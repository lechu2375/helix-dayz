AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_mercenary_condottiere", "Condottiere")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_mercenary_condottiere", 	
{	Name = "Condottiere", 
	Class = "nb_mercenary_condottiere",
	Category = "Mercenaries"	
})

ENT.Base = "nb_soldier_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 7

ENT.HealthAmount = 5000

ENT.Speed = 135
ENT.PatrolSpeed = 55
ENT.SprintingSpeed = 255
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 800
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.GrenadeDelay = 7
ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.GrenadeRange = 950
ENT.ShootRange = 600
ENT.MeleeRange = 80
ENT.StopRange = 500
ENT.BackupRange = 300

ENT.MeleeDamage = 150
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 30
ENT.WeaponSpread = 0.1
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_m3gauge"

ENT.Weapons = {"wep_nb_m249"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/arachnit/csgoheavyphoenix/tm_phoenix_heavyplayer.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_AR2
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnims = {"aoc_halberd_slash_02_mod"}

--Sounds--
ENT.AttackSounds = {"nextbots/mercenary/attack1.wav", --Melee Sounds
"nextbots/mercenary/attack2.wav",
"nextbots/mercenary/attack3.wav",
"nextbots/mercenary/attack4.wav",
"nextbots/mercenary/attack5.wav",
"nextbots/mercenary/attack6.wav",
"nextbots/mercenary/attack7.wav"}
ENT.AttackSounds2 = {"nextbots/mercenary/attack1.wav", --Shooting Sounds
"nextbots/mercenary/attack2.wav",
"nextbots/mercenary/attack3.wav",
"nextbots/mercenary/attack4.wav",
"nextbots/mercenary/attack5.wav",
"nextbots/mercenary/attack6.wav",
"nextbots/mercenary/attack7.wav"}
ENT.AttackSoundPitch = math.random(70,70)

ENT.PainSounds = {"nextbots/mercenary/pain1.wav",
"nextbots/mercenary/pain2.wav",
"nextbots/mercenary/pain3.wav",
"nextbots/mercenary/pain4.wav",
"nextbots/mercenary/pain5.wav",
"nextbots/mercenary/pain6.wav"}
ENT.PainSoundPitch = math.random(70,75)

ENT.AlertSounds = {""}

ENT.DeathSounds = {"nextbots/mercenary/death1.wav",
"nextbots/mercenary/death2.wav",
"nextbots/mercenary/death3.wav",
"nextbots/mercenary/death4.wav",
"nextbots/mercenary/death5.wav",
"nextbots/mercenary/death6.wav",
"nextbots/mercenary/death7.wav"}
ENT.DeathSoundPitch = math.random(70,70)

ENT.IdleSounds = {"nextbots/mercenary/idle1.wav",
"nextbots/mercenary/idle2.wav",
"nextbots/mercenary/idle3.wav",
"nextbots/mercenary/idle4.wav",
"nextbots/mercenary/idle5.wav",
"nextbots/mercenary/idle6.wav"}
ENT.IdleSoundPitch = math.random(70,70)

ENT.ReloadingSounds = {""} --Standing reloading sounds 
ENT.ReloadingSounds2 = {""} --If running away to reload
ENT.ReloadingSoundPitch = math.random(80,90)

ENT.RevivingFriendlySounds = {""}

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_m249" then
	
		self.RunningReloadAnim = "reload_dual"
		self.StandingReloadAnim = "reload_dual_original"
		self.CrouchingReloadAnim = "reload_dual"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.WeaponSound = "sean_wepnb_sound_m249"
		self.WeaponSpread = 2
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 15
		self.ShootDelay = 0.05
		self.BulletNum = 2
		self.BulletDamage = 10
		self.ClipAmount = 150

	end
	
end

function ENT:CustomInitialize()

	local model = table.Random( self.Models )
	if model == "" or nil then
		self:SetModel( "models/player/charple.mdl" )
	else
		--util.PrecacheModel( table.ToString( self.Models ) )
		self:SetModel( model )
	end

	self:SetHealth( self.HealthAmount )
	
	self:SetModelScale( 1.1, 0 )
		
	self.HeadArmor = 400
	self.FrontArmor = 800
	self.BackArmor = 800
	
	local weapon = table.Random( self.Weapons )
		if weapon == "" or nil then
		self.WeaponClass = self.WeaponClass
		self:SetWeaponType( self.WeaponClass )
	else
		self.WeaponClass = weapon
		self:SetWeaponType( weapon )
	end

	self:EquipWeapon()
	
	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	self.Downed = false
	self.DownedOnGround = false
	self.GettingUp = false
	
	self.GrenadeThrowAnims = { ACT_GMOD_GESTURE_RANGE_THROW, ACT_GMOD_GESTURE_ITEM_DROP, ACT_GMOD_GESTURE_ITEM_GIVE }
	self.ThrowingGrenade = false
	
end

function ENT:BodyUpdate()

	if self.ReloadAnimation or self.IsAttacking then

		self:BodyMoveXY()
		
	else

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
	
		--self:FrameAdvance() --Frame advance sets animation speed to ground speed.. Will speed up gestures if called
	
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

function ENT:RunBehaviour()

	while ( true ) do

		self:GrenadeThrow()

		if self:HaveEnemy() then
						
			local enemy = self:GetEnemy()	
						
			self.Patrolling = false

				if self.Reloading then
					self:ReloadWeapon( "running" )
				end
					
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
								
							self.Strafing = false
								
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
			self.Patrolling = true

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

function ENT:ReloadWeapon( type )

	if !self.Crouching or self.Downed then

		if type == "running" then
			if !self.ReloadAnimation then
			
				self.ReloadAnimation = true
		
				local reloadanim = self.RunningReloadAnim
				self:PlayGestureSequence( self.RunningReloadAnim )

				if !self.Downed then
					timer.Simple( ( self:SequenceDuration( reloadanim ) + 2 ), function()
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
			
			timer.Simple( ( self:SequenceDuration( reloadanim ) + 2 ), function()
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

				coroutine.wait(0.05)
				
			end
			
			self:MovementFunction()

			coroutine.yield()
	
		end
	
	end
	
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		--if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		
		local phys = ent:GetPhysicsObject()
		if (phys != nil && phys != NULL && phys:IsValid() ) then
			local knockback = ent:GetVelocity():Length() * 2000
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
		
			self.NextDamageTimer = CurTime() + 1
		end
		
	end

	if ent != self.Enemy then
		if ( ent:IsPlayer() and ai_ignoreplayers:GetInt() == 0 ) or ( ent.NEXTBOT and !ent.NEXTBOTMERCENARY ) then
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
	
	self:CustomOnContact2( ent )
	
end

function ENT:Melee( ent, type )
	self.IsAttacking = true

	self:PlayAttackSound()
	self:PlayGestureSequence( table.Random( self.MeleeAnims ) )
	
	self.loco:FaceTowards( ent:GetPos() )
	
	timer.Simple( 0.85, function()
		if ( IsValid(self) and self:Health() > 0) then
		
			if IsValid(ent) and ent:Health() > 0 then
		
				if self.Downed then return end
		
				if self:GetRangeTo( ent ) > self.MeleeRange then return end
			
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
				ent:EmitSound( "Flesh.ImpactHard", 100, 55 )
				
				if type == 1 then --Prop
					local phys = ent:GetPhysicsObject()
					if (phys != nil && phys != NULL && phys:IsValid() ) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
					end
				elseif type == 2 then --Door
					ent.Hitsleft = ent.Hitsleft - 10
				end
		
				if ent:IsPlayer() then
					local moveAdd=Vector(0,0,350)
					if not ent:IsOnGround() then
						moveAdd=Vector(0,0,350)
					end
					ent:SetVelocity(moveAdd+((ent:GetPos()-self:GetPos()):GetNormal()*450))
				end
		
			end
		
		end
		
	end)
	
	timer.Simple( 2, function()
		if ( IsValid(self) and self:Health() > 0 ) then
			self.IsAttacking = false
			if !self.Downed then
				self:SetPlaybackRate(2)
			end
		end
	end)
end

function ENT:GrenadeThrow()

	if self.ThrowingGrenade then
		
		if self.Enemy then
		
			self:ThrowNade( self.Enemy, 3 )
			self:RestartGesture( table.Random( self.GrenadeThrowAnims ) )
			coroutine.wait( 0.5 )
			self.ThrowingGrenade = false
		
		else
			
			self.ThrowingGrenade = false
			
		end
		
	end

end

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() and ( IsValid( self.Enemy ) and self.Enemy:Health() > 0 ) then
			
		if !self.Reloading and !self.ReloadAnimation and !self.IsAttacking then
			
			self:PoseParameters()
			
			if ( ( self:GetRangeSquaredTo( self.Enemy ) < self.ShootRange*self.ShootRange and self:GetRangeSquaredTo( self.Enemy ) > (self.MeleeRange + 1)*(self.MeleeRange + 1) ) and self:IsLineOfSightClear( self.Enemy )  and !self:CheckDoor() ) then

				if ( self.NextAttackTimer or 0 ) < CurTime() then
					self:ShootWeapon()	
					self.NextAttackTimer = CurTime() + self.ShootDelay
				end
					
			end
					
		end	
					
		if !self.ReloadAnimation and !self.Reloading and !self.IsAttacking then
				
			if ( self.Enemy and self:IsLineOfSightClear( self.Enemy ) ) then
				
				if self:GetRangeSquaredTo( self.Enemy ) < self.MeleeRange*self.MeleeRange then

					if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
						self:Melee( self.Enemy )
						self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
					end

				elseif ( self:GetRangeSquaredTo( self.Enemy ) < self.GrenadeRange*self.GrenadeRange and self:GetRangeSquaredTo( self.Enemy ) > self.BackupRange*self.BackupRange ) then
					
					if ( self.NextGrenadeTimer or 0 ) < CurTime() then
						self.ThrowingGrenade = true
						self.NextGrenadeTimer = CurTime() + ( self.GrenadeDelay + math.random(1,5) )
					end
					
				end
				
			end		
					
		end
					
	end
	
end

local function GetTrajectoryVelocity(startingPosition, targetPosition, lob, gravity)

	local physicsTimestep = 1/66
	local timestepsPerSecond = 66
 
	local n = lob * timestepsPerSecond;
 
	local a = physicsTimestep * physicsTimestep * gravity;
	local p = targetPosition;
	local s = startingPosition;
 
	local velocity = (s + (((n * n + n) * a) / 2) - p) * -1 / n

	//This will give us velocity per timestep. The physics engine expects velocity in terms of meters per second
	velocity = velocity / physicsTimestep;
	return velocity;
end

function ENT:ThrowNade( ent, velocity )
	
	local nadetype = math.random(1,3)
	local nade
	local nademodel
			
	if nadetype == 1 then
		--Molotov
		nade = "ent_nb_molotov"
		nademodel = "models/weapons/tfa_csgo/w_molotov.mdl"
	elseif nadetype == 2 then
		--Frag Grenade
		nade = "ent_nb_kb_grenade"
		nademodel = "models/weapons/w_eq_fraggrenade_thrown.mdl"
	elseif nadetype == 3 then
		--Shrapnel Grenade
		nade = "ent_nb_shrapnel_grenade"
		nademodel = "models/weapons/w_eq_fraggrenade_thrown.mdl"
	end
			
	timer.Simple( 0.85, function()
		if ( IsValid( self ) and self:Health() > 0 ) then
			
			if !ent then return end
			if ( self.Reloading or self.ReloadAnimation or self.Downed or self.GettingUp ) then return end
			
			local nadeentity = ents.Create( nade )

			if nadeentity and nadeentity:IsValid() then
			
				nadeentity:SetPos( self:GetPos() + Vector(0,0,55) - ( self:GetRight() * 5 ) )
				nadeentity:SetModel( nademodel )
				nadeentity:Spawn()
				nadeentity:SetOwner( self )
							
				local phys = nadeentity:GetPhysicsObject()
				if phys:IsValid() then
				
					local v
					if ( !IsValid( ent ) or ent:Health() < 0 ) then
						v = GetTrajectoryVelocity( self:GetPos(), ( self:GetPos() + ( self:GetForward() * 250 ) ), 1, Vector(0,0,-25) )
					else
						v = GetTrajectoryVelocity( self:GetPos(), ent:GetPos(), 1, Vector(0,0,25) )
					end
					
					phys:SetVelocityInstantaneous( v * velocity or 3 )
					
				end
						
			end
				
		end
	end)
		
end

function ENT:ArmorVisual( pos )

	local effectdata = EffectData()
		effectdata:SetStart( pos ) 
		effectdata:SetOrigin( pos )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )
		
	self:EmitSound("hits/armor_hit.wav")
		
end

function ENT:ArmorEffect( dmginfo, hitgroup )

	if hitgroup == HITGROUP_HEAD then
	
		if !self.HeadArmorBroken then 
			self.HeadArmor = self.HeadArmor - dmginfo:GetDamage()
			self:ArmorVisual( dmginfo:GetDamagePosition() )
		end
		
	end
		
	if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
		
		local attacker = dmginfo:GetAttacker()
		
		if attacker:IsValid() then
				if attacker:IsPlayer() then
				
					local attackerforward = attacker:GetForward()
					local forward = self:GetForward() 
					
					if attackerforward:Distance( forward ) < 1 then
						if !self.BackArmorBroken then 
							self:ArmorVisual( dmginfo:GetDamagePosition() )
							self.BackArmor = self.BackArmor - dmginfo:GetDamage()
						end
					else
						if !self.FrontArmorBroken then 
							self:ArmorVisual( dmginfo:GetDamagePosition() )
							self.FrontArmor = self.FrontArmor - dmginfo:GetDamage()
						end
					end
				
			end
		end
		
	end
	
end

function ENT:SpawnArmor( dmginfo, type )
	
	local ent = ents.Create( "ent_nb_fake_armor" )
	
	if ent:IsValid() and self:IsValid() then	
	
		local model
		local pos 
		
		if type == "head" then
			model = "models/arachnit/csgoheavyphoenix/items/mask.mdl"
			pos = Vector(0,0,10)
		elseif type == "front" then
			model = "models/arachnit/csgoheavyphoenix/items/frontcover.mdl"
			pos = Vector(0,0,5)
		elseif type == "back" then
			model = "models/arachnit/csgoheavyphoenix/items/backcover.mdl"
			pos = Vector(0,0,5)
		end
	
		ent:SetModel( model )
		ent:SetPos( self:GetPos() + pos )
		ent:Spawn()
	
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			if type == "back" then
			
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(-(ang:Forward()), math.Rand(-10, 10))
				phys:SetVelocityInstantaneous(-(ang:Forward()) * math.Rand( 200, 200 ))
			
			else
			
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 200, 200 ))
				
			end		
				
		end
		
	end

