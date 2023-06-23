local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Economy"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerDroppedMoney","droppedmoney",function(ply,amount,ent)
		ent.bLogs_WhoDroppedMoney = ply
		MODULE:LogPhrase("darkrp_dropped_money", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatMoney(amount))
	end)

	MODULE:Hook("playerPickedUpMoney","pickedupmoney",function(ply,amount,ent)
		if (IsValid(ent) and IsValid(ent.bLogs_WhoDroppedMoney)) then
			MODULE:LogPhrase("darkrp_picked_up_money_dropped_by", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatMoney(amount), GAS.Logging:FormatPlayer(ent.bLogs_WhoDroppedMoney))
		else
			MODULE:LogPhrase("darkrp_picked_up_money", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatMoney(amount))
		end
	end)

	MODULE:Hook("playerGaveMoney", "playerGaveMoney", function(giver, receiver, amount)
		MODULE:LogPhrase("darkrp_gave_money", GAS.Logging:FormatPlayer(giver), GAS.Logging:FormatMoney(amount), GAS.Logging:FormatPlayer(receiver))
	end)
end)

GAS.Logging:AddModule(MODULE)
