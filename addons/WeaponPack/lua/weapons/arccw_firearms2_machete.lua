include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Machete"
SWEP.Trivia_Class = "Knife"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = ""
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = ""
SWEP.Trivia_Country = ""
SWEP.Trivia_Year = nil

SWEP.Slot = 0

SWEP.ItemData = {
    width = 1,
    height = 1,
    JamCapacity = 200,
    DegradeRate = 0.02,
    price = 200,
    rarity = { weight = 30 },
    iconCam = {
        pos = Vector(0, 200, 0),
        ang = Angle(-1.33, 270.01, 0),
        fov = 13
    }
}

SWEP.NotForNPCs = true

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/melee/machete.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/melee/machete.mdl"
SWEP.ViewModelFOV = 60

SWEP.WorldModelOffset = {
    pos = Vector(3, 0.5, 0),
    ang = Angle(-150, -180, 0)
}

SWEP.PrimaryBash = true

SWEP.Primary.Ammo = nil

SWEP.MeleeDamage = 40
SWEP.MeleeRange = 4
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeTime = 0.7
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MeleeAttackTime = 0.1

SWEP.Melee2 = true
SWEP.Melee2Damage = 80
SWEP.Melee2Range = 4
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Melee2Time = 0.75
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Melee2AttackTime = 0.1

SWEP.MeleeSwingSound = ""
SWEP.MeleeMissSound = ""
SWEP.MeleeHitSound = "fas2/melee/knife_hitworld1.wav"
SWEP.MeleeHitNPCSound = {"fas2/melee/knife_hit1.wav", "fas2/melee/knife_hit2.wav", "fas2/melee/knife_hit3.wav"}

-- SWEP.Backstab = true
-- SWEP.BackstabMultiplier = 2

SWEP.NotForNPCs = true

-- SWEP.Delay = 5
SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "knife"

SWEP.Primary.ClipSize = -1

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 30/30,
        SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/30,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["bash"] = {
        Source = {"slash1", "slash2"},
        Time = 30/40,
        SoundTable = {{s = "fas2/machete/machete1.wav", "fas2/machete/machete2.wav", "fas2/machete/machete3.wav", t = 0}}
    },
    ["bash2"] = {
        Source = "overhead",
        Time = 30/40,
        SoundTable = {{s = "fas2/machete/machete1.wav", "fas2/machete/machete2.wav", "fas2/machete/machete3.wav", t = 0}}
    },
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 0, 1)

SWEP.CustomizePos = Vector(0, 0, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)