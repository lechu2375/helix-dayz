local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Purchases"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	local function LogPurchase(ply, ent, amount)
		MODULE:LogPhrase("darkrp_purchase", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatMoney(amount))
	end

	MODULE:Hook("playerBoughtVehicle","boughtvehicle",LogPurchase)
	MODULE:Hook("playerBoughtCustomVehicle","boughtcustomvehicle",function(ply,tbl,ent,cost)
		LogPurchase(ply,ent,cost)
	end)
	MODULE:Hook("playerBoughtCustomEntity","boughtentity",function(ply,tbl,ent,cost)
		LogPurchase(ply,ent,cost)
	end)
	MODULE:Hook("playerBoughtAmmo","boughtammo",function(ply,tbl,ent,cost)
		MODULE:LogPhrase("darkrp_purchase_ammo", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatAmmo(tbl.ammoType), GAS.Logging:FormatMoney(cost))
	end)

	MODULE:Hook("playerBoughtShipment","boughtshipment", function(ply, tbl, _, cost)
		MODULE:LogPhrase("darkrp_purchase_shipment", GAS.Logging:FormatPlayer(ply), GAS.Logging:Escape(tbl.amount or 1), GAS.Logging:FormatEntity(tbl.entity), GAS.Logging:FormatMoney(cost))
	end)
	MODULE:Hook("playerBoughtPistol","boughtpistol",function(ply, tbl, _, cost)
		MODULE:LogPhrase("darkrp_purchase", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(tbl.entity), GAS.Logging:FormatMoney(cost))
	end)
	MODULE:Hook("playerBoughtFood","boughtfood",function(ply, tbl, _, cost)
		MODULE:LogPhrase("darkrp_purchase_food", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(tbl.name), GAS.Logging:FormatMoney(cost))
	end)
end)

GAS.Logging:AddModule(MODULE)
