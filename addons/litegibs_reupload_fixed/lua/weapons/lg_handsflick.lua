SWEP.PrintName = "Litegibs Clean Hands"
SWEP.Category = "Other"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_lg_handsflick.mdl"
SWEP.UseHands = true
SWEP.ViewModelFOV=56

SWEP.WorldModel = "models/weapons/c_lg_handsflick.mdl"

SWEP.CleanFrame = 71
SWEP.CleanFrame2 = 88
SWEP.EndFrame = 145
SWEP.FPS = 60

SWEP.Primary = {
    Ammo        = "none",
    Automatic   = false,
    ClipSize    = -1,
    DefaultClip = -1
}

SWEP.Secondary = {
    Ammo        = "none",
    Automatic   = false,
    ClipSize    = -1,
    DefaultClip = -1
}

function SWEP:VMIV()
    return IsValid(self:GetOwner()) and IsValid(self:GetOwner():GetViewModel())
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_IDLE)
    self:SetCleanEnd(-1)
    self:SetCleaned1(true)
    self:SetCleaned2(true)
    return true
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"CleanEnd")
    self:NetworkVar("Bool",0,"Cleaned1")
    self:NetworkVar("Bool",0,"Cleaned2")
end

function SWEP:Think()
    if CurTime() > self:GetCleanEnd() then
        self:SendWeaponAnim(ACT_VM_IDLE)
    end
    if (not self:GetCleaned1()) and CurTime() > self:GetCleanEnd() - (self.EndFrame - self.CleanFrame)/self.FPS then
        self:SetCleaned1(true)
        self:Clean()
        if game.SinglePlayer() then
            self:CallOnClient("Clean")
        end
    end
    if (not self:GetCleaned2()) and CurTime() > self:GetCleanEnd() - (self.EndFrame - self.CleanFrame2)/self.FPS then
        self:SetCleaned2(true)
        self:Clean()
        if game.SinglePlayer() then
            self:CallOnClient("Clean")
        end
    end
end

function SWEP:Clean()
    if LiteGibs and LiteGibs.WeaponBlood and LiteGibs.WeaponBlood.Clean then
        LiteGibs.WeaponBlood.Clean(1,2)
    end
end

function SWEP:PrimaryAttack()
    if CurTime() > self:GetCleanEnd() then
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        if self:VMIV() then
            self:SetCleanEnd(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
            self:SetCleaned1(false)
            self:SetCleaned2(false)
        end
    end
end

function SWEP:SecondaryAttack()
    -- empty override
end

function SWEP:Holster()
    return true
end