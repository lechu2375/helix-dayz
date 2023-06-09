ITEM.name = "Komplet mudurowy BETA"
ITEM.description = "Komplet mundurowy specjalnie przeznaczony do środowiska radioaktywnego."
ITEM.model = "models/player/cheddar/beta1/beta1_soldier_v2.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-60.07, 25.76, 59.97),
	ang = Angle(-3.79, 336.91, -0.08),
	fov = 19.01
}
ITEM.vip = true

ITEM.replacement = "models/player/cheddar/beta1/beta1_soldier_v2.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 5 }

ITEM.speedModify = 5
ITEM.defDurability = 2000


ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end
