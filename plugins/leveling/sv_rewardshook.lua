function PLUGIN:OnNPCKilled(npc,attacker,inflictor )
    if(attacker:IsPlayer()) then
        local character = attacker:GetCharacter()
        if(character)then
            ix.leveling.giveXP(attacker, 5, false, false)
        end
    end
end
