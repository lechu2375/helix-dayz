include("shared.lua")

local function nulFunc()
end

local function secondLayer(fn, ...)
	fn(...)
end

local bigvec = Vector(32,32,32)
local upvec = Vector(0,0,32)

function ENT:Initialize()
	self.GetNW2Entity = self.GetNW2Entity or self.GetNWEntity
	self.gibbedBones = self.gibbedBones or {}
end

function ENT:InitializeCMod()
	self.cmod = ClientsideModel(self:GetModel())
	self.cmod.rag = self:GetNW2Entity("ragdoll")
	self.cmod:SetNoDraw(true)
	self.cmod:DrawShadow(true)
	self:DrawShadow(true)
	self.cmod:SetCollisionBounds(-bigvec,bigvec)
	self.cmod:SetRenderBounds(-bigvec,bigvec)
	
	self.cmod:SetSkin(self.cmod.rag:GetSkin())

	for i = 1, #self.cmod.rag:GetBodyGroups() do
		self.cmod:SetBodygroup(i, self.cmod.rag:GetBodygroup(i))
	end

	self.cmod:AddCallback("BuildBonePositions", function(myself, boneCount)
		if not IsValid(myself.rag) then return end
		local rag = myself.rag
		if IsValid(rag) then
			rag:SetupBones()
			for i=0, boneCount do
				local m = rag:GetBoneMatrix(i)

				if m then
					xpcall(secondLayer, nulFunc, myself.SetBoneMatrix, myself, i, m)
				end
			end

			if rag.gibbedBones then
				for k, v in pairs(rag.gibbedBones) do
					if k > boneCount or v > boneCount then return end

					if rag:GetBoneName(k) ~= "__INVALIDBONE__" then
						local mat = rag:GetBoneMatrix(v)
						if not mat then return end
						mat:Scale(vector_origin)
						xpcall(secondLayer, nulFunc, myself.SetBoneMatrix, myself, k, mat)
					end
				end
			end
		end
	end)
end

function ENT:Think()
end

function ENT:Draw()
	local rag = self:GetNW2Entity("ragdoll")

	if IsValid(rag) then
		if not self.hasinit then
			self:SetParent(rag)
			--self.cmod:AddEffects(EF_BONEMERGE)
			self:SetLocalPos(vector_origin)
			self:SetLocalAngles(angle_zero)

			self:InitializeCMod()
			rag:SetNoDraw(true)
			rag:DrawShadow(false)
			
			rag.lgdummy=self
			self.hasinit = true
			--print("rag:")
			--print(rag)
			rag.RenderOverride = nulFunc
			rag.WoundProxy = self.cmod
			self.WoundProxy = self.cmod
		end
	else
		return
	end
	
	if IsValid(self.cmod) then
		self.cmod:SetupBones()
		self.cmod:DrawModel()
		self.cmod:SetPos(self:GetPos())
		self.cmod:SetAngles(self:GetAngles())
	end

	--self:SetupBones()
	--self:DrawModel()
end

function ENT:OnRemove()
	if IsValid(self.cmod) then
		self.cmod:Remove()
		self.cmod=nil
	end
end