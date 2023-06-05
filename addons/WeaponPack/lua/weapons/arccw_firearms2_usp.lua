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

SWEP.PrintName = "HK USP"
SWEP.Trivia_Class = "Semi-automatic pistol"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Heckler & Koch"
SWEP.Trivia_Calibre = ".45 ACP"
SWEP.Trivia_Country = "Germany"
SWEP.Trivia_Year = "1993"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/pistols/usp.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/pistols/usp.mdl"
SWEP.ViewModelFOV = 65

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 17
SWEP.DamageMin = 8 -- damage done at maximum range
SWEP.Range = 50 -- in METRES
SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 280 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 12 -- DefaultClip is automatically set.

SWEP.Recoil = 1.25
SWEP.RecoilSide = 0.05

SWEP.RecoilRise = 0.06
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.2
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
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = ".45acp" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = 0

SWEP.ShootSound = "Firearms2_USP"
SWEP.ShootDrySound = "fas2/empty_pistol.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/m1911.ogg"
SWEP.ShootSoundSilenced = "Firearms2_USP_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_pistol_red"

SWEP.ShellModel = "models/shells/45acp.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Pistol
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.223, -1, 0.68),
    Ang = Angle(0.15, 0, 0),
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

SWEP.ActivePos = Vector(-0.7, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -3, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(0.4, -4, -2.69)
SWEP.HolsterAng = Angle(38.433, 0, 0)

SWEP.SprintPos = Vector(0.4, -4, -2.69)
SWEP.SprintAng = Angle(38.433, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 10, -3)

SWEP.CustomizePos = Vector(2.824, -2, -1)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 17

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
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
    ["match_compensator"] = {
        VMBodygroups = {{ind = 2, bg = 4}},
        WMBodygroups = {{ind = 1, bg = 4}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Ironsight",
        DefaultAttName = "Ironsight",
        Slot = "fas2_pistol_sight",
        Bone = "framebone",
        Offset = {
            vpos = Vector(-0.02, 2.4, 1.42),
            vang = Angle(0, 270, 0),
            wpos = Vector(7.5, 0.8, -4.25),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(0.95, 0.95, 0.95),
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0),
        ExcludeFlags = {"match_compensator"},
        GivesFlags = {"sight"}
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider", "fas2_match_compensator"},
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_pistol_tactical",
        Bone = "framebone",
        Offset = {
            vpos = Vector(-0.02, 2.75, -0.5),
            vang = Angle(0, 270, 0),
            wpos = Vector(8.6, 0.8, -1.35),
            wang = Angle(-10.393, 0, 180),
        },
        VMScale = Vector(0.95, 0.95, 0.95),
        WMScale = Vector(1.6, 1.6, 1.6),
        ExcludeFlags = {"match_compensator"},
        GivesFlags = {"tactical"}
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

function SWEP:Hook_NameChange(name)
    local eles = self:GetActiveElements()

    local name = "HK USP"
    local model = " MATCH"

    for i, k in pairs(eles or {}) do
        if k == "fas2_muzzle_match_compensator" then
            return name .. model
        end
    end

    if model == "" then
        return name .. model
    end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local nomen = wep.Attachments[5].Installed and "_nomen" or ""

	return anim .. nomen
end

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 20/60,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 20/60,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            },
    },
    ["holster"] = {
        Source = "holster",
        Time = 15/45,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 15/45,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3"},
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 15/30,
        ShellEjectAt = 0,
		SoundTable = {
        {s = "Firearms2.P226_SlideBack", t = 0},
        },
    },
    ["fire_iron"] = {
        Source = "Fire_Iron",
        Time = 9/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "fire_last_iron",
        Time = 15/35,
        ShellEjectAt = 0,
		SoundTable = {
        {s = "Firearms2.P226_SlideBack", t = 0},
        },
    },
    ["reload"] = {
        Source = "reload",
        Time = 46/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
		{s = "Firearms2.USP_MagOut", t = 0.2},
        {s = "Firearms2.Cloth_Movement", t = 0.2},
		{s = "Firearms2.Magpouch_Pistol", t = 0.43},
		{s = "Firearms2.USP_MagIn", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.USP_MagOut", t = 0.2},
        {s = "Firearms2.Cloth_Movement", t = 0.2},
        {s = "Firearms2.Magpouch_Pistol", t = 0.43},
        {s = "Firearms2.USP_MagIn", t = 0.8},
        {s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.P226_SlideBack", t = 1.85},
		{s = "Firearms2.Cloth_Movement", t = 1.85},
		{s = "Firearms2.USP_BoltRelease", t = 2.1},
		{s = "Firearms2.Cloth_Movement", t = 2.1},
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 46/40,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.USP_MagOut", t = 0.125},
        {s = "Firearms2.Cloth_Movement", t = 0.125},
        {s = "Firearms2.Magpouch_Pistol", t = 0.325},
        {s = "Firearms2.USP_MagIn", t = 0.575},
        {s = "Firearms2.Cloth_Movement", t = 0.575},
		},
    },
    ["reload_empty_nomen"] = {
        Source = "reload_empty_nomen",
        Time = 85/40,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.USP_MagOut", t = 0.125},
        {s = "Firearms2.Cloth_Movement", t = 0.125},
        {s = "Firearms2.Magpouch_Pistol", t = 0.325},
        {s = "Firearms2.USP_MagIn", t = 0.575},
        {s = "Firearms2.Cloth_Movement", t = 0.575},
        {s = "Firearms2.P226_SlideBack", t = 1.3875},
        {s = "Firearms2.Cloth_Movement", t = 1.3875},
        {s = "Firearms2.USP_BoltRelease", t = 1.575},
        {s = "Firearms2.Cloth_Movement", t = 1.575},
		},
    },
}