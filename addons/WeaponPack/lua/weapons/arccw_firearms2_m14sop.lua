include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 3

SWEP.ItemData = {
    width = 3,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 5 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.75, 271, 0),
        fov = 11.5
    }
}

SWEP.PrintName = "M14 SOPMOD"
SWEP.Trivia_Class = "Battle rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Springfield Armory"
SWEP.Trivia_Calibre = "7.62x51mm"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1959"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/m14sop.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/m14sop.mdl"
SWEP.ViewModelFOV = 55

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 44
SWEP.DamageMin = 21 -- damage done at maximum range
SWEP.Range = 900 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 850 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.

SWEP.Recoil = 2
SWEP.RecoilSide = 0.1

SWEP.RecoilRise = 0.05
SWEP.RecoilPunch = 0.75
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.135 -- 60 / RPM.
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
SWEP.HipDispersion = 380 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "7.62x51mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_M14SOP"
SWEP.ShootDrySound = "fas2/empty_battlerifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/m14.ogg"
SWEP.ShootSoundSilenced = "Firearms2_M14SOP_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MeleeHitSound = "fas2/melee/knife_hitworld1.wav"

SWEP.MuzzleEffect = "muzzleflash_4"

SWEP.ShellModel = "models/shells/7_62x51mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-2.5635, -5.354, 1.363),
    Ang = Angle(0, 0.01, 0),
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

SWEP.CrouchPos = Vector(-4.5, -3, 0.3)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(4.532, -3.5, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4.532, -3.5, 0)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 32

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
    ["20rnd"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["grip"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
    ["m14sop_stock"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
        WMBodygroups = {{ind = 4, bg = 1}},
    },
}


SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope", "fas2_leupold2_scope"},
        -- Slot = {"fas2_sight", "fas2_scope", "fas2_leupold_scope"},
        Bone = "Dummy01", 
        Offset = {
            vpos = Vector(4, -1.95, 0),
            vang = Angle(0, 0, 270),
            wpos = Vector(11, 0.8, -6.65),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(1.3, 1.3, 1.3),
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0.002, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Canted Sight",
        Slot = "fas2_cantedsight",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(9, -1.95, 0),
            vang = Angle(0, 0, 270),
            wpos = Vector(12.8, 0.75, -6.32),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(1.3, 1.3, 1.3),
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(10, -1.0, -0.6),
            vang = Angle(0, 0, 180),
            wpos = Vector(16.5, -0.05, -6.25),
            wang = Angle(-10.393, 0, 270),
        },
        VMScale = Vector(1.3, 1.3, 1.3),
        WMScale = Vector(1.6, 1.6, 1.6),
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "M14/M21 10rnd Mag",
        Slot = "fas2_m21_20rnd",
    },
    {
        PrintName = "Stock",
        DefaultAttName = "M14 SOPMOD Folded Stock",
        Slot = {"fas2_m14sop_stock"},
        FreeSlot = true
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "7.62x51MM",
        Slot = "fas2_ammo_762x51mmap",
    },
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local grip = wep.Attachments[5].Installed and "_grip" or ""

	return anim .. grip
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle1",
        Time = 0/1,
    },
    ["idle_empty"] = {
        Source = "idle1_empty",
        Time = 0/1,
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
        Source = "shoot",
        Time = 60/60,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "shoot_last",
        Time = 60/60,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot_scoped",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "shoot_last_scoped",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload2",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M14_Magout", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.3},
		{s = "Firearms2.M14_Magin", t = 2},
		{s = "Firearms2.Cloth_Movement", t = 2}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty2",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M14_MagoutEmpty", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.34},
		{s = "Firearms2.M14_Magin", t = 1.95},
		{s = "Firearms2.Cloth_Movement", t = 1.95},
		{s = "Firearms2.M14_BoltRelease", t = 3.15},
		{s = "Firearms2.Cloth_Movement", t = 3.15},
		},
    },
    ["idle_grip"] = {
        Source = "idle1_grip",
        Time = 0/1,
    },
    ["idle_empty_grip"] = {
        Source = "idle1_empty_grip",
        Time = 0/1,
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_empty_grip"] = {
        Source = "deploy_empty_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty_grip"] = {
        Source = "holster_empty_grip",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire_grip"] = {
        Source = "shoot_grip",
        Time = 60/60,
        ShellEjectAt = 0,
    },
    ["fire_empty_grip"] = {
        Source = "shoot_grip_last",
        Time = 60/60,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "shoot_grip_scoped",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty_grip"] = {
        Source = "shoot_grip_last_scoped",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["reload_grip"] = {
        Source = "reload2_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M14_Magout", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.3},
		{s = "Firearms2.M14_Magin", t = 1.9},
		{s = "Firearms2.Cloth_Movement", t = 1.9}
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty2_grip",
        Time = 120/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M14_MagoutEmpty", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.34},
		{s = "Firearms2.M14_Magin", t = 1.95},
		{s = "Firearms2.Cloth_Movement", t = 1.95},
		{s = "Firearms2.M14_BoltRelease", t = 3.15},
		{s = "Firearms2.Cloth_Movement", t = 3.15},
		},
    },
}