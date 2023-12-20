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

ENT.Base = "nb_swat_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
ENT.ChaseDistance = 5000

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 180
ENT.PatrolSpeed = 75
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 800
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.ShootRange = 300
ENT.MeleeRange = 60
ENT.StopRange = 200
ENT.BackupRange = 150

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 5
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_shotgun"
ENT.WeaponSound = "Weapon_Shotgun.Single"

ENT.PistolClass = "wep_nb_pistol"
ENT.PistolSound = "Weapon_Pistol.Single"

--Model--
ENT.WalkAnim = ACT_HL2MP_RUN_SHOTGUN  
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
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
	
		self.NEXTBOTFACTION = 'NEXTBOTCOMBINE'
		self.NEXTBOTCOMBINE = true
		self.NEXTBOT = true
		
		--Status
		self.NextCheckTimer = CurTime() + 4
		self.StuckAttempts = 0
		self.TotalTimesStuck = 0
		self.IsJumping = false
		self.ReloadAnimation = false
		self.CanRunReload = true
		self.HitByVehicle = false
		self.FollowingPlayer = false
		self.EntityFollowing = nil
		self.TouchedDoor = false
		self.IsAlerted = false
		self.AlertedEntity = nil
		self.LookingForReload = false
		
		self:MovementFunction()
	end
	
	if CLIENT then
		self.NEXTBOTFACTION = 'NEXTBOTCOMBINE'
		self.NEXTBOTCOMBINE = true
		self.NEXTBOT = true
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel( "" )
		self:SetHealth( self.HealthAmount )
	end
	
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		
		local veh = ent:GetPhysicsObject()
		local dmg = math.Round( (ent:GetVelocity():Length() / 5 + ( veh:GetMass() / 100 ) ), 1 )

		if dmg > self:Health() then
		
			if ent:GetOwner():IsValid() then
				self:TakeDamage( dmg, ent:GetOwner() )
			else
				self:TakeDamage( dmg, ent )
			end
		
		else
		
			self.HitByVehicle = true
			self:VehicleHit( ent, "nb_rise_base", self:GetClass(), "", ( self:Health() - dmg ), true )
		
		end

	end

	if ent != self.Enemy then
		if ( self.NextMeleeTimer or 0 ) < CurTime() then
			if self:CanTargetThisEnemy( ent ) then
				self:Melee( ent )
				--print( "contacted: ", ent, "nb: ", self )
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
		end
			
		if ( self.NextSwitchTargetTimer or 0 ) < CurTime() then
			if self:CanTargetThisEnemy( ent ) then
				self:SetEnemy( ent )
				--self:BehaveStart()
				self.NextSwitchTargetTimer = CurTime() + 1
			end
		end
	end
	
	self:CustomOnContact2( ent )
	
end

function ENT:FindEnemy()

	local enemies
		
	if ai_ignoreplayers:GetInt() == 1 then
		enemies = table.Add( ents.FindByClass("nb_*") )
	else
		enemies = table.Add( player.GetAll(), ents.FindByClass("nb_*") )
	end
	
	if #enemies > 0 then
		for i=1,table.Count( enemies ) do -- Goal is to reduce amount of values to be sorted through in the table for better performance
			for k,v in pairs( enemies ) do
				if v.BASENEXTBOT then --Remove base nextbot entities (eg. nb_deathanim_base)
					table.remove( enemies, k )
				end
				if ( self.NEXTBOTFACTION == v.NEXTBOTFACTION ) then --Remove same faction from pool of enemies
					table.remove( enemies, k )
				end
				if !IsValid( v ) then --Remove unvalid targets from pool of enemies
					table.remove( enemies, k )
				end
				if v:Health() < 0 then --Remove dead targets from pool of enemies
					table.remove( enemies, k )
				end
				if ai_ignoreplayers:GetInt() == 0 then --Remove players from pool of enemies if ignore players is true
					if v:IsPlayer() then
						if !v:Alive() then --Remove dead players from pool of enemies
							table.remove( enemies, k )
						end
					end
				end
			end
		end
		
		table.sort( enemies, 
		function( a,b ) 
			return self:GetRangeSquaredTo( a ) < self:GetRangeSquaredTo( b ) --Sort in order of closeness from pool of enemies
		end )
	
		self:SearchForEnemy( enemies )
		--PrintTable( enemies )
	end
	
