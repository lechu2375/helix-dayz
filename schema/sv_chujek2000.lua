local ACTable = ix.data.Get("antyzjeb", {}, true, true, true)

function Schema:PlayerInitialSpawn(ply)
    ply:IsOnBanicja() //if we should remove from him banicja then do it
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


hook.Add( "EntityTakeDamage", "BanicjaWatcher", function( target, dmg )//Banned player dont deal damage
    local attacker = dmg:GetInflictor()
    if(attacker:IsPlayer() and attacker:IsOnBanicja()) then
        dmg:SetDamage(0)
        return true
    end
end )



function Schema:OnEntityCreated(entity) //banned player shouldn see items lmao
    if(entity:GetClass()=="ix_item") then
        for k,v in pairs(player.GetAll()) do
            if(v:IsOnBanicja()) then
                entity:SetPreventTransmit(v,true)
            end
        end
    end
end


local meta = FindMetaTable("Player")



//BANICJA
function meta:SetBanicja(duration) //minimum 1hour
    local osTime = os.time()
    if(duration<=0) then
        duration = 1
    end
    duration = osTime+(duration*60*60)
    self:SetData("banicja",duration)
    
end
function meta:IsOnBanicja()
    local banicjaTime = self:GetData("banicja",false)
    if(banicjaTime) then
        local osTime = os.time()
        if(osTime>banicjaTime) then
            self:RemoveBanicja()
            return false
        else
            return true
        end
    end
    return false
end
function meta:RemoveBanicja()
    self:SetData("banicja",false)
    
end
/// BANICJA END

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
    adminOnly = true,
	OnRun = function(self, client, target)
        client:PrintMessage(HUD_PRINTTALK, target:GetPlayer():Nick()..":"..target:GetName())
		client:PrintMessage(HUD_PRINTTALK, target:GetPlayer():GetInfoString())
        client:PrintMessage(HUD_PRINTTALK, "Ta postać ma już:"..(math.Round(target:GetPlaytime()/60, 2)).."godzin")
	end
}) 

ix.command.Add("Zbanuj", {
	description = "Zbanuj chuja na x godzin",
	arguments = {
		ix.type.character,
		ix.type.number
	},
    adminOnly = true,
	OnRun = function(self, client, target,hours)
        local clientTarget = target:GetPlayer()
        clientTarget:SetBanicja(hours)
        local time = os.time()
        time=time+(hours*60*60)
        local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , time )
        client:PrintMessage(HUD_PRINTTALK,"Zbanowałeś chuja do ".. TimeString)
	end
}) 
ix.command.Add("Odbanuj", {
	description = "Odbanuj chuja",
	arguments = ix.type.character,
    adminOnly = true,
	OnRun = function(self, client, target)
        local clientTarget = target:GetPlayer()
        clientTarget:RemoveBanicja()
	end
}) 

ix.command.Add("SprawdzBanicje", {
	description = "Sprawdz status typka",
	arguments = ix.type.character,
    adminOnly = true,
	OnRun = function(self, client, target)
        local clientTarget = target:GetPlayer()
        if(clientTarget:IsOnBanicja()) then
            local banicjaTime = clientTarget:GetData("banicja",false)
            local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , banicjaTime )
            client:PrintMessage(HUD_PRINTTALK,"Chuj będzie wolny o ".. TimeString)
        else
            client:PrintMessage(HUD_PRINTTALK,"Ten gracz nie posiada statusu banicji")
        end
	end
}) 