local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Murder"
MODULE.Name     = "Loot"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("PlayerPickupLoot", "pickuploot", function(ply)
		MODULE:LogPhrase("murder_loot", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
