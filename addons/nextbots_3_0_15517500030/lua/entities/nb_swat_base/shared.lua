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

ENT.Base = "nb_rebel_base"
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

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel( "" )
		self:SetHealth( self.HealthAmount )
	end
	
end

function ENT:Use( activator, caller )

end

function ENT:CheckCrouchDistance()

	local enemy = self:GetEnemy()
	if ( enemy and enemy:IsValid() and enemy:Health() > 0 ) then
		
		if ( self.Weapon.TypeClass == "rifle" 
		or self.Weapon.TypeClass == "sniper" 
		or self.Weapon.TypeClass == "rifle" 
		or self.Weapon.TypeClass == "pistol" ) then
		
			if ( ( self:GetRangeSquaredTo( enemy ) > 800*800 and self:GetRangeSquaredTo( enemy ) < self.ShootRange*self.ShootRange ) and self:IsLineOfSightClear( enemy ) ) then
					
				self.WeaponBulletOffset = 3
					
				self.Crouching = true
				self:StartMovementAnim( self.CrouchAnim, 0 )
			else
				
				local offset
				offset = math.Round( ( 1 / (self:GetRangeSquaredTo( enemy )*self:GetRangeSquaredTo( enemy )) * 400 ), 2 )
				self.WeaponBulletOffset = 6 + offset
					
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
		
			if ( ( self:GetRangeSquaredTo( enemy ) > 500*500 and self:GetRangeSquaredTo( enemy ) < self.ShootRange*self.ShootRange ) and self:IsLineOfSightClear( enemy ) ) then
					
				self.WeaponBulletOffset = 5
					
				self.Crouching = true
				self:StartMovementAnim( self.CrouchAnim, self.Speed )
			else
				
				local offset
				offset = math.Round( ( 1 / (self:GetRangeSquaredTo( enemy )*self:GetRangeSquaredTo( enemy )) * 100 ), 2 )
				self.WeaponBulletOffset = 8 + offset
					
				self.Crouching = false
				self:StartMovementAnim( self.WalkAnim, self.Speed )
			end
		
		
		elseif ( self.Weapon.TypeClass == "shotgun" ) then
		
			if ( self:GetRangeSquaredTo( enemy ) > 300*300 and self:GetRangeSquaredTo( enemy ) < self.ShootRange*self.ShootRange ) then
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

function ENT:MovementFunction( type )

	if !self.Downed then 
	
		if type == "reloading" then
			self:StartMovementAnim( self.SprintingAnim, self.SprintingSpeed, 1 )
		elseif type =="standreload" then
			self:StartMovementAnim( self.WalkAnim, self.Speed, 1 )
		elseif type == "crouching" then
			self:StartMovementAnim( self.CrouchAnim, self.CrouchSpeed, 1 )
		elseif type == nil then
			self:CheckCrouchDistance()
		end
	
	else
	
		--self:CheckCrouchDistance()
		--self:StartMovementAnim( self.WalkAnim, self.Speed )
		
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
	
		if !self.GoingToRevive then
			if self:HaveEnemy() and !self.Reloading and self.Patrolling then
				return "failed"
			end
		end
	
		if nb_doorinteraction:GetInt() == 1 then
			if !self:CheckDoor() then
			
			elseif ( self:CheckDoor():IsValid() and self:GetRangeSquaredTo( self:CheckDoor() ) < (self.StopRange + 20)*(self.StopRange + 20) and self:IsLineOfSightClear( self:CheckDoor() ) ) then
				self:ContactDoor( self:CheckDoor() )
				return "ok"
			end
		end
	
		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end

		if !self.Downed then
			if ( self.loco:IsStuck() ) then
				self:HandleStuck()
				return "stuck"
			end
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
			
				if v != self then
			
					if !self.Reloading and !self.ReloadAnimation then
			
						if v:WOSGetIncapped() then
						
							if v == self.FollowingEntity then return end
							if v == self.RevivingEntity then return end
							if ( v:IsPlayer() and self:IsPlayerZombie( v ) ) then return end
						
							if self:GetRangeSquaredTo( v ) < 500*500 and self:IsLineOfSightClear( v ) then
								
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

function ENT:GrenadeThrow()
end

function ENT:PlayDownedAnimation()
	if ( self.NextDownAnimTimer or 0 ) < CurTime() then
	
		self:ResetSequence( "wos_l4d_collapse_to_incap", 1 )
		self:SetCycle( 0.1 )
	
		coroutine.wait( 2.2 )
		self.DownedOnGround = true
		self:BehaveStart()
	
		self.NextDownAnimTimer = CurTime() + 3
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
	
				if self:HaveEnemy() then
						
					local enemy = self:GetEnemy()	
						
					self.Patrolling = false
					
					if !self.Reloading then
					
						pos = enemy:GetPos()	
							
						if ( pos ) and enemy:IsValid() and enemy:Health() > 0 then
						
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
							
					else
						
						self.Strafing = false
						
						self:ReloadBehaviour()
						
					end
				
				else
					
					self.Strafing = false
					self.Patrolling = true

					if !self.Reloading and !self.ReloadAnimation and !self.GoingToRevive then

						if self.BulletsUsed != 0 then
						
							if math.random(1,2) == 1 then
								self:ReloadWeapon( "running" )
							elseif math.random(1,2) == 2 then
								self:ReloadWeapon( "standing" )
							end
						
						else
					
							self:PlayIdleSound()
					
							self:MovementFunction()
					
							local pos = self:FindSpot( "random", { radius = 5000 } )

							if ( pos ) then

								self:MoveToPos( pos )

							end
					
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
						
						if self.WeaponClass == "wep_nb_famas" then
							self.TimesShot = self.TimesShot + 1
							
							if self.TimesShot == 3 then
								self.NextAttackTimer = CurTime() + self.ShootDelay
								self.TimesShot = 0
							else
								self.NextAttackTimer = CurTime() + 0.1
							end
						else
							self.NextAttackTimer = CurTime() + self.ShootDelay
						end
						
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

