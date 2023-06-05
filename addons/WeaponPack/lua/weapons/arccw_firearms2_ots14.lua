include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 3

SWEP.ItemData = {
    width = 2,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 1 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.45, 271.8, 0),
        fov = 4.5
    }
}


SWEP.PrintName = "OTs-14"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Kalashnikov Concern"
SWEP.Trivia_Calibre = "9x39mm"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "1974"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/ots14.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/ots14.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 37
SWEP.DamageMin = 18 -- damage done at maximum range
SWEP.Range = 500 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 880 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.

SWEP.Recoil = 1.7
SWEP.RecoilSide = 0.12

SWEP.RecoilRise = 0.05
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.11 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 400 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "9x39mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_OTS14"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/ak74.ogg"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.SelectUBGLSound =  ""
SWEP.ExitUBGLSound = ""

SWEP.MuzzleEffect = "muzzleflash_3"

SWEP.ShellModel = "models/shells/9x39mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.21, -4, -0.23),
    Ang = Angle(0.85, -0.02, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 70 -- The mean number of shots between malfunctions, will be autocalculated if nil
-- SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
-- SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.4

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 0.8)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-3.8, -3, 0)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -4, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(3.532, -3, 0)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 25

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "lead_gun",
        Offset = {
            vpos = Vector(-0.033, -2.3, 0.05),
            vang = Angle(270, 0, 270),
            wpos = Vector(3, 0.8, -4.75),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)  
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "9x39MM",
        Slot = {"fas2_ammo_9x39mmap", "fas2_ammo_9x39mmsp"},
    },
    {
        PrintName = "Grenade Launcher",
        Slot = "fas2_ots14_ubgl",
        Installed = "fas2_misc_ots14_gl",
        Integral = true,
    },
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 22/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 22/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 12/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_iron",
        Time = 12/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.OTs14_MagOut", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.27},
		{s = "Firearms2.OTs14_MagIn", t = 1.6},
		{s = "Firearms2.Cloth_Movement", t = 1.6}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 133/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.OTs14_MagOut", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.27},
        {s = "Firearms2.OTs14_MagIn", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		{s = "Firearms2.OTs14_BoltBack", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9},
        {s = "Firearms2.OTs14_BoltRelease", t = 3.26},
		{s = "Firearms2.Cloth_Movement", t = 3.26}
		},
    },
    ["enter_ubgl"] = {
        Source = "enter_ubg",
        Time = 70/30,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.MP5_SelectorSwitch", t = 0.55},
            {s = "Firearms2.Cloth_Movement", t = 0.55},
            {s = "Firearms2.OTs14_FireSelect", t = 1.23},
            {s = "Firearms2.Cloth_Movement", t = 1.23}
            },
    },
    ["exit_ubgl"] = {
        Source = "exit_ubg",
        Time = 70/30,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.OTs14_FireSelect", t = 1},
            {s = "Firearms2.Cloth_Movement", t = 1},
            {s = "Firearms2.MP5_SelectorSwitch", t = 1.7},
            {s = "Firearms2.Cloth_Movement", t = 1.7}
            },
    },
    ["draw_ubgl"] = {
        Source = "draw_ubg",
        Time = 22/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster_ubgl"] = {
        Source = "holster_ubg",
        Time = 22/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["fire_ubgl"] = {
        Source = "fire_ubg",
        Time = 12/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["reload_ubgl"] = {
        Source = "reload_ubg",
        Time = 63/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.6},
		{s = "Firearms2.OTs14_InsertGrenade", t = 1},
		{s = "Firearms2.Cloth_Movement", t = 1},
		{s = "Firearms2.OTs14_InsertGrenadeClick", t = 1.3}
		},
    },
}

function SWEP:SelectUBGL()
    if !self:GetBuff_Override("UBGL") then return end
    if self:GetReloading() then return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    self:SetInUBGL(true)

    if !IsFirstTimePredicted() then return end

    self:MyEmitSound(self.SelectUBGLSound)
    self:SetFireMode(1)

    if CLIENT then
        if !ArcCW:ShouldDrawHUDElement("CHudAmmo") then
            self:GetOwner():ChatPrint("Selected " .. self:GetBuff_Override("UBGL_PrintName") or "UBGL")
        end
        if !self:GetLHIKAnim() then
            self:DoLHIKAnimation("enter")
        end
    end

    if self:GetBuff_Override("UBGL_BaseAnims") and self.Animations.enter_ubgl_empty and self:Clip2() == 0 then
        self:PlayAnimation("enter_ubgl_empty", 1, false, 0, true)
        self:SetNextSecondaryFire(CurTime() + self:GetAnimKeyTime("enter_ubgl_empty"))
    elseif self:GetBuff_Override("UBGL_BaseAnims") and self.Animations.enter_ubgl then
        self:PlayAnimation("enter_ubgl", 1, false, 0, true)
        self:SetNextSecondaryFire(CurTime() + self:GetAnimKeyTime("enter_ubgl"))
    end

    self:GetBuff_Hook("Hook_OnSelectUBGL")
end

function SWEP:DeselectUBGL()
    if !self:GetInUBGL() then return end
    if self:GetReloading() then return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    self:SetInUBGL(false)

    if !IsFirstTimePredicted() then return end

    self:MyEmitSound(self.ExitUBGLSound)

    if CLIENT then
        if !ArcCW:ShouldDrawHUDElement("CHudAmmo") then
            self:GetOwner():ChatPrint("Deselected " .. self:GetBuff_Override("UBGL_PrintName") or "UBGL")
        end
        if !self:GetLHIKAnim() then
            self:DoLHIKAnimation("exit")
        end
    end

    if self:GetBuff_Override("UBGL_BaseAnims") and self.Animations.exit_ubgl_empty and self:Clip2() == 0 then
        self:PlayAnimation("exit_ubgl_empty", 1, false, 0, true)
        self:SetNextPrimaryFire(CurTime() + self:GetAnimKeyTime("exit_ubgl_empty"))
    elseif self:GetBuff_Override("UBGL_BaseAnims") and self.Animations.exit_ubgl then
        self:PlayAnimation("exit_ubgl", 1, false, 0, true)
        self:SetNextPrimaryFire(CurTime() + self:GetAnimKeyTime("exit_ubgl"))
    end

    self:GetBuff_Hook("Hook_OnDeselectUBGL")
end

function SWEP:FireRocket(ent, vel, ang)
    if CLIENT then return end

    local rocket = ents.Create(ent)

    ang = ang or self:GetOwner():EyeAngles()

    local src = self:GetShootSrc()

    if !rocket:IsValid() then print("!!! INVALID ROUND " .. ent) return end

    local EA =  self.Owner:EyeAngles()
    src = src + EA:Right() * 3 - EA:Up() * 7 + EA:Forward() * 8

    rocket:SetAngles(ang)
    rocket:SetPos(src)

    rocket:SetOwner(self:GetOwner())
    rocket.Inflictor = self

    rocket:Spawn()
    rocket:Activate()
    rocket:GetPhysicsObject():SetVelocity(self:GetOwner():GetAbsVelocity())
    rocket:GetPhysicsObject():SetVelocityInstantaneous(ang:Forward() * vel)
    rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)

    if rocket.ArcCW_Killable == nil then
        rocket.ArcCW_Killable = true
    end

    rocket.ArcCWProjectile = true

    return rocket
end