if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot_human" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "BWAAF Shield"
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
		self:GiveWeapon("bwa_tmp_shield")
		self.AvoidEnemyRange = 100
		self.AvoidAfraidOfRange = 100
		self.ReachEnemyRange = 500
		self.RangeAttackRange = 1000
      	self:SetDefaultRelationship(D_HT)
		if GetConVar("bwa_friends"):GetBool() then
			self:AddRelationship("player D_LI 99")
		end
      	self:SetHealth(math.random(125,150))
      	self:WeaponReload()
		self:SetSkin(math.random(0,12))
		self:SetBodygroup(3, math.random(0,6))
		self:SetBodygroup(8, math.random(0,5))
		self:SetBodygroup(10, math.random(0,1))
		self:SetBodygroup(12, math.random(0,1))
		self:SetBodygroup(13, math.random(0,1))
		self:SetBodygroup(14, math.random(0,1))
		self.currentsound = ""
		self.bwa = true
		self:SetFactionRelationship("FACTION_BWA", D_LI, 99)

		local m = ents.Create('prop_physics')
		m:SetModel("models/bwa_wep/v_shield.mdl")
		m:SetPos(self:GetPos())
		m:Spawn()
		m:GetPhysicsObject():EnableMotion(false)
		m:SetCollisionGroup(1)
		self:DeleteOnRemove(m)
		self.shieldmodel = m
		self:SetNWEntity('shield', m)

		local m = ents.Create('prop_physics')
		m:SetModel("models/hunter/plates/plate075x105.mdl")
		m:SetPos(self:GetPos())
		m:Spawn()
		m:GetPhysicsObject():EnableMotion(false)
		m:SetCollisionGroup(1)
		m:SetNoDraw(true)
		self:DeleteOnRemove(m)
		self.shieldmodel2 = m
    end

	function ENT:CallInCoroutineOverride(callback)
		local oldThread = self.BehaveThread
		self.BehaveThread = coroutine.create(function() 
			callback(self) 
			self.BehaveThread = oldThread 
		end)
	end

	function ENT:OnTakeDamage(dmg)
		self:SpotEntity(dmg:GetAttacker())
		if self:Health() > 0 and dmg:GetDamage() >= self:Health() and math.random(1,8) == 1 and not self.laststand then
			self.laststand = true
			dmg:SetDamage(0)
			self:LastStand()
			return 0
		end
		if math.random(1,2) == 1 and dmg:GetDamage() > 5 then
			self:SetCrouching(true)
			timer.Simple(5, function()
				if IsValid(self) then
					self:SetCrouching(false)
				end
			end)
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
		local offsetVec = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand"))
		local offsetAng = select(2, self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand")))
		offsetAng = Angle(0,offsetAng[2]+100,0)
		local m = ents.Create('prop_physics')
		m:SetModel("models/bwa_wep/v_shield.mdl")
		m:SetPos(offsetVec+offsetAng:Up()*14+offsetAng:Forward()*-3+offsetAng:Right()*-11)
		m:SetAngles(offsetAng)
		m:Spawn()
		m:GetPhysicsObject():EnableMotion(true)
		m:SetCollisionGroup(1)
		timer.Simple(60, function()
			if IsValid(m) then
				m:Remove()
			end
		end)
		self:Remove()
	end

	function ENT:OnDeath(dmg, hitgroup)
		self:PlaySequenceAndMove('')
		local offsetVec = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand"))
		local offsetAng = select(2, self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand")))
		offsetAng = Angle(0,offsetAng[2]+100,0)
		local m = ents.Create('prop_physics')
		m:SetModel("models/bwa_wep/v_shield.mdl")
		m:SetPos(offsetVec+offsetAng:Up()*14+offsetAng:Forward()*-3+offsetAng:Right()*-11)
		m:SetAngles(offsetAng)
		m:Spawn()
		m:GetPhysicsObject():EnableMotion(true)
		m:SetCollisionGroup(1)
		timer.Simple(60, function()
			if IsValid(m) then
				m:Remove()
			end
		end)
		if IsValid(self.shieldmodel) then
			self.shieldmodel:Remove()
		end
		if IsValid(self.shieldmodel2) then
			self.shieldmodel2:Remove()
		end
		if math.random(1,2) == 1 then
			self.death1 = true
			if hitgroup == 1 and math.random(1,2) == 1 then				
				ParticleEffectAttach("blood_advisor_pierce_spray",PATTACH_POINT_FOLLOW,self,2)
			end
			self:PlaySequenceAndMove('dead'..math.random(1,14))
		end
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
		local offsetVec = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand"))
		local offsetAng = select(2, self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand")))
		offsetAng = Angle(0,offsetAng[2]+100,0)
		if self:IsCrouching() then
			offsetAng = Angle(-10,offsetAng[2],0)
			if IsValid(self.shieldmodel) then
				self.shieldmodel:SetPos(offsetVec+offsetAng:Up()*14+offsetAng:Forward()*3+offsetAng:Right()*-11)
				self.shieldmodel:SetAngles(offsetAng)
			end
		else
			if IsValid(self.shieldmodel) then
				self.shieldmodel:SetPos(offsetVec+offsetAng:Up()*14+offsetAng:Forward()*-3+offsetAng:Right()*-11)
				self.shieldmodel:SetAngles(offsetAng)
			end
		end
		offsetAng = Angle(0,offsetAng[2]+90,90)
		if IsValid(self.shieldmodel2) then
			self.shieldmodel2:SetPos(offsetVec+offsetAng:Up()*8+offsetAng:Forward()*18)
			self.shieldmodel2:SetAngles(offsetAng)
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
			local animname = 'seq_meleeattack01'
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
		  if weapon.DrGBase_Melee then
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
	function ENT:PrimaryFire()
		if not self:HasWeapon() then return end
		return self:WeaponPrimaryFire(ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1)
	end
	function ENT:Reload()
		if not self:HasWeapon() then return end
		return self:WeaponReload(ACT_HL2MP_GESTURE_RELOAD_SMG1)
	end
else
	function ENT:Draw()		
		local offsetVec = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand"))
		local offsetAng = select(2, self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_Hand")))
		offsetAng = Angle(0,offsetAng[2]+100,0)
	
		if self:IsCrouching() then
			offsetAng = Angle(-10,offsetAng[2],0)
			if IsValid(self:GetNWEntity('shield')) then
				self:GetNWEntity('shield'):SetPos(offsetVec+offsetAng:Up()*14+offsetAng:Forward()*3+offsetAng:Right()*-11)
				self:GetNWEntity('shield'):SetAngles(offsetAng)
				self:GetNWEntity('shield'):SetupBones()
			end
		else
			if IsValid(self:GetNWEntity('shield')) then
				self:GetNWEntity('shield'):SetPos(offsetVec+offsetAng:Up()*14+offsetAng:Forward()*-3+offsetAng:Right()*-11)
				self:GetNWEntity('shield'):SetAngles(offsetAng)
				self:GetNWEntity('shield'):SetupBones()
			end
		end
	
		self:DrawModel()
	end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)