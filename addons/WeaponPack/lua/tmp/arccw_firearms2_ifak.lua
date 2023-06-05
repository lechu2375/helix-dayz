include("arccw_firearms2_functions.lua")

SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Firearms: Source 2" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Infantry First Aid Kit"
SWEP.Trivia_Class = "Supplies"
SWEP.Trivia_Desc = "IFAK is a personal medical kit issued to soldiers in service. The official first aid kit in the U.S. Marine Corps IFAK (Individual First Aid Kit of the United States Marine Corps)."
SWEP.Trivia_Manufacturer = ""
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Country = "US"
SWEP.Trivia_Year = nil

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/fas2/view/misc/ifak.mdl"
SWEP.WorldModel = "models/weapons/fas2/world/misc/ifak.mdl"
SWEP.ViewModelFOV = 53

SWEP.WorldModelOffset = {
    pos = Vector(1.5, 5, 0),
    ang = Angle(-40, 90, 180)
}

SWEP.PrimaryBash = true

SWEP.Primary.Ammo = nil

SWEP.MeleeDamage = 0
SWEP.MeleeRange = 0
SWEP.MeleeDamageType = 0
SWEP.MeleeTime = 0
SWEP.MeleeGesture = nil
SWEP.MeleeAttackTime = 0

SWEP.Melee2 = true
SWEP.Melee2Damage = 0
SWEP.Melee2Range = 0
SWEP.MeleeDamageType = 0
SWEP.Melee2Time = 0
SWEP.Melee2Gesture = nil
SWEP.Melee2AttackTime = 0

SWEP.MeleeSwingSound = nil
SWEP.MeleeMissSound = nil
SWEP.MeleeHitSound = nil
SWEP.MeleeHitNPCSound = nil

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "Medkit"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "slam"

SWEP.Primary.ClipSize = -1

SWEP.AttachmentElements = {
    ["camo"] = {
        VMBodygroups = {{ind = 0, bg = 1}},
        WMBodygroups = {{ind = 0, bg = 1}},
    },
}

