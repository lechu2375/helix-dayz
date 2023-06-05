include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 3

SWEP.ItemData = {
    width = 2,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 1 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.7, 272.7, 0),
        fov = 11
    }
}

SWEP.PrintName = "AUG A3"
SWEP.Trivia_Class = "Bullpup Assault Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Steyr Mannlicher"
SWEP.Trivia_Calibre = "5.56x45mm"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = "1978"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/aug.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/aug.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 30
SWEP.DamageMin = 15
SWEP.Range = 300 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 970 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.Recoil = 1.2
SWEP.RecoilSide = 0.15

SWEP.RecoilRise = 0.05
SWEP.RecoilPunch = 0.7
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.12-- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3
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
SWEP.HipDispersion = 430 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "5.56x45mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_AUG"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/auga3.ogg"
SWEP.ShootSoundSilenced = "Firearms2_FAMAS_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_6"

SWEP.ShellModel = "models/shells/5_56x45mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.75

SWEP.IronSightStruct = {
    Pos = Vector(-1.868, -5.4, 0.68),
    Ang = Angle(-0.3, 0.01, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 130 -- The mean number of shots between malfunctions, will be autocalculated if nil
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

SWEP.CrouchPos = Vector(-0.5, -2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(4, -4, 0.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(4, -4, 0.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 25

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["aug_grip"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
    ["muzzlebrake"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
    ["flashhider"] = {
        VMBodygroups = {{ind = 2, bg = 3}},
        WMBodygroups = {{ind = 1, bg = 3}},
    },
    ["40rnd"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
        WMBodygroups = {{ind = 4, bg = 1}},
    },
    ["45rnd"] = {
        VMBodygroups = {{ind = 5, bg = 2}},
        WMBodygroups = {{ind = 4, bg = 2}},
    },
    ["60rnd"] = {
        VMBodygroups = {{ind = 5, bg = 3}},
        WMBodygroups = {{ind = 4, bg = 3}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "famas",
        Offset = {
            vpos = Vector(-1.525, 9.35, -1.15),
            vang = Angle(0, 270, 0),
            wpos = Vector(6, 0.79, -5.17),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(0.9, 0.9, 0.9),
        WMScale = Vector(1.5, 1.5, 1.5),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
        Bone = "famas",
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "famas",
        Offset = {
            vpos = Vector(-2.18, 9.8, -1.82),
            vang = Angle(0, 270, 40),
            wpos = Vector(6.5, -0.32, -4.08),
            wang = Angle(-10.393, 0, 220),
        },
        WMScale = Vector(1.5, 1.5, 1.5),
    },
    {
        PrintName = "Grip",
        DefaultAttName = "Folded Forerip",
        Slot = "fas2_aug_grip",
        FreeSlot = true,
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "AUG 30rnd Mag",
        Slot = {"fas2_aug_45rnd", "fas2_556_40rnd", "fas2_556_60rnd"}
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "5.56x45MM",
        Slot = "fas2_ammo_556x45mmap",
    },
    {
        PrintName = "Skill",
        DefaultAttName = "No Skill",
        Slot = "fas2_nomen",
    },
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep.Attachments[4].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[4].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local nomen = wep.Attachments[7].Installed and "_nomen" or ""
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[4].Installed and "_grip" or ""
    local mag40 = wep.Attachments[5].Installed == "fas2_mag_556_40rnd" and "_45rnd" or ""
    local mag45 = wep.Attachments[5].Installed == "fas2_mag_aug_45rnd" and "_45rnd" or ""
    local mag60 = wep.Attachments[5].Installed == "fas2_mag_556_60rnd" and "_60rnd" or ""

	return "reload" .. mag40 .. mag45 .. mag60 .. nomen .. empty .. grip
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
    ["draw"] = {
        Source = "draw",
        Time = 30/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_grip"] = {
        Source = "draw_grip",
        Time = 30/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 20/60,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["fire"] = {
        Source = "Shoot1",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_grip"] = {
        Source = "Shoot1_grip",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "shoot_last",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_empty_grip"] = {
        Source = "shoot_last_grip",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot_ironsight",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_grip"] = {
        Source = "shoot_ironsight_grip",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "shoot_last_ironsight",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty_grip"] = {
        Source = "shoot_last_ironsight_grip",
        Time = 15/35,
        ShellEjectAt = 0,
    },
    -- ["fix"] = {
    --     Source = "fix",
    --     Time = 45/30,
    --     ShellEjectAt = 0.6,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.AUG_BoltBack", t = 0.5},
    --     {s = "Firearms2.Cloth_Movement", t = 0.5},
    --     {s = "Firearms2.AUG_BoltForward", t = 0.75}
    --     }, 
    -- },
    -- ["fix_grip"] = {
    --     Source = "fix_grip",
    --     Time = 45/30,
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    --     ShellEjectAt = 0.6,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.AUG_BoltBack", t = 0.5},
    --     {s = "Firearms2.Cloth_Movement", t = 0.5},
    --     {s = "Firearms2.AUG_BoltForward", t = 0.75}
    --     }, 
    -- },
    -- ["fix_iron"] = {
    --     Source = "fix_iron",
    --     Time = 35/30,
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    --     ShellEjectAt = 0.6,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.AUG_BoltBack", t = 0.5},
    --     {s = "Firearms2.Cloth_Movement", t = 0.5},
    --     {s = "Firearms2.AUG_BoltForward", t = 0.75}
    --     }, 
    -- },
    -- ["fix_iron_grip"] = {
    --     Source = "fix_iron_grip",
    --     Time = 35/30,
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    --     ShellEjectAt = 0.6,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.AUG_BoltBack", t = 0.5},
    --     {s = "Firearms2.Cloth_Movement", t = 0.5},
    --     {s = "Firearms2.AUG_BoltForward", t = 0.75}
    --     }, 
    -- },
    ["reload"] = {
        Source = "reload",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.AUG_MagOut", t = 0.7},
            {s = "Firearms2.Magpouch", t = 1.2},
            {s = "Firearms2.AUG_MagIn", t = 1.75}
            },  
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.AUG_MagOut", t = 0.7},
            {s = "Firearms2.Magpouch", t = 1.2},
            {s = "Firearms2.AUG_MagIn", t = 1.75}
            },  
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 115/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.75},
        {s = "Firearms2.AUG_BoltBack", t = 2.55},
        {s = "Firearms2.Cloth_Movement", t = 2.55},
        {s = "Firearms2.AUG_BoltForward", t = 2.8}
        }, 
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 115/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.75},
        {s = "Firearms2.AUG_BoltBack", t = 2.55},
        {s = "Firearms2.Cloth_Movement", t = 2.55},
        {s = "Firearms2.AUG_BoltForward", t = 2.8}
        }, 
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5}
        },  
    },
    ["reload_nomen_grip"] = {
        Source = "reload_grip_nomen",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5}
        },  
    },
    ["reload_nomen_empty"] = {
        Source = "reload_empty_nomen",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5},
        {s = "Firearms2.AUG_BoltBack", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.AUG_BoltForward", t = 2.45}
        }, 
    },
    ["reload_nomen_empty_grip"] = {
        Source = "reload_empty_grip_nomen",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5},
        {s = "Firearms2.AUG_BoltBack", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.AUG_BoltForward", t = 2.45}
        }, 
    },
    ["reload_45rnd"] = {
        Source = "reload_45rnd",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.AUG_MagOut", t = 0.7},
            {s = "Firearms2.Magpouch", t = 1.2},
            {s = "Firearms2.AUG_MagIn", t = 1.75}
            },  
    },
    ["reload_45rnd_grip"] = {
        Source = "reload_45rnd_grip",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.AUG_MagOut", t = 0.7},
            {s = "Firearms2.Magpouch", t = 1.2},
            {s = "Firearms2.AUG_MagIn", t = 1.75}
            },  
    },
    ["reload_45rnd_empty"] = {
        Source = "reload_45rnd_empty",
        Time = 115/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.75},
        {s = "Firearms2.AUG_BoltBack", t = 2.55},
        {s = "Firearms2.Cloth_Movement", t = 2.55},
        {s = "Firearms2.AUG_BoltForward", t = 2.8}
        }, 
    },
    ["reload_45rnd_empty_grip"] = {
        Source = "reload_45rnd_empty_grip",
        Time = 115/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.75},
        {s = "Firearms2.AUG_BoltBack", t = 2.55},
        {s = "Firearms2.Cloth_Movement", t = 2.55},
        {s = "Firearms2.AUG_BoltForward", t = 2.8}
        }, 
    },
    ["reload_45rnd_nomen"] = {
        Source = "reload_45rnd_nomen",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5}
        },  
    },
    ["reload_45rnd_nomen_grip"] = {
        Source = "reload_45rnd_grip_nomen",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5}
        },  
    },
    ["reload_45rnd_nomen_empty"] = {
        Source = "reload_45rnd_empty_nomen",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5},
        {s = "Firearms2.AUG_BoltBack", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.AUG_BoltForward", t = 2.45}
        }, 
    },
    ["reload_45rnd_nomen_empty_grip"] = {
        Source = "reload_45rnd_empty_grip_nomen",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5},
        {s = "Firearms2.AUG_BoltBack", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.AUG_BoltForward", t = 2.45}
        }, 
    },
    ["reload_60rnd"] = {
        Source = "reload_60rnd",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.AUG_MagOut", t = 0.7},
            {s = "Firearms2.Magpouch", t = 1.2},
            {s = "Firearms2.AUG_MagIn", t = 1.75}
            },  
    },
    ["reload_60rnd_grip"] = {
        Source = "reload_60rnd_grip",
        Time = 85/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
            {s = "Firearms2.Cloth_Movement", t = 0},
            {s = "Firearms2.AUG_MagOut", t = 0.7},
            {s = "Firearms2.Magpouch", t = 1.2},
            {s = "Firearms2.AUG_MagIn", t = 1.75}
            },  
    },
    ["reload_60rnd_empty"] = {
        Source = "reload_60rnd_empty",
        Time = 115/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.75},
        {s = "Firearms2.AUG_BoltBack", t = 2.55},
        {s = "Firearms2.Cloth_Movement", t = 2.55},
        {s = "Firearms2.AUG_BoltForward", t = 2.8}
        }, 
    },
    ["reload_60rnd_empty_grip"] = {
        Source = "reload_60rnd_empty_grip",
        Time = 115/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.7},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.75},
        {s = "Firearms2.AUG_BoltBack", t = 2.55},
        {s = "Firearms2.Cloth_Movement", t = 2.55},
        {s = "Firearms2.AUG_BoltForward", t = 2.8}
        }, 
    },
    ["reload_60rnd_nomen"] = {
        Source = "reload_60rnd_nomen",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5}
        },  
    },
    ["reload_60rnd_nomen_grip"] = {
        Source = "reload_60rnd_grip_nomen",
        Time = 75/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5}
        },  
    },
    ["reload_60rnd_nomen_empty"] = {
        Source = "reload_60rnd_empty_nomen",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5},
        {s = "Firearms2.AUG_BoltBack", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.AUG_BoltForward", t = 2.45}
        }, 
    },
    ["reload_60rnd_nomen_empty_grip"] = {
        Source = "reload_60rnd_empty_grip_nomen",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.AUG_MagOut", t = 0.5},
        {s = "Firearms2.Magpouch", t = 1.2},
        {s = "Firearms2.AUG_MagIn", t = 1.5},
        {s = "Firearms2.AUG_BoltBack", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.AUG_BoltForward", t = 2.45}
        }, 
    },
}