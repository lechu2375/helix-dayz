ITEM.name = "Hełm KZ SZZPU"
ITEM.description = [[Hełm OMON skonstruowany i wyprodukowany zgodnie z technicznymi wymogami TU 7399-112-29211456-2012.

Przeznaczony jest do ochrony głowy przed uderzeniami pałką, kamieniami, butelkami itd., ochrona przed odkrytym ogniem i niebezpiecznymi sytuacjami klimatycznymi.

Wytrzymuje uderzenie tępym narzędziem o sile 80 J."]]

ITEM.outfitCategory = "hat"



ITEM.dropHat = true

ITEM.categoryKit = "helmets"

ITEM.defDurability = 100
ITEM.damageReduction = { [HITGROUP_HEAD] = 0.2 }
ITEM.rarity = { weight = 15 }

ITEM.price = 10000

ITEM.model = "models/shtokerbox/ground_headgear_riothelmet2.mdl"
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
					["Model"] = "models/shtokerbox/headgear/male_headwear_riothelmet2.mdl",
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