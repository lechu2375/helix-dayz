if (not GAS.Logging.Modules:IsAddonInstalled("AWarn")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "AWarn"
MODULE.Name     = "Warnings"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	local function PlayerWarned(ply,admin,reason)
		if (reason and #string.Trim(reason) > 0) then
			MODULE:LogPhrase("warned_reason", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(admin), GAS.Logging:Highlight(reason))
		else
			MODULE:LogPhrase("warned_noreason", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(admin))
		end
	end
	MODULE:Hook("AWarnPlayerWarned","warned",PlayerWarned)
	MODULE:Hook("AWarnPlayerIDWarned","idwarned",PlayerWarned)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "AWarn"
MODULE.Name     = "Kicks"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("AWarnLimitKick","warnkick",function(ply)
		MODULE:LogPhrase("warned_kicked", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "AWarn"
MODULE.Name     = "Bans"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("AWarnLimitBan","warnban",function(ply)
		MODULE:LogPhrase("warned_banned", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
