LiteGibs = LiteGibs or {}

LiteGibs.WeaponDamageScales = LiteGibs.WeaponDamageScales or {
	["weapon_shotgun"] = 8
}

hook.Add("InitPostEntity", "optionChanger", function()
	
	LiteGibs.CVars.Enabled:SetBool(ix.option.Get("enableGibs", false))
	ix.option.Add("enableGibs", ix.type.bool, false, {
		category = "GoreMod",
		OnChanged = function()
			if(CLIENT)then
				local var = ix.option.Get("enableGibs", false)
				if(var) then LiteGibs.SetupMenu() end
				LiteGibs.CVars.Enabled:SetBool(var)
			end
		end
	})

end)
--ent.BecomeRagdoll = NetworkRagdollFunction
local ValidHitGroups = {HITGROUP_HEAD, HITGROUP_CHEST, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG}
local keepcorpses = GetConVar("ai_serverragdolls")

local function GetClosestBone(ent, pos)
	local biggestDist = math.huge
	local b

	for i = 0, ent:GetBoneCount() - 1 do
		local p = ent:GetBonePosition(i)
		local d = pos:Distance(p)

		if d < biggestDist then
			biggestDist = d
			b = i
		end
	end

	return b
end

local function fixHitGroupDir(hg, bn)
	local nhg = hg

	if bn:EndsWith("_r") or bn:find("_r_") then
		if nhg == HITGROUP_LEFTLEG then
			nhg = HITGROUP_RIGHTLEG
		elseif nhg == HITGROUP_LEFTARM then
			nhg = HITGROUP_RIGHTARM
		end
	end

	return nhg
end

local function fixHitGroup(ent, hg, dmg)
	local tr = {}
	local traceRes
	local toReturn
	if hg == HITGROUP_GENERIC then
		local centerpos = ent:GetPos()

		if ent.GetShootPos then
			centerpos = (centerpos + ent:GetShootPos()) / 2
		end

		tr.start = dmg:GetDamagePosition() or centerpos
		tr.endpos = centerpos
		traceRes = util.TraceLine(tr)
		hg = traceRes.HitGroup or hg

		if hg == HITGROUP_GENERIC and traceRes.Entity == ent and traceRes.PhysicsBone and traceRes.PhysicsBone >= 0 then
			if LiteGibs.PhysBoneBlacklistClass[ent:GetClass()] then
				local bone = GetClosestBone(ent, tr.start)
				if not bone then return HITGROUP_STOMACH end
				local bn = string.lower(ent:GetBoneName(bone) or "valvebiped.bip01_spine1")

				for k, v in pairs(LiteGibs.BoneHitGroups) do
					if string.find(bn, k) then  return fixHitGroupDir(v, bn) end
				end
			else
				local bone = ent:TranslatePhysBoneToBone(traceRes.PhysicsBone)
				if not bone then return HITGROUP_STOMACH end
				local bn = string.lower(ent:GetBoneName(bone) or "valvebiped.bip01_spine1")

				for k, v in pairs(LiteGibs.BoneHitGroups) do
					if string.find(bn, k) then  return fixHitGroupDir(v, bn) end
				end
			end
		end
	end

	if hg == HITGROUP_GENERIC then return HITGROUP_STOMACH end
	
	return hg
end

local function IsDamageType(dmg, typev)
	return bit.band(dmg, typev) == typev
end

