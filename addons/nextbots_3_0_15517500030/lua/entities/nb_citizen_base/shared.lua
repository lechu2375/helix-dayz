if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_revive_players = GetGlobalBool("nb_revive_players")

local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

ENT.Base = "nb_vehicle_hit_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 180
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.ShootRange = 300
ENT.MeleeRange = 60
ENT.StopRange = 200

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.WalkAnim = ACT_HL2MP_RUN_SHOTGUN  
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40 
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnim = "range_melee_shove_2hand"

function ENT:Initialize()

	if SERVER then
		self:CustomInitialize()
	
		self.loco:SetDeathDropHeight( self.MaxDropHeight )	
		self.loco:SetAcceleration( self.AccelerationAmount )		
		self.loco:SetDeceleration( self.DecelerationAmount )
		self.loco:SetStepHeight( self.StepHeight )
		self.loco:SetJumpHeight( self.JumpHeight )
	
		self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
		self.FriendlyToPlayers = true
		self.NEXTBOTFACTION = 'NEXTBOTREBEL'
		self.NEXTBOTREBEL = true
		self.NEXTBOT = true
		
		--Status
		self.StuckAttempts = 0
		self.TotalTimesStuck = 0
		self.IsJumping = false
		self.HitByVehicle = false
		self.FollowingPlayer = false
		self.EntityFollowing = nil
		self.TouchedDoor = false
		self.InPanic = false
		self.Waving = false
		self.WavingTo = nil
		self.GoingToRevive = false
		self.RevivingEntity = nil
	end
	
	if CLIENT then
		self.FriendlyToPlayers = true
		self.NEXTBOTFACTION = 'NEXTBOTREBEL'
		self.NEXTBOTREBEL = true
		self.NEXTBOT = true
	end
	
end

function ENT:CollisionSetup( collisionside, collisionheight, collisiongroup )
	self:SetCollisionGroup( collisiongroup )
	self:SetCollisionBounds( Vector(-collisionside,-collisionside,0), Vector(collisionside,collisionside,collisionheight) )
	--self:PhysicsInitShadow(true, false)
end

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel( "" )
		self:SetHealth( self.HealthAmount )
	end
	
end

function ENT:Alive()
	if self:Health() > 0 then return true
	end
end

function ENT:CheckValid()
	if self:IsValid() then return true
	end
	if self:Alive() then return true
	end
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		self.HitByVehicle = true
		
		local veh = ent:GetPhysicsObject()
		local dmg = math.Round( (ent:GetVelocity():Length() / 3 + ( veh:GetMass() / 50 ) ), 0 )
		
		if ent:GetOwner():IsValid() then
			self:TakeDamage( dmg, ent:GetOwner() )
		end
		
		self:VehicleHit( ent, "nb_rise_base", self:GetClass(), "combine_pistol", ( self:Health() - dmg ), true )
	end

	self:CustomOnContact2( ent )

end

function ENT:WaveToFriendly( ent )

	if ( self.NextWaveTimer or 0 ) < CurTime() then

		if ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) ) or ( ent.NEXTBOT and ( !ent.NEXTBOTZOMBIE and !ent.NEXTBOTMERCENARY ) ) then
			
			local entforward = ent:GetForward()
			local forward = self:GetForward() 
					
			if entforward:Distance( forward ) > 1 then
				--Contacted from front

				self:EmitSound( Sound( table.Random( self.WavingSounds ) ) )
				
				self.Waving = true
				self.WavingTo = ent
				
				if math.random(1,5) == 1 then
					self:SetSequence( "gesture_wave_original" )
				elseif math.random(1,5) == 2 then
					self:SetSequence( "gesture_bow_original" )
				elseif math.random(1,5) == 3 then
					self:SetSequence( "gesture_salute_original" )
				elseif math.random(1,5) == 4 then
					self:SetSequence( "gesture_agree_original" )
				elseif math.random(1,5) == 5 then
					self:SetSequence( "gesture_disagree_original" )
				end
	
				self:SetCycle(0)
				self:SetPlaybackRate(1)
	
				timer.Simple( 1.9, function()
					if IsValid( self ) and self:Health() > 0 then
						self.Waving = false
						self.WavingTo = nil
						self:MovementFunction()
					end
				end)
				
			end
	
		end
		
		self.NextWaveTimer = CurTime() + 3
	end

