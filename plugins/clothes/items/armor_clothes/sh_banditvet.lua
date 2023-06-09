ITEM.name = "Mundur łajdaka"
ITEM.description = "Ciuchy wyglądające na mundur, prawdopodobnie należą do kogoś kto kiedyś należał do armii ale wszedł na złą ścieżkę."
ITEM.model = "models/gmodz/npc/bandit_veteran.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(220.8, 16.18, 67.83),
	ang = Angle(2.08, 184.44, 0),
	fov = 5.96
}



ITEM.defDurability = 2000
ITEM.replacement = "models/gmodz/npc/bandit_veteran.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 8 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end


