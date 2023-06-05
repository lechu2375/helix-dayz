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

SWEP.PrintName = "M110"
SWEP.Trivia_Class = "Designated Marksman Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Knight's Armament Company"
SWEP.Trivia_Calibre = "7.62x51mm"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "2007"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/snipers/m110.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/snipers/m110.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 46
SWEP.DamageMin = 23 -- damage done at maximum range
SWEP.Range = 800 -- in METRES
SWEP.Penetration = 15
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 783 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.

SWEP.Recoil = 2.1
SWEP.RecoilSide = 0.11

SWEP.RecoilRise = 0.07
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.18 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = -2,
        PostBurstDelay = 0.05,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 320 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "7.62x51mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_M110"
SWEP.ShootDrySound = "fas2/empty_sniperrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/m110.ogg"
SWEP.ShootSoundSilenced = "Firearms2_M110_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_SR25"

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
    Pos = Vector(-1.965, -4, 1.16),
    Ang = Angle(0.3, 0.05, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 55 -- The mean number of shots between malfunctions, will be autocalculated if nil
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

SWEP.CrouchPos = Vector(-4, -2, 0)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(3.5, -3, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(3.5, -3, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 29

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
    ["mount"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
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
        Slot = {"fas2_leupold2_scope", "fas2_sight", "fas2_scope"},
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(2, -1.2, -0.06),
            vang = Angle(0, 0, 270),
            wpos = Vector(6.5, 0.8, -5.45),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(1.01, 1.01, 1.01),
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
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
            vpos = Vector(7, -1.2, -0.06),
            vang = Angle(0, 0, 270),
            wpos = Vector(12.9, 0.8, -6.55),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(10.8, -0.5, -0.68),
            vang = Angle(0, 0, 180),
            wpos = Vector(20, 1.75, -6.65),
            wang = Angle(-10.393, 0, 90),
        },
        WMScale = Vector(1.6, 1.6, 1.6),
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
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
    local empty = wep:Clip1() == 0 and "_empty" or ""

	return "reload" .. empty .. grip
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 0/1,
    },
    ["idle_empty"] = {
        Source = "idle_empty",
        Time = 0/1,
    },
    ["idle_grip"] = {
        Source = "idle_grip",
        Time = 0/1,
    },
    ["idle_empty_grip"] = {
        Source = "idle_empty_grip",
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
        Source = {"shoot", "shoot2", "shoot3"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "shoot_last",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = {"shoot1_scoped", "shoot2_scoped"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "shoot_last_scoped",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M110_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M110_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M110_Magout", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M110_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M110_Boltcatch", t = 2.25},
		{s = "Firearms2.Cloth_Movement", t = 2.25}
		},
    },
    ["idle_grip"] = {
        Source = "idle_grip",
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
        Source = {"shoot_grip", "shoot2_grip", "shoot3_grip"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_empty_grip"] = {
        Source = "shoot_last_grip",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = {"shoot1_scoped_grip", "shoot2_scoped_grip"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty_grip"] = {
        Source = "shoot_last_scoped_grip",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M110_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M110_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M110_Magout", t = 0.6},
		{s = "Firearms2.Cloth_Movement", t = 0.6},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M110_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M110_Boltcatch", t = 2.25},
		{s = "Firearms2.Cloth_Movement", t = 2.25}
		},
    },
    ["fix"] = { 
        Source = "fix",
        Time = 53/40,
		ProcDraw = true,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M4A1_ChargeBack", t = 0.45},
        {s = "Firearms2.M4A1_ReleaseHandle", t = 0.625},
        {s = "Firearms2.Cloth_Movement", t = 0.625},
        },
    },
    ["fix_grip"] = { 
        Source = "fix_grip",
        Time = 53/40,
		ProcDraw = true,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M4A1_ChargeBack", t = 0.45},
        {s = "Firearms2.M4A1_ReleaseHandle", t = 0.625},
        {s = "Firearms2.Cloth_Movement", t = 0.625},
        },
    },
}