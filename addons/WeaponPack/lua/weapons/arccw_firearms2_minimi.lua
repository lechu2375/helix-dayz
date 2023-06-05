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
    rarity = { weight = 15 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.65, 270.5, 0),
        fov = 12.4
    }
}

SWEP.PrintName = "FN Minimi"
SWEP.Trivia_Class = "Light machine gun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "FN Herstal"
SWEP.Trivia_Calibre = "5.56x45mm"
SWEP.Trivia_Country = "Belgium"
SWEP.Trivia_Year = "1977"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/machineguns/minimi.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/machineguns/minimi.mdl"
SWEP.ViewModelFOV = 50

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 29
SWEP.DamageMin = 15 -- damage done at maximum range
SWEP.Range = 1000 -- in METRES
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 925 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 0 -- tracer every X

SWEP.Bipod_Integral = false -- Integral bipod (ie, weapon model has one)
SWEP.BipodDispersion = 1.1 -- Bipod dispersion for Integral bipods
SWEP.BipodRecoil = 1.01 -- Bipod recoil for Integral bipods

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 100 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 200
SWEP.ReducedClipSize = 10

SWEP.Recoil = 1.65
SWEP.RecoilSide = 0.15

SWEP.RecoilRise = 0.04
SWEP.RecoilPunch = 0.5
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1
SWEP.RecoilVMShake = 0

SWEP.Sway = 0.5

SWEP.Delay = 0.0857 -- 60 / RPM.
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
SWEP.HipDispersion = 480 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "5.56x45mm" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = nil

SWEP.ShootSound = "Firearms2_M249"
SWEP.ShootDrySound = "fas2/m249/m249_fire_empty.wav" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/minimi.ogg"
SWEP.ShootSoundSilenced = "Firearms2_M249_S"
SWEP.FiremodeSound = "Firearms2.Firemode_Switch"

SWEP.MuzzleEffect = "muzzleflash_MINIMI"

SWEP.ShellModel = "models/shells/5_56x45mm.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Rifle
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.75
SWEP.SightedSpeedMult = 0.65

