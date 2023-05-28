ITEM.name = "Mundur wojskowy"
ITEM.desc = "Mundur z odprutymi naszywkami, po obtarciach wygląda na to, że pierwotnie był w służbie."
ITEM.model = "models/gmodz/npc/military_exp.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(46.71, 1.04, 60.73),
	ang = Angle(-6.85, 181.77, -0.05),
	fov = 34.68
}



ITEM.defDurability = 2000
ITEM.replacement = "models/gmodz/npc/military_exp.mdl"
ITEM.noCollisionGroup = true
ITEM.price = 120000

ITEM.rarity = { weight = 10 }



ix.anim.SetModelClass(ITEM.replacement, "player")

function ITEM:OnGetDropModel(entity)
    return "models/gmodz/misc/backpack.mdl"
end