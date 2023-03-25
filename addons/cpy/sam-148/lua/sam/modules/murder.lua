if SAM_LOADED then return end

local add = not GAMEMODE and hook.Add or function(_, _, fn)
	fn()
end

-- Thanks to https://github.com/boxama/addons/blob/master/addons/ULX_Murder/lua/ulx/modules/sh/murder.lua
add("PostGamemodeLoaded", "SAM.Murder", function()
	if GAMEMODE.Author ~= "MechanicalMind" then return end
	if not isstring(GAMEMODE.Version) or GAMEMODE.Version < "28" then return end

	local sam, command = sam, sam.command

	command.set_category("Murder")

	local autoslain_players = {}

	command.new("slaynr")
		:SetPermission("slaynr", "admin")

		:AddArg("player")
		:AddArg("number", {hint = "rounds", optional = true, default = 1, min = 1, max = 100, round = true})

		:Help("Slays the target(s) at the beggining of the next round.")

		:OnExecute(function(ply, targets, rounds)
			for i = 1, #targets do
				local v = targets[i]
				v.MurdererChance = 0

				if not v:IsBot() then
					autoslain_players[v:AccountID()] = rounds
				end
			end

			sam.player.send_message(nil, "{A} set {T} to be autoslain for {V} round(s)", {
				A = ply, T = targets, V = rounds
			})
		end)
	:End()

	command.new("unslaynr")
		:SetPermission("unslaynr", "admin")

		:AddArg("player")

		:Help("Remove target(s) autoslays.")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				local v = targets[i]
				v.MurdererChance = 1

				if not v:IsBot() then
					autoslain_players[v:AccountID()] = nil
				end
			end

			sam.player.send_message(nil, "Removed all autoslays for {T} ", {
				A = ply, T = targets
			})
		end)
	:End()

	hook.Add("OnStartRound", "SAM.Murder", function()
		timer.Simple(3, function()
			local players = team.GetPlayers(2)
			local targets = {admin = sam.console}
			for i = 1, #players do
				local v = players[i]
				if not v:IsBot() then continue end

				local slays = autoslain_players[v:AccountID()]
				if not slays then continue end

				v:Kill()

				slays = slays - 1

				targets[1] = v
				sam.player.send_message(nil, "{A} autoslayed {T}, autoslays left: {V}.", {
					A = sam.console, T = targets, V = slays
				})

				autoslain_players[v:AccountID()] = slays > 0 and slays or nil
			end
		end)
	end)

	hook.Add("PlayerInitialSpawn", "SAM.Murder", function(ply)
		if autoslain_players[ply:AccountID()] then
			ply.MurdererChance = 0
		end
	end)

	command.new("respawn")
		:SetPermission("respawn", "admin")

		:AddArg("player", {single_target = true})

		:Help("Respawn a target.")

		:OnExecute(function(ply, targets)
			local target = targets[1]

			if target:Team() ~= 2 then
				return ply:sam_add_text("You cannot respawn a spectator!")
			end

			target:Spectate(OBS_MODE_NONE)
			target:Spawn()

			sam.player.send_message(nil, "respawn", {
				A = ply, T = targets
			})
		end)
	:End()

	local get_admins = function()
		local admins = {}

		local players = player.GetHumans()
		for i = 1, #players do
			local v = players[i]
			if v:IsAdmin() then
				table.insert(admins, v)
			end
		end

		return admins
	end

	command.new("givemagnum")
		:SetPermission("givemagnum", "superadmin")

		:AddArg("player", {single_target = true, optional = true})

		:Help("Give the target a magnum.")

		:OnExecute(function(ply, targets)
			local target = targets[1]

			if target:Team() ~= 2 then
				return ply:sam_add_text("You cannot give spectator a magnum!")
			end

			target:Give("weapon_mu_magnum")

			sam.player.send_message(get_admins(), "{A} gave {T} a {V}", {
				A = ply, T = targets, V = "magnum"
			})
		end)
	:End()

	command.new("giveknife")
		:SetPermission("giveknife", "superadmin")

		:AddArg("player", {single_target = true, optional = true})

		:Help("Give the target a knife.")

		:OnExecute(function(ply, targets)
			local target = targets[1]

			if target:Team() ~= 2 then
				return ply:sam_add_text("You cannot give spectator a knife!")
			end

			target:Give("weapon_mu_knife")

			sam.player.send_message(get_admins(), "{A} gave {T} a {V}", {
				A = ply, T = targets, V = "knife"
			})
		end)
	:End()

	command.new("forcemurderer")
		:SetPermission("forcemurderer", "admin")

		:AddArg("player", {single_target = true, optional = true})

		:Help("Force the target to me a murderer next round.")

		:OnExecute(function(ply, targets)
			GAMEMODE.ForceNextMurderer = targets[1]

			sam.player.send_message(get_admins(), "{A} set {T} to be the Murderer next round!", {
				A = ply, T = targets
			})
		end)
	:End()

	command.new("getmurderers")
		:SetPermission("getmurderers", "admin")

		:Help("Print all murderers in chat.")

		:OnExecute(function(ply)
			local murderers = {admin = ply}

			local players = team.GetPlayers(2)
			for i = 1, #players do
				local v = players[i]
				if v:GetMurderer() then
					table.insert(murderers, v)
				end
			end

			sam.player.send_message(ply, "Murderers are: {T}", {
				T = murderers
			})
		end)
	:End()
end)