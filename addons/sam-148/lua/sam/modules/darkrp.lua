if SAM_LOADED then return end

local add = not GAMEMODE and hook.Add or function(_, _, fn)
	fn()
end

add("PostGamemodeLoaded", "SAM.DarkRP", function()
	if not DarkRP then return end

	local sam, command, language = sam, sam.command, sam.language

	command.set_category("DarkRP")

	command.new("arrest")
		:SetPermission("arrest", "superadmin")

		:AddArg("player")
		:AddArg("number", {hint = "time", optional = true, min = 0, default = 0, round = true})

		:Help("arrest_help")

		:OnExecute(function(ply, targets, time)
			if time == 0 then
				time = math.huge
			end

			for i = 1, #targets do
				local v = targets[i]
				if v:isArrested() then
					v:unArrest()
				end
				v:arrest(time, ply)
			end

			if time == math.huge then
				sam.player.send_message(nil, "arrest", {
					A = ply, T = targets
				})
			else
				sam.player.send_message(nil, "arrest2", {
					A = ply, T = targets, V = time
				})
			end
		end)
	:End()

	command.new("unarrest")
		:SetPermission("unarrest", "superadmin")

		:AddArg("player", {optional = true})

		:Help("unarrest_help")

		:OnExecute(function(ply, targets)
			for i = 1, #targets do
				targets[i]:unArrest()
			end

			sam.player.send_message(nil, "unarrest", {
				A = ply, T = targets
			})
		end)
	:End()

	command.new("setmoney")
		:SetPermission("setmoney", "superadmin")

		:AddArg("player", {single_target = true})
		:AddArg("number", {hint = "amount", min = 0, round = true})

		:Help("setmoney_help")

		:OnExecute(function(ply, targets, amount)
			local target = targets[1]

			amount = hook.Call("playerWalletChanged", GAMEMODE, target, amount - target:getDarkRPVar("money"), target:getDarkRPVar("money")) or amount

			DarkRP.storeMoney(target, amount)
			target:setDarkRPVar("money", amount)

			sam.player.send_message(nil, "setmoney", {
				A = ply, T = targets, V = amount
			})
		end)
	:End()

	command.new("addmoney")
		:SetPermission("addmoney", "superadmin")

		:AddArg("player", {single_target = true})
		:AddArg("number", {hint = "amount", min = 0, round = true})

		:Help("addmoney_help")

		:OnExecute(function(ply, targets, amount)
			targets[1]:addMoney(amount)

			sam.player.send_message(nil, "addmoney", {
				A = ply, T = targets, V = DarkRP.formatMoney(amount)
			})
		end)
	:End()

	command.new("selldoor")
		:SetPermission("selldoor", "superadmin")

		:Help("selldoor_help")

		:OnExecute(function(ply)
			local ent = ply:GetEyeTrace().Entity
			if not IsValid(ent) or not ent.keysUnOwn then
				return ply:sam_send_message("door_invalid")
			end
			local door_owner = ent:getDoorOwner()
			if not IsValid(door_owner) then
				return ply:sam_send_message("door_no_owner")
			end
			ent:keysUnOwn(ply)

			sam.player.send_message(nil, "selldoor", {
				A = ply, T = {door_owner, admin = ply}
			})
		end)
	:End()

	command.new("sellall")
		:SetPermission("sellall", "superadmin")

		:AddArg("player", {single_target = true})

		:Help("sellall_help")

		:OnExecute(function(ply, targets, amount)
			targets[1]:keysUnOwnAll()

			sam.player.send_message(nil, "sellall", {
				A = ply, T = targets
			})
		end)
	:End()

	command.new("setjailpos")
		:SetPermission("setjailpos", "superadmin")

		:Help("setjailpos_help")

		:OnExecute(function(ply)
			DarkRP.storeJailPos(ply, false)

			sam.player.send_message(nil, "s_jail_pos", {
				A = ply
			})
		end)
	:End()

	command.new("addjailpos")
		:SetPermission("addjailpos", "superadmin")

		:Help("addjailpos_help")

		:OnExecute(function(ply)
			DarkRP.storeJailPos(ply, true)

			sam.player.send_message(nil, "a_jail_pos", {
				A = ply
			})
		end)
	:End()

	local RPExtraTeams = RPExtraTeams
	local job_index = nil

	command.new("setjob")
		:SetPermission("setjob", "admin")

		:AddArg("player")
		:AddArg("text", {hint = "job", check = function(job)
			job = job:lower()

			for i = 1, #RPExtraTeams do
				local v = RPExtraTeams[i]
				if v.name:lower() == job or v.command:lower() == job then
					job_index = v.team
					return true
				end
			end

			return false
		end})

		:Help("setjob_help")

		:OnExecute(function(ply, targets, job)
			for i = 1, #targets do
				targets[i]:changeTeam(job_index, true, true, true)
			end

			sam.player.send_message(nil, "setjob", {
				A = ply, T = targets, V = job
			})
		end)
	:End()

	do
		local get_shipment = function(name)
			local found, key = DarkRP.getShipmentByName(name)
			if found then return found, key end

			name = name:lower()

			local shipments = CustomShipments
			for i = 1, #shipments do
				local shipment = shipments[i]
				if shipment.entity == name then
					return DarkRP.getShipmentByName(shipment.name)
				end
			end

			return false
		end

		local place_entity = function(ent, tr, ply)
			local ang = ply:EyeAngles()
			ang.pitch = 0
			ang.yaw = ang.yaw - 90
			ang.roll = 0
			ent:SetAngles(ang)

			local flush_point = tr.HitPos - (tr.HitNormal * 512)
			flush_point = ent:NearestPoint(flush_point)
			flush_point = ent:GetPos() - flush_point
			flush_point = tr.HitPos + flush_point
			ent:SetPos(flush_point)
		end

		command.new("shipment")
			:SetPermission("shipment", "superadmin")

			:AddArg("text", {hint = "weapon", check = get_shipment})

			:Help("shipment_help")

			:OnExecute(function(ply, weapon_name)
				local trace = {}
				trace.start = ply:EyePos()
				trace.endpos = trace.start + ply:GetAimVector() * 85
				trace.filter = ply
				local tr = util.TraceLine(trace)

				local shipment_info, shipment_key = get_shipment(weapon_name)

				local crate = ents.Create(shipment_info.shipmentClass or "spawned_shipment")
				crate.SID = ply.SID

				crate:Setowning_ent(ply)
				crate:SetContents(shipment_key, shipment_info.amount)

				crate:SetPos(Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z))

				crate.nodupe = true
				crate.ammoadd = shipment_info.spareammo
				crate.clip1 = shipment_info.clip1
				crate.clip2 = shipment_info.clip2

				crate:Spawn()
				crate:SetPlayer(ply)

				place_entity(crate, tr, ply)

				local phys = crate:GetPhysicsObject()
				phys:Wake()

				if shipment_info.weight then
					phys:SetMass(shipment_info.weight)
				end

				sam.player.send_message(nil, "shipment", {
					A = ply, V = weapon_name
				})
			end)
		:End()
	end

	sam.command.new("forcename")
		:SetPermission("forcename", "superadmin")

		:AddArg("player")
		:AddArg("text", {hint = "name"})

		:Help("forcename_help")

		:OnExecute(function(ply, targets, name)
			local target = targets[1]

			DarkRP.retrieveRPNames(name, function(taken)
				if not IsValid(target) then return end

				if taken then
					ply:sam_send_message("forcename_taken", {
						V = name
					})
					return
				end

				sam.player.send_message(nil, "forcename", {
					A = ply, T = targets, V = name
				})

				DarkRP.storeRPName(target, name)
				target:setDarkRPVar("rpname", name)
			end)
		end)
	:End()
end)