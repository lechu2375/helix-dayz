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
        ang = Angle(-1.75, 271, 0),
        fov = 11.5
    }
}

SWEP.PrintName = "M4A1"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Colt’s Manufacturing Company"
SWEP.Trivia_Calibre = "5.56x45mm"
SWEP.Trivia_Country = "US"
SWEP.Trivia_Year = "1994"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/rifles/m4a1.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/rifles/m4a1.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 31
SWEP.DamageMin = 16 -- damage done at maximum range
SWEP.Range = 600 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 936 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.6

SWEP.RecoilRise = 0.06
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.0667 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3,
        PostBurstDelay = 0.1,
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
SWEP.HipDispersion = 470 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "5.56x45mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_M4A1"
SWEP.ShootDrySound = "fas2/empty_assaultrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/m4a1.ogg"
SWEP.ShootSoundSilenced = "Firearms2_M4A1_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"
SWEP.MeleeSwingSound = "Firearms2.Magpouch"

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
    Pos = Vector(-2.044, -4, 0.446),
    Ang = Angle(0, 0.02, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.SightTime = 0.4

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-3.8, -3, 0)
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
    ["mount"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["bayonet"] = {
        VMBodygroups = {{ind = 3, bg = 4}},
        WMBodygroups = {{ind = 2, bg = 4}},
    },
    ["dustcover"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
    ["grip"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
        WMBodygroups = {{ind = 4, bg = 1}},
    },
    ["muzzlebrake"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 2, bg = 2}},
    },
    ["flashhider"] = {
        VMBodygroups = {{ind = 3, bg = 3}},
        WMBodygroups = {{ind = 2, bg = 3}},
    },
    ["40rnd"] = {
        VMBodygroups = {{ind = 6, bg = 1}},
        WMBodygroups = {{ind = 5, bg = 1}},
    },
    ["60rnd"] = {
        VMBodygroups = {{ind = 6, bg = 2}},
        WMBodygroups = {{ind = 5, bg = 2}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "Dummy01", 
        Offset = {
            vpos = Vector(2, -1.3, 0.01),
            vang = Angle(0, 0, 270),
            wpos = Vector(6.6, 0.81, -5.23),
            wang = Angle(-10.393, 0, 180)
        },
        VMScale = Vector(1, 1, 1),
        WMScale = Vector(1.5, 1.5, 1.5),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider", "fas2_bayonet"},
    },
    {
        PrintName = "Canted Sight",
        Slot = "fas2_cantedsight",
        Bone = "Dummy01",
        ExcludeFlags = {"cover"},
        GivesFlags = {"cantedsight"},
        Offset = {
            vpos = Vector(5.5, -1.3, 0.01),
            vang = Angle(0, 0, 270),
            wpos = Vector(12.7, 0.81, -6.32),
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
        ExcludeFlags = {"cover"},
        GivesFlags = {"tactical"},
        RequireFlags = {"grip"},
        Offset = {
            vpos = Vector(7.3, -0.65, -0.57),
            vang = Angle(0, 0, 180),
            wpos = Vector(15, 1.7, -5.65),
            wang = Angle(-10.393, 0, 90),
        },
        WMScale = Vector(1.6, 1.6, 1.6),
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
        GivesFlags = {"grip"},
    },
    {
        PrintName = "Cover",
        Slot = "fas2_dustcover",
        ExcludeFlags = {"cantedsight", "tactical"},
        GivesFlags = {"cover"},
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "5.56 30rnd Mag",
        Slot = {"fas2_556_40rnd", "fas2_556_60rnd"},
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
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    if wep.Attachments[5].Installed then return anim .. "_grip" end
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local nomen = wep.Attachments[9].Installed and "_nomen" or ""
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[5].Installed and "_grip" or ""
    local mag40 = wep.Attachments[7].Installed == "fas2_mag_556_40rnd" and "_40rnd" or ""
    local mag60 = wep.Attachments[7].Installed == "fas2_mag_556_60rnd" and "_60rnd" or ""

	return "reload" .. mag40 .. mag60 .. empty .. nomen .. grip
end

SWEP.Animations = {
    -- ["idle"] = false,
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
    ["bash"] = {
        Source = "melee",
        Time = 15/30,
    },
    ["bash_empty"] = {
        Source = "melee_empty",
        Time = 15/30,
    },
    ["bash_grip"] = {
        Source = "melee_grip",
        Time = 15/30,
    },
    ["bash_empty_grip"] = {
        Source = "melee_grip_empty",
        Time = 15/30,
    },
    ["draw"] = {
        Source = "deploy",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_empty"] = {
        Source = "deploy_empty",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_empty_grip"] = {
        Source = "deploy_empty_grip",
        Time = 20/40,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    -- ["ready"] = { 
    --     Source = "deploy_first",
    --     Time = 160/30,
	-- 	ProcDraw = true,
	-- 	SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M4A1_StockPull", t = 0.9},
    --         {s = "Firearms2.Cloth_Movement", t = 0.9},
    --         {s = "Firearms2.M4A1_ChargeBack", t = 1.5},
    --         {s = "Firearms2.M4A1_ReleaseHandle", t = 1.65},
    --         {s = "Firearms2.Cloth_Movement", t = 1.65},
    --         {s = "Firearms2.M4A1_Check", t = 2.2},
    --         {s = "Firearms2.Cloth_Movement", t = 2.2},
    --         {s = "Firearms2.M4A1_Forwardassist", t = 3.6},
    --         {s = "Firearms2.Cloth_Movement", t = 3.6},
    --         {s = "Firearms2.M4A1_DustCover", t = 4.05},
    --         {s = "Firearms2.Cloth_Movement", t = 4.13},
    --         {s = "Firearms2.M4A1_Switch", t = 4.8},
    --         },
    -- },
    -- ["ready_grip"] = { 
    --     Source = "deploy_first_grip",
    --     Time = 160/30,
	-- 	ProcDraw = true,
	-- 	SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M4A1_StockPull", t = 0.9},
    --         {s = "Firearms2.Cloth_Movement", t = 0.9},
    --         {s = "Firearms2.M4A1_ChargeBack", t = 1.5},
    --         {s = "Firearms2.M4A1_ReleaseHandle", t = 1.65},
    --         {s = "Firearms2.Cloth_Movement", t = 1.65},
    --         {s = "Firearms2.M4A1_Check", t = 2.2},
    --         {s = "Firearms2.Cloth_Movement", t = 2.2},
    --         {s = "Firearms2.M4A1_Forwardassist", t = 3.6},
    --         {s = "Firearms2.Cloth_Movement", t = 3.6},
    --         {s = "Firearms2.M4A1_DustCover", t = 4.05},
    --         {s = "Firearms2.Cloth_Movement", t = 4.13},
    --         {s = "Firearms2.M4A1_Switch", t = 4.8},
    --         },
    -- },
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
        Source = {"shoot1_scoped", "shoot2_scoped", "shoot3_scoped"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "shoot_last_scoped",
        Time = 30/30,
        ShellEjectAt = 0,
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
        Source = {"shoot1_scoped_grip", "shoot2_scoped_grip", "shoot3_scoped_grip"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty_grip"] = {
        Source = "shoot_last_scoped_grip",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M4A1_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M4A1_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M4A1_Boltcatch", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3}
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.3},
		{s = "Firearms2.M4A1_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.M4A1_MagIn", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1}
		},
    },
    ["reload_empty_nomen"] = {
        Source = "reload_empty_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Magpouch", t = 0.4},
        {s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.M4A1_Magin", t = 1.1},
        {s = "Firearms2.Cloth_Movement", t = 1.1},
        {s = "Firearms2.M4A1_Boltcatch", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M4A1_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M4A1_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M4A1_Boltcatch", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3}
		},
    },
    ["reload_nomen_grip"] = {
        Source = "reload_nomen_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.3},
		{s = "Firearms2.M4A1_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.M4A1_MagIn", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1}
		},
    },
    ["reload_empty_nomen_grip"] = {
        Source = "reload_empty_nomen_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Magpouch", t = 0.4},
        {s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.M4A1_Magin", t = 1.1},
        {s = "Firearms2.Cloth_Movement", t = 1.1},
        {s = "Firearms2.M4A1_Boltcatch", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
    ["reload_40rnd"] = {
        Source = "reload_40rnd",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M4A1_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_40rnd_empty"] = {
        Source = "reload_40rnd_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M4A1_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M4A1_Boltcatch", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3}
		},
    },
    ["reload_40rnd_nomen"] = {
        Source = "reload_40rnd_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.3},
		{s = "Firearms2.M4A1_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.M4A1_MagIn", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1}
		},
    },
    ["reload_40rnd_empty_nomen"] = {
        Source = "reload_40rnd_empty_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Magpouch", t = 0.4},
        {s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.M4A1_Magin", t = 1.1},
        {s = "Firearms2.Cloth_Movement", t = 1.1},
        {s = "Firearms2.M4A1_Boltcatch", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
    ["reload_40rnd_grip"] = {
        Source = "reload_40rnd_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M4A1_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_40rnd_empty_grip"] = {
        Source = "reload_40rnd_empty_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M4A1_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M4A1_Boltcatch", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3}
		},
    },
    ["reload_40rnd_nomen_grip"] = {
        Source = "reload_40rnd_nomen_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.3},
		{s = "Firearms2.M4A1_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.M4A1_MagIn", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1}
		},
    },
    ["reload_40rnd_empty_nomen_grip"] = {
        Source = "reload_40rnd_empty_nomen_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Magpouch", t = 0.4},
        {s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.M4A1_Magin", t = 1.1},
        {s = "Firearms2.Cloth_Movement", t = 1.1},
        {s = "Firearms2.M4A1_Boltcatch", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
    ["reload_60rnd"] = {
        Source = "reload_60rnd",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M4A1_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_60rnd_empty"] = {
        Source = "reload_60rnd_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M4A1_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M4A1_Boltcatch", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3}
		},
    },
    ["reload_60rnd_nomen"] = {
        Source = "reload_60rnd_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.3},
		{s = "Firearms2.M4A1_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.M4A1_MagIn", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1}
		},
    },
    ["reload_60rnd_empty_nomen"] = {
        Source = "reload_60rnd_empty_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Magpouch", t = 0.4},
        {s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.M4A1_Magin", t = 1.1},
        {s = "Firearms2.Cloth_Movement", t = 1.1},
        {s = "Firearms2.M4A1_Boltcatch", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
    ["reload_60rnd_grip"] = {
        Source = "reload_60rnd_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_Magout", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.5},
		{s = "Firearms2.Cloth_Movement", t = 1.53},
		{s = "Firearms2.M4A1_Magin", t = 2.05},
		{s = "Firearms2.Cloth_Movement", t = 2.05}
		},
    },
    ["reload_60rnd_empty_grip"] = {
        Source = "reload_60rnd_empty_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 90/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
		{s = "Firearms2.Cloth_Movement", t = 0.7},
		{s = "Firearms2.Magpouch", t = 1.15},
		{s = "Firearms2.M4A1_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.M4A1_Boltcatch", t = 2.3},
		{s = "Firearms2.Cloth_Movement", t = 2.3}
		},
    },
    ["reload_60rnd_nomen_grip"] = {
        Source = "reload_60rnd_nomen_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.Magpouch", t = 0.3},
		{s = "Firearms2.M4A1_MagOut", t = 0.8},
		{s = "Firearms2.Cloth_Movement", t = 0.8},
		{s = "Firearms2.M4A1_MagIn", t = 1.1},
		{s = "Firearms2.Cloth_Movement", t = 1.1}
		},
    },
    ["reload_60rnd_empty_nomen_grip"] = {
        Source = "reload_60rnd_empty_nomen_grip",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        Time = 68/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.Magpouch", t = 0.4},
        {s = "Firearms2.M4A1_MagoutEmpty", t = 0.7},
        {s = "Firearms2.Cloth_Movement", t = 0.7},
        {s = "Firearms2.M4A1_Magin", t = 1.1},
        {s = "Firearms2.Cloth_Movement", t = 1.1},
        {s = "Firearms2.M4A1_Boltcatch", t = 1.6},
        {s = "Firearms2.Cloth_Movement", t = 1.6},
		},
    },
}