if not DrGBase then return end -- return if DrGBase isn't installed
SWEP.Base = "drgbase_weapon" -- DO NOT TOUCH (obviously)

-- Misc --
SWEP.PrintName = "MP5"
SWEP.Class = "bwa_mp5"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Slot = 2
SWEP.SlotPos = 0

-- Looks --
SWEP.HoldType = "smg"
SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip = false
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelAngle = Angle(0, 0, 0)
SWEP.UseHands = false
SWEP.WorldModel = "models/bwa_wep/ump45/worldmodel.mdl"
SWEP.WMPos = Vector( -14, -0.5, 3.25)
SWEP.WMAng = Vector(-5, 88, 180)

-- Primary --

-- Shooting
SWEP.Primary.Damage = 10
SWEP.Primary.Bullets = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.11
SWEP.Primary.Recoil = 0.5

-- Ammo
SWEP.Primary.Ammo	= "smg1"
SWEP.Primary.Cost = 1
SWEP.Primary.ClipSize	= 30
SWEP.Primary.DefaultClip = 30

-- Effects
SWEP.Primary.Sound = "bwa_wep/mp5.wav"
SWEP.Primary.EmptySound = "Weapon_AR2.Empty"

if CLIENT then
    function SWEP:DrawWorldModel()      
        wm = ClientsideModel(self.WorldModel)

        if IsValid(wm) then
            if IsValid(self.Owner) then
                pos, ang = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
                    
                if pos and ang then
                    ang:RotateAroundAxis(ang:Right(), self.WMAng[1])
                    ang:RotateAroundAxis(ang:Up(), self.WMAng[2])
                    ang:RotateAroundAxis(ang:Forward(), self.WMAng[3])
    
                    pos = pos + self.WMPos[1] * ang:Right()
                    pos = pos + self.WMPos[2] * ang:Forward()
                    pos = pos + self.WMPos[3] * ang:Up()
    
                    wm:SetRenderOrigin(pos)
                    wm:SetRenderAngles(ang)
                    wm:DrawModel()
                end
            else
                wm:SetRenderOrigin(self:GetPos())
                wm:SetRenderAngles(self:GetAngles())
                wm:DrawModel()
                wm:DrawShadow()
            end
    
            wm:SetupBones()
            wm:Remove()
        else
            self:DrawModel()
        end
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddWeapon(SWEP)