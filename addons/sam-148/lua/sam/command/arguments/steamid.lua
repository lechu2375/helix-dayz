if SAM_LOADED then return end

local sam, command = sam, sam.command

local cached_ranks = {}
local targeting_offline = {}

local check_steamid = function(steamid)
	if not sam.is_steamid(steamid) then
		if sam.is_steamid64(steamid) then
			return util.SteamIDFrom64(steamid)
		else
			return nil
		end
	end

	return steamid
end

local can_target_steamid_callback = function(data, promise)
	local ply, steamid = promise.ply, promise.steamid

	if not data or sam.ranks.can_target(promise.rank, data.rank) then
		promise:resolve({steamid})
	elseif IsValid(ply) then
		ply:sam_send_message("cant_target_player", {
			S = steamid
		})
	end

	targeting_offline[ply] = nil
	cached_ranks[steamid] = data ~= nil and data or false
end

command.new_argument("steamid")
	:OnExecute(function(argument, input, ply, _, result, i)
		local steamid = check_steamid(input)
		if not steamid then
			ply:sam_send_message("invalid", {
				S = "steamid/steamid64", S_2 = input
			})
			return false
		end

		if argument.allow_higher_target then
			result[i] = steamid
			return
		end

		local promise = sam.Promise.new()
		promise.ply = ply
		promise.rank = ply:sam_getrank()
		promise.steamid = steamid

		local target = player.GetBySteamID(steamid)
		if sam.isconsole(ply) then
			promise:resolve({steamid})
		elseif target then
			if ply:CanTarget(target) then
				promise:resolve({steamid, target})
			else
				ply:sam_send_message("cant_target_player", {
					S = steamid
				})
			end
		elseif cached_ranks[steamid] ~= nil then
			can_target_steamid_callback(cached_ranks[steamid], promise)
		else
			targeting_offline[ply] = true

			sam.SQL.FQuery([[
				SELECT
					`rank`
				FROM
					`sam_players`
				WHERE
					`steamid` = {1}
			]], {steamid}, can_target_steamid_callback, true, promise)
		end

		result[i] = promise
	end)
	:Menu(function(set_result, body, buttons, argument)
		local steamid_entry = buttons:Add("SAM.TextEntry")
		steamid_entry:SetTall(25)
		steamid_entry:SetUpdateOnType(true)
		steamid_entry:SetPlaceholder("steamid/steamid64")

		steamid_entry:SetCheck(function(steamid)
			steamid = check_steamid(steamid)
			set_result(steamid)
			return steamid or false
		end)

		return steamid_entry
	end)
:End()

timer.Create("SAM.ClearCachedRanks", 60 * 2.5, 0, function()
	table.Empty(cached_ranks)
end)

hook.Add("SAM.ChangedSteamIDRank", "RemoveIfCached", function(steamid)
	cached_ranks[steamid] = nil
end)

hook.Add("SAM.CanRunCommand", "StopIfTargetingOffline", function(ply)
	if targeting_offline[ply] then
		return false
	end
end)