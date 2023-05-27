local CHAR = ix.meta.character 

function CHAR:FindAllBagsInInventory()
    local foundTable = {}
    for k,v in pairs(self:GetInventory():GetItems(true)) do
        if(v.invWidth) then //v.pacmodel
            foundTable[#foundTable+1] = v
        end
    end
        return foundTable
end

function CHAR:ReloadBagModel()
    local bag = self:FindAllBagsInInventory()
    local client = self:GetPlayer()
    if(bag[1]) then 

        client:AddPart("backpack", bag[1])
        print("addpart")
        //self:GetPlayer():AddPart(60, bag[1])
    end
end
concommand.Add("testcmd", function(ply,cmd,args)

local char = ply:GetCharacter()
    print("found:")
    print(char:FindAllBagsInInventory()[1])

    char:ReloadBagModel()
end)



function PLUGIN:CanPlayerTakeItem(client, item)

    local itemTable = ix.item.instances[item.ixItemID]
    print(itemTable.pacData)
	if(itemTable.invWidth) then
        return table.IsEmpty(client:GetCharacter():FindAllBagsInInventory()) //cant take more than one backpack
    end
end

local schemat =  {
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
				["Model"] = "models/player/backpack_baselardwild/bp_load_baselard_body_lod0.mdl",
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

do
    print("Backpacks update")
    for k,v in pairs(ix.item.list) do
        if(v.pacmodel) then
            v.pacData = schemat
            v.pacData["children"][1]["self"].model = pacmodel
        end
    end
end