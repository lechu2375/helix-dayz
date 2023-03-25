if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("Fun")

do
	local sounds = {}
	for i = 1, 6 do
		sounds[i] = "physics/body/body_medium_impact_hard" .. i .. ".wav"
	end

	local slap = function(ply, damage, admin)
		if not ply:Alive() or ply:sam_get_nwvar("frozen") then return end
		ply:ExitVehicle()

		ply:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(200, 400)))
		ply:EmitSound(sounds[math.random(1, 6)], 60, math.random(80, 120))

		if damage > 0 then
			ply:TakeDamage(damage, admin, DMG_GENERIC)
		end
	end

	command.new("slap")
		:SetPermission("slap", "admin")

		:AddArg("player")
		:AddArg("number", {hint = "damage", round = true, optional = true, min = 0, default = 0})

		:Help("slap_help")

		:OnExecute(function(ply, targets, damage)
			for i = 1, #targets do
				slap(targets[i], damage, ply)
			end

			if damage > 0 then
				sam.player.send_message(nil, "slap_damage", {
					A = ply, T = targets, V = damage
				})
			else
				sam.player.send_message(nil, "slap", {
					A = ply, T = targets
				})
			end
		end)
	:End()
end

command.new("slay")
	:SetPermission("slay", "admin")

	:AddArg("player")

	:Help("slay_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			local v = targets[i]
			if not v:sam_get_exclusive(ply) then
				v:Kill()
			end
		end

		sam.player.send_message(nil, "slay", {
			A = ply, T = targets
		})
	end)
:End()

command.new("hp")
	:Aliases("sethp", "health", "sethealth")

	:SetPermission("hp", "admin")

	:AddArg("player")
	:AddArg("number", {hint = "amount", min = 1, max = 2147483647, round = true, optional = true, default = 100})

	:Help("hp_help")

	:OnExecute(function(ply, targets, amount)
		for i = 1, #targets do
			targets[i]:SetHealth(amount)
		end

		sam.player.send_message(nil, "set_hp", {
			A = ply, T = targets, V = amount
		})
	end)
:End()

command.new("armor")
	:Aliases("setarmor")

	:SetPermission("armor", "admin")

	:AddArg("player")
	:AddArg("number", {hint = "amount", min = 1, max = 2147483647, round = true, optional = true, default = 100})

	:Help("armor_help")

	:OnExecute(function(ply, targets, amount)
		for i = 1, #targets do
			targets[i]:SetArmor(amount)
		end

		sam.player.send_message(nil, "set_armor", {
			A = ply, T = targets, V = amount
		})
	end)
:End()

command.new("ignite")
	:SetPermission("ignite", "admin")

	:AddArg("player")
	:AddArg("number", {hint = "seconds", optional = true, default = 60, round = true})

	:Help("ignite_help")

	:OnExecute(function(ply, targets, length)
		for i = 1, #targets do
			local target = targets[i]

			if target:IsOnFire() then
				target:Extinguish()
			end

			target:Ignite(length)
		end

		sam.player.send_message(nil, "ignite", {
			A = ply, T = targets, V = length
		})
	end)
:End()

command.new("unignite")
	:Aliases("extinguish")

	:SetPermission("ignite", "admin")

	:AddArg("player", {optional = true})

	:Help("unignite_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			targets[i]:Extinguish()
		end

		sam.player.send_message(nil, "unignite", {
			A = ply, T = targets
		})
	end)
:End()

command.new("god")
	:Aliases("invincible")

	:SetPermission("god", "admin")

	:AddArg("player", {optional = true})

	:Help("god_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			local target = targets[i]
			target:GodEnable()
			target.sam_has_god_mode = true
		end

		sam.player.send_message(nil, "god", {
			A = ply, T = targets
		})
	end)
:End()

command.new("ungod")
	:Aliases("uninvincible")

	:SetPermission("ungod", "admin")

	:AddArg("player", {optional = true})

	:Help("ungod_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			local target = targets[i]
			target:GodDisable()
			target.sam_has_god_mode = nil
		end

		sam.player.send_message(nil, "ungod", {
			A = ply, T = targets
		})
	end)
