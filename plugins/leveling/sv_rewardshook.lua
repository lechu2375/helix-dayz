function PLUGIN:OnNPCKilled(npc,attacker,inflictor )
    if(attacker:IsPlayer()) then
        local character = attacker:GetCharacter()
        if(character)then
            ix.leveling.giveXP(attacker, 5, false, false)
        end
    end
end


function PLUGIN:OnPlayerAreaChanged(client)
    local character = client:GetCharacter()
    if(character)then
        ix.leveling.giveXP(client, 3, true, true)
    end
end


function  PLUGIN:PlayerDeath(  victim,  inflictor,  attacker )
    if(attacker:IsPlayer()) then
        local character = attacker:GetCharacter()
        if(character)then
            ix.leveling.giveXP(attacker, 10, false, false)
        end
    end
end