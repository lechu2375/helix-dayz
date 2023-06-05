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
        ang = Angle(-1.45, 271.8, 0),
        fov = 4.5
    }
}

SWEP.PrintName = "Desert Eagle .357"
SWEP.Trivia_Class = "Semi-automatic pistol"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Israel Military Industries"
SWEP.Trivia_Calibre = ".357 Magnum"
SWEP.Trivia_Country = "Israel"
SWEP.Trivia_Year = "1983"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/pistols/deagle357.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/pistols/deagle357.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 38
SWEP.DamageMin = 19 -- damage done at maximum range
SWEP.Range = 70 -- in METRES
SWEP.Penetration = 5
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 470 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 7 -- DefaultClip is automatically set.

SWEP.Recoil = 4
SWEP.RecoilSide = 0.3

SWEP.RecoilRise = 0.07
SWEP.RecoilPunch = 0.8
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.2245 -- 60 / RPM.
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
SWEP.HipDispersion = 480 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = ".357magnum" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_DEAGLE357"
SWEP.ShootDrySound = "fas2/empty_pistol.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/deagle357.ogg"
SWEP.ShootSoundSilenced = "Firearms2_DEAGLE357_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_pistol_deagle"

SWEP.ShellModel = "models/shells/357mag.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Pistol
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.418, 0, 0.81),
    Ang = Angle(0.1, 0.04, 0),
    Magnification = 1.2,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 27 -- The mean number of shots between malfunctions, will be autocalculated if nil
-- SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
-- SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.35

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

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

SWEP.CustomizePos = Vector(2.824, -4, -1.297)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 19

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
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
    ["tritium"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Ironsight",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_tritium", "fas2_pistol_sight"},
        Bone = "frame",
        Offset = {
            vpos = Vector(-0.1, -0.2, 1.31),
            vang = Angle(0, 0, 270),
            wpos = Vector(6.9, 0.8, -4.22),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_pistol_tactical",
        Bone = "frame",
        Offset = {
            vpos = Vector(1.3, 1.5, 1.31),
            vang = Angle(0, 0, 270),
            wpos = Vector(9.3, 0.8, -1.55),
            wang = Angle(-10.393, 0, 180),
        },
        WMScale = Vector(1.6, 1.6, 1.6),
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = ".357 Magnum",
        Slot = "fas2_ammo_357magnumap",
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
        Source = "deploy",
        Time = 30/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["draw_empty"] = {
        Source = "deploy_empty",
        Time = 30/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["ready"] = {
        Source = "deploy",
        Time = 30/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3", "fire4"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_iron",
        Time = 15/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "fire_iron_last",
        Time = 15/30,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 35/30,
        ShellEjectAt = 0.55,
		SoundTable = {
        {s = "Firearms2.Deagle_MagOutEmpty", t = 0.5},
		{s = "Firearms2.Deagle_SlideStop", t = 0.57},
		{s = "Firearms2.Cloth_Movement", t = 0.57},
		},
    },
    ["reload"] = {
        Source = "reload",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Deagle_MagOut", t = 0.5},
		{s = "Firearms2.Cloth_Movement", t = 0.5},
		{s = "Firearms2.Magpouch_Pistol", t = 0.9},
		{s = "Firearms2.Deagle_MagIn", t = 1.55},
		{s = "Firearms2.Cloth_Movement", t = 1.55},
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 94/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Deagle_MagOutEmpty", t = 0.6},
        {s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch_Pistol", t = 0.9},
        {s = "Firearms2.Deagle_MagIn", t = 1.55},
        {s = "Firearms2.Cloth_Movement", t = 1.55},
		{s = "Firearms2.Deagle_SlideStop", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3},
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 54/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Deagle_MagOut", t = 0.3},
		{s = "Firearms2.Cloth_Movement", t = 0.3},
		{s = "Firearms2.Magpouch_Pistol", t = 0.5},
		{s = "Firearms2.Deagle_MagInPartial", t = 0.95},
		{s = "Firearms2.Cloth_Movement", t = 0.95},
		{s = "Firearms2.Deagle_MagInNomen", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1},
		},
    },
    ["reload_nomen_empty"] = {
        Source = "reload_nomen_empty",
        Time = 69/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Deagle_MagOutEmpty", t = 0.3},
		{s = "Firearms2.Cloth_Movement", t = 0.3},
		{s = "Firearms2.Magpouch_Pistol", t = 0.5},
		{s = "Firearms2.Deagle_MagInPartial", t = 0.95},
		{s = "Firearms2.Cloth_Movement", t = 0.95},
		{s = "Firearms2.Deagle_MagInNomen", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1},
		{s = "Firearms2.Deagle_SlideStop", t = 1.6},
		{s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
}