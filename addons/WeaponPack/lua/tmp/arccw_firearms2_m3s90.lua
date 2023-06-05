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
        ang = Angle(-1.5, 270, 0),
        fov = 15
    }
}

SWEP.PrintName = "M3S90"
SWEP.Trivia_Class = "Shotgun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Benelli"
SWEP.Trivia_Calibre = "12-Gauge"
SWEP.Trivia_Country = "Italy"
SWEP.Trivia_Year = "1989"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/shotguns/m3s90.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/shotguns/m3s90.mdl"
SWEP.ViewModelFOV = 58

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 10
SWEP.DamageMin = 6 -- damage done at maximum range
SWEP.Range = 80 -- in METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 715 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 5 -- DefaultClip is automatically set.

SWEP.ShotgunReload = true

SWEP.Recoil = 7.5
SWEP.RecoilSide = 0.2

SWEP.RecoilRise = 0.06
SWEP.RecoilPunch = 0.3
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.25 -- 60 / RPM.
SWEP.Num = 12 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 60 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 290 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "12gauge" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_M3S90"
SWEP.ShootDrySound = "fas2/empty_shotguns.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/m3s90.ogg"
SWEP.ShootSoundSilenced = "Firearms2_M3S90_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_M3"

SWEP.ShellModel = "models/shells/12g_buck.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_ShotgunShell
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.26, -4, 1.7),
    Ang = Angle(0.1, 0.02, 0),
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

