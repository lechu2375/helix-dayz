ITEM.name = "Exoskeleton"
ITEM.description = ""
ITEM.model = "models/gmodz/characters/exoskeleton.mdl"
ITEM.width = 3
ITEM.height = 3
ITEM.iconCam = {
	pos = Vector(220.8, 16.18, 67.83),
	ang = Angle(2.08, 184.44, 0),
	fov = 5.96
}

ITEM.defDurability = 5000
ITEM.damageReduction = 0.5
ITEM.replacement = "models/gmodz/characters/exoskeleton.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 350000

ITEM.speedModify = -5

ITEM.disableSprint = true

ITEM.rarity = { weight = 1 }

ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/Items/BoxMRounds.mdl"
end