include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 2

SWEP.PrintName = "Kriss Vector"
SWEP.Trivia_Class = "Submachine Gun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Kriss USA Inc."
SWEP.Trivia_Calibre = ".45 ACP"
SWEP.Trivia_Country = "	United States"
SWEP.Trivia_Year = "2009"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/smgs/vector.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/smgs/vector.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 24
SWEP.DamageMin = 12 -- damage done at maximum range
SWEP.Range = 70 -- in METRES
SWEP.Penetration = 2
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.Recoil = 1.7
SWEP.RecoilSide = 0.55

SWEP.RecoilRise = 0.72
SWEP.RecoilPunch = 0.6
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.07 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
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

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 370 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = ".45acp" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_KRISS"
SWEP.ShootDrySound = "fas2/empty_submachineguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/vector.ogg"
SWEP.ShootSoundSilenced = "Firearms2_KRISS_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_smg"

SWEP.ShellModel = "models/shells/45acp.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Pistol
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-1.87, -2, 2.02),
    Ang = Angle(0.1, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.Malfunction = true
SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
SWEP.MalfunctionMean = 80 -- The mean number of shots between malfunctions, will be autocalculated if nil
SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.35

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-3.8, -3, 0.8)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(5.532, -2, 1)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(5.532, -2, 1)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(5.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 24


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
    ["grip"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(0, -0.27, -0.115),
            vang = Angle(0, 0, -90),
            wpos = Vector(7, 0.72, -4.3),
            wang = Angle(-10.393, -2, 180)
        },
        VMScale = Vector(1.2, 1.2, 1.2),
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0.004, 0, 0.004),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Canted Sight",
        Slot = "fas2_cantedsight",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(3.5, -0.27, -0.13),
            vang = Angle(-1.5, 0, -90),
            wpos = Vector(10.8, 0.75, -4.96),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(1.2, 1.2, 1.2),
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = ".45ACP",
        Slot = "fas2_ammo_45acphs",
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
    local nomen = wep.Attachments[6].Installed and "_nomen" or ""

	return anim .. grip .. nomen
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
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "shoot",
        Time = 31/35,
        ShellEjectAt = 0,
    },
    ["fire_grip"] = {
        Source = "shoot_grip",
        Time = 31/35,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "shoot_scoped_grip",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 41/30,
        ShellEjectAt = 0.6,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.KRISS_ChargeBack", t = 0.5},
		{s = "Firearms2.Cloth_Movement", t = 0.5},
		{s = "Firearms2.KRISS_ChargeRelease", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7}
        },
    },
    ["fix_grip"] = {
        Source = "fix_grip",
        Time = 41/30,
        ShellEjectAt = 0.6,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.KRISS_ChargeBack", t = 0.5},
		{s = "Firearms2.Cloth_Movement", t = 0.5},
		{s = "Firearms2.KRISS_ChargeRelease", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7}
        },
    },
    ["reload"] = {
        Source = "reload",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.KRISS_MagOut", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch_SMG", t = 1.2},
		{s = "Firearms2.KRISS_MagFit", t = 2},
		{s = "Firearms2.KRISS_MagIn", t = 2.15},
		{s = "Firearms2.Cloth_Movement", t = 2.15},
		},
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.KRISS_MagOut", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch_SMG", t = 1.2},
		{s = "Firearms2.KRISS_MagFit", t = 2},
		{s = "Firearms2.KRISS_MagIn", t = 2.15},
		{s = "Firearms2.Cloth_Movement", t = 2.15},
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 110/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.KRISS_MagOut", t = 0.6},
        {s = "Firearms2.Cloth_Movement", t = 0.6},
        {s = "Firearms2.Magpouch_SMG", t = 1.2},
        {s = "Firearms2.KRISS_MagFit", t = 2},
        {s = "Firearms2.KRISS_MagIn", t = 2.15},
        {s = "Firearms2.Cloth_Movement", t = 2.15},
		{s = "Firearms2.KRISS_ChargeBack", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9},
		{s = "Firearms2.KRISS_ChargeRelease", t = 3.1},
		{s = "Firearms2.Cloth_Movement", t = 3.1}
        },
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 110/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.KRISS_MagOut", t = 0.6},
        {s = "Firearms2.Cloth_Movement", t = 0.6},
        {s = "Firearms2.Magpouch_SMG", t = 1.2},
        {s = "Firearms2.KRISS_MagFit", t = 2},
        {s = "Firearms2.KRISS_MagIn", t = 2.15},
        {s = "Firearms2.Cloth_Movement", t = 2.15},
		{s = "Firearms2.KRISS_ChargeBack", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9},
		{s = "Firearms2.KRISS_ChargeRelease", t = 3.1},
		{s = "Firearms2.Cloth_Movement", t = 3.1}
        },
    },
    ["reload_nomen"] = {
        Source = "reload",
        Time = 90/40,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.KRISS_MagOut", t = 0.45},
		{s = "Firearms2.Cloth_Movement", t = 0.45},
		{s = "Firearms2.Magpouch_SMG", t = 0.9},
		{s = "Firearms2.KRISS_MagFit", t = 1.5},
		{s = "Firearms2.KRISS_MagIn", t = 1.65},
		{s = "Firearms2.Cloth_Movement", t = 1.65},
		},
    },
    ["reload_grip_nomen"] = {
        Source = "reload_grip",
        Time = 90/40,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.KRISS_MagOut", t = 0.45},
        {s = "Firearms2.Cloth_Movement", t = 0.45},
		{s = "Firearms2.Magpouch_SMG", t = 0.9},
		{s = "Firearms2.KRISS_MagFit", t = 1.5},
		{s = "Firearms2.KRISS_MagIn", t = 1.65},
		{s = "Firearms2.Cloth_Movement", t = 1.65},
        },
    },
    ["reload_empty_nomen"] = {
        Source = "reload_empty",
        Time = 110/40,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.KRISS_MagOut", t = 0.45},
        {s = "Firearms2.Cloth_Movement", t = 0.45},
		{s = "Firearms2.Magpouch_SMG", t = 0.9},
		{s = "Firearms2.KRISS_MagFit", t = 1.5},
		{s = "Firearms2.KRISS_MagIn", t = 1.65},
		{s = "Firearms2.Cloth_Movement", t = 1.65},
		{s = "Firearms2.KRISS_ChargeBack", t = 2.15},
		{s = "Firearms2.Cloth_Movement", t = 2.15},
		{s = "Firearms2.KRISS_ChargeRelease", t = 2.325},
		{s = "Firearms2.Cloth_Movement", t = 2.325}
        },
    },
    ["reload_empty_grip_nomen"] = {
        Source = "reload_empty_grip",
        Time = 110/40,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.KRISS_MagOut", t = 0.45},
        {s = "Firearms2.Cloth_Movement", t = 0.45},
        {s = "Firearms2.Magpouch_SMG", t = 0.9},
        {s = "Firearms2.KRISS_MagFit", t = 1.5},
        {s = "Firearms2.KRISS_MagIn", t = 1.65},
        {s = "Firearms2.Cloth_Movement", t = 1.65},
        {s = "Firearms2.KRISS_ChargeBack", t = 2.15},
        {s = "Firearms2.Cloth_Movement", t = 2.15},
        {s = "Firearms2.KRISS_ChargeRelease", t = 2.325},
        {s = "Firearms2.Cloth_Movement", t = 2.325}
        },
    },
}