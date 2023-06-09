ITEM.name = "Mundur wojskowy"
ITEM.description = "Mundur z odprutymi naszywkami, po obtarciach wygląda na to, że pierwotnie był w służbie."
ITEM.model = "models/gmodz/npc/military_exp.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(220.8, 16.18, 67.83),
	ang = Angle(2.08, 184.44, 0),
	fov = 5.96
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