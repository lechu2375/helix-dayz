local PLUGIN = PLUGIN
local wysokoscSlupa = 1564
PLUGIN.slupyElektryczne = {}
local slupyElektryczne = PLUGIN.slupyElektryczne

slupyElektryczne[1] = {    
    Vector(-4772.5844726563,7111.4936523438,317.39059448242),
    Vector(-4424.0288085938,6743.3901367188,wysokoscSlupa)

}
slupyElektryczne[1].bttns = 
{

    Vector(-4405.2133789063,6927.0869140625,1112.52734375),
    Vector(-4455.04296875,6923.9389648438,1235.0303955078),
    Vector(-4746.3984375,6929.9384765625,1258.2864990234),
    Vector(-4812.306640625,6930.8120117188,1092.6423339844),
    Vector(-4751.0405273438,6930.8110351563,925.94177246094),
    Vector(-4462.5732421875,6930.81640625,923.64556884766)



}




if(CLIENT) then
    function PLUGIN:PostDrawTranslucentRenderables()
        for _,v in pairs(PLUGIN.slupyElektryczne) do
            for _,b in pairs(v.bttns) do

                render.DrawSphere( b, 10, 30,50,color_white)

            end
        end

    end

end

function PLUGIN:CanClimbOnPole(ply)
    local pos = ply:GetPos()
    for _,v in pairs(slupyElektryczne) do
        if(pos:WithinAABox(v[1],v[2])) then 
            return true 
        end
    end
    return false
end

local origin = Vector(-4607.3647460938,6932.2109375,335.25302124023)
function PLUGIN:KeyPress(ply,key)
    if(key==IN_ATTACK2 and ply:GetActiveWeapon():GetClass()=="ix_hands" and ( (ply.nextElectricJump or 0)<=CurTime() ) and !ply.failedHardkor and  PLUGIN:CanClimbOnPole(ply) ) then
        print((ply.nextElectricJump or 0)<=CurTime())
        ply:SetLocalVelocity(ply:GetAimVector() * 400)
        local Vel = ply:GetVelocity()
        ply:SetVelocity(Vector(0, 0, 240 - 15 * 1 - Vel.z))
        ply.nextElectricJump = CurTime()+0.5
    end
end