local function AddToDamageTable(ent, hitgroup, damage, damageType, vec)
	ent.LGDamageTable = ent.LGDamageTable or {}

	if IsDamageType(damageType, DMG_BLAST) then
		for _, hgruppe in pairs(ValidHitGroups) do
			ent.LGDamageTable[hgruppe] = ent.LGDamageTable[hgruppe] or {}
			ent.LGDamageTable[hgruppe].damage = ent.LGDamageTable[hgruppe].damage or 0
			ent.LGDamageTable[hgruppe].damage = ent.LGDamageTable[hgruppe].damage + damage * math.Rand(0.5, 1.5)
			ent.LGDamageTable[hgruppe].damageType = bit.bor(damageType, ent.LGDamageTable[hgruppe].damageType or 0)
		end

		ent.LGDamageTable[hitgroup] = ent.LGDamageTable[hitgroup] or {}
		ent.LGDamageTable[hitgroup].damage = ent.LGDamageTable[hitgroup].damage or 0
		ent.LGDamageTable[hitgroup].damage = ent.LGDamageTable[hitgroup].damage + damage / 2
		ent.LGDamageTable[hitgroup].damageType = bit.bor(damageType, ent.LGDamageTable[hitgroup].damageType or 0)
	elseif IsDamageType(damageType, DMG_SLASH) then
		ent.LGDamageTable[hitgroup] = ent.LGDamageTable[hitgroup] or {}
		ent.LGDamageTable[hitgroup].damage = ent.LGDamageTable[hitgroup].damage or 0
		ent.LGDamageTable[hitgroup].damage = ent.LGDamageTable[hitgroup].damage + damage
		ent.LGDamageTable[hitgroup].damageType = bit.bor(damageType, ent.LGDamageTable[hitgroup].damageType or 0)
	end

	if IsDamageType(damageType, DMG_ALWAYSGIB) then
		ent.LGDamageTable[hitgroup] = ent.LGDamageTable[hitgroup] or {}
		ent.LGDamageTable[hitgroup].damage = 1000

		if damage < 160 then
			ent.LGDamageTable[hitgroup].damageType = DMG_SLASH
		else
			ent.LGDamageTable[hitgroup].damageType = damageType
		end
	elseif not IsDamageType(damageType, DMG_NEVERGIB) then
		ent.LGDamageTable[hitgroup] = ent.LGDamageTable[hitgroup] or {}
		ent.LGDamageTable[hitgroup].damage = damage
		ent.LGDamageTable[hitgroup].damageType = damageType
	end
end

local function CanGib(ent, dmg, hitgroup)
	local hp = LiteGibs.EntityHealth[ent:GetClass()] or ent:GetMaxHealth() or 100

	return dmg > hp * LiteGibs.EntityHitGroupHealth[hitgroup]
end

local function CanOvergib(ent, dmg, hitgroup)
	local hp = LiteGibs.EntityHealth[ent:GetClass()] or ent:GetMaxHealth() or 100

	return dmg > hp * LiteGibs.EntityHitGroupHealth[hitgroup] * 1.3
end