end

function ENT:HaveEnemy()

	local enemy = self:GetEnemy()

	if ( enemy and IsValid( enemy ) ) then
		if ( enemy:Health() < 0 ) then
			return self:FindEnemy()
		end
		
		if enemy:IsPlayer() and ai_ignoreplayers:GetInt() == 1 then 
			return self:FindEnemy()
		end
		
		if ( self.NextCheckTimer or 0 ) < CurTime() then --Every 4 seconds, find new and best target
			self:FindEnemy()
			if nb_targetmethod:GetInt() == 1 then
				self.LastEnemy = enemy
				timer.Simple(math.random(0.1,0.5),function()
					if IsValid( self ) and self:Health() > 0 then
						if !self.Enemy and self.LastEnemy then
							if IsValid( self.LastEnemy ) and self.LastEnemy:Health() > 0 then
								self:SetEnemy( self.LastEnemy )
							else
								self.LastEnemy = nil
							end
						end
					end
				end)
			end
			self.NextCheckTimer = CurTime() + 4
		end
		
		return true
		
	else
		return self:FindEnemy()
	end
end

function ENT:LookForRevive()

	if ( self.NextLookTimer or 0 ) < CurTime() then

		if !self.GoingToRevive then
	
			local allies
	
			allies = table.Add( ents.FindByClass("nb_combine*") )
			
			for k,v in pairs( allies ) do
			
				if v != self then
			
					if !self.Reloading and !self.ReloadAnimation then
			
						if v:WOSGetIncapped() then
						
							if v == self.FollowingEntity then return end
							if v == self.RevivingEntity then return end
							if ( v:IsPlayer() and self:IsPlayerZombie( v ) ) then return end
						
							if self:GetRangeSquaredTo( v ) < 500*500 and self:Visible( v ) then
								
								self:PlayGestureSequence( "gesture_signal_halt" )
							
								self.GoingToRevive = true
								self.RevivingEntity = v
								self:BehaveStart()
							end
							
						end
			
					end
			
				end
			
			end
	
			self.NextLookTimer = CurTime() + math.random(5,8)
		
		end
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
			
				local effectdata = EffectData()
					effectdata:SetStart( dmginfo:GetDamagePosition() ) 
					effectdata:SetOrigin( dmginfo:GetDamagePosition() )
					effectdata:SetScale( 1 )
				util.Effect( "StunStickImpact", effectdata )
				
				self:EmitSound("hits/armor_hit.wav")
			
				dmginfo:ScaleDamage(2.5)
			else
				self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
			end
			
			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				dmginfo:ScaleDamage(0.5)
			end
	end

	if !self.Downed and !self.GettingUp then
		self:Flinch( dmginfo, hitgroup )
	
		self:CheckEnemyPosition( dmginfo )
	end
	
	if nb_allow_reviving:GetInt() == 1 then
		self:CheckIfDowned( dmginfo )
	end

	self:PlayPainSound()
	
end

function ENT:CustomOnOtherKilled( ent, dmginfo )

end

function ENT:CustomOnThink()

end

function ENT:BodyUpdate()

	if !self.Downed then

		if ( self:GetActivity() == self.WalkAnim ) then
				
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.Speed )
				
		elseif ( self:GetActivity() == self.SprintingAnim ) then
				
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.SprintingSpeed )
				
		elseif ( self:GetActivity() == self.CrouchAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.CrouchSpeed )
				
		elseif ( self:GetActivity() == self.AimWalkAnim ) then
			
			self:BodyMoveXY()	
				
		elseif ( self:GetActivity() == self.PatrolWalkAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.PatrolSpeed )
				
		end

	else
			
		self:BodyMoveXY()
		self.loco:SetDesiredSpeed( 0 )
		
	end
	
	--self:FrameAdvance() --Frame advance sets animation speed to ground speed.. Will speed up gestures if called
	
end

