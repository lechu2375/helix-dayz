if not DrGBase then return end -- return if DrGBase isn't installed
SWEP.Base = "drgbase_weapon" -- DO NOT TOUCH (obviously)

-- Misc --
SWEP.PrintName = "Glock"
SWEP.Class = "bwa_pistol"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Slot = 2
SWEP.SlotPos = 0

-- Looks --
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip = false
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelAngle = Angle(0, 0, 0)
SWEP.UseHands = false
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

-- Primary --

-- Shooting
SWEP.Primary.Damage = 10
SWEP.Primary.Bullets = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.25
SWEP.Primary.Recoil = 0.5

-- Ammo
SWEP.Primary.Ammo	= "pistol"
SWEP.Primary.Cost = 1
SWEP.Primary.ClipSize	= 17
SWEP.Primary.DefaultClip = 17

-- Effects
SWEP.Primary.Sound = "bwa_wep/pistol.wav"
SWEP.Primary.EmptySound = "Weapon_AR2.Empty"

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddWeapon(SWEP)