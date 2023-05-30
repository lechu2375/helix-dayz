ITEM.name = "Czarnoruski mundur wojskowy"
ITEM.description = "Porządnie wykonany mundur wojskowy, na ramieniu posiada flagę Czarnorusi. Bez kominiarki."
ITEM.model = "models/easterncrisis/cdf_infantry.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(188.31, 8.57, 102.17),
	ang = Angle(11.74, 182.62, 0),
	fov = 5.96
}




ITEM.defDurability = 2000
ITEM.replacement = "models/easterncrisis/cdf_infantry.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end