function ENT:ReloadWeapon( type )

	if !self.Crouching or self.Downed then

		if type == "running" then
			if !self.ReloadAnimation then
			
				self.ReloadAnimation = true
		
				local reloadanim = self.RunningReloadAnim
				self:PlayGestureSequence( self.RunningReloadAnim )

				if !self.Downed then
					timer.Simple( ( self:SequenceDuration( reloadanim ) + 1 ), function()
						if IsValid( self ) and self:Health() > 0 then
							self:ResetWeapon()
						end
					end)
				else
					timer.Simple( ( 2.3 ), function()
						if IsValid( self ) and self:Health() > 0 then
							self:ResetWeapon()
						end
					end)
				end
				
				if !( self.RunningReloadAnim == "reload_shotgun" or self.RunningReloadAnim == "reload_revolver" ) then
					self:ChooseReloadSound()
				end
			end
			
		elseif type == "standing" then
			if !self.ReloadAnimation then
			
				self:MovementFunction( "standreload" )
			
				self.ReloadAnimation = true
				
				self:ChooseReloadSound()
				self:PlaySequenceAndWait( self.StandingReloadAnim, 1 )
				self:ResetWeapon()
			end
		end
		
	else
	
		if !self.ReloadAnimation then

			self:MovementFunction( "crouching" )
			
			local reloadanim = self.CrouchingReloadAnim
			self:PlayGestureSequence( reloadanim )
			
			self.ReloadAnimation = true
			
			timer.Simple( ( self:SequenceDuration( reloadanim ) + 1 ), function()
				if IsValid( self ) and self:Health() > 0 then
					self:ResetWeapon()
				end
			end)
			
			if !( self.CrouchingReloadAnim == "reload_shotgun" or self.CrouchingReloadAnim == "reload_revolver" ) then
				self:ChooseReloadSound()
			end
		end
		
	end
	
end

function ENT:BackUp()
	
	local enemy = self:GetEnemy()
	
	if IsValid( self ) and self:Health() > 0 then
		if self.GoingToRevive then return end
	
		if enemy and enemy:IsValid() and enemy:Health() > 0 then
		
			self:MovementFunction()
	
			while( ( enemy:IsValid() and enemy:Health() > 0) and self:GetRangeSquaredTo( enemy ) < self.BackupRange*self.BackupRange ) do
		
				local back = self:GetPos() + self:GetAngles():Forward() * -16
				local sideways = self:GetPos() + self:GetAngles():Right() * ( math.random(-1,1) * 16 )

				if ( self.NextSafeCheckTimer or 0 ) < CurTime() then	
					
					local navarea = navmesh.GetNavArea( back, 64 )
					if IsValid( navarea ) then
						self.HeadingBackwards = true
						self.HeadingSideways = false
					else
						sideways = self:GetPos() + self:GetAngles():Right() * ( math.random(-1,1) * 16 )
						self.HeadingBackwards = false
						self.HeadingSideways = true
					end
					
					self.NextSafeCheckTimer = CurTime() + 1
				end	

				if self.HeadingBackwards then
					self.loco:Approach(back, self.BackupRange)
				elseif self.HeadingSideways then
					self.loco:Approach(sideways, self.BackupRange)
				end
				
				--debugoverlay.Cross( back, 10, 10, color_white, true )
				
				--local tr = util.TraceLine( {
					--start = self:GetPos(),
					--endpos = back,
					--mask = MASK_BLOCKLOS,
					--filter = self
				--} )

				--debugoverlay.Line( self:GetPos(), back, 10, color_white, true )
				
				coroutine.wait(0.05)
				
			end
			
			self:MovementFunction()

			coroutine.yield()
	
		end
	
	end
	
end

