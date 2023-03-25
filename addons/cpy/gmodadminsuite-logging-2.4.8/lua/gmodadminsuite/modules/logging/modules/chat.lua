local MODULE = GAS.Logging:MODULE()

MODULE.Category = "General"
MODULE.Name     = "Chat"
MODULE.Colour   = Color(0,106,193)

MODULE:Setup(function()
	if (GAS.Logging.GamemodeModulesEnabled.DarkRP) then
		MODULE:Hook("onChatCommand","oocchat",function(ply,cmd,args)
			if (type(args) == "table") then
				args = table.concat(args," ")
			end
			local lower_cmd = cmd:lower()
			if (lower_cmd == "ooc" or lower_cmd == "/") then
				MODULE:Log(GAS.Logging:FormatPlayer(ply) .. ": " .. GAS.Logging:Highlight("[OOC]") .. " " .. GAS.Logging:Escape(args))
			end
		end)
	end

	MODULE:SuperiorHook("PlayerSay","chat",function(ply,text)
		if (#text == 0) then return end
		MODULE:Log(GAS.Logging:FormatPlayer(ply) .. ": " .. GAS.Logging:Escape(text))
	end)
end)

GAS.Logging:AddModule(MODULE)