function ENT:BodyUpdate()

	if self.ReloadAnimation or self.IsAttacking then

		self:BodyMoveXY()
		
	else

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
	
end

function ENT:SetEnemy( ent )
	
	self.Enemy = ent

	if !self.ReloadAnimation and !self.Reloading and !self.Downed then
		if self.Enemy != nil then
		
			if self.Enemy and self.Enemy:IsValid() and self.Enemy:Health() > 0 then
				self:PlayAlertSound()
				self:AlertNearby()
			end

			if math.random(1,2) == 1 then
				self:PlayGestureSequence( "gesture_signal_forward" )
			else
				self:PlayGestureSequence( "gesture_signal_group" )
			end
			
		end
	end
	
end

function ENT:Think()

	self:CustomOnThink()
	
	if SERVER then
	
		if self.IsAlerted then
		
			if self.AlertedEntity and ( IsValid( self.AlertedEntity ) and self.AlertedEntity:Health() > 0 ) then
				self.loco:FaceTowards( self.AlertedEntity:GetPos() )
			end
		
		end
		
		if self.Strafing then
		
			if ( self.NextLookTimer or 0 ) < CurTime() then
				local enemy = self:GetEnemy()
		
				if enemy and ( IsValid( enemy ) and enemy:Health() > 0 ) then
					self.loco:FaceTowards( enemy:GetPos() )
				end
			
				self.NextLookTimer = CurTime() + 0.25
			end
		
		end
	
		if self.DownedOnGround then
			self:ResetSequence( "wos_l4d_idle_incap_pistol" )
		end
	
	end
	
end

function ENT:CustomOnThink()

end

function ENT:OnKilled( dmginfo )
	
	if self.HitByVehicle then 
	return end
	
	if dmginfo:GetAttacker().NEXTBOTZOMBIE or self:IsPlayerZombie( dmginfo:GetAttacker() ) then
	
		self:RiseAsZombie( self, "nb_rise_base", "nb_freshdead", "", 100, true )
	
		if self.Weapon then
			SafeRemoveEntity( self.Weapon)
		end
	
	else
	
		if !self.Downed then
		
			if dmginfo:IsExplosionDamage() then
				self:BecomeRagdoll( dmginfo )
				self:DropWeapon()
			else
				if dmginfo:GetDamage() > 50 then
					self:BecomeRagdoll( dmginfo )
					self:DropWeapon()
				else
					if nb_death_animations:GetInt() == 1 then
						self:DeathAnimation( "nb_deathanim_base", self:GetPos(), self.WalkAnim, 1, self.WeaponClass, "ent_fakeweapon" )
						
						if self.Weapon then
							SafeRemoveEntity( self.Weapon)
						end
					else
						self:BecomeRagdoll( dmginfo )
						self:DropWeapon()
					end
				end
			end
		
		else
		
			self:BecomeRagdoll( dmginfo )
			self:DropWeapon()
			
		end
	
	end
	
	self:PlayDeathSound()
	
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
				dmginfo:ScaleDamage(3)
				
				local effectdata = EffectData()
					effectdata:SetStart( dmginfo:GetDamagePosition() ) 
					effectdata:SetOrigin( dmginfo:GetDamagePosition() )
					effectdata:SetScale( 1 )
				util.Effect( "StunStickImpact", effectdata )
				
				self:EmitSound("hits/armor_hit.wav")
			end

			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				dmginfo:ScaleDamage(0.7)
				self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
			end
	end

	if !self.Downed and !self.GettingUp then
		self:Flinch( dmginfo, hitgroup )
		self:CheckEnemyPosition( dmginfo )
	else
		dmginfo:ScaleDamage( 0.5 )
	end
	
	if nb_allow_reviving:GetInt() == 1 then
		self:CheckIfDowned( dmginfo )
	end

	self:PlayPainSound()
	
end

function ENT:WOSRevive()

	if !self.DownedOnGround then return end

	if !self.GettingUp then
		
		self:SetHealth( ( self:Health() + 150 ) )
		
		self.loco:ClearStuck()
		
		self.WOS_InLastStand = false
		
		if nb_revive_players then
			wOS.LastStand.InLastStand[ self ] = false
		end
			
		if nb_revive_players then		
			net.Start( "wOS.LastStand.ToggleLS" )
			net.WriteBool( false )
			net.WriteEntity( self )
			net.Broadcast()
		end
		
		self.GettingUp = true
		self:BehaveStart()
		
	end
	
end

function ENT:WOSIncap()
	if self.Downed then return end
	
	self.Downed = true
			
	self.WOS_InLastStand = true
			
	if nb_revive_players then		
		wOS.LastStand.InLastStand[ self ] = true	
		
		net.Start( "wOS.LastStand.ToggleLS" )
		net.WriteBool( true )
		net.WriteEntity( self )
		net.Broadcast()
	end
end

function ENT:WOSGetIncapped()
	return self.WOS_InLastStand
end

function ENT:CheckIfDowned( dmginfo )

	if self.HitByVehicle then return end

	if !self.Downed then

		if ( self:Health() < 80 and self:Health() > 1 ) then

			if math.random(1,3) == 1 then
				self:WOSIncap()
				self:BehaveStart()
			end
			
		end
	
	end
	
end

function ENT:IsBot()
	return true
end

function ENT:Nick()
	local NextbotList = list.Get( "sean_nextbots" )
	local nextbot = NextbotList[ self:GetClass() ]

	if !nextbot then
		return "Friendly"
	end
	
	return nextbot.Name
end