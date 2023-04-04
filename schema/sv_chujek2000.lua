local ACTable = ix.data.Get("antyzjeb", {}, true, true, true)

function Schema:PlayerInitialSpawn(ply)

    if(!ACTable[ply:SteamID64()]) then //no table for player then create new
        ACTable[ply:SteamID64()] = {}
        ACTable[ply:SteamID64()].hits = {}
    end
end

function Schema:ScalePlayerDamage( poszkodowany,hitgroup,dmginfo )
    local attacker = dmginfo:GetInflictor()
    local actable = ACTable[attacker:SteamID64()]
    actable.hits[hitgroup] = (actable.hits[hitgroup] or 0) + 1 
end


local meta = FindMetaTable("Player")


function meta:GetAllHitsCount(hitgroup)
    local actable = ACTable[self:SteamID64()]
    local count = 0
    if(hitgroup) then
        return actable.hits[hitgroup]
    else
        for _,v in pairs(actable.hits) do 
            count = count + v
        end
        return count
    end 
end

function meta:GetHitPercByHitgroup(hitgroup)
    local actable = ACTable[self:SteamID64()]
    if(actable.hits[hitgroup]) then
        local hitCount = self:GetAllHitsCount(false)
        local hitgroupCount = self:GetAllHitsCount(hitgroup)
        local percentage = hitgroupCount/hitCount
        return percentage
    end
    return false //wrong hitgroup
end