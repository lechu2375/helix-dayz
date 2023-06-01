if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

ENT.Base = "nb_vehicle_hit_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
ENT.ChaseDistance = 3000

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 180
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 700
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
ENT.WeaponSpread = 0.6
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_shotgun"
ENT.WeaponSound = "Weapon_Shotgun.Single"

ENT.PistolClass = "wep_nb_pistol"
ENT.PistolSound = "Weapon_Pistol.Single"

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
	
		self.FriendlyToPlayers = false
		self.NEXTBOTFACTION = 'NEXTBOTREBEL'
		self.NEXTBOTREBEL = true
		self.NEXTBOT = true
		
		--Status
		self.NextCheckTimer = CurTime() + 4
		self.LookForSpotCount = 0
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
		self.FriendlyToPlayers = true
		self.NEXTBOTFACTION = 'NEXTBOTREBEL'
		self.NEXTBOTREBEL = true
		self.NEXTBOT = true
		
		self.Downed = false
		self.DownedOnGround = false
		
		if nb_revive_players then
			wOS.LastStand.InLastStand[ self ] = false
		end
		
		self.WOS_InLastStand = false
		self.GettingUp = false
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

function ENT:CustomOnContact2( ent )

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

function ENT:MovementFunction( type )
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

function ENT:Use( activator, caller )

	if ( self.NextFollowTimer or 0 ) < CurTime() then
					
		if caller:IsPlayer() and !self:IsPlayerZombie( caller ) then

			if !self.FollowingPlayer then --Following
				self.FollowingPlayer = true
				self.EntityFollowing = caller
			
				self:BehaveStart()
			
				self:AddGesture( ACT_GMOD_GESTURE_BOW, true )
				
				local randomsound = table.Random( self.FollowingSounds )
				self:EmitSound( Sound( randomsound ), 100, self.FollowingSoundsPitch or 100 )
			
				self.NextFollowTimer = CurTime() + 1
			else --UnFollowing
				self.FollowingPlayer = false
				self.EntityFollowing = nil
			
				self:BehaveStart()
				
				self:AddGesture( ACT_GMOD_TAUNT_SALUTE, true )
				
				local randomsound = table.Random( self.FollowingSounds2 )
				self:EmitSound( Sound( randomsound ), 100, self.FollowingSounds2Pitch or 100 )
				
				self.NextFollowTimer = CurTime() + 1
			end

		end			
					
		
	end

end

function ENT:LookForSpot( count )

	if self.Enemy and IsValid( self.Enemy ) then

		if !self.GoingToSpot then
	
			local spottype 
			if math.random(1,3) == 1 then
				spottype = "near"
			elseif math.random(1,3) == 2 then
				spottype = "far"
			elseif math.random(1,3) == 3 then
				spottype = "hiding"
			end
	
			if self.Enemy.NEXTBOTZOMBIE then --Find spot as far away if enemy is a zombie
				spottype = "far"
			end
	
			local spot = self:FindSpotFunction( spottype, 3000 )
			
			if spot == nil then --If we could not find any spots then stand reload
				self.GoingToSpot = true
				self:ChooseRandomReload( "running", "standing" )
			else
				spot = spot + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 15
				
				if isvector( spot ) then	
					--debugoverlay.Cross( spot, 10, 10, color_white, true )
					
					local tr = util.TraceLine( {
						start = self.Enemy:GetPos() + Vector(0,0,45),
						endpos = spot,
						mask = MASK_BLOCKLOS,
						filter = self
					} )

					--debugoverlay.Line( self.Enemy:GetPos() + Vector(0,0,30), spot, 10, color_white, true )

					if ( tr.Hit and !tr.HitPos:IsEqualTol( spot, 50 )  ) then
						self.GoingToSpot = true
						self.LookForSpotCount = 0
						self.CurrentSpotVector = spot
						self:MovementFunction( "reloading" )
						self:MoveToPos( spot )
						--Reload
						self:ChooseRandomReload( "running", "standing" )
						self.GoingToSpot = false
					else
						--self.LookForSpotCount = self.LookForSpotCount + 1
							
						--if self.LookForSpotCount >= 3 then --If spots are taken after three calls, then reload standing
							--self.LookForSpotCount = 0
							--if math.random(1,2) == 1 then
								--self:ReloadWeapon( "running" )
							--elseif math.random(1,2) == 2 then
								--self:ReloadWeapon( "standing" )
							--end
						--else
							--self:LookForSpot( self.LookForSpotCount )
						--end
						--print("No hit ", self)
					end
				else
					--No reload spot
					--print("Bad spot ", self)
					self.GoingToSpot = true
					self:ChooseRandomReload( "running", "standing" )
				end
			end
			
		end	
		
	else
		--print("Enemy not valid", self)
	end
			
