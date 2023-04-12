local PLUGIN = PLUGIN
PLUGIN.name = "Polish electrican"
PLUGIN.description = "Nie weszłeś"
PLUGIN.author = "Lechu2375"

local wysokoscSlupa = 1564
local slupekElektrik = {
    Vector(-4772.5844726563,7111.4936523438,317.39059448242),
    Vector(-4424.0288085938,6743.3901367188,352.49060058594)
}

slupekElektrik[2].z = wysokoscSlupa
local origin = Vector(-4607.3647460938,6932.2109375,335.25302124023)

/*
if(CLIENT) then
    function PLUGIN:PostDrawTranslucentRenderables()
        render.SetColorMaterial()
        cam.IgnoreZ( true )
        render.DrawBox( origin, angle_zero, mina, maxa, color_white )
        cam.IgnoreZ( false)
    end

end*/ 

if(SERVER) then

    function PLUGIN:ShouldCollide(ent1,ent2 )
        print(ent1,ent2)
    end
end
local trigger
function TestJumpix()




    timer.Create("dupojadek", 0.3, 0, function()
        local ply = player.GetAll()[1]
        local tracedata = { }
        local ShootPos = ply:GetShootPos()
        local AimVector = ply:GetAimVector()
        tracedata.start = ShootPos
        tracedata.endpos = ShootPos + AimVector*45
        tracedata.filter = ply
        local trace = util.TraceLine(tracedata)
        
        if(ply:GetPos():WithinAABox(slupekElektrik[1],slupekElektrik[2]) ) then
            
            ply:SetLocalVelocity(ply:GetAimVector() * 400)
    
            local Vel = ply:GetVelocity()
            ply:SetVelocity(Vector(0, 0, 240 - 15 * 1 - Vel.z))
        else
            timer.Remove("dupojadek")
        end  
    end)

end