local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "logging")
	else
		return GAS:PhraseFormat(phrase, "logging", ...)
	end
end

GAS.Logging.Scenes = {}

if (SERVER) then
	GAS:netInit("logging:ViewScene")
	GAS:netReceive("logging:ViewScene", function(ply)
		local scene_id = net.ReadUInt(16)
		local beginning = net.ReadBool()
		if (not GAS.Logging.Permissions:CanAccessModule(ply, GAS.Logging.PVP_COMBAT_MODULE)) then return end
		if (GAS.Logging.PvP.CombatScenes[scene_id]) then
			GAS:netStart("logging:ViewScene")
				net.WriteUInt(scene_id, 16)
				net.WriteBool(beginning)
				local data = util.Compress(GAS:SerializeTable(GAS.Logging.PvP.CombatScenes[scene_id].Scenes))
				net.WriteData(data, #data)
			net.Send(ply)
		end
	end)
else
	surface.CreateFont("GAS_Logging_Scene_HUD_1", {
		font = "Circular Std Medium",
		size = 48
	})

	surface.CreateFont("GAS_Logging_Scene_HUD_2", {
		font = "Circular Std Medium",
		size = 28
	})

	local red = Color(255,0,0)
	local green = Color(0,255,0)
	local white = Color(255,255,255)
	local black = Color(0,0,0)

	local red_laser = Material("cable/redlaser")
	local red_laser_dot = Material("sprites/glow04_noz")

	local green_laser = CreateMaterial("gas_logging_scene_greenlaser", "UnlitGeneric", {
		["$basetexture"] = "sprites/purplelaser1",
		["$translucent"] = "1",
		["$vertexcolor"] = "1",
		["$color"] = "5 1 1"
	})
	local green_laser_dot = Material("sprites/glow04_noz")

	local function IgnoreZ_RenderOverride(self)
		cam.IgnoreZ(true) self:DrawModel() cam.IgnoreZ(false)
	end

	GAS_Logging_Scenes_Ents = GAS_Logging_Scenes_Ents or {}

	GAS.Logging.Scenes.SceneEnts = {}
	GAS.Logging.Scenes.CachedData = {}
	GAS.Logging.Scenes.Instigators = {}
	GAS.Logging.Scenes.Victims = {}
	GAS.Logging.Scenes.TraceDrawers = {}
	GAS.Logging.Scenes.OriginCallbacks = {}

	function GAS.Logging.Scenes:Clear()
		for ent in pairs(GAS_Logging_Scenes_Ents) do
			if (not IsValid(ent)) then continue end
			ent:Remove()
		end
		GAS_Logging_Scenes_Ents = {}
		GAS.Logging.Scenes.SceneEnts = {}
		GAS.Logging.Scenes.Instigators = {}
		GAS.Logging.Scenes.Victims = {}
		GAS.Logging.Scenes.TraceDraw = {}
		GAS.Logging.Scenes.HUDDraw = {}
	end
	GAS.Logging.Scenes:Clear()

	function GAS.Logging.Scenes:CreatePlayer(ply_scene_obj)
		if (ply_scene_obj == nil) then return end
		
		local ent = ClientsideModel(ply_scene_obj[GAS.Logging.PvP_SCENE_MODEL], RENDERGROUP_TRANSLUCENT)
		ent.RenderOverride = IgnoreZ_RenderOverride

		GAS_Logging_Scenes_Ents[ent] = true

		ent.bVGUI_RenderScene_ForceDraw = true
		ent:SetPos(ply_scene_obj[GAS.Logging.PvP_SCENE_POS])
		ent:SetAngles(ply_scene_obj[GAS.Logging.PvP_SCENE_ANG])

		if (ply_scene_obj[GAS.Logging.PvP_SCENE_SEQUENCE]) then
			ent:ResetSequence(ply_scene_obj[GAS.Logging.PvP_SCENE_SEQUENCE])
		end

		if (ply_scene_obj[GAS.Logging.PvP_SCENE_HEAD_ANG]) then
			local head = ent:LookupBone("ValveBiped.Bip01_Head1")
			if (head and head ~= 0) then
				local x = ent:GetBonePosition(head)
				local y = ply_scene_obj[GAS.Logging.PvP_SCENE_SHOOT_POS]
				ent:ManipulateBoneAngles(head, Angle(0, (x - y):Angle().p, 0))
			end
		end

		local wep
		if (ply_scene_obj[GAS.Logging.PvP_SCENE_WEAPON_MDL]) then
			wep = ClientsideModel(ply_scene_obj[GAS.Logging.PvP_SCENE_WEAPON_MDL], RENDERGROUP_TRANSLUCENT)
			wep.bLogs_Scene_Ent = true
			wep.RenderOverride = IgnoreZ_RenderOverride

			GAS_Logging_Scenes_Ents[wep] = true

			wep.bVGUI_RenderScene_ForceDraw = true
			wep:SetParent(ent)
			wep:SetPos(ent:GetPos())
			wep:SetAngles(ent:GetAngles())
			wep:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION)
			wep:SetSolid(SOLID_NONE)
			wep:AddEffects(EF_BONEMERGE)
		end

		function ent:GetPlayerColor()
			return ply_scene_obj[GAS.Logging.PvP_SCENE_PLY_COLOR]
		end
		function ent:GetWeaponColor()
			return ply_scene_obj[GAS.Logging.PvP_SCENE_WEP_COLOR]
		end

		local vehicle
		if (ply_scene_obj[GAS.Logging.PvP_SCENE_VEHICLE_MODEL]) then
			vehicle = ClientsideModel(ply_scene_obj[GAS.Logging.PvP_SCENE_VEHICLE_MODEL], RENDERGROUP_TRANSLUCENT)
			vehicle.bLogs_Scene_Ent = true
			vehicle.RenderOverride = IgnoreZ_RenderOverride

			GAS_Logging_Scenes_Ents[vehicle] = true

			vehicle.bVGUI_RenderScene_ForceDraw = true
			vehicle:SetPos(ply_scene_obj[GAS.Logging.PvP_SCENE_VEHICLE_POS])
			vehicle:SetAngles(ply_scene_obj[GAS.Logging.PvP_SCENE_VEHICLE_ANG])
			vehicle:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION)
			vehicle:SetSolid(SOLID_NONE)

			ent:SetParent(vehicle, ply_scene_obj[GAS.Logging.PvP_SCENE_VEHICLE_ATTACHMENT] or nil)
			local matrix = ent:GetParentWorldTransformMatrix()
			ent:SetPos(matrix:GetTranslation())
			ent:SetAngles(matrix:GetAngles())
		end

		return ent, wep, vehicle
	end

	function GAS.Logging.Scenes:ClearScene(scene_id, beginning)
		local k = tostring(scene_id)
		if (beginning) then k = k .. "!" end

		GAS.Logging.Scenes.TraceDraw[k] = nil
		GAS.Logging.Scenes.HUDDraw[k] = nil

		if (GAS.Logging.Scenes.SceneEnts[k]) then
			for _,ent in pairs(GAS.Logging.Scenes.SceneEnts[k]) do
				if (not IsValid(ent)) then continue end
				local f = false
				for i,ent2 in ipairs(GAS.Logging.Scenes.Victims) do
					if (ent2 == ent) then
						f = true
						table.remove(GAS.Logging.Scenes.Victims, i)
						break
					end
				end
				if (not f) then
					for i,ent2 in ipairs(GAS.Logging.Scenes.Instigators) do
						if (ent2 == ent) then
							table.remove(GAS.Logging.Scenes.Instigators, i)
							break
						end
					end
				end

				GAS_Logging_Scenes_Ents[ent] = nil
				ent:Remove()
			end
			GAS.Logging.Scenes.SceneEnts[k] = nil
		end

		if (beginning == nil) then GAS.Logging.Scenes:ClearScene(scene_id, true) end
	end
	function GAS.Logging.Scenes:SetupScene(scene_id, beginning, data, origin_callback)
		local k = tostring(scene_id)
		if (beginning) then k = k .. "!" end
		local scene_obj
		if (beginning) then
			scene_obj = data.Start
		elseif (data.End) then
			scene_obj = data.End
		else
			return
		end
		if (not scene_obj[1] or not scene_obj[2]) then return end

		if (GAS.Logging.Scenes.ViewingScene ~= nil and GAS.Logging.Scenes.ViewingScene ~= scene_id) then
			GAS.Logging.Scenes:Clear()
		end
		GAS.Logging.Scenes.ViewingScene = scene_id

		local victim, victim_wep, victim_vehicle = GAS.Logging.Scenes:CreatePlayer(scene_obj[1])
		local instigator, instigator_wep, instigator_vehicle = GAS.Logging.Scenes:CreatePlayer(scene_obj[2])

		GAS.Logging.Scenes.SceneEnts[k] = {victim, victim_wep, victim_vehicle, instigator, instigator_wep, instigator_vehicle}
		table.insert(GAS.Logging.Scenes.Victims, victim)
		if (IsValid(victim_wep)) then table.insert(GAS.Logging.Scenes.Victims, victim_wep) end
		if (IsValid(victim_vehicle)) then table.insert(GAS.Logging.Scenes.Victims, victim_vehicle) end
		table.insert(GAS.Logging.Scenes.Instigators, instigator)
		if (IsValid(instigator_wep)) then table.insert(GAS.Logging.Scenes.Instigators, instigator_wep) end
		if (IsValid(instigator_vehicle)) then table.insert(GAS.Logging.Scenes.Instigators, instigator_vehicle) end

		local victim_eyes = victim:LookupAttachment("eyes")
		local instigator_eyes = IsValid(instigator) and instigator:LookupAttachment("eyes") or nil

		local victim_wep_muzzle
		if (IsValid(victim_wep)) then
			victim_wep_muzzle = victim_wep:LookupAttachment("muzzle")
			if (victim_wep_muzzle == 0) then victim_wep_muzzle = nil end
		end

		local instigator_wep_muzzle
		if (IsValid(instigator_wep)) then
			instigator_wep_muzzle = instigator_wep:LookupAttachment("muzzle")
			if (instigator_wep_muzzle == 0) then instigator_wep_muzzle = nil end
		end

		GAS.Logging.Scenes.TraceDraw[k] = function()
			local instigator_origin = scene_obj[1][GAS.Logging.PvP_SCENE_EYE_POS]
			local victim_origin = scene_obj[1][GAS.Logging.PvP_SCENE_EYE_POS]

			if (instigator_wep_muzzle) then
				local attach = instigator_wep:GetAttachment(instigator_wep_muzzle)
				if (attach) then instigator_origin = attach.Pos end
			elseif (instigator_eyes) then
				local attach = instigator:GetAttachment(instigator_eyes)
				if (attach) then instigator_origin = attach.Pos end
			end

			if (victim_wep_muzzle) then
				local attach = victim_wep:GetAttachment(victim_wep_muzzle)
				if (attach) then victim_origin = attach.Pos end
			elseif (victim_eyes) then
				local attach = victim:GetAttachment(victim_eyes)
				if (attach) then victim_origin = attach.Pos end
			end

			cam.IgnoreZ(true)

			render.SetMaterial(red_laser)
			render.DrawBeam(instigator_origin, scene_obj[2][GAS.Logging.PvP_SCENE_SHOOT_POS], 4, 0, 12.5, white)

			render.SetMaterial(red_laser_dot)
			render.DrawSprite(scene_obj[2][GAS.Logging.PvP_SCENE_SHOOT_POS], 10, 10, red)

			render.SetMaterial(green_laser)
			render.DrawBeam(victim_origin, scene_obj[1][GAS.Logging.PvP_SCENE_SHOOT_POS], 4, 0, 12.5, green)

			render.SetMaterial(green_laser_dot)
			render.DrawSprite(scene_obj[1][GAS.Logging.PvP_SCENE_SHOOT_POS], 10, 10, green)

			cam.IgnoreZ(false)
		end

		local instigator_tag, victim_tag = "[" .. string.upper(L"instigator") .. "]", "[" .. string.upper(L"victim") .. "]"
		local instigator_head, victim_head = IsValid(instigator) and instigator:LookupBone("ValveBiped.Bip01_Head1") or nil, victim:LookupBone("ValveBiped.Bip01_Head1")

		local wep_list = list.Get("Weapon")
		local instigator_wep_printname, victim_wep_printname
		if (scene_obj[1][GAS.Logging.PvP_SCENE_WEAPON_CLASS] and wep_list[scene_obj[1][GAS.Logging.PvP_SCENE_WEAPON_CLASS]]) then
			local wep_info = wep_list[scene_obj[1][GAS.Logging.PvP_SCENE_WEAPON_CLASS]]
			if (wep_info.PrintName) then
				victim_wep_printname = wep_info.PrintName
			end
		end
		if (scene_obj[2][GAS.Logging.PvP_SCENE_WEAPON_CLASS] and wep_list[scene_obj[2][GAS.Logging.PvP_SCENE_WEAPON_CLASS]]) then
			local wep_info = wep_list[scene_obj[2][GAS.Logging.PvP_SCENE_WEAPON_CLASS]]
			if (wep_info.PrintName) then
				instigator_wep_printname = wep_info.PrintName
			end
		end

		local origin_callback = origin_callback
		GAS.Logging.Scenes.HUDDraw[k] = function()
			local instigator_origin, victim_origin
			if (not instigator_head or instigator_head == 0) then
				if (instigator_eyes ~= nil and instigator_eyes ~= 0 and instigator:GetAttachment(instigator_eyes)) then
					instigator_origin = instigator:GetAttachment(instigator_eyes).Pos + Vector(0,0,10)
				else
					instigator_origin = instigator:GetPos() + Vector(0,0,20)
				end
			else
				instigator_origin = (IsValid(instigator) and instigator:GetBonePosition(instigator_head) or instigator:GetPos()) + Vector(0,0,10)
			end
			if (origin_callback) then
				origin_callback(instigator_origin, (scene_obj[2][GAS.Logging.PvP_SCENE_SHOOT_POS] - instigator_origin):Angle())
				origin_callback = nil
			end

			if (not victim_head or victim_head == 0) then
				if (victim_eyes ~= nil and victim_eyes ~= 0 and victim:GetAttachment(victim_eyes)) then
					victim_origin = victim:GetAttachment(victim_eyes).Pos + Vector(0,0,10)
				else
					victim_origin = victim:GetPos() + Vector(0,0,20)
				end
			else
				victim_origin = victim:GetBonePosition(victim_head) + Vector(0,0,10)
			end

			local my_eye_pos = GAS.Logging.Scenes.ViewOrigin or LocalPlayer():EyePos()

			cam.IgnoreZ(true)

			local sprite_ang = (instigator_origin - my_eye_pos):Angle()
			sprite_ang.r = 90
			sprite_ang.p = 0
			sprite_ang.y = sprite_ang.y - 90

			cam.Start3D2D(instigator_origin, sprite_ang, 0.1)
				draw.SimpleTextOutlined(instigator_tag, "GAS_Logging_Scene_HUD_1", 0, -60, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
				if (instigator_wep_printname) then
					draw.SimpleTextOutlined(instigator_wep_printname, "GAS_Logging_Scene_HUD_2", 0, -24, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
					draw.SimpleTextOutlined("(" .. scene_obj[2][GAS.Logging.PvP_SCENE_WEAPON_CLASS] .. ")", "GAS_Logging_Scene_HUD_2", 0, 0, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
				elseif (scene_obj[2][GAS.Logging.PvP_SCENE_WEAPON_CLASS]) then
					draw.SimpleTextOutlined(scene_obj[2][GAS.Logging.PvP_SCENE_WEAPON_CLASS], "GAS_Logging_Scene_HUD_2", 0, 0, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
				end
			cam.End3D2D()

			local sprite_ang = (victim_origin - my_eye_pos):Angle()
			sprite_ang.r = 90
			sprite_ang.p = 0
			sprite_ang.y = sprite_ang.y - 90

			cam.Start3D2D(victim_origin, sprite_ang, 0.1)
				draw.SimpleTextOutlined(victim_tag, "GAS_Logging_Scene_HUD_1", 0, -60, green, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
				if (victim_wep_printname) then
					draw.SimpleTextOutlined(victim_wep_printname, "GAS_Logging_Scene_HUD_2", 0, -24, green, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
					draw.SimpleTextOutlined("(" .. scene_obj[1][GAS.Logging.PvP_SCENE_WEAPON_CLASS] .. ")", "GAS_Logging_Scene_HUD_2", 0, 0, green, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
				elseif (scene_obj[1][GAS.Logging.PvP_SCENE_WEAPON_CLASS]) then
					draw.SimpleTextOutlined(scene_obj[1][GAS.Logging.PvP_SCENE_WEAPON_CLASS], "GAS_Logging_Scene_HUD_2", 0, 0, green, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, black)
				end
			cam.End3D2D()

			cam.IgnoreZ(false)
		end
	end
	function GAS.Logging.Scenes:ViewScene(id, beginning, origin_callback)
		if (GAS.Logging.Scenes.CachedData[id] and (beginning or GAS.Logging.Scenes.CachedData[id].End ~= nil)) then
			GAS.Logging.Scenes:SetupScene(id, beginning, GAS.Logging.Scenes.CachedData[id], origin_callback)
		else
			local k = tostring(scene_id)
			if (beginning) then k = k .. "!" end
			GAS.Logging.Scenes.OriginCallbacks[k] = origin_callback

			GAS:netStart("logging:ViewScene")
				net.WriteUInt(id, 16)
				net.WriteBool(beginning)
			net.SendToServer()
		end
	end

	GAS:netReceive("logging:ViewScene", function(l)
		local id = net.ReadUInt(16)
		local beginning = net.ReadBool()
		local data = GAS:DeserializeTable(util.Decompress(net.ReadData(l - 16 - 1)))
		GAS.Logging.Scenes.CachedData[id] = data
		if (beginning or data.End) then
			local k = tostring(scene_id)
			if (beginning) then k = k .. "!" end
			GAS.Logging.Scenes:SetupScene(id, beginning, data, GAS.Logging.Scenes.OriginCallbacks[k])
		end
	end)

	hook.Add("PostDrawTranslucentRenderables", "gas_logging_scene_hud", function()
		for _,f in pairs(GAS.Logging.Scenes.HUDDraw) do f() end
		for _,f in pairs(GAS.Logging.Scenes.TraceDraw) do f() end
	end)
	hook.Add("GAS_RenderView_DrawHUD", "gas_logging_scene_hud_renderview", function()
		for _,f in pairs(GAS.Logging.Scenes.HUDDraw) do f() end
		for _,f in pairs(GAS.Logging.Scenes.TraceDraw) do f() end
	end)

	hook.Add("PreDrawHalos", "gas_logging_scene_halos", function()
		if (not GAS:table_IsEmpty(GAS.Logging.Scenes.Instigators)) then
			halo.Add(GAS.Logging.Scenes.Instigators, red, 1, 1, 5, true, true)
		end
		if (not GAS:table_IsEmpty(GAS.Logging.Scenes.Victims)) then
			halo.Add(GAS.Logging.Scenes.Victims, green, 1, 1, 5, true, true)
		end
	end)
end