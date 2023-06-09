ITEM.name = "Czarnoruski mundur wojskowy"
ITEM.description = "Porządnie wykonany mundur wojskowy, na ramieniu posiada flagę Czarnorusi. Bez kominiarki."
ITEM.model = "models/easterncrisis/cdf_infantry.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(308.6, -2.9, 137.03),
	ang = Angle(13.5, 179.54, 0),
	fov = 3.36
}





ITEM.defDurability = 2000
ITEM.replacement = "models/easterncrisis/cdf_infantry.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 8 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end