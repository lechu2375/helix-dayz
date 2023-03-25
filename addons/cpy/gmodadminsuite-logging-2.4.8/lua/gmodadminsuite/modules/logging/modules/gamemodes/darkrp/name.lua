local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "RPName Changes"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("onPlayerChangedName","changename",function(ply,before,after)
		MODULE:LogPhrase("darkrp_rpname_change", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(before), GAS.Logging:Highlight(after))
	end)
end)

GAS.Logging:AddModule(MODULE)
