ITEM.name = "Czarny mundur najemnika"
ITEM.description = "Cały zestaw ubrań z którego korzystają najemnicy. Wersja czarna."
ITEM.model = "models/ninja/mgs4_praying_mantis_merc.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(140.94, -3.21, 67.18),
	ang = Angle(1.09, 178.88, 0),
	fov = 5.96
}



ITEM.defDurability = 2000
ITEM.replacement = "models/ninja/mgs4_praying_mantis_merc.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 5 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end
