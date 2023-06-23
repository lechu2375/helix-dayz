local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Pocket"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("onPocketItemAdded","pocketadded",function(ply,ent)
		MODULE:LogPhrase("darkrp_pocket_added", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
	end)

	MODULE:Hook("onPocketItemDropped","pocketdropped",function(ply,ent)
		MODULE:LogPhrase("darkrp_pocket_dropped", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
	end)
end)

GAS.Logging:AddModule(MODULE)
