local ACTable = ix.data.Get("antyzjeb", {}, true, true, true)

function Schema:PlayerInitialSpawn(ply)
    ply.ACTable = ply:GetData("actable", {})
    if(table.IsEmpty(ply.ACTable)) then
        ply.ACTable.hits = {}
    end
end

function Schema:PlayerDisconnected(ply )
    ply:SetData("actable", ply.ACTable)

end

function Schema:ScalePlayerDamage( poszkodowany,hitgroup,dmginfo )
    local attacker = dmginfo:GetInflictor()
    local actable = attacker.ACTable
    if(table.IsEmpty(attacker.ACTable)) then
        attacker.ACTable.hits = {}
    end
    actable.hits[hitgroup] = (actable.hits[hitgroup] or 0) + 1 
    if(attacker:GetAllHitsCount(false)>100 and attacker:GetHitPercByHitgroup(hitgroup)>0.8) then //sus?
        print(attacker,"sus","hitgroup num", hitgroup,"ponad 80% trafień w tego samego hitgroupa")
    end
end


local meta = FindMetaTable("Player")


function meta:GetAllHitsCount(hitgroup)
    local actable = self.ACTable
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
    local actable = self.ACTable
    if(actable.hits[hitgroup]) then
        local hitCount = self:GetAllHitsCount(false)
        local hitgroupCount = self:GetAllHitsCount(hitgroup)
        local percentage = hitgroupCount/hitCount
        return percentage
    end
    return false //wrong hitgroup
end