function ENT:CheckCrouchDistance()

	local enemy = self:GetEnemy()
	if ( enemy and enemy:IsValid() and enemy:Health() > 0 ) then

		if ( self.Weapon.TypeClass == "rifle" 
		or self.Weapon.TypeClass == "sniper" 
		or self.Weapon.TypeClass == "rifle" 
		or self.Weapon.TypeClass == "pistol" ) then
		
			if ( ( self:GetRangeTo( enemy ) < self.ShootRange and self:GetRangeTo( enemy ) > ( self.ShootRange - self.BackupRange ) ) and self:Visible( enemy ) ) then
					
				self.WeaponBulletOffset = 3
					
				self.Crouching = true
				self:StartMovementAnim( self.CrouchAnim, self.Speed )
			else
				
				--local offset
				--offset = math.Round( ( 1 / (self:GetRangeSquaredTo( enemy )*self:GetRangeSquaredTo( enemy )) * 400 ), 2 )
				--self.WeaponBulletOffset = 6 + offset
					
				self.Crouching = false
				
				if self.Weapon.TypeClass == "pistol" then
					if math.random(1,2) == 1 then
						self:StartMovementAnim( self.AimWalkAnim, self.Speed )
					else
						self:StartMovementAnim( self.WalkAnim, self.Speed )
					end
				else
					self:StartMovementAnim( self.WalkAnim, self.Speed )
				end
				
			end
		
		elseif ( self.Weapon.TypeClass == "smg" ) then
		
			if ( ( self:GetRangeTo( enemy ) > (self.ShootRange - self.BackupRange) and self:GetRangeSquaredTo( enemy ) < self.ShootRange*self.ShootRange ) and self:IsLineOfSightClear( enemy ) ) then
					
				self.WeaponBulletOffset = 5
					
				self.Crouching = true
				self:StartMovementAnim( self.CrouchAnim, self.Speed )
			else
				
				--local offset
				--offset = math.Round( ( 1 / (self:GetRangeSquaredTo( enemy )*self:GetRangeSquaredTo( enemy )) * 100 ), 2 )
				--self.WeaponBulletOffset = 8 + offset
					
				self.Crouching = false
				self:StartMovementAnim( self.WalkAnim, self.Speed )
			end
		
		
		elseif ( self.Weapon.TypeClass == "shotgun" ) then
		
			if ( self:GetRangeTo( enemy ) > (self.ShootRange - self.BackupRange) and self:GetRangeSquaredTo( enemy ) < self.ShootRange*self.ShootRange ) then
				self:StartMovementAnim( self.AimWalkAnim, self.Speed )
			else
				self:StartMovementAnim( self.WalkAnim, self.Speed )
			end
		
		end
			
	else
	
		if self:HaveEnemy() then
		
			self:StartMovementAnim( self.WalkAnim, self.Speed )
		
		else
		
			if self.GoingToRevive then
			
				self:StartMovementAnim( self.WalkAnim, self.Speed )
			
			else
			
				self:StartMovementAnim( self.PatrolWalkAnim, self.PatrolSpeed )

			end
			
		end
		
	end

end

function ENT:ReloadBehaviour()

	if ( self.NextReloadCheck or 0 ) < CurTime() then

		if nb_soldier_findreloadspot:GetInt() == 1 then
		
			if !self.GoingToSpot and !self.ReloadAnimation then
			
				if ( self:Health() < ( self.HealthAmount / 2 ) and self.CanRunReload ) then
					self:PlayReloadingSound( 2 )
					self:LookForSpot( self.LookForSpotCount )
				else
					self:PlayReloadingSound()
					self:ReloadWeapon( "running" )
				end
				
			end
			
		else
		
			self:ReloadWeapon( "running" )
			
		end
	
		self.NextReloadCheck = CurTime() + 0.05
	end
	
end

