include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 1

SWEP.ItemData = {
    width = 2,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 1 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.65, 270.5, 0),
        fov = 12.4
    }
}

SWEP.PrintName = "OTs-33 Pernach"
SWEP.Trivia_Class = "Machine pistol"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "KBP Instrument Design Bureau"
SWEP.Trivia_Calibre = "9x18"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "1996"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/pistols/ots33.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/pistols/ots33.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 15
SWEP.DamageMin = 7 -- damage done at maximum range
SWEP.Range = 50 -- in METRES
SWEP.Penetration = 2
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 330 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 18 -- DefaultClip is automatically set.

SWEP.Recoil = 1.1
SWEP.RecoilSide = 0.05

SWEP.RecoilRise = 0.035
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.075 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0,
    },
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 380 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "9x18mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_OTS33"
SWEP.ShootDrySound = "fas2/empty_pistol.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/ots33.ogg"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_OTS"

SWEP.ShellModel = "models/shells/9x18mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Pistol
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-1.655, -0.786, 0.63),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

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

SWEP.CustomizePos = Vector(2.824, -4, -1)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 17

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["muzzlebrake"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["flashhider"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Ironsight",
        DefaultAttName = "Ironsight",
        Slot = "fas2_pistol_sight",
        Bone = "Base",
        Offset = {
            vpos = Vector(0.01, -0.87, -2.7),
            vang = Angle(270, 0, 270),
            wpos = Vector(8, 0.82, -4.75),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_pistol_tactical",
        Bone = "Base",
        Offset = {
            vpos = Vector(0.01, 0.98, -3.9),
            vang = Angle(270, 0, 270),
            wpos = Vector(10.3, 0.82, -2.2),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.4, 1.4, 1.4),
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "9x18MM",
        Slot = "fas2_ammo_9x18mmap",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "Idle_Iron",
        Time = 0/1,
    },
    ["idle_empty"] = {
        Source = "Idle_Empty_Iron",
        Time = 0/1,
    },
    ["draw"] = {
        Source = "Draw",
        Time = 15/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["draw_empty"] = {
        Source = "Draw_Empty",
        Time = 15/45,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["holster"] = {
        Source = "Holster",
        Time = 15/45,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "Holster_Empty",
        Time = 15/45,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"Fire1", "Fire2", "Fire3"},
        Time = 15/30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "Fire_Last",
        Time = 15/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "Fire_Iron",
        Time = 15/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "Fire_Last_Iron",
        Time = 15/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "Reload_Wet",
        Time = 70/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.OTs33_MagOut", t = 0.4},
		{s = "Firearms2.Cloth_Movement", t = 0.4},
		{s = "Firearms2.Magpouch_Pistol", t = 0.6},
		{s = "Firearms2.OTs33_MagInPartial", t = 1},
		{s = "Firearms2.Cloth_Movement", t = 1},
		{s = "Firearms2.OTs33_MagIn", t = 1.25},
		{s = "Firearms2.Cloth_Movement", t = 1.25},
		},
    },
    ["reload_empty"] = {
        Source = "Reload_Dry",
        Time = 70/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.OTs33_MagOutEmpty", t = 0.4},
        {s = "Firearms2.Cloth_Movement", t = 0.4},
        {s = "Firearms2.Magpouch_Pistol", t = 0.6},
        {s = "Firearms2.OTs33_MagInPartial", t = 1},
		{s = "Firearms2.Cloth_Movement", t = 1},
        {s = "Firearms2.OTs33_MagIn", t = 1.25},
        {s = "Firearms2.Cloth_Movement", t = 1.25},
        {s = "Firearms2.OTs33_SlideRelease", t = 1.9},
		{s = "Firearms2.Cloth_Movement", t = 1.9},
		},
    },
    ["reload_nomen"] = {
        Source = "Fast_Reload_Wet",
        Time = 50/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.OTs33_MagOut", t = 0.4},
		{s = "Firearms2.Magpouch_Pistol", t = 0.6},
		{s = "Firearms2.OTs33_MagInPartial", t = 0.7},
		{s = "Firearms2.OTs33_MagIn", t = 0.9},
		{s = "Firearms2.Cloth_Movement", t = 0.9},
		},
    },
    ["reload_nomen_empty"] = {
        Source = "Fast_Reload_Dry",
        Time = 60/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.OTs33_MagOutEmpty", t = 0.4},
		{s = "Firearms2.Magpouch_Pistol", t = 0.6},
		{s = "Firearms2.OTs33_MagInPartial", t = 0.7},
		{s = "Firearms2.OTs33_MagIn", t = 0.9},
		{s = "Firearms2.Cloth_Movement", t = 0.9},
		{s = "Firearms2.OTs33_SlideRelease", t = 1.2},
		{s = "Firearms2.Cloth_Movement", t = 1.2},
		},
    },
}