local ACTable = ix.data.Get("antyzjeb", {}, true, true, true)

function Schema:PlayerInitialSpawn(ply)

    if(!ACTable[ply:SteamID64()]) then
        ACTable[ply:SteamID64()] = {}
        ACTable[ply:SteamID64()].hits = {}
    end
end

function Schema:ScalePlayerDamage( poszkodowany,hitgroup,dmginfo )
    local attacker = dmginfo:GetInflictor()
    local actable = ACTable[attacker:SteamID64()]
    actable.hits[hitgroup] = (actable.hits[hitgroup] or 0) + 1
end