end

function ENT:CustomOnContact2( ent )

	if !self.InPanic then
	
		if ent.NEXTBOT or ent:IsPlayer() then
			if ent.NEXTBOT and ent.InPanic then
				self:StartPanic( self )
			else
				if !self.GoingToRevive then
					self:WaveToFriendly( ent )
				end
			end
		end
		
	else
	
		if ent.NEXTBOT and !ent.InPanic then
			self:StartPanic( self )
		end
		
	end
	
	self:AttackProp( ent )
	
	if !self.TouchedDoor then
		self:ContactDoor( ent, 1 )
	end
	
end

function ENT:AttackProp( ent )

	if ( ent:GetClass() == "func_breakable" || ent:GetClass() == "func_physbox" || ent:GetClass() == "prop_physics_multiplayer" || ent:GetClass() == "prop_physics" ) and !ent.FalseProp then
		if ( self.NextMeleeTimer or 0 ) < CurTime() then
			self:Melee( ent, 1 )
			self:BehaveStart()
			self.NextMeleeTimer = CurTime() + self.MeleeDelay
		end
	end

end

function ENT:Melee( ent, type )
	self:PlayGestureSequence( self.MeleeAnim )
	self.loco:FaceTowards( ent:GetPos() )
	
	timer.Simple( 0.4, function()
		if ( IsValid(self) and self:Health() > 0) and IsValid(ent) then
		
			if self:GetRangeTo( ent ) > self.MeleeRange then return end
		
			if ent:Health() > 0 then
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
				ent:EmitSound( "Flesh.ImpactHard" )
			end
			
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 10
			end
			
			--ent:EmitSound( data.hitsound, 50, math.random( 80, 160 ) )
		
		end
	end)
	
end

function ENT:MovementFunction( type )

	if self.InPanic then
	
		if self:GetActivity() != self.PanickedAnim then
			self:StartActivity( self.PanickedAnim )
		end
		self.loco:SetDesiredSpeed( self.PanickedSpeed )
		
	elseif self.FollowingPlayer or self.GoingToRevive then
	
		if self:GetActivity() != self.SprintingAnim then
			self:StartActivity( self.SprintingAnim )
		end
		self.loco:SetDesiredSpeed( self.SprintingSpeed )
	
	else
	
		if type == "crouching" then
			self:StartActivity( self.CrouchAnim )
			self.loco:SetDesiredSpeed( self.CrouchSpeed )
		else
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )
		end
		
	end

end

function ENT:Use( activator, caller )

	if ( self.NextFollowTimer or 0 ) < CurTime() then
					
		if caller:IsPlayer() and !self:IsPlayerZombie( caller ) then

			if !self.FollowingPlayer then --Following
				self.FollowingPlayer = true
				self.EntityFollowing = caller
			
				self:BehaveStart()
			
				self:AddGesture( ACT_GMOD_GESTURE_BOW, true )
				
				if self.InPanic then
				
				else
					local randomsound = table.Random( self.FollowingSounds )
					self:EmitSound( Sound( randomsound ), 100, self.FollowingSoundsPitch or 100 )
				end
			
				self.NextFollowTimer = CurTime() + 1
			else --UnFollowing
				self.FollowingPlayer = false
				self.EntityFollowing = nil
			
				self:BehaveStart()
				
				self:AddGesture( ACT_GMOD_TAUNT_SALUTE, true )
				
				if self.InPanic then
				
				else
					local randomsound = table.Random( self.FollowingSounds2 )
					self:EmitSound( Sound( randomsound ), 100, self.FollowingSounds2Pitch or 100 )
				end
				
				self.NextFollowTimer = CurTime() + 1
			end

		end			
					
		
	end

end