SWEP.IronSightStruct = {
    Pos = Vector(-3.516, -3.5, 2.02),
    Ang = Angle(0.5, 0.02, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

-- SWEP.Malfunction = true
-- SWEP.MalfunctionJam = true -- After a malfunction happens, the gun will dryfire until reload is pressed. If unset, instead plays animation right after.
-- SWEP.MalfunctionTakeRound = false -- When malfunctioning, a bullet is consumed.
-- SWEP.MalfunctionMean = 76 -- The mean number of shots between malfunctions, will be autocalculated if nil
-- SWEP.MalfunctionVariance = 1 -- The fraction of mean for variance. e.g. 0.2 means 20% variance
-- SWEP.MalfunctionSound = "weapons/arccw/malfunction.wav"

SWEP.SightTime = 0.5

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -25)

SWEP.HolsterPos = Vector(6, -3, 1.5)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.SprintPos = Vector(6, -3, 1.5)
SWEP.SprintAng = Angle(-4.633, 36.881, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(6.824, 0, -1.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 27

SWEP.AttachmentElements = {
    ["mount"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["suppressor"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 2, bg = 1}},
    },
    ["200mag"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},
    },
    ["stanag"] = {
        VMBodygroups = {{ind = 4, bg = 2}},
        WMBodygroups = {{ind = 3, bg = 2}},
    },
    -- ["60rnd"] = {
    --     VMBodygroups = {{ind = 4, bg = 3}},
    --     WMBodygroups = {{ind = 3, bg = 3}},
    -- },
    ["muzzlebrake"] = {
        VMBodygroups = {{ind = 3, bg = 2}},
        WMBodygroups = {{ind = 2, bg = 2}},
    },
    ["flashhider"] = {
        VMBodygroups = {{ind = 3, bg = 3}},
        WMBodygroups = {{ind = 2, bg = 3}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Mount",
        DefaultAttName = "Ironsight",
        Slot = {"fas2_sight", "fas2_scope"},
        Bone = "Lid",
        Offset = {
            vpos = Vector(-4.2, -0.955, -0.85),
            vang = Angle(0, 0, 270),
            wpos = Vector(3.85, 2.18, -7.9),
            wang = Angle(-10.393, 0, 180)
        },
        WMScale = Vector(1.6, 1.6, 1.6),
        CorrectivePos = Vector(0.003, 0, 0.00),
        CorrectiveAng = Angle(0, 0, 0)
    },
    {
        PrintName = "Muzzle",
        Slot = {"fas2_muzzle", "fas2_muzzlebrake", "fas2_flashhider"},
    },
    {
        PrintName = "Magazine",
        DefaultAttName = "Minimi/M249 100rnd Box",
        Slot = {"fas2_m249_200rnd", "fas2_stanag"}
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


local fisrtfire = false
SWEP.fisrtfire_starter = true

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep:Clip1() == wep:GetMaxClip1() then return anim .. "_unfired" end
    if wep:Clip1() <= 10 then return anim .. wep:Clip1() end

    return anim
end

local stanag_installed = false

SWEP.Hook_SelectFireAnimation = function(wep, anim)
    stanag_installed = wep.Attachments[3].Installed == "fas2_mag_stanag"
    local iron = (wep:GetState() == ArcCW.STATE_SIGHTS and "_iron") or ""

    if wep:Clip1() <= 10 then return anim .. "_last" .. wep:Clip1() end

    return anim
end

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    local empty = (wep:Clip1() == 0 and "_empty") or ""
    local nomen = wep.Attachments[5].Installed and "_nomen" or ""

    if wep.Attachments[3].Installed == "fas2_mag_stanag" then
        return anim .. empty .. "_stanag" .. nomen
    else
        if wep:Clip1() == 0 then 
            wep:ReloadLinkEject(1.8) 
        end
    end

    if wep:Clip1() <= 10 then
        return anim .. wep:Clip1() .. nomen
    else
        if wep:Clip1() >= 11 then
            return anim .. nomen
        end
    end

    return anim
end

SWEP.Animations = {
    ["idle"] = false,
    -- ["ready"] = { 
    --     Source = "",
    -- },
    -- ["enter_bipod"] = { 
    --     Source = "bipod_down",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last11"] = { 
    --     Source = "bipod_down_last11",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last10"] = { 
    --     Source = "bipod_down_last10",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last9"] = { 
    --     Source = "bipod_down_last9",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last8"] = { 
    --     Source = "bipod_down_last8",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last7"] = { 
    --     Source = "bipod_down_last7",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last6"] = { 
    --     Source = "bipod_down_last6",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last5"] = { 
    --     Source = "bipod_down_last5",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last4"] = { 
    --     Source = "bipod_down_last4",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last3"] = { 
    --     Source = "bipod_down_last3",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last2"] = { 
    --     Source = "bipod_down_last2",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.Bipod_Down", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last1"] = { 
    --     Source = "bipod_down_last1",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_last0"] = { 
    --     Source = "bipod_down_last0",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["bipod_down_unfired"] = { 
    --     Source = "bipod_down_unfired",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.1},
    --     },
    -- },
    -- ["exit_bipod"] = { 
    --     Source = "bipod_up",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last0"] = { 
    --     Source = "bipod_up_last0",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last1"] = { 
    --     Source = "bipod_up_last1",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last2"] = { 
    --     Source = "bipod_up_last2",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last3"] = { 
    --     Source = "bipod_up_last3",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last4"] = { 
    --     Source = "bipod_up_last4",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.45},
    --     },
    -- },
    -- ["bipod_up_last5"] = { 
    --     Source = "bipod_up_last5",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last6"] = { 
    --     Source = "bipod_up_last6",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last7"] = { 
    --     Source = "bipod_up_last7",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last8"] = { 
    --     Source = "bipod_up_last8",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last9"] = { 
    --     Source = "bipod_up_last9",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last10"] = { 
    --     Source = "bipod_up_last10",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_last11"] = { 
    --     Source = "bipod_up_last11",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["bipod_up_unfired"] = { 
    --     Source = "bipod_up_unfired",
    --     Time = 30/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Bipod", t = 0.5},
    --     },
    -- },
    -- ["fire_bipod"] = {
    --     Source = {"bipod_fire1", "bipod_fire2", "bipod_fire3"},
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last11"] = {
    --     Source = "bipod_fire1_last11",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last10"] = {
    --     Source = "bipod_fire1_last10",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last9"] = {
    --     Source = "bipod_fire1_last9",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last8"] = {
    --     Source = "bipod_fire1_last8",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last7"] = {
    --     Source = "bipod_fire1_last7",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last6"] = {
    --     Source = "bipod_fire1_last6",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last5"] = {
    --     Source = "bipod_fire1_last5",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last4"] = {
    --     Source = "bipod_fire1_last4",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last3"] = {
    --     Source = "bipod_fire1_last3",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last2"] = {
    --     Source = "bipod_fire1_last2",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last1"] = {
    --     Source = "bipod_fire1_last1",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["fire_iron_bipod"] = {
    --     Source = {"bipod_fire1_scoped", "bipod_fire2_scoped", "bipod_fire3_scoped"},
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last11_scoped"] = {
    --     Source = "bipod_fire1_last11_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last10_scoped"] = {
    --     Source = "bipod_fire1_last10_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last9_scoped"] = {
    --     Source = "bipod_fire1_last9_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last8_scoped"] = {
    --     Source = "bipod_fire1_last8_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last7_scoped"] = {
    --     Source = "bipod_fire1_last7_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last6_scoped"] = {
    --     Source = "bipod_fire1_last6_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last5_scoped"] = {
    --     Source = "bipod_fire1_last5_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last4_scoped"] = {
    --     Source = "bipod_fire1_last4_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last3_scoped"] = {
    --     Source = "bipod_fire1_last3_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last2_scoped"] = {
    --     Source = "bipod_fire1_last2_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["bipod_fire1_last1_scoped"] = {
    --     Source = "bipod_fire1_last1_scoped",
    --     Time = 30/55,
    --     ShellEjectAt = 0,
    -- },
    -- ["deploy_first01"] = { 
    -- Source = "deploy_first01",
    -- Time = 60/30,
	-- ProcDraw = true,
	-- SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Butt", t = 0.5},
    --     {s = "Firearms2.M249_Butt_Move", t = 0.9},
    --     {s = "Firearms2.M60_shoulderrest", t = 1.35},
    --     },
    -- },

    -- ["deploy_first02"] = { 
    --     Source = "deploy_first02",
    --     Time = 135/30,
    --     ProcDraw = true,
    --     SoundTable = {
    --         {s = "Firearms2.Cloth_Movement", t = 0},
    --         {s = "Firearms2.M249_Lidopen", t = 0.65},
    --         {s = "Firearms2.M60_feeding_mechanism", t = 1.6},
    --         {s = "Firearms2.M60_feeding_mechanism", t = 1.9},
    --         {s = "Firearms2.M60_feeding_tray", t = 2.5},
    --         {s = "Firearms2.M249_Lidclose", t = 3.7},
    --         },
    --     },
    ["draw"] = {
        Source = "deploy",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw_unfired"] = {
        Source = "deploy_unfired",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw0"] = {
        Source = "deploy_last0",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw1"] = {
        Source = "deploy_last1",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw2"] = {
        Source = "deploy_last2",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw3"] = {
        Source = "deploy_last3",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw4"] = {
        Source = "deploy_last4",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw5"] = {
        Source = "deploy_last5",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw6"] = {
        Source = "deploy_last6",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw7"] = {
        Source = "deploy_last7",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw8"] = {
        Source = "deploy_last8",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw9"] = {
        Source = "deploy_last9",
        Time = 20/30,
		ProcDraw = true,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["draw10"] = {
        Source = "deploy_last10",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_unfired"] = {
        Source = "holster_unfired",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster0"] = {
        Source = "holster_last0",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster1"] = {
        Source = "holster_last1",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster2"] = {
        Source = "holster_last2",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster3"] = {
        Source = "holster_last3",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster4"] = {
        Source = "holster_last4",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster5"] = {
        Source = "holster_last5",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster6"] = {
        Source = "holster_last6",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster7"] = {
        Source = "holster_last7",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster8"] = {
        Source = "holster_last8",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster9"] = {
        Source = "holster_last9",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster10"] = {
        Source = "holster_last10",
        Time = 20/30,
		SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    -- ["fire_dry"] = {
    --     Source = "fire_empty",
	-- 	SoundTable = {{s = "fas2/m249/m249_fire_empty.wav", t = 0}},
    --     Time = 45/50,
    --     TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
    -- },
    -- ["fire_dry_iron"] = {
    --     Source = "fire_empty_scoped",
	-- 	SoundTable = {{s = "fas2/m249/m249_fire_empty.wav", t = 0}},
    --     Time = 45/50,
    -- },
    -- ["fire_dry_bipod"] = {
    --     Source = "bipod_fire1_last0",
	-- 	SoundTable = {{s = "fas2/m249/m249_fire_empty.wav", t = 0}},
    --     Time = 45/50,
    --     TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
    -- },
    -- ["fire_dry_iron_bipod"] = {
    --     Source = "bipod_fire1_last0_scoped",
	-- 	SoundTable = {{s = "fas2/m249/m249_fire_empty.wav", t = 0}},
    --     Time = 45/50,
    -- },
    -- ["fire_empty"] = {
    --     Source = "fire_empty",
    --     Time = 45/50,
    -- },
    -- ["fire_empty_scoped"] = {
    --     Source = "fire_empty_scoped",
    --     Time = 45/50,
    -- },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3"},
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = {"fire1_scoped", "fire2_scoped", "fire3_scoped"},
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last0"] = {
        Source = "fire1_last1",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last1"] = {
        Source = "fire1_last2",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last2"] = {
        Source = "fire1_last3",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last3"] = {
        Source = "fire1_last4",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last4"] = {
        Source = "fire1_last5",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last5"] = {
        Source = "fire1_last6",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last6"] = {
        Source = "fire1_last7",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last7"] = {
        Source = "fire1_last8",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last8"] = {
        Source = "fire1_last9",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last9"] = {
        Source = "fire1_last10",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_last10"] = {
        Source = "fire1_last11",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last0"] = {
        Source = "fire1_last1_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last1"] = {
        Source = "fire1_last2_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last2"] = {
        Source = "fire1_last3_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last3"] = {
        Source = "fire1_last4_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last4"] = {
        Source = "fire1_last5_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last5"] = {
        Source = "fire1_last6_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last6"] = {
        Source = "fire1_last7_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last7"] = {
        Source = "fire1_last8_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last8"] = {
        Source = "fire1_last9_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last9"] = {
        Source = "fire1_last10_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_iron_last10"] = {
        Source = "fire1_last11_scoped",
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_stanag"] = {
        Source = {"fire1_stanag", "fire2_stanag", "fire3_stanag"},
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fire_stanag_iron"] = {
        Source = {"fire1_stanag_scoped", "fire2_stanag_scoped", "fire3_stanag_scoped"},
        Time = 45/55,
        ShellEjectAt = 0,
    },
    ["fix"] = {
        Source = "fix",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix0"] = {
        Source = "fix0",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix1"] = {
        Source = "fix1",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix2"] = {
        Source = "fix2",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix3"] = {
        Source = "fix3",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix4"] = {
        Source = "fix4",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix5"] = {
        Source = "fix5",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix6"] = {
        Source = "fix6",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix7"] = {
        Source = "fix7",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix8"] = {
        Source = "fix8",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix9"] = {
        Source = "fix9",
        Time = 53/30,
        Procfix = true,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["fix10"] = {
        Source = "fix10",
        Time = 53/30,
        SoundTable = {{s = "Firearms2.M249_Charge", t = 0.34}},
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload10"] = {
        Source = "reload_last10",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload9"] = {
        Source = "reload_last9",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload8"] = {
        Source = "reload_last8",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload7"] = {
        Source = "reload_last7",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload6"] = {
        Source = "reload_last6",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload5"] = {
        Source = "reload_last5",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Beltremove", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload4"] = {
        Source = "reload_last4",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Belt4", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload3"] = {
        Source = "reload_last3",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Belt4", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload2"] = {
        Source = "reload_last2",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Belt5", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload1"] = {
        Source = "reload_last1",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 270/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.45},
        {s = "Firearms2.M249_Belt6", t = 1},
        {s = "Firearms2.M249_Boxremove", t = 2.375},
        {s = "Firearms2.M249_Boxinsert", t = 3.7},
        {s = "Firearms2.M249_Beltpull", t = 4.375},
        {s = "Firearms2.M249_Beltload", t = 5},
        {s = "Firearms2.M249_Lidclose", t = 5.625},
		},
    },
    ["reload0"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 300/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Charge", t = 0.35},
        {s = "Firearms2.M249_Lidopen", t = 1.2},
        {s = "Firearms2.M249_Belt6", t = 1.8},
        {s = "Firearms2.M249_Boxremove", t = 3.125},
        {s = "Firearms2.M249_Boxinsert", t = 4.45},
        {s = "Firearms2.M249_Beltpull", t = 5.125},
        {s = "Firearms2.M249_Beltload", t = 5.75},
        {s = "Firearms2.M249_Lidclose", t = 6.375},
		},
    },
    -- ["reload_bipod"] = {
    --     Source = "bipod_reload",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last11"] = {
    --     Source = "bipod_reload_last11",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last10"] = {
    --     Source = "bipod_reload_last10",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last9"] = {
    --     Source = "bipod_reload_last9",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last8"] = {
    --     Source = "bipod_reload_last8",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last7"] = {
    --     Source = "bipod_reload_last7",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last6"] = {
    --     Source = "bipod_reload_last6",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last5"] = {
    --     Source = "bipod_reload_last5",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Beltremove", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last4"] = {
    --     Source = "bipod_reload_last4",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Belt4", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last3"] = {
    --     Source = "bipod_reload_last3",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Belt4", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last2"] = {
    --     Source = "bipod_reload_last2",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Belt5", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["bipod_reload_last1"] = {
    --     Source = "bipod_reload_last1",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 270/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Lidopen", t = 0.45},
    --     {s = "Firearms2.M249_Belt6", t = 1},
    --     {s = "Firearms2.M249_Boxremove", t = 2.375},
    --     {s = "Firearms2.M249_Boxinsert", t = 3.7},
    --     {s = "Firearms2.M249_Beltpull", t = 4.375},
    --     {s = "Firearms2.M249_Beltload", t = 5},
    --     {s = "Firearms2.M249_Lidclose", t = 5.625},
	-- 	},
    -- },
    -- ["reload_bipod_empty"] = {
    --     Source = "bipod_reload_empty",
    --     TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    --     Time = 300/40,
	-- 	SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M249_Charge", t = 0.35},
    --     {s = "Firearms2.M249_Lidopen", t = 1.2},
    --     {s = "Firearms2.M249_Belt6", t = 1.8},
    --     {s = "Firearms2.M249_Boxremove", t = 3.125},
    --     {s = "Firearms2.M249_Boxinsert", t = 4.45},
    --     {s = "Firearms2.M249_Beltpull", t = 5.125},
    --     {s = "Firearms2.M249_Beltload", t = 5.75},
    --     {s = "Firearms2.M249_Lidclose", t = 6.375},
	-- 	},
    -- },
    ["reload_stanag"] = {
        Source = "reload_stanag",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 90/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M16A2_MagOut", t = 0.84},
        {s = "Firearms2.Magpouch", t = 1.44},
        {s = "Firearms2.M16A2_MagHousing", t = 2},
        {s = "Firearms2.M16A2_MagIn", t = 2.2},
		},
    },
    ["reload_empty_stanag"] = {
        Source = "reload_stanag_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 120/30,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Charge", t = 0.34},
        {s = "Firearms2.M16A2_MagOut", t = 1.84},
        {s = "Firearms2.Magpouch", t = 2.4},
        {s = "Firearms2.M16A2_MagHousing", t = 3},
        {s = "Firearms2.M16A2_MagIn", t = 3.17},
		},
    },
    ["reload_nomen"] = {
        Source = "reload_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload10_nomen"] = {
        Source = "reload_last10_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload9_nomen"] = {
        Source = "reload_last9_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload8_nomen"] = {
        Source = "reload_last8_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload7_nomen"] = {
        Source = "reload_last7_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload6_nomen"] = {
        Source = "reload_last6_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload5_nomen"] = {
        Source = "reload_last5_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Beltremove", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload4_nomen"] = {
        Source = "reload_last4_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Belt4", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload3_nomen"] = {
        Source = "reload_last3_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Belt4", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload2_nomen"] = {
        Source = "reload_last2_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Belt5", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload1_nomen"] = {
        Source = "reload_last1_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 202/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Belt6", t = 1.175},
        {s = "Firearms2.M249_Boxremove", t = 1.8},
        {s = "Firearms2.M249_Boxinsert", t = 2.775},
        {s = "Firearms2.M249_Beltpull", t = 3.125},
        {s = "Firearms2.M249_Beltload", t = 3.575},
        {s = "Firearms2.M249_Lidclose", t = 4.15},
		},
    },
    ["reload0_nomen"] = {
        Source = "reload_empty_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 225/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Lidopen", t = 0.5},
        {s = "Firearms2.M249_Charge", t = 1.1},
        {s = "Firearms2.M249_Belt6", t = 1.8},
        {s = "Firearms2.M249_Boxremove", t = 2.3},
        {s = "Firearms2.M249_Boxinsert", t = 3.325},
        {s = "Firearms2.M249_Beltpull", t = 3.7},
        {s = "Firearms2.M249_Beltload", t = 4.175},
        {s = "Firearms2.M249_Lidclose", t = 4.725},
		},
    },
    ["reload_stanag_nomen"] = {
        Source = "reload_stanag_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 89/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M16A2_MagOut", t = 0.625},
        {s = "Firearms2.Magpouch", t = 1.075},
        {s = "Firearms2.M16A2_MagHousing", t = 1.5},
        {s = "Firearms2.M16A2_MagIn", t = 1.65},
		},
    },
    ["reload_empty_stanag_nomen"] = {
        Source = "reload_empty_stanag_nomen",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 120/40,
		SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.M249_Charge", t = 0.25},
        {s = "Firearms2.M16A2_MagOut", t = 1.375},
        {s = "Firearms2.Magpouch", t = 1.8},
        {s = "Firearms2.M16A2_MagHousing", t = 2.25},
        {s = "Firearms2.M16A2_MagIn", t = 2.375},
		},
    },
}

