if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot_human" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "CDF Guard"
ENT.Category = "DayZ"
ENT.Models = {
  	"models/easterncrisis/cdf_infantry_mask.mdl",
	"models/easterncrisis/cdf_infantry.mdl"
}

-- Relationships --
ENT.Factions = {"FACTION_CDF"}

-- Movements --
ENT.UseWalkframes = true

ENT.ClimbLedges = true
ENT.ClimbLedgesMaxHeight = 96
ENT.LedgeDetectionDistance = 24
ENT.ClimbProps = true
ENT.ClimbLadders = true
ENT.ClimbSpeed = 200
ENT.ClimbAnimRate = 1
ENT.Guard = true
ENT.OnDeathSounds = {"gmodz/npc/military/death_1.ogg","gmodz/npc/military/death_2.ogg","gmodz/npc/military/death_3.ogg","gmodz/npc/military/death_4.ogg","gmodz/npc/military/death_5.ogg"}

ENT.OnDamageSounds = {"gmodz/npc/military/hit_1.ogg","gmodz/npc/military/hit_2.ogg","gmodz/npc/military/hit_3.ogg","gmodz/npc/military/hit_4.ogg","gmodz/npc/military/hit_5.ogg","gmodz/npc/military/hit_6.ogg"}
ENT.DamageSoundDelay = 0.25

