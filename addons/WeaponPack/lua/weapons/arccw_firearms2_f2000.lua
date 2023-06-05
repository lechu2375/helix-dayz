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
    rarity = { weight = 16 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.65, 272.15, 0),
        fov = 9
    }
}

SWEP.PrintName = "FN F2000"
SWEP.Trivia_Class = "Bullpup Assault Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "FN Herstal"
SWEP.Trivia_Calibre = "5.56x45mm"
SWEP.Trivia_Country = "	Belgium"
SWEP.Trivia_Year = "2001"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/f2000.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/f2000.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 34
SWEP.DamageMin = 17 -- damage done at maximum range
SWEP.Range = 350 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 900 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.Recoil = 1.55
SWEP.RecoilSide = 0.25

SWEP.RecoilRise = 0.65
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.1 -- 60 / RPM.
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
SWEP.HipDispersion = 500 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "5.56x45mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_F2000"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/ak47.ogg"
SWEP.ShootSoundSilenced = "Firearms2_F2000_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_1"

SWEP.ShellModel = "models/shells/5_56x45mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.212, -6.646, 0.375),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 50 -- The mean number of shots between malfunctions, will be autocalculated if nil
-- SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
-- SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.4

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, -4, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-3.8, -4, 0)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(3.532, -5, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(3.532, -5, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(0.824, -7, -0.4)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 27

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["40rnd"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
    ["60rnd"] = {
        VMBodygroups = {{ind = 4, bg = 2}},
        WMBodygroups = {{ind = 3, bg = 2}},
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
            vpos = Vector(0, 4.8, 2.14),
            vang = Angle(0, 270, 0),
            wpos = Vector(4.8, 0.8, -5.25),
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
        PrintName = "Magazine",
        DefaultAttName = "5.56 30rnd Mag",
        Slot = {"fas2_556_40rnd", "fas2_556_60rnd"},
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "5.56x45MM",
        Slot = "fas2_ammo_556x45mmap",
    },
}

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local mag60 = wep.Attachments[3].Installed == "fas2_mag_556_60rnd" and "_60rnd" or ""

	return anim .. mag60
end


SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 35/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["ready"] = {
        Source = "deploy",
        Time = 35/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 30/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 60/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_scoped",
        Time = 8/30,
        ShellEjectAt = 0,
    },
    -- ["fix"] = {
    --     Source = "fix",
    --     Time = 48/36,
    --     ShellEjectAt = 0.75,
	-- 	SoundTable = {
	-- 	{s = "Firearms2.Cloth_Movement", t = 0},    
	-- 	{s = "Firearms2.AK47_BoltPull", t = 0.6},
	-- 	{s = "Firearms2.Cloth_Movement", t = 0.6}
	-- 	},
    -- },
    ["reload"] = {
        Source = "reload",
        Time = 112/37,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.F2000_MagOut", t = 0.97},
		{s = "Firearms2.Cloth_Movement", t = 0.97},
		{s = "Firearms2.Magpouch", t = 1.7},
		{s = "Firearms2.F2000_MagIn", t = 1.94},
		{s = "Firearms2.Cloth_Movement", t = 1.94}
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 130/37,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.F2000_MagOut", t = 0.64},
        {s = "Firearms2.Cloth_Movement", t = 0.64},
        {s = "Firearms2.Magpouch", t = 1.45},
        {s = "Firearms2.F2000_MagIn", t = 1.86},
        {s = "Firearms2.Cloth_Movement", t = 1.86},
        {s = "Firearms2.F2000_BoltBack", t = 2.83},
        {s = "Firearms2.Cloth_Movement", t = 2.83},
        {s = "Firearms2.F2000_BoltClose", t = 3},
        {s = "Firearms2.Cloth_Movement", t = 3}
        },
    },
    ["reload_60rnd"] = {
        Source = "reload_60rnd",
        Time = 112/37,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.F2000_MagOut", t = 0.97},
		{s = "Firearms2.Cloth_Movement", t = 0.97},
		{s = "Firearms2.Magpouch", t = 1.7},
		{s = "Firearms2.F2000_MagIn", t = 1.94},
		{s = "Firearms2.Cloth_Movement", t = 1.94}
        },
    },
    ["reload_empty_60rnd"] = {
        Source = "reload_empty_60rnd",
        Time = 130/37,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.F2000_MagOut", t = 0.64},
        {s = "Firearms2.Cloth_Movement", t = 0.64},
        {s = "Firearms2.Magpouch", t = 1.45},
        {s = "Firearms2.F2000_MagIn", t = 1.86},
        {s = "Firearms2.Cloth_Movement", t = 1.86},
        {s = "Firearms2.F2000_BoltBack", t = 2.83},
        {s = "Firearms2.Cloth_Movement", t = 2.83},
        {s = "Firearms2.F2000_BoltClose", t = 3},
        {s = "Firearms2.Cloth_Movement", t = 3}
        },
    },
}