if SERVER then
	util.AddNetworkString("LITEGIBDMG")
	util.AddNetworkString("LITEGIBPS")
	util.AddNetworkString("LITEGIBCLIENTRAG")

	local RelSched = {
		[SCHED_RELOAD]=true,
		[SCHED_HIDE_AND_RELOAD] = true
	}

	local function CanLiveDismember(ent, hg)
		local tbl = ent.LGDamageTable[hg]
		if not tbl then return false end
		local dmg = tbl.damage
		if not CanGib(ent, dmg, hg) then return false end
		return true
	end

	local function DropWep(wep)
		if IsValid(wep) then
			local wepClone = ents.Create(wep:GetClass())
			wepClone:SetPos(wep:GetPos())
			wepClone:SetAngles(wep:GetAngles())
			wepClone:SetClip1(wep.Clip1 and wep:Clip1() or 0 )
			wepClone:Spawn()
			wep:Remove()
		end
	end

	local function NetworkDamage(ent, hg, dmg)
		local dmgVal = dmg:GetBaseDamage()
		if dmgVal <= 1 then return end
		local fixedHitgroup = fixHitGroup(ent, hg, dmg)
		local vec = dmg:GetDamagePosition()
		local wep = dmg:GetInflictor()

		if IsValid(wep) and wep:IsPlayer() then
			wep = wep:GetActiveWeapon()
		end

		if IsValid(wep) and wep:IsWeapon() and not dmg:IsDamageType(DMG_SLASH) and not dmg:IsDamageType(DMG_CLUB) and not dmg:IsDamageType(DMG_CRUSH) then
			if wep.GetStat then
				dmgVal = math.min(dmgVal * wep:GetStat("Primary.NumShots"), wep:GetStat("Primary.Damage", wep.Primary.Damage) * wep:GetStat("Primary.NumShots"))
			elseif wep.Primary and wep.Primary.Damage and type(wep.Primary.Damage) == "number" and wep.Primary.NumShots then
				dmgVal = math.min(wep.Primary.Damage * wep.Primary.NumShots, dmgVal)
			end

			local mod = LiteGibs.WeaponDamageScales[wep:GetClass()] or 1
			dmgVal = dmgVal * mod
		end

		if dmgVal > ent:GetMaxHealth() * 2 and hg == 0 then
			hg = HITGROUP_STOMACH
		end

		if ent:IsRagdoll() or LiteGibs.CVars.LiveDismemberGameplay:GetBool() then
			local bone = ent:GetClosestPhysicsEnabledBone(vec) or 0
			ent:DamageBone(bone, dmgVal, dmg:GetDamageType(), vec)
			
			ent:GibDamagedBones()
			
		end

		AddToDamageTable(ent, fixedHitgroup, math.Round(dmgVal), math.Round(dmg:GetDamageType()), vec)
		if LiteGibs.CVars.LiveDismemberGameplay:GetBool() and ent.GetActiveWeapon and not (ent.Alive and not ent:Alive()) then
			local ply = dmg:GetAttacker()
			if CanLiveDismember(ent,HITGROUP_HEAD) or CanLiveDismember(ent,HITGROUP_CHEST) or CanLiveDismember(ent,HITGROUP_STOMACH) or (CanLiveDismember(ent,HITGROUP_LEFTLEG) and CanLiveDismember(ent,HITGROUP_RIGHTLEG)) then
				timer.Simple(0.1, function()
					if IsValid(ent) and not (ent.Alive and not ent:Alive()) then
						dmg:SetDamage(ent:Health()+1)
						ent:TakeDamageInfo(dmg)
					end
				end)
			end
			if CanLiveDismember(ent,HITGROUP_RIGHTARM) then
				local hitwep = ent:GetActiveWeapon()
				DropWep(hitwep)
				if ent:IsNPC() and ent.SetSchedule and ent.GetCurrentSchedule then
					if IsValid(ply) then
						ent:AddEntityRelationship( ply, D_FR, 99 )
					end
					ent:ClearSchedule()
				end
			end
			if CanLiveDismember(ent,HITGROUP_LEFTARM) then
				local hitwep = ent:GetActiveWeapon()
				if IsValid(hitwep) then
					if hitwep:GetHoldType() == "melee2" then
						hitwep:SetHoldType("melee")
					elseif hitwep:GetHoldType() ~= "melee" then
						hitwep:SetHoldType("pistol")
					end
					if ent:IsNPC() and ent.SetSchedule and ent.GetCurrentSchedule then
						if ent:Health()>(ent:GetMaxHealth() or 100)*0.75 then
							local tid = "LGPreventReload"..ent:EntIndex()
							timer.Create(tid,0.1,0,function()
								if not IsValid(ent) then
									timer.Remove(tid)
									return
								end
								if RelSched[ent:GetCurrentSchedule()] then
									DropWep(ent:GetActiveWeapon())
									if IsValid(ply) then
										ent:AddEntityRelationship( ply, D_FR, 99 )
									end
									ent:ClearSchedule()
									timer.Remove(tid)
								end
							end)
						else
							DropWep(hitwep)
							if IsValid(ply) then
								ent:AddEntityRelationship( ply, D_FR, 99 )
							end
							ent:ClearSchedule()
						end
					end
					if hitwep.ClearStatCache then
						hitwep:ClearStatCache()
					end
					hitwep.Reload = function(v)
						DropWep(v)
					end
				end
			end
		end

		net.Start("LITEGIBDMG")
		net.WriteEntity(ent)

		net.WriteUInt(fixedHitgroup, 4)
		net.WriteInt(math.Round(dmgVal), 12)
		net.WriteUInt(math.Round(dmg:GetDamageType()), 31)
		net.WriteVector(vec)
		if IsValid(wep) then
			net.WriteEntity(wep)
		end
		net.SendPVS(ent:GetPos())
		ent.LGLastNWDamage = CurTime()

		if ent:GetBloodColorLG() ~= DONT_BLEED then
			ent:EmitSound(LiteGibs.Sounds.BloodBurst)
		end
	end

	hook.Add("ScaleNPCDamage", "LGNetworkDamage", NetworkDamage)
	hook.Add("ScalePlayerDamage", "LGNetworkDamage",NetworkDamage)

	hook.Add("EntityTakeDamage", "LGNetworkDamage", function(ent, dmg)

		if ent.LGLastNWDamage and ent.LGLastNWDamage >= CurTime() then return end

		if ent:IsRagdoll() then
			local phys = ent:GetPhysicsObjectNum(0)
			local mat = IsValid(phys) and phys:GetMaterial() or -1 --TODO: HEADCRABS AND DEAD ZOMBIES
			if mat ~= "flesh" and mat~="alienflesh" and mat~="antlion" then return end
		else
			if ent:GetBloodColorLG() == DONT_BLEED then return end
		end
		if(ent:IsPlayer()) then
			NetworkDamage(ent, ent:LastHitGroup() or HITGROUP_GENERIC, dmg)
		end
		if ent.BehaveStart or ent.ClearCondition or ent:IsNPC() or ent:IsRagdoll() then
			NetworkDamage(ent, ent.LastHitGroup or HITGROUP_GENERIC, dmg)
		end
	end)

	hook.Add("PlayerSpawn", "LGPlayerSpawn", function(ply)
		ply.LGDamageTable = nil
		ply.gibbedBones = nil
		net.Start("LITEGIBPS")
		net.WriteEntity(ply)
		net.Broadcast()
	end)
