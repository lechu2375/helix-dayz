ITEM.name = "Komplet mudurowy GC"
ITEM.description = "Komplet mundurowy specjalnie przeznaczony do środowiska radioaktywnego. Został zaprojektowany na terenie Federacji Rosyjskiej jako cichy konkurent kompletu BETA"
ITEM.model = "models/player/trent/uc_soldier.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-60.07, 25.76, 59.97),
	ang = Angle(-3.79, 336.91, -0.08),
	fov = 19.01
}
ITEM.vip = true
ITEM.defDurability = 3000
ITEM.damageReduction = 0.1
ITEM.replacement = "models/player/trent/uc_soldier.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 4 }

ITEM.speedModify = 4



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end
