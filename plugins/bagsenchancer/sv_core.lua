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
		print("Adding Part")
		//PrintTable(bag[1].pacData)
        client:AddPart(bag[1].uniqueID, bag[1])
    end
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
		print("Removing Part")
		inventory:GetOwner():RemovePart(item.uniqueID)
	end
end
function PLUGIN:InventoryItemAdded(oldInv, inventory, item)
	if(inventory:GetOwner() and item.pacmodel) then
		inventory:GetOwner():GetCharacter():ReloadBagModel()
	end
end

concommand.Add("testcmd", function(ply,cmd,args)

	local char = ply:GetCharacter()
		print("found:")
		print(char:FindAllBagsInInventory()[1])
		char:ReloadBagModel()
end)