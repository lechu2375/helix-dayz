if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

ENT.Base = "nb_vehicle_hit_base"
ENT.Spawnable = false
ENT.AdminSpawnable = false

--Stats--	

ENT.ChaseDistance = 2000

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 50

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

ENT.ShootRange = 80
ENT.MeleeRange = 40
ENT.StopRange = 20

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

ENT.HitSound = "Flesh.ImpactHard"

--Model--
ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

function ENT:Initialize()

	if SERVER then
		--Make sure the model is SET before calling CollisionSetup() or else, nextbots will get stuck on eachother
		self:CustomInitialize()
	
		self.loco:SetDeathDropHeight( self.MaxDropHeight )	
		self.loco:SetAcceleration( self.AccelerationAmount )		
		self.loco:SetDeceleration( self.DecelerationAmount )
		self.loco:SetStepHeight( self.StepHeight )
		self.loco:SetJumpHeight( self.JumpHeight )

		self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
		
		self.NEXTBOTFACTION = 'NEXTBOTZOMBIE'
		self.NEXTBOTZOMBIE = true
		self.NEXTBOT = true
		
		--Status
		self.NextCheckTimer = CurTime() + 4
		self.NextRotateTime = CurTime() + 5
		self.StuckAttempts = 0
		self.TotalTimesStuck = 0
		self.IsJumping = false
		self.IsAttacking = false
		self.FacingTowards = nil
		self.HitByVehicle = false
		self.IsAlerted = false
		self.AlertedEntity = nil
		
		self:MovementFunction()
	end
	
	if CLIENT then
		self.NEXTBOTFACTION = 'NEXTBOTZOMBIE'
		self.NEXTBOTZOMBIE = true
		self.NEXTBOT = true
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel("")
		self:SetHealth( self.HealthAmount )
	end
	
end

function ENT:CollisionSetup( collisionside, collisionheight, collisiongroup )
	self:SetCollisionGroup( collisiongroup )
	self:SetCollisionBounds( Vector(-collisionside,-collisionside,0), Vector(collisionside,collisionside,collisionheight) )
	--self:PhysicsInitShadow(true, false)
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
				self:SetEnemy( ent )
				self:BehaveStart()
				self:Melee( ent )
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
		end
	end
	
	--if ent != self.Enemy then
		--if ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) or ( ent.NEXTBOT and !ent.NEXTBOTZOMBIE ) then
			--if ( self.NextMeleeTimer or 0 ) < CurTime() then
				--self:Melee( ent )
				--self:SetEnemy( ent )
				--self:BehaveStart()
				--self.NextMeleeTimer = CurTime() + self.MeleeDelay
			--end
		--end
	--end
	
	self:CustomOnContact2( ent )
	
end

function ENT:CustomOnContact2( ent )

	self:AttackProp( ent )

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

function ENT:MovementFunction()
	self:StartActivity( self.WalkAnim )
	self.loco:SetDesiredSpeed( self.Speed )
end

function ENT:OnSpawn()

end

function ENT:RunBehaviour()

	self:OnSpawn()

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
		if(self.nosleep or !self.sleeping) then
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
		end
		self:PlayIdleSound()
			
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

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() and self:CheckEnemyStatus( self.Enemy ) then
		
		if ( self:GetRangeSquaredTo( self.Enemy ) < (self.ShootRange*self.ShootRange) and self:IsLineOfSightClear( self.Enemy ) ) then

			if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
				self:Melee( self.Enemy )
				self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
			end

		end
			
		if self.IsAttacking then
			if self.FacingTowards:IsValid() and self.FacingTowards:Health() > 0 then
				self.loco:FaceTowards( self.FacingTowards:GetPos() )
			end
		end
			
	end
	
end

