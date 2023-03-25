if SAM_LOADED then return end

local sam = sam
local SQL = sam.SQL

local DEFAULT_REASON = sam.language.get("default_reason")

local set_cached, get_cached do
	local cached_bans = {}
	function set_cached(k, v)
		cached_bans[k] = v
	end
	function get_cached(k)
		return cached_bans[k]
	end
	timer.Create("SAM.ClearCachedBans", 60 * 2.5, 0, function()
		table.Empty(cached_bans)
	end)
end

function sam.format_ban_message(admin_name, admin_steamid, reason, unban_date)
	unban_date = unban_date == 0 and "never" or sam.format_length((unban_date - os.time()) / 60)

	local message_tbl
	if admin_name == "" then
		message_tbl = sam.format_message("ban_message", {
			S = admin_steamid, S_2 = reason, S_3 = unban_date
		})
	else
		message_tbl = sam.format_message("ban_message_2", {
			S = admin_name, S_2 = admin_steamid, S_3 = reason, S_4 = unban_date
		})
	end

	local message = ""
	for i = 1, #message_tbl do
		local v = message_tbl[i]
		if sam.isstring(v) then
			message = message .. v
		end
	end

	return message
end

function sam.player.ban(ply, length, reason, admin_steamid)
	if sam.type(ply) ~= "Player" or not ply:IsValid() then
		error("invalid player")
	end

	if ply.sam_is_banned then return end

	local unban_date
	if not sam.isnumber(length) or length <= 0 then
		unban_date = 0
	else
		unban_date = (math.min(length, 31536000) * 60) + os.time()
	end

	if not sam.isstring(reason) then
		reason = DEFAULT_REASON
	end

	if ply:IsBot() then -- you can't ban bots!
		return ply:Kick(reason)
	end

	if not sam.is_steamid(admin_steamid) then -- 69461840312350aef64d3194a3ec7e443cc23037809e57efb1de5f58d3f78f4c
		admin_steamid = "Console"
	end

	local steamid = ply:SteamID()

	SQL.FQuery([[
		INSERT INTO
			`sam_bans`(
				`steamid`,
				`reason`,
				`admin`,
				`unban_date`
			)
		VALUES
			({1}, {2}, {3}, {4})
	]], {steamid, reason, admin_steamid, unban_date})

	local admin_name = ""
	do
		local admin = player.GetBySteamID(admin_steamid)
		if admin then
			admin_name = admin:Name()
		end
	end

	ply.sam_is_banned = true
	set_cached(steamid, nil)
	sam.hook_call("SAM.BannedPlayer", ply, unban_date, reason, admin_steamid)
	ply:Kick(sam.format_ban_message(admin_name, admin_steamid, reason, unban_date))
end

function sam.player.ban_id(steamid, length, reason, admin_steamid)
	sam.is_steamid(steamid, true)

	do
		local ply = player.GetBySteamID(steamid)
		if ply then
			return ply:sam_ban(length, reason, admin_steamid)
		end
	end

	local unban_date
	if not sam.isnumber(length) or length <= 0 then
		unban_date = 0
	else
		unban_date = (math.min(length, 31536000) * 60) + os.time()
	end

	if not sam.isstring(reason) then
		reason = DEFAULT_REASON
	end

	local query
	if SQL.IsMySQL() then
		query = [[
			INSERT INTO
				`sam_bans`(
					`steamid`,
					`reason`,
					`admin`,
					`unban_date`
				)
			VALUES
				({1}, {2}, {3}, {4}) ON DUPLICATE KEY
			UPDATE
				`reason` = VALUES(`reason`),
				`admin` = VALUES(`admin`),
				`unban_date` = VALUES(`unban_date`)
		]]
	else
		query = [[
			INSERT INTO
				`sam_bans`(
					`steamid`,
					`reason`,
					`admin`,
					`unban_date`
				)
			VALUES
				({1}, {2}, {3}, {4}) ON CONFLICT(`steamid`) DO
			UPDATE SET
				`reason` = excluded.`reason`,
				`admin` = excluded.`admin`,
				`unban_date` = excluded.`unban_date`
		]]
	end

	SQL.FQuery(query, {steamid, reason, admin_steamid, unban_date})

	local admin_name = ""
	if sam.is_steamid(admin_steamid) then
		local admin = player.GetBySteamID(admin_steamid)
		if admin then
			admin_name = admin:Name()
		end
	else
		admin_steamid = "Console"
	end

	set_cached(steamid, nil)
	sam.hook_call("SAM.BannedSteamID", steamid, unban_date, reason, admin_steamid)
	sam.player.kick_id(steamid, sam.format_ban_message(admin_name, admin_steamid, reason, unban_date))
