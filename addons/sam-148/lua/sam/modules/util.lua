if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("Utility")

command.new("map")
	:SetPermission("map", "admin")

	:AddArg("map")
	:AddArg("text", {hint = "gamemode", optional = true, check = sam.is_valid_gamemode})

	:Help("map_help")

	:OnExecute(function(ply, map, gamemode)
		if not gamemode then
			sam.player.send_message(nil, "map_change", {
				A = ply, V = map
			})
		else
			sam.player.send_message(nil, "map_change2", {
				A = ply, V = map, V_2 = gamemode
			})
			RunConsoleCommand("gamemode", gamemode)
		end

		if #player.GetHumans() == 0 then
			RunConsoleCommand("changelevel", map)
		else
			timer.Create("SAM.Command.Map", 10, 1, function()
				RunConsoleCommand("changelevel", map)
			end)
		end
	end)
:End()

command.new("maprestart")
	:SetPermission("maprestart", "admin")

	:Help("map_restart_help")

	:OnExecute(function(ply)
		if #player.GetHumans() == 0 then
			RunConsoleCommand("changelevel", game.GetMap())
		else
			timer.Create("SAM.Command.MapRestart", 10, 1, function()
				RunConsoleCommand("changelevel", game.GetMap())
			end)

			sam.player.send_message(nil, "map_restart", {
				A = ply
			})
		end
	end)
:End()

command.new("mapreset")
	:SetPermission("mapreset", "admin")

	:Help("mapreset_help")

	:OnExecute(function(ply)
		game.CleanUpMap()

		sam.player.send_message(nil, "mapreset", {
			A = ply
		})
	end)
:End()

command.new("kick")
	:SetPermission("kick", "admin")

	:AddArg("player", {single_target = true})
	:AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

	:GetRestArgs()

	:Help("kick_help")

	:OnExecute(function(ply, targets, reason)
		local target = targets[1]
		target:Kick(reason)

		sam.player.send_message(nil, "kick", {
			A = ply, T = target:Name(), V = reason
		})
	end)
:End()

command.new("ban")
	:SetPermission("ban", "admin")

	:AddArg("player", {single_target = true})
	:AddArg("length", {optional = true, default = 0})
	:AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

	:GetRestArgs()

	:Help("ban_help")

	:OnExecute(function(ply, targets, length, reason)
		local target = targets[1]
		if ply:GetBanLimit() ~= 0 then
			if length == 0 then
				length = ply:GetBanLimit()
			else
				length = math.Clamp(length, 1, ply:GetBanLimit())
			end
		end
		target:sam_ban(length, reason, ply:SteamID())

		sam.player.send_message(nil, "ban", {
			A = ply, T = target:Name(), V = sam.format_length(length), V_2 = reason
		})
	end)
:End()

command.new("banid")
	:SetPermission("banid", "admin")

	:AddArg("steamid")
	:AddArg("length", {optional = true, default = 0})
	:AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

	:GetRestArgs()

	:Help("banid_help")

	:OnExecute(function(ply, promise, length, reason)
		local a_steamid, a_name, a_ban_limit = ply:SteamID(), ply:Name(), ply:GetBanLimit()

		promise:done(function(data)
			local steamid, target = data[1], data[2]

			if a_ban_limit ~= 0 then
				if length == 0 then
					length = a_ban_limit
				else
					length = math.Clamp(length, 1, a_ban_limit)
				end
			end

			if target then
				target:sam_ban(length, reason, a_steamid)

				sam.player.send_message(nil, "ban", {
					A = a_name, T = target:Name(), V = sam.format_length(length), V_2 = reason
				})
			else
				sam.player.ban_id(steamid, length, reason, a_steamid)

				sam.player.send_message(nil, "banid", {
					A = a_name, T = steamid, V = sam.format_length(length), V_2 = reason
				})
			end
		end)
	end)
:End()

command.new("unban")
	:SetPermission("unban", "admin")

	:AddArg("steamid", {allow_higher_target = true})

	:Help("unban_help")

	:OnExecute(function(ply, steamid, reason)
		sam.player.unban(steamid, ply:SteamID())

		sam.player.send_message(nil, "unban", {
			A = ply, T = steamid
		})
	end)
:End()

do
	command.new("noclip")
		:SetPermission("noclip", "admin")

		:AddArg("player", {optional = true})

		:Help("noclip_help")

		:OnExecute(function(ply, targets)
			local id
			for i = 1, #targets do
				local v = targets[i]
				v:SetMoveType(v:GetMoveType() == MOVETYPE_WALK and MOVETYPE_NOCLIP or MOVETYPE_WALK)
				if v == ply then
					id = i
				end
			end

			if id then
				table.remove(targets, id)
				if #targets == 0 then return end
			end

			sam.player.send_message(nil, "noclip", {
				A = ply, T = targets
			})
		end)
	:End()

	sam.permissions.add("can_noclip", nil, "admin")

	hook.Add("PlayerNoClip", "SAM.CanNoClip", function(ply)
		if ply:HasPermission("can_noclip") then
			return true
		end
	end)
