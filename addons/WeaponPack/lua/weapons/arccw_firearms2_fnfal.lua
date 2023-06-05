include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 4

SWEP.ItemData = {
    width = 3,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 6 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.65, 270.8, 0),
        fov = 13.01
    }
}

SWEP.PrintName = "FN FAL"
SWEP.Trivia_Class = "Battle Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "FN Herstal"
SWEP.Trivia_Calibre = "7.62x51mm"
SWEP.Trivia_Country = "Belgium"
SWEP.Trivia_Year = "1953"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/snipers/fnfal.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/snipers/fnfal.mdl"
SWEP.ViewModelFOV = 52

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 47
SWEP.DamageMin = 24 -- damage done at maximum range
SWEP.Range = 600 -- in METRES
SWEP.Penetration = 9
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 840 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.

SWEP.Recoil = 2.1
SWEP.RecoilSide = 0.3

SWEP.RecoilRise = 0.04
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.12 -- 60 / RPM.
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
SWEP.HipDispersion = 350 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "7.62x51mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_FNFAL"
SWEP.ShootDrySound = "fas2/empty_sniperrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/fnfal.ogg"
SWEP.ShootSoundSilenced = "Firearms2_FNFAL_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_6b"

SWEP.ShellModel = "models/shells/7_62x51mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.3695, -2, 0.75),
    Ang = Angle(0.63, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 13 -- The mean number of shots between malfunctions, will be autocalculated if nil
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

SWEP.CrouchPos = Vector(-1, -2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(4, -2.5, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4, -2.5, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 30

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
    ["mag"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["50rnd"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 2, bg = 2}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "FAL/SA-58 10rnd Mag",
        Slot = {"fas2_falmag", "fas2_xfal_50rnd"}
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "7.62x51MM",
        Slot = "fas2_ammo_762x51mmap",
    },
}

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local mag = wep.Attachments[2].Installed == "fas2_mag_fal_50rnd" and "_drum" or ""

	return anim .. mag
end

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 35/53,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_empty"] = {
        Source = "deploy_empty",
        Time = 35/53,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 22/66,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 22/66,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 25/60,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 25/58,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_scoped",
        Time = 20/60,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "fire_scoped_last",
        Time = 20/60,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 45/30,
        ShellEjectAt = 0.7,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.FNFAL_BoltBack", t = 0.67},
        {s = "Firearms2.Cloth_Movement", t = 0.67},
        {s = "Firearms2.FNFAL_BoltRelease", t = 0.87}
        },
    },
   ["reload"] = {
        Source = "reload",
        Time = 100/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.FNFAL_MagOut", t = 0.65},
		{s = "Firearms2.Cloth_Movement", t = 0.65},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SVD_MagInPartial", t = 1.7},
		{s = "Firearms2.FNFAL_MagIn", t = 1.96},
		{s = "Firearms2.Cloth_Movement", t = 1.96}
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 96/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.FNFAL_MagOut", t = 0.65},
        {s = "Firearms2.Cloth_Movement", t = 0.65},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SVD_MagInPartial", t = 1.7},
        {s = "Firearms2.FNFAL_MagIn", t = 1.96},
        {s = "Firearms2.Cloth_Movement", t = 1.96},
        {s = "Firearms2.FNFAL_BoltRelease", t = 2.41}
        },
    },
    ["reload_drum"] = {
        Source = "reload_drum",
        Time = 100/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.FNFAL_MagOut", t = 0.65},
		{s = "Firearms2.Cloth_Movement", t = 0.65},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SVD_MagInPartial", t = 1.7},
		{s = "Firearms2.FNFAL_MagIn", t = 1.96},
		{s = "Firearms2.Cloth_Movement", t = 1.96}
        },
    },
    ["reload_empty_drum"] = {
        Source = "reload_drum_empty",
        Time = 96/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.FNFAL_MagOut", t = 0.65},
        {s = "Firearms2.Cloth_Movement", t = 0.65},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SVD_MagInPartial", t = 1.7},
        {s = "Firearms2.FNFAL_MagIn", t = 1.96},
        {s = "Firearms2.Cloth_Movement", t = 1.96},
        {s = "Firearms2.FNFAL_BoltRelease", t = 2.4}
        },
    },
}