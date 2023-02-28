PLUGIN.name = "Chat Channels"
PLUGIN.author = "STEAM_0:1:29606990"
PLUGIN.description = ""

do
	CAMI.RegisterPrivilege({
		Name = "Helix - Bypass TradeChat Timer",
		MinAccess = "admin"
	})

	ix.config.Add("tradeChatDelay", 60, "Odstęp przed kolejnym wysłaniem wiadomości w oknie handlu", nil, {
		data = {min = 0, max = 10000},
		category = "chat"
	})

	if (CLIENT) then
		function ix.chat.GetPlayerIcon(speaker)
			local icon = ""

			if (speaker:IsSuperAdmin()) then
				icon = "icon16/shield.png"
			elseif (speaker:IsAdmin()) then
				icon = "icon16/star.png"
			elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
				icon = "icon16/wrench.png"
			elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
				icon = "icon16/heart.png"
			end

			return hook.Run("GetPlayerIcon", speaker) or icon
		end
	end
end

if (CLIENT) then
	function PLUGIN:InitializedPlugins()
		if (IX_RELOADED) then
			hook.Run("InitializedChatClasses")
		end
	end
end

function PLUGIN:InitializedChatClasses()
	local clr_gray = ix.color.Darken(color_white, 100)



	ix.chat.classes["pm"].deadCanChat = nil

	ix.chat.Register("y", {
		indicator = "chatTalking",
		OnChatAdd = function(self, speaker, text)
			local name = IsValid(speaker) and speaker:GetCharacter():GetName() or "Console"
			local name_color = IsValid(speaker) and hook.Run("GetPlayerColorSB", speaker) or clr_gray
			local icon = IsValid(speaker) and ix.chat.GetPlayerIcon(speaker) or ""
			local flag = ix.geoip:GetMaterial(speaker, false) or ""

			if (#icon > 0) then
				icon = ix.util.GetMaterial(icon)
			end

			chat.AddText(Color(0, 150, 255), L"yellChatPrefix", icon, flag, name_color, name .. ": ", color_white, text)
		end,
		CanHear = ix.config.Get("chatRange", 280)*2,
		noSpaceAfter = true,
		format = "%s yells \"%s\"",
		CanHear = ix.config.Get("chatRange", 280) * 2,
		prefix = {"/Y", "/Yell"},
		description = "@cmdY",
		indicator = "chatYelling",
		font  = "ixBigFont"
	})

	ix.chat.Register("w", {
		format = "%s whispers \"%s\"",
		CanHear = ix.config.Get("chatRange", 280) * 0.25,
		prefix = {"/W", "/Whisper"},
		description = "@cmdW",
		indicator = "chatWhispering",
		font  = "ixSmallFont",
		OnChatAdd = function(self, speaker, text)
			local name = IsValid(speaker) and speaker:GetCharacter():GetName() or "Console"
			local name_color = IsValid(speaker) and hook.Run("GetPlayerColorSB", speaker) or clr_gray
			local icon = IsValid(speaker) and ix.chat.GetPlayerIcon(speaker) or ""
			local flag = ix.geoip:GetMaterial(speaker, false) or ""

			if (#icon > 0) then
				icon = ix.util.GetMaterial(icon)
			end

			chat.AddText(Color(0, 150, 255), L"whisperChatPrefix", icon, flag, name_color, name .. ": ", color_white, text)
		end,
		CanHear = ix.config.Get("chatRange", 280),
		noSpaceAfter = true
	})

	ix.chat.Register("ic", {
		indicator = "chatTalking",
		OnChatAdd = function(self, speaker, text)
			local name = IsValid(speaker) and speaker:GetCharacter():GetName() or "Console"
			local name_color = IsValid(speaker) and hook.Run("GetPlayerColorSB", speaker) or clr_gray
			local icon = IsValid(speaker) and ix.chat.GetPlayerIcon(speaker) or ""
			local flag = ix.geoip:GetMaterial(speaker, false) or ""

			if (#icon > 0) then
				icon = ix.util.GetMaterial(icon)
			end

			chat.AddText(Color(0, 150, 255), L"localChatPrefix", icon, flag, name_color, name .. ": ", color_white, text)
		end,
		CanHear = ix.config.Get("chatRange", 280),
		noSpaceAfter = true
	})

	ix.chat.Register("radio", {
		bNoIndicator = true,
		CanHear = function(self, speaker, target)
			local squad = ix.squad.list[speaker:GetCharacter():GetSquadID()]

			return squad and squad.members[target:SteamID64()]
		end,
		CanSay = function(self, speaker)
			if (!speaker:Alive() or speaker.ixLastRadio and CurTime() - speaker.ixLastRadio <= 2) then
				return false
			end

			speaker.ixLastRadio = CurTime()
			return speaker:GetCharacter():GetSquadID() != "NULL"
		end,
		OnChatAdd = function(self, speaker, text)
			local name = IsValid(speaker) and speaker:GetCharacter():GetName() or "Console"
			local flag = ix.geoip:GetMaterial(speaker, false) or ""

			chat.AddText(Color(51, 153, 255), L"squadChatPrefix", flag, clr_gray, name .. ": ", color_white, text)
		end,
		description = "@cmdSquadChat",
		noSpaceAfter = true,
		prefix = {"/r", "/radio"}
	})

	ix.chat.Register("ooc", {
		CanSay = function(self, speaker, text)


			if (!ix.config.Get("allowGlobalOOC")) then
				speaker:NotifyLocalized("global_ooc_disabled")
				return false
			else
				local delay = ix.config.Get("oocDelay", 10)

				if (delay > 0 and speaker.ixLastOOC) then
					local lastOOC = CurTime() - speaker.ixLastOOC

					if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
						speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

						return false
					end
				end

				speaker.ixLastOOC = CurTime()
			end
		end,
		OnChatAdd = function(self, speaker, text)
			local name = IsValid(speaker) and speaker:GetCharacter():GetName() or "Console"
			local name_color = IsValid(speaker) and hook.Run("GetPlayerColorSB", speaker) or color_white
			local icon = IsValid(speaker) and ix.chat.GetPlayerIcon(speaker) or ""
			local flag = ix.geoip:GetMaterial(speaker, false) or ""

			if (#icon > 0) then
				icon = ix.util.GetMaterial(icon)
			end

			chat.AddText(Color("green"), L"globalChatPrefix", icon, flag, clr_gray, name .. ": ", name_color, text)
		end,
		prefix = {"//", "/OOC"},
		description = "@cmdOOC",
		noSpaceAfter = true
	})

	ix.chat.Register("trade", {
		CanSay = function(self, speaker, text)
			if (!IsValid(speaker)) then
				return false
			else
				local delay = ix.config.Get("tradeChatDelay", 10)

				if (delay > 0 and speaker.ixLastTradeChat) then
					local lastTrade = CurTime() - speaker.ixLastTradeChat

					if (lastTrade <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass TradeChat Timer", nil)) then
						speaker:NotifyLocalized("tradeChatDelay", delay - math.ceil(lastTrade))

						return false
					end
				end

				speaker.ixLastTradeChat = CurTime()
			end
		end,
		OnChatAdd = function(self, speaker, text)
			local name = IsValid(speaker) and speaker:GetCharacter():GetName() or "Console"
			local icon = IsValid(speaker) and ix.chat.GetPlayerIcon(speaker) or ""
			local flag = ix.geoip:GetMaterial(speaker, false) or ""

			if (#icon > 0) then
				icon = ix.util.GetMaterial(icon)
			end

			chat.AddText(Color(255, 200, 50), L"tradeChatPrefix", icon, flag, clr_gray, name .. ": ", color_white, text)
		end,
		description = "@cmdTradeChat",
		noSpaceAfter = true,
		prefix = "/trade"
	})

	if (SERVER) then
		ix.chat.classes["disconnect"].OnChatAdd = nil
		ix.chat.classes["connect"].OnChatAdd = nil
	end

	// COMMANDS

	for _, cmd in ipairs({"CharGetUp", "CharFallOver", "BecomeClass"}) do
		local data = ix.command.list[cmd:lower()]

		if (data) then
			if (data.alias) then
				if (istable(data.alias)) then
					for _, v in ipairs(data.alias) do
						ix.command.list[v:lower()] = nil
					end
				elseif (isstring(data.alias)) then
					ix.command.list[data.alias:lower()] = nil
				end
			end

			ix.command.list[cmd:lower()] = nil
		end

		data = nil
	end
end