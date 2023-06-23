if (GAS.Logging.GamemodeModulesEnabled.DarkRP) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Team Changes"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerChangedTeam","teamchange",function(ply,before,after)
		MODULE:LogPhrase("changed_team", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatTeam(before), GAS.Logging:FormatTeam(after))
	end)
end)

GAS.Logging:AddModule(MODULE)