end

function ENT:BreakArmor( dmginfo, type )

	if SERVER then

		if type == "head" then
			if self.HeadArmorBroken then return end 
			self.HeadArmorBroken = true
			self:SetBodygroup( 4, 1 )
			self:SpawnArmor( dmginfo, "head" )
		end
		
		if type == "front" then
			if self.FrontArmorBroken then return end 
			self.FrontArmorBroken = true
			self:SetBodygroup( 6, 1 )
			self:SpawnArmor( dmginfo, "front" )
		end
		
		if type == "back" then
			if self.BackArmorBroken then return end 
			self.BackArmorBroken = true
			self:SetBodygroup( 7, 1 )
			self:SpawnArmor( dmginfo, "back" )
		end
		
		self:EmitSound( "physics/metal/metal_box_break"..math.random(1,2)..".wav", 70, math.random( 90,95 ) )
	
	end
	
end

function ENT:CheckArmor( dmginfo )

	if self.HeadArmor < 0 then
		self:BreakArmor( dmginfo, "head" )
	end
	
	if self.FrontArmor < 0 then
		self:BreakArmor( dmginfo, "front" )
	end
	
	if self.BackArmor < 0 then
		self:BreakArmor( dmginfo, "back" ) 
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
				if self.HeadArmorBroken then
					self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
					dmginfo:ScaleDamage(4)
				else
					dmginfo:ScaleDamage(1)
				end
			end
			
			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				if self.BackArmorBroken and self.FrontArmorBroken then
					dmginfo:ScaleDamage(0.5)
					self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
				else
					dmginfo:ScaleDamage(0.8)
				end
			end
	end

	self:CheckArmor( dmginfo )
	self:ArmorEffect( dmginfo, hitgroup )
	
	self:Flinch( dmginfo, hitgroup )
	self:CheckEnemyPosition( dmginfo )

	self:PlayPainSound()
	
