local entMeta = FindMetaTable("Entity")
local plyMeta = FindMetaTable("Player")

if plyMeta then
	plyMeta.GetRagdollEntityOld = plyMeta.GetRagdollEntityOld or plyMeta.GetRagdollEntity
	function plyMeta:GetRagdollEntity()
		if IsValid(self.LGDeathRagdoll) then
			return self.LGDeathRagdoll
		end
		if self.GetRagdollEntityOld then
			return self:GetRagdollEntityOld()
		end
		return nil
	end
end


if entMeta then
	local modelBoneCache = {}
	local modelPhysBoneTranslateCache = {}

	if SERVER then
		function entMeta:SetupBones()
		end
	end

	if not entMeta.LG_OLD_TranslatePhysBoneToBone then
		entMeta.LG_OLD_TranslatePhysBoneToBone = entMeta.TranslatePhysBoneToBone
	end

	function entMeta:CachePhysBones(forced)
		local mdl = self:GetModel()
		if modelPhysBoneTranslateCache[mdl] and not forced then
			return
		end

		local t = {}

		for i = 0, self:GetBoneCount() - 1 do
			local phys = self:TranslateBoneToPhysBone(i)
			if not t[phys] then
				t[phys] = i
			end
		end
		modelPhysBoneTranslateCache[mdl] = t
		return modelPhysBoneTranslateCache[mdl]
	end

	function entMeta:TranslatePhysBoneToBone(b,...)
		local md = self:GetModel()
		local t = modelPhysBoneTranslateCache[md]
		if not t then
			t = self:CachePhysBones()
		end
		return t[b] or self.LG_OLD_TranslatePhysBoneToBone(self,b,...)
	end

	entMeta.GetRagdollEntity = plyMeta.GetRagdollEntity

	function entMeta:GetClosestBone(pos)
		local biggestDist = math.huge
		local b

		for i = 0, self:GetBoneCount() - 1 do
			local p = self:GetBoneCenter(i)
			local d = pos:Distance(p)

			if d < biggestDist then
				biggestDist = d
				b = i
			end
		end

		return b
	end

	function entMeta:GetClosestPhysicsEnabledBone(pos)
		local bonelist = {}
		local cached = {}

		for i = 0, self:GetBoneCount() - 1 do
			local phys = self:TranslateBoneToPhysBone(i)
			if not cached[phys] then
				bonelist[#bonelist + 1] = i
				cached[phys]=true
			end
		end

		return self:GetClosestBoneInList(pos, bonelist)
	end

	local lo = string.lower

	function entMeta:GetClosestPhysicalBone(pos)
		local bonelist = {}

		for i = 0, self:GetPhysicsObjectCount() do
			local b = self:TranslatePhysBoneToBone(i)
			if not LiteGibs.Bones.Blacklist[lo(self:GetBoneName(b))] then
				bonelist[#bonelist + 1] = b
			end
		end

		return self:GetClosestBoneInList(pos, bonelist)
	end

	function entMeta:GetClosestBoneInList(pos, list)
		if not list then return self:GetClosestBone(pos) end
		local biggestDist = math.huge
		local b = parentBone

		for _, boneName in ipairs(list) do
			local bone = isnumber(boneName) and boneName or self:LookupBone(boneName)

			if bone then
				local p = self:GetBoneCenter(bone)
				local d = pos:Distance(p)

				if d < biggestDist then
					biggestDist = d
					b = bone
				end
			end
		end

		if not b then return self:GetClosestBone(pos) end

		return b
	end

	function entMeta:GetBoneCenter(bone)
		self:SetupBones()
		local rootpos, rootang = self:GetBonePosition(bone)
		local t = self:GetChildBones(bone)

		if #t == 1 then
			local p = self:GetBonePosition(t[1])
			if self:BoneHasFlag(t[1], BONE_USED_BY_VERTEX_MASK) then return (p + rootpos) / 2 end
		else
			local par = self:GetBoneParent(bone)

			if par and par ~= -1 then
				local parpos = self:GetBonePosition(par)

				return rootpos + self:BoneLength(bone) * (rootpos - parpos):GetNormalized() / 2
			end
		end

		return rootpos + self:BoneLength(bone) * rootang:Forward() / 2
	end

	function entMeta:GetChildBonesRecursive(bone)
		local mdl = self:GetModel()

		if not modelBoneCache[mdl] then
			modelBoneCache[mdl] = {}
		end

		local mdlT = modelBoneCache[mdl]

		if mdlT[bone] then
			return mdlT[bone]
		else
			if isstring(bone) then
				bone = self:LookupBone(bone)

				if not bone then
					mdlT[bone] = {}

					return mdlT[bone]
				end
			end

			self:SetupBones()
			local t = {}
			t[#t + 1] = bone
			local childBones = self:GetChildBones(bone)

			for _, childBone in ipairs(childBones) do
				local tAppend = self:GetChildBonesRecursive(childBone)

				for _, b in ipairs(tAppend) do
					t[#t + 1] = b
				end
			end

			mdlT[bone] = t

			return t
		end
	end
end