function ENT:RunBehaviour()

	while ( true ) do

		if ( self.GoingToRevive and nb_allow_reviving:GetInt() == 1 ) then
		
			if self.RevivingEntity and ( IsValid( self.RevivingEntity ) and self.RevivingEntity:Health() > 0 ) and self.RevivingEntity:WOSGetIncapped() then
		
				local pos = self.RevivingEntity:GetPos()

				if ( pos ) then
						
					self:MovementFunction()
					
					local maxageScaled=math.Clamp(pos:Distance(self:GetPos())/1000,0.1,3)	
					local opts = {	lookahead = 30,
						tolerance = 50,
						draw = false,
						maxage = maxageScaled 
						}
					
					self:MoveToPos( pos, opts )
	
					if self:GetRangeTo( pos ) < 50 then
							
						if self.RevivingEntity:WOSGetIncapped() then	
							
							self.loco:SetDesiredSpeed( 0 )
							self:PlaySequenceAndWait( "wos_l4d_heal_incap_crouching" )
							
							if self.RevivingEntity and ( IsValid( self.RevivingEntity ) and self.RevivingEntity:Health() > 0 ) then
								self.RevivingEntity:WOSRevive()
							end
						
						end
						
						self.GoingToRevive = false
						self.RevivingEntity = nil
						
						self:MovementFunction()
							
					end
	
				end
		
			end
		
		else
		
			if self.FollowingPlayer then
			
				pos = self.EntityFollowing:GetPos()	
						
				if ( pos ) and self.EntityFollowing:IsValid() and self.EntityFollowing:Health() > 0 then
					
					self:MovementFunction()	
						
					local enemy = self.EntityFollowing
					local maxageScaled=math.Clamp(pos:Distance(self:GetPos())/1000,0.1,3)	
					local opts = {	lookahead = 30,
						tolerance = 20,
						draw = false,
						maxage = maxageScaled 
						}
						
					self:MoveToPos( pos, opts )
						
				end	
				
			else
			
				if self.InPanic then
				
					self:PlayAlertSound()
				
					local pos = self:FindSpot( "far", { radius = 5000 } )

					if ( pos ) then
					
						self:MovementFunction()
						
						self:MoveToPos( pos )

						if self:GetRangeTo( pos ) < 40 then
						
							self.loco:SetDesiredSpeed(0)
							coroutine.wait(1)
							self:MovementFunction()
						
						end
						
					end
					
				else
				
					self:PlayIdleSound()
				
					local pos = self:FindSpot( "random", { radius = 5000 } )

					if ( pos ) then

						self:MovementFunction()
						
						self:MoveToPos( pos )

					end
					
				end
				
			end

		end	
			
		coroutine.yield()


	end


end

function ENT:PlayGestureSequence( sequence )
	local sequencestring = self:LookupSequence( sequence )
	self:AddGestureSequence( sequencestring, true )
end

function ENT:BehaveUpdate( fInterval )

	if ( !self.BehaveThread ) then return end
	
		self:CustomBehaveUpdate()
		
		if nb_allow_reviving:GetInt() == 1 then
			self:LookForRevive()
		end
		
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then

		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );

	end

end

function ENT:LookForRevive()

	if ( self.NextLookTimer or 0 ) < CurTime() then

		if !self.GoingToRevive then
	
			local allies
	
			if ( nb_revive_players == true ) then
				allies = table.Add( player.GetAll(), ents.FindByClass("nb_swat*") )
			else
				allies = table.Add( ents.FindByClass("nb_swat*") )
			end

			for k,v in pairs( allies ) do
			
				if v:WOSGetIncapped() then
				
					if v == self.FollowingEntity then return end
					if v == self.RevivingEntity then return end
					if ( v:IsPlayer() and self:IsPlayerZombie( v ) ) then return end
				
					if self:GetRangeTo( v ) < 500 and self:IsLineOfSightClear( v ) then
						self.GoingToRevive = true
						self.RevivingEntity = v
						self:BehaveStart()
					end
					
				end
			
			
			end
	
			self.NextLookTimer = CurTime() + math.random(5,8)
		
		end
	end

