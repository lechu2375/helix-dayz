LiteGibs = LiteGibs or {}
LiteGibs.Ragdolls = LiteGibs.Ragdolls or {}
LiteGibs.RagdollGibs = LiteGibs.RagdollGibs or {}
LiteGibs.Gibs = LiteGibs.Gibs or {}
LiteGibs.BoneGibSounds = LiteGibs.BoneGibSounds or {}
LiteGibs.Wounds = LiteGibs.Wounds or {}
LiteGibs.MaxWounds = 32

local LiteGibs = LiteGibs

local splatterMats = {
	[BLOOD_COLOR_RED] = Material("decals/bloodstain_002"),
	[BLOOD_COLOR_GREEN] = Material("decals/yblood4"),
	[BLOOD_COLOR_YELLOW] = Material("decals/yblood4"),
	[BLOOD_COLOR_ANTLION] = Material("decals/yblood4")
}

local decals = {
	[BLOOD_COLOR_RED] = "Blood",
	[BLOOD_COLOR_GREEN] = "YellowBlood",
	[BLOOD_COLOR_YELLOW] = "YellowBlood",
	[BLOOD_COLOR_ANTLION] = "YellowBlood"
}

local downVec = Vector(0, 0, -32)

function LiteGibs.GibCallback(myself, boneCount)
	if myself.gibbedBones then
		for k, v in pairs(myself.gibbedBones) do
			if k > boneCount or v > boneCount then return end

			if myself:GetBoneName(k) ~= "__INVALIDBONE__" then
				local mat = myself:GetBoneMatrix(v)
				if not mat then return end
				mat:Scale(vector_origin)
				myself:SetBoneMatrix(k, mat)
			end
		end
	end
end

local keepcorpses = GetConVar("ai_serverragdolls")
local entMeta = FindMetaTable("Entity")

local function gibImpactSound(myself, physData)
	local vent = GetViewEntity()

	if physData.Speed > 40 and IsValid(vent) and myself:GetPos():Distance(vent:GetPos()) < 12 * 50 then
		sound.Play(LiteGibs.Sounds.GibSplat,physData.HitPos)
	end
end

local function gibImpactRed(myself, physData)
	if physData.Speed > 100 and physData.HitPos then
		util.Decal("Blood", physData.HitPos - physData.HitNormal * 4, physData.HitPos + physData.HitNormal)
		local fx = EffectData()
		fx:SetOrigin(physData.HitPos)
		fx:SetNormal(physData.HitNormal)
		fx:SetColor(BLOOD_COLOR_RED)
		util.Effect("BloodImpact", fx)
	end
end

local function gibImpactGreen(myself, physData)
	if physData.Speed > 100 and physData.HitPos then
		util.Decal("yellowblood", physData.HitPos - physData.HitNormal * 4, physData.HitPos + physData.HitNormal)
		local fx = EffectData()
		fx:SetOrigin(physData.HitPos)
		fx:SetNormal(physData.HitNormal)
		fx:SetColor(BLOOD_COLOR_GREEN)
		util.Effect("BloodImpact", fx)
	end
end

local gibQueue = {}