:End()

do
	command.new("freeze")
		:SetPermission("freeze", "admin")

		:AddArg("player")

		:Help("freeze_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				local v = targets[i]
				v:ExitVehicle()
				if v:sam_get_nwvar("frozen") then
					v:UnLock()
				end
				v:Lock()
				v:sam_set_nwvar("frozen", true)
				v:sam_set_exclusive("frozen")
			end

			sam.player.send_message(nil, "freeze", {
				A = ply, T = targets
			})
		end)
	:End()

	command.new("unfreeze")
		:SetPermission("unfreeze", "admin")

		:AddArg("player", {optional = true})

		:Help("unfreeze_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				local v = targets[i]
				v:UnLock()
				v:sam_set_nwvar("frozen", false)
				v:sam_set_exclusive(nil)
			end

			sam.player.send_message(nil, "unfreeze", {
				A = ply, T = targets
			})
		end)
	:End()

	local disallow = function(ply)
		if ply:sam_get_nwvar("frozen") then
			return false
		end
	end

	for _, v in ipairs({"SAM.CanPlayerSpawn", "CanPlayerSuicide", "CanTool"}) do
		hook.Add(v, "SAM.FreezePlayer." .. v, disallow)
	end
end

command.new("cloak")
	:SetPermission("cloak", "admin")

	:AddArg("player", {optional = true})

	:Help("cloak_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			targets[i]:sam_cloak()
		end

		sam.player.send_message(nil, "cloak", {
			A = ply, T = targets
		})
	end)
:End()

command.new("uncloak")
	:SetPermission("uncloak", "admin")

	:AddArg("player", {optional = true})

	:Help("uncloak_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			targets[i]:sam_uncloak()
		end

		sam.player.send_message(nil, "uncloak", {
			A = ply, T = targets
		})
	end)
:End()

