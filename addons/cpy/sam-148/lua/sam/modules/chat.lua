if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("Chat")

command.new("pm")
	:SetPermission("pm", "user")

	:AddArg("player", {allow_higher_target = true, single_target = true, cant_target_self = true})
	:AddArg("text", {hint = "message", check = function(str)
		return str:match("%S") ~= nil
	end})

	:GetRestArgs()

	:Help("pm_help")

	:OnExecute(function(ply, targets, message)
		if ply:sam_get_pdata("unmute_time") then
			return ply:sam_send_message("you_muted")
		end

		local target = targets[1]

		ply:sam_send_message("pm_to", {
			T = targets, V = message
		})

		if ply ~= target then
			target:sam_send_message("pm_from", {
				A = ply, V = message
			})
		end
	end)
:End()

do
	sam.permissions.add("see_admin_chat", nil, "admin")

	local reports_enabled = sam.config.get_updated("Reports", true)
	command.new("asay")
		:SetPermission("asay", "user")

		:AddArg("text", {hint = "message"})
		:GetRestArgs()

		:Help("asay_help")

		:OnExecute(function(ply, message)
			if reports_enabled.value and not ply:HasPermission("see_admin_chat") then
				local success, time = sam.player.report(ply, message)
				if success == false then
					ply:sam_send_message("You need to wait {S Red} seconds.", {
						S = time
					})
				else
					ply:sam_send_message("to_admins", {
						A = ply, V = message
					})
				end
				return
			end

			local targets = {ply}

			local players = player.GetHumans()
			for i = 1, #players do
				local v = players[i]
				if v:HasPermission("see_admin_chat") and v ~= ply then
					table.insert(targets, v)
				end
			end

			sam.player.send_message(targets, "to_admins", {
				A = ply, V = message
			})
		end)
	:End()

	if SERVER then
		sam.hook_last("PlayerSay", "SAM.Chat.Asay", function(ply, text)
			if text:sub(1, 1) == "@" then
				ply:Say("!asay " .. text:sub(2))
				return ""
			end
		end)
	end
end

do
	command.new("mute")
		:SetPermission("mute", "admin")

		:AddArg("player")
		:AddArg("length", {optional = true, default = 0, min = 0})
		:AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

		:GetRestArgs()

		:Help("mute_help")

		:OnExecute(function(ply, targets, length, reason)
			local current_time = SysTime()

			for i = 1, #targets do
				local target = targets[i]
				target:sam_set_pdata("unmute_time", length ~= 0 and (current_time + length * 60) or 0)
			end

			sam.player.send_message(nil, "mute", {
				A = ply, T = targets, V = sam.format_length(length), V_2 = reason
			})
		end)
	:End()

	command.new("unmute")
		:SetPermission("unmute", "admin")
		:AddArg("player", {optional = true})
		:Help("unmute_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				targets[i]:sam_set_pdata("unmute_time", nil)
			end

			sam.player.send_message(nil, "unmute", {
				A = ply, T = targets
			})
		end)
	:End()

	if SERVER then
		sam.hook_first("PlayerSay", "SAM.Chat.Mute", function(ply, text)
			local unmute_time = ply:sam_get_pdata("unmute_time")
			if not unmute_time then return end

			if text:sub(1, 1) == "!" and text:sub(2, 2):match("%S") ~= nil then
				local args = sam.parse_args(text:sub(2))

				local cmd_name = args[1]
				if not cmd_name then return end

				local cmd = command.get_command(cmd_name)
				if cmd then
					return
				end
			end

			if unmute_time == 0 or unmute_time > SysTime() then
				return ""
			else
				ply:sam_set_pdata("unmute_time", nil)
			end
		end)
	end
end

do
	command.new("gag")
		:SetPermission("gag", "admin")

		:AddArg("player")
		:AddArg("length", {optional = true, default = 0, min = 0})
		:AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

		:GetRestArgs()

		:Help("gag_help")

		:OnExecute(function(ply, targets, length, reason)
			for i = 1, #targets do
				local target = targets[i]
				target.sam_gagged = true
				if length ~= 0 then
					timer.Create("SAM.UnGag" .. target:SteamID64(), length * 60, 1, function()
						RunConsoleCommand("sam", "ungag", "#" .. target:EntIndex())
					end)
				end
			end

			sam.player.send_message(nil, "gag", {
				A = ply, T = targets, V = sam.format_length(length), V_2 = reason
			})
		end)
	:End()

	command.new("ungag")
		:SetPermission("ungag", "admin")

		:AddArg("player", {optional = true})
		:Help("ungag_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				local target = targets[i]
				target.sam_gagged = nil
				timer.Remove("SAM.UnGag" .. target:SteamID64())
			end

			sam.player.send_message(nil, "ungag", {
				A = ply, T = targets
			})
		end)
	:End()

	if SERVER then
		hook.Add("PlayerCanHearPlayersVoice", "SAM.Chat.Gag", function(_, ply)
			if ply.sam_gagged then
				return false
			end
		end)

		hook.Add("PlayerInitialSpawn", "SAM.Gag", function(ply)
			local gag_time = ply:sam_get_pdata("gagged")
			if gag_time then
				ply:sam_set_pdata("gagged", nil)
				RunConsoleCommand("sam", "gag", "#" .. ply:EntIndex(), gag_time / 60, "LTAP")
			end
		end)

		hook.Add("PlayerDisconnected", "SAM.Gag", function(ply)
			if ply.sam_gagged then
				ply:sam_set_pdata("gagged", timer.TimeLeft("SAM.UnGag" .. ply:SteamID64()) or 0)
			end
		end)
	end
end