BWA = BWA or {}

CreateConVar("bwa_enable_cover_system", 1, FCVAR_ARCHIVE, "That is WIP and can be buggy.", 0, 1)
CreateConVar("bwa_cover_system_min_delay", 30, FCVAR_ARCHIVE, "That is WIP and can be buggy.", 5)
CreateConVar("bwa_cover_system_max_delay", 60, FCVAR_ARCHIVE, "That is WIP and can be buggy.", 10)
CreateConVar("bwa_enable_follow_to_commander", 1, FCVAR_ARCHIVE, "That is WIP and can be buggy.", 0, 1)
CreateConVar("bwa_friends", 0, FCVAR_ARCHIVE, "Not bugged.", 0, 1)
CreateConVar("bwa_invasion_mode", 0, FCVAR_DONTRECORD, "Enable spawn npcs on map.", 0, 1)
CreateConVar("bwa_invasion_mode_ann", 1, FCVAR_ARCHIVE, "", 0, 1)
CreateConVar("bwa_invasion_mode_jet_background", 1, FCVAR_ARCHIVE, "", 0, 1)
CreateConVar("bwa_invasion_mode_max_npcs", 20, FCVAR_ARCHIVE, "", 1, 100)
CreateConVar("bwa_invasion_mode_delay", 2, FCVAR_ARCHIVE, "", 0.01)
CreateConVar("bwa_invasion_mode_delay_special", 5, FCVAR_ARCHIVE, "", 1)
CreateConVar("bwa_invasion_mode_delay_heli", 45, FCVAR_ARCHIVE, "", 5)
CreateConVar("bwa_invasion_mode_delay_boss", 60, FCVAR_ARCHIVE, "", 1)
CreateConVar("bwa_invasion_mode_min_dist", 512, FCVAR_ARCHIVE, "", 0)
CreateConVar("bwa_invasion_mode_max_dist", 2048, FCVAR_ARCHIVE, "", 0)

BWA.invasion_mode = false
BWA.invasion_mode_delay = 2
BWA.invasion_mode_delay_special = 5
BWA.invasion_mode_delay_heli = 45
BWA.invasion_mode_delay_boss = 60
BWA.invasion_mode_max_alives = 20
BWA.invasion_mode_min_dist = 512
BWA.invasion_mode_max_dist = 2048
BWA.invasion_table_special = {"bwaaf_stealth", "bwaaf_medic", "bwaaf_sniper", "bwaaf_machinegunner", "bwaaf_grenadier", "bwaaf_shield", "bwacc_riot", "bwacc_patrol"}

if SERVER then

local bwa_can_spawn = true
local bwa_can_spawn_special = true
local bwa_can_spawn_heli = true
local bwa_can_spawn_boss = true
local bwa_start_siren = true
local bwa_can_jet_fly = true

concommand.Add("bwa_invasion_mode_reset_settings", function(ply)
    if ply:IsSuperAdmin() then
        ply:ChatPrint('Invasion settings in resetted!')
        ply:EmitSound('buttons/blip1.wav')
        RunConsoleCommand("bwa_invasion_mode", 0)
        RunConsoleCommand("bwa_invasion_mode_ann", 1)
        RunConsoleCommand("bwa_invasion_mode_jet_background", 1)
        RunConsoleCommand("bwa_invasion_mode_max_npcs", 20)
        RunConsoleCommand("bwa_invasion_mode_delay", 2)
        RunConsoleCommand("bwa_invasion_mode_delay_special", 5)
        RunConsoleCommand("bwa_invasion_mode_delay_heli", 45)
        RunConsoleCommand("bwa_invasion_mode_delay_boss", 60)
        RunConsoleCommand("bwa_invasion_mode_min_dist", 512)
        RunConsoleCommand("bwa_invasion_mode_max_dist", 2048)
    else
        ply:ChatPrint('You are not superadmin!')
        ply:EmitSound('buttons/button1.wav')
    end
end)

