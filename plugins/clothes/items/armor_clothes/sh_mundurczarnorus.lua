ITEM.name = "Czarnoruski mundur wojskowy"
ITEM.description = "Porządnie wykonany mundur wojskowy, na ramieniu posiada flagę Czarnorusi."
ITEM.model = "models/easterncrisis/cdf_infantry_mask.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(46.71, 1.04, 60.73),
	ang = Angle(-6.85, 181.77, -0.05),
	fov = 34.68
}



ITEM.defDurability = 2000
ITEM.replacement = "models/easterncrisis/cdf_infantry_mask.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end