if (not GAS.Logging.Modules:IsAddonInstalled("ULX Admin Mod")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "ULX"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(255,90,0)

local ULX_Blacklist = {
	["ulx noclip"] = true,
	["ulx luarun"] = true,
	["ulx rcon"] = true,

	["ulx votebanMinvotes"] = true,
	["ulx votebanSuccessratio"] = true,
	["ulx votekickMinvotes"] = true,
	["ulx votekickSuccessratio"] = true,
	["ulx votemap2Minvotes"] = true,
	["ulx votemap2Successratio"] = true,
	["ulx voteEcho"] = true,
	["ulx votemapMapmode"] = true,
	["ulx votemapVetotime"] = true,
	["ulx votemapMinvotes"] = true,
	["ulx votemapWaittime"] = true,
	["ulx votemapMintime"] = true,
	["ulx votemapEnabled"] = true,
	["ulx rslotsVisible"] = true,
	["ulx rslots"] = true,
	["ulx rslotsMode"] = true,
	["ulx logEchoColorMisc"] = true,
	["ulx logEchoColorPlayer"] = true,
	["ulx logEchoColorPlayerAsGroup"] = true,
	["ulx logEchoColorEveryone"] = true,
	["ulx logEchoColorSelf"] = true,
	["ulx logEchoColorConsole"] = true,
	["ulx logEchoColorDefault"] = true,
	["ulx logEchoColors"] = true,
	["ulx logEcho"] = true,
	["ulx logDir"] = true,
	["ulx logJoinLeaveEcho"] = true,
	["ulx logSpawnsEcho"] = true,
	["ulx votemapSuccessratio"] = true,
	["ulx logSpawns"] = true,
	["ulx logChat"] = true,
	["ulx logEvents"] = true,
	["ulx logFile"] = true,
	["ulx welcomemessage"] = true,
	["ulx meChatEnabled"] = true,
	["ulx chattime"] = true,
	["ulx motdurl"] = true,
	["ulx motdfile"] = true,
	["ulx showMotd"] = true,
}

MODULE:Setup(function()
	MODULE:Hook(ULib.HOOK_COMMAND_CALLED or "ULibCommandCalled", "command", function(_ply,cmd,_args)
		if (not _args) then return end
		if ((#_args > 0 and ULX_Blacklist[cmd .. " " .. _args[1]]) or ULX_Blacklist[cmd]) then return end
		local ply = _ply
		if (not IsValid(ply)) then
			ply = "CONSOLE"
		end
		local argss = ""
		if (#_args > 0) then
			argss = " " .. table.concat(_args, " ")
		end
		MODULE:LogPhrase("command_used", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(cmd .. argss))
	end)
end)

GAS.Logging:AddModule(MODULE)