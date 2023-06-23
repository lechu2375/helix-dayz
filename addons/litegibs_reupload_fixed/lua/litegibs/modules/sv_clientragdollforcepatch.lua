LiteGibs = LiteGibs or {}
LiteGibs.EntitiesPatched = {}
local function patch(cl)
	local tbl = scripted_ents.GetStored( cl )
	if tbl and tbl.t then
		local ENT = scripted_ents.GetStored( cl ).t
		function ENT:MorphRagdoll( dmginfo)
			self:BecomeRagdoll(dmginfo or DamageInfo())
		end
		function ENT:TransformRagdoll( dmginfo)
			self:BecomeRagdoll(dmginfo or DamageInfo())
		end
	end
end
hook.Add("OnEntityCreated","LGForceClientRagdolls_NextBot",function(ent)
	local cl = ent:GetClass()
	if not LiteGibs.EntitiesPatched[cl] then
		patch(cl)
	end
	--patch max health
	timer.Simple(0, function()
		if IsValid(ent) and ent:Health() > ent:GetMaxHealth() then
			ent:SetMaxHealth(ent:Health())
		end
	end)
end)
local keepcorpses = GetConVar("ai_serverragdolls")
hook.Add("OnEntityCreated", "LGForceClientRagdolls", function(ent)
	if keepcorpses and keepcorpses:GetBool() then return end
	ent:SetShouldServerRagdoll(false)
end)