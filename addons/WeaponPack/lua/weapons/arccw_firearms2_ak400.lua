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
        ang = Angle(-1.46, 271, 0),
        fov = 12.1
    }
}

SWEP.PrintName = "AK-400"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Izhmash"
SWEP.Trivia_Calibre = "5.45x39mm"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "2012"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/ak400.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/ak400.mdl"
SWEP.ViewModelFOV = 55

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 34
SWEP.DamageMin = 17 -- damage done at maximum range
SWEP.Range = 800 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 900 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.3

SWEP.RecoilRise = 0.55
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
SWEP.HipDispersion = 410 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "5.45x39mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_AK400"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/ak12.ogg"
SWEP.ShootSoundSilenced = "Firearms2_AK400_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_ak47"

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
    Pos = Vector(-2.131, -3.875, 0.59),
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
    ["fas2_scope_pso1"] = true
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
        Bone = "body",
        Offset = {
            vpos = Vector(2.85, -1, -0.009),
            vang = Angle(0, 0, 270),
            wpos = Vector(7.7, 0.75, -5.45),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0.0009, 0, 0.005),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Canted Sight",
        Slot = "fas2_cantedsight",
        Bone = "body",
        ExcludeFlags = {"tactical"},
        GivesFlags = {"cantedsight"},
        Offset = {
            vpos = Vector(6, -0.935, -0.009),
            vang = Angle(0, 0, 270),
            wpos = Vector(12.8, 0.75, -6.32),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "body",
        ExcludeFlags = {"cantedsight"},
        GivesFlags = {"tactical"},
        Offset = {
            vpos = Vector(7.8, -0.58, 0.465),
            vang = Angle(0, 0, 0),
            wpos = Vector(16.5, -0.05, -6.25),
            wang = Angle(-10.393, 0, 270),
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
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[5].Installed and "_grip" or ""

	return "reload" .. empty .. grip
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
        Time = 17/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 15/30,
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
    ["fix"] = {
        Source = "fix",
        Time = 40/30,
        ShellEjectAt = 0.75,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},    
		{s = "Firearms2.AK400_BoltHalf", t = 0.34},
		{s = "Firearms2.Cloth_Movement", t = 0.34},
		{s = "Firearms2.AK400_BoltBack", t = 0.64},
		{s = "Firearms2.Cloth_Movement", t = 0.64},
		{s = "Firearms2.AK400_BoltForward", t = 0.8}
		},
    },
    ["reload"] = {
        Source = "reload",
        Time = 70/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AK400_MagOut", t = 0.53},
        {s = "Firearms2.Cloth_Movement", t = 0.53},
        {s = "Firearms2.Magpouch", t = 1.14},
        {s = "Firearms2.AK400_MagInsert", t = 1.27},
        {s = "Firearms2.AK400_MagIn", t = 1.36},
        {s = "Firearms2.Cloth_Movement", t = 1.36}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 93/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK400_MagOut", t = 0.53},
		{s = "Firearms2.Cloth_Movement", t = 0.53},
		{s = "Firearms2.Magpouch", t = 1.14},
		{s = "Firearms2.AK400_MagInsert", t = 1.27},
		{s = "Firearms2.AK400_MagIn", t = 1.36},
		{s = "Firearms2.Cloth_Movement", t = 1.36},
		{s = "Firearms2.AK400_BoltBack", t = 1.9},
		{s = "Firearms2.Cloth_Movement", t = 1.9},
		{s = "Firearms2.AK400_BoltForward", t = 2.07}
		},
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 17/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 15/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire_grip"] = {
        Source = "fire_grip",
        Time = 12/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "fire_iron_grip",
        Time = 12/30,
        ShellEjectAt = 0,
    },
    ["fix_grip"] = {
        Source = "fix_grip",
        Time = 40/30,
        ShellEjectAt = 0.75,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},    
		{s = "Firearms2.AK400_BoltHalf", t = 0.34},
		{s = "Firearms2.Cloth_Movement", t = 0.34},
		{s = "Firearms2.AK400_BoltBack", t = 0.64},
		{s = "Firearms2.Cloth_Movement", t = 0.64},
		{s = "Firearms2.AK400_BoltForward", t = 0.8}
		},
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 70/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AK400_MagOut", t = 0.53},
        {s = "Firearms2.Cloth_Movement", t = 0.53},
        {s = "Firearms2.Magpouch", t = 1.14},
        {s = "Firearms2.AK400_MagInsert", t = 1.27},
        {s = "Firearms2.AK400_MagIn", t = 1.36},
        {s = "Firearms2.Cloth_Movement", t = 1.36}
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 93/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.AK400_MagOut", t = 0.53},
		{s = "Firearms2.Cloth_Movement", t = 0.53},
		{s = "Firearms2.Magpouch", t = 1.14},
		{s = "Firearms2.AK400_MagInsert", t = 1.27},
		{s = "Firearms2.AK400_MagIn", t = 1.36},
		{s = "Firearms2.Cloth_Movement", t = 1.36},
		{s = "Firearms2.AK400_BoltBack", t = 1.9},
		{s = "Firearms2.Cloth_Movement", t = 1.9},
		{s = "Firearms2.AK400_BoltForward", t = 2.07}
		},
    },
}