ITEM.name = "Hełm 6B47"
ITEM.description = "6B47 to aramidowy hełm rosyjskiego pochodzenia. W ramach programu Ratnik jest to nowy standardowy hełm dla większości rosyjskich sił zbrojnych."

ITEM.outfitCategory = "hat"



ITEM.dropHat = true

ITEM.categoryKit = "helmets"

ITEM.defDurability = 100
ITEM.damageReduction = { [HITGROUP_HEAD] = 0.3 }
ITEM.rarity = { weight = 10 }

ITEM.price = 15000

ITEM.model = "models/shtokerbox/ground_headgear_rus_helmet2b.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(-7.82, -124.29, 7.36),
	ang = Angle(1.7, 86.21, 0),
	fov = 3.76
}



ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(0, -90, -90),
					["UniqueID"] = "4eeab4e570878434914441326f6dea3e835fc2f88b8cebe7f995ca56de477b43",
					["ClassName"] = "model2",
					["Size"] = 1,
					["EditorExpand"] = true,
                    ["Bone"] = "head",
                    ["BoneMerge"] = true,
					["Model"] = "models/shtokerbox/headgear/male_headwear_rus_helmet2b.mdl",
					["Position"] = Vector(-0.9, -1, 0),
					["Name"] = "helmet"
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "243iun234bui234bdbhjkasdfafs21324324",
			["ClassName"] = "group",
			["Name"] = "tachelmet"
		},
	},
}