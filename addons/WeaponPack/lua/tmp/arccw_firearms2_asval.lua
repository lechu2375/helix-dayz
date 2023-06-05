include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 4

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

SWEP.PrintName = "AS VAL"
SWEP.Trivia_Class = "Designated Marksman Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Tula Arms Plant"
SWEP.Trivia_Calibre = "9x39MM"
SWEP.Trivia_Country = "Soviet Union"
SWEP.Trivia_Year = "1987"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/asval.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/asval.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 39
SWEP.DamageMin = 19 -- damage done at maximum range
SWEP.Range = 300 -- in METRES
SWEP.Penetration = 15
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 282 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.

SWEP.Recoil = 1.6
SWEP.RecoilSide = 0.09

SWEP.RecoilRise = 0.11
SWEP.RecoilPunch = 0.4
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.08 -- 60 / RPM.
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
SWEP.HipDispersion = 370 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "9x39mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

-- SWEP.IsSilent = true
-- SWEP.Silencer = true

SWEP.ShootVol = 70 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_ASVAL_S"
SWEP.ShootSoundSilenced = "Firearms2_ASVAL_S"
SWEP.ShootDrySound = "fas2/empty_submachineguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_suppressed"

SWEP.ShellModel = "models/shells/9x39mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.22, -4.646, 1.82),
    Ang = Angle(0.1, 0.01, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.SightTime = 0.4

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4.3, -2, 0.6)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -3, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.532, -3, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 28

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["20rnd"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["30rnd"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 2, bg = 2}},
    },
    ["grip"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope", "fas2_scope_pso1"},
        Bone = "ak_frame", 
        Offset = {
            vpos = Vector(-0.025, 1.8, 1.7),
            vang = Angle(0, 270, 0),
            wpos = Vector(6.4, 0.76, -5.45),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(0.9, 0.9, 0.9),
        WMScale = Vector(1.5, 1.5, 1.5),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0)
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "9x39 10Rnd Mag",
        Slot = "fas2_9x39_mags"
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "9x39MM",
        Slot = {"fas2_ammo_9x39mmap", "fas2_ammo_9x39mmsp"}
    },
    {
        PrintName = "",
        DefaultAttName = "",
        Slot = "fas2_muzzle_integrated",
        Installed = "fas2_muzzle_suppressor_integrated",
        Integral = true,
    },	
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[2].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[2].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[2].Installed and "_grip" or ""

	return "reload" .. empty .. grip
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 0/1,
    },
    ["draw"] = {
        Source = "deploy",
        Time = 25/50,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/50,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 20/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_scoped",
        Time = 20/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {{s = "Firearms2.VSS_Reload", t = 0.01}},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {{s = "Firearms2.VSS_Reload_Empty", t = 0.01}},
    },
    ["idle_grip"] = {
        Source = "idle_grip",
        Time = 0/1,
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 25/50,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 20/50,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire_grip"] = {
        Source = "fire_grip",
        Time = 20/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "fire_scoped_grip",
        Time = 20/30,
        ShellEjectAt = 0,
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 80/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {{s = "Firearms2.VSS_Reload", t = 0.01}},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {{s = "Firearms2.VSS_Reload_Empty", t = 0.01}},
    },
}