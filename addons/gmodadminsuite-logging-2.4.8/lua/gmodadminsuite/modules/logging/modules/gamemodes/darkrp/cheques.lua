local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Cheques"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerDroppedCheque","droppedcheque",function(dropper,written,cost)
		MODULE:LogPhrase("darkrp_cheque_dropped", GAS.Logging:FormatPlayer(dropper), GAS.Logging:FormatMoney(cost), GAS.Logging:FormatPlayer(written))
	end)

	MODULE:Hook("playerPickedUpCheque","pickedupcheque",function(dropper,written,cost,success)
		if (not success) then return end
		MODULE:LogPhrase("darkrp_cheque_picked_up", GAS.Logging:FormatPlayer(written), GAS.Logging:FormatMoney(cost), GAS.Logging:FormatPlayer(dropper))
	end)

	MODULE:Hook("playerToreUpCheque","torecheque",function(dropper,written,cost)
		MODULE:LogPhrase("darkrp_cheque_tore_up", GAS.Logging:FormatPlayer(dropper), GAS.Logging:FormatMoney(cost), GAS.Logging:FormatPlayer(written))
	end)
end)

GAS.Logging:AddModule(MODULE)