local function makeGibModels(ent, boneName, vel)
	if not LiteGibs.CVars.GibsEnabled:GetBool() then return end
	local gibTable = LiteGibs.GibModels[ent:GetModel()]
	local t = gibTable[boneName] or gibTable["default"]
	local default = (gibTable["default"]==t)
	local bone = ent:LookupBone(boneName)
	if not bone then return end
	local bpos, bang = ent:GetBonePosition(bone)
	if not bpos then return end
	if not bang then return end
	if math.abs(bpos.z) > 16000 then return end
	local maxQueue = LiteGibs.CVars.GibsQueue:GetInt()
	if default and #gibQueue>maxQueue/2 then
		t.count = 1
	end
	for i = 1, t.count or 1 do
		local gt = {}

		if t.orderedModels then
			gt.mdl = t.models[i]
		else
			gt.mdl = table.Random(t.models)
		end

		gt.pos = bpos
		gt.ang = bang
		gt.mat = t.material or t.mat
		gt.scale = t.scale
		gt.velocity = VectorRand() * vel
		local phys = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(bone) or 0)

		if IsValid(phys) then
			gt.velocity = gt.velocity + phys:GetVelocity()
		end

		gt.bloodColor = ent:GetBloodColorLG()
		gt.bone=boneName
		if #gibQueue < maxQueue then
			gibQueue[#gibQueue + 1] = gt
		end
	end
end

local cv_dev = GetConVar("developer")

hook.Add("PreRender", "LiteGisGibQueue", function()
	local toRemove = {}
	local gibsPerFrame = LiteGibs.CVars.GibsRate:GetInt()
	local count = math.min(#gibQueue, gibsPerFrame)
	for i = 1, count do
		local t = gibQueue[i]
		table.insert(toRemove, 1, i)
		if t then
			local cmod = ClientsideModel(t.mdl)
			cmod:PhysicsInit(SOLID_VPHYSICS)
			//print(cmod:GetPhysicsObject())
			if not IsValid(cmod) then return end

			cmod:SetPos(t.pos + VectorRand() * 3)
			cmod:SetAngles(t.ang)

			cmod:SetMaterial(t.mat)

			local gibModelScale = 1

			if t.scale then
				gibModelScale = istable(t.scale) and math.Rand(t.scale[1], t.scale[2]) or t.scale

				cmod:SetModelScale(gibModelScale, 0)
			end

			cmod:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			cmod:SetCollisionBounds(cmod:OBBMins() * gibModelScale, cmod:OBBMaxs() * gibModelScale)
			cmod:PhysicsInit(SOLID_VPHYSICS)
			local physObj = cmod:GetPhysicsObject()

			if IsValid(physObj) and gibModelScale ~= 1 then
				local physMeshes = physObj:GetMeshConvexes()

				if type(physMeshes)=="table" and #physMeshes >= 1 then
					local newPhysMeshes = {}

					for _, mesh in pairs( physMeshes ) do
						local newPhysMesh = {}

						for k, v in pairs( mesh ) do
							table.insert(newPhysMesh, v.pos * gibModelScale)
						end

						table.insert(newPhysMeshes, newPhysMesh)
					end

					if #newPhysMeshes >= 1 and #newPhysMeshes[1] >= 1 then
						cmod:PhysicsInitMultiConvex( newPhysMeshes )
						cmod:EnableCustomCollisions( true )
					end
				end

				physObj = cmod:GetPhysicsObject()
			end

			local boner = cmod:LookupBone(t.bone)
			
			if boner and physObj:IsValid() then
				local bonerPos, bonerAng = cmod:GetBonePosition(boner)
				local posOff, angOff = WorldToLocal( physObj:GetPos(), physObj:GetAngles(), bonerPos, bonerAng)
				local newPos, newAng = LocalToWorld(posOff,angOff,t.pos,t.ang)
				physObj:SetPos(newPos,true)
				physObj:SetAngles(newAng,true)
				--physObj:EnableGravity(false)
			end

			if physObj:IsValid() then
				--physObj:SetDamping(0.1, 1)
				--physObj:SetMass(5)
				physObj:SetMaterial("gmod_silent")
				physObj:SetVelocity(t.velocity)
				physObj:AddAngleVelocity(t.velocity * 1)
				physObj:Wake()
			end

			cmod:Activate()
			cmod:DrawShadow(false)
			cmod:SetRenderMode(RENDERMODE_NORMAL)

			if LiteGibs.CVars.GibsSound:GetBool() then
				cmod:AddCallback("PhysicsCollide", gibImpactSound)
			end

			if LiteGibs.CVars.GibsBlood:GetBool() then
				if t.bloodColor == BLOOD_COLOR_RED then
					cmod:AddCallback("PhysicsCollide", gibImpactRed)
				elseif t.bloodColor == BLOOD_COLOR_GREEN then
					cmod:AddCallback("PhysicsCollide", gibImpactGreen)
				elseif t.bloodColor == BLOOD_COLOR_ANTLION then
					cmod:AddCallback("PhysicsCollide", gibImpactGreen)
				elseif t.bloodColor == BLOOD_COLOR_YELLOW then
					cmod:AddCallback("PhysicsCollide", gibImpactGreen)
				elseif t.bloodColor == BLOOD_COLOR_ZOMBIE then
					cmod:AddCallback("PhysicsCollide", gibImpactRed)
				end
			end

			table.insert(LiteGibs.Gibs, {CurTime(), cmod})
		end
	end
	for i = 1,#toRemove do
		table.remove(gibQueue,toRemove[i])
	end
	if #gibQueue > 0 and cv_dev:GetBool() then
		PrintTable(gibQueue)
	end
end)

local fleshMat = Material("models/flesh")

local function RenderWounds(ent)
	if not IsValid(ent.goreModel) then
		ent:DrawModel()

		return
	end

	if not ent.LiteGibWounds then
		ent:DrawModel()

		return
	end

	if halo.RenderedEntity() == ent then
		ent:DrawModel()

		return
	end

	if #ent.LiteGibWounds == 0 then
		ent:DrawModel()

		return
	end

	--start off by clearing stencil
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	--first we write the entity to the stencil buffer with value 1
	--writing to the depth buffer but not color allows us to clip the wound with the model
	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.CullMode(MATERIAL_CULLMODE_CCW)
	render.OverrideColorWriteEnable(true, false)
	ent:DrawModel()
	render.OverrideColorWriteEnable(false, false)
	--now we write the wound model, which increments the see-through areas to stencil value 2
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_INCR)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetBlend(0)
	render.OverrideDepthEnable(true, false)

	for _, v in ipairs(ent.LiteGibWounds) do
		if IsValid(v.model) and v.bone and v.pos and v.ang then
			local mat = ent:GetBoneMatrix(v.bone)

			if mat then
				local bpos, bang
				bpos = mat:GetTranslation()
				bang = mat:GetAngles()
				local pos, ang = LocalToWorld(v.pos, v.ang, bpos, bang)
				v.model:SetupBones()
				v.model:SetRenderOrigin(pos)
				v.model:SetRenderAngles(ang)
				v.model:DrawModel()
			end
		end
	end

	render.OverrideDepthEnable(false, false)
	render.SetBlend(1)
	--now we clear the depth of the wound area
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	render.OverrideColorWriteEnable(true, false)
	render.ClearBuffersObeyStencil(0, 0, 0, 0, true)
	render.OverrideColorWriteEnable(false, false)
	--now we write, in order, the fleshy interior of the model, and the wound model
	render.SetStencilReferenceValue(2)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.ModelMaterialOverride(fleshMat)
	render.CullMode(MATERIAL_CULLMODE_CW)
	ent:DrawModel()
	render.OverrideDepthEnable(true, false)
	render.CullMode(MATERIAL_CULLMODE_CCW)
	ent.goreModel:SetupBones()
	ent.goreModel:DrawModel()
	render.OverrideDepthEnable(false, false)
	render.ModelMaterialOverride()
	render.SetStencilReferenceValue(2)
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	ent:DrawModel()
	render.ClearStencil()
	render.SetStencilEnable(false)
end

if entMeta then
	local bloodDripThreshold = 3
	local upVec = Vector(0,0,1)
	function entMeta:InitializeDripBlood()
		self.BloodDripPoints = self.BloodDripPoints or {}
		local s = tostring(self) .. (self.id or "")
		if timer.Exists(s .. "dripblood") then return end
		timer.Create(s .. "dripblood", 0.5, 0, function()
			if not IsValid(self) then
				timer.Remove(s .. "dripblood")
				return
			end
			for _, v in ipairs(self.BloodDripPoints) do
				if (self.Alive and self:Alive()) or not self.Alive then
					local bonePos, boneAng = self:GetBonePosition(v.bone)
					if bonePos and boneAng and CurTime() < v.die and not (self.gibbedBones and self.gibbedBones[v.bone]) then
						local pos = LocalToWorld(v.pos,angle_zero,bonePos,boneAng)
						if v.lastDripPos:Distance(pos)>bloodDripThreshold then
							v.dripCount = 0
						end
						if v.dripCount < v.dripMax then
							local fx = EffectData()
							fx:SetOrigin(pos)
							fx:SetNormal(upVec)
							fx:SetFlags(self.id or self:EntIndex() or 1)
							fx:SetMagnitude(v.bone)
							fx:SetScale(v.scale)
							fx:SetAttachment(0)
							util.Effect("lg_blood_pool",fx)
							v.dripCount = v.dripCount + 1
						end
					end
				end
			end
		end)
	end
	function entMeta:DripBlood(localPos, bone, time, scale)
		if not LiteGibs.CVars.BloodPoolEnabled:GetBool() then return end
		self.BloodDripPoints = self.BloodDripPoints or {}
		self.BloodDripPoints[( #self.BloodDripPoints % 5) + 1] = {
			["pos"] = localPos,
			["bone"] = bone,
			["die"] = CurTime() + (time or 10),
			["scale"] = scale or 0.3,
			["dripCount"] = 0,
			["dripMax"] = 3,
			["lastDripPos"] = Vector()
		}
		self:InitializeDripBlood()
	end
	function entMeta:CopyDripBlood(ent)
		self.BloodDripPoints = table.Copy(ent.BloodDripPoints or {})
		self:InitializeDripBlood()
	end

	function entMeta:ClearWounds()
		if IsValid(self.goreModel) then
			SafeRemoveEntityDelayed(self.goreModel, 0.1)
		end

		if not self.LiteGibWounds then return end
		local toremove

		for k, v in ipairs(self.LiteGibWounds) do
			toremove = toremove or {}
			toremove[#toremove + 1] = k

			if IsValid(v.model) then
				SafeRemoveEntityDelayed(v.model, 0.1)
			end
		end

		if not toremove then return end

		-- remove in backward direction so we save time
		for i = #toremove, 1, -1 do
			table.remove(self.LiteGibWounds, toremove[i])
		end
	end

	function entMeta:AddWoundModel(model, scale, localPos, localAng, bone)
		if LiteGibs.CVars.WoundsEnabled and not LiteGibs.CVars.WoundsEnabled:GetBool() then return end
		if ((self.Alive and self:Alive()) or self:IsNPC()) and LiteGibs.CVars.WoundsLive and not LiteGibs.CVars.WoundsLive:GetBool() then return end
		if self.gibbedBones and self.gibbedBones[bone] then return end
		if not IsValid(self) then return end
		self.LiteGibWounds = self.LiteGibWounds or {}
		local woundModel = ClientsideModel(model)
		woundModel:SetOwner(self)
		woundModel:SetNoDraw(true)
		woundModel:DrawShadow(false)
		woundModel:SetModelScale(scale, 0)
		woundModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))
		local t = {self, woundModel}

		if LiteGibs.CVars.WoundsLimit then
			LiteGibs.MaxWounds = LiteGibs.CVars.WoundsLimit:GetInt()
		end

		if #LiteGibs.Wounds >= LiteGibs.MaxWounds then
			local tMax = LiteGibs.Wounds[LiteGibs.MaxWounds]

			if tMax and IsValid(tMax[2]) then
				SafeRemoveEntityDelayed(tMax[2], 0.1)
			end

			table.insert(LiteGibs.Wounds, 1, t)
		else
			LiteGibs.Wounds[#LiteGibs.Wounds + 1] = t
		end

		self.LiteGibWounds[#self.LiteGibWounds + 1] = {
			["pos"] = localPos,
			["ang"] = localAng,
			["model"] = woundModel,
			["modelpath"] = model,
			["scale"] = scale,
			["bone"] = bone
		}
	end

	function entMeta:CopyWounds(ent)
		if not ent.LiteGibWounds then return end

		for k, v in ipairs(ent.LiteGibWounds) do
			if not (self.gibbedBones and self.gibbedBones[v.bone]) then
				self:AddWoundModel(v.modelpath, v.scale, v.pos, v.ang, v.bone)
			end
		end

		self:CopyDripBlood(ent)
		self:Wound()
	end

	function entMeta:Wound(ogPos, ogAng, bone, woundModel, woundModelScale, goreModel)
		if self.WoundProxy then
			return self.WoundProxy:Wound(ogPos, ogAng, bone, woundModel, woundModelScale, goreModel)
		end
		if LiteGibs.CVars.WoundsEnabled and not LiteGibs.CVars.WoundsEnabled:GetBool() then return end
		self:SetupBones()

		if not IsValid(self.goreModel) then
			self.goreModel = ClientsideModel(goreModel or "models/player/skeleton.mdl")
			self.goreModel:SetParent(self)
			self.goreModel:AddEffects(EF_BONEMERGE)
			--self.goreModel:AddEffects(EF_BONEMERGE_FASTCULL)
			self.goreModel:SetNoDraw(true)
			self.goreModel:DrawShadow(false)
			local findTable

			-- iterate in backward direction because
			-- we mostly create gibs for newly created
			-- LiteGibs.RagdollGibs entry
			for i = #LiteGibs.RagdollGibs, 1, -1 do
				if LiteGibs.RagdollGibs[i][1] == self then
					findTable = LiteGibs.RagdollGibs[i]
					break
				end
			end

			if not findTable then
				findTable = {self, {}}
				table.insert(LiteGibs.RagdollGibs, findTable)
			end

			table.insert(findTable[2], self.goreModel)
		end

		if not self.RenderOverride then
			self.RenderOverride = RenderWounds
		end

		local p, a = self:GetBonePosition(bone or -1)
		if not ogPos then return end
		if not p then return end
		if not a then return end
		local woundTable = LiteGibs.WoundRadius[self:GetModel()]
		local radius = woundTable[string.lower(self:GetBoneName(bone))] or woundTable["default"]
		local boneCenter = self:GetBoneCenter(bone)
		local newPos = ogPos
		local nrm = (boneCenter - p):GetNormalized()
		local dist = ogPos:Distance(boneCenter)
		newPos = util.IntersectRayWithPlane(p, nrm, ogPos, nrm)
		woundModel = woundModel or "models/combine_helicopter/helicopter_bomb01.mdl"
		local woundrad = LiteGibs.WoundModelRadius[string.lower(woundModel)] or 8
		woundrad = woundrad * woundModelScale

		if newPos then
			if dist > radius then
				newPos = newPos + (ogPos - newPos):GetNormalized() * math.max(0, radius - woundrad)
			else
				newPos = newPos + (ogPos - newPos):GetNormalized() * math.max(0, dist - woundrad)
			end
		else
			if dist > radius then
				newPos = boneCenter + (ogPos - boneCenter):GetNormalized() * math.max(0, radius - woundrad)
			else
				newPos = boneCenter + (ogPos - boneCenter):GetNormalized() * math.max(0, dist - woundrad)
			end
		end

		local localPos, localAng = WorldToLocal(newPos, ogAng, p, a)
		self:AddWoundModel(woundModel, woundModelScale or 1, localPos, localAng, bone)
		self:DripBlood(localPos, bone, math.sqrt(woundrad / 3) * 10, math.sqrt(woundrad / 3))
	end

	function entMeta:TotalGib(vel)
		self:SetNoDraw(true)
		if IsValid(self.LGParentEntity) then
			self.LGParentEntity:EmitSound(LiteGibs.Sounds.TotalGib)
		else
			self:EmitSound(LiteGibs.Sounds.TotalGib)
		end

		local fx = EffectData()
		fx:SetOrigin(self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Pelvis") or 0))
		fx:SetScale(5)
		fx:SetColor(self:GetBloodColorLG())
		util.Effect("lg_blood_puff", fx)
		fx:SetScale(2.5)
		fx:SetFlags(0)
		util.Effect("lg_blood_spray", fx)
		local traceRes = util.QuickTrace(self:GetPos(), downVec, self)

		if traceRes.Hit and traceRes.Fraction < 1 then
			util.DecalEx(splatterMats[self:GetBloodColorLG()] or splatterMats[BLOOD_COLOR_RED], traceRes.Entity, traceRes.HitPos, traceRes.HitNormal, color_white, 1, 1)
		end

		for i = 0, self:GetBoneCount() - 1 do
			local bn = self:GetBoneName(i)

			if bn then
				makeGibModels(self, string.lower(bn), vel or 200)
			end
		end
	end

	function entMeta:GibBone(baseBone, makeGib, velocity)
		if not self.id then
			local index = #LiteGibs.Ragdolls + 1
			LiteGibs.Ragdolls[index] = self
			self.gibbedBones = self.gibbedBones or {}
			self.id = index
		end

		if not self.HasAddedGibCallback then
			self:AddCallback("BuildBonePositions", LiteGibs.GibCallback)
			self.HasAddedGibCallback = true
		end

		local boneIndex = self:LookupBone(baseBone)
		if not boneIndex then return end
		local bPos = self:GetBonePosition(boneIndex)

		if makeGib == LiteGibs.GIB_NONE_SV then
			self.gibbedBones = self.gibbedBones or {}
			local childBones = self:GetChildBonesRecursive(boneIndex)

			if self.LiteGibWounds then
				for k, v in ipairs(self.LiteGibWounds) do
					if table.HasValue(childBones, v.bone) then
						v.model:Remove()
					end
				end
			end

			for _, v in pairs(childBones) do
				self.gibbedBones[v] = boneIndex
			end

			return
		end

		if not self.HasMadeDecal then
			local traceRes = util.QuickTrace(self:GetPos(), downVec, self)

			if traceRes.Hit and traceRes.Fraction < 1 then
				util.Decal(decals[self:GetBloodColorLG()] or decals[BLOOD_COLOR_RED], traceRes.HitPos - traceRes.HitNormal * 2, traceRes.HitPos + traceRes.HitNormal, traceRes.Entity)
			end

			self.HasMadeDecal = true
		end

		self.gibbedBones = self.gibbedBones or {}

		if self.gibbedBones[boneIndex] then
			makeGib = LiteGibs.GIB_NONE
		else
			local fx = EffectData()
			fx:SetFlags(self.id)
			fx:SetMagnitude(boneIndex) --self:GetBoneParent(boneIndex))
			self:SetupBones()
			fx:SetOrigin(self:GetBonePosition(boneIndex))
			fx:SetColor(self:GetBloodColorLG())
			util.Effect("lg_blood_stream", fx)

			if makeGib == LiteGibs.GIB_RAG then
				fx:SetScale(0.5)
				util.Effect("lg_blood_puff", fx)
				util.Effect("lg_blood_spray", fx)
			else
				fx:SetScale(0.7)
				util.Effect("lg_blood_spray", fx)
			end

			local snd = LiteGibs.BoneGibSounds[string.lower(tostring(baseBone))] or LiteGibs.BoneGibSounds["default"]

			if IsValid(self.LGParentEntity) then
				self.LGParentEntity:EmitSound(snd)
			else
				self:EmitSound(snd)
			end
		end

		local rag

		if makeGib == LiteGibs.GIB_RAG then
			rag = self:MakeGibRagdoll(boneIndex, velocity)
		end

		local childBones = self:GetChildBonesRecursive(boneIndex)

		if self.LiteGibWounds then
			for k, v in ipairs(self.LiteGibWounds) do
				if table.HasValue(childBones, v.bone) then
					v.model:Remove()
				end
			end
		end

		for _, bone in ipairs(childBones) do
			if self:BoneHasFlag(bone, BONE_USED_BY_VERTEX_MASK) then
				if not self.gibbedBones[bone] then
					if makeGib == LiteGibs.GIB_MODEL then
						makeGibModels(self, string.lower(self:GetBoneName(bone)), (velocity or 100) )
					elseif makeGib == LiteGibs.GIB_CHUNK then
						self:MakeGibRagdoll(bone, velocity, true)
					end

					if makeGib ~= LiteGibs.GIB_RAG then
						local fx = EffectData()
						fx:SetOrigin(self:GetBonePosition(bone))
						fx:SetScale(1)
						fx:SetColor(self:GetBloodColorLG())
						util.Effect("lg_blood_puff", fx)
					end
				end

				self.gibbedBones[bone] = boneIndex
				local boneid = self:TranslateBoneToPhysBone(bone)

				if boneid and self:GetPhysicsObjectCount() >= boneid then
					local phys = self:GetPhysicsObject(boneid)

					if phys and phys:IsValid() then
						phys:EnableCollisions(false)
						phys:SetMass(math.min(phys:GetMass(),5))
						--phys:EnableDrag(false)
						--phys:EnableGravity(false)
					end
				end
			end
		end

		local par = self:GetBoneParent(boneIndex)

		if par and par > -1 then
			local bn = string.lower(baseBone)

			if makeGib == LiteGibs.GIB_RAG then
				local woundTable = LiteGibs.WoundRadius[self:GetModel()]
				local rad = math.sqrt((woundTable[bn] or woundTable["default"] or 4) / 4) * 4
				self:Wound(bPos, angle_zero, par, "models/Combine_Helicopter/helicopter_bomb01.mdl", rad * 0.08)

				if IsValid(rag) then
					rag:Wound(bPos, angle_zero, boneIndex, "models/Combine_Helicopter/helicopter_bomb01.mdl", rad * 0.05)
				end
			elseif makeGib == LiteGibs.GIB_MODEL then
				local woundTable = LiteGibs.WoundRadius[self:GetModel()]
				local rad = math.sqrt((woundTable[bn] or woundTable["default"] or 4) / 4) * 4
				self:Wound(bPos, angle_zero, par, "models/Combine_Helicopter/helicopter_bomb01.mdl", rad * 0.08)
			end
		end
	end

	function entMeta:MakeCloneRagdoll()
		if not LiteGibs.CVars.LimbsEnabled:GetBool() then return end
		local rag = ClientsideRagdoll(self:GetModel())
		rag.gibbedBones = table.Copy(self.gibbedBones or {})

		if self:IsRagdoll() then
			for i = 0, self:GetPhysicsObjectCount() - 1 do
				local myPhys = self:GetPhysicsObjectNum(i)
				local phys = rag:GetPhysicsObjectNum(i)
				phys:SetPos(myPhys:GetPos())
				phys:SetAngles(myPhys:GetAngles())
				phys:SetVelocity(myPhys:GetVelocity())
			end
		else
			for i = 0, rag:GetPhysicsObjectCount() - 1 do
				local phys = rag:GetPhysicsObjectNum(i)
				local bpos, bang = self:GetBonePosition(math.max(rag:TranslatePhysBoneToBone(i) or 0),0)
				phys:SetPos(bpos)
				phys:SetAngles(bang)
				phys:SetVelocity(self:GetVelocity())
			end
		end

		rag:SetPos(self:GetPos())
		rag:SetAngles(self:GetAngles())
		rag:SetSkin(self:GetSkin())

		for i = 1, #self:GetBodyGroups() do
			rag:SetBodygroup(i, self:GetBodygroup(i))
		end

		rag:SetMaterial(self.mat)
		rag:SetNoDraw(false)
		rag:DrawShadow(true)

		return rag
	end

	function entMeta:MakeGibRagdoll(boneIndex, velocity, chunk)
		if not LiteGibs.CVars.LimbsEnabled:GetBool() then return end
		if chunk and string.find(string.lower(self:GetBoneName(boneIndex)), "finger") then return end
		local baseBone = self:GetBoneName(boneIndex)
		if baseBone == "__INVALIDBONE__" then return end
		local rag = ClientsideRagdoll(self:GetModel())
		rag:SetPos(self:GetPos())
		rag:SetAngles(self:GetAngles())
		rag.gibbedBones = chunk and {} or table.Copy(self.gibbedBones)
		local vel = velocity or 100

		if keepcorpses:GetBool() or not self:IsRagdoll() then
			for i = 0, rag:GetPhysicsObjectCount() - 1 do
				local p, a = self:GetBonePosition(self:TranslatePhysBoneToBone(i) or 0)
				local phys = rag:GetPhysicsObjectNum(i)
				phys:SetPos(p)
				phys:SetAngles(a)
				phys:SetVelocity(VectorRand() * vel)
			end
		else
			for i = 0, self:GetPhysicsObjectCount() - 1 do
				local myPhys = self:GetPhysicsObjectNum(i)
				local phys = rag:GetPhysicsObjectNum(i)
				phys:SetPos(myPhys:GetPos())
				phys:SetAngles(myPhys:GetAngles())
				phys:SetVelocity(myPhys:GetVelocity() + VectorRand() * vel)
			end
		end

		rag:GibBoneInverse(baseBone)

		if chunk then
			for _, bone in ipairs(self:GetChildBonesRecursive(boneIndex)) do
				if bone ~= boneIndex then
					rag.gibbedBones[bone] = boneIndex
				end
			end
		end

		rag:SetSkin(self:GetSkin())

		for i = 1, #self:GetBodyGroups() do
			rag:SetBodygroup(i, self:GetBodygroup(i))
		end

		rag:SetMaterial(self.mat)
		rag:SetNoDraw(false)
		rag:DrawShadow(true)

		if chunk then
			timer.Simple(5, function()
				if IsValid(rag) then
					rag:Remove()
				end
			end)
		else
			rag:CopyWounds(self)
			local findTable

			-- iterate in backward direction because
			-- we mostly create gibs for newly created
			-- LiteGibs.RagdollGibs entry
			for i = #LiteGibs.RagdollGibs, 1, -1 do
				if LiteGibs.RagdollGibs[i][1] == self then
					findTable = LiteGibs.RagdollGibs[i]
					break
				end
			end

			if not findTable then
				findTable = {self, {}}
				table.insert(LiteGibs.RagdollGibs, findTable)
			end

			table.insert(findTable[2], rag)
			local index = #LiteGibs.Ragdolls + 1
			LiteGibs.Ragdolls[index] = rag
			rag.id = index
			rag.isGib = true

			if LiteGibs.Bones.BloodStream[string.lower(tostring(baseBone))] and not chunk then
				rag:SetupBones()
				local fx = EffectData()
				fx:SetFlags(rag.id)
				fx:SetMagnitude(boneIndex) --self:GetBoneParent(boneIndex))
				fx:SetOrigin(rag:GetBonePosition(boneIndex))
				fx:SetColor(self:GetBloodColorLG())
				util.Effect("lg_blood_stream", fx)
				fx:SetScale(1)
				util.Effect("lg_blood_spray", fx)
			end
		end

		return rag
	end

	function entMeta:GibBoneInverse(baseBone)
		local boneIndex = self:LookupBone(baseBone)
		if not boneIndex then return end
		local childBones = self:GetChildBonesRecursive(boneIndex)
		self.gibbedBones = self.gibbedBones or {}

		for i = 0, self:GetBoneCount() - 1 do
			if (not table.HasValue(childBones, i)) and self:BoneHasFlag(i, BONE_USED_BY_VERTEX_MASK) then
				self.gibbedBones[i] = boneIndex
				local phys = self:GetPhysicsObject(self:TranslateBoneToPhysBone(i))

				if phys and phys:IsValid() then
					phys:EnableCollisions(false)
					phys:EnableDrag(false)
					phys:EnableGravity(false)
				end
			end
		end

		if not self.HasAddedGibCallback then
			self:AddCallback("BuildBonePositions", LiteGibs.GibCallback)
			self.HasAddedGibCallback = true
		end
	end
end

LiteGibs.GibFade = 1
local color_white = Color(255, 255, 255)

hook.Add("PreRender", "LiteGibsFadeGibs", function()
	local life = LiteGibs.CVars.GibsTime:GetFloat()
	local fade = math.min(LiteGibs.GibFade, life)
	local ctime = CurTime()
	local toremove

	for i, data in ipairs(LiteGibs.Gibs) do
		if IsValid(data[2]) then
			local gib = data[2]
			if not gib.hasShadow then
				gib:CreateShadow()
			end
			if ctime > data[1] + life then
				gib:Remove()
			else
				color_white.a = 255 - math.Clamp(ctime - data[1] - life + fade, 0, fade) / fade * 255
				if (color_white.a <= 254) then
					if not gib.lg_talpha then
						gib:SetRenderMode(RENDERMODE_TRANSALPHA)
						gib.lg_talpha = true
					end
				end
				gib:SetColor(color_white)
			end
		else
			toremove = toremove or {}
			table.insert(toremove, i)
		end
	end

	if not toremove then return end

	-- remove in backward direction so we save time
	for i = #toremove, 1, -1 do
		table.remove(LiteGibs.Gibs, toremove[i])
	end
end)

hook.Add("PreCleanupMap", "LiteGibsCleanup", function()
	for i, data in ipairs(LiteGibs.Gibs) do
		if IsValid(data[2]) then
			data[2]:Remove()
		end
	end

	LiteGibs.Gibs = {}

	for i, data in ipairs(LiteGibs.RagdollGibs) do
		for i2, gib in ipairs(data[2]) do
			if IsValid(gib) then
				gib:Remove()
			end
		end
	end

	LiteGibs.RagdollGibs = {}

	for i, data in ipairs(LiteGibs.Wounds) do
		local wound = data[2]

		if IsValid(wound) then
			SafeRemoveEntityDelayed(wound, 0.1)
		end
	end

	LiteGibs.Wounds = {}
end)

hook.Add("CreateClientsideRagdoll", "LiteGibsAddRagdollParent", function(ent, ragdoll)
	ragdoll.LGParentEntity = ent
	if IsValid(ragdoll) then
		for i = #LiteGibs.RagdollGibs, 1, -1 do
			if LiteGibs.RagdollGibs[i][1] == ent then
				LiteGibs.RagdollGibs[i][1]=ragdoll
				break
			end
		end
	end
end)

hook.Add("EntityRemoved", "LiteGibsGarbageColectWounds", function(ent)
	ent:ClearWounds()
end)

timer.Create("LiteGibsGarbageCollectWounds", 1, 0, function()
	local toremove

	for i, data in ipairs(LiteGibs.Wounds) do
		local par = data[1]
		local wound = data[2]

		if not IsValid(par) or not IsValid(wound) then
			toremove = toremove or {}
			toremove[#toremove + 1] = i

			if IsValid(wound) then
				SafeRemoveEntityDelayed(wound, 0.1)
			end
		end
	end

	if not toremove then return end

	-- remove in backward direction so we save time
	for i = #toremove, 1, -1 do
		table.remove(LiteGibs.Wounds, toremove[i])
	end
end)

timer.Create("LiteGibsGarbageCollectRagdollGibs", 1, 0, function()
	local toremove

	for i, data in ipairs(LiteGibs.RagdollGibs) do
		if not IsValid(data[1]) then
			toremove = toremove or {}
			table.insert(toremove, i)

			for i2, gib in ipairs(data[2]) do
				if IsValid(gib) then
					gib:Remove()
				end
			end
		end
	end

	if not toremove then return end

	-- remove in backward direction so we save time
	for i = #toremove, 1, -1 do
		table.remove(LiteGibs.RagdollGibs, toremove[i])
	end
end)
--functions which are now unused
--[[
function entMeta:CacheBoneHierarchy()
	local mdl = self:GetModel()
	if modelBoneTable[mdl] then return end
	self:SetupBones()
	local t = {}
	local bc = self:GetBoneCount()

	for i = 0, bc - 1 do
		local par = self:GetBoneParent(i)
		if par ~= -1 then
			t[par] = t[par] or {}
			local part = t[par]
			part[#part + 1] = i
		end
	end

	modelBoneTable[mdl] = t
end
]]
--