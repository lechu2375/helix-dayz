local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Warrants"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerWarranted","warrant",function(criminal,actor,reason)
		MODULE:LogPhrase("darkrp_filed_warant", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(criminal), GAS.Logging:Highlight(reason))
	end)

	MODULE:Hook("playerUnWarranted","unwarrant",function(excriminal,actor)
		MODULE:LogPhrase("darkrp_warrant_cancelled", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(excriminal))
	end)
end)

GAS.Logging:AddModule(MODULE)
