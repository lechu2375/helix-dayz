
local PLUGIN = PLUGIN


PLUGIN.eventCityInvasion = {}
evci = PLUGIN.eventCityInvasion
evci.hostages = evci.hostages or {}
evci.zombies = evci.zombies or {}
evci.guards = evci.guards or {}
evci.EventTimer = evci.EventTimer or nil
evci.IsRunning = false
evci.NextBotsPositions = {
    Vector(-2704.5671386719,7535.115234375,48.196334838867),
    Vector(-2860.9677734375,7634.9970703125,55.947677612305),
    Vector(-2717.88671875,7877.1166992188,48),
    Vector(-2694.1076660156,8276.9091796875,48),
    Vector(-2473.8022460938,8780.7919921875,48.088413238525),
    Vector(-1951.2763671875,8964.5078125,48.670394897461),
    Vector(-1679.1151123047,8967.29296875,48.003845214844),
    Vector(-1419.3284912109,8976.9228515625,48.000007629395),
    Vector(-1641.1372070313,9614.7861328125,170.43022155762),
    Vector(-2119.9982910156,9538.3603515625,173.43420410156),
    Vector(-2706.6499023438,9663.7939453125,234.39880371094),
    Vector(-3129.7995605469,9489.4326171875,247.38661193848),
    Vector(-3977.5869140625,9136.03515625,238.4535369873),
    Vector(-3951.7846679688,8894.89453125,195.94256591797),
    Vector(-1712.7447509766,8290.197265625,48),
    Vector(-849.65777587891,8945.8876953125,48),
    Vector(-586.93890380859,8765.1181640625,48),
    Vector(198.73512268066,8637.4794921875,48),
    Vector(715.15844726563,8615.0791015625,48.000015258789),
    Vector(1129.2202148438,8581.4150390625,48),
    Vector(1357.2397460938,8262.7470703125,48),
    Vector(1003.3895263672,8372.8671875,48),
    Vector(1327.8393554688,8013.9545898438,48),
    Vector(1467.2095947266,7735.9458007813,48),

}
evci.HostagesPositions 		=	{ //well
    Vector(126.51190185547,3866.2192382813,504.03125),
    Vector(278.12701416016,3836.2150878906,504.03125),
    Vector(452.14050292969,3872.8591308594,504.03125),
    Vector(178.46530151367,4036.4655761719,376.03125),
}
evci.ArmoredGuardsPost 	=	{ 
    Vector(576.92993164063,3544.4265136719,40.03125),
    Vector(-189.69728088379,3352.859375,40.03125),
    Vector(286.62097167969,3818.8427734375,48.031257629395),
    Vector(680.42266845703,3784.8774414063,184.03125),
    Vector(1030.8247070313,3545.8034667969,40.03125),
    Vector(819.77966308594,3122.2416992188,40.03125),
}

evci.NextBotsClasses = {"nb_zombine","nb_type1","nb_infected_citizen","nb_type3","nb_seeker"}
evci.TargetDestination = Vector("179.379410 4026.378906 530.031250")


function evci.AreHostageAlive()
    local count = 0
    for _,v in pairs(evci.hostages) do
        if(IsValid(v)) then
            count = count+1
        end
    end
    if(count==0) then 
        return false 
    else 
        return count 
    end

end
function evci.GetFirstAliveHostage()

    for _,v in pairs(evci.hostages) do
        if(IsValid(v)) then
            return v
        end
    end
    return false
end
function evci.EventCleanup()
    if(timer.Exists("evci.EventTimer")) then timer.Remove("evci.EventTimer") end
    if(timer.Exists("evci.WaveTimer")) then timer.Remove("evci.WaveTimer") end
    if(IsValid(evci.destination)) then
        evci.destination:Remove()
    end
    for k,v in pairs(evci.zombies) do
        if(IsValid(v)) then v:Remove() end
        evci.zombies[k] = nil
    end
    for k,v in pairs(evci.guards) do
        if(IsValid(v)) then v:Remove() end
        evci.guards[k] = nil
    end
    for k,v in pairs(evci.hostages) do
        if(IsValid(v)) then v:Remove() end
        evci.hostages[k] = nil
    end   
    evci.IsRunning = false
