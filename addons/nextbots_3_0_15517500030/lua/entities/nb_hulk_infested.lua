AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_hulk_infested", "Hulk Infested")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_hulk_infested", 	
{	Name = "Hulk Infested", 
	Class = "nb_hulk_infested",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 84
ENT.CollisionSide = 11

ENT.HeadShotMultipler = 2
ENT.HealthAmount = 400

ENT.Speed = 75
ENT.SprintingSpeed = 65
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 40
ENT.MeleeRange = 55
ENT.StopRange = 20

ENT.MeleeDamage = 50
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/zombie/hulk.mdl"

ENT.WalkAnim = ACT_WALK
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.IdleAnim = ACT_IDLE

ENT.MeleeAnim = "melee_01"

ENT.FlinchAnim1 = "FlinchC"
ENT.FlinchAnim2 = "FlinchL"
ENT.FlinchAnim3 = "FlinchR"

--Sounds--
ENT.AttackSounds = {"npc/zombie_poison/pz_warn1.wav", 
"npc/zombie_poison/pz_warn2.wav"}
ENT.AttackSoundPitch = math.random(70,90)

ENT.PainSounds = { "npc/zombie_poison/pz_pain1.wav", 
"npc/zombie_poison/pz_pain2.wav",
"npc/zombie_poison/pz_pain3.wav"}
ENT.PainSoundPitch = math.random(70,90)

ENT.AlertSounds = { "npc/zombie_poison/pz_alert1.wav",
"npc/zombie_poison/pz_alert2.wav"}
ENT.AlertSoundPitch = math.random(70,90)

ENT.DeathSounds = { "npc/zombie_poison/pz_die1.wav",
"npc/zombie_poison/pz_die2.wav"}
ENT.DeathSoundPitch = math.random(70,90)

ENT.IdleSounds = { "npc/zombie_poison/pz_idle2.wav",
"npc/zombie_poison/pz_idle3.wav",
"npc/zombie_poison/pz_idle4.wav"}
ENT.IdleSoundPitch = math.random(70,90)

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"npc/zombie/claw_strike1.wav"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.Enraged = false

	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end

end

function ENT:MovementFunction()

	if !self.Enemy then
		
		self:StartActivity( self.IdleAnim )
		self.loco:SetDesiredSpeed( 0 )
		
	else
	
		self:StartActivity( self.WalkAnim )
		self.loco:SetDesiredSpeed( self.Speed )

	end

end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self:PlayGestureSequence( self.MeleeAnim )
	self.loco:SetDesiredSpeed(0)
	self:PlayAttackSound()
	
	timer.Simple( 0.8, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			local misssound = table.Random( self.MissSounds )
			self:EmitSound( Sound( misssound ), 90, self.MissSoundPitch or 100 )
		
			if self.Flinching then return end
			if self:GetRangeTo( ent ) > self.MeleeRange then return end
		
			self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
	
			if type == nil then
				local hitsound = table.Random( self.HitSounds )
				ent:EmitSound( Sound( hitsound ), 90, self.HitSoundPitch or 100 )
			else
				ent:EmitSound( self.PropHitSound )
			end
	
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 5
			end
	
		end
	end)
	
	timer.Simple( 1.3, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:MovementFunction()
			self.IsAttacking = false
		end
	end)
	
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		--if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		
		local phys = ent:GetPhysicsObject()
		if (phys != nil && phys != NULL && phys:IsValid() ) then
			local knockback = ent:GetVelocity():Length() * 1500
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*(knockback) + Vector(0, 0, 2))
		end
		
		if ( self.NextDamageTimer or 0 ) < CurTime() then
	
			local veh = ent:GetPhysicsObject()
			local dmg = math.Round( (ent:GetVelocity():Length() / 3 + ( veh:GetMass() / 50 ) ), 0 )
		
			if ent:GetOwner():IsValid() then
				self:TakeDamage( dmg, ent:GetOwner() )
			else
				self:TakeDamage( dmg, ent )
			end
		
			self.NextDamageTimer = CurTime() + 0.1
		end
		
	end
	
	if ent != self.Enemy then
		if ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) or ( ent.NEXTBOT and !ent.NEXTBOTZOMBIE ) then
			if ( self.NextMeleeTimer or 0 ) < CurTime() then
				self:Melee( ent, 0, 1 )
				self:SetEnemy( ent )
				self:BehaveStart()
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
		end
	end
	
	self:CustomOnContact2( ent )
	
end

function ENT:HardFlinch( dmginfo, hitgroup )
	
	if ( self.NextFlinchTimer or 0 ) < CurTime() then
	
		local anim = math.random(1,3)
	
		if anim == 1 then
			self:PlayFlinchSequence( self.FlinchAnim1, 1, 0, 0, 0.6 )
		elseif anim == 2 then
			self:PlayFlinchSequence( self.FlinchAnim2, 1, 0, 0, 0.6 )
		elseif anim == 3 then
			self:PlayFlinchSequence( self.FlinchAnim3, 1, 0, 0, 0.6 )
		end
		
		self.NextFlinchTimer = CurTime() + 2	
	end	
	
end

function ENT:OnInjured( dmginfo )

	--1=Zombie,2=Rebel,3=Mercenary,4=Combine
	if self:CheckFriendlyFire( dmginfo:GetAttacker(), 1 ) then 
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

	if !self.Flinching then
		if dmginfo:GetDamage() > 60 then
			self:HardFlinch( dmginfo, hitgroup )
		end
	end
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
end

function ENT:OnKilled( dmginfo )

	self:BecomeRagdoll( dmginfo )
	self:PlayDeathSound()
	
end