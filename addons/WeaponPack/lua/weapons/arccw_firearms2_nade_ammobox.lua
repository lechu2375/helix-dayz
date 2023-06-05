include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base_nade"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Ammobox"
SWEP.Trivia_Class = "Supplies"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "N/A"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Country = ""

SWEP.UseHands = false

SWEP.WorldModelOffset = {
	pos		=	Vector(12, 9, -1.7),
	ang		=	Angle(0, 70, 180),
	bone	=	"ValveBiped.Bip01_R_Hand",
    scale   =   0.7
}

SWEP.Slot = 1

SWEP.PullPinTime = nil

SWEP.NotForNPCs = true

SWEP.UseHands = false

SWEP.Disposable = true

SWEP.ViewModel = "models/weapons/fas2/view/misc/ammobox.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/misc/ammobox.mdl"
SWEP.ViewModelFOV = 53

SWEP.FuseTime = false

SWEP.Throwing = true
SWEP.BottomlessClip = true -- weapon never has to reload

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "ammoboxes"

SWEP.Firemodes = {
    {
        PrintName = "Throwable",
        Mode = 1,
    }
}

SWEP.MuzzleVelocity = 500
-- SWEP.ShootEntity = "arccw_firearms2_thrown_ammobox"

SWEP.CanBash = false

SWEP.ActivePos = Vector(0, 0, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(0, 0, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        Time = 20/30,
		SoundTable = {
            {s = "Firearms2.Deploy", t = 0},
            {s = "Firearms2.M67_Safety", t = 0.4},
            }, 
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 0/30,
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/30,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 0/30,
    },
    ["throw"] = {
        Source = "throw",
        Time = 15/30,
        SoundTable = {
            {s = "Firearms2.Cloth_Fast", t = 0},
            }, 
    }
}

-- function SWEP:Equip(own)
-- 	own:GiveAmmo(1, "Am")
-- end

-- function SWEP:CanAttack()

--     if self:GetState() == 3 then return end

--     print(self:GetState())

--     return true
-- end

function SWEP:Equip(own)
	own:GiveAmmo(1, "Ammoboxes")
end

function SWEP:PrimaryAttack()	

    am = self.Owner:GetAmmoCount("Ammoboxes")
    
    if am <= 0 then
    	return
    end
    
    CT = CurTime()
    
    if SERVER then
    	dir = self.Owner:EyeAngles()
    	fw = dir:Forward()
        
    	ent = ents.Create("arccw_firearms2_thrown_ammobox")
    	ent:SetPos(self.Owner:GetShootPos() + fw * 30 - dir:Up() * 5)
    	ent:SetAngles(dir)
    	ent:Spawn()
        
    	ent:GetPhysicsObject():SetVelocity(fw * 300)
    end
    
    self:PlayAnimation("throw", 1, false, 0, true)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:TakePrimaryAmmo(1)
    self.MonitorAmmo = CT + 0.6
    self:SetNextPrimaryFire(CT + 1.4)

    if self:Ammo1() > 0 then
        self:SetTimer(self:GetAnimKeyTime("throw"), function()
            self:PlayAnimation("draw", 1, false, 0, true)
        end)
    end

    if self:Ammo1() == 0 then
        timer.Simple(0.4, function()
            if IsValid(self) and IsValid(self:GetOwner()) then
                self:GetOwner():StripWeapon(self:GetClass())
            end
        end)
    end
end

function SWEP:SecondaryAttack()	
	return
end

SWEP.Hook_OnDeploy = function(wep)
    wep:PlayAnimation("draw", 1, false, 0, true)
end

SWEP.Hook_DrawHUD = function(wep)
    FT, CT, x, y = FrameTime(), CurTime(), ScrW(), ScrH()
    
    x2, y2 = math.Round(x * 0.5), math.Round(y * 0.5)
    
    draw.ShadowText(wep.Owner:GetAmmoCount("Ammoboxes") .. "x AMMOBOXES", "ARCCW_FAS2", x / 2, y / 2 + 200, Color(255, 255, 255, wep.CrossAlpha), Color(0, 0, 0, wep.CrossAlpha), 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end