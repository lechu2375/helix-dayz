include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 2

SWEP.PrintName = "UMP-45"
SWEP.Trivia_Class = "Submachine Gun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Heckler & Koch"
SWEP.Trivia_Calibre = ".45 ACP"
SWEP.Trivia_Country = "Germany"
SWEP.Trivia_Year = "1999"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/smgs/ump45.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/smgs/ump45.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 25
SWEP.DamageMin = 12 -- damage done at maximum range
SWEP.Range = 65 -- in METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 285 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 25 -- DefaultClip is automatically set.

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.16

SWEP.RecoilRise = 0.06
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
        Mode = -2,
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
SWEP.HipDispersion = 360 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = ".45acp" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_UMP45"
SWEP.ShootDrySound = "fas2/empty_submachineguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/ump45.ogg"
SWEP.ShootSoundSilenced = "Firearms2_UMP45_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_3"

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
    Pos = Vector(-1.986, -5, 0.825),
    Ang = Angle(0, 0, 0),
    Magnification = 1.2 ,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.SightTime = 0.35

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(0.2, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(4.5, -3, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.5, -3, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 24

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
            vpos = Vector(0.7, -1.52, 0.015),
            vang = Angle(0, 0, 270),
            wpos = Vector(6, 0.8, -6.35),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.4, 1.4, 1.4),
        CorrectivePos = Vector(0.003, 0, 0.00),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = ".45 ACP",
        Slot = "fas2_ammo_45acphs",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[3].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[3].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local nomen = wep.Attachments[5].Installed and "_nomen" or ""
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[3].Installed and "_grip" or ""

	return "reload" .. empty .. nomen .. grip
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
    -- ["ready"] = {
    --     Source = "deploy_first",
    --     Time = 30/30,
	-- 	SoundTable = {
	-- 	{s = "Firearms2.Deploy", t = 0},
	-- 	{s = "Firearms2.Cloth_Movement", t = 0.2},
	-- 	{s = "Firearms2.MP5_SelectorSwitch", t = 0.7},
	-- 	{s = "Firearms2.Cloth_Movement", t = 0.7},
	-- 	},
    -- },
    ["draw"] = {
        Source = "deploy",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "shoot",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "shoot_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "shoot_last_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_MagOut", t = 0.6},
		{s = "Firearms2.UMP45_Cloth", t = 1.4},
		{s = "Firearms2.UMP45_MagIn", t = 2.2},
		{s = "Firearms2.Cloth_Movement", t = 2.2},
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 105/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_BoltBack", t = 0.4},
		{s = "Firearms2.UMP45_Cloth", t = 0.7},
		{s = "Firearms2.UMP45_MagOut", t = 1},
		{s = "Firearms2.UMP45_Cloth", t = 1.7},
		{s = "Firearms2.UMP45_MagIn", t = 2.2},
		{s = "Firearms2.UMP45_BoltForward", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9}
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_MagOut", t = 0.45},
		{s = "Firearms2.Cloth_Movement", t = 0.45},
		{s = "Firearms2.UMP45_Cloth", t = 1},
		{s = "Firearms2.UMP45_MagIn", t = 1.55},
		{s = "Firearms2.Cloth_Movement", t = 1.55},
		},
    },
    ["reload_empty_nomen"] = {
        Source = "reload_empty_nomen",
        Time = 79/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_Cloth", t = 0.3},
		{s = "Firearms2.UMP45_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.UMP45_MagIn", t = 1.2},
		{s = "Firearms2.Cloth_Movement", t = 1.2},
		{s = "Firearms2.UMP45_BoltBack", t = 1.8},
		{s = "Firearms2.Cloth_Movement", t = 1.8},
		{s = "Firearms2.UMP45_BoltForward", t = 2},
		{s = "Firearms2.Cloth_Movement", t = 2}
		},
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_MagOut", t = 0.6},
		{s = "Firearms2.UMP45_Cloth", t = 1.4},
		{s = "Firearms2.UMP45_MagIn", t = 2.2},
		{s = "Firearms2.Cloth_Movement", t = 2.2},
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 105/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_BoltBack", t = 0.4},
		{s = "Firearms2.UMP45_Cloth", t = 0.7},
		{s = "Firearms2.UMP45_MagOut", t = 1},
		{s = "Firearms2.UMP45_Cloth", t = 1.7},
		{s = "Firearms2.UMP45_MagIn", t = 2.2},
		{s = "Firearms2.UMP45_BoltForward", t = 2.9},
		{s = "Firearms2.Cloth_Movement", t = 2.9}
		},
    },
    ["reload_nomen_grip"] = {
        Source = "reload_nomen_grip",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_MagOut", t = 0.45},
		{s = "Firearms2.Cloth_Movement", t = 0.45},
		{s = "Firearms2.UMP45_Cloth", t = 1},
		{s = "Firearms2.UMP45_MagIn", t = 1.55},
		{s = "Firearms2.Cloth_Movement", t = 1.55},
		},
    },
    ["reload_empty_nomen_grip"] = {
        Source = "reload_empty_nomen_grip",
        Time = 79/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.UMP45_Cloth", t = 0.3},
		{s = "Firearms2.UMP45_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.UMP45_MagIn", t = 1.2},
		{s = "Firearms2.Cloth_Movement", t = 1.2},
		{s = "Firearms2.UMP45_BoltBack", t = 1.8},
		{s = "Firearms2.Cloth_Movement", t = 1.8},
		{s = "Firearms2.UMP45_BoltForward", t = 2},
		{s = "Firearms2.Cloth_Movement", t = 2}
		},
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire_grip"] = {
        Source = "shoot_grip",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_empty_grip"] = {
        Source = "shoot_last_grip",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "shoot_scoped_grip",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty_grip"] = {
        Source = "shoot_last_scoped_grip",
        Time = 30/35,
        ShellEjectAt = 0,
    },
}