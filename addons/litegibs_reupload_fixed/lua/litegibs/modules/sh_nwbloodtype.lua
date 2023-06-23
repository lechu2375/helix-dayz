local btOverrides = {
	["npc_antlion"] = BLOOD_COLOR_ANTLION,
	["npc_antlionguard"] = BLOOD_COLOR_ANTLION,
	["npc_hunter"] = BLOOD_COLOR_SYNTH,
	["npc_turret_floor"] = DONT_BLEED
}

if SERVER then
	util.AddNetworkString("CLBloodType")

	hook.Add("OnEntityCreated", "LGNWBloodType", function(ent)
		timer.Simple(0.01, function()
			if IsValid(ent) then
				ent.BloodColor = btOverrides[ent:GetClass()] or ent.BloodColor or ent:GetBloodColor()

				if ent.BloodColor then
					net.Start("CLBloodType")
					net.WriteEntity(ent)
					net.WriteInt(ent.BloodColor, 8)
					net.SendPVS(ent:GetPos())
				end
			end
		end)
	end)
else
	net.Receive("CLBloodType", function()
		local ent = net.ReadEntity()

		if IsValid(ent) then
			local bt = net.ReadInt(8)
			ent.BloodColor = bt
		end
	end)
end

local meta = FindMetaTable("Entity")

function meta:GetBloodColorLG()
	return self.BloodColor or self:GetBloodColor() or BLOOD_COLOR_RED
end