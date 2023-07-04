AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName = "Soundproxy"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Bone = ""
ENT.Sound = ""
ENT.DieTime = 0
ENT.Vol = 100

function ENT:Initialize()
    self:SetModel("models/editor/axis_helper.mdl")

    if CLIENT then return end
    if !IsValid(self:GetParent()) then self:Remove() return end

    local filter = RecipientFilter()
    filter:AddAllPlayers()

    self.DieTime = CurTime() + SoundDuration(self.Sound)
    self.PlayedSound = CreateSound(self, self.Sound, filter)
    self.PlayedSound:Play()
    self.PlayedSound:ChangeVolume(self.Vol, 0)
end

function ENT:OnRemove()
    if self.PlayedSound then
        self.PlayedSound:Stop()
    end
end

function ENT:Think()
    if CLIENT then return end
    if !IsValid(self:GetParent()) then self:Remove() return end

    local parent = self:GetParent()

    local boneid = parent:LookupBone(self.Bone)

    if !boneid then self:Remove() return end

    local pos = parent:GetBonePosition(boneid)

    self:SetPos(pos)

    if self.DieTime < CurTime() then self:Remove() return end
end

function ENT:Draw()
    return
end