end

function ENT:ReloadBehaviour()

	if ( self.NextReloadCheck or 0 ) < CurTime() then

		if nb_soldier_findreloadspot:GetInt() == 1 then
		
			if !self.GoingToSpot and !self.ReloadAnimation then
			
				if ( IsValid( self.Enemy ) and self.Enemy:Health() > 0 ) then

					if ( ( self:Health() < ( self.HealthAmount / 2 ) or self:GetRangeTo( self.Enemy ) < ( self.BackupRange / 2) ) and !self.FollowingPlayer and self.CanRunReload ) then
						self:PlayReloadingSound( 2 )
						self:LookForSpot( self.LookForSpotCount )
					else
						self:PlayReloadingSound()
						self:ChooseRandomReload( "running", "standing" )
					end
				
				else
				
					if ( self:Health() < ( self.HealthAmount / 2 ) and !self.FollowingPlayer and self.CanRunReload ) then
						self:PlayReloadingSound( 2 )
						self:LookForSpot( self.LookForSpotCount )
					else
						self:PlayReloadingSound()
						self:ChooseRandomReload( "running", "standing" )
					end
				
				end
				
			end
			
		else
		
			self:ChooseRandomReload( "running", "standing" )
			
		end
	
		self.NextReloadCheck = CurTime() + 0.05
	end
	
end

function ENT:RunBehaviour()

	while ( true ) do

		if((self.nextActivationCheck or 0)<CurTime()) then
			local isSleeping = true
			for _,v in pairs(player.GetAll()) do
				if(self:GetRangeSquaredTo(v)<=3411715) then
					
					isSleeping = false
					break
				end
			end
			self.sleeping = isSleeping
			if(SleepCheck) then
				print(self,"is sleeping:",self.sleeping)
			end
			self.nextActivationCheck = CurTime()+math.random(5, 7)
		end
		if(!self.sleeping) then
			if self:HaveEnemy() then
				
				local pos
				
				if !self.Reloading then
		
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

						pos = self:GetEnemy():GetPos()	
						
						if ( pos ) and self:GetEnemy():IsValid() and self:GetEnemy():Health() > 0 then
					
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
					
					end
						
				else

					self:ReloadBehaviour()

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

					self:MovementFunction()

				end
				
				self:PlayIdleSound()
				
			end
		end
		coroutine.yield()


	end


end