SWEP.CrouchPos = Vector(-4.2, -3, 0.7)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -5, 1)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.532, -5, 1)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(5.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 28

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["7rnd"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
    ["9rnd"] = {
        VMBodygroups = {{ind = 5, bg = 2}},
        WMBodygroups = {{ind = 3, bg = 2}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["choke"] = {
        VMBodygroups = {{ind = 4, bg = 2}},
        WMBodygroups = {{ind = 2, bg = 2}},
    },
    ["incendiary"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 4, bg = 2}},
    },
    ["slug"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 4, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = "fas2_sight",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(3.85, -1.105, 0.01),
            vang = Angle(0, 0, 270),
            wpos = Vector(10.65, 0.79, -5.92),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(0.9, 0.9, 0.9),
        WMScale = Vector(1.4, 1.4, 1.4),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_choke"}
    },
    {
        PrintName = "Tube",
        DefaultAttName = "M3S90 5rnd Tube",
        Slot = "fas2_m3s90_tube",
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "12 Gauge",
        Slot = "fas2_ammo_shotgun",
    },
}

SWEP.Bandolier = 6

SWEP.Hook_TranslateAnimation = function(wep, anim)
    local mag = wep:Clip1()
    local iron = (wep:GetState() == ArcCW.STATE_SIGHTS and "_iron") or ""
    local band = wep:GetNWInt("Bando", -1)

    if band <= 5 and mag >= 0 then
        anim = "last" .. math.Clamp(band, 0, 6) .. "_" .. anim
	end

    return anim
end

-- SWEP.Hook_SelectFireAnimation = function(wep, anim)
--     local mag = wep:Clip1()
--     local iron = (wep:GetState() == ArcCW.STATE_SIGHTS and "_iron") or ""
--     local band = wep:GetNWInt("Bando", -1)

--     if band <= 5 and mag >= 0 then
--         anim = "last" .. math.Clamp(band, 0, 6) .. "_" .. anim .. iron
-- 	end

--     -- print(anim)

--     return anim
-- end

SWEP.Hook_SelectInsertAnimation = function(wep, anim)
    local num = math.min(wep.Primary.ClipSize + wep:GetChamberSize() - wep:Clip1(), wep:GetOwner():GetAmmoCount(wep.Primary.Ammo), 4)
    local anim = "sgreload_insert" .. num

    return {count = num, anim = anim, empty = false}
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 0/20,
    },
    ["idle_empty"] = {
        Source = "idle_empty",
        Time = 0/20,
    },
    ["draw"] = {
        Source = "deploy",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_empty"] = {
        Source = "deploy_empty",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3"},
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "fire_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["fire_dry"] = {
        Source = "fire_dry",
        Time = 35/20,
    },
    ["fire_dry_iron"] = {
        Source = "fire_dry",
        Time = 35/20,
    },
    ["sgreload_start"] = {
        Source = "reload_start",
        Time = 20/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
    },
    ["sgreload_start_empty"] = {
        Source = "reload_start_empty",
        Time = 60/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 0.8},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.2},
        },
    },
    ["sgreload_insert"] = {
        Source = "reload_load1",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Load", t = 0.3},
        },
    },
    ["sgreload_insert1"] = {
        Source = "reload_load1",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Load", t = 0.3},
        },
    },
    ["sgreload_insert2"] = {
        Source = "reload_load2",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Load", t = 0.47},
        {s = "Firearms2.M3S90_Load", t = 0.84},
        },
    },
    ["sgreload_insert3"] = {
        Source = "reload_load3",
        Time = 50/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Load", t = 0.37},
        {s = "Firearms2.M3S90_Load", t = 0.74},
        {s = "Firearms2.M3S90_Load", t = 1.13},
        },
    },
    ["sgreload_insert4"] = {
        Source = "reload_load4",
        Time = 50/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Load", t = 0.27},
        {s = "Firearms2.M3S90_Load", t = 0.54},
        {s = "Firearms2.M3S90_Load", t = 0.87},
        {s = "Firearms2.M3S90_Load", t = 1.27},
        },
    },
    ["sgreload_finish"] = {
        Source = "reload_abort",
        Time = 20/30,
    },
    ["last0_idle"] = {
        Source = "last0_idle",
        Time = 0/20,
    },
    ["last0_idle_empty"] = {
        Source = "last0_idle_empty",
        Time = 0/20,
    },
    ["last0_draw"] = {
        Source = "last0_deploy",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last0_draw_empty"] = {
        Source = "last0_deploy_empty",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last0_holster"] = {
        Source = "last0_holster",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last0_holster_empty"] = {
        Source = "last0_holster_empty",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last0_fire"] = {
        Source = "last0_fire1",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last0_fire_empty"] = {
        Source = "last0_fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last0_fire_iron"] = {
        Source = "last0_fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last0_fire_iron_empty"] = {
        Source = "last0_fire1_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last0_fire_dry"] = {
        Source = "last0_fire_dry",
        Time = 35/20,
    },
    ["last0_fire_dry_iron"] = {
        Source = "last0_fire_dry",
        Time = 35/20,
    },
    ["last0_restock"] = {
        Source = "last0_restock",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        {s = "Firearms2.M3S90_Restock", t = 1.33},
        },
    },
    ["last0_restock_empty"] = {
        Source = "last0_restock_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        {s = "Firearms2.M3S90_Restock", t = 1.33},
        },
    },
    ["last1_idle"] = {
        Source = "last1_idle",
        Time = 0/20,
    },
    ["last1_idle_empty"] = {
        Source = "last1_idle_empty",
        Time = 0/20,
    },
    ["last1_draw"] = {
        Source = "last1_deploy",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last1_draw_empty"] = {
        Source = "last1_deploy_empty",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last1_holster"] = {
        Source = "last1_holster",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last1_holster_empty"] = {
        Source = "last1_holster_empty",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last1_fire"] = {
        Source = "last1_fire1",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last1_fire_empty"] = {
        Source = "last1_fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last1_fire_iron"] = {
        Source = "last1_fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last1_fire_iron_empty"] = {
        Source = "last1_fire1_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last1_fire_dry"] = {
        Source = "last1_fire_dry",
        Time = 35/20,
    },
    ["last1_fire_dry_iron"] = {
        Source = "last1_fire_dry",
        Time = 35/20,
    },
    ["last1_restock"] = {
        Source = "last1_restock",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        {s = "Firearms2.M3S90_Restock", t = 1.33},
        },
    },
    ["last1_restock_empty"] = {
        Source = "last1_restock_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        {s = "Firearms2.M3S90_Restock", t = 1.33},
        },
    },
    ["last1_reload_start"] = {
        Source = "last1_reload_start",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.5},
        {s = "Firearms2.M3S90_Load", t = 0.9},
        },
    },
    ["last1_reload_start_empty"] = {
        Source = "last1_reload_start_empty",
        Time = 65/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.5},
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 1.06},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.43},
        },
    },
    ["last1_reload_start_end"] = {
        Source = "last1_reload_start_end",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.5},
        {s = "Firearms2.M3S90_Load", t = 0.9},
        },
    },
    ["last1_reload_end"] = {
        Source = "last1_reload_end",
        Time = 30/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.4},
        },
    },
    ["last2_idle"] = {
        Source = "last2_idle",
        Time = 0/20,
    },
    ["last2_idle_empty"] = {
        Source = "last2_idle_empty",
        Time = 0/20,
    },
    ["last2_draw"] = {
        Source = "last2_deploy",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last2_draw_empty"] = {
        Source = "last2_deploy_empty",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last2_holster"] = {
        Source = "last2_holster",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last2_holster_empty"] = {
        Source = "last2_holster_empty",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last2_fire"] = {
        Source = "last2_fire1",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last2_fire_empty"] = {
        Source = "last2_fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last2_fire_iron"] = {
        Source = "last2_fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last2_fire_iron_empty"] = {
        Source = "last2_fire1_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last2_fire_dry"] = {
        Source = "last2_fire_dry",
        Time = 35/20,
    },
    ["last2_fire_dry_iron"] = {
        Source = "last2_fire_dry",
        Time = 35/20,
    },
    ["last2_restock"] = {
        Source = "last2_restock",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last2_restock_empty"] = {
        Source = "last2_restock_empty",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last2_reload_start"] = {
        Source = "last2_reload_start",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last2_reload_start_empty"] = {
        Source = "last2_reload_start_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.53},
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 1.06},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.43},
        },
    },
    ["last2_reload_start_end"] = {
        Source = "last2_reload_start_end",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last2_reload_insert"] = {
        Source = "last2_reload_insert",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last2_reload_end"] = {
        Source = "last2_reload_end",
        Time = 30/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last3_idle"] = {
        Source = "last3_idle",
        Time = 0/20,
    },
    ["last3_idle_empty"] = {
        Source = "last3_idle_empty",
        Time = 0/20,
    },
    ["last3_draw"] = {
        Source = "last3_deploy",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last3_draw_empty"] = {
        Source = "last3_deploy_empty",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last3_holster"] = {
        Source = "last3_holster",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last3_holster_empty"] = {
        Source = "last3_holster_empty",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last3_fire"] = {
        Source = "last3_fire1",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last3_fire_empty"] = {
        Source = "last3_fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last3_fire_iron"] = {
        Source = "last3_fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last3_fire_iron_empty"] = {
        Source = "last3_fire1_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last3_fire_dry"] = {
        Source = "last3_fire_dry",
        Time = 35/20,
    },
    ["last3_fire_dry_iron"] = {
        Source = "last3_fire_dry",
        Time = 35/20,
    },
    ["last3_restock"] = {
        Source = "last3_restock",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last3_restock_empty"] = {
        Source = "last3_restock_empty",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last3_reload_start"] = {
        Source = "last3_reload_start",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last3_reload_start_empty"] = {
        Source = "last3_reload_start_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.53},
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 1.06},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.43},
        },
    },
    ["last3_reload_start_end"] = {
        Source = "last3_reload_start_end",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.5},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last3_reload_insert"] = {
        Source = "last3_reload_insert",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last3_reload_end"] = {
        Source = "last3_reload_end",
        Time = 30/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last4_idle"] = {
        Source = "last4_idle",
        Time = 0/20,
    },
    ["last4_idle_empty"] = {
        Source = "last4_idle_empty",
        Time = 0/20,
    },
    ["last4_draw"] = {
        Source = "last4_deploy",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last4_draw_empty"] = {
        Source = "last4_deploy_empty",
        Time = 20/40,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last4_holster"] = {
        Source = "last4_holster",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last4_holster_empty"] = {
        Source = "last4_holster_empty",
        Time = 20/60,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last4_fire"] = {
        Source = "last4_fire1",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last4_fire_empty"] = {
        Source = "last4_fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last4_fire_iron"] = {
        Source = "last4_fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last4_fire_iron_empty"] = {
        Source = "last4_fire1_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last4_fire_dry"] = {
        Source = "last4_fire_dry",
        Time = 35/20,
    },
    ["last4_fire_dry_iron"] = {
        Source = "last4_fire_dry",
        Time = 35/20,
    },
    ["last4_restock"] = {
        Source = "last4_restock",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last4_restock_empty"] = {
        Source = "last4_restock_empty",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last4_reload_start"] = {
        Source = "last4_reload_start",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last4_reload_start_empty"] = {
        Source = "last4_reload_start_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.53},
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 1.06},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.43},
        },
    },
    ["last4_reload_start_end"] = {
        Source = "last4_reload_start_end",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last4_reload_insert"] = {
        Source = "last4_reload_insert",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last4_reload_end"] = {
        Source = "last4_reload_end",
        Time = 30/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last5_idle"] = {
        Source = "last5_idle",
        Time = 0/20,
    },
    ["last5_idle_empty"] = {
        Source = "last5_idle_empty",
        Time = 0/20,
    },
    ["last5_draw"] = {
        Source = "last5_deploy",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last5_draw_empty"] = {
        Source = "last5_deploy_empty",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["last5_holster"] = {
        Source = "last5_holster",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last5_holster_empty"] = {
        Source = "last5_holster_empty",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["last5_fire"] = {
        Source = "last5_fire1",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last5_fire_empty"] = {
        Source = "last5_fire_last",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last5_fire_iron"] = {
        Source = "last5_fire1_scoped",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last5_fire_iron_empty"] = {
        Source = "last5_fire1_last_iron",
        Time = 30/35,
        ShellEjectAt = 0,
    },
    ["last5_fire_dry"] = {
        Source = "last5_fire_dry",
        Time = 35/20,
    },
    ["last5_fire_dry_iron"] = {
        Source = "last5_fire_dry",
        Time = 35/20,
    },
    ["last5_restock"] = {
        Source = "last5_restock",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last5_restock_empty"] = {
        Source = "last5_restock_empty",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_Restock", t = 0.6},
        },
    },
    ["last5_reload_start"] = {
        Source = "last5_reload_start",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.5},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last5_reload_start_empty"] = {
        Source = "last5_reload_start_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.53},
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 1.06},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.43},
        },
    },
    ["last5_reload_start_end"] = {
        Source = "last5_reload_start_end",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.5},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last5_reload_insert"] = {
        Source = "last5_reload_insert",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last5_reload_end"] = {
        Source = "last5_reload_end",
        Time = 30/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last6_reload_start"] = {
        Source = "last6_reload_start",
        Time = 40/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last6_reload_start_empty"] = {
        Source = "last6_reload_start_empty",
        Time = 60/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.53},
        {s = "Firearms2.M3S90_LoadEjectorPort", t = 1.06},
        {s = "Firearms2.M3S90_Boltcatch", t = 1.43},
        },
    },
    ["last6_reload_start_end"] = {
        Source = "last6_reload_start_end",
        Time = 45/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.6},
        {s = "Firearms2.M3S90_Load", t = 0.86},
        },
    },
    ["last6_reload_insert"] = {
        Source = "last6_reload_insert",
        Time = 25/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
    ["last6_reload_end"] = {
        Source = "last6_reload_end",
        Time = 30/30,
        SoundTable = {
        {s = "Firearms2.M3S90_GetAmmo", t = 0.03},
        {s = "Firearms2.M3S90_Load", t = 0.36},
        },
    },
}

