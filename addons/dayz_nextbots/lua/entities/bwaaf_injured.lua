if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Injured BWAAF"
ENT.Models = {"models/blackwatcharmy_nextbots/bwaaf_soldier_ragdoll.mdl"}

-- Relationships --
ENT.Factions = {"FACTION_BWA"}

-- Movements --
ENT.UseWalkframes = true

ENT.RunAnimation = "crawl_back_new"
ENT.WalkAnimation = "crawl_back_new"
ENT.IdleAnimation = "crawl_idle_new"

if SERVER then

	function ENT:OnContact(ent)
		if string.find( ent:GetClass():lower(), "prop_*" ) or (ent:GetClass() == "func_physbox") or (ent:GetClass() == "func_breakable") or (ent:GetClass() == "func_breakable_surf") then
			if IsValid(ent) then
				local velocity = math.Round(self:GetVelocity():Length())*2
				local forwardvel = Vector(self:GetForward().x,self:GetForward().y,self:GetForward().z)*velocity
					
				if IsValid(ent:GetPhysicsObject()) then
					ent:GetPhysicsObject():EnableMotion( true )
					ent:GetPhysicsObject():SetVelocity(forwardvel)
					ent:TakeDamage( 100, self,self )
				end
			end
		end
		if ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "func_door" then
			if IsValid(ent) then
				ent:Fire('Open')
			end
		end
	end

    function ENT:CustomInitialize()
		self.currentsound = ""
      	self:SetDefaultRelationship(D_FR)
		  self:SetFactionRelationship("FACTION_BWA", D_LI, 99)
		if GetConVar("bwa_friends"):GetBool() then
			self:AddRelationship("player D_LI 99")
		end
		self:SetHealth(999999)
		self.bwa = true
		if not self.model then
			self.model = "models/blackwatcharmy_nextbots/bwaaf_soldier_ragdoll.mdl"
		end
		if not self.class then
			self.class = "bwaaf_soldier"
		end
		self:SetModel(self.model)
		self:ReactInCoroutine(function(self)
			self:PlaySequenceAndMove('stun_fall')
			self.animend = true
			self:SetHealth(75)
			self:PlaySequenceAndMove('crawl_idle_new')
		end)
		local wep = self:GiveWeapon('bwa_pistol')
		self:SetActiveWeapon(wep)
		timer.Simple(math.random(30,45), function()
			if IsValid(self) then
				self:TakeDamage(self:Health())
			end
		end)
    end

	function ENT:Revive()
		local soldier = ents.Create(self.class)
		soldier:SetPos(self:GetPos())
		soldier:SetAngles(self:GetAngles())
		soldier:Spawn()
		BWA:CopyBodygroups(self, soldier)
		self:Remove()
	end

	function ENT:VoiceLine()
		local sounds = "bwaaf/help"..math.random(1,4)..".wav"
		self:StopSound(self.currentsound)
		self:EmitSound(sounds)
		self.currentsound = sounds
	end

	function ENT:CustomThink()
		if self:IsStuck() and self:GetCooldown("stuck") == 0 then
			self:SetCooldown("stuck", 1)
			self:SetPos(self:RandomPos(256,512))
		end
		if self:GetCooldown("blood") == 0 then
			self:SetCooldown("blood", math.Rand(0.75,1))
		end
		if self:GetCooldown("voiceline") == 0 then
			self:SetCooldown("voiceline", math.Rand(5,10))
			self:VoiceLine()
		end
		if IsValid(self:GetEnemy()) and self:GetEnemy():GetPos():Distance(self:GetPos()) < 1024 and self.animend and self:GetCooldown("attack") == 0 then
			self:SetCooldown("attack", math.Rand(0.25,0.75))
			self:PrimaryFire()
		end
		if IsValid(self:GetEnemy()) then
			self:FaceInstant(self:GetEnemy())
		end
		if IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon():Clip1() < 1 and self.animend then
			self:Reload()
		end
	end

	function ENT:OnIdle() end

	function ENT:CallInCoroutineOverride(callback)
		local oldThread = self.BehaveThread
		self.BehaveThread = coroutine.create(function() 
			callback(self) 
			self.BehaveThread = oldThread 
		end)
	end

	function ENT:PrimaryFire()
		if not self:HasWeapon() then return end
		return self:WeaponPrimaryFire("range_pistol")
	end
	
	function ENT:Reload()
		if not self:HasWeapon() or self.melee then return end
		return self:WeaponReload()
	end
end

AddCSLuaFile()
DrGBase.AddNextbot(ENT)