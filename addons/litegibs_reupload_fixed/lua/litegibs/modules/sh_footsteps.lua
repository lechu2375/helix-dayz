LiteGibs = LiteGibs or {}
LiteGibs.Ragdolls = LiteGibs.Ragdolls or {}
LiteGibs.RagdollGibs = LiteGibs.RagdollGibs or {}
LiteGibs.Gibs = LiteGibs.Gibs or {}
local LiteGibs = LiteGibs
local gibStepDistance = 32
local gibStepVelocity = 40

if SERVER and game.SinglePlayer() then
	util.AddNetworkString("Footstep")

	hook.Add("PlayerFootstep", "LiteGibStepOnGibs", function(ply, pos, foot, snd, vol)
		net.Start("Footstep")
		net.WriteEntity(ply)
		net.WriteVector(pos)
		net.WriteUInt(foot, 2)
		net.WriteString(snd)
		net.WriteFloat(vol)
		net.Broadcast()
	end)
elseif CLIENT then
	if game.SinglePlayer() then
		net.Receive("Footstep", function()
			local ply, pos, foot, snd, vol = net.ReadEntity(), net.ReadVector(), net.ReadUInt(2), net.ReadString(), net.ReadFloat()

			if ply and pos then
				hook.Run("PlayerFootstep", ply, pos, foot, snd, vol)
			end
		end)
	end

	hook.Add("PlayerFootstep", "LiteGibStepOnGibs", function(ply, pos)
		if not LiteGibs.CVars.FootstepsEnabled:GetBool() then return end

		for i, data in ipairs(LiteGibs.Gibs) do
			local gib = data[2]

			if IsValid(gib) and gib:GetPos():Distance(pos) < gibStepDistance then
				local phys = gib:GetPhysicsObject()

				if IsValid(phys) then
					if phys:IsAsleep() then
						phys:Wake()
						phys:EnableMotion(true)
					end

					phys:SetVelocity(phys:GetVelocity() - (pos - gib:GetPos()):GetNormalized() * gibStepVelocity * math.sqrt(phys:GetMass()))
				end
			end
		end

		local touchedCache = {}

		for i, data in ipairs(LiteGibs.RagdollGibs) do
			for i2, gib in pairs(data[2]) do
				if not IsValid(gib) then goto CONTINUE end
				touchedCache[gib] = true

				for physid = 0, gib:GetPhysicsObjectCount() - 1 do
					local phys = gib:GetPhysicsObjectNum(physid)
					if not IsValid(phys) then goto CONTINUE2 end

					if phys:GetPos():Distance(pos) < gibStepDistance then
						if phys:IsAsleep() then
							phys:Wake()
							phys:EnableMotion(true)
						end

						phys:SetVelocity(phys:GetVelocity() - (pos - phys:GetPos()):GetNormalized() * gibStepVelocity * math.sqrt(phys:GetMass()))
					end

					::CONTINUE2::
				end

				::CONTINUE::
			end
		end

		for _, rag in ipairs(LiteGibs.Ragdolls) do
			if not IsValid(rag) or touchedCache[rag] then goto CONTINUE end

			for physid = 0, rag:GetPhysicsObjectCount() - 1 do
				local phys = rag:GetPhysicsObjectNum(physid)
				if not IsValid(phys) then goto CONTINUE2 end

				if phys:GetPos():Distance(pos) < gibStepDistance then
					if phys:IsAsleep() then
						phys:Wake()
						phys:EnableMotion(true)
					end

					phys:SetVelocity(phys:GetVelocity() - (pos - phys:GetPos()):GetNormalized() * gibStepVelocity * math.sqrt(phys:GetMass()))
				end

				::CONTINUE2::
			end

			::CONTINUE::
		end
	end)
end