SWEP.ReloadState = 0
SWEP.ReloadStateWait = 0

SWEP.Hook_Think = function(wep, anim)
    if wep.ShotgunThink then
		wep:ShotgunThink()
	end
end

function SWEP:InsertAmmoFromBandolier()
    if SERVER then
        local band = self:GetNWInt("Bando", -1)
        self:SetNWInt("Bando", band - 1)
        self:SetClip1(self:Clip1() + 1)
    end
end

function SWEP:Reload()
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    if self:GetOwner():IsNPC() then
        return
    end

    if self:GetState() == ArcCW.STATE_CUSTOMIZE then
        return
    end

    if self:GetState() == ArcCW.STATE_SIGHTS then
        return
    end

    if self:GetNextPrimaryFire() >= CurTime() then return end
    -- if !game.SinglePlayer() and !IsFirstTimePredicted() then return end


    if self.Throwing then return end
    if self.PrimaryBash then return end

    -- with the lite 3D HUD, you may want to check your ammo without reloading
    local Lite3DHUD = self:GetOwner():GetInfo("arccw_hud_3dfun") == "1"
    if self:GetOwner():KeyDown(IN_WALK) and Lite3DHUD then
        return
    end

    if self:GetMalfunctionJam() then
        local r = self:MalfunctionClear()
        if r then return end
    end

    if self:HasBottomlessClip() then return end

    if self:GetBuff_Hook("Hook_PreReload") then return end

	ammo = self.Owner:GetAmmoCount(self.Primary.Ammo)

    mag = self:Clip1()

    band = self:GetNWInt("Bando", -1)
	
	if band == 0 and ammo >= 6 then
		amt = math.Clamp(6, 0, ammo)
		
		if mag == 0 then
            self:PlayAnimation("last" .. band .. "_restock_empty", 1, true, 0, true)
		else
            self:PlayAnimation("last" .. band .. "_restock", 1, true, 0, true)
		end
		
		self.Owner:RemoveAmmo(amt, self.Primary.Ammo)
        self:SetNWInt("Bando", 	amt)
		self:SetNextPrimaryFire(CurTime() + 2)
		self:SetNextSecondaryFire(CurTime() + 2)		
		return
	end

    local mult = self:GetBuff_Mult("Mult_ReloadTime")

    local anim = self:SelectReloadAnimation()

    local reloadtime2 = self:GetAnimKeyTime(anim, false) * mult
    -- local reloadtime2 = self:GetAnimKeyTime(anim, false) * mult
	
	if band < 6 and ammo >= 6 - band then
		amt = math.Clamp(6 - band, 0, ammo)
			
		if mag == 0 then
            self:PlayAnimation("last" .. band .. "_restock_empty", 1, true, 0, true)
		else
            self:PlayAnimation("last" .. band .. "_restock", 1, true, 0, true)
		end
		
		self:SetNextPrimaryFire(CurTime() + reloadtime2)
		self:SetNextSecondaryFire(CurTime() + reloadtime2)
		self.Owner:RemoveAmmo(amt, self.Primary.Ammo)
        self:SetNWInt("Bando", band + amt)
		
		return
	end

    self:ReloadStartLogic()
