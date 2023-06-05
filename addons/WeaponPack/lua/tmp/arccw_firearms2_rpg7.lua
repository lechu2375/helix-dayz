include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Slot = 4

SWEP.PrintName = "RPG-7"
SWEP.Trivia_Class = "Rocket-Propelled Grenade Launcher"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Bazalt"
SWEP.Trivia_Calibre = "40MM"
SWEP.Trivia_Country = "Soviet Union"
SWEP.Trivia_Year = "1958"

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/explosives/rpg7.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/explosives/rpg7.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultSkin = 0

SWEP.Damage = 0
SWEP.DamageMin = 0 -- damage done at maximum range
SWEP.Range = 250 -- in METRES
SWEP.Penetration = 20
SWEP.ShootEntity = "arccw_firearms2_rpg7rocket_fly" -- entity to fire, if any
SWEP.MuzzleVelocity = 120000

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.

SWEP.Recoil = 5.5
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.4
SWEP.RecoilPunch = 0
SWEP.VisualRecoilMult = 0
SWEP.RecoilVMShake = 0

SWEP.Delay = 0.1 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "Tube",
    },
}

SWEP.NotForNPCS = true

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 200 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150 -- inaccuracy added by moving. Applies in sights as well! Walking speed is considered as "maximum".
SWEP.SightsDispersion = 0 -- dispersion that remains even in sights
SWEP.JumpDispersion = 300 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "rpg7_rocket" -- what ammo type the gun uses
SWEP.MagID = "" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootPitchVariation = 0

SWEP.ShootSound = "Firearms2_RPG7"
SWEP.ShootDrySound = "" -- Add an attachment hook for Hook_GetShootDrySound please!
SWEP.DistantShootSound = "fas2/distant/rpg26.ogg"

SWEP.MuzzleEffect = "muzzleflash_shotgun"

SWEP.ShellModel = "models/weapons/arccw/fas2/explosives/w_m79_grenade_shell.mdl"
SWEP.ShellScale = 1
SWEP.ShellSounds = ArcCW.Firearms2_Casings_Heavy
SWEP.ShellPitch = 100
SWEP.ShellTime = 1 -- add shell life time

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.65
SWEP.SightedSpeedMult = 0.55

SWEP.IronSightStruct = {
    Pos = Vector(-2.815, -6, -1.82),
    Ang = Angle(1.2, 0, 0),
    Magnification = 1.1,
    SwitchToSound = {"fas2/weapon_sightraise.wav", "fas2/weapon_sightraise2.wav"}, -- sound that plays when switching to this sight
    SwitchFromSound = {"fas2/weapon_sightlower.wav", "fas2/weapon_sightlower2.wav"},
}

SWEP.SightTime = 0.5

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "rpg"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG

SWEP.CanBash = false

SWEP.ActivePos = Vector(-0.4, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(0, 0, 0)
SWEP.CrouchAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, 0, 0)
SWEP.SprintAng = Angle(-10, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.CustomizePos = Vector(3.824, 0, -2.297)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelLength = 35

SWEP.Animations = {
    ["idle"] = false,
    -- ["ready"] = {
    --     Source = "first_draw",
    --     Time = 169/25,
    --     SoundTable = {
    --     {s = "Firearms2.Cloth_Movement", t = 0},
    --     {s = "Firearms2.M24_Back", t = 1.5},
    --     {s = "Firearms2.M24_Back", t = 2.5}
    --     },
    -- },
    ["draw"] = {
        Source = "draw",
        Time = 36/30,
		SoundTable = {
        {s = "Firearms2.Deploy", t = 0},
        },
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 36/30,
		SoundTable = {
        {s = "Firearms2.Deploy", t = 0},
        },
    },
    ["holster"] = {
        Source = "holster",
        Time = 31/30,
        SoundTable = {
        {s = "Firearms2.Holster", t = 0},
        },
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 31/30,
        SoundTable = {
        {s = "Firearms2.Holster", t = 0},
        },
    },
    ["fire"] = {
        Source = "fire1",
        Time = 147/130,
    },
    ["reload"] = {
        Source = "reload",
        Time = 181/30,
        SoundTable = {
        {s = "Firearms2.Cloth_Movement", t = 0},
        {s = "Firearms2.RPG7_Load1", t = 2},
        {s = "Firearms2.Cloth_Movement", t = 2},
        {s = "Firearms2.RPG7_Load2", t = 2.9},
        {s = "Firearms2.Cloth_Movement", t = 2.9},
        },
    },
}

function SWEP:FireRocket(ent, vel, ang)
    if CLIENT then return end

    local rocket = ents.Create(ent)

    ang = ang or self:GetOwner():EyeAngles()

    local src = self:GetShootSrc()

    if !rocket:IsValid() then print("!!! INVALID ROUND " .. ent) return end

    local EA =  self.Owner:EyeAngles()
    src = src + EA:Right() * 5 - EA:Up() * 2 + EA:Forward() * 8

    rocket:SetAngles(ang)
    rocket:SetPos(src)

    rocket:SetOwner(self:GetOwner())
    rocket.Inflictor = self

    rocket:Spawn()
    rocket:Activate()
    rocket:GetPhysicsObject():SetVelocity(self:GetOwner():GetAbsVelocity())
    rocket:GetPhysicsObject():SetVelocityInstantaneous(ang:Forward() * vel)
    rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)

    if rocket.ArcCW_Killable == nil then
        rocket.ArcCW_Killable = true
    end

    rocket.ArcCWProjectile = true

    return rocket
end