function ENT:Melee( ent, type, time )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self:RestartGesture( self.MeleeAnim )
	self:PlayAttackSound()
	
	timer.Simple( time or 0.9, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			if self.Flinching then return end
			
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
	
	if time then
		timer.Simple( time + 0.4, function()
			if ( IsValid(self) and self:Health() > 0) then
				self.IsAttacking = false
			end
		end)
	else
		timer.Simple( 1.3, function()
			if ( IsValid(self) and self:Health() > 0) then
				self.IsAttacking = false
			end
		end)
	end
	
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:SetEnemy( ent )
	
	self.Enemy = ent
	
	if self:IsPlayerZombie( ent ) then
		self.Enemy = nil
	else
		if ent and ent:IsValid() and ent:Health() > 0 then
			self:PlayAlertSound()
			self:AlertNearby()
		end
	end
	
end

function ENT:FindEnemy()

	if ( self.NextLookForTimer or 0 ) < CurTime() then

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
					if v:Health() < 0 then
						table.remove( enemies, k )
					end
					if ai_ignoreplayers:GetInt() == 0 then --Remove players from pool of enemies if ignore players is true
						if v:IsPlayer() then --Remove players who are zombies from pool of enemies
							if self:IsPlayerZombie( v ) then
								table.remove( enemies, k )	
							else
								if !v:Alive() then --Remove dead players from pool of enemies
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

		self.NextLookForTimer = CurTime() + ( self.EnemyCheckTime or math.random(1,3) )
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
		elseif enemy:IsPlayer() and self:IsPlayerZombie( enemy ) then
			return self:FindEnemy()
		end
		
		if ( self.NextCheckTimer or 0 ) < CurTime() then --Every 5-8 seconds, find new and best target
			self:FindEnemy()
			if nb_targetmethod:GetInt() == 1 then
				self.LastEnemy = enemy
				timer.Simple(math.random(0.1,1.5),function()
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
			self.NextCheckTimer = CurTime() + math.random(5,8)
		end
		
		return true
		
	else
		if(self.NextRotateTime<CurTime()) then
			self:SetAngles(Angle(0,self:GetAngles().y+math.random(-90, 90),0))
			self.NextRotateTime = CurTime()+math.random(5, 10)
		end
		return self:FindEnemy()
	end
end

function ENT:BodyUpdate()

	--if !self.IsAttacking then

		if ( self:GetActivity() == self.WalkAnim ) then

			self:BodyMoveXY()

		elseif ( self:GetActivity() == self.SprintingAnim ) then
		
			self:BodyMoveXY()
		
		end

	--else
	
		--if self.loco:GetVelocity():Length() < 0.5 then
			--self:SetPoseParameter("move_x", 0.2 )
		--else
			--self:SetPoseParameter("move_x", 0.8 )
		--end
	
	--end
	
	--self:FrameAdvance()

end

function ENT:AttackDoor( ent )

	if ( self.NextMeleeTimer or 0 ) < CurTime() then
		self:Melee( ent, 2 )
		self.NextMeleeTimer = CurTime() + self.MeleeDelay
	end
	
end

function ENT:ContactDoor( ent )

	if ent.Hitsleft == nil then
		ent.Hitsleft = 10
	end

	if ent != NULL and ent.Hitsleft > 0 then

		self:AttackDoor( ent )

	end

	if ent != NULL and ent.Hitsleft < 1 then

		local door = ents.Create("prop_physics")
			if door then
				door:SetModel(ent:GetModel())
				door:SetPos(ent:GetPos())
				door:SetAngles(ent:GetAngles())
				door:Spawn()
				door.FalseProp = true
				door:EmitSound("Wood_Plank.Break")

		local phys = door:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
			end

				door:SetSkin(ent:GetSkin())
				door:SetColor(ent:GetColor())
				door:SetMaterial(ent:GetMaterial())

		SafeRemoveEntity( ent )

	end

	end
					
end

function ENT:CheckPathAge( path )

	if path then
	
		local length = path:GetLength()
		local age = 2

		if length < 1000 then
			age = 0.8
		elseif length < 500 then
			age = 0.5
		elseif length < 200 then
			age = 0.2
		end
		
		return age
	
	else
	
		return 1
	
	end

end

function ENT:ChaseEnemy( options )

	local enemy = self:GetEnemy()
	local pos = enemy:GetPos()
	local enemynav = navmesh.GetNearestNavArea( pos,false,100,false,false)
	local options = options or {}
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 30 )
	path:SetGoalTolerance( options.tolerance or 20 )
	if(enemynav) then
		path:Compute( self, pos )
	end

	if (!path:IsValid() ) then return "failed" end
	
	if !enemy then return "failed" end
	
	if !enemy:IsValid() then return "failed" end
	
	if enemy:Health() < 0 then return "failed" end
	
	if self:IsPlayerZombie( enemy ) then return "failed" end
	
	while ( path:IsValid() and self:HaveEnemy() and ( enemy:IsValid() and enemy:Health() > 0) ) do

		if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange ) and !self.IsJumping then 
			return "ok"
		end
	
		if nb_doorinteraction:GetInt() == 1 then
			if !self:CheckDoor() then
			
			elseif ( self:CheckDoor():IsValid() and self:GetRangeSquaredTo( self:CheckDoor() ) < self.StopRange*self.StopRange and self:Visible( self:CheckDoor() ) ) then
				self:ContactDoor( self:CheckDoor() )
				return "ok"
			end
		end
	
		if ( !self.Reloading and !self.loco:IsStuck() and ( enemy and enemy:IsValid() and enemy:Health() > 0) ) then
			if ( path:GetAge() > options.maxage ) then	
			--if ( path:GetAge() > ( self:CheckPathAge( path ) ) ) then
				local enemynav = navmesh.GetNearestNavArea( enemy:GetPos(),false,100,false,false)
				//print(enemynav)
				if(!enemynav) then
					self.Enemy = nil
					//print("Enemy has no navmesh")
				else
					path:Compute( self, enemy:GetPos() )
					
				end
				
				
			end
			
		end
		
		path:Update( self )	
		
		if ( options.draw ) then
			path:Draw()
		end
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck( 0 )
			return "stuck"
		end
		
		coroutine.yield()
	end
	
	return "ok"