function ENT:RunBehaviour()

	if self.GettingUp then
		self.GettingUp = false
		self.DownedOnGround = false
		self:PlaySequenceAndWait( "wos_l4d_getup_from_pounced", 1 )
		self.Downed = false
		self.loco:ClearStuck()
		self:BehaveStart()
		self:MovementFunction( "standreload" )
	return end
	
	if self.Downed and !self.DownedOnGround then
		self:MovementFunction()
		self:PlayDownedAnimation()
		coroutine.wait( 2.2 )
		self.DownedOnGround = true
		self:BehaveStart()
	return end

	while ( true ) do

		self:GrenadeThrow()

		if !self.Downed then
	
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
		
						if self:GetRangeSquaredTo( pos ) < 50*50 then
								
							if self.RevivingEntity:WOSGetIncapped() then	
								
								local randomsound = table.Random( self.RevivingFriendlySounds )
								self:EmitSound( Sound( randomsound ), 100, self.RevivingFriendlySoundsPitch or 100 )
		
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
			
				else
				
					self.GoingToRevive = false
					self.RevivingEntity = nil
							
					self:MovementFunction()
				
				end
			
			else
	
				if self:HaveEnemy() and self.Enemy then
						
					local enemy = self:GetEnemy()	
						
					self.Patrolling = false
					
					if self.Reloading then
						self:ReloadBehaviour()
					end
						
					if !self.GoingToSpot then
					
						if enemy:IsValid() and enemy:Health() > 0 then
					
							pos = enemy:GetPos()	
									
							if ( pos ) then
								
								self:MovementFunction()	

								if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange and self:GetRangeSquaredTo( enemy ) > self.BackupRange*self.BackupRange and self:Visible( self.Enemy ) and !self.Crouching ) then
				
									if ( self.NextStrafeTimer or 0 ) < CurTime() then
				
										self.Strafing = true
				
										local sidetoside = ( self:GetPos() + self:GetAngles():Right() * ( 328 * math.random(-1,1) ) )
				
										self.loco:Approach(sidetoside, 75)
										
										self.NextStrafeTimer = CurTime() + 0.2
										
									else
										
										self.Strafing = true
										
									end
										
								else
									
									local maxageScaled=math.Clamp(pos:Distance(self:GetPos())/1000,0.1,3)	
									local opts = {	lookahead = 30,
										tolerance = 20,
										draw = false,
										maxage = maxageScaled 
									}
									
									self:ChaseEnemy( opts )
									self.Strafing = false
									
								end
									
							end

						end	
							
					end		
				
				else

					--if !self.GoingToRevive then
					if !self.Reloading and !self.ReloadAnimation and !self.GoingToRevive and !self.GoingToSpot then
					
						self.Strafing = false
						self.Patrolling = true
					
						if self.BulletsUsed != 0 and ( !self.Enemy ) then
							self:ReloadWeapon( "running" )
						end
				
						self:PlayIdleSound()
					
						self:MovementFunction()
					
						local pos = self:FindSpot( "random", { radius = 5000 } )

						if ( pos ) then

							self:MoveToPos( pos )

						end

					end
					
				end
	
			end
	
		else
		
			if self.Reloading and !self.GettingUp then
		
				self:ReloadWeapon( "running" )
		
			end
		
		end
		
		coroutine.yield()
		
	end

end

function ENT:Melee( ent, type )
	self.IsAttacking = true

	self:PlayAttackSound()
	self:PlayGestureSequence( table.Random( self.MeleeAnims ) )
	
	self.loco:FaceTowards( ent:GetPos() )
	
	timer.Simple( 0.45, function()
		if ( IsValid(self) and self:Health() > 0) then
		
			if IsValid(ent) and ent:Health() > 0 then
		
				if self.Downed then return end
		
				if self:GetRangeTo( ent ) > self.MeleeRange then return end
			
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
				ent:EmitSound( "Flesh.ImpactHard" )
				
				if type == 1 then --Prop
					local phys = ent:GetPhysicsObject()
					if (phys != nil && phys != NULL && phys:IsValid() ) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
					end
				elseif type == 2 then --Door
					ent.Hitsleft = ent.Hitsleft - 10
				end
		
			end
		
		end
		
	end)
	
	timer.Simple( 1, function()
		if ( IsValid(self) and self:Health() > 0 ) then
			self.IsAttacking = false
		end
	end)
end

