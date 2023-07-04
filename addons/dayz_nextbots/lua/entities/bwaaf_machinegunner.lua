if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot_human" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "BWAAF Machinegunner"
ENT.Category = "BlackWatch Army"
ENT.Models = {
  	"models/blackwatcharmy_nextbots/bwaaf_soldier_ragdoll.mdl"
}

-- Relationships --
ENT.Factions = {"FACTION_BWA"}

-- Movements --
ENT.UseWalkframes = true

ENT.ClimbLedges = true
ENT.ClimbLedgesMaxHeight = 96
ENT.LedgeDetectionDistance = 24
ENT.ClimbProps = true
ENT.ClimbLadders = true
ENT.ClimbSpeed = 200
ENT.ClimbAnimRate = 1

ENT.OnDeathSounds = {"bwaaf/pain1.wav", "bwaaf/pain2.wav", "bwaaf/pain3.wav", "bwaaf/pain4.wav"}
ENT.OnDamageSounds = {"bwaaf/pain1.wav", "bwaaf/pain2.wav", "bwaaf/pain3.wav", "bwaaf/pain4.wav"}
ENT.DamageSoundDelay = 0.25

ENT.WeaponAccuracy = 0.1

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
		self:GiveWeapon("bwa_m60")
		self.AvoidEnemyRange = 250
		self.AvoidAfraidOfRange = 250
		self.ReachEnemyRange = 1750
		self.RangeAttackRange = 3000
      	self:SetDefaultRelationship(D_HT)
		if GetConVar("bwa_friends"):GetBool() then
			self:AddRelationship("player D_LI 99")
		end
      	self:SetHealth(math.random(175,225))
      	self:WeaponReload()
		self:SetSkin(math.random(0,12))
		self:SetBodygroup(3, math.random(0,6))
		self:SetBodygroup(5, 0)
		self:SetBodygroup(6, 1)
		self:SetBodygroup(7, 4)
		self:SetBodygroup(8, math.random(0,5))
		self:SetBodygroup(9, 1)
		self:SetBodygroup(10, math.random(0,1))
		self:SetBodygroup(12, math.random(0,1))
		self:SetBodygroup(13, math.random(0,1))
		self:SetBodygroup(14, math.random(0,1))
		self.currentsound = ""
		self.GrenadeCount = math.random(0,1)
		self.bwa = true
		self:SetCooldown("grenades", math.random(15,45))
		self:SetFactionRelationship("FACTION_BWA", D_LI, 99)
    end

	function ENT:CallInCoroutineOverride(callback)
		local oldThread = self.BehaveThread
		self.BehaveThread = coroutine.create(function() 
			callback(self) 
			self.BehaveThread = oldThread 
		end)
	end

	function ENT:DoStun()
		if not self.rolling then
			self.rolling = true
			self:CallInCoroutineOverride(function(self)
				self:PlaySequenceAndMove('stun'..math.random(1,7), math.Rand(1.25,1.50))
				self.rolling = false
			end)
		end
	end

	function ENT:OnTakeDamage(dmg)
		self:SpotEntity(dmg:GetAttacker())
		if dmg:GetDamage() < self:Health() and math.random(1,10) == 1 and not self.rolling and not self.melee then
			self:DoStun()
		end
		if self:Health() > 0 and dmg:GetDamage() >= self:Health() and math.random(1,8) == 1 and not self.laststand then
			self.laststand = true
			dmg:SetDamage(0)
			self:LastStand()
			return 0
		end
		if dmg:GetAttacker().bwa then
			return 0
		end
	end

	function ENT:LastStand()
		local npc = ents.Create('bwaaf_injured')
		npc:SetPos(self:GetPos())
		npc:SetAngles(self:GetAngles())
		npc.model = self:GetModel()
		npc.class = self:GetClass()
		npc:Spawn()
		BWA:CopyBodygroups(self, npc)
		self:Remove()
	end

	function ENT:OnDeath(dmg, hitgroup)
		self:PlaySequenceAndMove('')
		if math.random(1,2) == 1 then
			self.death1 = true
			if hitgroup == 1 and math.random(1,2) == 1 then				
				ParticleEffectAttach("blood_advisor_pierce_spray",PATTACH_POINT_FOLLOW,self,2)
			end
			self:PlaySequenceAndMove('dead'..math.random(1,14))
		end
	end

	function ENT:DropGrenade()
		if not IsValid(self:GetEnemy()) or self.GrenadeCount <= 0 then return end
		self.GrenadeCount = self.GrenadeCount - 1
		self.melee = true
		self:VoiceLine("grenade")
		self:FaceInstant(self:GetEnemy())
		self:CallInCoroutineOverride(function(self)
			timer.Simple(0.5, function()
				if IsValid(self) and IsValid(self:GetEnemy()) then
					local dist = math.Clamp(self:GetEnemy():GetPos():Distance(self:GetPos()), 0, 1024)
					local grenade = ents.Create('proj_drg_grenade')
					grenade:SetPos(self:GetPos()+Vector(0,0,32)+self:GetForward()*32)
					grenade:Spawn()
					grenade:SetVelocity(Vector(0,0,dist/2.25)+self:GetForward()*dist/2)
					grenade:Use(self)
				end
			end)
			self:PlaySequenceAndMove('seq_throw', 1.5)
			self.melee = false
		end)
	end

	function ENT:VoiceLine(type)
		local sounds = ""
		self:StopSound(self.currentsound)
		if type == "idle" then
			sounds = 'bwaaf/idle'..math.random(2,9)..'.wav'
		elseif type == "combat" then
			local rnd = math.random(1,3)
			if rnd == 1 then
				sounds = 'bwaaf/combat'..math.random(1,16)..'.wav'
			elseif rnd == 2 then
				sounds = 'bwaaf/supress'..math.random(1,6)..'.wav'
			elseif rnd == 3 then
				sounds = 'bwaaf/help'..math.random(1,4)..'.wav'
			end
		elseif type == "killed" then
			sounds = 'bwaaf/killed'..math.random(1,4)..'.wav'
		elseif type == "reload" then
			sounds = 'bwaaf/reload'..math.random(1,4)..'.wav'
		elseif type == "grenade" then
			sounds = 'bwaaf/grenade'..math.random(1,2)..'.wav'
		end
		self:EmitSound(sounds)
		self.currentsound = sounds
	end

	function ENT:PrimaryFire()
		if not self:HasWeapon() then return end
		if math.random(1,250) == 1 then
			self:SetCrouching(true)
			timer.Simple(5, function()
				if IsValid(self) then
					self:SetCrouching(false)
				end
			end)
		end
		if math.random(1,250) == 1 then
			self:SetCrouching(true)
			timer.Simple(5, function()
				if IsValid(self) then
					self:SetCrouching(false)
				end
			end)
		end
		return self:WeaponPrimaryFire(self:GetShootAnimation())
	end

	function ENT:OnLost() 
		self:VoiceLine("killed")
	end
	
	function ENT:Reload()
		if not self:HasWeapon() then return end
		if self:GetCooldown("reloading") == 0 and IsValid(self:GetEnemy()) then
			self:SetCooldown("reloading", 5)
			self:VoiceLine("reload")
		end
		if math.random(1,2) == 2 then
			if math.random(1,2) == 1 then
			  	self:Approach(self:GetPos()+self:GetRight()*math.random(128,256))
			else
			  	self:Approach(self:GetPos()-self:GetRight()*math.random(128,256))
			end
		end
		return self:WeaponReload(self:GetReloadAnimation())
	end

	function ENT:CustomThink()
		if self:GetCooldown("voicelinescombat") == 0 and IsValid(self:GetEnemy()) then
			self:SetCooldown("voicelinescombat", math.random(5,20))
			self:VoiceLine("combat")
		end
		if self:GetCooldown("grenades") == 0 and IsValid(self:GetEnemy()) and self:IsInSight(self:GetEnemy()) and not self.melee and not self.rolling and self:GetEnemy():GetPos():DistToSqr(self:GetPos()) > 256^2 and self:GetEnemy():GetPos():DistToSqr(self:GetPos()) < 1024^2 then
			self:SetCooldown("grenades", math.random(10,30))
			self:DropGrenade()
		end
		if self:IsStuck() and self:GetCooldown("stuck") == 0 then
			self:SetCooldown("stuck", 1)
			self:SetPos(self:RandomPos(256,512))
		end
		if not self.stunned and self:GetCooldown("breaking") == 0 then
			self:SetCooldown("breaking", 0.5)
			for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 128)) do
				if ent:GetClass() == "func_breakable" or ent:GetClass() == "func_breakable_surf" then
					ent:Fire('Break')
				elseif ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating" then
					ent:Fire('Open')
				end
			end
		end
		if IsValid(self:GetEnemy()) and not self.melee and not self.death1 then
			local en = self:GetEnemy()
			if en:GetPos():DistToSqr(self:GetPos()) < 96^2 then
				self:MeleeAttacks()
			end
		end
	end

	function ENT:OnIdle()
		self:AddPatrolPos(self:RandomPos(256,512))
		if self:GetCooldown("voicelinesidle") == 0 and not IsValid(self:GetEnemy()) then
			self:SetCooldown("voicelinesidle", math.random(15,45))
			self:VoiceLine("idle")
		end
	end

	function ENT:OnReachedPatrol()
		self:Wait(math.random(3, 7))
	end

	function ENT:MeleeAttacks()
		if not self:GetCooldown("attack") or self.rolling or self.death1 then return end
		if self:GetCooldown("attack") == 0 and IsValid(self:GetEnemy()) then
			local animname = 'melee'..math.random(1,3)
			local animtime = select(2, self:LookupSequence(animname))
			self:SetCooldown("attack", animtime)
			self:FaceInstant(self:GetEnemy())
			self.melee = true
			timer.Simple(animtime/2.1, function()
				if IsValid(self) then
					self:Attack({
						damage = math.random(60,80),
						range = 64,
						type = DMG_SLASH,
						viewpunch = Angle(math.random(-25, 25), math.random(-25, 25), math.random(-25, 25))
					}, function(self, hit)
						if #hit > 0 then
							self:EmitSound("bwa_wep/melee/wep ("..math.random(1,5)..").wav")
						else
							self:EmitSound("Zombie.AttackMiss")
						end
					end)
				end
			end)
			timer.Simple(animtime, function()
				if IsValid(self) then
					self.melee = false
				end
			end)
			self:CallInCoroutineOverride(function(self)
				self:PlaySequenceAndMove(animname)
			end)
		end
	end

	function ENT:AttackEntity(ent)
		local weapon = self:GetWeapon()
		if self.BehaviourType == AI_BEHAV_HUMAN and self:HasWeapon() then
		  if weapon.DrGBase_Melee or string.find(weapon:GetHoldType(), "melee") then
			if self:IsInRange(ent, self.MeleeAttackRange) then
			  if self:OnMeleeAttack(ent, weapon) ~= true  and self.IsDrGNextbotHuman then
				self:FaceTowards(ent)
			  end
			end
		  elseif self:IsInRange(ent, self.RangeAttackRange) then
			if self:OnRangeAttack(ent, weapon) ~= true and self.IsDrGNextbotHuman then
			  if self:IsMoving() then
				self:FaceTowards(ent)
				self:FaceTowards(ent)
			  end
			  if self:IsWeaponPrimaryEmpty() then
				self:Reload()
			  elseif self:IsInSight(ent) then
				local shootPos = self:GetShootPos()
				local tr = util.DrG_TraceHull({
				  start = shootPos, endpos = shootPos + self:GetAimVector()*99999,
				  mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 5),
				  filter = {self, self:GetWeapon(), self:GetPossessor()}
				})
				  local class = weapon:GetClass()
				  if class == "weapon_shotgun" and
				  weapon:Clip1() >= 2 and math.random(3) == 1 then
					self:SecondaryFire()
				  else self:PrimaryFire() end
			  end
			end
		  end
		elseif self:IsInRange(ent, self.MeleeAttackRange) and
		self:OnMeleeAttack(ent, weapon) ~= false then
		elseif self:IsInRange(ent, self.RangeAttackRange) then
		  self:OnRangeAttack(ent, weapon)
		end
	end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)