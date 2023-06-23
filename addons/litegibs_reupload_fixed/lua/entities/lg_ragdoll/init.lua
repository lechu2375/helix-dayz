AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:NextThink(CurTime())
end

function ENT:Think()
	local rag = self:GetNW2Entity("ragdoll")

	if IsValid(rag) and not self.hasinit then
		self:SetParent(rag)
		--self:AddEffects(EF_BONEMERGE)
		self:SetLocalPos(vector_origin)
		self:SetLocalAngles(angle_zero)
		self.hasinit = true
	end

	if self.hasinit and not IsValid(rag) then
		self:Remove()
	end
	self:NextThink(CurTime())
end