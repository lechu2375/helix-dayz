local CHAR = ix.meta.character 

function CHAR:FindAllBagsInInventory()
    local foundTable = {}
    for k,v in pairs(self:GetInventory():GetItems(true)) do
        if(v.invWidth and v.pacmodel) then //invW and pacmodel, we know that it is backpack
            foundTable[#foundTable+1] = v
        end
    end
        return foundTable
end

function CHAR:ReloadBagModel()


    local client = self:GetPlayer()

	for k,v in pairs(ix.item.list) do
		if(v.pacmodel) then
			client:RemovePart(v.uniqueID) //clear all others backpacks
		end
	end

    local bag = self:FindAllBagsInInventory()
    local client = self:GetPlayer()

    if(bag[1]) then 
        client:AddPart(bag[1].uniqueID, bag[1])
    end
end

function PLUGIN:PostPlayerLoadout(ply)
	ply:GetCharacter():ReloadBagModel()
end

function PLUGIN:CanPlayerTakeItem(client, item)

    local itemTable = ix.item.instances[item.ixItemID]
    
	if(itemTable.invWidth) then
		if(!table.IsEmpty(client:GetCharacter():FindAllBagsInInventory()) ) then
			client:Notify("Nie możesz mieć dwóch plecaków!")
			return false
		else
			return true
        end
    end
end

function PLUGIN:InventoryItemRemoved(inventory, item)
	if(inventory:GetOwner()) then
		inventory:GetOwner():RemovePart(item.uniqueID) //drop
	end
end
function PLUGIN:InventoryItemAdded(oldInv, inventory, item)
	if(inventory:GetOwner() and item.pacmodel) then
		inventory:GetOwner():GetCharacter():ReloadBagModel() //pick up
	end
end

/*
concommand.Add("testcmd", function(ply,cmd,args)

	local char = ply:GetCharacter()
		print("found:")
		print(char:FindAllBagsInInventory()[1])
		char:ReloadBagModel()
end)*/