end

function SWEP:ReloadStartLogic()
	mag = self:Clip1()
	ammo = self.Owner:GetAmmoCount(self.Primary.Ammo)
    band = self:GetNWInt("Bando", -1)

    if ammo == 0 then
        if mag < self.Primary.ClipSize then
            if band > 0 then
                CT = CurTime()

                if band == 1 then
                    self:PlayAnimation("last1_reload_start_end", 1, true, 0, true)
                    self.ReloadStateWait = CT + 1.75
                
                    self:InsertAmmoFromBandolier()
                    self.Owner:SetAnimation(PLAYER_RELOAD)
                    self.ReloadState = 0
                else
                    if mag == 0 then
                        self:PlayAnimation("last" .. band .. "_reload_start_empty", 1, true, 0, true)
                        self.ReloadStateWait = CT + 1.75
                    
                        self:InsertAmmoFromBandolier()
                        self.Owner:SetAnimation(PLAYER_RELOAD)
                        self.ReloadState = 2
                    else
                        if mag == self.Primary.ClipSize - 1 then
                            self:PlayAnimation("last" .. band .. "_reload_start_end", 1, true, 0, true)
                                
                            self:InsertAmmoFromBandolier()
                            self.ReloadState = 0
                        else	
                            self:PlayAnimation("last" .. band .. "_reload_start", 1, true, 0, true)
                            self:InsertAmmoFromBandolier()
                            self.ReloadStateWait = CT + 1.1
                            self.ReloadState = 2
                        end
                    end
                end
            end
        end
    else
        local dumpclip = self:GetBuff_Hook("Hook_ReloadDumpClip")
        if dumpclip and !self:HasInfiniteAmmo() and self:Clip1() >= self:Ammo1() then
            return
        end

        self.LastClip1 = self:Clip1()

        local reserve = self:Ammo1()

        reserve = reserve + self:Clip1()
        if self:HasInfiniteAmmo() then reserve = self:GetCapacity() + self:Clip1() end

        local clip = self:GetCapacity()

        local chamber = math.Clamp(self:Clip1(), 0, self:GetChamberSize())
        if self:GetNeedCycle() then chamber = 0 end

        local load = math.Clamp(clip + chamber, 0, reserve)

        if !self:GetMalfunctionJam() and load <= self:Clip1() then return end

        self:SetBurstCount(0)

        local shouldshotgunreload = self:GetBuff_Override("Override_ShotgunReload")
        local shouldhybridreload = self:GetBuff_Override("Override_HybridReload")

        if shouldshotgunreload == nil then shouldshotgunreload = self.ShotgunReload end
        if shouldhybridreload == nil then shouldhybridreload = self.HybridReload end

        if shouldhybridreload then
            shouldshotgunreload = self:Clip1() != 0
        end

        if shouldshotgunreload and self:GetShotgunReloading() > 0 then return end

        local mult = self:GetBuff_Mult("Mult_ReloadTime")

        if shouldshotgunreload then
            local anim = "sgreload_start"
            local insertcount = 0

            local empty = self:Clip1() == 0 --or self:GetNeedCycle()

            if self.Animations.sgreload_start_empty and empty then
                anim = "sgreload_start_empty"
                empty = false
                if (self.Animations.sgreload_start_empty or {}).ForceEmpty == true then
                    empty = true
                end

                insertcount = (self.Animations.sgreload_start_empty or {}).RestoreAmmo or 1
            else
                insertcount = (self.Animations.sgreload_start or {}).RestoreAmmo or 0
            end

            anim = self:GetBuff_Hook("Hook_SelectReloadAnimation", anim) or anim

            local time = self:GetAnimKeyTime(anim)
            local time2 = self:GetAnimKeyTime(anim, true)

            if time2 >= time then
                time2 = 0
            end

            if insertcount > 0 then
                self:SetMagUpCount(insertcount)
                self:SetMagUpIn(CurTime() + time2 * mult)
            end
            self:PlayAnimation(anim, mult, true, 0, true, nil, true)

            self:SetReloading(CurTime() + time * mult)

            self:SetShotgunReloading(empty and 4 or 2)
        else
            local anim = self:SelectReloadAnimation()

            if !self.Animations[anim] then print("Invalid animation \"" .. anim .. "\"") return end

            self:PlayAnimation(anim, mult, true, 0, false, nil, true)

            local reloadtime = self:GetAnimKeyTime(anim, true) * mult
            local reloadtime2 = self:GetAnimKeyTime(anim, false) * mult

            self:SetNextPrimaryFire(CurTime() + reloadtime2)
            self:SetReloading(CurTime() + reloadtime2)

            self:SetMagUpCount(0)
            self:SetMagUpIn(CurTime() + reloadtime)
        end

        self:SetClipInfo(load)
        if game.SinglePlayer() then
            self:CallOnClient("SetClipInfo", tostring(load))
        end

        for i, k in pairs(self.Attachments) do
            if !k.Installed then continue end
            local atttbl = ArcCW.AttachmentTable[k.Installed]

            if atttbl.DamageOnReload then
                self:DamageAttachment(i, atttbl.DamageOnReload)
            end
        end

        self:GetBuff_Hook("Hook_PostReload")
    end
