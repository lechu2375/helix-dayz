LiteGibs = LiteGibs or {}
local keepcorpses = GetConVar("ai_serverragdolls")

local function IsDamageType(dmg, typev)
	return bit.band(dmg, typev) == typev
end

if SERVER then
	util.AddNetworkString("LGGibBone")
	util.AddNetworkString("LGCopyWounds")
	util.AddNetworkString("LGTotalGib")
	util.AddNetworkString("LGGibBoneInverse")

	hook.Add("CreateEntityRagdoll", "LGCreateEntityRag", function(ent, rag)
		net.Start("LGCopyWounds")
		net.WriteEntity(ent)
		net.WriteEntity(rag)
		net.SendPVS(ent:GetPos())
		rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		rag.BloodColor = ent:GetBloodColorLG()
		timer.Simple(0, function()
			if IsValid(ent) and IsValid(rag) and ent.LGBoneHealth then
				rag:EnableClientGibbing()
				rag.LGBoneHealth = table.Copy(ent.LGBoneHealth)
				rag:GibDamagedBones()
			end
		end)
	end)

	local keepcorpses = GetConVar("ai_serverragdolls")
	local meta = FindMetaTable("Entity")

	if meta then
		function meta:GibBone(baseBone, makeGib, velocity)
			local boneIndex

			if isnumber(baseBone) then
				boneIndex = baseBone
				baseBone = self:GetBoneName(boneIndex)
			else
				boneIndex = self:LookupBone(baseBone)
			end

			if not boneIndex then return end
			if boneIndex == 0 then
				self:TotalGib()
				if self:IsRagdoll() then
					self:Remove()
				end
				return
			end
			self.gibbedBones = self.gibbedBones or {}

			if makeGib == LiteGibs.GIB_RAG and keepcorpses:GetBool() then
				self:MakeGibRagdoll(boneIndex, velocity)
			end

			if self.gibbedBones[boneIndex] then
				makeGib = LiteGibs.GIB_NONE
			end

			local physEdited = {}
			local childBones = self:GetChildBonesRecursive(boneIndex)

			for _, v in ipairs(childBones) do
				local physB = self:TranslateBoneToPhysBone(v)

				if not physEdited[physB] then
					physEdited[physB] = true
					local phys = self:GetPhysicsObjectNum(physB)

					if IsValid(phys) then
						phys:EnableCollisions(false)
						--phys:EnableDrag(false)
						--phys:EnableGravity(false)
						phys:SetMass(phys:GetMass() / 20)
					end

					self.LGBoneHealth[physB] = self.LGBoneHealth[physB] or {}
					self.LGBoneHealth[physB].gibbed = true
				end

				self:ManipulateBoneScale(v, vector_origin)
			end

			self.gibbedBones[boneIndex] = true
			net.Start("LGGibBone")
			net.WriteEntity(self)
			net.WriteString(baseBone)

			if makeGib ~= LiteGibs.GIB_RAG or not keepcorpses:GetBool() then
				net.WriteUInt(makeGib, 5)
			else
				net.WriteUInt(LiteGibs.GIB_NONE, 5)
			end

			net.WriteInt(velocity or 0, 16)
			net.SendPVS(self:GetPos())
		end

		function meta:MakeGibRagdoll(boneIndex, velocity, chunk)
			local rag = ents.Create("prop_ragdoll")
			rag:SetModel(self:GetModel())
			rag:SetPos(self:GetPos())
			rag:SetAngles(self:GetAngles())
			rag:SetSkin(self:GetSkin())
			rag:SetColor(self:GetColor())
			rag:SetMaterial(self:GetMaterial())

			for key, value in pairs(self:GetBodyGroups()) do
				rag:SetBodygroup(value.id, self:GetBodygroup(value.id))
			end

			rag.BloodColor = self:GetBloodColorLG()
			rag.gibbedBones = table.Copy(self.gibbedBones or {})
			rag.LGBoneHealth = table.Copy(self.LGBoneHealth or {})
			local phindex = self:TranslateBoneToPhysBone(boneIndex)
			rag.LGBoneHealth[phindex] = rag.LGBoneHealth[phindex] or {}
			rag.LGBoneHealth[phindex].gibbed = true
			rag.LGBoneHealth[phindex].hp = math.huge
			rag:Spawn()
			rag:SetCollisionGroup(self:GetCollisionGroup())
			local n = rag:GetPhysicsObjectCount()

			for i = 0, n - 1 do
				local phys = rag:GetPhysicsObjectNum(i)
				local myPhys = self:GetPhysicsObjectNum(i)

				if IsValid(phys) and IsValid(myPhys) then
					phys:SetPos(myPhys:GetPos())
					phys:SetAngles(myPhys:GetAngles())
					phys:SetVelocity(myPhys:GetVelocity())
				end
			end

			timer.Simple(0.01, function()
				if not IsValid(rag) then return end
				if not IsValid(self) then return end
				rag:EnableClientGibbing()
				rag:GibBoneInverse(rag:GetBoneName(boneIndex))

				for k, v in pairs(rag.gibbedBones) do
					rag:GibBone(rag:GetBoneName(k), LiteGibs.GIB_NONE_SV, velocity)
				end
			end)
		end

		function meta:GibBoneInverse(baseBone)
			if not self.LGBoneHealth then
				self.LGBoneHealth = {}
			end

			local boneIndex = self:LookupBone(baseBone)
			if not boneIndex then return end
			local childBones = self:GetChildBonesRecursive(boneIndex)
			local physEdited = {}
			local bc = self:GetBoneCount()

			for i = 0, bc - 1 do
				local physB = self:TranslateBoneToPhysBone(i)

				if not table.HasValue(childBones, i) then
					if not physEdited[physB] then
						physEdited[physB] = true
						local phys = self:GetPhysicsObjectNum(physB)

						if IsValid(phys) then
							phys:EnableCollisions(false)
							--phys:EnableDrag(false)
							--phys:EnableGravity(false)
							phys:SetMass(phys:GetMass() / 20)
						end

						self:ManipulateBoneScale(i, vector_origin)
						self.LGBoneHealth[physB] = self.LGBoneHealth[physB] or {}
						self.LGBoneHealth[physB].gibbed = true
						self.LGBoneHealth[physB].hp = math.huge
					end
				end
			end

			net.Start("LGGibBoneInverse")
			net.WriteEntity(self)
			net.WriteString(baseBone)
			net.SendPVS(self:GetPos())
		end

		function meta:TotalGib(vel)
			net.Start("LGTotalGib")
			net.WriteEntity(self)
			net.WriteInt(vel or -1,32)
			net.SendPVS(self:GetPos())
		end

		function meta:DamageBone(bone, damage, damageType)
			if not self.LGBoneHealth then
				self.LGBoneHealth = {}
			end

			local physB = self:TranslateBoneToPhysBone(bone)
			if not physB then return end

			if not self.LGBoneHealth[physB] then
				self.LGBoneHealth[physB] = {}
				local hpMax = LiteGibs.EntityHealth[self:GetClass()]

				if not hpMax and (self:IsNPC() or self:IsPlayer()) then
					hpMax = self:GetMaxHealth()
				else
					hpMax = 100
				end

				local bn = self:GetBoneName(bone) or ""
				local mul = LiteGibs.BoneHealthMultiplier[bn]
				if not mul then
					local hg = -1
					for k,v in pairs(LiteGibs.Bones.HitGroupSearch) do
						if table.HasValue(v, bn) then
							hg = k
						end
					end
					if hg ~= -1 then
						mul = LiteGibs.EntityHitGroupHealth[hg]
					end
				end
				if mul then
					self.LGBoneHealth[physB].hp = hpMax * mul * LiteGibs.BoneHealthGlobalMultiplier
				else
					if not self.LGSummedMass then
						self.LGSummedMass = 0
						for i=0, self:GetPhysicsObjectCount() do
							local p = self:GetPhysicsObjectNum(i)
							if IsValid(p) then
								self.LGSummedMass = self.LGSummedMass + p:GetMass()
							end
						end
					end

					local phys = self:GetPhysicsObjectNum(physB)

					if IsValid(phys) then
						self.LGBoneHealth[physB].hp = math.sqrt(phys:GetMass() / self.LGSummedMass) * hpMax * LiteGibs.BoneHealthGlobalMultiplier * LiteGibs.BoneHealthPhysicsMultiplier
					else
						self.LGBoneHealth[physB].hp = hpMax * 0.5
					end
				end
			end

			self.LGBoneHealth[physB].bone = bone
			self.LGBoneHealth[physB].damage = self.LGBoneHealth[physB].damage or 0

			if IsDamageType(damageType, DMG_BLAST) then
				for i = 0, self:GetPhysicsObjectCount() do
					self.LGBoneHealth[i] = self.LGBoneHealth[i] or {}
					self.LGBoneHealth[i].damage = self.LGBoneHealth[i].damage or 0
					self.LGBoneHealth[i].damage = self.LGBoneHealth[i].damage + damage * math.Rand(2.5, 3.5)
					self.LGBoneHealth[i].damageType = bit.bor(damageType, self.LGBoneHealth[i].damageType or 0)
				end
				self.LGBoneHealth[physB].damage = self.LGBoneHealth[physB].damage + damage / 2
				self.LGBoneHealth[physB].damageType = bit.bor(damageType, self.LGBoneHealth[physB].damageType or 0)
			elseif IsDamageType(damageType, DMG_SLASH) then
				self.LGBoneHealth[physB].damage = self.LGBoneHealth[physB].damage + damage * 4
				self.LGBoneHealth[physB].damageType = bit.bor(damageType, self.LGBoneHealth[physB].damageType or 0)
			else
				self.LGBoneHealth[physB].damage = self.LGBoneHealth[physB].damage + damage
				self.LGBoneHealth[physB].damageType = bit.bor(damageType, self.LGBoneHealth[physB].damageType or 0)
			end

			if IsDamageType(damageType, DMG_ALWAYSGIB) then
				self.LGBoneHealth[physB] = self.LGBoneHealth[physB] or {}
				self.LGBoneHealth[physB].damage = 1000

				if damage < 160 then
					self.LGBoneHealth[physB].damageType = DMG_SLASH
				else
					self.LGBoneHealth[physB].damageType = damageType
				end
			elseif IsDamageType(damageType, DMG_NEVERGIB) then
				self.LGBoneHealth[physB] = self.LGBoneHealth[physB] or {}
				self.LGBoneHealth[physB].damage = 0
				self.LGBoneHealth[physB].damageType = 0
			end
		end

		function meta:GibDamagedBones()
			if not keepcorpses:GetBool() then return end
			for k, v in pairs(self.LGBoneHealth) do
				if not v.gibbed and v.damage and v.hp and v.damage > v.hp then
					local doGib = v.damage < v.hp * 1.3
					if IsDamageType(v.damageType,DMG_SLASH) then
						doGib = true
					end
					self:GibBone(v.bone or self:TranslatePhysBoneToBone(k), doGib and LiteGibs.GIB_RAG or LiteGibs.GIB_MODEL, v.damage / 5)
					v.gibbed = true
				end
			end
		end

		function meta:EnableClientGibbing()
			if IsValid(self.lgdummy) then return end
			local dummy = ents.Create("lg_ragdoll")
			dummy.SetNW2Entity = dummy.SetNW2Entity or dummy.SetNWEntity
			dummy:SetNW2Entity("ragdoll", self)
			dummy:SetModel(self:GetModel())
			dummy.BloodColor = self:GetBloodColorLG()
			dummy:Spawn()
			self.lgdummy = dummy
		end
	end
else
	net.Receive("LGGibBone", function()
		local ent = net.ReadEntity()
		local baseBone = net.ReadString()
		local makeGib = net.ReadUInt(5)
		local velocity = net.ReadInt(16)
		if not IsValid(ent) then return end
		ent:GibBone(baseBone, makeGib, velocity)
	end)

	net.Receive("LGGibBoneInverse", function()
		local ent = net.ReadEntity()
		local baseBone = net.ReadString()
		if not IsValid(ent) then return end
		ent:GibBoneInverse(baseBone)
	end)

	net.Receive("LGCopyWounds", function()
		local ent = net.ReadEntity()
		local rag = net.ReadEntity()

		if IsValid(ent) and IsValid(rag) then
			rag:CopyWounds(ent)
			if not rag.gibbedBones then
				rag.gibbedBones = ent.gibbedBones
			else
				table.Merge(rag.gibbedBones, ent.gibbedBones)
			end
		end
	end)

	net.Receive("LGTotalGib", function()
		local ent = net.ReadEntity()

		if IsValid(ent) then
			local vel = net.ReadInt(32)
			if vel<0 then
				vel=nil
			end
			ent:TotalGib(vel)
		end
	end)
end