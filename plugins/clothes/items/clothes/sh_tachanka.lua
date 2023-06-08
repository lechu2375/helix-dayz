ITEM.name = "Hełm Maska-1SCh"
ITEM.description = [[Kuloodporny hełm ochronny Maska-1 pojawił się w służbie w 1991 roku jako zamiennik hełmu "Sfera", zaprojektowanego do użytku przez Ministerstwo Spraw Wewnętrznych Sił Zbrojnych Federacji Rosyjskiej. Modyfikacja Maska-1SCh ("Mask-1 Shield") posiada kuloodporną stalową osłonę twarzy, aby zapewnić maksymalną ochronę twarzy użytkownika. ]]

ITEM.outfitCategory = "hat"



ITEM.dropHat = true

ITEM.categoryKit = "helmets"

ITEM.defDurability = 250
ITEM.damageReduction = { [HITGROUP_HEAD] = 0.7 }
ITEM.rarity = { weight = 2 }

ITEM.price = 19000

ITEM.model = "models/shtokerbox/headgear/ground_headwear_tchanka.mdl"
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
					["UniqueID"] = "4eeab4e5708784349dsa26f6dea3e835fc2f88b8cebe7f995ca56de477b43",
					["ClassName"] = "model2",
					["Size"] = 1,
					["EditorExpand"] = true,
                    ["Bone"] = "head",
                    ["BoneMerge"] = true,
					["Model"] = "models/shtokerbox/headgear/male_headwear_tchanka.mdl",
					["Position"] = Vector(-0.9, -1, 0),
					["Name"] = "helmet"
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "243iun234bui234bdbhjkasdfafs21324324",
			["ClassName"] = "group",
			["Name"] = "altyn"
		},
	},
}