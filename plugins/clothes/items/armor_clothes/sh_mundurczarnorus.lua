ITEM.name = "Czarnoruski mundur wojskowy"
ITEM.desc = "Porządnie wykonany mundur wojskowy, na ramieniu posiada flagę Czarnorusi."
ITEM.model = "models/tankbags/small_bags/smallbag04.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(248.25, 220.12, 137.3),
	ang = Angle(22.29, 221.77, 0),
	fov = 5.96
}


ITEM.defDurability = 2000
ITEM.damageReduction = 0.3
ITEM.replacement = "models/easterncrisis/cdf_infantry_mask.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }

ITEM.speedModify = -25

ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/tankbags/small_bags/smallbag04.mdl"
end