end

local amt

function SWEP:ShotgunThink()
    CT = CurTime()
    band = self:GetNWInt("Bando", -1)

    if CT > self.ReloadStateWait then
        ammo = self.Owner:GetAmmoCount(self.Primary.Ammo)
        if self.ReloadState == 2 then
            mag = self:Clip1()
            
            if band > 1 then
                if mag < self.Primary.ClipSize - 1 then
                    self:PlayAnimation("last" .. band .. "_reload_insert", 1, true, 0, true)
                    self.ReloadStateWait = CT + 0.6
                    self:InsertAmmoFromBandolier()
                else
                    self.ReloadState = 3
                end
            else
                self.ReloadState = 3
            end
        elseif self.ReloadState == 3 then
            self:PlayAnimation("last" .. band .. "_reload_end", 1, true, 0, true)
            self.ReloadStateWait = CT + 1
            self:InsertAmmoFromBandolier()
            self.ReloadState = 0
        elseif self.ReloadState == 4 then
            self:PlayAnimation("sgreload_start", 1, true, 0, true)
            self.ReloadStateWait = CT + 0.6
            
            self.ReloadState = 2
        end
    end
end

SWEP.Hook_DrawHUD = function(wep, anim)
    FT, CT, x, y = FrameTime(), CurTime(), ScrW(), ScrH()
    x2, y2 = math.Round(x * 0.5), math.Round(y * 0.5)

    ammo = wep:Ammo1()
    mag = wep:Clip1()
    band = wep:GetNWInt("Bando", -1)
        
    if band >= 1 and ammo == 0 and mag < wep.Primary.ClipSize then
        draw.ShadowText("RELOAD KEY - LOAD FROM BANDOLIER", "ARCCW_FAS2", x / 2, y / 2 + 200, Color(255, 255, 255, wep.CrossAlpha), Color(0, 0, 0, wep.CrossAlpha), 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end





--Tryna avoid bandolier bug

function SWEP:Attach(slot, attname, silent, noadjust)
    silent = silent or false
    local attslot = self.Attachments[slot]
    if !attslot then return end
    if attslot.Installed == attname then return end
    if attslot.Internal then return end

    -- Make an additional check to see if we can detach the current attachment
    if attslot.Installed and !ArcCW:PlayerCanAttach(self:GetOwner(), self, attslot.Installed, slot, attname) then
        if CLIENT and !silent then
            surface.PlaySound("items/medshotno1.wav")
        end
        return
    end

    if !ArcCW:PlayerCanAttach(self:GetOwner(), self, attname, slot, false) then
        if CLIENT and !silent then
            surface.PlaySound("items/medshotno1.wav")
        end
        return
    end

    local pick = self:GetPickX()

    if pick > 0 and self:CountAttachments() >= pick and !attslot.FreeSlot
            and !attslot.Installed then
        if CLIENT and !silent then
            surface.PlaySound("items/medshotno1.wav")
        end
        return
    end

    local atttbl = ArcCW.AttachmentTable[attname]

    if !atttbl then return end
    if !ArcCW:SlotAcceptsAtt(attslot.Slot, self, attname) then return end
    if !self:CheckFlags(atttbl.ExcludeFlags, atttbl.RequireFlags) then return end
    if !self:PlayerOwnsAtt(attname) then return end

    local max = atttbl.Max

    if max then
        local amt = 0

        for i, k in pairs(self.Attachments) do
            if k.Installed == attname then amt = amt + 1 end
        end

        if amt >= max then return end
    end

    if attslot.SlideAmount then
        attslot.SlidePos = 0.5
    end

    if atttbl.MountPositionOverride then
        attslot.SlidePos = atttbl.MountPositionOverride
    end

    if atttbl.AdditionalSights then
        self.SightMagnifications = {}
    end

    if atttbl.ToggleStats then
        attslot.ToggleNum = 1
    end

    attslot.ToggleLock = atttbl.ToggleLockDefault or false

    if CLIENT then
        -- we are asking to attach something

        self:SendAllDetails()

        net.Start("arccw_asktoattach")
        net.WriteUInt(slot, 8)
        net.WriteUInt(atttbl.ID, 24)
        net.SendToServer()

        if !silent then
            surface.PlaySound(atttbl.AttachSound or "weapons/arccw/install.wav")
        end
    else
        self:DetachAllMergeSlots(slot)

        for i, k in pairs(self.Attachments) do
            if table.HasValue(k.MergeSlots or {}, slot) then
                self:DetachAllMergeSlots(i)
            end
        end
    end

    attslot.Installed = attname

    if slot == 4 and self.Attachments[4].Installed then
        local band = self:GetNWInt("Bando", -1)

        if SERVER then
            self:GetOwner():GiveAmmo(band, self:GetPrimaryAmmoType(), true)
            self:SetNWInt("Bando", 0)
        end
    end

    if atttbl.Health then
        attslot.HP = self:GetAttachmentMaxHP(slot)
    end

    if atttbl.ColorOptionsTable then
        attslot.ColorOptionIndex = 1
    end

    ArcCW:PlayerTakeAtt(self:GetOwner(), attname)

    --[[]
    local fmt = self:GetBuff_Override("Override_Firemodes") or self.Firemodes
    local fmi = self:GetFireMode()

    if fmi > table.Count(fmt) then
        self:SetFireMode(1)
    end
    ]]

    --self.UnReady = false

    if SERVER then
        self:NetworkWeapon()
        self:SetupModel(false)
        self:SetupModel(true)
        ArcCW:PlayerSendAttInv(self:GetOwner())

        if engine.ActiveGamemode() == "terrortown" then
            self:TTT_PostAttachments()
        end
    else
        self:SetupActiveSights()

        self.LHIKAnimation = 0
        self.LHIKAnimationStart = 0
        self.LHIKAnimationTime = 0

        self.LHIKDelta = {}
        self.LHIKDeltaAng = {}

        self.ViewModel_Hit = Vector(0, 0, 0)

        if !silent then
            self:SavePreset("autosave")
        end
    end

    for s, i in pairs(self.Attachments) do
        if !self:CheckFlags(i.ExcludeFlags, i.RequireFlags) then
            self:Detach(s, true, true)
        end
    end

    if !noadjust then
        self:AdjustAtts()
    end

    if atttbl.UBGL then
        local ubgl_ammo = self:GetBuff_Override("UBGL_Ammo")
        local ubgl_clip = self:GetBuff_Override("UBGL_Capacity")
        if self:GetOwner():IsPlayer() and GetConVar("arccw_atts_ubglautoload"):GetBool() and ubgl_ammo then
            local amt = math.min(ubgl_clip - self:Clip2(), self:GetOwner():GetAmmoCount(ubgl_ammo))
            self:SetClip2(self:Clip2() + amt)
            self:GetOwner():RemoveAmmo(amt, ubgl_ammo)
        end
    end

    self:RefreshBGs()
    return true