end

function ENT:OnKilled( dmginfo )

	self:DropWeapon()

	if dmginfo:GetAttacker().NEXTBOTZOMBIE or self:IsPlayerZombie( dmginfo:GetAttacker() ) then
		self:ZombieDeathAnimation( "nb_deathanim_boss", self:GetPos(), self.WalkAnim, self:GetModelScale(), nil, "", 0, "nb_freshdead_condottiere" )
	else
		self:DeathAnimation( "nb_deathanim_boss", self:GetPos(), self.WalkAnim, self:GetModelScale(), nil, "", 0 )
	end
	
end

function ENT:ZombieDeathAnimation( anim, pos, activity, scale, weapon, dropwep, bosstype, revive )
	local human = ents.Create( anim )
	if !self:IsValid() then return end

	if human:IsValid() then
		human:SetPos( pos )
		human:SetModel(self:GetModel())
		human:SetAngles(self:GetAngles())
		human:SetSkin(self:GetSkin())
		human:SetColor(self:GetColor())
		human:SetMaterial(self:GetMaterial())
		human:SetModelScale( scale, 0 )
		
		human:StartActivity( activity )

		human:SetBodygroup( 1, self:GetBodygroup(1) )
		human:SetBodygroup( 2, self:GetBodygroup(2) )
		human:SetBodygroup( 3, self:GetBodygroup(3) )
		human:SetBodygroup( 4, self:GetBodygroup(4) )
		human:SetBodygroup( 5, self:GetBodygroup(5) )
		human:SetBodygroup( 6, self:GetBodygroup(6) )
		human:SetBodygroup( 7, self:GetBodygroup(7) )
		human:SetBodygroup( 8, self:GetBodygroup(8) )
		human:SetBodygroup( 9, self:GetBodygroup(9) )
		
		if self.Weapon and ( weapon != nil ) then
		
			human:EquipWeapon( weapon )
			human.DroppedWeapon = dropwep
		
		end
		
		if bosstype == 1 then --Corpse boss
			human.EquipWeapons = true
		end
		
		if revive != nil then
			human.SpawnNpc = revive
		end
		
		human:Spawn()
		
		SafeRemoveEntity( self )
	end
end