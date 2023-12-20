AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_combine", "Combine")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_combine_juggernaut", 	
{	Name = "Combine Juggernaut", 
	Class = "nb_combine_juggernaut",
	Category = "Combine"	
})

ENT.Base = "nb_combine_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 9

ENT.HealthAmount = 400

ENT.Speed = 55
ENT.PatrolSpeed = 55
ENT.SprintingSpeed = 255
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 0

ENT.AccelerationAmount = 500
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.ShootRange = 600
ENT.MeleeRange = 60
ENT.StopRange = 500
ENT.BackupRange = 300

ENT.MeleeDamage = 30
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 30
ENT.WeaponSpread = 0.1
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_ar3"

ENT.Weapons = {"wep_nb_ar3"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/armored_soldier.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_AR2
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = "walkHOLDALL_MG" 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnims = {"melee_gunhit"}

--Sounds--
ENT.AttackSounds = {""} --Melee Sounds
ENT.AttackSounds2 = {""} --Shooting Sounds

ENT.PainSounds = {"npc/combine_soldier/pain1.wav",
"npc/combine_soldier/pain2.wav",
"npc/combine_soldier/pain3.wav"}

ENT.AlertSounds = {"npc/combine_soldier/vo/target.wav", --Normal alert sounds
"npc/combine_soldier/vo/sweepingin.wav",
"npc/combine_soldier/vo/prosecuting.wav",
"npc/combine_soldier/vo/movein.wav",
"npc/combine_soldier/vo/engaging.wav",
"npc/combine_soldier/vo/contact.wav",
"npc/combine_soldier/vo/contactconfim.wav",
"npc/combine_soldier/vo/contactconfirmprosecuting.wav",
"npc/combine_soldier/vo/alert1.wav",
"npc/combine_soldier/vo/unitisclosing.wav",
"npc/combine_soldier/vo/unitisinbound.wav",
"npc/combine_soldier/vo/unitismovingin.wav",
"npc/combine_soldier/vo/readyweapons.wav",
"npc/combine_soldier/vo/readyweaponshostilesinbound.wav",
"npc/combine_soldier/vo/prepforcontact.wav",
"npc/combine_soldier/vo/executingfullresponse.wav",
"npc/combine_soldier/vo/callcontacttarget1.wav",
"npc/combine_soldier/vo/callhotpoint.wav",
"npc/combine_soldier/vo/inbound.wav"}
ENT.AlertSounds2 = {"npc/combine_soldier/vo/outbreak.wav", --If spotted zombie
"npc/combine_soldier/vo/outbreakstatusiscode.wav",
"npc/combine_soldier/vo/containmentproceeding.wav",
"npc/combine_soldier/vo/callcontactparasitics.wav",
"npc/combine_soldier/vo/wehavefreeparasites.wav",
"npc/combine_soldier/vo/necrotics.wav",
"npc/combine_soldier/vo/necroticsinbound.wav",
"npc/combine_soldier/vo/infected.wav",
"npc/combine_soldier/vo/infected.wav",
"npc/combine_soldier/vo/infected.wav"}

ENT.DeathSounds = {"npc/combine_soldier/die1.wav",
"npc/combine_soldier/die2.wav",
"npc/combine_soldier/die3.wav"}

ENT.IdleSounds = {"npc/combine_soldier/vo/isfieldpromoted.wav",
"npc/combine_soldier/vo/isfinalteamunitbackup.wav",
"npc/combine_soldier/vo/isholdingatcode.wav",
"npc/combine_soldier/vo/hardenthatposition.wav",
"npc/combine_soldier/vo/overwatch.wav",
"npc/combine_soldier/vo/reportallpositionsclear.wav",
"npc/combine_soldier/vo/reportallradialsfree.wav",
"npc/combine_soldier/vo/reportingclear.wav",
"npc/combine_soldier/vo/secure.wav",
"npc/combine_soldier/vo/sightlineisclear.wav"}

ENT.ReloadingSounds = {"npc/combine_soldier/vo/cover.wav", --Standing reloading sounds 
"npc/combine_soldier/vo/coverme.wav",
"npc/combine_soldier/vo/copy.wav",
"npc/combine_soldier/vo/copythat.wav"} 
ENT.ReloadingSounds2 = {"npc/combine_soldier/vo/coverhurt.wav", --If running away to reload
"npc/combine_soldier/vo/displace.wav",
"npc/combine_soldier/vo/displace2.wav",
"npc/combine_soldier/vo/dash.wav"}

ENT.RevivingFriendlySounds = {"npc/combine_soldier/vo/requestmedical.wav",
"npc/combine_soldier/vo/requeststimdose.wav"}

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_ar3" then
	
		self.WeaponTracer = "AR2Tracer"
	
		self.RunningReloadAnim = "gesture_reload"
		self.StandingReloadAnim = "reload_mg"
		self.CrouchingReloadAnim = "gesture_reload"
		self.WalkAnim = "walkHOLDALL_MG"
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_GESTURE_RANGE_ATTACK_SMG1 
		self.WeaponSound = "sean_wepnb_sound_ar3"
		self.WeaponSpread = 1
		self.ShootRange = 1500
		self.StopRange = 1000
		self.BulletForce = 10
		self.ShootDelay = 0.001
		self.BulletNum = 2
		self.BulletDamage = 5
		self.ClipAmount = 150
	
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		
		local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end

		self:SetHealth( self.HealthAmount )
	
	end
	
	local weapon = table.Random( self.Weapons )
		if weapon == "" or nil then
		self.WeaponClass = self.WeaponClass
		self:SetWeaponType( self.WeaponClass )
	else
		self.WeaponClass = weapon
		self:SetWeaponType( weapon )
	end

	if self.Risen then
		self.WeaponClass = "wep_nb_ar2"
		self:SetWeaponType( "wep_nb_ar2" )
	end
	
	self:EquipWeapon()
	
	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	self.Downed = false
	self.DownedOnGround = false
	self.GettingUp = false

	self.move_ang = Angle()
	self.loco:SetMaxYawRate( 180 )
	
end

function ENT:MovementFunction2( type )

	if type == "reloading" then
		self:StartMovementAnim( self.SprintingAnim, self.SprintingSpeed, 1 )
	elseif type =="standreload" then
		self:StartMovementAnim( self.WalkAnim, self.Speed, 1 )
	elseif type == "crouching" then
		self:StartMovementAnim( self.CrouchAnim, self.CrouchSpeed, 1 )
	elseif type == nil then
		self:StartMovementAnim( self.WalkAnim, self.Speed )
	end
	
end

function ENT:MovementFunction( type )

	if IsValid( self.Enemy ) and self.Enemy:Health() > 0 and self.Enemy then
		
		if ( self.loco:GetVelocity():IsZero() and self:GetRangeTo( self.Enemy ) < self.ShootRange and self:GetRangeTo( self.Enemy ) > self.BackupRange and self:Visible( self.Enemy ) ) then
		
			self:ResetSequence( "shoot_mg" )
			self.loco:SetDesiredSpeed( 0 )
				
			self.WeaponSpread = 0.45
		
		else
			
			self.WeaponSpread = 2
			self:MovementFunction2( type )
			
		end
		
	else
		
		self:MovementFunction2( type )
		
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

	self:BodyMoveYaw()
	
	self:FrameAdvance() --Frame advance sets animation speed to ground speed.. Will speed up gestures if called
	
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
		if self.Enemy.Downed then
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
			
			if !self.Reloading and !self.ReloadAnimation and !self.IsAttacking then
			
				if ( ( self:GetRangeSquaredTo( self.Enemy ) < self.ShootRange*self.ShootRange and self:GetRangeSquaredTo( self.Enemy ) > (self.MeleeRange + 1)*(self.MeleeRange + 1) ) and self:IsLineOfSightClear( self.Enemy )  and !self:CheckDoor() ) then

					self:PoseParameters()
						
					if ( self.NextAttackTimer or 0 ) < CurTime() then
					
						self:ShootWeapon()	
						self:PlayAttackSound( 2 )
					
						self.NextAttackTimer = CurTime() + self.ShootDelay
						
					end
					
				end
					
			end	
					
			if !self.ReloadAnimation and !self.Reloading and !self.IsAttacking then
				
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

function ENT:ChaseEnemy( options )

	local enemy = self:GetEnemy()
	local pos = enemy:GetPos()
	
	local options = options or {}
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 30 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if (!path:IsValid() ) then return "failed" end
	
	if !enemy then return "failed" end
	
	if !enemy:IsValid() then return "failed" end
	
	if enemy:Health() < 0 then return "failed" end
	
	while ( path:IsValid() and self:HaveEnemy() and ( enemy and enemy:IsValid() and enemy:Health() > 0) ) do

		self:MovementFunction()
	
		if nb_allow_backingup:GetInt() == 1 then
			if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange and self:GetRangeSquaredTo( enemy ) > (self.BackupRange + 1)*(self.BackupRange + 1) ) and self:IsLineOfSightClear( enemy ) and !self.IsJumping then 
				return "failed"
			elseif self:GetRangeSquaredTo( enemy ) <= self.BackupRange*self.BackupRange and self:IsLineOfSightClear( enemy ) and ( !self.loco:IsStuck() ) and !self.IsJumping then
				self:BackUp()
			end
		else
			if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange ) and self:IsLineOfSightClear( enemy ) and !self.IsJumping then 
				return "failed"
			end
		end
	
		if nb_doorinteraction:GetInt() == 1 then
			if !self:CheckDoor() then
			
			elseif ( self:CheckDoor():IsValid() and self:GetRangeSquaredTo( self:CheckDoor() ) < self.StopRange*self.StopRange and self:IsLineOfSightClear( self:CheckDoor() ) ) then
				self:ContactDoor( self:CheckDoor() )
				return "ok"
			end
		end
	
		if ( !self.Reloading and !self.loco:IsStuck() and ( enemy and enemy:IsValid() and enemy:Health() > 0) ) then
		
				if ( path:GetAge() > options.maxage ) then	

					path:Compute( self, enemy:GetPos(), function( area, fromArea, ladder, elevator, length )
					if ( !IsValid( fromArea ) ) then
						return 0
					else

						if ( !self.loco:IsAreaTraversable( area ) ) then
							return -1
						end

						local dist = 0

						local cost = dist + fromArea:GetCostSoFar()

						local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
						if ( deltaZ >= self.loco:GetStepHeight() ) then
					
							if ( deltaZ >= self.loco:GetMaxJumpHeight() ) then
								return -1
							end

							local jumpPenalty = 5
							cost = cost + jumpPenalty * dist
							
						elseif ( deltaZ < -self.loco:GetDeathDropHeight() ) then
							return -1
						end

					return cost
					
					end
					end)

				end

		path:Update( self )	
		
		if ( options.draw ) then
			path:Draw()
		end
		
	end	
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck( 0 )
			return "stuck"
		end
		
		coroutine.yield()
	end
	
	return "ok"