end

do
	local config = sam.config

	sam.permissions.add("can_physgun_players", nil, "admin")

	if CLIENT then
		local add_setting = function(body, title, key)
			local setting = body:Add("SAM.LabelPanel")
			setting:Dock(TOP)
			setting:SetLabel(title)

			local enable = setting:Add("SAM.ToggleButton")
			enable:SetConfig(key, true)

			return setting
		end

		config.add_menu_setting("Physgun", function(body)
			local setting_body

			do
				local p = add_setting(body, "Physgun (Enable/Disable all physgun features except picking up players)", "Physgun.Enabled")
				p:DockMargin(8, 6, 8, 0)
			end

			setting_body = body:Add("Panel")
			setting_body:Dock(TOP)
			setting_body:DockMargin(8, 6, 8, 0)
			setting_body:DockPadding(8, 0, 8, 0)

			add_setting(setting_body, "No fall damage on drop", "Physgun.NoFallDamageOnDrop")
			add_setting(setting_body, "Right click to freeze players", "Physgun.RightClickToFreeze")
			add_setting(setting_body, "Reset Velocity to fix some issues when players fall", "Physgun.ResetVelocity")

			function setting_body:PerformLayout()
				setting_body:SizeToChildren(false, true)
			end
		end)
	end

	local freeze_player = function(ply)
		if SERVER then
			ply:Lock()
		end
		ply:SetMoveType(MOVETYPE_NONE)
		ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end

	sam.hook_first("PhysgunPickup", "SAM.CanPhysgunPlayer", function(ply, target)
		if sam.type(target) == "Player" and ply:HasPermission("can_physgun_players") and ply:CanTarget(target) then
			freeze_player(target)
			return true
		end
	end)

	local load_phygun_settings = function()
		hook.Remove("PhysgunDrop", "SAM.PhysgunDrop")
		hook.Remove("OnPlayerHitGround", "SAM.PhysgunDropOnPlayerHitGround")

		if config.get("Physgun.Enabled", true) == false then
			return
		end

		local right_click_to_freeze = config.get("Physgun.RightClickToFreeze", true)
		local reset_velocity = config.get("Physgun.ResetVelocity", true)
		hook.Add("PhysgunDrop", "SAM.PhysgunDrop", function(ply, target)
			if sam.type(target) ~= "Player" then return end

			if right_click_to_freeze and ply:KeyPressed(IN_ATTACK2) then
				freeze_player(target)

				if SERVER then
					target:sam_set_nwvar("frozen", true)
					target:sam_set_exclusive("frozen")
				end
			else
				if reset_velocity then
					target:SetLocalVelocity(Vector(0, 0, 0))
				end

				if SERVER then
					target:UnLock()
					target:sam_set_nwvar("frozen", false)
					target:sam_set_exclusive(nil)

					if target.sam_has_god_mode then
						target:GodEnable()
					end

					target.sam_physgun_drop_was_frozen = not target:IsOnGround()
				end

				target:SetMoveType(MOVETYPE_WALK)
				target:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			end
		end)

		if config.get("Physgun.NoFallDamageOnDrop", true) then
			hook.Add("OnPlayerHitGround", "SAM.PhysgunDropOnPlayerHitGround", function(ply)
				if ply.sam_physgun_drop_was_frozen then
					ply.sam_physgun_drop_was_frozen = false
					return true
				end
			end)
		end
	end

	config.hook({"Physgun.Enabled", "Physgun.RightClickToFreeze", "Physgun.ResetVelocity", "Physgun.NoFallDamageOnDrop"}, load_phygun_settings)
end

do
	command.new("cleardecals")
		:SetPermission("cleardecals", "admin")
		:Help("cleardecals_help")

		:OnExecute(function(ply)
			sam.netstream.Start(nil, "cleardecals")

			sam.player.send_message(nil, "cleardecals", {
				A = ply
			})
		end)
	:End()

	if CLIENT then
		sam.netstream.Hook("cleardecals", function()
			game.RemoveRagdolls()
			RunConsoleCommand("r_cleardecals")
		end)
	end
end

do
	command.new("stopsound")
		:SetPermission("stopsound", "admin")
		:Help("stopsound_help")

		:OnExecute(function(ply)
			sam.netstream.Start(nil, "stopsound")

			sam.player.send_message(nil, "stopsound", {
				A = ply
			})
		end)
	:End()

	if CLIENT then
		sam.netstream.Hook("stopsound", function()
			RunConsoleCommand("stopsound")
		end)
	end
end