end
function evci.StartEvent(waveSize, wavesAmount)
    evci.IsRunning = true
    for _,v in pairs(player.GetAll()) do //fade so players wont notice lag due to spawning npc
        v:ScreenFade( SCREENFADE.PURGE, color_black,0.1, 1.5 )
    end

    evci.EventCleanup() //In case if someone would do the same command second time


    evci.destination = ents.Create("nb_citizen") //XDD spawn citizen then for every zombie set him as enemy so they will run to his position
    evci.destination:SetPos(evci.TargetDestination)
    evci.destination:SetCollisionGroup(COLLISION_GROUP_NONE)
    evci.destination:Spawn()
    evci.destination:DropToFloor()
    //evci.destination:SetColor( Color( 0, 0, 0, 0 ) ) //invisible so player won't see him
    //evci.destination:SetRenderMode( RENDERMODE_TRANSCOLOR ) 
    local npc
    local position = 1
    local posPointer = 0
    local class = ""
    local delay
    for wave=1,wavesAmount do
        delay  = (wave-1)*120
        if(wave ==1) then 
            delay = 0
            PrintMessage(HUD_PRINTTALK, "Horda zombie zbliża się do miasta!")
        end
        
        timer.Create("evci.WaveTimer",120, wavesAmount-1, function()
            PrintMessage(HUD_PRINTTALK, "Kolejna horda zombie zbliża się do miasta!")
        end)
        for i=1,waveSize do //zombie spawner
            timer.Simple(delay+math.Rand(0,2.30),function() //timer to avoid npc stuck even with changed collision group
                if(!timer.Exists("evci.EventTimer")) then return end
                class = table.Random(evci.NextBotsClasses) 
                if(i==1) then class = "nb_boss_gargantuan" end
                npc = ents.Create(class)
                posPointer = posPointer + 1
                if(#evci.NextBotsPositions<posPointer) then posPointer = 1 end

                npc:SetPos(evci.NextBotsPositions[posPointer]+Vector(math.random(40,120),0,0))
                npc:SetEnemy(evci.destination)
                npc:SetSolid(SOLID_NONE)
                npc:SetCollisionGroup(COLLISION_GROUP_NONE)
                npc:Spawn()
                npc:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
                npc:DropToFloor()

                evci.zombies[position] = npc
                position = position + 1
            end)
        end
    end

    local citizens = {}
    for k,v in pairs(evci.HostagesPositions) do //citizen spawner
        local npc = ents.Create("nb_citizen") //citizens without weapons
        npc:SetPos(v)
        npc:SetCollisionGroup(COLLISION_GROUP_NONE)
        npc:Spawn()
        npc:DropToFloor()
        citizens[k] = npc
    end
    evci.hostages = citizens

    for k,v in pairs(evci.ArmoredGuardsPost) do //guardians spawner
        local npc = ents.Create("nb_swat") //guards npcs
        npc:SetPos(v)
        npc:SetCollisionGroup(COLLISION_GROUP_NONE)
        npc:Spawn()
        npc:DropToFloor()
        evci.guards[k] = npc
    end
    
    //printnpcs()
    evci.EventTimer = timer.Create("evci.EventTimer", 120*wavesAmount, 1, //check after certain amount of time if we should reward player
        function()
            local shouldReward = true or evci.AreHostageAlive()

            if(shouldReward) then
                local rewardSpawnPos = Vector(815.09545898438,3491.5947265625,40.03125)
                PrintMessage(HUD_PRINTTALK, "Cywile przeżyli! Niedaleko budynku wylądował zrzut.")
                local container = ents.Create("ix_container")
			    container:SetPos(rewardSpawnPos)
			    
			    container:SetModel("models/gmodz/airdrops/supplycrate.mdl")
                container:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			    container:Spawn()

			ix.inventory.New(0, "container:" .. "models/gmodz/airdrops/supplycrate.mdl", function(inventory)
				-- we'll technically call this a bag since we don't want other bags to go inside
				inventory.vars.isBag = true
				inventory.vars.isContainer = true

				if (IsValid(container)) then
					container:SetInventory(inventory)
					ix.plugin.list.containers:SaveContainer()
				end
			end)
            local RandomItems = ix.plugin.list.merchant:SetRandomItems(math.random(30, 40))
                local inv = container:GetInventory()
                for k,v in pairs(RandomItems) do
                    //print(v.uniqueID, v.data.quantity)
                    inv:Add(v.uniqueID, v.data.quantity)
                end
            else
                evci.EventCleanup()
                PrintMessage(HUD_PRINTTALK, "Cywile zostali pożarci przez zombie!")
            end
        end
    )
end



function PLUGIN:OnNextbotDeath(npc)
    print("NB DEATH",npc,"died")
    local nextTarget = evci.GetFirstAliveHostage()
    if(!IsValid(evci.destination) and !nextTarget and evci.IsRunning) then
        evci.EventCleanup()
        PrintMessage(HUD_PRINTTALK, "Cywile zostali pożarci przez zombie!")
        return
    end
    if(npc==evci.destination) then
        

        for k,v in pairs(evci.zombies) do
            evci.destination = evci.GetFirstAliveHostage()
            v:SetEnemy(evci.destination)
        end
    end
end