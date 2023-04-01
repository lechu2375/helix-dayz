AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_type1", "Type 1")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_type1", 	
{	Name = "Type 1", 
	Class = "nb_type1",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 80

ENT.Speed = 200
ENT.SprintingSpeed = 200
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 0.4
ENT.LeapDelay = 6

ENT.LeapRange = 600
ENT.ShootRange = 70
ENT.MeleeRange = 45
ENT.StopRange = 20

ENT.MeleeDamage = 2
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/player/zombie_fast.mdl"

ENT.WalkAnim = ACT_HL2MP_RUN_ZOMBIE_FAST
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_06
ENT.RunAnim = ACT_HL2MP_RUN_ZOMBIE_FAST
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_FRENZY 

--Sounds--
ENT.AttackSounds = {"npc/fast_zombie/wake1.wav"}

ENT.PainSounds = {"NPC_FastZombie.Pain"}

ENT.AlertSounds = {"NPC_FastZombie.AlertFar"}

ENT.DeathSounds = {"NPC_FastZombie.Die"}

ENT.IdleSounds = { "npc/fast_zombie/fz_frenzy1.wav",
"npc/fast_zombie/idle1.wav",
"npc/fast_zombie/idle2.wav",
"npc/fast_zombie/idle3.wav"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"npc/zombie/claw_strike1.wav"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.IsLeaping = false
	
	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end

end

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() and self.Enemy then
		
		if self:IsLineOfSightClear( self.Enemy ) and !self.IsAttacking then
		
			if self:GetRangeSquaredTo( self.Enemy ) < self.ShootRange*self.ShootRange then

				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:Melee( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end

			end
			
			if self:GetRangeSquaredTo( self.Enemy ) < 1 then
				self.loco:JumpAcrossGap( self:GetPos() - (self:GetForward()*30), self:GetForward() )
			end
			
			if self:GetRangeSquaredTo( self.Enemy ) < self.LeapRange*self.LeapRange and self:GetRangeSquaredTo( self.Enemy ) > ( (self.ShootRange*self.ShootRange) + 1 ) then

				if ( self.NextLeapTimer or 0 ) < CurTime() then
				
					local selfNAV = navmesh.GetNavArea( self:GetPos(), self.LeapRange + 5 )
					local enemyNAV = navmesh.GetNavArea( self.Enemy:GetPos(), self.LeapRange + 5 )
					local heightdiff = selfNAV:ComputeAdjacentConnectionHeightChange( enemyNAV )
					
					if heightdiff != nil then --dont jump
					
						if heightdiff < ( self.JumpHeight + 60 ) then
						
							self.IsLeaping = true
							self.IsAttacking = true
							self.FacingTowards = self.Enemy
							
							self:EmitSound("npc/fast_zombie/leap1.wav" )
							self:EmitSound("NPC_FastZombie.Scream")
							self:RestartGesture(ACT_ZOMBIE_LEAP_START)
							self.loco:SetDesiredSpeed(50)
					
							timer.Simple( 0.5, function()
								if ( ( self:IsValid() and self:Health() > 0 ) and ( self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
									local jumpfactor = math.Round( math.abs( ( self:GetRangeTo( self.Enemy ) - 250 ) ), 0 )
									if jumpfactor <= 70 then
										jumpfactor = jumpfactor + 80
									end
									self.loco:JumpAcrossGap( self.Enemy:GetPos() + (self:GetForward()*jumpfactor), self:GetForward() )
									self:StartActivity(ACT_ZOMBIE_LEAPING)
								end
							end)
					
						end
						
						self.NextLeapTimer = CurTime() + self.LeapDelay
						
					end
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

function ENT:CustomOnContact2( ent )

	self:AttackProp( ent )

	if self.IsLeaping then
		if ent:IsPlayer() or ( ent.NEXTBOT and !ent.NEXTBOTZOMBIE ) then
			local dmgAmount = math.random( self.MeleeDamage, self.MeleeDamage + 1 )
			local dmginfo = DamageInfo()
				dmginfo:SetAttacker( self )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( dmgAmount )
				dmginfo:SetDamageType( self.MeleeDamageType )
				dmginfo:SetDamageForce( self.MeleeDamageForce )
		
			ent:TakeDamageInfo( dmginfo )
			
			local hitsound = table.Random( self.HitSounds )
			ent:EmitSound( Sound( hitsound ), 90, self.HitSoundPitch or 100 )
	
			if !IsValid( ent ) then return end
	
			if ent:IsPlayer() then
				local viewpunch = ( Angle(math.random(-2, 2)*dmgAmount, math.random(-2, 2)*dmgAmount, math.random(-2, 2)*dmgAmount) )
				ent:ViewPunch( viewpunch )
				ent:SetVelocity( self.MeleeDamageForce )
			end
		end
	end

end

function ENT:OnLandOnGround()

	self.IsJumping = false
	
	if self.IsLeaping then
		self.IsLeaping = false
		self.IsAttacking = false
		
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 5 )
		self:TakeDamageInfo(dmginfo)
	end
	
	self:MovementFunction()
	
end

function ENT:MeleeDamageTimer( ent, type, time )
	timer.Simple( time, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then

			if self:GetRangeSquaredTo( ent ) > self.MeleeRange*self.MeleeRange then return end
		
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
end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self:RestartGesture( self.MeleeAnim )
	
	self:MeleeDamageTimer( ent, type, 0.2 )
	self:MeleeDamageTimer( ent, type, 0.35 )
	
	timer.Simple( 0.39, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
		end
	end)
	
end

function ENT:OnKilled( dmginfo )

	self:BecomeRagdoll( dmginfo )
	self:PlayDeathSound()
	
end