end

function SWEP:Detach(slot, silent, noadjust, nocheck)
    if !slot then return end
    if !self.Attachments[slot] then return end

    if !self.Attachments[slot].Installed then return end

    if self.Attachments[slot].Internal then return end

    if !nocheck and !ArcCW:PlayerCanAttach(self:GetOwner(), self, self.Attachments[slot].Installed, slot, true) then
        if CLIENT and !silent then
            surface.PlaySound("items/medshotno1.wav")
        end
        return
    end

    if self.Attachments[slot].Installed == self.Attachments[slot].EmptyFallback then
        return
    end

    local previnstall = self.Attachments[slot].Installed

    local atttbl = ArcCW.AttachmentTable[previnstall]
    

    if atttbl.UBGL then
        local clip = self:Clip2()

        local ammo = atttbl.UBGL_Ammo or "smg1_grenade"

        if SERVER then
            self:GetOwner():GiveAmmo(clip, ammo, true)
        end

        self:SetClip2(0)

        self:DeselectUBGL()
    end

    if self.Attachments[slot].EmptyFallback then -- is this a good name
        self.Attachments[slot].Installed = self.Attachments[slot].EmptyFallback
    else
        self.Attachments[slot].Installed = nil
    end

    if self.Attachments[slot].SubAtts then
        for i, k in pairs(self.Attachments[slot].SubAtts) do
            self:Detach(k, true, true)
        end
    end

    if self:GetAttachmentHP(slot) >= self:GetAttachmentMaxHP(slot) then
        ArcCW:PlayerGiveAtt(self:GetOwner(), previnstall)
    end

    if CLIENT then
        self:SendAllDetails()

        -- we are asking to detach something
        net.Start("arccw_asktodetach")
        net.WriteUInt(slot, 8)
        net.SendToServer()

        if !silent then
            surface.PlaySound(atttbl.DetachSound or "weapons/arccw/uninstall.wav")
        end

        self:SetupActiveSights()

        self.LHIKAnimation = 0
        self.LHIKAnimationStart = 0
        self.LHIKAnimationTime = 0

        if !silent then
            self:SavePreset("autosave")
        end
    else
        self:NetworkWeapon()
        self:SetupModel(false)
        self:SetupModel(true)
        ArcCW:PlayerSendAttInv(self:GetOwner())

        if engine.ActiveGamemode() == "terrortown" then
            self:TTT_PostAttachments()
        end
    end

    -- if self.Attachments[4].Installed or !self.Attachments[4].Installed then
    if slot == 4 then 
        if self.Attachments[4].Installed or !self.Attachments[4].Installed then
            local band = self:GetNWInt("Bando", -1)

            if SERVER then
                self:GetOwner():GiveAmmo(band, self:GetPrimaryAmmoType(), true)
                self:SetNWInt("Bando", 0)
            end
        end
    end

    self:RefreshBGs()

    if !noadjust then
        self:AdjustAtts()
    end
    return true
