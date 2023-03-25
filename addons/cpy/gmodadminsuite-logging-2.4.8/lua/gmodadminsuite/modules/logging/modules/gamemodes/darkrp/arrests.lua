local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Arrests"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerArrested","arrested",function(criminal,time,actor)
		MODULE:LogPhrase("darkrp_arrest", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(criminal))
	end)

	MODULE:Hook("playerUnArrested","unarrested",function(excriminal,actor)
		MODULE:LogPhrase("darkrp_unarrest", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(excriminal))
	end)
end)

GAS.Logging:AddModule(MODULE)
