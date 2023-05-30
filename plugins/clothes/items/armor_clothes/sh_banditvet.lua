ITEM.name = "Mundur łajdaka"
ITEM.description = "Ciuchy wyglądające na mundur, prawdopodobnie należą do kogoś kto kiedyś należał do armii ale wszedł na złą ścieżkę."
ITEM.model = "models/gmodz/npc/bandit_veteran.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(46.71, 1.04, 60.73),
	ang = Angle(-6.85, 181.77, -0.05),
	fov = 34.68
}



ITEM.defDurability = 2000
ITEM.replacement = "models/gmodz/npc/bandit_veteran.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end