function ENT:BehaveUpdate( fInterval )

	if ( !self.BehaveThread ) then return end
	
		self:CustomBehaveUpdate()
		
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then

		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );

	end

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

	if self:HaveEnemy() and self.Enemy then
		
		if !self.Reloading then

			if ( ( self:GetRangeSquaredTo( self.Enemy ) < self.ShootRange*self.ShootRange and self:GetRangeSquaredTo( self.Enemy ) > (self.MeleeRange + 1)*(self.MeleeRange + 1) ) and self:IsLineOfSightClear( self.Enemy )  and !self:CheckDoor() ) then

				self:PoseParameters()
					
				if ( self.NextAttackTimer or 0 ) < CurTime() then
					self:ShootWeapon()
					self:PlayAttackSound( 2 )
					self.NextAttackTimer = CurTime() + self.ShootDelay
				end
				
			end
				
		end	
				
		if !self.ReloadAnimation then
			
			if self.Enemy and ( self:GetRangeSquaredTo( self.Enemy ) < self.MeleeRange*self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then

				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:Melee( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end

			end
				
		end
				
	end

end

function ENT:Melee( ent, type )
	self:PlayAttackSound()	
	self:PlayGestureSequence( self.MeleeAnim )
	self.loco:FaceTowards( ent:GetPos() )
	
	timer.Simple( 0.4, function()
		if ( IsValid(self) and self:Health() > 0) and IsValid(ent) then
		
			if self:GetRangeSquaredTo( ent ) > self.MeleeRange*self.MeleeRange then return end
		
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

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:SetEnemy( ent )
	
	self.Enemy = ent

	if ent and ent:IsValid() and ent:Health() > 0 then
		if ent.NEXTBOTZOMBIE or ( ent:IsPlayer() and self:IsPlayerZombie( ent ) ) then
			self:PlayAlertSound( 2 )
		else
			self:PlayAlertSound()
		end
		self:AlertNearby()
	end

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
					if v:IsPlayer() and !v:IsBandit()then --Remove players who are not zombies from pool of enemies
						if !self:IsPlayerZombie( v ) then
							table.remove( enemies, k )	
						else
							if !v:Alive() then --Remove dead zombie players from pool of enemies
								table.remove( enemies, k )
							end
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

function ENT:BodyUpdate()

	--if !self.ReloadAnimation then

		--self:BodyMoveXY()
	
		if ( self:GetActivity() == self.WalkAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.Speed )
			
		elseif ( self:GetActivity() == self.SprintingAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.SprintingSpeed )
		
		elseif ( self:GetActivity() == self.CrouchAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.CrouchSpeed )
		
		end

	--end
	
	--self:FrameAdvance()wait

end

function ENT:BackUp()
	
	local enemy = self:GetEnemy()
	
	if IsValid( self ) and self:Health() > 0 then
		if self.Reloading then return end
		if self.ReloadAnimation then return end
		if self.GoingToRevive then return end
	
		if enemy and enemy:IsValid() and enemy:Health() > 0 then
			self:MovementFunction()
	
			while( ( enemy:IsValid() and enemy:Health() > 0) and self:GetRangeSquaredTo( enemy ) < self.BackupRange*self.BackupRange and !self.Reloading ) do
		
				local back = self:GetPos() + self:GetAngles():Forward() * -628
		
				self.loco:Approach(back, self.BackupRange)
				coroutine.wait(0.05)
			end
			self:MovementFunction()

		coroutine.yield()
	
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

		if self.Patrolling then
			if self:HaveEnemy() and !self.Reloading then
				return "failed"
			end
		end
	
		if self.FollowingPlayer then
			if self:IsPlayerZombie( self.EntityFollowing ) then
				self.FollowingPlayer = false
				self.EntityFollowing = nil
				return "failed"
			end
		
			if ( self:GetRangeSquaredTo( self.EntityFollowing ) < 90*90 ) then 
				return "ok"
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

		if nb_allow_backingup:GetInt() == 1 then
			if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange and self:GetRangeSquaredTo( enemy ) > (self.BackupRange + 1)*(self.BackupRange + 1) ) and self:IsLineOfSightClear( enemy ) and !self.IsJumping then 
				return "failed"
			elseif self:GetRangeSquaredTo( enemy ) <= self.BackupRange*self.BackupRange and self:IsLineOfSightClear( enemy ) and ( !self.loco:IsStuck() ) and !self.IsJumping and !self.Patrolling then
				self:BackUp()
				--return "failed"
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

function ENT:OnLeaveGround( ent )

	--self:RestartGesture( self.JumpAnim )

end

function ENT:OnLandOnGround()

	self.IsJumping = false
	
	--if !self.Downed then
	
		--if self.Reloading then
			--self:MovementFunction( "reloading" )
		--else
			--self:MovementFunction()
		--end
	
	--end
	
end

function ENT:OnNavAreaChanged( old, new )

	if !self.Downed then

		if old:HasAttributes( 1 ) then
			if !self.Reloading then
				self:MovementFunction( "crouching" )
			else
				
			end
			self.Crouching = true
		else
			if !self.Reloading then
				self:MovementFunction()
			end
			self.Crouching = false
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
				dmginfo:ScaleDamage(8)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end
	end

	self:Flinch( dmginfo, hitgroup )
	
	self:CheckEnemyPosition( dmginfo )
	
	self:PlayPainSound()
	
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
				if !self.Reloading and !self.GoingToSpot and !self.ReloadAnimation then
					self.CanRunReload = false
					self.WalkAnim = self.FlinchWalkAnim
					self.Speed = self.FlinchWalkSpeed
					self:BehaveStart()
				end
			end
		end	
		
		self.NextFlinchTimer = CurTime() + 0.5
	end
	
end

function ENT:OnRemove()

	if self.Weapon then
		SafeRemoveEntity( self.Weapon )
	end
	
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
		
	end
	hook.Run( "OnNPCKilled",self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:PlayDeathSound()
	
end

function ENT:DropWeapon()
	
	if !self.Weapon then return end
	
	local ent = ents.Create( "ent_fakeweapon" )
	
	if ent:IsValid() and self:IsValid() then	
	
		ent:SetModel( self.Weapon:GetModel() )
		
		if self.DownedOnGround then
			ent:SetPos( self:GetPos() + Vector( 0,0,5 ) )
		else
			ent:SetPos( self:GetPos() + Vector( 0,0,50 ) )
		end
		
		ent:SetAngles( self.Weapon:GetAngles() )
		ent:Spawn()
	
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 100))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 100))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 20, 200 ))
				
		end
		
	end
	
	SafeRemoveEntity( self.Weapon )

