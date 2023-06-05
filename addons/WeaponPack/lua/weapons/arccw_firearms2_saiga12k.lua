include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 4

SWEP.ItemData = {
    width = 2,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 39 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.33, 270.01, 0),
        fov = 13
    }
}

SWEP.PrintName = "Saiga-12K"
SWEP.Trivia_Class = "Shotgun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Kalashnikov Concern"
SWEP.Trivia_Calibre = "12-Gauge"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "1997"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/shotguns/saiga12k.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/shotguns/saiga12k.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 11
SWEP.DamageMin = 8 -- damage done at maximum range
SWEP.Range = 200 -- in METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 800 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 5 -- DefaultClip is automatically set.

SWEP.Recoil = 6
SWEP.RecoilSide = 0.24

SWEP.RecoilRise = 0.02
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.2 -- 60 / RPM.
SWEP.Num = 12 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 55 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 270 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "12gauge" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_SAIGA12K"
SWEP.ShootDrySound = "fas2/empty_shotguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/saiga12k.ogg"
SWEP.ShootSoundSilenced = "Firearms2_SAIGA12K_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_shotgun"

SWEP.ShellModel = "models/shells/12g_buck.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-1.81, -4, 0.6),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.SightTime = 0.4

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-3.8, -3, 0)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -3, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.532, -3, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 25

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["choke"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
    ["incendiary"] = {
        VMBodygroups = {{ind = 4, bg = 2}},
    },
    ["slug"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = "fas2_sight",
        Bone = "Object01", 
        Offset = {
            vpos = Vector(-3.2, -2, 0.5),
            vang = Angle(0, 0, -78.2),
            wpos = Vector(6.25, 0.7, -5.75),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_choke"},
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "12 Gauge",
        Slot = "fas2_ammo_shotgun",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 0/1,
    },
    ["draw"] = {
        Source = "deploy",
        Time = 31/60,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 40/120,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"fire", "fire2", "fire3"},
        Time = 21/60,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_scoped",
        Time = 21/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 88/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.SAIGA12K_MagOut", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.4},
		{s = "Firearms2.SAIGA12K_MagIn", t = 1.73},
		{s = "Firearms2.Cloth_Movement", t = 1.73}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 125/30   ,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SAIGA12K_MagOut", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.4},
        {s = "Firearms2.SAIGA12K_MagIn", t = 1.73},
        {s = "Firearms2.Cloth_Movement", t = 1.73},
		{s = "Firearms2.SAIGA12K_BoltPull", t = 2.8},
		{s = "Firearms2.Cloth_Movement", t = 2.8}
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 88/37.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.SAIGA12K_MagOut", t = 0.56},
		{s = "Firearms2.Cloth_Movement", t = 0.56},
		{s = "Firearms2.Magpouch", t = 1.12},
		{s = "Firearms2.SAIGA12K_MagIn", t = 1.38},
		{s = "Firearms2.Cloth_Movement", t = 1.38}
		},
    },
    ["reload_nomen_empty"] = {
        Source = "reload_empty_nomen",
        Time = 115/37.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SAIGA12K_MagOut", t = 0.66},
        {s = "Firearms2.Cloth_Movement", t = 0.66},
        {s = "Firearms2.Magpouch", t = 1.25},
        {s = "Firearms2.SAIGA12K_MagIn", t = 1.46},
        {s = "Firearms2.Cloth_Movement", t = 1.46},
		{s = "Firearms2.SAIGA12K_BoltPull", t = 2.08},
		{s = "Firearms2.Cloth_Movement", t = 2.08}
		},
    },
}