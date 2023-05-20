local PLUGIN = PLUGIN
local effectdata = EffectData()
effectdata:SetMagnitude(200)
function PLUGIN:ShouldCollide(ent1,ent2)
    if(ent1.explodes) then

        if(ent1.nextExplosion<=CurTime()) then
            ent1.nextExplosion = CurTime()+.1
            local min, max = ent1:GetCollisionBounds()
            local RandomPos = Vector(math.random(min.x, max.x),math.random(min.y, max.y),math.random(min.z, max.z))
            effectdata:SetOrigin( ent1:LocalToWorld(RandomPos) )
            util.Effect( "Explosion", effectdata )
        end
    end
end



helicrash = helicrash or {}
local crashSite = Vector(-7160.912109375,4747.7392578125,428.04818725586)
local heliModel = "models/gmodz/airdrops/heli_uh60_fly.mdl"
local crashedHeliModel = "models/gmodz/airdrops/heli_uh60_crush.mdl"
local heliPassSound = "helicopterPreCrash"
local crashSound = ""
local explosionSound = "BaseExplosionEffect.Sound"
function helicrash.TestCrash(pos)


        local trace = util.QuickTrace( pos, Vector(0,0,9999))
        local heliProp = ents.Create("prop_physics") 
        heliProp:SetModel( heliModel)
        heliProp:SetPos(trace.HitPos-Vector(0,0,200) )
        heliProp:EmitSound( heliPassSound)
        local angles = Angle(0,0,0)
        angles:Random()
        heliProp:SetCustomCollisionCheck(true)
        heliProp:SetAngles(angles)
        heliProp:Spawn()
        heliProp:GetPhysicsObject():SetMass(heliProp:GetPhysicsObject():GetMass()/2)
        heliProp.explodes = true
        heliProp.nextExplosion = CurTime()


        
        local min,max = heliProp:GetCollisionBounds()
        max = heliProp:LocalToWorld(max)
        heliProp:GetPhysicsObject():ApplyForceOffset(Vector(1.1,1,0)* 998000, max)

        local id = heliProp:GetCreationID()
        timer.Create("heliRemover"..id, 0.1, 0, function()  

            if(!heliProp) then
                timer.Remove("heliRemover"..id)
                return
            end

            if(IsValid(heliProp) and heliProp:GetPhysicsObject():IsAsleep()) then


                local heliContainer = ents.Create("ix_container") 
                heliContainer:SetModel( crashedHeliModel)
                heliContainer:SetPos(heliProp:GetPos() )
                heliContainer:SetAngles(heliProp:GetAngles())
                heliContainer:Spawn()
                heliContainer:GetPhysicsObject():EnableMotion(false)
                
                ix.inventory.New(0, "container:" .. crashedHeliModel, function(inventory)
                    -- we'll technically call this a bag since we don't want other bags to go inside
                    inventory.vars.isBag = true
                    inventory.vars.isContainer = true
            
                    if (IsValid(heliContainer)) then
                        heliContainer:SetInventory(inventory)
                        ix.plugin.list.containers:SaveContainer()
                    end
                end)
            
                local RandomItems = ix.plugin.list.merchant:SetRandomItems(40)
                local inv = heliContainer:GetInventory()
                for k,v in pairs(RandomItems) do
                    inv:Add(v.uniqueID, v.data.quantity)
                end
                timer.Simple(60*5, function()
                    if(IsValid(heliContainer)) then
                        heliContainer:SetHealth(100)
                        heliContainer:Ignite()
                    end      
                end)
                heliProp:Remove()
            end
            
        end)    
    

end