else
	local function WoundEnt(ent, dmg, hg, vec)
		local bloodColor = ent:GetBloodColorLG()

		if bloodColor == DONT_BLEED then return end
		local finalBone = ent:GetClosestBoneInList(vec, LiteGibs.Bones.HitGroupSearch[hg])
		local bn = ent:GetBoneName(finalBone)
		bn = string.Replace(string.lower(bn), "valvebiped.", "")
		bn = string.Replace(string.lower(bn), "bip01_", "")
		local goreModelTable = LiteGibs.GoreModels[ent:GetModel()]
		local woundModelTable = LiteGibs.WoundModels[ent:GetModel()]
		local wound_def = woundModelTable["default"] or LiteGibs.WoundModels["default"].default
		local wound = woundModelTable[bn] or woundModelTable["default"]
		local rad = math.pow(dmg / 50, 0.3) * (wound["scale"] or wound_def["scale"] or 1)
		rad = math.min(rad, wound["clamp"] or wound_def["scale"] or 1)
		ent:Wound(vec, angle_zero, finalBone, wound["model"] or wound_def["model"], rad, goreModelTable[bn] or goreModelTable["default"])
		local fx = EffectData()
		fx:SetOrigin(vec)
		fx:SetColor(bloodColor)
		fx:SetScale(math.min(dmg / 150, math.sqrt(dmg / 180)))
		fx:SetFlags(0)
		fx:SetMagnitude(finalBone)
		util.Effect("lg_blood_spray", fx)
	end

	local function BoneDynamicGib(ent, hg, doGib, dmg)
		local bc = ent:GetBoneCount() - 1
		local searchStrings = {}

		for k, v in pairs(LiteGibs.BoneHitGroups) do
			if v == hg then
				searchStrings[#searchStrings + 1] = k
			end
		end

		for _, v in ipairs(searchStrings) do
			for i = 0, bc do
				local n = string.lower(ent:GetBoneName(i))

				if string.find(n, v) then
					ent:GibBone(n, doGib and LiteGibs.GIB_RAG or LiteGibs.GIB_MODEL, dmg/ 5)

					return
				end
			end
		end
	end

	local function ApplyDamageSubTable(ent, rag, hg)
		local tbl = ent.LGDamageTable[hg]
		if not tbl then return end
		local dmg = tbl.damage
		if not CanGib(ent, dmg, hg) then return end

		if LiteGibs.Bones.HitGroupGibs[hg] then
			local var = LiteGibs.Bones.HitGroupGibs[hg]

			if isstring(var) then
				local doGib = not CanOvergib(ent, dmg, hg) or IsDamageType(tbl.damageType, DMG_SLASH)
				rag:GibBone(var, doGib and LiteGibs.GIB_RAG or LiteGibs.GIB_MODEL, dmg/ 5)
			elseif istable(var) then
				local hasGibbed = false

				for _, v in ipairs(var) do
					if rag:LookupBone(v) then
						local doGib = not CanOvergib(ent, dmg, hg) or IsDamageType(tbl.damageType, DMG_SLASH)
						rag:GibBone(v, doGib and LiteGibs.GIB_RAG or LiteGibs.GIB_MODEL, dmg/ 5)
						hasGibbed = true
						break
					end
				end

				if not hasGibbed then
					BoneDynamicGib(rag, hg, doGib, dmg)
				end
			end
		end
	end

	local function EntityCanGibTable(ent, t)
		for k, v in ipairs(t) do
			if not ent.LGDamageTable[v] then return false end
			if not CanGib(ent, ent.LGDamageTable[v].damage, v) then return false end
		end

		return true
	end

	local function ApplyDamageTable(ent, rag)
		if EntityCanGibTable(ent, {HITGROUP_STOMACH, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG}) or EntityCanGibTable(ent, {HITGROUP_CHEST, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG}) then
			ent:TotalGib()
			
			local cl = string.lower(rag:GetClass())

			if string.find(cl, "hl2mp") or string.find(cl, "prop") or ent:IsNPC() or ent:IsPlayer() then
				rag:SetNoDraw(true)
			else
				rag:Remove()
			end

			return
		end

		ApplyDamageSubTable(ent, rag, HITGROUP_HEAD)
		ApplyDamageSubTable(ent, rag, HITGROUP_LEFTARM)
		ApplyDamageSubTable(ent, rag, HITGROUP_RIGHTARM)
		ApplyDamageSubTable(ent, rag, HITGROUP_LEFTLEG)
		ApplyDamageSubTable(ent, rag, HITGROUP_RIGHTLEG)
		ApplyDamageSubTable(ent, rag, HITGROUP_CHEST)
		ApplyDamageSubTable(ent, rag, HITGROUP_STOMACH)
	end

	net.Receive("LITEGIBDMG", function()
		if LiteGibs.CVars.Enabled and not LiteGibs.CVars.Enabled:GetBool() then return end
		local ent = net.ReadEntity()
		local hitgroup = net.ReadUInt(4)
		local damage = net.ReadInt(12)
		local damageType = net.ReadUInt(31)
		local vec = net.ReadVector()
		local inf = net.ReadEntity()
		if not IsValid(ent) then return end
		if not hitgroup then return end
		if not damage then return end
		if not damageType then return end
		damage = damage * LiteGibs.CVars.DamageMultiplier:GetFloat()

		if IsValid(inf) and inf:IsNPC() then
			local wep = inf:GetActiveWeapon()
			if IsValid(wep) and not wep:IsScripted() then
				damage = damage * 8 --HL2 weapons are scaled by 8
			end
		end

		if not keepcorpses:GetBool() then
			AddToDamageTable(ent, hitgroup, damage, damageType, vec)
			if LiteGibs.CVars.LiveDismember:GetBool() then
				ApplyDamageTable(ent, ent)
			end
		end

		if damage > 1 then
			WoundEnt(ent, damage, hitgroup, vec)
			ent.LGLastDamage = damage
			ent.LGLastHG = hitgroup
			ent.LGLastVec = vec
			ent.LGLastInf = inf

			if damage >=8 then
				LiteGibs.WeaponBlood.FromDamage(damage, vec, ent:GetBloodColorLG())
			end
			LiteGibs.HUDBlood.FromDamage(damage, damageType, vec, ent, inf)
		end
	end)

	net.Receive("LITEGIBPS", function()
		local ent = net.ReadEntity()

		if IsValid(ent) then
			ent.LGDamageTable = nil
			ent:ClearWounds()
			ent.LGDamageTable = nil
			ent.gibbedBones = nil
		end
	end)

	hook.Add("CreateClientsideRagdoll", "LiteGibsCCR", function(ent, rag)
		if LiteGibs.CVars.Enabled and not LiteGibs.CVars.Enabled:GetBool() then return end
		if keepcorpses:GetBool() then return end
		if not IsValid(ent) then return end
		if not ent.LGDamageTable then return end
		ent.Dead=true

		if IsValid(rag) then
			ent.LGDeathRagdoll=rag
			for i = 0, rag:GetPhysicsObjectCount() - 1 do
				local phys = rag:GetPhysicsObjectNum(i)

				if IsValid(phys) then
					phys:SetVelocity(phys:GetVelocity():GetNormalized() * math.pow(phys:GetVelocity():Length() / 100, 0.3) * 100)
				end
			end

			rag.BloodColor = ent:GetBloodColorLG()
			rag.mat = ent:GetMaterial()
			rag.owner = ent
			local index = #LiteGibs.Ragdolls + 1
			LiteGibs.Ragdolls[index] = rag
			rag.gibbedBones = {}
			rag.id = index
			rag:CopyWounds(ent)
			rag.gibbedBones = ent.gibbedBones
			if rag.gibbedBones then
				rag:GibBone(rag:GetBoneName(table.GetKeys(rag.gibbedBones)[1]),LiteGibs.GIB_MODEL,0)
			end

			if LiteGibs.CVars.WoundsLive and not LiteGibs.CVars.WoundsLive:GetBool() then
				WoundEnt(rag, ent.LGLastDamage or 0.1, LGLastHG or HITGROUP_GENERIC, ent.LGLastVec or vector_origin)
			end

			ApplyDamageTable(ent, rag)
		end
	end)
end