SWEP.Attachments = {
    {
        PrintName = "Skin",
        DefaultAttName = "Desert Khaki",
        Slot = "fas2_ifak_skin",
    },
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 20/30,
		SoundTable = {
		{s = "Firearms2.IFAK_Zipper", t = 0},
		{s = "Firearms2.Cloth_Movement", t = 0}
        },
    },
    ["holster"] = {
        Source = "holster",
        Time = 20/30,
        SoundTable = {{s = "Firearms2.Holster", t = 0}},
    },
    ["bandage"] = {
        Source = "bandage",
        Time = 75/30,
		SoundTable = {
        {s = "Firearms2.IFAK_BandageRetrieve", t = 0.37},
        {s = "Firearms2.IFAK_BandageOpen", t = 1.24}
        },
    },
    ["bandage_end"] = {
        Source = "bandage_end",
        Time = 15/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["suture"] = {
        Source = "suture",
        Time = 120/30,
		SoundTable = {
        {s = "Firearms2.IFAK_HemostatRetrieve", t = 0.24},
        {s = "Firearms2.IFAK_HemostatClose", t = 3.5}
        },
    },
    ["suture_end"] = {
        Source = "suture_end",
        Time = 30/30,
		SoundTable = {{s = "Firearms2.IFAK_HemostatRetrieve", t = 0.4}},
    },
    ["quikclot"] = {
        Source = "quikclot",
        Time = 120/30,
		SoundTable = {
        {s = "Firearms2.IFAK_QuikclotRetrieve", t = 0.27},
        {s = "Firearms2.IFAK_QuikclotLoosen", t = 1.47},
        {s = "Firearms2.IFAK_QuikclotOpen", t = 2.47}
        },
    },
    ["quikclot_end"] = {
        Source = "quikclot_end",
        Time = 15/30,
		SoundTable = {{s = "Firearms2.Deploy", t = 0}},
    },
    ["tourniquet"] = {
        Source = "tourniquet",
        Time = 65/30,
		SoundTable = {
        {s = "Firearms2.IFAK_QuikclotRetrieve", t = 0.4},
        {s = "Firearms2.Cloth_Movement", t = 0.85},
        {s = "Firearms2.IFAK_Hands_Off", t = 1.3}
        },
    },
    ["tourniquet_end"] = {
        Source = "tourniquet_end",
        Time = 15/30,
    },
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0.4, 0, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(0, 0, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)



SWEP.EasterWait = 0

local nade, EA, pos, mag, CT, tr, force, phys, pos, vel, ent, dmg, tr2, am
local td = {}

function SWEP:Reload()
	if self.Owner:KeyDown(IN_USE) then
		CT = CurTime()
		
		if CT > self.EasterWait then
			
			self:EmitSound("fas2/ifak/radio_request_medic" .. math.random(1, 6) .. ".wav", 80, 100)
			self.EasterWait = CT + SoundDuration("fas2/ifak/radio_request_medic" .. math.random(1, 6) .. ".wav") + 0.4
		end
	end
end

function SWEP:Equip(own)
	own:GiveAmmo(2, "Bandages")
	own:GiveAmmo(1, "Quikclots")
	own:GiveAmmo(2, "Hemostats")
	own:GiveAmmo(1, "Tourniquets")
end

SWEP.Hook_ModifyBodygroups = function(wep, data)
    local vm = data.vm

	cvar = GetConVarNumber("arccw_fas2_handrig")

	if GetConVar("arccw_fas2_handrig"):GetBool() then vm:SetBodygroup(1, cvar) end

    if CLIENT then
		RunConsoleCommand("arccw_fas2_handrig_applynow")
	end

    bd = wep.Owner:GetAmmoCount("Bandages")
	
	if bd > 0 then
		if bd == 1 then
			vm:SetBodygroup(2, 1)
		elseif bd >= 2 then
			vm:SetBodygroup(2, 2)
		end
	else
		bd = wep.Owner:GetAmmoCount("Tourniquets")
		
		if bd > 0 then
			vm:SetBodygroup(4, 0)
		else
			vm:SetBodygroup(4, 1)
		end
	end

    am = wep.Owner:GetAmmoCount("Hemostats")
	
	if am > 0 then
		if am == 1 then
			vm:SetBodygroup(3, 2)
		elseif am >= 2 then
			vm:SetBodygroup(3, 3)
		end
	else
		am = wep.Owner:GetAmmoCount("Quikclots")
		
		if am > 0 then
			vm:SetBodygroup(3, 1)
		else
			vm:SetBodygroup(3, 0)
		end
	end
end

SWEP.Hook_Think = function(wep, anim)
    CT = CurTime()
	if not wep.CurrentHeal then
		-- if CLIENT then
		-- 	wep:SetUpBodygroups()
		-- end
	else
		if CT >= wep.HealTime then
			if wep.OwnHeal then
				wep:EndSelfHealingProcess()
			else
				wep:EndHealingProcess()
			end
		end
	end
end

local Mins, Maxs = Vector(-8, -8, -8), Vector(8, 8, 8)

function SWEP:FindHealTarget()
	td.start = self.Owner:GetShootPos()
	td.endpos = td.start + self.Owner:GetAimVector() * 50
	td.filter = self.Owner
	td.mins = Mins
	td.maxs = Maxs
	
	tr = util.TraceHull(td)
	
	if tr.Hit then
		ent = tr.Entity
		
		if IsValid(ent) and ent:IsPlayer() then
			return ent
		end
	end
	
	return self.Owner
end

function SWEP:HealTarget(amt)
	self.Target:SetHealth(math.Clamp(self.Target:Health() + amt, 0, self.Target:GetMaxHealth()))
end

function SWEP:PrimaryAttack()	
	if not IsFirstTimePredicted() then
		return
	end

	ab = self.Owner:GetAmmoCount("Bandages")
	
	if ab > 0 then
		self.Target = self:FindHealTarget()
		
		if CLIENT then
			if self.Target:Health() >= 100 then
				return
			end
		else
			if self.Target:Health() >= self.Target:GetMaxHealth() then
				return
			end
		end
		
		CT = CurTime()
		self:SetNextPrimaryFire(CT + 2.5)
		self:SetNextSecondaryFire(CT + 2.5)
		self.HealTime = CT + 2.5
		self.CurrentHeal = "bandage"
		self.AmmoType = "Bandages"
		
		if SERVER and SP then
			self.Owner:SendLua("LocalPlayer():GetActiveWeapon().HealTime = CurTime() + 2.5")
		end
		
		if self.Target != self.Owner then
			if SERVER then
				self:HealTarget(10)
			end
			
			self.OwnHeal = false
		else
			self.HealAmount = 10
			self.OwnHeal = true
		end
		
        self:PlayAnimation("bandage", 1, true, 0, true)
	else
		ab = self.Owner:GetAmmoCount("Tourniquets")
		
		if ab > 0 then
			self.Target = self:FindHealTarget()
			
			if CLIENT then
				if self.Target:Health() >= 100 then
					return
				end
			else
				if self.Target:Health() >= self.Target:GetMaxHealth() then
					return
				end
			end
			
			CT = CurTime()
			self:SetNextPrimaryFire(CT + 2.17)
			self:SetNextSecondaryFire(CT + 2.17)
			self.HealTime = CT + 2.17
			self.CurrentHeal = "tourniquet"
			self.AmmoType = "Tourniquets"
			
			if SERVER and SP then
				self.Owner:SendLua("LocalPlayer():GetActiveWeapon().HealTime = CurTime() + 2.17")
			end
	
			self.Target = self:FindHealTarget()

			-- if self.CurrentHeal == "tourniquet" and self.Owner:GetAmmoCount("Tourniquets") == 1 and self.Target != self.Owner then
			-- 	return
			-- end
			
			if self.Target != self.Owner then

				if SERVER then
					self:HealTarget(15)
				end
		
				self.OwnHeal = false
			else
				self.HealAmount = 15
				self.OwnHeal = true
			end
			
            self:PlayAnimation("tourniquet", 1, true, 0, true)
		end
	end
end

function SWEP:SecondaryAttack()	
	if not IsFirstTimePredicted() then
		return
	end
	
	am = self.Owner:GetAmmoCount("Hemostats")
	
	if am > 0 then
		self.Target = self:FindHealTarget()
		
		if CLIENT then
			if self.Target:Health() >= 100 then
				return
			end
		else
			if self.Target:Health() >= self.Target:GetMaxHealth() then
				return
			end
		end
		
		CT = CurTime()
		self:SetNextPrimaryFire(CT + 4)
		self:SetNextSecondaryFire(CT + 4)
		self.HealTime = CT + 4
		self.CurrentHeal = "suture"
		self.AmmoType = "Hemostats"
		
		if SERVER and SP then
			self.Owner:SendLua("LocalPlayer():GetActiveWeapon().HealTime = CurTime() + 4")
		end
		
		if self.Target != self.Owner then
			if SERVER then
				self:HealTarget(30)
			end
			
			self.OwnHeal = false
		else
			self.HealAmount = 30
			self.OwnHeal = true
		end
		
        self:PlayAnimation("suture", 1, true, 0, true)
	else
		am = self.Owner:GetAmmoCount("Quikclots")
		
		if am > 0 then
			self.Target = self:FindHealTarget()
			
			if CLIENT then
				if self.Target:Health() >= 100 then
					return
				end
			else
				if self.Target:Health() >= self.Target:GetMaxHealth() then
					return
				end
			end
			
			CT = CurTime()
			self:SetNextPrimaryFire(CT + 4)
			self:SetNextSecondaryFire(CT + 4)
			self.HealTime = CT + 4
			self.CurrentHeal = "quikclot"
			self.AmmoType = "Quikclots"
			
			if SERVER and SP then
				self.Owner:SendLua("LocalPlayer():GetActiveWeapon().HealTime = CurTime() + 4")
			end
	
			self.Target = self:FindHealTarget()
			
			if self.Target != self.Owner then
				if SERVER then
					self:HealTarget(20)
				end
		
				self.OwnHeal = false
			else
				self.HealAmount = 20
				self.OwnHeal = true
			end
			
            self:PlayAnimation("quikclot", 1, true, 0, true)
		end
	end
end

function SWEP:EndSelfHealingProcess()
	if self.CurrentHeal == "suture" and self.Owner:GetAmmoCount("Hemostats") == 1 then
        self:PlayAnimation("bandage_end", 1, true, 0, true)
	else
        self:PlayAnimation(self.CurrentHeal .. "_end", 1, true, 0, true)
	end
	
	self.Owner:RemoveAmmo(1, self.AmmoType)
	
	-- if CLIENT then
	-- 	self:SetUpBodygroups()
	-- end
	
	if SERVER then
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + self.HealAmount, 0, self.Owner:GetMaxHealth()))
	end
	
	self.CurrentHeal = nil
	self.HealTime = nil
	self.HealAmount = nil