end

function ENT:PlayAttackSound( type )
	if self:Health() < 0 then return end

	if ( self.NextAttackSoundTimer or 0 ) < CurTime() then
	
		local randomsound 
		
		--Type 2 is when bot is shooting weapon, otherwise play normal attack sounds
		
		if type == 2 then
			if self.AttackSounds2 then
				randomsound = table.Random( self.AttackSounds2 )
			else
				randomsound = table.Random( self.AttackSounds )
			end
		else
			randomsound = table.Random( self.AttackSounds )
		end

		self:EmitSound( Sound( randomsound ), 100, self.AttackSoundPitch or 100, 1, CHAN_VOICE )
		
		self.NextAttackSoundTimer = CurTime() + math.random(7,16)
	end
end

function ENT:PlayPainSound()
	if self:Health() < 0 then return end

	if ( self.NextPainSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.PainSounds )
		self:EmitSound( Sound( randomsound ), 100, self.PainSoundPitch or 100, 1, CHAN_VOICE )
	
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
	
		self:EmitSound( Sound( randomsound ), 100, self.AlertSoundPitch or 100, 1, CHAN_VOICE )
	
		self.NextAlertSoundTimer = CurTime() + math.random(8,12)
	end
end

function ENT:PlayDeathSound()
	if ( self.NextDeathSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.DeathSounds )
		self:EmitSound( Sound( randomsound ), 100, self.DeathSoundPitch or 100, 1, CHAN_VOICE )
	
		self.NextDeathSoundTimer = CurTime() + 1
	end
end

function ENT:PlayIdleSound()
	if self:Health() < 0 or self.IsAttacking or self.Flinching then return end
	if self.Enemy then return end
	
	if ( self.NextIdleSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.IdleSounds )
		self:EmitSound( Sound( randomsound ), 100, self.IdleSoundPitch or 100, 1, CHAN_VOICE )
	
		self.NextIdleSoundTimer = CurTime() + math.random(5,16)
	end
end

function ENT:PlayReloadingSound( type )
	if self:Health() < 0 then return end

	if ( self.NextReloadVoiceTimer or 0 ) < CurTime() then
	
		local randomsound 
	
		if type == 2 then
			if self.ReloadingSounds2 then
				randomsound = table.Random( self.ReloadingSounds2 )
			else
				randomsound = table.Random( self.ReloadingSounds )
			end
		else
			randomsound = table.Random( self.ReloadingSounds )
		end
	
		self:EmitSound( Sound( randomsound ), 100, self.ReloadingSoundPitch or 100, 1, CHAN_VOICE )
	
		self.NextReloadVoiceTimer = CurTime() + math.random(8,12)
	end
end