end

function SWEP:Initialize()
    if (!IsValid(self:GetOwner()) or self:GetOwner():IsNPC()) and self:IsValid() and self.NPC_Initialize and SERVER then
        self:NPC_Initialize()
    end

    if game.SinglePlayer() and self:GetOwner():IsValid() and SERVER then
        self:CallOnClient("Initialize")
    end

    self:SetNWInt("Bando", 6) 

    if CLIENT then
        local class = self:GetClass()

        if self.KillIconAlias then
            killicon.AddAlias(class, self.KillIconAlias)
            class = self.KillIconAlias
        end

        local path = "arccw/weaponicons/" .. class
        local mat = Material(path)

        if !mat:IsError() then

            local tex = mat:GetTexture("$basetexture")
            if tex then
                local texpath = tex:GetName()
                killicon.Add(class, texpath, Color(255, 255, 255))
                self.WepSelectIcon = surface.GetTextureID(texpath)

                if self.ShootEntity then
                killicon.Add(self.ShootEntity, texpath, Color(255, 255, 255))
                end
            end
        end

        -- Check for incompatibile addons once 
        if LocalPlayer().ArcCW_IncompatibilityCheck != true and game.SinglePlayer() then
            LocalPlayer().ArcCW_IncompatibilityCheck = true

            local incompatList = {}
            local addons = engine.GetAddons()
            for _, addon in pairs(addons) do
                if ArcCW.IncompatibleAddons[tostring(addon.wsid)] and addon.mounted then
                    incompatList[tostring(addon.wsid)] = addon
                end
            end

            local predrawvmhooks = hook.GetTable().PreDrawViewModel
            if predrawvmhooks and (predrawvmhooks.DisplayDistancePlaneLS or predrawvmhooks.DisplayDistancePlane) then -- vtools lua breaks arccw with stupid return in vm hook, ya dont need it if you going to play with guns
                hook.Remove("PreDrawViewModel", "DisplayDistancePlane")
                hook.Remove("PreDrawViewModel", "DisplayDistancePlaneLS")
                incompatList["DisplayDistancePlane"] = {
                    title = "Light Sprayer / Scenic Dispenser tool",
                    wsid = "DisplayDistancePlane",
                    nourl = true,
                }
            end
            local shouldDo = true
            -- If never show again is on, verify we have no new addons
            if file.Exists("arccw_incompatible.txt", "DATA") then
                shouldDo = false
                local oldTbl = util.JSONToTable(file.Read("arccw_incompatible.txt"))
                for id, addon in pairs(incompatList) do
                    if !oldTbl[id] then shouldDo = true break end
                end
                if shouldDo then file.Delete("arccw_incompatible.txt") end
            end
            if shouldDo and !table.IsEmpty(incompatList) then
                ArcCW.MakeIncompatibleWindow(incompatList)
            elseif !table.IsEmpty(incompatList) then
                print("ArcCW ignored " .. table.Count(incompatList) .. " incompatible addons. If things break, it's your fault.")
            end
        end
    end

    if GetConVar("arccw_equipmentsingleton"):GetBool() and self.Throwing then
        self.Singleton = true
        self.Primary.ClipSize = -1
        self.Primary.Ammo = ""
    end

    self:SetState(0)
    self:SetClip2(0)
    self:SetLastLoad(self:Clip1())

    self.Attachments["BaseClass"] = nil

    if !self:GetOwner():IsNPC() then
        self:SetHoldType(self.HoldtypeActive)
    end

    local og = weapons.Get(self:GetClass())

    self.RegularClipSize = og.Primary.ClipSize

    self.OldPrintName = self.PrintName

    self:InitTimers()

    if engine.ActiveGamemode() == "terrortown" then
        self:TTT_Init()
    end

    hook.Run("ArcCW_WeaponInit", self)

    self:AdjustAtts()
end