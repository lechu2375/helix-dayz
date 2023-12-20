AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_ghoul", "Ghoul")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_ghoul", 	
{	Name = "Ghoul", 
	Class = "nb_ghoul",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 50
ENT.SprintingSpeed = 50
ENT.FlinchWalkSpeed = 25
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 200
ENT.DecelerationAmount = 900

ENT.JumpHeight = 58
ENT.StepHeight = 35
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 140
ENT.MeleeRange = 40
ENT.StopRange = 20

ENT.MeleeDamage = 25
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/player/corpse1.mdl"

ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

--Sounds--
ENT.AttackSounds = {"npc/fast_zombie/leap1.wav"}
ENT.AttackSoundPitch = math.random(110,130)

ENT.PainSounds = {"npc/zombie_poison/pz_warn1.wav",
"npc/zombie_poison/pz_warn2.wav"}
ENT.PainSoundPitch = math.random(132,148)

ENT.AlertSounds = {""}

ENT.DeathSounds = {""}

ENT.IdleSounds = {"npc/fast_zombie/fz_alert_close1.wav"}
ENT.IdleSoundPitch = math.random(70,80)

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"Flesh.ImpactHard"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end

	local walkanims = { ACT_HL2MP_WALK_ZOMBIE_01, ACT_HL2MP_WALK_ZOMBIE_02, ACT_HL2MP_WALK_ZOMBIE_03, ACT_HL2MP_WALK_ZOMBIE_04 }
	self.WalkAnim = table.Random( walkanims )

end

function ENT:Flesh( amount, velocity, angle, pos )
	
	if !self:IsValid() then return end
	
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))	
	
	for i=1,amount do
	
		local flesh = ents.Create("nb_projectile_base") 
		
		if flesh:IsValid() then
			flesh:SetPos( pos )
			flesh:SetOwner( self )
			flesh:Spawn()
	
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-angle, angle))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-angle, angle))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( velocity, velocity + math.random(200,300) ) )
			end	
			
		end	
		
	end
		
end

function ENT:TossFlesh( ent )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self:RestartGesture( self.MeleeAnim )
		
	timer.Simple(0.8, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:Flesh( math.random(4,6), 400, 10, self:GetPos() + Vector(0,0,50) )
		end
	end)
	
	timer.Simple(1.3, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
		end
	end)
	
end

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() and self:CheckEnemyStatus( self.Enemy ) then
		
		if self.Enemy:IsPlayer() then
		
			if ( ( self:GetRangeTo( self.Enemy ) < self.ShootRange and self:GetRangeTo( self.Enemy ) > self.MeleeRange + 1 ) and self:IsLineOfSightClear( self.Enemy ) ) then

				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:TossFlesh( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end

			end
		
			if ( self:GetRangeTo( self.Enemy ) < self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then
		
				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:Melee( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end
		
			end
			
		elseif self.Enemy.NEXTBOT then
		
			if ( self:GetRangeTo( self.Enemy ) < self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then
		
				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:Melee( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end
		
			end
		
		end
			
		if self.IsAttacking then
			if self.FacingTowards:IsValid() and self.FacingTowards:Health() > 0 then
				self.loco:FaceTowards( self.FacingTowards:GetPos() )
			end
		end
			
	end
	
end

function ENT:EmitFlesh( amount, velocity, angle, pos )

	if ( self.NextFlesh or 0 ) < CurTime() then	

		self:Flesh( amount, velocity, angle, pos )

		self.NextFlesh = CurTime() + 4
	end
		
end

function ENT:OnInjured( dmginfo )

	if self:CheckFriendlyFire( dmginfo:GetAttacker() ) then 
		dmginfo:ScaleDamage(0)
	return end

	if ( dmginfo:IsBulletDamage() ) then

		local attacker = dmginfo:GetAttacker()
	
			local trace = {}
			trace.start = attacker:EyePos()

			trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
			trace.mask = MASK_SHOT
			trace.filter = attacker
		
			local tr = util.TraceLine( trace )
			hitgroup = tr.HitGroup
			
			if hitgroup == ( HITGROUP_LEFTLEG or HITGROUP_RIGHTLEG ) then
				dmginfo:ScaleDamage(0.45)	
			end

			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage( self.HeadShotMultipler or 8)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end

	end
	
	self:Flinch( dmginfo, hitgroup )
	
	self:EmitFlesh( math.random(2,3), math.random(150,200), 105, self:GetPos() + Vector(0,0,50) )
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
end