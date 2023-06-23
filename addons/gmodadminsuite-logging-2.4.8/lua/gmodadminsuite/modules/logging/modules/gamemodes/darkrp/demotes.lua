local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Demotes"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("onPlayerDemoted","demoted",function(ply,target,reason)
		MODULE:LogPhrase("darkrp_demoted", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(target), GAS.Logging:Highlight(reason))
	end)

	MODULE:Hook("playerAFKDemoted","afkdemoted",function(ply)
		MODULE:LogPhrase("darkrp_afk_demoted", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
