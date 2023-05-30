ITEM.name = "Mundur rosyjskich służb specjalnych"
ITEM.description = "Mundur GORKA-4 wyprodukowany przez firmę BARS. Noszony głównie przez Specnaz."
ITEM.model = "models/tpamodern_nutscript.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(199.4, 3.02, 86.56),
	ang = Angle(6.6, 180.75, 0),
	fov = 5.96
}




ITEM.defDurability = 2000
ITEM.replacement = "models/tpamodern_nutscript.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }



//ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end