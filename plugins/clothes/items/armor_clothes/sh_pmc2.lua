ITEM.name = "Czarny mundur najemnika"
ITEM.description = "Cały zestaw ubrań z którego korzystają najemnicy. Wersja czarna."
ITEM.model = "models/ninja/mgs4_praying_mantis_merc.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(46.71, 1.04, 60.73),
	ang = Angle(-6.85, 181.77, -0.05),
	fov = 34.68
}



ITEM.defDurability = 2000
ITEM.replacement = "models/ninja/mgs4_praying_mantis_merc.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end
