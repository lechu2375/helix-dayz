if (not GAS.Logging.Modules:IsAddonInstalled("ServerGuard Admin Mod")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "ServerGuard"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("serverguard.RanCommand", "command", function(_ply,commandTable,silent,_args)
		if (silent or GAS.Logging.Config.ServerGuard_Blacklist[commandTable.command]) then return end
		local ply = _ply
		if (not IsValid(ply)) then
			ply = "CONSOLE"
		end
		local args = ""
		if (_args and #_args > 0) then
			args = " " .. table.concat(_args, " ")
		end
		MODULE:LogPhrase("command_used", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(commandTable.command .. args))
	end)
end)

GAS.Logging:AddModule(MODULE)