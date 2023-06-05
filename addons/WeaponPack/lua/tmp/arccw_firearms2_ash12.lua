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
        ang = Angle(-1.6, 272.6, 0),
        fov = 12
    }
}

SWEP.PrintName = "ASH-12"
SWEP.Trivia_Class = "Bullpup Battle Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Izhmash"
SWEP.Trivia_Calibre = "12.7x55MM"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "2010"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/ash12.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/ash12.mdl"
SWEP.ViewModelFOV = 70

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 58
SWEP.DamageMin = 29 -- damage done at maximum range
SWEP.Range = 300 -- in METRES
SWEP.Penetration = 30
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 315 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.

SWEP.Recoil = 3.4
SWEP.RecoilSide = 1

SWEP.RecoilRise = 0.9
SWEP.RecoilPunch = 0.4
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.0923 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 410 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "12.7x55mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_ASH12"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/ash12.ogg"
SWEP.ShootSoundSilenced = "Firearms2_ASH12_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_slug"

SWEP.ShellModel = "models/shells/12_7x55mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Heavy
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.6
SWEP.SightedSpeedMult = 0.55

SWEP.IronSightStruct = {
    Pos = Vector(-1.64, -2, 0.01),
    Ang = Angle(1, 0.02, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 30 -- The mean number of shots between malfunctions, will be autocalculated if nil
-- SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
-- SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.4

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-0.5, -2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(2.532, -2.8, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(2.532, -2.8, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 29

SWEP.RejectAttachments = {
    ["fas2_scope_pso1"] = true
}

SWEP.AttachmentElements = {
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["grip"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["30rnd"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "weapon_main",
        Offset = {
            vpos = Vector(0.025, 2.75, 1.52),
            vang = Angle(0, 270, 0),
            wpos = Vector(4.75, 0.8, -6.68),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(0.8, 0.8, 0.8),
        WMScale = Vector(1.5, 1.5, 1.5),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = "fas2_muzzle",
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "weapon_main",
        Offset = {
            vpos = Vector(0.6, 7.1, -0.235),
            vang = Angle(0, 270, 270),
            wpos = Vector(13, 1.95, -4.73),
            wang = Angle(-10.393, 0, 90),
        },
        WMScale = Vector(1.6, 1.6, 1.6),
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "12.7 10rnd Mag",
        Slot = "fas2_127_20rnd",
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "12.7x55MM",
        Slot = "fas2_ammo_127x55mmap",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[4].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[4].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local grip = wep.Attachments[4].Installed and "_grip" or ""
    local nomen = wep.Attachments[7].Installed and "_nomen" or ""
    local mag = wep.Attachments[5].Installed and "_30rnd" or ""

	return anim .. mag .. grip .. nomen
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 0/1,
    },
    ["idle_grip"] = {
        Source = "idle_grip",
        Time = 0/1,
    },
    ["draw"] = {
        Source = "deploy",
        Time = 26/34,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 26/34,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 18/34,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 18/34,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 18/36,
        ShellEjectAt = 0,
    },
    ["fire_grip"] = {
        Source = "fire_grip",
        Time = 18/36,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_iron",
        Time = 10/36,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "fire_iron_grip",
        Time = 10/36,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 54/30,
        ShellEjectAt = 0.96,
		SoundTable = {
        {s = "Firearms2.ASH12_BoltBack", t = 0.86},
        {s = "Firearms2.ASH12_BoltForward", t = 1.06},
        {s = "Firearms2.ASH12_Cloth", t = 1.06}
		},
    },
    ["fix_grip"] = {
        Source = "fix_grip",
        Time = 54/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        ShellEjectAt = 0.96,
		SoundTable = {
        {s = "Firearms2.ASH12_BoltBack", t = 0.86},
        {s = "Firearms2.ASH12_BoltForward", t = 1.06},
        {s = "Firearms2.ASH12_Cloth", t = 1.06}
		},
    },
    ["reload"] = {
        Source = "reload",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2}
		},
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2},
		{s = "Firearms2.ASH12_BoltBack", t = 3.1},
		{s = "Firearms2.ASH12_BoltForward", t = 3.3},
		{s = "Firearms2.ASH12_Cloth", t = 3.6}
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2},
		{s = "Firearms2.ASH12_BoltBack", t = 3.1},
		{s = "Firearms2.ASH12_BoltForward", t = 3.3},
		{s = "Firearms2.ASH12_Cloth", t = 3.6}
		},
    },
    ["reload_nomen"] = {
        Source = "reload",
        Time = 80/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
        {s = "Firearms2.ASH12_MagOut", t = 0.34},
        {s = "Firearms2.ASH12_Cloth", t = 0.9},
        {s = "Firearms2.ASH12_MagIn", t = 1.28},
        {s = "Firearms2.ASH12_Cloth2", t = 1.71}
		},
    },
    ["reload_grip_nomen"] = {
        Source = "reload_grip",
        Time = 80/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.34},
		{s = "Firearms2.ASH12_Cloth", t = 0.9},
		{s = "Firearms2.ASH12_MagIn", t = 1.28},
		{s = "Firearms2.ASH12_Cloth2", t = 1.71}
		},
    },
    ["reload_empty_nomen"] = {
        Source = "reload_empty",
        Time = 120/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
        {s = "Firearms2.ASH12_MagOut", t = 0.34},
        {s = "Firearms2.ASH12_Cloth", t = 0.9},
        {s = "Firearms2.ASH12_MagIn", t = 1.28},
        {s = "Firearms2.ASH12_Cloth2", t = 1.71},
		{s = "Firearms2.ASH12_BoltBack", t = 2.65},
		{s = "Firearms2.ASH12_BoltForward", t = 2.85},
		{s = "Firearms2.ASH12_Cloth", t = 3.08}
		},
    },
    ["reload_empty_grip_nomen"] = {
        Source = "reload_empty_grip",
        Time = 120/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
        {s = "Firearms2.ASH12_MagOut", t = 0.34},
        {s = "Firearms2.ASH12_Cloth", t = 0.9},
        {s = "Firearms2.ASH12_MagIn", t = 1.28},
        {s = "Firearms2.ASH12_Cloth2", t = 1.71},
		{s = "Firearms2.ASH12_BoltBack", t = 2.65},
		{s = "Firearms2.ASH12_BoltForward", t = 2.85},
		{s = "Firearms2.ASH12_Cloth", t = 3.08}
		},
    },
    ["reload_30rnd"] = {
        Source = "reload_30rnd",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2}
		},
    },
    ["reload_30rnd_grip"] = {
        Source = "reload_30rnd_grip",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2}
		},
    },
    ["reload_empty_30rnd"] = {
        Source = "reload_30rnd_empty",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2},
		{s = "Firearms2.ASH12_BoltBack", t = 3.1},
		{s = "Firearms2.ASH12_BoltForward", t = 3.3},
		{s = "Firearms2.ASH12_Cloth", t = 3.6}
		},
    },
    ["reload_empty_30rnd_grip"] = {
        Source = "reload_30rnd_empty_grip",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.4},
		{s = "Firearms2.ASH12_Cloth", t = 1.05},
		{s = "Firearms2.ASH12_MagIn", t = 1.5},
		{s = "Firearms2.ASH12_Cloth2", t = 2},
		{s = "Firearms2.ASH12_BoltBack", t = 3.1},
		{s = "Firearms2.ASH12_BoltForward", t = 3.3},
		{s = "Firearms2.ASH12_Cloth", t = 3.6}
		},
    },
    ["reload_30rnd_nomen"] = {
        Source = "reload_30rnd",
        Time = 80/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
        {s = "Firearms2.ASH12_MagOut", t = 0.34},
        {s = "Firearms2.ASH12_Cloth", t = 0.9},
        {s = "Firearms2.ASH12_MagIn", t = 1.28},
        {s = "Firearms2.ASH12_Cloth2", t = 1.71}
		},
    },
    ["reload_30rnd_grip_nomen"] = {
        Source = "reload_30rnd_grip",
        Time = 80/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
		{s = "Firearms2.ASH12_MagOut", t = 0.34},
		{s = "Firearms2.ASH12_Cloth", t = 0.9},
		{s = "Firearms2.ASH12_MagIn", t = 1.28},
		{s = "Firearms2.ASH12_Cloth2", t = 1.71}
		},
    },
    ["reload_30rnd_empty_nomen"] = {
        Source = "reload_30rnd_empty",
        Time = 120/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
        {s = "Firearms2.ASH12_MagOut", t = 0.34},
        {s = "Firearms2.ASH12_Cloth", t = 0.9},
        {s = "Firearms2.ASH12_MagIn", t = 1.28},
        {s = "Firearms2.ASH12_Cloth2", t = 1.71},
		{s = "Firearms2.ASH12_BoltBack", t = 2.65},
		{s = "Firearms2.ASH12_BoltForward", t = 2.85},
		{s = "Firearms2.ASH12_Cloth", t = 3.08}
		},
    },
    ["reload_empty_30rnd_grip_nomen"] = {
        Source = "reload_30rnd_empty_grip",
        Time = 120/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.ASH12_Cloth2", t = 0},
        {s = "Firearms2.ASH12_MagOut", t = 0.34},
        {s = "Firearms2.ASH12_Cloth", t = 0.9},
        {s = "Firearms2.ASH12_MagIn", t = 1.28},
        {s = "Firearms2.ASH12_Cloth2", t = 1.71},
		{s = "Firearms2.ASH12_BoltBack", t = 2.65},
		{s = "Firearms2.ASH12_BoltForward", t = 2.85},
		{s = "Firearms2.ASH12_Cloth", t = 3.08}
		},
    },
}