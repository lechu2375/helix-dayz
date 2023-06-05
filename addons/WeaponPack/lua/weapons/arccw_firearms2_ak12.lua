include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Firearms: Source 2"
SWEP.AdminOnly = false
SWEP.Slot = 3

SWEP.ItemData = {
    width = 2,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 28 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.33, 270.01, 0),
        fov = 13
    }
}

SWEP.PrintName = "AK-12"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Izhmash"
SWEP.Trivia_Calibre = "5.45x39mm"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "2012"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/ak12.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/ak12.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"

SWEP.Damage = 32
SWEP.DamageMin = 16
SWEP.Range = 800
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 900

SWEP.TracerNum = 0

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 30

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.25

SWEP.RecoilRise = 0.5
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.1
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0
SWEP.HipDispersion = 410
SWEP.MoveDispersion = 150
SWEP.SightsDispersion = 0
SWEP.JumpDispersion = 300

SWEP.Primary.Ammo = "5.45x39mm"
SWEP.MagID = ""

SWEP.ShootVol = 110
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_AK12"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav"
SWEP.DistantShootSound = "fas2/distant/ak12.ogg"
SWEP.ShootSoundSilenced = "Firearms2_AK74_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_1bb"

SWEP.ShellModel = "models/shells/5_45x39mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.208, -3.875, 0.59),
    Ang = Angle(0.2, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 80 -- The mean number of shots between malfunctions, will be autocalculated if nil
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

SWEP.CrouchPos = Vector(-3.8, -3, 0)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -4, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.532, -4, 0)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 28

SWEP.RejectAttachments = {
    ["fas2_extra_anpeq2"] = true,
}

SWEP.AttachmentElements = {
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["45rnd"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["60rnd"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 2, bg = 2}},
    },
    ["grip"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
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
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "ak_frame",
        Offset = {
            vpos = Vector(0, 2.95, 1.92),
            vang = Angle(0, 270, 0),
            wpos = Vector(7.72, 0.79, -5.35),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Canted Sight",
        Slot = "fas2_cantedsight",
        Bone = "ak_frame",
        Offset = {
            vpos = Vector(0, 5.9, 1.92),
            vang = Angle(0, 270, 0),
            wpos = Vector(13, 0.79, -6.25),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0)
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "ak_frame",
        Offset = {
            vpos = Vector(0, 8.6, 2),
            vang = Angle(0, 270, 0),
            wpos = Vector(17.3, 0.68, -7),
            wang = Angle(-10.393, 0, 180),
        },
        WMScale = Vector(1.6, 1.6, 1.6),
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "5.45 30rnd Mag",
        Slot = {"fas2_545_45rnd", "fas2_545_60rnd"}
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "5.45x39MM",
        Slot = "fas2_ammo_545x39mmap",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local nomen = wep.Attachments[8].Installed and "_nomen" or ""
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[5].Installed and "_grip" or ""

	return "reload" .. nomen .. empty .. grip
end

SWEP.Animations = {
    -- ["idle"] = false,
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
        Time = 49/70,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 49/70,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 36/90,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 36/90,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 60/40,
        ShellEjectAt = 0,
    },
    ["fire_grip"] = {
        Source = "fire_grip",
        Time = 60/40,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_scoped",
        Time = 10/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "fire_scoped_grip",
        Time = 10/30,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 48/36,
        ShellEjectAt = 0.75,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},    
		{s = "Firearms2.AK74_BoltPull", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6}
		},
    },
    ["fix_grip"] = {
        Source = "fix_grip",
        Time = 48/36,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        ShellEjectAt = 0.75,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},    
		{s = "Firearms2.AK74_BoltPull", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6}
		},
    },
    ["reload"] = {
        Source = "reload",
        Time = 112/36,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK74_MagOut", t = 1},
		{s = "Firearms2.Cloth_Movement", t = 1},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.AK74_MagIn", t = 2},
		{s = "Firearms2.Cloth_Movement", t = 2}
		},
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 112/36,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK74_MagOut", t = 1},
		{s = "Firearms2.Cloth_Movement", t = 1},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.AK74_MagIn", t = 2},
		{s = "Firearms2.Cloth_Movement", t = 2}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 130/36,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK74_MagOutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.AK74_MagIn", t = 1.85},
		{s = "Firearms2.Cloth_Movement", t = 1.85},
		{s = "Firearms2.AK74_BoltPull", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9}
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 130/36,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK74_MagOutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.AK74_MagIn", t = 1.85},
		{s = "Firearms2.Cloth_Movement", t = 1.85},
		{s = "Firearms2.AK74_BoltPull", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9}
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 100/34,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK74_MagOut", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.2},
		{s = "Firearms2.AK74_MagIn", t = 1.8},
		{s = "Firearms2.Cloth_Movement", t = 1.8}
		},
    },
    ["reload_nomen_grip"] = {
        Source = "reload_grip_nomen",
        Time = 100/34,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK74_MagOut", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.2},
		{s = "Firearms2.AK74_MagIn", t = 1.8},
		{s = "Firearms2.Cloth_Movement", t = 1.8}
		},
    },
    ["reload_nomen_empty"] = {
        Source = "reload_empty_nomen",
        Time = 134/34,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.8},
		{s = "Firearms2.AK74_MagOutEmptyNomen", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.5},
		{s = "Firearms2.AK74_MagIn", t = 1.8},
		{s = "Firearms2.Cloth_Movement", t = 1.8},
		{s = "Firearms2.AK74_BoltPull", t = 2.5},
		{s = "Firearms2.Cloth_Movement", t = 2.5}
		},
    },
    ["reload_nomen_empty_grip"] = {
        Source = "reload_empty_grip_nomen",
        Time = 134/34,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.8},
		{s = "Firearms2.AK74_MagOutEmptyNomen", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.5},
		{s = "Firearms2.AK74_MagIn", t = 1.8},
		{s = "Firearms2.Cloth_Movement", t = 1.8},
		{s = "Firearms2.AK74_BoltPull", t = 2.5},
		{s = "Firearms2.Cloth_Movement", t = 2.5}
		},
    },
}