end

function ENT:CustomBehaveUpdate()

end

function ENT:BodyUpdate()

	if ( self:GetActivity() == self.WalkAnim ) then
		
		self:BodyMoveXY()
		
	elseif ( self:GetActivity() == self.SprintingAnim ) then
		
		self:BodyMoveXY()
		
	elseif ( self:GetActivity() == self.PanickedAnim ) then
		
		self:BodyMoveXY()	
		
	end

	self:FrameAdvance()

end

function ENT:HandleStuck()

	self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
	
	self.StuckAttempts = self.StuckAttempts + 1
	if self.StuckAttempts == 100 then
		self.loco:ClearStuck()
		self.StuckAttempts = 0
		self.TotalTimesStuck = self.TotalTimesStuck + 1
		if self.TotalTimesStuck >= 10 then
			self:TakeDamage(math.huge, self)
		end
	end

end

function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		if self.FollowingPlayer then
			if self:IsPlayerZombie( self.EntityFollowing ) then
				self.FollowingPlayer = false
				self.EntityFollowing = nil
				return "failed"
			end
		
			if nb_allow_reviving:GetInt() == 1 then
				if nb_revive_players then	
					if self.EntityFollowing:WOSGetIncapped() then
						self.FollowingPlayer = false
						self.GoingToRevive = true
						self.RevivingEntity = self.EntityFollowing
						self:BehaveStart()
						return "failed"
					end
				end
			end
		
			if ( self:GetRangeTo( self.EntityFollowing ) < 90 ) then 
				return "ok"
			end
		end
	
		if nb_doorinteraction:GetInt() == 1 then
			if !self:CheckDoor() then
			
			elseif ( self:CheckDoor():IsValid() and self:GetRangeTo( self:CheckDoor() ) < self.StopRange + 20 and self:IsLineOfSightClear( self:CheckDoor() ) ) then
				self:ContactDoor( self:CheckDoor() )
				return "ok"
			end
		end
	
		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end

		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		
		coroutine.yield()

	end

	return "ok"

end

function ENT:ContactDoor( ent, type )
	if type == 1 then --Contacted Door, probably stuck
		if !self.TouchedDoor then
			self.TouchedDoor = true
	
			timer.Simple( 2, function()
				self.TouchedDoor = false
			end)
		end
	else
		ent:Fire("Open")
	end
end

function ENT:Think()

	if self.Waving then
		if self.WavingTo and ( IsValid( self.WavingTo ) and self.WavingTo:Health() > 0 ) then
			self.loco:FaceTowards( self.WavingTo:GetPos() )
		end
	end

	self:CustomOnThink()
	
end

function ENT:CustomOnThink()

end

function ENT:OnLeaveGround( ent )

	--self:RestartGesture( self.JumpAnim )

end

function ENT:OnLandOnGround()

	self.IsJumping = false
	
	--self:MovementFunction()
	
end

function ENT:OnNavAreaChanged( old, new )

	if old:HasAttributes( 1 ) then
		self:MovementFunction( "crouching" )
		self.Crouching = true
	else
		self:MovementFunction()
		self.Crouching = false
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
				dmginfo:ScaleDamage(8)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end
	end

	if !self.GoingToRevive then
		self:Flinch( dmginfo, hitgroup )
	end
	
	self:CustomOnInjured()
	
	self:PlayPainSound()
	
end

function ENT:CustomOnInjured()

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
			
			if dmginfo:GetDamage() > 25 then
				self.CanRunReload = false
				self.WalkAnim = self.FlinchWalkAnim
				self.Speed = self.FlinchWalkSpeed
				self:BehaveStart()
			end
		end	
		
		self.NextFlinchTimer = CurTime() + 0.5
	end
	
end

