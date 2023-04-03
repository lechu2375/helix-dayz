AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_zombine", "Infested Combine")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_zombine", 	
{	Name = "Infested Combine", 
	Class = "nb_zombine",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 400

ENT.Speed = 45
ENT.SprintingSpeed = 165
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 60
ENT.MeleeRange = 70
ENT.StopRange = 20

ENT.MeleeDamage = 30
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.SprintingAnim = ACT_RUN

ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

--Sounds--
ENT.AttackSounds = {"nextbots/zombine/attack1.wav", 
"nextbots/zombine/attack2.wav"}

ENT.PainSounds = {"nextbots/zombine/pain1.wav", 
"nextbots/zombine/pain2.wav",
"nextbots/zombine/pain3.wav",
"nextbots/zombine/flinch1.wav",
"nextbots/zombine/flinch2.wav"}

ENT.AlertSounds = {"nextbots/zombine/idle1.wav",
"nextbots/zombine/idle2.wav",
"nextbots/zombine/idle3.wav",
"nextbots/zombine/idle4.wav"}

ENT.DeathSounds = {"nextbots/zombine/death1.wav",
"nextbots/zombine/death2.wav",
"nextbots/zombine/death3.wav"}

ENT.IdleSounds = {"nextbots/zombine/idle1.wav",
"nextbots/zombine/idle2.wav",
"nextbots/zombine/idle3.wav",
"nextbots/zombine/idle4.wav"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"npc/zombie/claw_strike1.wav"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.Enraged = false
	self.PulledGrenade = false
	
	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end

	local walkanims = { ACT_HL2MP_WALK_ZOMBIE_01, ACT_HL2MP_WALK_ZOMBIE_02, ACT_HL2MP_WALK_ZOMBIE_03, ACT_HL2MP_WALK_ZOMBIE_04, ACT_WALK }
	self.WalkAnim = table.Random( walkanims )
	
	--PrintTable( self:GetSequenceList() )
	
	self.move_ang = Angle()
	self.loco:SetMaxYawRate( 180 )
	
	--Sometimes ACT ID of run_all_grenade changes, use this line to make sure it always uses correct ACT ID for the sequence
	self.SprintingAnim2 = ( self:GetSequenceActivity( self:LookupSequence("run_all_grenade") ) )
	
end

function ENT:EquipWeapon()

	local nade = ents.Create( "ent_melee_weapon" )
	nade:SetOwner(self)
    nade:SetPos( self:GetPos())
    nade:SetParent(self)
	nade:SetModelScale(1, 0)
    nade:Spawn()
    nade:Fire("setparentattachment", "Anim_Attachment_LH")
	nade:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	nade:SetModel( "models/weapons/w_grenade.mdl" )
	self.NadeModel = nade
	
end

function ENT:GrenadeTimer()
	timer.Simple( 4, function()
		if !( IsValid( self ) and self:Health() > 0 ) then return end
		if SERVER then
			local explode = ents.Create("env_explosion")
			explode:SetPos( self:GetPos() + Vector(0,0,30) + (self:GetRight()*5) )
			explode:Spawn()
			explode:SetKeyValue( "iMagnitude", 0 )
			explode:SetOwner( self )	
			explode:Fire( "Explode", 1, 0 )	
					
			local ents = ents.FindInSphere( self:GetPos(), 150 )
			for _,v in pairs(ents) do
				local dmg = DamageInfo()

				if v != self then
					dmg:SetAttacker( self )
					dmg:SetInflictor( self )
					dmg:SetDamage( 300 )
					dmg:SetDamageType( DMG_BLAST )
					v:TakeDamageInfo( dmg )
				end	
					
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
				end
			end
				
			SafeRemoveEntity( self.NadeModel )		
			self:TakeDamage( ( self:Health() + 1 )*5, self )
		end
	end)
end

function ENT:RunBehaviour()

	if self.Enraged then
		self.EnrageAnimation = true
		if math.random(1,3) == 1 then
			self:EquipWeapon()
			self:PlaySequenceAndWait("pullgrenade",1)
			print("nade")
			self.PulledGrenade = true
			self:GrenadeTimer()
			self:MovementFunction()
		else
			self:PlaySequenceAndWait("taunt_zombie_original",1)
		end
		self.MeleeDamage = self.MeleeDamage + 15
		self.MeleeRange = self.MeleeRange - 10
		self.EnrageAnimation = false
	end

	self:OnSpawn()

	while ( true ) do

		if self:HaveEnemy() and self:CheckEnemyStatus( self.Enemy ) then
				
				pos = self:GetEnemy():GetPos()

				if ( pos ) then
					
					self:MovementFunction()
						
					local enemy = self:GetEnemy()
					local maxageScaled=math.Clamp(pos:Distance(self:GetPos())/1000,0.1,3)	
					local opts = {	lookahead = 30,
							tolerance = 20,
							draw = false,
							maxage = maxageScaled 
							}
						
					self:ChaseEnemy( opts )
						
				end

					
		else
				
			coroutine.wait( 1 )	
			self:MovementFunction()
					
		end
			
		self:PlayIdleSound()
			
		coroutine.yield()
			
	end
		
end

function ENT:BodyMoveYaw() --BodyYaw function from Nextbot Chase Demo

	local my_ang = self:GetAngles()
	local my_vel = self.loco:GetGroundMotionVector()
	
	if my_vel:IsZero() or self.loco:GetVelocity():IsZero() then 
	return end
	
	local move_ang = my_vel:Angle()
	local ang_dif = move_ang - my_ang
	ang_dif:Normalize()

	self.move_ang = LerpAngle( 0.9, ang_dif, self.move_ang )
	
	self:SetPoseParameter( "move_yaw", self.move_ang.yaw )
	
end

function ENT:BodyUpdate()

	if ( self:GetActivity() == self.WalkAnim ) then

		self:BodyMoveXY()

	elseif ( self:GetActivity() == self.SprintingAnim or self:GetActivity() == self.SprintingAnim2 ) then
			
		self:BodyMoveYaw()
		self:FrameAdvance()
			
	end
	
end

function ENT:MovementFunction()

	if self.Enemy then

		if self.Enraged then
		
			if self.PulledGrenade then
				self:StartMovementAnim( self.SprintingAnim2, self.SprintingSpeed, 1 )
			else
				self:StartMovementAnim( self.SprintingAnim, self.SprintingSpeed, 1 )
			end
			
		else

			self:StartMovementAnim( self.WalkAnim, self.Speed, 1 )
			
		end
	
	else
	
		if ( self.NextIdleAnimTimer or 0 ) < CurTime() then
			self:StartActivity( ACT_IDLE )
			self.loco:SetDesiredSpeed( 0 )
			self.NextIdleAnimTimer = CurTime() + 2
		end
	
	end
	
end

function ENT:MeleeDamageTimer( ent, type, time, reset )
	timer.Simple( time, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			if self.Flinching then return end
			if self.EnrageAnimation then return end
			
			local misssound = table.Random( self.MissSounds )
			self:EmitSound( Sound( misssound ), 90, self.MissSoundPitch or 100 )
			
			if self:GetRangeSquaredTo( ent ) > (self.MeleeRange*self.MeleeRange) then return end
		
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
				ent.Hitsleft = ent.Hitsleft - 1
			end
	
		end
	end)
	
	timer.Simple( reset, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
			self:MovementFunction()
		end
	end)
end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end
	if self.Flinching then return end
	if self.EnrageAnimation then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self:PlayAttackSound()
	
	if self.Enraged then
		self:RestartGesture( self.MeleeAnim )
		self:MeleeDamageTimer( ent, type, 0.85, 1.3 )
	else
		self:PlayGestureSequence( "fastattack", 1 )
		self.loco:SetDesiredSpeed( 0 )
		self:MeleeDamageTimer( ent, type, 0.4, 0.85 )
	end
	
end

function ENT:OnRemove()
	SafeRemoveEntity( self.NadeModel )
end

function ENT:OnKilled( dmginfo )
	print("death")
	SafeRemoveEntity( self.NadeModel )
	self:BecomeRagdoll( dmginfo )
	self:PlayDeathSound()
	hook.Run( "OnNPCKilled",self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
end

function ENT:Flinch( dmginfo, hitgroup )
	
	if ( self.NextFlinchTimer or 0 ) < CurTime() then
		
		if hitgroup == HITGROUP_HEAD then
			self:PlayGestureSequence( "flinch_head_0"..math.random(1,2) )
		elseif hitgroup == HITGROUP_RIGHTARM then
			self:PlayGestureSequence( "flinch_shoulder_r" )
		elseif hitgroup == HITGROUP_LEFTARM then
			self:PlayGestureSequence( "flinch_shoulder_l" )
		elseif hitgroup == HITGROUP_CHEST then
			self:PlayGestureSequence( "flinch_phys_0"..math.random(1,2) )
		elseif hitgroup == ( HITGROUP_GEAR or HITGROUP_STOMACH ) then
			self:PlayGestureSequence( "flinch_stomach_0"..math.random(1,2) )
		elseif hitgroup == ( HITGROUP_RIGHTLEG or HITGROUP_LEFTLEG ) then
			self:PlayGestureSequence( "flinch_0"..math.random(1,2) )
		end	
		
		if !self.Enraged then
			self.loco:SetDesiredSpeed( self.Speed / 2 )
			
			timer.Simple( 0.14, function()
				if ( IsValid(self) and self:Health() > 0) then
					self.loco:SetDesiredSpeed(self.Speed)
				end
			end)
		end
		
		self.NextFlinchTimer = CurTime() + 0.15
	end
	
end

function ENT:OnInjured( dmginfo )

	if self:CheckFriendlyFire( dmginfo:GetAttacker() ) and ( dmginfo:GetAttacker() != self ) then 
		dmginfo:ScaleDamage(0)
	return end
	
	self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
	dmginfo:ScaleDamage( 0.5 )
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
	if !self.Enraged then
		if self:Health() < (self.HealthAmount/2) then
			if !self.IsAttacking and !self.Flinching and !self.EnrageAnimation then
				self.Enraged = true
				self:BehaveStart()
			end
		else
			if !self.Flinching and !self.EnrageAnimation then
				if dmginfo:GetDamage() > 35 then
					self:HardFlinch( dmginfo, hitgroup )
				else
					self:Flinch( dmginfo, hitgroup )
				end
			end
		end
	else
		self:Flinch( dmginfo, hitgroup )
	end

end