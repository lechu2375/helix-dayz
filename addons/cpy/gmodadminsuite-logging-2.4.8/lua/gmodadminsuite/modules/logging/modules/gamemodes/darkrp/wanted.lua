local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Wanted"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerWanted","wanted",function(criminal,actor,reason)
		MODULE:LogPhrase("darkrp_set_wanted", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(criminal), GAS.Logging:Highlight(reason))
	end)

	MODULE:Hook("playerUnWanted","unwanted",function(excriminal,actor)
		if (not IsValid(actor)) then
			MODULE:LogPhrase("darkrp_auto_cancelled_wanted", GAS.Logging:FormatPlayer(excriminal))
		else
			MODULE:LogPhrase("darkrp_cancelled_wanted", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(excriminal))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
