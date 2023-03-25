local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Doors"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:SuperiorHook("playerKeysSold","solddoor",function(ply, door)
		if (not door:isDoor()) then return end
		MODULE:LogPhrase("darkrp_sold_door", GAS.Logging:FormatPlayer(ply))
	end)

	MODULE:SuperiorHook("playerBoughtDoor","boughtdoor",function(ply, door)
		MODULE:LogPhrase("darkrp_bought_door", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