end

function ENT:OnLandOnGround()

	self.IsJumping = false
	
	self:MovementFunction()
	
end

function ENT:OnNavAreaChanged( old, new )

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
				dmginfo:ScaleDamage( self.HeadShotMultipler or 8 )
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end
			
	end
	
	self:Flinch( dmginfo, hitgroup )
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
end

function ENT:PlayFlinchSequence( string, rate, cycle, speed, time )
	self.Flinching = true

	self:ResetSequence( string )
	self:SetCycle( cycle )
	self:SetPlaybackRate( rate )
	self.loco:SetDesiredSpeed( speed )
	
	timer.Simple(time, function() 
		if ( self:IsValid() and self:Health() > 0 ) then
			self:MovementFunction()
			self:BehaveStart()
			self.Flinching = false
		end
	end)
end

function ENT:HardFlinch( dmginfo, hitgroup )
	
	if ( self.NextFlinchTimer or 0 ) < CurTime() then
	
		if hitgroup == HITGROUP_HEAD then
			self:PlayFlinchSequence( self.HeadFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_LEFTLEG then
			self:PlayFlinchSequence( self.LLegFlinch, 1, 0, 0, 2.5 )
		elseif hitgroup == HITGROUP_RIGHTLEG then
			self:PlayFlinchSequence( self.RLegFlinch, 1, 0, 0, 1.6 )
		elseif hitgroup == HITGROUP_LEFTARM then
			self:PlayFlinchSequence( self.LArmFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_RIGHTARM then
			self:PlayFlinchSequence( self.RArmFlinch, 1, 0, 0, 0.7 )
		elseif hitgroup == HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH then
			if math.random(1,3) == 1 then
				self:PlayFlinchSequence( self.ChestFlinch1, 1, 0, 0, 0.5 )
			elseif math.random(1,3) == 2 then
				self:PlayFlinchSequence( self.ChestFlinch2, 1, 0, 0, 0.6 )
			elseif math.random(1,3) == 3 then
				self:PlayFlinchSequence( self.ChestFlinch3, 1, 0, 0, 0.6 )
			end
		end
		
		self.NextFlinchTimer = CurTime() + 2	
	end	
	
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
		
		self.loco:SetDesiredSpeed( self.Speed / 2 )
		
		timer.Simple( 0.14, function()
			if ( IsValid(self) and self:Health() > 0) then
				self.loco:SetDesiredSpeed(self.Speed)
			end
		end)
		
		self.NextFlinchTimer = CurTime() + 0.15
	end
	
end

function ENT:OnKilled( dmginfo )

	if self.HitByVehicle then 
	return end

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
	
	self:PlayDeathSound()

	hook.Run("OnNextbotDeath",self,dmginfo)
	hook.Run( "OnNPCKilled",self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
end

function ENT:PlayAttackSound()
	if self:Health() < 0 then return end

	if ( self.NextAttackSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.AttackSounds )
		self:EmitSound( Sound( randomsound ), 100, self.AttackSoundPitch or 100, 1, CHAN_VOICE )
		
		self.NextAttackSoundTimer = CurTime() + self.MeleeDelay
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

function ENT:PlayAlertSound()
	if self:Health() < 0 then return end

	if ( self.NextAlertSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.AlertSounds )
		self:EmitSound( Sound( randomsound ), 100, self.AlertSoundPitch or 100, 1, CHAN_VOICE )
	
		self.NextAlertSoundTimer = CurTime() + math.random(16,36)
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
	
	if ( self.NextIdleSoundTimer or 0 ) < CurTime() then
	
		local randomsound = table.Random( self.IdleSounds )
		self:EmitSound( Sound( randomsound ), 100, self.IdleSoundPitch or 100, 1, CHAN_VOICE )
	
		self.NextIdleSoundTimer = CurTime() + math.random(16,36)
	end
end