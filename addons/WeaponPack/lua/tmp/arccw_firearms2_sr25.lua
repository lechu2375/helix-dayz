include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 4

SWEP.PrintName = "SR-25"
SWEP.Trivia_Class = "Designated marksman rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Knight's Armament Company"
SWEP.Trivia_Calibre = "7.62x51mm"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1990"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/snipers/sr25.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/snipers/sr25.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 55
SWEP.DamageMin = 27 -- damage done at maximum range
SWEP.Range = 800 -- in METRES
SWEP.Penetration = 20
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 820 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.

SWEP.Recoil = 2
SWEP.RecoilSide = 0.12

SWEP.RecoilRise = 0.04
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.16 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 240 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "7.62x51mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_SR25"
SWEP.ShootDrySound = "fas2/empty_sniperrifles.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/sr25.ogg"
SWEP.ShootSoundSilenced = "Firearms2_SR25_S"
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
    Pos = Vector(-2.028, -0.651, 0.56),
    Ang = Angle(0, -0.02, 0),
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

SWEP.CrouchPos = Vector(-3.8, -2, 0)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.HolsterPos = Vector(3.5, -3, 1)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(3.5, -3, 0)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(4.5, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 29

SWEP.AttachmentElements = {
    ["suppressorsr25"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
    ["muzzlebrake"] = {
        VMBodygroups = {{ind = 2, bg = 3}},
        WMBodygroups = {{ind = 1, bg = 3}},
    },
    ["flashhider"] = {
        VMBodygroups = {{ind = 2, bg = 4}},
        WMBodygroups = {{ind = 1, bg = 4}},
    },
    ["grip"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["20rnd"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = "fas2_leupold2_scope",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(0.65, -1.27, -0.04),
            vang = Angle(0, 0, 270),
            wpos = Vector(5.18, 0.86, -4.97),
            wang = Angle(-10.393, 0, 180)
        },
        Installed = "fas2_scope_leupold2",
        Integral = true,
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
    },
    {
        PrintName = "Canted Sight",
        Slot = "fas2_cantedsight",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(4.5, -1.27, -0.04),
            vang = Angle(0, 0, 270),
            wpos = Vector(11.5, 0.86, -6.1),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzle_sr25", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Tactical",
        Slot = "fas2_tactical",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(9.4, -0.7, -0.68),
            vang = Angle(0, 0, 180),
            wpos = Vector(19.3, 1.86, -6.43),
            wang = Angle(-10.393, 0, 90),
        },
        VScale = Vector(1.2, 1.2, 1.2),
        WMScale = Vector(1.7, 1.7, 1.7),
    },
    {
        PrintName = "Grip",
        Slot = "fas2_grip",
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "SR-25 10Rnd Mag",
        Slot = "fas2_sr25_20rnd"
    },
    {
        PrintName = "Ammunition",
        DefaultAttName = "7.62x51MM",
        Slot = "fas2_ammo_762x51mmap",
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
    local nomen = wep.Attachments[8].Installed and "_nomen" or ""
    local empty = wep:Clip1() == 0 and "_empty" or ""
    local grip = wep.Attachments[5].Installed and "_grip" or ""
    local mag20 = wep.Attachments[6].Installed and "_20rnd" or ""

	return "reload" .. mag20 .. empty .. nomen .. grip
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
    -- ["idle"] = false,
    -- ["ready_sr25_suppressor"] = {
    --     Source = "deploy_first",
    --     Time = 190/30,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.SR25_StockUnlock", t = 0.7},
    --     {s = "Firearms2.Cloth_Movement", t = 0.7},
    --     {s = "Firearms2.SR25_StockPull", t = 0.9},
    --     {s = "Firearms2.SR25_StockLock", t = 1.5},
    --     {s = "Firearms2.Cloth_Movement", t = 1.5},
    --     {s = "Firearms2.SR25_ChargingHandleBack", t = 2.2},
    --     {s = "Firearms2.Cloth_Movement", t = 2.2},
    --     {s = "Firearms2.SR25_ChargingHandleForward", t = 2.5},
    --     {s = "Firearms2.SR25_SupressorOn", t = 4.5},
    --     {s = "Firearms2.Cloth_Movement", t = 4.5},
    --     {s = "Firearms2.SR25_SupressorLock", t = 5.1},
    --     {s = "Firearms2.Cloth_Movement", t = 5.1},
    --     {s = "Firearms2.SR25_Safety", t = 5.9}
    --     },
    -- },
    -- ["ready"] = {
    --     Source = "deploy",
    --     Time = 20/30,
	-- 	SoundTable = {
    --     {s = "Firearms2.Deploy", t = 0},
    --     {s = "Firearms2.SR25_Safety", t = 0.35}
    --     },
    -- },
    ["draw"] = {
        Source = "deploy",
        Time = 20/30,
		SoundTable = {
        {s = "Firearms2.Deploy", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.35}
        },
    },
    ["draw_grip"] = {
        Source = "deploy_grip",
        Time = 20/30,
		SoundTable = {
        {s = "Firearms2.Deploy", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.35}
        },
    },
    ["draw_empty"] = {
        Source = "deploy_empty",
        Time = 20/30,
		SoundTable = {
        {s = "Firearms2.Deploy", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.35}
        },
    },
    ["draw_empty_grip"] = {
        Source = "deploy_empty_grip",
        Time = 20/30,
		SoundTable = {
        {s = "Firearms2.Deploy", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.35}
        },
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/60,
		SoundTable = {
        {s = "Firearms2.Holster", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.05}
        },
    },
    ["holster_grip"] = {
        Source = "holster_grip",
        Time = 20/60,
		SoundTable = {
        {s = "Firearms2.Holster", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.05}
        },
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 20/60,
		SoundTable = {
        {s = "Firearms2.Holster", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.05}
        },
    },
    ["holster_empty_grip"] = {
        Source = "holster_empty_grip",
        Time = 20/60,
		SoundTable = {
        {s = "Firearms2.Holster", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.05}
        },
    },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_grip"] = {
        Source = {"fire1_grip", "fire2_grip", "fire3_grip"},
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["fire_empty_grip"] = {
        Source = "fire_last_grip",
        Time = 30/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.SR25_Safety", t = 0.2},
		{s = "Firearms2.SR25_Magout", t = 0.4},
		{s = "Firearms2.Cloth_Movement", t = 0.4},
		{s = "Firearms2.Magpouch", t = 1.3},
		{s = "Firearms2.SR25_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.SR25_Magslap", t = 2.2},
		{s = "Firearms2.Cloth_Movement", t = 2.2},
		{s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_grip"] = {
        Source = "reload_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.SR25_Safety", t = 0.2},
		{s = "Firearms2.SR25_Magout", t = 0.4},
		{s = "Firearms2.Cloth_Movement", t = 0.4},
		{s = "Firearms2.Magpouch", t = 1.3},
		{s = "Firearms2.SR25_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.SR25_Magslap", t = 2.2},
		{s = "Firearms2.Cloth_Movement", t = 2.2},
		{s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.2},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Cloth_Movement", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SR25_Magin", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7},
        {s = "Firearms2.SR25_BoltcatchSlap", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_empty_grip"] = {
        Source = "reload_empty_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.2},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Cloth_Movement", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SR25_Magin", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7},
        {s = "Firearms2.SR25_BoltcatchSlap", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Magout", t = 0.2},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5}
        },
    },
    ["reload_nomen_grip"] = {
        Source = "reload_grip_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Magout", t = 0.2},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5}
        },
    },
    ["reload_nomen_empty"] = {
        Source = "reload_empty_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5},
        {s = "Firearms2.SR25_Boltcatch", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7}
        },
    },
    ["reload_nomen_empty_grip"] = {
        Source = "reload_empty_grip_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5},
        {s = "Firearms2.SR25_Boltcatch", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7}
        },
    },
    ["reload_20rnd"] = {
        Source = "reload_20rnd",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.SR25_Safety", t = 0.2},
		{s = "Firearms2.SR25_Magout", t = 0.4},
		{s = "Firearms2.Cloth_Movement", t = 0.4},
		{s = "Firearms2.Magpouch", t = 1.3},
		{s = "Firearms2.SR25_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.SR25_Magslap", t = 2.2},
		{s = "Firearms2.Cloth_Movement", t = 2.2},
		{s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_20rnd_grip"] = {
        Source = "reload_20rnd_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
		{s = "Firearms2.Cloth_Movement", t = 0},
		{s = "Firearms2.SR25_Safety", t = 0.2},
		{s = "Firearms2.SR25_Magout", t = 0.4},
		{s = "Firearms2.Cloth_Movement", t = 0.4},
		{s = "Firearms2.Magpouch", t = 1.3},
		{s = "Firearms2.SR25_Magin", t = 1.7},
		{s = "Firearms2.Cloth_Movement", t = 1.7},
		{s = "Firearms2.SR25_Magslap", t = 2.2},
		{s = "Firearms2.Cloth_Movement", t = 2.2},
		{s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_20rnd_empty"] = {
        Source = "reload_20rnd_empty",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.2},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Cloth_Movement", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SR25_Magin", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7},
        {s = "Firearms2.SR25_BoltcatchSlap", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_20rnd_empty_grip"] = {
        Source = "reload_20rnd_empty_grip",
        Time = 90/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Safety", t = 0.2},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Cloth_Movement", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.3},
        {s = "Firearms2.SR25_Magin", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7},
        {s = "Firearms2.SR25_BoltcatchSlap", t = 2.2},
        {s = "Firearms2.Cloth_Movement", t = 2.2},
        {s = "Firearms2.SR25_Safety", t = 2.7}
        },
    },
    ["reload_20rnd_nomen"] = {
        Source = "reload_20rnd_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Magout", t = 0.2},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5}
        },
    },
    ["reload_20rnd_nomen_grip"] = {
        Source = "reload_20rnd_grip_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_Magout", t = 0.2},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5}
        },
    },
    ["reload_20rnd_empty_nomen"] = {
        Source = "reload_20rnd_empty_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5},
        {s = "Firearms2.SR25_Boltcatch", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7}
        },
    },
    ["reload_20rnd_empty_nomen_grip"] = {
        Source = "reload_20rnd_empty_grip_nomen",
        Time = 67/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.SR25_MagoutEmpty", t = 0.4},
        {s = "Firearms2.Magpouch", t = 1.1},
        {s = "Firearms2.SR25_Magin", t = 1.5},
        {s = "Firearms2.Cloth_Movement", t = 1.5},
        {s = "Firearms2.SR25_Boltcatch", t = 1.7},
        {s = "Firearms2.Cloth_Movement", t = 1.7}
        },
    },
}