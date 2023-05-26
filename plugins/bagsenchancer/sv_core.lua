local CHAR = ix.meta.character or

function CHAR:FindAllBags()
    local foundTable = {}
    for k,v in pairs(self:GetInventory():GetItems(true)) do
        if(v.invWidth) then

        end
    end
    return foundTable
end