end

function sam.player.unban(steamid, admin)
	sam.is_steamid(steamid, true)

	if not sam.is_steamid(admin) then
		admin = "Console"
	end

	SQL.FQuery([[
		DELETE FROM
			`sam_bans`
		WHERE
			`steamid` = {1}
	]], {steamid})

	set_cached(steamid, false)
	sam.hook_call("SAM.UnbannedSteamID", steamid, admin)
end

local check_for_unban = function(steamid, ban_data, callback)
	local to_return = ban_data

	local unban_date = tonumber(ban_data.unban_date)
	if unban_date ~= 0 and os.time() >= unban_date then
		to_return = false
		sam.player.unban(steamid)
	end

	if callback then
		callback(to_return, steamid)
	else
		return to_return
	end
end

do
	local query_callback = function(data, arguments)
		local steamid, callback = arguments[1], arguments[2]
		if data then
			set_cached(steamid, data)
			check_for_unban(steamid, data, callback)
		else
			set_cached(steamid, false)
			callback(false, steamid)
		end
	end

	function sam.player.is_banned(steamid, callback)
		sam.is_steamid(steamid, true)

		local ban_data = get_cached(steamid)
		if ban_data then
			check_for_unban(steamid, ban_data, callback)
		elseif ban_data == false then
			callback(false, steamid)
		else
			local query = [[
				SELECT
					`sam_bans`.`steamid`,
					`sam_bans`.`reason`,
					`sam_bans`.`admin`,
					`sam_bans`.`unban_date`,
					IFNULL(`sam_players`.`name`, '') AS `admin_name`
				FROM
					`sam_bans`
				LEFT OUTER JOIN
					`sam_players`
				ON
					`sam_bans`.`admin` = `sam_players`.`steamid`
				WHERE
					`sam_bans`.`steamid` = ]] .. SQL.Escape(steamid)

			SQL.Query(query, query_callback, true, {steamid, callback})
		end
	end
end

do
	local steamids = {}

	local query_callback = function(ban_data, steamid)
		steamids[steamid] = nil

		if ban_data then
			sam.player.kick_id(steamid, sam.format_ban_message(ban_data.admin_name, ban_data.admin, ban_data.reason, tonumber(ban_data.unban_date)))
		end
	end

	gameevent.Listen("player_connect")
	hook.Add("player_connect", "SAM.CheckIfBanned", function(data)
		local steamid = data.networkid
		if data.bot == 0 and not steamids[steamid] then
			steamids[steamid] = true
			sam.player.is_banned(steamid, query_callback)
		end
	end)

	hook.Add("CheckPassword", "SAM.CheckIfBanned", function(steamid64)
		local steamid = util.SteamIDFrom64(steamid64)
		local ban_data = get_cached(steamid)
		if not ban_data then return end

		ban_data = check_for_unban(steamid, ban_data)
		if not ban_data then return end

		return false, sam.format_ban_message(ban_data.admin_name, ban_data.admin, ban_data.reason, tonumber(ban_data.unban_date))
	end)
end

sam.player.ban_set_cached, sam.player.ban_get_cached = set_cached, get_cached