if SAM_LOADED then return end

local sam, SQL = sam, sam.SQL

local auth_player = function(data, ply)
	if not ply:IsValid() then return end
	if ply:sam_get_nwvar("is_authed") then return end

	local steamid = ply:SteamID()

	local rank, expiry_date, play_time
	local first_join = false
	if data then
		rank, expiry_date, play_time = data.rank, tonumber(data.expiry_date), tonumber(data.play_time)

		SQL.FQuery([[
			UPDATE
				`sam_players`
			SET
				`name` = {1},
				`last_join` = {2}
			WHERE
				`steamid` = {3}
		]], {ply:Name(), os.time(), steamid})
	else
		rank, expiry_date, play_time = "user", 0, 0
		first_join = true

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
		]], {steamid, ply:Name(), rank, 0, time, time, 0})
	end

	ply:SetUserGroup(rank)
	ply:sam_setrank(rank)
	ply:sam_start_rank_timer(expiry_date)

	ply:sam_set_nwvar("join_time", os.time())
	ply:sam_set_nwvar("play_time", play_time)
	ply:sam_set_nwvar("is_authed", true)

	hook.Call("SAM.AuthedPlayer", nil, ply, steamid, first_join)

	timer.Simple(0, function()
		if IsValid(ply) then
			sam.client_hook_call("SAM.AuthedPlayer", ply, steamid, first_join)
		end
	end)
end
hook.Add("PlayerInitialSpawn", "SAM.AuthPlayer", function(ply)
	SQL.FQuery([[
		SELECT
			`rank`,
			`expiry_date`,
			`play_time`
		FROM
			`sam_players`
		WHERE
			`steamid` = {1}
	]], {ply:SteamID()}, auth_player, true, ply)
end)
sam.player.auth = auth_player

hook.Add("SAM.AuthedPlayer", "SetSuperadminToListenServer", function(ply)
	if game.SinglePlayer() or ply:IsListenServerHost() then
		ply:sam_set_rank("superadmin")
	end
end)

hook.Add("SAM.AuthedPlayer", "CheckIfFullyAuthenticated", function(ply)
	timer.Simple(0, function()
		if not IsValid(ply) then return end
		if ply:IsBot() then return end
		if not ply.IsFullyAuthenticated or ply:IsFullyAuthenticated() then return end
		if game.SinglePlayer() or ply:IsListenServerHost() then return end

		ply:Kick("Your SteamID wasn't fully authenticated, try restarting steam.")
	end)
end)

do
	local format = string.format
	local floor = math.floor
	local SysTime = SysTime
	local last_save = SysTime()

	local save_play_time = function(ply)
		if not ply:sam_get_nwvar("is_authed") then return end

		local query = format([[
			UPDATE
				`sam_players`
			SET
				`play_time` = %u
			WHERE
				`steamid` = '%s'
		]], floor(ply:sam_get_play_time()), ply:SteamID())
		SQL.Query(query)
	end

	hook.Add("Think", "SAM.Player.SaveTimes", function()
		if SysTime() - last_save < 60 then return end

		SQL.Begin()
		local players = player.GetHumans()
		for i = 1, #players do
			save_play_time(players[i])
		end
		SQL.Commit()

		sam.hook_call("SAM.UpdatedPlayTimes")

		last_save = SysTime()
	end)

	hook.Add("PlayerDisconnected", "SAM.Player.SaveTime", save_play_time)
end