function ENT:OnKilled( dmginfo )
	
	if self.HitByVehicle then 
	return end
	
	if dmginfo:GetAttacker().NEXTBOTZOMBIE or self:IsPlayerZombie( dmginfo:GetAttacker() ) then
	
		self:RiseAsZombie( self, "nb_rise_base", "nb_freshdead", "", 100, false )
	
	else
	
		if self.GoingToRevive then
			self:BecomeRagdoll( dmginfo )
		else
			if dmginfo:IsExplosionDamage() then
				self:BecomeRagdoll( dmginfo )
			else
				if dmginfo:GetDamage() > 50 then
					self:BecomeRagdoll( dmginfo )
				else
					if nb_death_animations:GetInt() == 1 then
						self:DeathAnimation( "nb_deathanim_base", self:GetPos(), self.WalkAnim, 1 )
					else
						self:BecomeRagdoll( dmginfo )
					end
				end
			end
		end
	
	end
	hook.Run("OnNextbotDeath",self,dmginfo)
	hook.Run( "OnNPCKilled",self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:PlayDeathSound()
	
end

function ENT:AlertNearbyCitizens()

	for k,v in pairs( ents.FindByClass("nb_citizen") ) do
	
		if !v.InPanic then
	
			if self:GetRangeTo( v ) < 400 and self:IsLineOfSightClear( v ) then
			
				if ( IsValid( v ) and v:Health() > 0 ) then
				
					self:StartPanic( v )
						
				end
				
			end
		
		end
		
	end
	
end

function ENT:OnOtherKilled( ent, dmginfo )

	if ent.NEXTBOT or ent:IsPlayer() then
	
		if self:GetRangeTo( ent ) < 500 and self:IsLineOfSightClear( ent ) then
	
			self:StartPanic( self )
	
		end
		
	end
	
end

function ENT:StartPanic( ent )

	self:PlayAlertSound()

	ent.InPanic = true
		
	if ent.Waving then
		ent.Waving = false
		ent.WavingTo = nil
		ent:MovementFunction()
	end
		
	ent:BehaveStart()

end

function ENT:DeathAnimation( anim, pos, activity, scale )
	local human = ents.Create( anim )
	if !self:IsValid() then return end

	if human:IsValid() then
		human:SetPos( pos )
		human:SetModel(self:GetModel())
		human:SetAngles(self:GetAngles())
		human:Spawn()
		human:SetSkin(self:GetSkin())
		human:SetColor(self:GetColor())
		human:SetMaterial(self:GetMaterial())
		human:SetModelScale( scale, 0 )
		
		human:StartActivity( activity )

		SafeRemoveEntity( self )
	end
end

function ENT:PlayPainSound()
	if self:Health() < 0 then return end

	if ( self.NextPainSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.PainSounds )
		self:EmitSound( Sound( randomsound ), 100, self.PainSoundPitch or 100 )
	
		self.NextPainSoundTimer = CurTime() + math.random(1,4)
	end
end

function ENT:PlayAlertSound( type )
	if self:Health() < 0 then return end

	if ( self.NextAlertSoundTimer or 0 ) < CurTime() then
	
		local randomsound 
	
		if type == 2 then
			if self.AlertSounds2 then
				randomsound = table.Random( self.AlertSounds2 )
			else
				randomsound = table.Random( self.AlertSounds )
			end
		else
			randomsound = table.Random( self.AlertSounds )
		end
	
		self:EmitSound( Sound( randomsound ), 100, self.AlertSoundPitch or 100 )
	
		self.NextAlertSoundTimer = CurTime() + math.random(8,16)
	end
end

function ENT:PlayDeathSound()
	if ( self.NextDeathSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.DeathSounds )
		self:EmitSound( Sound( randomsound ), 100, self.DeathSoundPitch or 100 )
	
		self.NextDeathSoundTimer = CurTime() + 1
	end
end

function ENT:PlayIdleSound()
	if self:Health() < 0 or self.IsAttacking or self.Flinching then return end
	if self.Enemy then return end
	
	if ( self.NextIdleSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.IdleSounds )
		self:EmitSound( Sound( randomsound ), 100, self.IdleSoundPitch or 100 )
	
		self.NextIdleSoundTimer = CurTime() + math.random(8,26)
	end
end