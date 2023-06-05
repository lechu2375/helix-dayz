include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 1

SWEP.ItemData = {
    width = 1,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 1 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.4, 271.9, 0),
        fov = 3.5
    }
}

SWEP.PrintName = "GSH-18"
SWEP.Trivia_Class = "Semi-automatic pistol"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "KBP Instrument Design Bureau"
SWEP.Trivia_Calibre = "9x19"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "2001"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/pistols/gsh18.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/pistols/gsh18.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 15
SWEP.DamageMin = 7 -- damage done at maximum range
SWEP.Range = 50 -- in METRES
SWEP.Penetration = 2
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 535 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 18 -- DefaultClip is automatically set.

SWEP.Recoil = 0.75
SWEP.RecoilSide = 0.09

SWEP.RecoilRise = 0.04
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.1765 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0,
    },
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 310 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "9x19mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_GSH18"
SWEP.ShootDrySound = "fas2/empty_pistol.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/gsh18.ogg"
SWEP.ShootSoundSilenced = "Firearms2_P226_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_pistol"

SWEP.ShellModel = "models/shells/9x19mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Pistol
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.75

SWEP.BulletBones = {
    [0] = "Bullet18",
    [1] = "Bullet17",
    [2] = "Bullet16",
    [3] = "Bullet15",
    [4] = "Bullet14",
    [5] = "Bullet13",
    [6] = "Bullet12",
    [7] = "Bullet11",
    [8] = "Bullet10",
    [9] = "Bullet9",
    [10] = "Bullet8",
    [11] = "Bullet7",
    [12] = "Bullet6",
    [13] = "Bullet5",
    [14] = "Bullet4",
    [15] = "Bullet3",
    [16] = "Bullet2",
    [17] = "Bullet1"
}

SWEP.IronSightStruct = {
    Pos = Vector(-1.9, 0, 0.86),
    Ang = Angle(0.25, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 38 -- The mean number of shots between malfunctions, will be autocalculated if nil
-- SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
-- SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.3

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -3, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(0.4, -5, -2.69)
SWEP.HolsterAng = Angle(38.433, 0, 0)

SWEP.SprintPos = Vector(0.4, -5, -2.69)
SWEP.SprintAng = Angle(38.433, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 10, -3)

SWEP.CustomizePos = Vector(1.824, -4, -1)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 17

SWEP.AttachmentElements = {
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["muzzlebrake"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
    ["flashhider"] = {
        VMBodygroups = {{ind = 2, bg = 3}},
        WMBodygroups = {{ind = 1, bg = 3}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "9x19MM",
        Slot = "fas2_ammo_9x19mmap",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 15/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 15/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["holster"] = {
        Source = "holster",
        Time = 15/45,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 15/45,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"fire1", "fire2"},
        Time = 22/33.5,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 22/33.5,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_scoped2",
        Time = 15/40,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "fire_last_iron",
        Time = 15/40,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 50/37,
        ShellEjectAt = 0.6,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Cloth_Movement", t = 0.5},
        {s = "Firearms2.P226_SlideBack", t = 0.55},
        {s = "Firearms2.P226_SlideForward", t = 0.73}
		},
    },
    ["reload"] = {
        Source = "reload",
        Time = 70/30,
        LastClip1OutTime = 1.6,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.P226_MagOut", t = 0.5},
		{s = "Firearms2.Magpouch_Pistol", t = 0.9},
		{s = "Firearms2.Cloth_Movement", t = 1.3},
		{s = "Firearms2.P226_MagInPartial", t = 1.45},
		{s = "Firearms2.P226_MagIn", t = 1.65},
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 95/37,
        LastClip1OutTime = 0.54,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.P226_MagOutEmpty", t = 0.3},
        {s = "Firearms2.Magpouch_Pistol", t = 0.5},
        {s = "Firearms2.Cloth_Movement", t = 0.86},
        {s = "Firearms2.P226_MagInPartial", t = 0.9},
		{s = "Firearms2.P226_MagIn", t = 1},
        {s = "Firearms2.Cloth_Movement", t = 1.76},
        {s = "Firearms2.P226_SlideBack", t = 1.8},
        {s = "Firearms2.P226_SlideForward", t = 1.95},
		{s = "Firearms2.P226_SlideStop", t = 2},
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 59/30,
        LastClip1OutTime = 0.73,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.P226_MagOut", t = 0.5},
		{s = "Firearms2.Magpouch_Pistol", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 1.1},
		{s = "Firearms2.P226_MagInPartial", t = 1.15},
		{s = "Firearms2.P226_MagIn", t = 1.35},
		},
    },
    ["reload_nomen_empty"] = {
        Source = "reload_empty_nomen",
        Time = 62/30,
        LastClip1OutTime = 0.76,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.P226_MagOutEmpty", t = 0.5},
		{s = "Firearms2.Magpouch_Pistol", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 1.1},
		{s = "Firearms2.P226_MagInPartial", t = 1.15},
		{s = "Firearms2.P226_MagIn", t = 1.35},
		{s = "Firearms2.P226_SlideForward", t = 1.6},
		{s = "Firearms2.P226_SlideStop", t = 1.65},
		},
    },
}