function BWA:GetNPCToSpawn(special, heli, boss)
    if not special and not heli and not boss then
        return "bwaaf_soldier"
    elseif special then
        return BWA.invasion_table_special[math.random(1,#BWA.invasion_table_special)]
    elseif heli then
        return "bwa_infil"
    elseif boss then
        return "bwaaf_commander"
    end
end

local navmeshes = {}
timer.Simple(15, function()
    navmeshes = navmesh.GetAllNavAreas()
    if #navmeshes > 0 then
        print("[BWA Invasion Mode] Navmesh loaded!")
    else
        print("[BWA Invasion Mode] Navmesh not exist on this map!")
    end
end)        

function BWA:GetBestPosToSpawn(heli)
    local distance, distance2 = BWA.invasion_mode_min_dist^2, BWA.invasion_mode_max_dist^2
    local tab2 = {}
    if #navmeshes > 0 then
        for _, nav in ipairs(navmeshes) do
            for _, p in ipairs(player.GetHumans()) do
                if p:Alive() then
					if not heli then
						local dist = p:GetPos():DistToSqr(nav:GetCenter())
						if not p:VisibleVec(nav:GetCenter()) and dist > distance and dist < distance2 then
							tab2[#tab2+1] = nav:GetCenter()
						end
					else
						local tr = util.TraceLine( {
							start = nav:GetCenter()+Vector(0,0,8),
							endpos = nav:GetCenter()+Vector(0,0,99999)
						} )

						local tr2 = util.TraceLine( {
							start = nav:GetCenter()-Vector(0,100,0)+Vector(0,0,8),
							endpos = nav:GetCenter()+Vector(0,100,0)+Vector(0,0,8)
						} )

						local tr3 = util.TraceLine( {
							start = nav:GetCenter()-Vector(100,0,0)+Vector(0,0,8),
							endpos = nav:GetCenter()+Vector(100,0,0)+Vector(0,0,8)
						} )

						local dist = p:GetPos():DistToSqr(nav:GetCenter())
						if dist > distance and dist < distance2 and tr.HitSky and not tr2.HitWorld and not tr3.HitWorld then
							tab2[#tab2+1] = nav:GetCenter()
						end
					end
                end
            end
        end
        if table.IsEmpty(tab2) then
            return false
        else
			return tab2[math.random(#tab2)]
        end
    else
        return false
    end
end

function BWA:CopyBodygroups(source, target)
    if not IsValid(source) or not IsValid(target) then return end

    local bg = {}

    for i=0,#source:GetBodyGroups()-1 do 
        bg[#bg+1] = source:GetBodygroup(i)
    end

    for k, v in pairs(bg) do
		target:SetBodygroup(k-1,v)
	end
end

function BWA:TransferBonePosition( base, ragdoll )
	if !IsValid( base ) or !IsValid( ragdoll ) then return end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

function BWA:CountAlives(boss, invasion)
    local tab = {}

    if not boss then
        for _, ent in ipairs(ents.FindByClass('bwaaf_*')) do
            if ent:IsNextBot() then
                table.insert(tab, ent)
            end
        end
    elseif boss then
        for _, ent in ipairs(ents.FindByClass('bwaaf_commander')) do
            table.insert(tab, ent)
        end
    elseif invasion then
        for _, ent in ipairs(ents.FindByClass('bwaaf_*')) do
            if ent:IsNextBot() and ent.invasion then
                table.insert(tab, ent)
            end
        end
    end

    return #tab
end

function BWA:JetBackground()
    local pos = BWA:GetBestPosToSpawn(true)
    local tr = util.TraceLine( {
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    } )

    local height = math.Clamp(tr.HitPos:Distance(pos)-256, 512, 4096)
    local randang = math.random(0,360)

    for i=1,math.random(1,3) do
        local airm = ents.Create('prop_dynamic')
        timer.Simple(0+i, function()
            airm:SetModel('models/blackwatcharmy_nextbots/veh/a10.mdl')
            airm:SetPos(pos+Vector(0,0,height))
            airm:SetAngles(Angle(0,randang, 0))
            airm:Spawn()
            airm:ResetSequence('strafing run')
            airm:EmitSound('ambient/machines/aircraft_distant_flyby3.wav', 511, math.random(95,105), 1, CHAN_STATIC)
        end)

        timer.Simple(7+i, function()
            if !IsValid(airm) then return end
            airm:EmitSound('bwa_veh/a10.wav', 511, math.random(95,105), 1, CHAN_STATIC)
        end)

        timer.Simple(12+i, function()
            if !IsValid(airm) then return end
            airm:Remove()
        end)
    end
end

function BWA:CallAirstrike(ent)
    local pos = ent:GetPos()
    local tr = util.TraceLine( {
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    } )

    if not tr.HitSky then return end

    local height = math.Clamp(tr.HitPos:Distance(pos)-256, 512, 4096)

    local airm = ents.Create('prop_dynamic')
    airm:SetModel('models/blackwatcharmy_nextbots/veh/a10.mdl')
    airm:SetPos(pos+Vector(0,0,height))
    airm:SetAngles(Angle(0,math.random(0,360), 0))
    airm:Spawn()
    airm:ResetSequence('strafing run')
    airm:EmitSound('ambient/machines/aircraft_distant_flyby3.wav', 511, math.random(95,105), 1, CHAN_STATIC)

    timer.Simple(7, function()
        if !IsValid(airm) then return end
        airm:EmitSound('bwa_veh/a10.wav', 511, math.random(95,105), 1, CHAN_STATIC)
    end)

    for i=1,4 do
        timer.Simple(8+(i/math.Rand(2,4)), function()
            if !IsValid(airm) then return end
            if IsValid(ent) then
                local pos2 = ent:GetPos()

                local tr = util.TraceLine( {
                    start = pos2,
                    endpos = pos2+Vector(0,0,99999),
                    filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
                } )

                if tr.HitSky then
                    pos = pos2
                end
            end
            local pos2 = pos + Vector(math.random(-300,300),math.random(-300,300),0)
            airm:EmitSound('bwa_veh/a10_explosion.wav', 140)
            ParticleEffect( "explosion_huge_c", pos2, Angle( 0, 0, 0 ) )
            ParticleEffect( "explosion_huge_d", pos2, Angle( 0, 0, 0 ) )
            ParticleEffect( "explosion_huge_h", pos2, Angle( 0, 0, 0 ) )
            util.ScreenShake( pos2, 10, 5, 5, 15000 )
            util.BlastDamage(airm, airm, pos, 512, 512)
        end)
    end

    timer.Simple(15, function()
        if !IsValid(airm) then return end
        airm:Remove()
    end)
end

local function InvasionModeThink()
    BWA.invasion_mode = GetConVar("bwa_invasion_mode"):GetBool()
    BWA.invasion_mode_max_alives = GetConVar("bwa_invasion_mode_max_npcs"):GetFloat()
    BWA.invasion_mode_delay = GetConVar("bwa_invasion_mode_delay"):GetFloat()
    BWA.invasion_mode_delay_special = GetConVar("bwa_invasion_mode_delay_special"):GetFloat()
    BWA.invasion_mode_delay_heli = GetConVar("bwa_invasion_mode_delay_heli"):GetFloat()
    BWA.invasion_mode_delay_boss = GetConVar("bwa_invasion_mode_delay_boss"):GetFloat()
    BWA.invasion_mode_min_dist = GetConVar("bwa_invasion_mode_min_dist"):GetFloat()
    BWA.invasion_mode_max_dist = GetConVar("bwa_invasion_mode_max_dist"):GetFloat()

    if BWA.invasion_mode and BWA:CountAlives() < BWA.invasion_mode_max_alives then
        if bwa_start_siren and GetConVar("bwa_invasion_mode_ann"):GetBool() then
            bwa_start_siren = false
            for _, ply in ipairs(player.GetAll()) do
                ply:SendLua("surface.PlaySound('bwa_other/invasion_mode_start.wav')")
                ply:SendLua("chat.AddText(Color(255,55,55), 'BWA has invaded the territory, be ready to defend!')")
            end
        end
        if bwa_can_spawn then
            local class = BWA:GetNPCToSpawn()
            local pos = BWA:GetBestPosToSpawn()
            if not pos then return end
            bwa_can_spawn = false

            timer.Simple(BWA.invasion_mode_delay, function()
                bwa_can_spawn = true
            end)

            local npc = ents.Create(class)
            npc:SetPos(pos)
            npc:Spawn()
            npc:SetOmniscient(true)
            npc.invasion = true
        end
        if bwa_can_spawn_special then
            local class = BWA:GetNPCToSpawn(true)
            local pos = BWA:GetBestPosToSpawn()
            if not pos then return end
            bwa_can_spawn_special = false

            timer.Simple(BWA.invasion_mode_delay_special, function()
                bwa_can_spawn_special = true
            end)

            local npc = ents.Create(class)
            npc:SetPos(pos)
            npc:Spawn()
            npc:SetOmniscient(true)
            npc.invasion = true
        end
        if bwa_can_spawn_heli and BWA:CountAlives() < BWA.invasion_mode_max_alives/1.25 then
            pos = BWA:GetBestPosToSpawn(true)
            local class = BWA:GetNPCToSpawn(false, true)

            if not pos then return end

            bwa_can_spawn_heli = false

            timer.Simple(BWA.invasion_mode_delay_heli, function()
                bwa_can_spawn_heli = true
            end)

            local npc = ents.Create(class)
            npc:SetPos(pos)
            npc:Spawn()
            npc.invasion = true
        end
        if bwa_can_spawn_boss and BWA:CountAlives(true) < 1 then
            local class = BWA:GetNPCToSpawn(false, false, true)
            local pos = BWA:GetBestPosToSpawn()
            if not pos then return end
            bwa_can_spawn_boss = false

            timer.Simple(BWA.invasion_mode_delay_boss, function()
                bwa_can_spawn_boss = true
            end)

            local npc = ents.Create(class)
            npc:SetPos(pos)
            npc:Spawn()
            npc:SetOmniscient(true)
            npc.invasion = true
        end
        if bwa_can_jet_fly and GetConVar("bwa_invasion_mode_jet_background"):GetBool() then
            bwa_can_jet_fly = false

            timer.Simple(math.random(45,90), function()
                bwa_can_jet_fly = true
            end)
            BWA:JetBackground()
        end
    end
    if not BWA.invasion_mode and BWA:CountAlives(false, true) > 0 then
        bwa_start_siren = true
        for _, ent in ipairs(ents.FindByClass('bwa*')) do
            if ent.invasion then
                ent:Remove()
            end
        end
    end
end

hook.Add("Think", "BWA_Invasion", InvasionModeThink)

else --client part

    hook.Add("PopulateToolMenu", "BWAExpandMenu", function()
        spawnmenu.AddToolMenuOption("DrGBase", "BWA Nextbots", "BWAServer", "Server Settings", "", "", function(panel)
            panel:ClearControls()
            panel:CheckBox("Friendly to player faction?", "bwa_friends")
            panel:ControlHelp("BWA will friends to player faction.")
            panel:CheckBox("Enable Follow Leader System?", "bwa_enable_follow_to_commander")
            panel:ControlHelp("3 BWA Soldiers will defend commander. Its can be buggy and its in W.I.P!")
            panel:CheckBox("Enable Cover System?", "bwa_enable_cover_system")
            panel:ControlHelp("BWA will try find place for cover and ambush. Its can be buggy and its in W.I.P!")
            panel:NumSlider("Min delay to find cover?", "bwa_cover_system_min_delay", 5, 180, 0)
            panel:ControlHelp("Minimum delay in random to find cover for npc.")
            panel:NumSlider("Max delay to find cover?", "bwa_cover_system_max_delay", 10, 180, 0)
            panel:ControlHelp("Maximum delay in random to find cover for npc.")
        end)
        spawnmenu.AddToolMenuOption("DrGBase", "BWA Nextbots", "BWAServer2", "Invasion Settings", "", "", function(panel)
            panel:ClearControls()
            panel:CheckBox("Enable Invasion Mode?", "bwa_invasion_mode")
            panel:ControlHelp("BWA will invasion your map.")
            panel:Help("-----Settings-----")
            panel:CheckBox("Do announcment on invasion?", "bwa_invasion_mode_ann")
            panel:ControlHelp("Siren and text will appear on invasion.")
            panel:CheckBox("Enable A10 on background?", "bwa_invasion_mode_jet_background")
            panel:ControlHelp("A10 will appear on invasion and will fly.")
            panel:NumSlider("Max Alive NPCs?", "bwa_invasion_mode_max_npcs", 1, 100, 0)
            panel:ControlHelp("Max count of alive invasion npcs.")
            panel:NumSlider("Min Distance to spawn?", "bwa_invasion_mode_min_dist", 0, 2048, 0)
            panel:ControlHelp("Minimal distance from player to spawn bwa npcs.")
            panel:NumSlider("Max Distance to spawn?", "bwa_invasion_mode_max_dist", 0, 2048, 0)
            panel:ControlHelp("Maximum distance from player to spawn bwa npcs.")
            panel:NumSlider("Delay to spawn soldiers?", "bwa_invasion_mode_delay", 0.01, 60, 2)
            panel:ControlHelp("Time before new soldier will spawn.")
            panel:NumSlider("Delay to spawn commander?", "bwa_invasion_mode_delay_boss", 1, 180, 0)
            panel:ControlHelp("Time before new commander will spawn.")
            panel:NumSlider("Delay to spawn special?", "bwa_invasion_mode_delay_special", 1, 180, 0)
            panel:ControlHelp("Time before new special will spawn.")
            panel:NumSlider("Delay to spawn heli?", "bwa_invasion_mode_delay_heli", 5, 180, 0)
            panel:ControlHelp("Time before new helicopter will spawn.")
            panel:Button("RESET SETTINGS", "bwa_invasion_mode_reset_settings")
        end)
    end)

end