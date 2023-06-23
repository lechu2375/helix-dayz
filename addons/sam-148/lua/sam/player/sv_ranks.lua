if SAM_LOADED then return end

local sam = sam
local SQL, Promise = sam.SQL, sam.Promise

function sam.player.set_rank(ply, rank, length)
	if sam.type(ply) ~= "Player" or not ply:IsValid() then
		error("invalid player")
	elseif not sam.ranks.is_rank(rank) then
		error("invalid rank")
	end

	if not sam.isnumber(length) or length < 0 then
		length = 0
	end

	local expiry_date = 0
	if length ~= 0 then
		if rank == "user" then
			expiry_date = 0
		else
			expiry_date = (math.min(length, 31536000) * 60) + os.time()
		end
	end

	ply:sam_start_rank_timer(expiry_date)

	SQL.FQuery([[
		UPDATE
			`sam_players`
		SET
			`rank` = {1},
			`expiry_date` = {2}
		WHERE
			`steamid` = {3}
	]], {rank, expiry_date, ply:SteamID()})

	local old_rank = ply:sam_getrank()
	ply:SetUserGroup(rank)
	ply:sam_setrank(rank)
	sam.hook_call("SAM.ChangedPlayerRank", ply, rank, old_rank, expiry_date)
end

do
	local set_rank_id = function(player_data, arguments)
		local old_rank = player_data and player_data.rank or false
		local promise, steamid, rank, length = unpack(arguments, 1, 4)

		local expiry_date = 0
		if length ~= 0 then
			if rank == "user" then
				expiry_date = 0
			else
				expiry_date = (math.min(length, 31536000) * 60) + os.time()
			end
		end

		local exists = true
		if old_rank == false then
			exists, old_rank = false, "user"

			local time = os.time()
			SQL.FQuery([[
				INSERT INTO
					`sam_players`(
						`steamid`,
						`name`,
						`rank`,
						`expiry_date`,
						`first_join`,
						`last_join`,
						`play_time`
					)
				VALUES
					({1}, {2}, {3}, {4}, {5}, {6}, {7})
			]], {steamid, "", rank, 0, time, time, 0})
		else
			SQL.FQuery([[
				UPDATE
					`sam_players`
				SET
					`rank` = {1},
					`expiry_date` = {2}
				WHERE
					`steamid` = {3}
			]], {rank, expiry_date, steamid})
		end

		promise:resolve()
		sam.hook_call("SAM.ChangedSteamIDRank", steamid, rank, old_rank, expiry_date, exists)
	end

	function sam.player.set_rank_id(steamid, rank, length)
		sam.is_steamid(steamid, true)

		if not sam.ranks.is_rank(rank) then
			error("invalid rank")
		end

		local promise = Promise.new()

		do
			local ply = player.GetBySteamID(steamid)
			if ply then
				promise:resolve(ply:sam_set_rank(rank, length))
				return promise
			end
		end

		if not sam.isnumber(length) or length < 0  then
			length = 0
		end

		SQL.FQuery([[
			SELECT
				`rank`
			FROM
				`sam_players`
			WHERE
				`steamid` = {1}
		]], {steamid}, set_rank_id, true, {promise, steamid, rank, length})

		return promise
	end
end

do
	local get_rank = function(data, callback)
		if not data then
			callback(false)
		else
			callback(data.rank)
		end
	end

	function sam.player.get_rank(steamid, callback)
		sam.is_steamid(steamid, true)

		SQL.FQuery([[
			SELECT
				`rank`
			FROM
				`sam_players`
			WHERE
				`steamid` = {1}
		]], {steamid}, get_rank, true, callback)
	end
end

do
	local remove_rank_timer = function(ply)
		timer.Remove("SAM.RankTimer." .. ply:SteamID())
	end

	function sam.player.start_rank_timer(ply, expiry_date)
		ply.sam_rank_expirydate = expiry_date
		if expiry_date == 0 then -- permanent rank
			return remove_rank_timer(ply)
		end
		expiry_date = expiry_date - os.time()
		timer.Create("SAM.RankTimer." .. ply:SteamID(), expiry_date, 1, function()
			sam.player.send_message(nil, "rank_expired", {
				T = {ply, admin = sam.console}, V = ply:sam_getrank()
			})
			ply:sam_set_rank("user")
		end)
	end

	hook.Add("PlayerDisconnected", "SAM.RemoveRankTimer", remove_rank_timer)
end

hook.Add("SAM.OnRankRemove", "ResetPlayerRank", function(name)
	for _, ply in ipairs(player.GetAll()) do
		if ply:sam_getrank() == name then
			ply:sam_set_rank("user")
		end
	end

	SQL.FQuery([[
		UPDATE
			`sam_players`
		SET
			`rank` = 'user',
			`expiry_date` = 0
		WHERE
			`rank` = {1}
	]], {name})
end)

hook.Add("SAM.RankNameChanged", "ChangePlayerRankName", function(old, new)
	for _, ply in ipairs(player.GetAll()) do
		if ply:sam_getrank() == old then
			ply:sam_set_rank(new)
		end
	end

	SQL.FQuery([[
		UPDATE
			`sam_players`
		SET
			`rank` = {1}
		WHERE
			`rank` = {2}
	]], {new, old})
end)