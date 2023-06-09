ITEM.name = "Ghillie"
ITEM.description = "Strój maskujący używany głównie przez strzelców wyborowych."
ITEM.model = "models/gmodz/characters/ghillie.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-64.41, 9.66, 58.43),
	ang = Angle(-5.74, 351.56, -0.03),
	fov = 20.07
}
ITEM.onlyvip = true
ITEM.useDurability = nil
ITEM.replacement = "models/gmodz/characters/ghillie.mdl"
ITEM.noCollisionGroup = true
ITEM.speedModify = 10
ITEM.price = 80000
ITEM.vip = true

ITEM.rarity = { weight = 2 }

ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/Items/BoxMRounds.mdl"
end