end

function SWEP:EndHealingProcess()
	if self.CurrentHeal == "suture" and self.Owner:GetAmmoCount("Hemostats") == 1 then
        self:PlayAnimation("bandage_end", 1, true, 0, true)
	else
        self:PlayAnimation(self.CurrentHeal .. "_end", 1, true, 0, true)
	end
	
	self.Owner:RemoveAmmo(1, self.AmmoType)
	
	-- if CLIENT then
	-- 	self:SetUpBodygroups()
	-- end
	
	self.CurrentHeal = nil
	self.HealTime = nil
	self.OwnHeal = false
end

if CLIENT then
	local x, y, x2, y2, pos, ang
	local White, Black, Grey, Red, Green = Color(255, 255, 255, 255), Color(0, 0, 0, 255), Color(200, 200, 200, 255), Color(255, 137, 119, 255), Color(202, 255, 163, 255)
	
	-- function SWEP:Draw3D2DCamera()

    --     local vm = wep:GetOwner():GetViewModel()
		
	-- 	pos, ang = vm:GetBonePosition(vm:LookupBone("Dummy97"))
	-- 	ang:RotateAroundAxis(ang:Up(), 90)
	-- 	ang:RotateAroundAxis(ang:Right(), 5)
		
	-- 	cam.Start3D2D(pos + ang:Right() * -3.8 - ang:Forward() * 3.5, ang, 0.015 * GetConVarNumber("fas2_textsize"))
	-- 		am = self.Owner:GetAmmoCount("Bandages")
	-- 		draw.ShadowText("BANDAGES: " .. am, "FAS2_HUD48", -40, 0, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			
	-- 		if am > 0 then
	-- 			draw.ShadowText("LMB - APPLY BANDAGE", "FAS2_HUD36", -40, -40, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 			draw.ShadowText("+10 HP", "FAS2_HUD24", -40, -60, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 		end
	-- 	cam.End3D2D()
		
	-- 	pos, ang = vm:GetBonePosition(vm:LookupBone("Dummy98"))
	-- 	ang:RotateAroundAxis(ang:Up(), 90)
		
	-- 	cam.Start3D2D(pos + ang:Right() * -3.5 + ang:Forward(), ang, 0.015 * GetConVarNumber("fas2_textsize"))
	-- 		am = self.Owner:GetAmmoCount("Hemostats")
			
	-- 		if am > 0 then
	-- 			draw.ShadowText("HEMOSTATS: " .. am, "FAS2_HUD48", -20, 0, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 			draw.ShadowText("RMB - APPLY HEMOSTAT", "FAS2_HUD36", -20, -40, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 			draw.ShadowText("+30 HP", "FAS2_HUD24", -20, -60, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 		else
	-- 			am = self.Owner:GetAmmoCount("Quikclots")
				
	-- 			draw.ShadowText("QUIKCLOTS: " .. am, "FAS2_HUD48", -20, 0, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				
	-- 			if am > 0 then
	-- 				draw.ShadowText("RMB - APPLY QUIKCLOT", "FAS2_HUD36", -20, -40, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 				draw.ShadowText("+20 HP", "FAS2_HUD24", -20, -60, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- 			end
	-- 		end
	-- 	cam.End3D2D()
	-- end

SWEP.Hook_DrawHUD = function(wep, anim)

        FT, CT, x, y = FrameTime(), CurTime(), ScrW(), ScrH()
        x2, y2 = math.Round(x * 0.5), math.Round(y * 0.5)

        wep.Target = wep:FindHealTarget()
            
        if wep.Target then
            draw.ShadowText("HEAL TARGET: " .. (wep.Target != wep.Owner and wep.Target:Nick() or " SELF"), "ARCCW_FAS2", x / 2, y / 2 + 200, Color(255, 255, 255, wep.CrossAlpha), Color(0, 0, 0, wep.CrossAlpha), 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.ShadowText("HEAL TARGET: SELF", "ARCCW_FAS2", x / 2, y / 2 + 200, Color(255, 255, 255, wep.CrossAlpha), Color(0, 0, 0, wep.CrossAlpha), 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        
        ab = wep.Owner:GetAmmoCount("Bandages")
        
        if ab > 0 then
            draw.ShadowText("BANDAGES: " .. ab, "ARCCW_FAS2", x2 - 100, y2 + 125, White, Black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
            draw.ShadowText("LMB - APPLY BANDAGE", "ARCCW_FAS2", x2 - 100, y2 + 100, Green, Black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
            draw.ShadowText("+10 HP", "ARCCW_FAS2", x2 - 100, y2 + 75, Green, Black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
        else
            ab = wep.Owner:GetAmmoCount("Tourniquets")
            
            draw.ShadowText("TOURNIQUETS: " .. ab, "ARCCW_FAS2", x2 - 100, y2 + 125, White, Black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
            
            if ab > 0 then
                draw.ShadowText("RMB - APPLY TOURNIQUET", "ARCCW_FAS2", x2 - 100, y2 + 100, Green, Black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
                draw.ShadowText("+15 HP", "ARCCW_FAS2", x2 - 100, y2 + 75, Green, Black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
            end
        end
        
        am = wep.Owner:GetAmmoCount("Hemostats")
        
        if am > 0 then
            draw.ShadowText("HEMOSTATS: " .. am, "ARCCW_FAS2", x2 + 100, y2 + 125, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            draw.ShadowText("RMB - APPLY HEMOSTAT", "ARCCW_FAS2", x2 + 100, y2 + 100, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            draw.ShadowText("+30 HP", "ARCCW_FAS2", x2 + 100, y2 + 75, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        else
            am = wep.Owner:GetAmmoCount("Quikclots")
            
            draw.ShadowText("QUIKCLOTS: " .. am, "ARCCW_FAS2", x2 + 100, y2 + 125, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            
            if am > 0 then
                draw.ShadowText("RMB - APPLY QUIKCLOT", "ARCCW_FAS2", x2 + 100, y2 + 100, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                draw.ShadowText("+20 HP", "ARCCW_FAS2", x2 + 100, y2 + 75, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            end
        end
    end
end






