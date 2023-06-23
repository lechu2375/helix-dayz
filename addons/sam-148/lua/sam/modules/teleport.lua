if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("Teleport")

local find_empty_pos -- https://github.com/FPtje/DarkRP/blob/b147d6fa32799136665a9fd52d35c2fe87cf7f78/gamemode/modules/base/sv_util.lua#L149
do
	local is_empty = function(vector, ignore)
		local point = util.PointContents(vector)
		local a = point ~= CONTENTS_SOLID
			and point ~= CONTENTS_MOVEABLE
			and point ~= CONTENTS_LADDER
			and point ~= CONTENTS_PLAYERCLIP
			and point ~= CONTENTS_MONSTERCLIP
		if not a then return false end

		local ents_found = ents.FindInSphere(vector, 35)
		for i = 1, #ents_found do
			local v = ents_found[i]
			if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and v ~= ignore then
				return false
			end
		end

		return true
	end

	local distance, step, area = 600, 30, Vector(16, 16, 64)
	local north_vec, east_vec, up_vec = Vector(0, 0, 0), Vector(0, 0, 0), Vector(0, 0, 0)

	find_empty_pos = function(pos, ignore)
		if is_empty(pos, ignore) and is_empty(pos + area, ignore) then
			return pos
		end

		for j = step, distance, step do
			for i = -1, 1, 2 do
				local k = j * i

				-- North/South
				north_vec.x = k
				if is_empty(pos + north_vec, ignore) and is_empty(pos + north_vec + area, ignore) then
					return pos + north_vec
				end

				-- East/West
				east_vec.y = k
				if is_empty(pos + east_vec, ignore) and is_empty(pos + east_vec + area, ignore) then
					return pos + east_vec
				end

				-- Up/Down
				up_vec.z = k
				if is_empty(pos + up_vec, ignore) and is_empty(pos + up_vec + area, ignore) then
					return pos + up_vec
				end
			end
		end

		return pos
	end
end

command.new("bring")
	:DisallowConsole()
	:SetPermission("bring", "admin")

	:AddArg("player", {cant_target_self = true})

	:Help("bring_help")

	:OnExecute(function(ply, targets)
		if not ply:Alive() then
			return ply:sam_send_message("dead")
		end

		if ply:InVehicle() then
			return ply:sam_send_message("leave_car")
		end

		if ply:sam_get_exclusive(ply) then
			return ply:sam_send_message(ply:sam_get_exclusive(ply))
		end

		local teleported = {admin = ply}
		local all = targets.input == "*"

		for i = 1, #targets do
			local target = targets[i]

			if target:sam_get_exclusive(ply) then
				if not all then
					ply:sam_send_message(target:sam_get_exclusive(ply))
				end
				continue
			end

			if not target:Alive() then
				target:Spawn()
			end

			target.sam_tele_pos, target.sam_tele_ang = target:GetPos(), target:EyeAngles()

			target:ExitVehicle()
			target:SetVelocity(Vector(0, 0, 0))
			target:SetPos(find_empty_pos(ply:GetPos(), target))
			target:SetEyeAngles((ply:EyePos() - target:EyePos()):Angle())

			table.insert(teleported, target)
		end

		if #teleported > 0 then
			sam.player.send_message(nil, "bring", {
				A = ply, T = teleported
			})
		end
	end)
:End()

command.new("goto")
	:DisallowConsole()
	:SetPermission("goto", "admin")

	:AddArg("player", {single_target = true, allow_higher_target = true, cant_target_self = true})

	:Help("goto_help")

	:OnExecute(function(ply, targets)
		if ply:sam_get_exclusive(ply) then
			return ply:sam_send_message(ply:sam_get_exclusive(ply))
		end

		if not ply:Alive() then
			ply:Spawn()
		end

		local target = targets[1]
		ply.sam_tele_pos, ply.sam_tele_ang = ply:GetPos(), ply:EyeAngles()

		ply:ExitVehicle()
		ply:SetVelocity(Vector(0, 0, 0))
		ply:SetPos(find_empty_pos(target:GetPos(), ply))
		ply:SetEyeAngles((target:EyePos() - ply:EyePos()):Angle())

		sam.player.send_message(nil, "goto", {
			A = ply, T = targets
		})
	end)
:End()

command.new("return")
	:SetPermission("return", "admin")

	:AddArg("player", {single_target = true, optional = true})

	:Help("return_help")

	:OnExecute(function(ply, targets)
		local target = targets[1]

		local last_pos, last_ang = target.sam_tele_pos, target.sam_tele_ang
		if not last_pos then
			return sam.player.send_message(ply, "no_location", {
				T = targets
			})
		end

		if target:sam_get_exclusive(ply) then
			return ply:sam_send_message(target:sam_get_exclusive(ply))
		end

		if not target:Alive() then
			return ply:sam_send_message(target:Name() .. " is dead!")
		end

		target:ExitVehicle()
		target:SetVelocity(Vector(0, 0, 0))
		target:SetPos(last_pos)
		target:SetEyeAngles(last_ang)

		target.sam_tele_pos, target.sam_tele_ang = nil, nil

		sam.player.send_message(nil, "returned", {
			A = ply, T = targets
		})
	end)
:End()