ENT.WeaponAccuracy = 0.14

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
		local weptab = {
			"arccw_firearms2_g3",
			"arccw_firearms2_galil",
			"arccw_firearms2_ak101",
			"arccw_firearms2_ak104",
            "arccw_firearms2_rem870",
            "arccw_firearms2_uzi"
		}
		self:GiveWeapon(weptab[math.random(1,#weptab)])
		self.AvoidEnemyRange = 500
		self.AvoidAfraidOfRange = 500
      	self:SetDefaultRelationship(D_HT)
		if GetConVar("bwa_friends"):GetBool() then
			self:AddRelationship("player D_LI 99")
		end
		self:SetHealth(math.random(100,125))
      	self:WeaponReload()
		self:SetSkin(math.random(0,12))
        local bodygroups = self:GetBodyGroups()
        for _,v in pairs(bodygroups) do
			if(v.name =="Trousers") then
				self:SetBodygroup(v.id, math.random(0, v.num-2)) //because third bodygroup has no model
			else
            	self:SetBodygroup(v.id, math.random(0, v.num-1))
			end
        end
		self.currentsound = ""
		self.GrenadeCount = math.random(0,2)
		self.FollowTarget = nil
		self.cdf = true
		self.Covering = false
		self.Cover_Side_left = false
		self.Cover_Pos = nil
		self.Cover_Pos_Valid = false
		self.Covering_Anim = false
		self:SetCooldown("cover", math.random(GetConVar("bwa_cover_system_min_delay"):GetFloat(),GetConVar("bwa_cover_system_max_delay"):GetFloat()))
		self:SetCooldown("cover_state", 1)
		self:SetCooldown("grenades", math.random(15,45))
		self:SetFactionRelationship("FACTION_CDF", D_LI, 99)
		self:SetFactionRelationship("FACTION_CIVIL", D_NU, 50)
		self:SetFactionRelationship("FACTION_BANDITS", D_HT, 99)
        self.SpawnPoint = self:GetPos()
    end

	function ENT:CallInCoroutineOverride(callback)
		local oldThread = self.BehaveThread
		self.BehaveThread = coroutine.create(function() 
			callback(self) 
			self.BehaveThread = oldThread 
		end)
	end

	function ENT:CheckAngleEnemy()
		local target = self:GetEnemy()
		if !IsValid(target) then return 0 end

		local vec = ( self:GetPos() - target:GetPos() ):GetNormal():Angle().y
		local targetAngle = target:GetAngles().y
		
		if targetAngle > 360 then
			targetAngle = targetAngle - 360
		end
		if targetAngle < 0 then
			targetAngle = targetAngle + 360
		end
		
		local angleAround = vec - targetAngle
		
		if angleAround > 360 then
			angleAround = angleAround - 360
		end
		if angleAround < 0 then
			angleAround = angleAround + 360
		end

		return angleAround
	end

	function ENT:GoToCoverPos()
		local hd_pos = {}
		for _, p in ipairs(self:FindSpots({'hiding', self:GetPos(), 256, 16, 16})) do
			local rands = Vector(math.random(-32,32),math.random(-32,32),0)
			if not self:GetEnemy():VisibleVec(p.vector+rands) then
				table.insert(hd_pos, p.vector+rands)
			end
		end
		if #hd_pos < 1 then
			self.Covering = false 
			return 
		end
		if not self.Cover_Pos_Valid then
			self.Cover_Pos = hd_pos[math.random(1,#hd_pos)]
			self.Cover_Pos_Valid = true
		end
		if self.Covering then
			self:ReactInCoroutine(self.GoTo, self.Cover_Pos, 15)
		end
	end

	function ENT:GoToCoverPos()
		local hd_pos = self:FindSpot( "near", {'hiding', self:GetPos(), 256, 16, 16} )
		if not isvector(hd_pos) then
			self.Covering = false 
			return 
		end
		if not self.Cover_Pos_Valid then
			self.Cover_Pos = hd_pos+Vector(math.random(-64,64),math.random(-64,64),0)
			self.Cover_Pos_Valid = true
		end
		if self.Covering then
			self:ReactInCoroutine(self.GoTo, self.Cover_Pos, 15)
		end
	end

	function ENT:CheckCoverAnim()			
		local en = self:GetEnemy()
		if self:IsInSight(en) or not self.Covering then return end
		local tr_f = util.DrG_TraceLine({
			start = self:GetPos()+Vector(0,0,24),
			endpos = self:GetPos()+Vector(0,0,24)+self:GetForward()*48,
			filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end
		})
		local tr_b = util.DrG_TraceLine({
			start = self:GetPos()+Vector(0,0,24),
			endpos = self:GetPos()+Vector(0,0,24)-self:GetForward()*48,
			filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end
		})
		local tr_r = util.DrG_TraceLine({
			start = self:GetPos()+Vector(0,0,24),
			endpos = self:GetPos()+Vector(0,0,24)+self:GetRight()*48,
			filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end
		})
		local tr_l = util.DrG_TraceLine({
			start = self:GetPos()+Vector(0,0,24),
			endpos = self:GetPos()+Vector(0,0,24)-self:GetRight()*48,
			filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end
		})
		local ang = Angle(0,0,0)
		local towall = self:GetForward()*10
		if tr_f.Hit then
			ang = tr_f.HitNormal:Angle()
			towall = self:GetForward()*10
		elseif tr_b.Hit then
			ang = tr_b.HitNormal:Angle()
			towall = -self:GetForward()*10
		elseif tr_r.Hit then
			ang = tr_r.HitNormal:Angle()
			towall = self:GetRight()*10
		elseif tr_l.Hit then
			ang = tr_l.HitNormal:Angle()
			towall = -self:GetRight()*10
		end
		if not tr_f.Hit and not tr_b.Hit and not tr_l.Hit and not tr_r.Hit and not isvector(self.Cover_Pos) and self:GetPos():DistToSqr(self.Cover_Pos) > 64^2 then return end
		if self.Covering_Anim then
			self:SetAngles(ang)
			local tr_wall = util.DrG_TraceLine({
				start = self:GetPos()+Vector(0,0,24),
				endpos = self:GetPos()+Vector(0,0,24)+towall,
				filter = self
			})
			if not tr_wall.Hit then
				self:SetPos(self:GetPos()+towall/5)
			end
		end
		if self:CheckAngleEnemy() > 0 and self:CheckAngleEnemy() < 180 then
			self:ReactInCoroutine(function()
				self:PlaySequenceAndMove('cover_right')
			end)
		else
			self:ReactInCoroutine(function()
				self:PlaySequenceAndMove('cover_left')
			end)
		end
	end

	function ENT:CoverThink()
		if not GetConVar("bwa_enable_cover_system"):GetBool() then return end
		local en = self:GetEnemy()
		if !IsValid(en) then
			self.Covering = false
			self.Cover_Pos_Valid = false
			self.Cover_Pos = nil
		end
		self:CheckCoverAnim()
		if self:GetCooldown("cover") == 0 and IsValid(en) then
			self.Covering = true
			self:SetCrouching(false)
			self:SetCooldown("cover", math.random(GetConVar("bwa_cover_system_min_delay"):GetFloat(),GetConVar("bwa_cover_system_max_delay"):GetFloat()))
			self:GoToCoverPos()
		end
		if self:GetSequence() == self:LookupSequence('cover_left') or self:GetSequence() == self:LookupSequence('cover_right') then
			self.Covering_Anim = true
		else
			self.Covering_Anim = false
		end
		if self.Covering and not self.Covering_Anim then
			self:SetCooldown("cover_state", math.random(5,15))
		end
		if self:GetCooldown("cover_state") == 0 and self.Covering_Anim then
			self.Covering = false
			self.Cover_Pos_Valid = false
			self.Cover_Pos = nil
		end
	end

	function ENT:Follow(target)
		if self.FollowTarget then return end
		self.FollowTarget = target
		self:VoiceLine('follow') 
		self:AddPatrolPos(self:GetPos())
		table.insert(target.guards, self)
	end

	function ENT:Roll()
		if self.rolling or self.melee or self.death1 then return end
		self.rolling = true
		self:CallInCoroutineOverride(function(self)
			timer.Simple(0.5, function()
				if IsValid(self) then
					self:EmitSound('physics/body/body_medium_impact_hard'..math.random(1,6)..'.wav')
				end
			end)
			if math.random(1,2) == 1 then
				self:PlaySequenceAndMove('roll_left', 2)
			else
				self:PlaySequenceAndMove('roll_right', 2)
			end
			self.rolling = false
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
        self:AlertAllies(dmg:GetAttacker(), false)
		self:SetCooldown("cover", self:GetCooldown("cover")-1*dmg:GetDamage()/10)
		if self.Covering and self.Covering_Anim then
			self.Covering = false
			self.Cover_Pos_Valid = false
		end
		if dmg:GetDamage() < self:Health() and math.random(1,10) == 1 and not self.rolling and not self.melee then
			self:Roll()
		end
		if dmg:GetDamage() < self:Health() and math.random(1,20) == 1 and not self.rolling and not self.melee then
			self:DoStun()
		end
		if self:Health() > 0 and dmg:GetDamage() >= self:Health() and math.random(1,8) == 1 and not self.laststand then
			/*self.laststand = true
			dmg:SetDamage(0)
			self:LastStand()
			return 0*/
		end
		if dmg:GetAttacker().cdf then
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
			sounds = 'gmodz/npc/military/idle_'..math.random(1,28)..'.ogg'
		elseif type == "combat" then
			local rnd = math.random(1,2)
			if rnd == 1 then
				sounds = 'gmodz/npc/military/detour_'..math.random(1,17)..'.ogg'
            else 
				sounds = 'gmodz/npc/military/help_'..math.random(1,6)..'.ogg'
			end
		elseif type == "killed" then
			sounds = 'gmodz/npc/military/tolls_'..math.random(1,4)..'.ogg'
		elseif type == "reload" then
			sounds = ""
		elseif type == "grenade" then
			sounds = 'gmodz/npc/military/grenade_'..math.random(1,3)..'.ogg'
		elseif type == "follow" then
			sounds = 'gmodz/npc/military/search_'..math.random(1,5)..'.ogg'
		end
		//print(type,sounds)
		self:EmitSound(sounds,90)
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
			if math.random(1,4) == 1 then
				self:Roll()
			end
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
		if(self:IsCrouching()) then
			self.WeaponAccuracy = self.WeaponAccuracyBase*.86
		else
			self.WeaponAccuracy = self.WeaponAccuracyBase
		end
		self:CoverThink()
		if IsValid(self.FollowTarget) then
			self:ReactInCoroutine(function(self)
				self:FollowPath(self.FollowTarget, 64)
			end)
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
				if math.random(1,4) == 1 then
					self.rolling = true
					self.melee = true
					self:CallInCoroutineOverride(function(self)
						if self:IsInSight(self:GetEnemy()) then
							self:PlaySequenceAndMove('roll_backward', 1.5)
						else
							self:PlaySequenceAndMove('roll_forward', 2.5)
						end
						self.rolling = false
						self.melee = false
					end)
				else
					self:MeleeAttacks()
				end
			end
		end
	end

	function ENT:OnIdle()
		if not IsValid(self.FollowTarget) then
            local pos = self:GetPos()
           // print(pos:Distance(self.SpawnPoint))
            if(pos:Distance(self.SpawnPoint)>2000) then
                self:AddPatrolPos(self.SpawnPoint)
            else
			    self:AddPatrolPos(self:RandomPos(256,512))
            end
		end
		if self:GetCooldown("voicelinesidle") == 0 and not IsValid(self:GetEnemy()) then
			self:SetCooldown("voicelinesidle", math.random(15,45))
			self:VoiceLine("idle")
		end
	end

	function ENT:OnReachedPatrol()
		if not IsValid(self.FollowTarget) then
			self:Wait(math.random(3, 7))
		end
	end

	function ENT:MeleeAttacks()
		if true then return end
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
						damage = math.random(40,60),
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