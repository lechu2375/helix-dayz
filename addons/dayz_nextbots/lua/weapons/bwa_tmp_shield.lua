if not DrGBase then return end -- return if DrGBase isn't installed
SWEP.Base = "drgbase_weapon" -- DO NOT TOUCH (obviously)

-- Misc --
SWEP.PrintName = "TMP Shield"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Slot = 2
SWEP.SlotPos = 0

-- Looks --
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip = false
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelAngle = Angle(0, 0, 0)
SWEP.UseHands = false
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

-- Primary --

-- Shooting
SWEP.Primary.Damage = 8
SWEP.Primary.Bullets = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.11
SWEP.Primary.Recoil = 0.25

-- Ammo
SWEP.Primary.Ammo	= "pistol"
SWEP.Primary.Cost = 1
SWEP.Primary.ClipSize	= 30
SWEP.Primary.DefaultClip = 30

-- Effects
SWEP.Primary.Sound = "bwa_wep/mp5.wav"
SWEP.Primary.EmptySound = "Weapon_AR2.Empty"

function SWEP:ShootBullet(damage, num_bullets, aimcone)
	local bullet = {}
    local ent = self.Owner
	bullet.Num = num_bullets
	bullet.Src = ent:GetShootPos()+ent:GetForward()*8+ent:GetRight()*8-ent:GetUp()*8
	bullet.Dir = ent:GetAimVector()
	bullet.Spread = Vector(aimcone, aimcone, 0)
	bullet.Tracer	= 1
	bullet.Force = damage/10
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(ent, tr, dmg)
		dmg:SetAttacker(ent)
		dmg:SetInflictor(self)
	end
	ent:FireBullets(bullet)
	self:ShootEffects()
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddWeapon(SWEP)