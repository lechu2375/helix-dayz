if SAM_LOADED then return end

local loaded = false
local load_restrictions = function()
	local sam = sam
	local config = sam.config
	local hook = hook
	local SERVER = SERVER

	if CLIENT then
		local add_setting = function(body, title, key)
			local setting = body:Add("SAM.LabelPanel")
			setting:Dock(TOP)
			setting:SetLabel(title)

			local enable = setting:Add("SAM.ToggleButton")
			enable:SetConfig(key, true)

			return setting
		end

		config.add_menu_setting("Restrictions", function(body)
			local setting = body:Add("SAM.LabelPanel")
			setting:Dock(TOP)
			setting:DockMargin(8, 6, 8, 0)
			setting:SetLabel("Restrictions (Check these settings in ranks' permissions)")

			local setting_body = body:Add("Panel")
			setting_body:Dock(TOP)
			setting_body:DockMargin(8, 6, 8, 0)
			setting_body:DockPadding(8, 0, 8, 0)

			add_setting(setting_body, "Tool (Eg. using button tool)", "Restrictions.Tool")
			add_setting(setting_body, "Spawning (Eg. spawning props)", "Restrictions.Spawning")
			add_setting(setting_body, "Limits (Eg. how many props can you spawn)", "Restrictions.Limits")

			function setting_body:PerformLayout()
				setting_body:SizeToChildren(false, true)
			end
		end)
	end

	local tools = weapons.GetStored("gmod_tool")
	if sam.istable(tools) then
		if config.get("Restrictions.Tool", true) then
			for k, v in pairs(tools.Tool) do
				sam.permissions.add(v.Mode, "Tools - " .. (v.Category or "Other"), "user")
			end

			hook.Add("CanTool", "SAM.Module.Restrictions", function(ply, _, tool)
				if not ply:HasPermission(tool) then
					if CLIENT and sam.player.check_cooldown(ply, "ToolNoPermission", 0.1) then
						ply:sam_send_message("You don't have permission to use this tool.")
					end
					return false
				end
			end)
		else
			for k, v in pairs(tools.Tool) do
				sam.permissions.remove(v.Mode)
			end

			hook.Remove("CanTool", "SAM.Module.Restrictions")
		end
	end

	sam.permissions.add("admin_weapons", "Spawning", "superadmin")

	local function no_permission(ply, name)
		ply:sam_play_sound("buttons/button10.wav")
		ply:sam_send_message("You don't have permission to spawn {S Blue}.", {
			S = name
		})
	end

	local spawning = {
		PlayerSpawnProp = {
			name = "props",
			permission = "user",
			call_gm = true,
		},
		PlayerGiveSWEP = {
			name = "give_weapons",
			cb = function(_, ply, _, wep)
				if wep.sam_AdminOnly and not ply:HasPermission("admin_weapons") then
					no_permission(ply, "admin weapons")
					return false
				end
				return true
			end,
			hook = sam.hook_first,
		},
		PlayerSpawnSWEP = {
			name = "spawn_weapons",
			cb = function(_, ply, _, wep)
				if wep.sam_AdminOnly and not ply:HasPermission("admin_weapons") then
					no_permission(ply, "admin weapons")
					return false
				end
				return true
			end,
			hook = sam.hook_first,
		},
		-- PlayerSpawnSENT = {
		-- 	name = "entities",
		-- 	check_limit = "sents"
		-- },
		PlayerSpawnNPC = {
			name = "npcs",
			check_limit = "npcs",
		},
		PlayerSpawnVehicle = {
			name = "vehicles",
			check_limit = "vehicles",
		},
		PlayerSpawnRagdoll = {
			name = "ragdolls",
			permission = "user",
		}
	}

	local override_lists = {
		"Weapon",
		-- "SpawnableEntities"
	}

	local function LimitReachedProcess(ply, str)
		if not IsValid(ply) then return true end
		return ply:CheckLimit(str)
	end

	local GAMEMODE = GAMEMODE
	if config.get("Restrictions.Spawning", true) then
		for k, v in pairs(spawning) do
			local name = v
			local permission = "superadmin"
			local check
			local check_limit
			local hook = sam.hook_last
			if istable(v) then
				name = v.name
				permission = v.permission or permission
				if v.call_gm then
					check = GAMEMODE[k]
				elseif v.cb then
					check = v.cb
				end
				hook = v.hook or hook
				check_limit = v.check_limit
			end

			sam.permissions.add(name, "Spawning", permission)

			if SERVER then
				hook(k, "SAM.Spawning." .. k .. name, function(ply, ...)
					if not ply:HasPermission(name) then
						no_permission(ply, name)
						return false
					end

					if check_limit then
						return LimitReachedProcess(ply, check_limit)
					end

					if check then
						return check(GAMEMODE, ply, ...)
					end

					return true
				end)
			end
		end

		for i = 1, #override_lists do
			for k, v in pairs(list.GetForEdit(override_lists[i])) do
				v.sam_AdminOnly = v.sam_AdminOnly or v.AdminOnly
				v.AdminOnly = false
			end
		end
	else
		sam.permissions.add("admin_weapons")

		for k, v in pairs(spawning) do
			sam.permissions.remove(istable(v) and v.name or v)

			if SERVER then
				hook.Remove(k, "SAM.Spawning." .. k)
			end
		end

		for i = 1, #override_lists do
			for k, v in pairs(list.GetForEdit(override_lists[i])) do
				if v.sam_AdminOnly then
					v.AdminOnly = v.sam_AdminOnly
				end
			end
		end
	end

	local PLAYER = FindMetaTable("Player")
	if config.get("Restrictions.Limits", true) then
		local get_limit = sam.ranks.get_limit
		function PLAYER:GetLimit(limit_type)
			return get_limit(self:sam_getrank(), limit_type)
		end

		sam.hook_first("PlayerCheckLimit", "SAM.PlayerCheckLimit", function(ply, limit_type, count)
			local ply_limit = ply:GetLimit(limit_type)
			if ply_limit < 0 then return true end

			if count > ply_limit - 1 then
				return false
			end

			return true
		end)

		sam.limit_types = {}
		for _, limit_type in SortedPairs(cleanup.GetTable(), true) do
			local cvar = GetConVar("sbox_max" .. limit_type)
			if cvar then
				table.insert(sam.limit_types, limit_type)
			end
		end
	else
		sam.limit_types = nil
		PLAYER.GetLimit = nil
		hook.Remove("PlayerCheckLimit", "SAM.PlayerCheckLimit")
	end

	if not loaded then
		loaded = true
		hook.Call("SAM.LoadedRestrictions")
	end
end

timer.Simple(5, function()
	if GAMEMODE.IsSandboxDerived then
		sam.config.hook({"Restrictions.Tool", "Restrictions.Spawning", "Restrictions.Limits"}, load_restrictions)
	end
end)