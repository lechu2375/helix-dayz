PLUGIN.name = "Bags enchancer"
PLUGIN.author = "Lechu2375"

ix.util.Include("sv_core.lua")


local schemat = [[[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "d5dd2b367f2eedf334725786c8bc68e9a543005dd56db831593fd5975a5b12a4",
				["NoLighting"] = false,
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["AngleOffset"] = Angle(0, 0, 0),
				["PositionOffset"] = Vector(0, 0, 0),
				["Color"] = Vector(1, 1, 1),
				["Translucent"] = false,
				["DrawOrder"] = 0,
				["Alpha"] = 1,
				["Material"] = "",
				["Invert"] = false,
				["Bone"] = "head",
				["ModelModifiers"] = "",
				["BlendMode"] = "",
				["BoneMerge"] = true,
				["Model"] = "models/player/backpack_baselardwild/bp_load_baselard_body_lod0.mdl",
				["Position"] = Vector(0, 0, 0),
				["Brightness"] = 1,
				["LegacyTransform"] = false,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(1, 1, 1),
				["ClassName"] = "model2",
				["EditorExpand"] = false,
				["Size"] = 1,
				["EyeAngles"] = false,
				["NoTextureFiltering"] = false,
				["ForceObjUrl"] = false,
				["EyeTargetUID"] = "",
				["Angles"] = Angle(0, 0, 0),
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["EditorExpand"] = true,
		["OwnerName"] = "self",
		["Name"] = "my outfit",
		["ClassName"] = "group",
		["Hide"] = false,
		["Duplicate"] = false,
		["UniqueID"] = "9349211999f89157e512ab7669c448ed3b63514c3d3ea36be653f624a6285f08",
	},
},
["children"] = {
	[1] = {
		["children"] = {
		},
		["self"] = {
			["Skin"] = 0,
			["UniqueID"] = "d5dd2b367f2eedf334725786c8bc68e9a543005dd56db831593fd5975a5b12a4",
			["NoLighting"] = false,
			["AimPartName"] = "",
			["IgnoreZ"] = false,
			["AimPartUID"] = "",
			["Materials"] = "",
			["Name"] = "",
			["LevelOfDetail"] = 0,
			["AngleOffset"] = Angle(0, 0, 0),
			["PositionOffset"] = Vector(0, 0, 0),
			["Color"] = Vector(1, 1, 1),
			["Translucent"] = false,
			["DrawOrder"] = 0,
			["Alpha"] = 1,
			["Material"] = "",
			["Invert"] = false,
			["Bone"] = "head",
			["ModelModifiers"] = "",
			["BlendMode"] = "",
			["BoneMerge"] = true,
			["Model"] = "%s",
			["Position"] = Vector(0, 0, 0),
			["Brightness"] = 1,
			["LegacyTransform"] = false,
			["Hide"] = false,
			["NoCulling"] = false,
			["Scale"] = Vector(1, 1, 1),
			["ClassName"] = "model2",
			["EditorExpand"] = false,
			["Size"] = 1,
			["EyeAngles"] = false,
			["NoTextureFiltering"] = false,
			["ForceObjUrl"] = false,
			["EyeTargetUID"] = "",
			["Angles"] = Angle(0, 0, 0),
		},
	},
},
["self"] = {
	["DrawOrder"] = 0,
	["EditorExpand"] = true,
	["OwnerName"] = "self",
	["Name"] = "my outfit",
	["ClassName"] = "group",
	["Hide"] = false,
	["Duplicate"] = false,
	["UniqueID"] = "9349211999f89157e512ab7669c448ed3b63514c3d3ea36be653f624a6285f08",
},
]]
/*
do
    print("Backpacks update")
    for k,v in pairs(ix.item.list) do
        if(v.pacmodel) then
            v.pacData = string.format(schemat, v.pacmodel)
        end
    end
end*/