command.new("exit")
	:SetPermission("exit_vehicle", "admin")

	:AddArg("player", {single_target = true})

	:Help("exit_vehicle_help")

	:OnExecute(function(ply, targets)
		local target = targets[1]

		if not target:InVehicle() then
			if ply == target then
				return ply:sam_send_message("not_in_vehicle")
			else
				return ply:sam_send_message("not_in_vehicle2", {
					S = target:Name()
				})
			end
		end

		target:ExitVehicle()

		sam.player.send_message(nil, "exit_vehicle", {
			A = ply, T = targets
		})
	end)
:End()

command.new("time")
	:SetPermission("time", "user")

	:AddArg("player", {single_target = true, optional = true})

	:Help("time_help")

	:OnExecute(function(ply, targets)
		if ply == targets[1] then
			sam.player.send_message(ply, "time_your", {
				V = sam.reverse_parse_length(targets[1]:sam_get_play_time() / 60)
			})
		else
			sam.player.send_message(ply, "time_player", {
				T = targets, V = sam.reverse_parse_length(targets[1]:sam_get_play_time() / 60)
			})
		end
	end)
:End()

command.new("admin")
	:SetPermission("admin_mode", "admin")

	:Help("admin_help")

	:OnExecute(function(ply)
		ply:sam_cloak()
		ply:GodEnable()
		ply:SetMoveType(MOVETYPE_NOCLIP)
	end)
:End()

command.new("unadmin")
	:SetPermission("admin_mode", "admin")

	:Help("unadmin_help")

	:OnExecute(function(ply)
		ply:sam_uncloak()
		ply:GodDisable()
		ply:SetMoveType(MOVETYPE_WALK)
	end)
:End()

do
	command.new("buddha")
		:SetPermission("buddha", "admin")

		:AddArg("player", {optional = true})

		:Help("buddha_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				targets[i].sam_buddha = true
			end

			sam.player.send_message(nil, "buddha", {
				A = ply, T = targets
			})
		end)
	:End()

	command.new("unbuddha")
		:SetPermission("buddha", "admin")

		:AddArg("player", {optional = true})

		:Help("unbuddha_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				targets[i].sam_buddha = nil
			end

			sam.player.send_message(nil, "unbuddha", {
				A = ply, T = targets
			})
		end)
	:End()

	if SERVER then
		hook.Add("EntityTakeDamage", "SAM.BuddhaMode", function(ply, info)
			if ply.sam_buddha and ply:Health() - info:GetDamage() <= 0 then
				ply:SetHealth(1)
				return true
			end
		end)
	end
end

command.new("give")
	:SetPermission("give", "superadmin")

	:AddArg("player")
	:AddArg("text", {hint = "weapon/entity"})

	:Help("give_help")

	:OnExecute(function(ply, targets, weapon)
		for i = 1, #targets do
			targets[i]:Give(weapon)
		end

		sam.player.send_message(nil, "give", {
			A = ply, T = targets, V = weapon
		})
	end)
:End()

-- do
-- 	if CLIENT then
-- 		sam.netstream.Hook("GetFriends", function()
-- 			local friends = {}
-- 			local humans = player.GetHumans()
-- 			for i = 1, #humans do
-- 				local human = humans[i]
-- 				if human:GetFriendStatus() == "friend" then
-- 					table.insert(friends, human)
-- 				end
-- 			end
-- 			netstream.Start("GetFriends", friends)
-- 		end)
-- 	else
-- 		hook.Add("SAM.AuthedPlayer", "GetPlayerFriends", function(ply)
-- 			timer.Simple(0, function()
-- 				ply.sam_requesting_friends = true
-- 				netstream.Start(ply, "GetFriends")
-- 			end)
-- 		end)

-- 		local invalid_friends = function(ply, friends, new_list)
-- 			if not sam.istable(friends) then return true end

-- 			local count = #friends
-- 			local max_players = game.MaxPlayers()
-- 			for k, friend in pairs(friends) do
-- 				if not sam.isnumber(k) then return true end
-- 				if not sam.isentity(friend) then return true end
-- 				if k > max_players then return true end
-- 				if k > count then return true end

-- 				if IsValid(friend) then
-- 					table.insert(new_list, friend)
-- 				end
-- 			end
-- 		end

-- 		sam.netstream.Hook("GetFriends", function(ply, friends)
-- 			local new_list = {}
-- 			if invalid_friends(ply, friends, new_list) then
-- 				ply.sam_friends_invalid = true
-- 				return
-- 			end
-- 			ply.sam_friends = new_list
-- 		end, function()
-- 			return ply.sam_requesting_friends
-- 		end)
-- 	end

-- 	command.new("friends")
-- 		:SetPermission("friends", "superadmin")

-- 		:AddArg("player", {single_target = true})

-- 		:Help(language.get("friends_help"))

-- 		:OnExecute(function(ply, targets)
-- 			local target = targets[1]
-- 			target.sam_friends_requests = target.sam_friends_requests or {}
-- 			target.sam_friends_requests[ply] = true
-- 		end)
-- 	:End()
-- end