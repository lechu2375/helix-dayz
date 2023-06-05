include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 2

SWEP.ItemData = {
    width = 2,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 40 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.65, 270.5, 0),
        fov = 12.4
    }
}

SWEP.PrintName = "MAC-11"
SWEP.Trivia_Class = "Machine pistol"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Military Armament Corporation"
SWEP.Trivia_Calibre = "9x19MM"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1972"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/smgs/mac11.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/smgs/mac11.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 20
SWEP.DamageMin = 20 -- damage done at maximum range
SWEP.Range = 70 -- in METRES
SWEP.Penetration = 2
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 980 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 32 -- DefaultClip is automatically set.

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.2

SWEP.RecoilRise = 0.04
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.05 -- 60 / RPM.
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
SWEP.HipDispersion = 440 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "9x19mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_MAC11"
SWEP.ShootDrySound = "fas2/empty_submachineguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/mac11.ogg"
SWEP.ShootSoundSilenced = "Firearms2_MAC11_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_smg"

SWEP.ShellModel = "models/shells/9x19mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Pistol
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.03, -2.18, 0.67),
    Ang = Angle(0.2, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.SightTime = 0.35

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-0.5, -2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(0.4, -6, -2.69)
SWEP.HolsterAng = Angle(38.433, 0, 0)

SWEP.SprintPos = Vector(0.4, -6, -2.69)
SWEP.SprintAng = Angle(38.433, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(6.824, 0, -2)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 26

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
        Time = 32/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 32/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"fire", "fire2"},
        Time = 24/30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 24/30,
        ShellEjectAt = 0,
        SoundTable = {{s = "Firearms2.MAC11_BoltForward", t = 0.1}},
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
        SoundTable = {{s = "Firearms2.MAC11_BoltForward", t = 0.1}},
    },
    ["reload"] = {
        Source = "reload",
        Time = 102/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.MAC11_MagOut", t = 1},
		{s = "Firearms2.Cloth_Movement", t = 1},
		{s = "Firearms2.Magpouch_SMG", t = 1.5},
		{s = "Firearms2.MAC11_MagIn", t = 2.1},
		{s = "Firearms2.Cloth_Movement", t = 2.1}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 141/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MAC11_MagOutEmpty", t = 1},
        {s = "Firearms2.Cloth_Movement", t = 1},
        {s = "Firearms2.Magpouch_SMG", t = 1.5},
        {s = "Firearms2.MAC11_MagIn", t = 2.1},
        {s = "Firearms2.Cloth_Movement", t = 2.1},
        {s = "Firearms2.MAC11_BoltBack", t = 3.14},
        {s = "Firearms2.Cloth_Movement", t = 3.24},
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 102/45,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MAC11_MagOut", t = 0.6},
        {s = "Firearms2.Cloth_Movement", t = 0.6},
        {s = "Firearms2.Magpouch_SMG", t = 1},
        {s = "Firearms2.MAC11_MagIn", t = 1.4},
        {s = "Firearms2.Cloth_Movement", t = 1.4},
		},
    },
    ["reload_nomen_empty"] = {
        Source = "reload_empty_nomen",
        Time = 141/45,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MAC11_MagOutEmpty", t = 0.6},
        {s = "Firearms2.Cloth_Movement", t = 0.6},
        {s = "Firearms2.Magpouch_SMG", t = 1},
        {s = "Firearms2.MAC11_MagIn", t = 1.4},
        {s = "Firearms2.Cloth_Movement", t = 1.4},
        {s = "Firearms2.MAC11_BoltBack", t = 2.1},
        {s = "Firearms2.Cloth_Movement", t = 2.16},
		},
    },
}