do
	local jail_props = {
		Vector(0, 0, -5), Angle(90, 0, 0);
		Vector(0, 0, 97), Angle(90, 0, 0);

		Vector(21, 31, 46), Angle(0, 90, 0);
		Vector(21, -31, 46), Angle(0, 90, 0);
		Vector(-21, 31, 46), Angle(0, 90, 0);
		Vector(-21, -31, 46), Angle(0, 90, 0);

		Vector(-52, 0, 46), Angle(0, 0, 0);
		Vector(52, 0, 46), Angle(0, 0, 0)
	}

	local remove_jail = function(ply_jail_props)
		for _, jail_prop in ipairs(ply_jail_props) do
			if IsValid(jail_prop) then
				jail_prop:Remove()
			end
		end
	end

	local unjail = function(ply)
		if not IsValid(ply) then return end
		if not ply:sam_get_nwvar("jailed") then return end

		remove_jail(ply.sam_jail_props)

		ply.sam_jail_props = nil
		ply.sam_jail_pos = nil

		ply:sam_set_nwvar("jailed", nil)
		ply:sam_set_exclusive(nil)

		timer.Remove("SAM.Unjail." .. ply:SteamID())
		timer.Remove("SAM.Jail.Watch." .. ply:SteamID())
	end

	local return_false = function()
		return false
	end

	local function jail(ply, time)
		if not IsValid(ply) then return end
		if not isnumber(time) or time < 0 then
			time = 0
		end

		if ply:sam_get_nwvar("frozen") then
			RunConsoleCommand("sam", "unfreeze", "#" .. ply:EntIndex())
		end

		if not ply:sam_get_nwvar("jailed") or (not ply.sam_jail_props or not IsValid(ply.sam_jail_props[1])) then
			ply:ExitVehicle()
			ply:SetMoveType(MOVETYPE_WALK)

			ply.sam_jail_pos = ply:GetPos()

			ply:sam_set_nwvar("jailed", true)
			ply:sam_set_exclusive("in jail")

			if ply.sam_jail_props then
				for k, v in ipairs(ply.sam_jail_props) do
					if IsValid(v) then
						v:Remove()
					end
				end
			end

			local ply_jail_props = {}
			for i = 1, #jail_props, 2 do
				local jail_prop = ents.Create("prop_physics")
				jail_prop:SetModel("models/props_building_details/Storefront_Template001a_Bars.mdl")
				jail_prop:SetPos(ply.sam_jail_pos + jail_props[i])
				jail_prop:SetAngles(jail_props[i + 1])
				jail_prop:SetMoveType(MOVETYPE_NONE)
				jail_prop:Spawn()
				jail_prop:GetPhysicsObject():EnableMotion(false)
				jail_prop.CanTool = return_false
				jail_prop.PhysgunPickup = return_false
				jail_prop.jailWall = true
				table.insert(ply_jail_props, jail_prop)
			end
			ply.sam_jail_props = ply_jail_props
		end

		local steamid = ply:SteamID()

		if time == 0 then
			timer.Remove("SAM.Unjail." .. steamid)
		else
			timer.Create("SAM.Unjail." .. steamid, time, 1, function()
				if IsValid(ply) then
					unjail(ply)
				end
			end)
		end

		timer.Create("SAM.Jail.Watch." .. steamid, 0.5, 0, function()
			if not IsValid(ply) then
				return timer.Remove("SAM.Jail.Watch." .. steamid)
			end

			if ply:GetPos():DistToSqr(ply.sam_jail_pos) > 4900 then
				ply:SetPos(ply.sam_jail_pos)
			end

			if not IsValid(ply.sam_jail_props[1]) then
				jail(ply, timer.TimeLeft("SAM.Unjail." .. steamid) or 0)
			end
		end)
	end

	command.new("jail")
		:SetPermission("jail", "admin")

		:AddArg("player")
		:AddArg("length", {optional = true, default = 0, min = 0})
		:AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

		:GetRestArgs()

		:Help("jail_help")

		:OnExecute(function(ply, targets, length, reason)
			for i = 1, #targets do
				jail(targets[i], length * 60)
			end

			sam.player.send_message(nil, "jail", {
				A = ply, T = targets, V = sam.format_length(length), V_2 = reason
			})
		end)
	:End()

	command.new("unjail")
		:SetPermission("unjail", "admin")

		:AddArg("player", {optional = true})

		:Help("unjail_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				unjail(targets[i])
			end

			sam.player.send_message(nil, "unjail", {
				A = ply, T = targets
			})
		end)
	:End()

	sam.hook_first("CanProperty", "SAM.Jail", function(_, property, ent)
		if ent.jailWall and property == "remover" then
			return false
		end
	end)

	if SERVER then
		hook.Add("PlayerSpawn", "SAM.Jail", function(ply)
			if ply:sam_get_nwvar("jailed") or ply:sam_get_pdata("jailed") then
				if ply.sam_jail_pos then
					ply:SetPos(ply.sam_jail_pos)
				else
					ply:SetPos(ply:sam_get_pdata("jail_pos"))
					jail(ply, ply:sam_get_pdata("jail_time_left"))

					ply:sam_set_pdata("jailed", nil)
					ply:sam_set_pdata("jail_pos", nil)
					ply:sam_set_pdata("jail_time_left", nil)
				end
			end
		end)

		hook.Add("PlayerEnteredVehicle", "SAM.Jail", function(ply)
			if ply:sam_get_nwvar("jailed") then
				ply:ExitVehicle()
			end
		end)

		hook.Add("PlayerDisconnected", "SAM.Jail", function(ply)
			if ply:sam_get_nwvar("jailed") then
				remove_jail(ply.sam_jail_props)

				ply:sam_set_pdata("jailed", true)
				ply:sam_set_pdata("jail_pos", ply.sam_jail_pos)
				ply:sam_set_pdata("jail_time_left", timer.TimeLeft("SAM.Unjail." .. ply:SteamID()) or 0)

				timer.Remove("SAM.Unjail." .. ply:SteamID())
				timer.Remove("SAM.Jail.Watch." .. ply:SteamID())
			end
		end)
	end

	local disallow = function(ply)
		if ply:sam_get_nwvar("jailed") then
			return false
		end
	end

	for _, v in ipairs({"PlayerNoClip", "SAM.CanPlayerSpawn", "CanPlayerEnterVehicle", "CanPlayerSuicide", "CanTool"}) do
		hook.Add(v, "SAM.Jail", disallow)
	end
