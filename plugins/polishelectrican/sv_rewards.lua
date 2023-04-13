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
function testzap()

    local effectdata = EffectData()
    effectdata:SetOrigin( player.GetAll()[1]:GetPos() )
    effectdata:SetMagnitude(10)
    util.Effect( "ElectricSpark", effectdata,true, true )

end
function PLUGIN:KeyPress(ply,key)

    if(key==IN_USE and (NextClimbing[ply:SteamID64()] or 0 <CurTime()) and PLUGIN:CanClimbOnPole(ply)) then
        //print(NextClimbing[ply:SteamID64()] or 0 <CurTime())
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
                timer.Simple(2, function() if(ply:IsValid()) then ply:Kill() end end)

            end
            local effectdata = EffectData()
            effectdata:SetOrigin( trace.HitPos )
            effectdata:SetMagnitude(10)
            util.Effect( "ElectricSpark", effectdata,true, true )
            //NextClimbing[ply:SteamID64()] = CurTime()+ 60*10 //every 10 mins
        end
    end

    if(key==IN_ATTACK2 and ply:GetActiveWeapon():GetClass()=="ix_hands" and ( (ply.nextElectricJump or 0)<=CurTime() )  and  PLUGIN:CanClimbOnPole(ply) ) then
            
            
        ply:SetLocalVelocity(ply:GetAimVector() * 400)
    
        local Vel = ply:GetVelocity()
        ply:SetVelocity(Vector(0, 0, 240 - 15 * 1 - Vel.z))
        ply.nextElectricJump = CurTime()+.3

        if(!ply.climbingSoundStage) then
            print("climbingSoundStage1")
            ply.climbingSoundStage = 1
            ply.nextClimbingSound = CurTime()+4
        end

        if(ply.nextClimbingSound<CurTime()) then
            print("kture puscic")
            if(ply.climbingSoundStage == 1) then
                ply:EmitSound("stage1_r8b.wav",90)
                ply.climbingSoundStage = 2
            elseif(ply.climbingSoundStage == 2) then
                ply:EmitSound("stage2_r8b.wav",90)
                ply.climbingSoundStage = 3
            elseif(ply.climbingSoundStage == 3) then
                ply:EmitSound("stage3_r8b.wav",90)
                ply.climbingSoundStage = 1
            end
            ply.nextClimbingSound = CurTime()+math.random(5, 10)
            print("narkaa")
        end



    end
end

function PLUGIN:ScalePlayerDamage(ply)

    ply.nextElectricJump = CurTime()+30 //nie ma

end