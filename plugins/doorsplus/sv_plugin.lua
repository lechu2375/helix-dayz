local doorHealth = 500
function PLUGIN:InitPostEntity()
    for _,ent in pairs(ents.GetAll()) do
        if(!string.find(ent:GetClass(), "door")) then continue end
        ent:SetNoDraw(false)
        ent:SetNotSolid(false)
        ent.ArcCW_DoorBusted = false
        if(ent.ArcCW_DoorOldPos) then
            ent:SetPos(ent.ArcCW_DoorOldPos)
            ent.ArcCW_DoorOldPos = nil
        end
        ent:SetMaxHealth(doorHealth)
        ent:SetHealth(doorHealth)
    end
end



if(ArcCW) then

    function ArcCW.TryBustDoor(ent, dmginfo)

        if GetConVar("arccw_doorbust"):GetInt() == 0 or !IsValid(ent) or !string.find(ent:GetClass(), "door") then return end

        local wep = IsValid(dmginfo:GetAttacker()) and ((dmginfo:GetInflictor():IsWeapon() and dmginfo:GetInflictor()) or dmginfo:GetAttacker():GetActiveWeapon())
        if !wep or !wep:IsWeapon() or !wep.ArcCW  then return end
      
        if ent:GetNoDraw() or ent.ArcCW_NoBust or ent.ArcCW_DoorBusted then return end
  
        --- TTT may choose for some doors to not be openable by a crowbar, let's respect that
        if GAMEMODE.crowbar_unlocks and GAMEMODE.crowbar_unlocks[ent] != true then return end
        ent:SetHealth(ent:Health()-dmginfo:GetDamage())
        -- Magic number: 119.506 is the size of door01_left
        -- The bigger the door is, the harder it is to bust
        //local threshold = GetConVar("arccw_doorbust_threshold"):GetInt() * math.pow((ent:OBBMaxs() - ent:OBBMins()):Length() / 119.506, 2)
    
        -- Because shotgun damage is done per pellet, we must count them together
        if ent.ArcCW_BustCurTime and (ent.ArcCW_BustCurTime + 0.1 < CurTime()) then
            ent.ArcCW_BustCurTime = nil
            ent.ArcCW_BustDamage = 0
        end
        if (ent:Health()>0) then
            ent.ArcCW_BustCurTime = ent.ArcCW_BustCurTime or CurTime()
            ent.ArcCW_BustDamage = (ent.ArcCW_BustDamage or 0) + dmginfo:GetDamage()
            return
        else
            ent.ArcCW_BustCurTime = nil
            ent.ArcCW_BustDamage = nil
        end
        if(!ent.ixFactionID) then//jak frakcyjne drzwi to nie resetujemy
            local owner = ent:GetDTEntity(0)
            if(IsValid(owner)) then 
                local character = owner:GetCharacter()
                ent:RemoveDoorAccessData()
				local doors = character:GetVar("doors") or {}
				for k, v in ipairs(doors) do
					if (v == entity) then
						table.remove(doors, k)
					end
				end
				character:SetVar("doors", doors, true)
            end
        end
        ent:Fire("Unlock")
        ArcCW.DoorBust(ent, dmginfo:GetDamageForce() * 0.5)
        
        
        -- Double doors are usually linked to the same areaportal. We must destroy the second half of the double door no matter what
        for _, otherDoor in pairs(ents.FindInSphere(ent:GetPos(), 64)) do
            if ent != otherDoor and otherDoor:GetClass() == ent:GetClass() and !otherDoor:GetNoDraw() then
                ArcCW.DoorBust(otherDoor, dmginfo:GetDamageForce() * 0.5)
                break
            end
        end
    end

end