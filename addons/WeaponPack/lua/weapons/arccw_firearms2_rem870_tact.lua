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
    rarity = { weight = 35 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.33, 270.01, 0),
        fov = 13
    }
}

SWEP.PrintName = "Remington 870 Tactical"
SWEP.Trivia_Class = "Shotgun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Remington Arms"
SWEP.Trivia_Calibre = "12 Gauge"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1950"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/shotguns/remington870_tact.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/shotguns/remington870_tact.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 9
SWEP.DamageMin = 6 -- damage done at maximum range
SWEP.Range = 90 -- in METRES
SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 710 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 7 -- DefaultClip is automatically set.

SWEP.ShotgunReload = true
SWEP.ManualAction = true

SWEP.Recoil = 7
SWEP.RecoilSide = 0.15

SWEP.RecoilRise = 0.03
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.2 -- 60 / RPM.
SWEP.Num = 12 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        PrintName = "PUMP",
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 70 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 340 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "12gauge" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Firearms2_REM870_TACT"
SWEP.ShootDrySound = "fas2/empty_shotguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/bm16.ogg"
SWEP.ShootSoundSilenced = "Firearms2_REM870_TACT_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_shotgun"

SWEP.ShellModel = "models/shells/12g_buck.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_ShotgunShell
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-1.903, -4.935, 1.475),
    Ang = Angle(0.4, 0.13, 0),
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

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, -3, 0.5)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -5, 1)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.532, -5, 1)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(6.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 29

SWEP.AttachmentElements = {
    ["suppressor"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["choke"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
    ["incendiary"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
    },
    ["slug"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = "fas2_sight",
        Bone = "Body",
        Offset = {
            vpos = Vector(-2.5185, 9.8, -0.75),
            vang = Angle(0, -89.6, 0),
            wpos = Vector(10.8, 0.81, -6.07),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 179.6, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_choke"}
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "12 Gauge",
        Slot = "fas2_ammo_shotgun",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    if wep.Attachments[4].Installed then return anim .. "_nomen" end
end

SWEP.Hook_SelectInsertAnimation = function(wep, anim)
    local nomen = wep.Attachments[4].Installed and "_nomen" or ""

    anim.anim = anim.anim .. nomen

    return anim
end

SWEP.Hook_SelectCycleAnimation = function(wep, anim)
    local iron = (wep:GetState() == ArcCW.STATE_SIGHTS and "_iron") or ""
    local nomen = wep.Attachments[4].Installed and "_nomen" or ""

    return "cycle" .. iron .. nomen
end

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire",
        Time = 15/30,
        MinProgress = 0.5,
    },
    ["fire_iron"] = {
        Source = "fire_scoped",
        Time = 10/30,
        MinProgress = 0.4,
    },
    ["cycle"] = {
        Source = "pump",
        Time = 20/30,
        ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        ShellEjectAt = 0.25,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_PumpBack", t = 0.1},
        {s = "Firearms2.REM870_Tact_PumpForward", t = 0.45},
        },
    },
    ["cycle_iron"] = {
        Source = "pump_scoped",
        Time = 20/30,
        ShellEjectAt = 0.1,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_PumpBack", t = 0.1},
        {s = "Firearms2.REM870_Tact_PumpForward", t = 0.45},
        },
    },
    ["sgreload_start"] = {
        Source = "reload_start",
        Time = 15/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {{s = "Firearms2.Cloth_Movement", t = 0}},
    },
    ["sgreload_insert"] = {
        Source = "reload",
        Time = 20/30,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_Insert", t = 0.2},
        },
    },
    ["sgreload_finish"] = {
        Source = "reload_end",
        Time = 15/30,
    },
    ["sgreload_finish_empty"] = {
        Source = "reload_end_pump",
        Time = 50/30,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_PumpBack", t = 0.76},
        {s = "Firearms2.REM870_Tact_PumpForward", t = 0.96},
        },
    },
    ["cycle_nomen"] = {
        Source = "pump",
        Time = 20/35,
        ShellEjectAt = 0.21,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_PumpBack", t = 0.08},
        {s = "Firearms2.REM870_Tact_PumpForward", t = 0.38},
        },
    },
    ["cycle_iron_nomen"] = {
        Source = "pump_scoped",
        Time = 20/35,
        ShellEjectAt = 0.21,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_PumpBack", t = 0.08},
        {s = "Firearms2.REM870_Tact_PumpForward", t = 0.38},
        },
    },
    ["sgreload_start_nomen"] = {
        Source = "reload_start",
        Time = 15/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {{s = "Firearms2.Cloth_Movement", t = 0}},
    },
    ["sgreload_start_empty_nomen"] = {
        Source = "reload_start",
        Time = 15/35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {{s = "Firearms2.Cloth_Movement", t = 0}},
    },
    ["sgreload_insert_nomen"] = {
        Source = "reload",
        Time = 20/35,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_Insert", t = 0.17},
        },
    },
    ["sgreload_finish_nomen"] = {
        Source = "reload_end",
        Time = 15/35,
    },
    ["sgreload_finish_empty_nomen"] = {
        Source = "reload_end_pump",
        Time = 50/35,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.REM870_Tact_PumpBack", t = 0.65},
        {s = "Firearms2.REM870_Tact_PumpForward", t = 0.82},
        },
    }, 
}