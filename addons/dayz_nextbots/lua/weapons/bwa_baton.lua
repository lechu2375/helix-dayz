if not DrGBase then return end -- return if DrGBase isn't installed
SWEP.Base = "drgbase_weapon" -- DO NOT TOUCH (obviously)

-- Misc --
SWEP.PrintName = "Baton"
SWEP.Class = "bwa_baton"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Slot = 2
SWEP.SlotPos = 0

-- Looks --
SWEP.HoldType = "melee"
SWEP.ViewModelFOV	= 0
SWEP.ViewModelFlip = false
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelAngle = Angle(0, 0, 0)
SWEP.UseHands = false
SWEP.WorldModel = "models/bwa_wep/baton.mdl"

-- Primary --

-- Shooting
SWEP.Primary.Damage = 0
SWEP.Primary.Bullets = 0
SWEP.Primary.Spread = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0
SWEP.Primary.Recoil = 0

-- Ammo
SWEP.Primary.Ammo	= ""
SWEP.Primary.Cost = 0
SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip = -1

-- Effects
SWEP.Primary.Sound = ""
SWEP.Primary.EmptySound = ""

SWEP.WMPos = Vector( -4, 1, -6)
SWEP.WMAng = Vector(-0, -90, 0)

if CLIENT then
    function SWEP:DrawWorldModel()
        PrintTable(self:GetAttachments())       
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
                    wm:SetBodygroup(8,2)
                    wm:DrawModel()
                end
            else
                wm:SetBodygroup(8,2)
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