end

command.new("strip")
	:SetPermission("strip", "admin")

	:AddArg("player")

	:Help("strip_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			targets[i]:StripWeapons()
		end

		sam.player.send_message(nil, "strip", {
			A = ply, T = targets
		})
	end)
:End()

command.new("respawn")
	:SetPermission("respawn", "admin")

	:AddArg("player", {optional = true})

	:Help("respawn_help")

	:OnExecute(function(ply, targets)
		for i = 1, #targets do
			targets[i]:Spawn()
		end

		sam.player.send_message(nil, "respawn", {
			A = ply, T = targets
		})
	end)
:End()

command.new("setmodel")
	:SetPermission("setmodel", "superadmin")

	:AddArg("player")
	:AddArg("text", {hint = "model"})

	:Help("setmodel_help")

	:OnExecute(function(ply, targets, model)
		for i = 1, #targets do
			targets[i]:SetModel(model)
		end

		sam.player.send_message(nil, "setmodel", {
			A = ply, T = targets, V = model
		})
	end)
:End()

command.new("giveammo")
	:Aliases("ammo")

	:SetPermission("giveammo", "superadmin")

	:AddArg("player")
	:AddArg("number", {hint = "amount", min = 0, max = 99999})

	:Help("giveammo_help")

	:OnExecute(function(ply, targets, amount)
		if amount == 0 then
			amount = 99999
		end

		for i = 1, #targets do
			local target = targets[i]
			for _, wep in ipairs(target:GetWeapons()) do
				if wep:GetPrimaryAmmoType() ~= -1 then
					target:GiveAmmo(amount, wep:GetPrimaryAmmoType(), true)
				end

				if wep:GetSecondaryAmmoType() ~= -1 then
					target:GiveAmmo(amount, wep:GetSecondaryAmmoType(), true)
				end
			end
		end

		sam.player.send_message(nil, "giveammo", {
			A = ply, T = targets, V = amount
		})
	end)
:End()

do
	command.new("scale")
		:SetPermission("scale", "superadmin")

		:AddArg("player")
		:AddArg("number", {hint = "amount", optional = true, min = 0, max = 2.5, default = 1})

		:Help("scale_help")

		:OnExecute(function(ply, targets, amount)
			for i = 1, #targets do
				local v = targets[i]
				v:SetModelScale(amount)

				-- https://github.com/carz1175/More-ULX-Commands/blob/9b142ee4247a84f16e2dc2ec71c879ab76e145d4/lua/ulx/modules/sh/extended.lua#L313
				v:SetViewOffset(Vector(0, 0, 64 * amount))
				v:SetViewOffsetDucked(Vector(0, 0, 28 * amount))

				v.sam_scaled = true
			end

			sam.player.send_message(nil, "scale", {
				A = ply, T = targets, V = amount
			})
		end)
	:End()

	hook.Add("PlayerSpawn", "SAM.Scale", function(ply)
		if ply.sam_scaled then
			ply.sam_scaled = nil
			ply:SetViewOffset(Vector(0, 0, 64))
			ply:SetViewOffsetDucked(Vector(0, 0, 28))
		end
	end)
end

sam.command.new("freezeprops")
	:SetPermission("freezeprops", "admin")
	:Help("freezeprops_help")

	:OnExecute(function(ply)
		for _, prop in ipairs(ents.FindByClass("prop_physics")) do
			local physics_obj = prop:GetPhysicsObject()
			if IsValid(physics_obj) then
				physics_obj:EnableMotion(false)
			end
		end

		sam.player.send_message(nil, "freezeprops", {
			A = ply
		})
	end)
:End()