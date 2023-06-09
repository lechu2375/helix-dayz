


function PLUGIN:CanPlayerEquipItem(client, item)
    if(item.vip) then
        return client:IsVip()
    end
end