function SWEP:DoShellEject()
    local owner = self:GetOwner()

    if !IsValid(owner) then return end

    local vm = self

    if !owner:IsNPC() then owner:GetViewModel() end

    local att = vm:GetAttachment(self:GetBuff_Override("Override_CaseEffectAttachment") or self.CaseEffectAttachment or 2)

    if !att then return end

    local pos, ang = att.Pos, att.Ang

    local ed = EffectData()
    ed:SetOrigin(pos)
    ed:SetAngles(ang)
    ed:SetAttachment(self:GetBuff_Override("Override_CaseEffectAttachment") or self.CaseEffectAttachment or 2)
    ed:SetScale(1.5)
    ed:SetEntity(self)
    ed:SetNormal(ang:Forward())
    ed:SetMagnitude(100)

    local efov = {}
    efov.eff = "arccw_shelleffect"
    efov.fx  = ed

    if self:GetBuff_Hook("Hook_PreDoEffects", efov) == true then return end

    util.Effect("arccw_shelleffect", ed)

    if not stanag_installed then
        if not self.fisrtfire_starter then

            local att = vm:GetAttachment(3) or att

            local pos, ang = att.Pos, att.Ang

            local ed = EffectData()
            ed:SetOrigin(pos)
            ed:SetAngles(ang)
            ed:SetAttachment(3)
            ed:SetScale(1.5)
            ed:SetEntity(self)
            ed:SetNormal(ang:Forward())
            ed:SetMagnitude(100)

            local efov = {}
            efov.eff = "arccw_firearms2_m27_link"
            efov.fx  = ed

            util.Effect("arccw_firearms2_m27_link", ed)

        else
            self.fisrtfire_starter = false

            local ed = EffectData()
            ed:SetOrigin(pos)
            ed:SetAngles(ang)
            ed:SetAttachment(3)
            ed:SetScale(1.5)
            ed:SetEntity(self)
            ed:SetNormal(ang:Forward())
            ed:SetMagnitude(100)

            local efov = {}
            efov.eff = "arccw_firearms2_m27_starter"
            efov.fx  = ed

            util.Effect("arccw_firearms2_m27_starter", ed)
        end
    end
end

function SWEP:ReloadLinkEject(time)
    timer.Simple(time or 1.8, function()

        if not IsValid(self) then return end

        local owner = self:GetOwner()

        if !IsValid(owner) then return end

        local vm = self

        if !owner:IsNPC() then owner:GetViewModel() end

        local att = vm:GetAttachment(4)

        if !att then return end

        local pos, ang = att.Pos, att.Ang

        local ed = EffectData()
        ed:SetOrigin(pos)
        ed:SetAngles(ang)
        ed:SetAttachment(4)
        ed:SetScale(1.5)
        ed:SetEntity(self)
        ed:SetNormal(ang:Forward())
        ed:SetMagnitude(100)

        local efov = {}
        efov.eff = "arccw_firearms2_m27_link"
        efov.fx  = ed

        if self:GetBuff_Hook("Hook_PreDoEffects", efov) == true then return end

        util.Effect("arccw_firearms2_m27_link", ed)
    end)
end