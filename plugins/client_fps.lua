PLUGIN.name = "Boost FPS"
PLUGIN.author = "STEAM_0:1:29606990 && Lechu2375"
PLUGIN.description = ""

local fogCtrl = ents.FindByClass("env_fog_controller")
if(fogCtrl[1]) then
	fogCtrl[1]:Fire("SetFarZ", 4000)
	fogCtrl[1]:Fire("SetStartDist",0)
	fogCtrl[1]:Fire("SetEndDist",3200)
	fogCtrl[1]:Fire("SetMaxDensity",1.0)
	//fogCtrl[1]:Fire("SetColor",22,28,31)
end
do
	local hooks = {
		{'PostDrawEffects', 'RenderWidgets'},
		{'PlayerTick', 'TickWidgets'},
		{'PlayerInitialSpawn', 'PlayerAuthSpawn'},
		{'RenderScene', 'RenderStereoscopy'},
		{'LoadGModSave', 'LoadGModSave'},
		{"RenderScreenspaceEffects", "RenderColorModify"},
		{"RenderScreenspaceEffects", "RenderBloom"},
		{"RenderScreenspaceEffects", "RenderToyTown"},
		{"RenderScreenspaceEffects", "RenderTexturize"},
		{"RenderScreenspaceEffects", "RenderSunbeams"},
		{"RenderScreenspaceEffects", "RenderSobel"},
		{"RenderScreenspaceEffects", "RenderSharpen"},
		{"RenderScreenspaceEffects", "RenderMaterialOverlay"},
		{"RenderScreenspaceEffects", "RenderMotionBlur"},
		{"RenderScene", "RenderSuperDoF"},
		{"GUIMousePressed", "SuperDOFMouseDown"},
		{"GUIMouseReleased", "SuperDOFMouseUp"},
		{"PreventScreenClicks", "SuperDOFPreventClicks"},
		{"PostRender", "RenderFrameBlend"},
		{"PreRender", "PreRenderFrameBlend"},
		{"Think", "DOFThink"},
		{"RenderScreenspaceEffects", "RenderBokeh"},
		{"NeedsDepthPass", "NeedsDepthPass_Bokeh"},
		{"PostDrawEffects", "RenderWidgets"},
		{"PostDrawEffects", "RenderHalos"},
	}

	hook.Add('Initialize', 'hlib.widgets', function()
		hook.Remove('Initialize', 'hlib.widgets')

		for k, v in ipairs(hooks) do
			hook.Remove(v[1], v[2])
		end

		widgets.PlayerTick = nil

		timer.Remove("HostnameThink")
		timer.Remove("CheckHookTimes")

		hooks = nil
	end)
end

if (CLIENT) then
	ix.option.Add("entityShadows", ix.type.bool, false, {
		category = "performance"
	})

	do
		local bad_ents = {['class C_PhysPropClientside'] = true, ['class C_ClientRagdoll'] = true}
		timer.Create("CleanupGarbage", 60, 0, function()
			for _, v in ipairs(ents.GetAll()) do
				if (bad_ents[v:GetClass()]) then
					SafeRemoveEntity(v)
					RunConsoleCommand('r_cleardecals')
				end
			end
		end)
	end
	timer.Simple(10, function()
		RunConsoleCommand( "cl_detaildist",3000)
		RunConsoleCommand( "cl_detailfade",2800)	
	end)

	hook.Add("OnEntityCreated", "GmodZ.DisableShadows", function(entity)
		if (ix.option.Get("entityShadows", true)) then
			entity:DrawShadow(false)
		end
	end)

	hook.Add("InitPostEntity", "GmodZ.DisableShadows", function()
		if (ix.option.Get("entityShadows", true)) then
			for _, entity in ipairs(ents.GetAll()) do
				entity:DrawShadow(false)
			end
		end
	end)
end

if (SERVER) then
	hook.Add("PropBreak", "RPGM.AntiConstraintCrash", function(attacker, ent)
		if IsValid(ent) and ent:GetPhysicsObject():IsValid() then
			constraint.RemoveAll(ent)
		end
	end)
end

local toPrecache = "grabber_0"

for i=1,9 do
	util.PrecacheModel(toPrecache..i..".mdl")
end

toPrecache = "infected_0"

for i=1,9 do
	util.PrecacheModel(toPrecache..i..".mdl")
end

toPrecache = "seeker_0"

for i=1,3 do
	util.PrecacheModel(toPrecache..i..".mdl")
end

toPrecache = "freshdead_0"

for i=1,7 do
	util.PrecacheModel(toPrecache..i..".mdl")
end

timer.Create( "removeRagdolls", 30, 0, function() game.RemoveRagdolls() end )
/*
if(CLIENT) then

    function PLUGIN:CreateClientsideRagdoll(entity,ragdoll )
        timer.Simple(30, function()
            if(IsValid(ragdoll)) then
                ragdoll:Remove()
            end
        end)
    end
    
end*/