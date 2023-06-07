ITEM.name = "Plecak Black Jack"
ITEM.description = "Plecak na długie, dalekie i udane wyprawy stworzony przez firmę Mystery Ranch."
ITEM.model = Model("models/player/backpack_blackjack/blackjack.mdl")
ITEM.pacmodel = "models/player/backpack_blackjack/bp_blackjack50_body_lod0.mdl"
ITEM.category = "Użytkowe"
ITEM.outfitCategory = "plecak"
ITEM.price = 35000
ITEM.invWidth = 5
ITEM.invHeight = 7
ITEM.rarity = { weight = math.abs(60-(ITEM.invWidth*ITEM.invHeight)) }
ITEM.price = ITEM.invWidth*ITEM.invHeight*1000
ITEM.pacData =  {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "e55790b048b1170dad4ada52abac950dc81675516e6041f9a9d5ab7d74459ac5",
				["NoLighting"] = false,
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TargetEntityUID"] = "",
				["Alpha"] = 1,
				["Material"] = "",
				["Invert"] = false,
				["ForceObjUrl"] = false,
				["Bone"] = "head",
				["Angles"] = Angle(0, 0, 0),
				["AngleOffset"] = Angle(0, 0, 0),
				["BoneMerge"] = true,
				["Color"] = Vector(1, 1, 1),
				["Position"] = Vector(0, 0, 0),
				["ClassName"] = "model2",
				["Brightness"] = 1,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(1, 1, 1),
				["LegacyTransform"] = false,
				["EditorExpand"] = false,
				["Size"] = 1,
				["ModelModifiers"] = "",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = ITEM.pacmodel,
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "d205fbec34802bd3b4fb840198d94a859790ad53627dc45f1225b6dc7cb6c223",
		["Hide"] = false,
		["TargetEntityUID"] = "",
		["EditorExpand"] = true,
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "",
		["Duplicate"] = false,
		["ClassName"] = "group",
	},
}




ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
        item.player:AddPart(item.uniqueID, item)
		return false
	end,

}

ITEM.functions.UnEquip = {
	name = "UnEquip",
	tip = "unequipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
        item.player:RemovePart(item.uniqueID)
		return false
	end,

}