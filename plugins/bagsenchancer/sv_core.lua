local CHAR = ix.meta.character or

function CHAR:FindAllBagsInInventory()
    local foundTable = {}
    for k,v in pairs(self:GetInventory():GetItems(true)) do
        if(v.invWidth) then //v.pacmodel
            foundTable[#foundTable+1] = v
        end
    end
        return foundTable
end

concommand.Add("testcmd", function(ply)

local char = ply:GetCharacter()
    print("found:")
    PrintTable(char:FindAllBagsInInventory())

end)