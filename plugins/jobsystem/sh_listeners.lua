
local allZombies = {}
allZombies["nb_zombine"] = true
allZombies["nb_infested"] = true
allZombies["nb_freshdead"] = true
allZombies["nb_type2"] = true
allZombies["nb_infected_citizen"] = true
allZombies["nb_boss_gargantuan"] = true
allZombies["nb_type1"] = true
allZombies["nb_boss_corpse"] = true
allZombies["nb_shambler"] = true
allZombies["nb_type3"] = true
allZombies["nb_hulk_infested"] = true
allZombies["nb_seeker"] = true
allZombies["nb_seeker_slow"] = true
allZombies["nb_infected_citizen_slow"] = true
allZombies["nb_ghoul"] = true
local allZombieBoss = {}
allZombieBoss["nb_boss_gargantuan"] = true
allZombieBoss["nb_boss_corpse"] = true
local allBadGuys = {}
allBadGuys["nb_mercenary_condottiere"] = true
allBadGuys["nb_soldier"] = true
allBadGuys["nb_mercenary_bomber"] = true
allBadGuys["nb_soldier_nade"] = true
allBadGuys["nb_mercenary_melee"] = true
allBadGuys["nb_mercenary"] = true
allBadGuys["nb_mercenary_terrorist"] = true

local function CalculateCredit(entity, attacker, trigger)
  hook.Run("ix_JobTrigger", attacker, trigger)

  local players = {}

  for k,v in pairs(ents.FindInSphere( attacker:GetPos(), 1024 )) do
    if (v:IsPlayer() and v != attacker) then
      players[v:EntIndex()] = true
      hook.Run("ix_JobTrigger", v, trigger)
    end
  end
  for k,v in pairs(ents.FindInSphere( entity:GetPos(), 1024 )) do
    if (v:IsPlayer() and v != attacker and !players[v:EntIndex()]) then
      hook.Run("ix_JobTrigger", v, trigger)
    end
  end
end

function PLUGIN:OnNPCKilled(entity, attacker, inflictor)
  local class = string.lower(entity:GetClass())

  if attacker:IsPlayer() then

    if ( allZombies[class] or string.find(class, "zombie") )  then
      CalculateCredit(entity, attacker, "zombieKilled")
    end

    if (allZombieBoss[class])then
      CalculateCredit(entity, attacker, "bossKilled")
    end

    if (allBadGuys[class]) then
      CalculateCredit(entity, attacker, "mercenaryKilled")
    end
    
  end

end

function PLUGIN:PlayerSay(sender, text, teamchat)
  if(string.find(text, "sneed")) then
    hook.Run("ix_JobTrigger", sender, "chatSayTest")
  end
end