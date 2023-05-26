local ACTable = ix.data.Get("antyzjeb", {}, true, true, true)

function Schema:PlayerInitialSpawn(ply)
    ply.ACTable = ply:GetData("actable", {})
    if(table.IsEmpty(ply.ACTable)) then
        ply.ACTable.hits = {}
        for i=1,7 do
            ply.ACTable.hits[i] = 0
        end
    end
end

function Schema:PlayerDisconnected(ply )
    ply:SetData("actable", ply.ACTable)

end

function Schema:ScalePlayerDamage( poszkodowany,hitgroup,dmginfo )
    local attacker = dmginfo:GetInflictor()

    local actable = attacker.ACTable
    if(IsValid(actable)) then
        if(table.IsEmpty(attacker.ACTable)) then
            attacker.ACTable.hits = {}
        end
        actable.hits[hitgroup] = (actable.hits[hitgroup] or 0) + 1 
        if(attacker:GetAllHitsCount(false)>100 and attacker:GetHitPercByHitgroup(hitgroup)>0.8) then //sus?
            print(attacker,"sus","hitgroup num", hitgroup,"ponad 80% trafień w tego samego hitgroupa")
        end
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


local translateTable = {}
translateTable[1] = "Głowa"
translateTable[2] = "Klatka"
translateTable[3] = "Brzuch"
translateTable[4] = "Lewa ręka"
translateTable[5] = "Prawa ręka"
translateTable[6] = "Lewa noga"
translateTable[7] = "Prawa noga"
function meta:GetInfoString()
    local str = ""
    for i=1,7 do

        str=str.."\n"..translateTable[i]..":"..self:GetAllHitsCount(i).."/"..self:GetHitPercByHitgroup(i).."%"
    end
    return str
end


ix.command.Add("Investigate", {
	description = "Przejrzyj",
	arguments = ix.type.character,
	OnRun = function(self, client, target)
        client:PrintMessage(HUD_PRINTTALK, target:GetPlayer():Name()..":"..target:GetName())
		client:PrintMessage(HUD_PRINTTALK, target:GetPlayer():GetInfoString())
        client:PrintMessage(HUD_PRINTTALK, "Ta postać ma już:"..(target:GetPlaytime()/60).."godzin")
	end
})