local PLUGIN = PLUGIN
local NextClimbing = NextClimbing or {}

function PLUGIN:HitElectricPole(traceHitVector)
    for _,v in pairs(PLUGIN.slupyElektryczne) do
        for _,bttn in pairs(v.bttns) do
            if(traceHitVector:DistToSqr(bttn)<1000) then 
                return true 
            end
        end
    end
    return false
end

function PLUGIN:KeyPress(ply,key)

    if(key==IN_USE and (NextClimbing[ply:SteamID64()] or 0 <CurTime()) and PLUGIN:CanClimbOnPole(ply)) then
        local tracedata = { }
        local ShootPos = ply:GetShootPos()
        local AimVector = ply:GetAimVector()
        tracedata.start = ShootPos
        tracedata.endpos = ShootPos + AimVector*45
        tracedata.filter = ply
        local trace = util.TraceLine(tracedata)
        if(PLUGIN:HitElectricPole(trace.HitPos)) then
            local survived = math.random(1,2)
            if(survived==2) then
                ply:AddBuff("adrenaline")
                ply:EmitSound("happyend_r8b.wav",90)
            else
                ply:EmitSound("badend_r8b.wav",90)
                ply:Kill()
            end
            local effectdata = EffectData()
            effectdata:SetOrigin( trace.HitPos )
            util.Effect( "TeslaZap", effectdata )
            print("done")
            NextClimbing[ply:SteamID64()] = CurTime()+ 60*10 //every 10 mins
        end
    end
end