end

function ENT:RunBehaviour()

	while ( true ) do

		self:GrenadeThrow()

		if self:HaveEnemy() then
				
			local enemy = self:GetEnemy()	
						
			self.Patrolling = false

			if self.Reloading then
				self:ReloadWeapon( "running" )
			end
						
			if !self.GoingToSpot then
					
				pos = enemy:GetPos()	
								
				if ( pos ) and enemy:IsValid() and enemy:Health() > 0 then
							
					self:MovementFunction()	

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
			self.Patrolling = true

			--if self.BulletsUsed != 0 then
				--self:ReloadWeapon( "running" )
			--end
				
			self:PlayIdleSound()
					
			self:MovementFunction()
					
			local pos = self:FindSpot( "random", { radius = 5000 } )

			if ( pos ) then
				self:MoveToPos( pos )
			end

		end
		
		coroutine.yield()
		
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
		if ( ent.NEXTBOT and !ent.NEXTBOTCOMBINE ) or ( ent:IsPlayer() and self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) then
			if ( self.NextMeleeTimer or 0 ) < CurTime() then
				self:Melee( ent )
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
			
			if ( self.NextSwitchTargetTimer or 0 ) < CurTime() then
				self:SetEnemy( ent )
				self:BehaveStart()
				self.NextSwitchTargetTimer = CurTime() + 1
			end
		end
	end
	
	if self.GoingToSpot then
		if ( self.NextSpotTimer or 0 ) < CurTime() then
			if ent.GoingToSpot then
				if ent.CurrentSpotVector:IsEqualTol( self.CurrentSpotVector, 50 ) then
					if self:GetRangeTo( self.CurrentSpotVector ) > 100 then
						self:LookForSpot()
						--print("New spot ",self)
					end
				end
			end
			self.NextSpotTimer = CurTime() + 1
		end	
	end
	
	self:CustomOnContact2( ent )
	
end

function ENT:OnKilled( dmginfo )
	
	if self.HitByVehicle then
	return end
	
	self:BecomeRagdoll( dmginfo )
	self:DropWeapon()
	
	self:PlayDeathSound()
	
end