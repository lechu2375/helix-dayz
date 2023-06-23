local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Job Changes"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("OnPlayerChangedTeam","changejob",function(ply,before,after)
		MODULE:LogPhrase("darkrp_changed_job", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatTeam(before), GAS.Logging:FormatTeam(after))
	end)
end)

GAS.Logging:AddModule(MODULE)
