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
        ang = Angle(-1.65, 270.5, 0),
        fov = 12.4
    }
}

SWEP.PrintName = "Mossberg Maverick 88 Cruiser"
SWEP.Trivia_Class = "Shotgun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = ""
SWEP.Trivia_Calibre = "12 Gauge"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1950"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/shotguns/mossbergm88c.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/shotguns/mossbergm88c.mdl"
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
SWEP.RecoilSide = 0.3

SWEP.RecoilRise = 0.05
SWEP.RecoilPunch = 0.7
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

SWEP.AccuracyMOA = 80 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 360 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "12gauge" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Firearms2_MOSSM88C"
SWEP.ShootDrySound = "fas2/empty_shotguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/bm16.ogg"
SWEP.ShootSoundSilenced = "Firearms2_MOSSM88C_S"
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
    Pos = Vector(-2.27, -5.426, 2.02),
    Ang = Angle(0.5, 0, 0),
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
    ["9rnd"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
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
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_choke"}
    },
    {
        PrintName = "Tube",
        DefaultAttName = "Mossberg M88C 7rnd Tube",
        Slot = "fas2_m88c_9rnd",
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "12 Gauge",
        Slot = "fas2_ammo_shotgun",
    },
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "fire1",
        Time = 30/35,
        MinProgress = 0.4,
    },
    ["fire_iron"] = {
        Source = "fire1_scoped",
        Time = 30/35,
        MinProgress = 0.4,
    },
    ["cycle"] = {
        Source = "pump",
        Time = 37/30,
        ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        ShellEjectAt = 0.4,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MOSSM8C_PumpBack", t = 0.33},
        {s = "Firearms2.MOSSM8C_PumpForward", t = 0.5},
        },
    },
    ["cycle_iron"] = {
        Source = "pump_scoped",
        Time = 13/30,
        ShellEjectAt = 0.1,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MOSSM8C_PumpBack", t = 0},
        {s = "Firearms2.MOSSM8C_PumpForward", t = 0.25},
        },
    },
    ["sgreload_start"] = {
        Source = "reload_start",
        Time = 20/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {{s = "Firearms2.Cloth_Movement", t = 0}},
    },
    ["sgreload_insert"] = {
        Source = "reload_load1",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MOSSM8C_Load", t = 0.2},
        },
    },
    ["sgreload_finish"] = {
        Source = "reload_end",
        Time = 20/30,
    },
    ["sgreload_finish_empty"] = {
        Source = "reload_end_pump",
        Time = 35/30,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.MOSSM8C_PumpBack", t = 0.66},
        {s = "Firearms2.MOSSM8C_PumpForward", t = 0.93},
        },
    },
}