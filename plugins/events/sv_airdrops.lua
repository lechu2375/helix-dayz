local PLUGIN = PLUGIN

airdrops = airdrops or {}

local airdropModel = "models/gmodz/airdrops/supplycrate.mdl"
local parachuteModel = "models/gmodz/airdrops/parachute.mdl"
function airdrops.SpawnAtPos(pos,itemsAmount)

    local trace = util.QuickTrace( pos, Vector(0,0,9999))
    trace.HitPos:Sub(Vector(0,0,300))
    local supplyCrate = ents.Create("ix_container") 
    supplyCrate:SetModel( airdropModel)
    supplyCrate:SetPos(trace.HitPos )
    
    supplyCrate:Spawn()
    supplyCrate:EmitSound("Trainyard.wind_gust1",80)
    
    ix.inventory.New(0, "container:" .. "models/gmodz/airdrops/supplycrate.mdl", function(inventory)
        -- we'll technically call this a bag since we don't want other bags to go inside
        inventory.vars.isBag = true
        inventory.vars.isContainer = true

        if (IsValid(supplyCrate)) then
            supplyCrate:SetInventory(inventory)
            ix.plugin.list.containers:SaveContainer()
        end
    end)
    //itemID = Schema.GetRandomWeightedItem(v.scale, true)

    local inv = supplyCrate:GetInventory()
    for i=1,itemsAmount do
        inv:Add(Schema.GetRandomWeightedItem(0.01, true), 1)
    end

    timer.Simple(60*60*3, function()
        if(IsValid(supplyCrate)) then
            supplyCrate:Remove()
        end      
    end)

   local id = supplyCrate:GetCreationID()
    timer.Create("parachuteRemover"..id, 0.5, 0, function()
        if(!supplyCrate or !supplyCrate.parachute) then
            timer.Remove("parachuteRemover"..id)
            return
        end
        if(IsValid(supplyCrate.parachute) and supplyCrate:GetPhysicsObject():IsAsleep()) then
            supplyCrate.parachute:Remove()
        end
    
    end)

    supplyCrate.parachute = ents.Create("prop_physics") 
    supplyCrate.parachute:SetModel( parachuteModel)
    supplyCrate.parachute:SetPos(trace.HitPos)
    supplyCrate.parachute:SetCollisionGroup(COLLISION_GROUP_WORLD)
    supplyCrate.parachute:SetGravity( 0)
    supplyCrate.parachute:Spawn()
    constraint.Weld( supplyCrate, supplyCrate.parachute, 0,0,0,true,false)
end