function ENT:ShootWeapon()

	if !IsValid(self) then return end
	if !self.Weapon or !IsValid(self.Weapon) then self.IsAttacking = false return end

	local wep = self.Weapon
        
	if wep then
		local muzzle = wep:GetAttachment(wep:LookupAttachment("muzzle"))
		local spread = self.WeaponSpread or 0.6
			
		local shootPos = muzzle.Pos
			
		local bulletDir
		if self.Enemy.WOS_InLastStand then
			bulletDir = ( (self.Enemy:GetPos() + Vector(0,0,5) ) - shootPos):GetNormalized()
		else
			bulletDir = ( (self.Enemy:GetPos() + Vector(0,0,40) ) - shootPos):GetNormalized()
		end    
			
		if self.WeaponType == 2 then
			
			local ang = self:GetPos() - self:AimPos()
			local ang2 = ang:Angle()
			local aimDir = Angle(-ang2.x+11, ang2.y-180, ang2.z)
			
			if self.Weapon.TypeClass == "shotgun" then
				
				local effectdata = EffectData()
				effectdata:SetStart( shootPos - (self:GetForward() * 25) )
				effectdata:SetOrigin( shootPos - (self:GetForward() * 25) )
				effectdata:SetAngles( self:GetRight():Angle() )
				util.Effect( "ShotgunShellEject", effectdata )	
				
			else
				
				local effectdata = EffectData()
				effectdata:SetStart( shootPos - (self:GetForward() * 25) )
				effectdata:SetOrigin( shootPos - (self:GetForward() * 25) )
				effectdata:SetAngles( self:GetRight():Angle() )
				util.Effect( "RifleShellEject", effectdata )		
				
			end
				
			self:MuzzleFlash()

			local meffectdata = EffectData()
			meffectdata:SetStart( shootPos )
			meffectdata:SetOrigin( shootPos )
			meffectdata:SetAngles( aimDir )
			util.Effect( "MuzzleEffect", meffectdata )
					
		else

			self.Weapon:ResetSequence( self.WeaponMuzzleAnim or "attack_player" )
			
		end
				
		local bullet = {}
			bullet.Num = self.BulletNum or 1
			bullet.Src = shootPos
			bullet.Dir = bulletDir
			bullet.Spread = Vector( spread * 0.1 , spread * 0.1, 0)
			bullet.Tracer = 1
			bullet.TracerName    = ( self.WeaponTracer or "Tracer" )
			bullet.Force = self.BulletForce or 5
			bullet.Damage = self.BulletDamage or 5
			bullet.Attacker = self

			bullet.Callback = function(attacker, tr, dmginfo)
				dmginfo:SetAttacker( self )
				dmginfo:SetInflictor( self.Weapon )
				dmginfo:SetDamageType(DMG_BULLET)
			end
			 
		wep:FireBullets(bullet)
			
		self:EmitSound( self.WeaponSound )
		
		if isstring( self.ShootAnim ) then
			self:PlayGestureSequence( self.ShootAnim )
		else
			self:RestartGesture( self.ShootAnim )
		end
			
		self.BulletsUsed = self.BulletsUsed + 1
			
		if !self.Reloading then
			
			if self.BulletsUsed == self.ClipAmount then
			
				self.Reloading = true
				self:BehaveStart()
				
			end
			
		end
		
	else
			
	end
		
end

function ENT:CustomBehaveUpdate()

	if nb_allow_reviving:GetInt() == 1 then
		self:LookForRevive()
	end

	if !( self.GoingToRevive and nb_allow_reviving:GetInt() == 1 ) then
	
		if self:HaveEnemy() and self.Enemy then
			
			if !self.Reloading and !self.ReloadAnimation and !self.IsAttacking and !self.GettingUp then
			
				if ( ( self:GetRangeSquaredTo( self.Enemy ) < self.ShootRange*self.ShootRange and self:GetRangeSquaredTo( self.Enemy ) > (self.MeleeRange + 1)*(self.MeleeRange + 1) ) and self:IsLineOfSightClear( self.Enemy )  and !self:CheckDoor() ) then

					self:PoseParameters()
						
					if ( self.NextAttackTimer or 0 ) < CurTime() then
					
						self:ShootWeapon()	

						self.NextAttackTimer = CurTime() + ( self.ShootDelay + math.random(0,0.02) )
					end
					
				end
					
			end	
					
			if !self.ReloadAnimation and !self.Reloading and !self.IsAttacking and !self.Downed and !self.GettingUp then
				
				if self.Enemy and ( self:GetRangeSquaredTo( self.Enemy ) < self.MeleeRange*self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then

					if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
						self:Melee( self.Enemy )
						self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
					end

				end
					
			end
					
		end

	end
	
end