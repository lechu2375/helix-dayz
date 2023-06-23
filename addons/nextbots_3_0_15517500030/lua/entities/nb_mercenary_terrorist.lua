AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_mercenary_terrorist", "Terrorist")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_mercenary_terrorist", 	
{	Name = "Terrorist", 
	Class = "nb_mercenary_terrorist",
	Category = "Mercenaries"	
})

ENT.Base = "nb_mercenary_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 150

ENT.Speed = 180
ENT.PatrolSpeed = 70
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 900
ENT.DecelerationAmount = 900

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 0.2
ENT.MeleeDelay = 1

ENT.ShootRange = 500
ENT.MeleeRange = 60
ENT.StopRange = 400
ENT.BackupRange = 200

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 15
ENT.WeaponSpread = 0.6
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 30
ENT.WeaponClass = "wep_nb_ak47"

ENT.Weapons = {"wep_nb_ak47"}

ENT.WeaponModel = "models/weapons/w_rif_ak47.mdl"
ENT.WeaponSound = "sean_wepnb_sound_ak47"

--Model--
ENT.Models = {"models/gmodz/npc/bandit_exp.mdl","models/gmodz/npc/bandit_exp.mdl"}

ENT.WalkAnim = ACT_RUN
ENT.PatrolWalkAnim = ACT_WALK
ENT.SprintingAnim = ACT_RUN
ENT.FlinchWalkAnim = ACT_WALK
ENT.CrouchAnim = ACT_RUN_CROUCH 
ENT.JumpAnim = ACT_HOP

ENT.ShootAnim = "Run_Shoot_AK"
ENT.MeleeAnim = "Run_Shoot_GREN2"

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

ENT.PainSounds = {"nextbots/mercenary/pain1.wav",
"nextbots/mercenary/pain2.wav",
"nextbots/mercenary/pain3.wav",
"nextbots/mercenary/pain4.wav",
"nextbots/mercenary/pain5.wav",
"nextbots/mercenary/pain6.wav"}

ENT.AlertSounds = {""}

ENT.DeathSounds = {"nextbots/mercenary/death1.wav",
"nextbots/mercenary/death2.wav",
"nextbots/mercenary/death3.wav",
"nextbots/mercenary/death4.wav",
"nextbots/mercenary/death5.wav",
"nextbots/mercenary/death6.wav",
"nextbots/mercenary/death7.wav"}

ENT.IdleSounds = {"nextbots/mercenary/idle1.wav",
"nextbots/mercenary/idle2.wav",
"nextbots/mercenary/idle3.wav",
"nextbots/mercenary/idle4.wav",
"nextbots/mercenary/idle5.wav",
"nextbots/mercenary/idle6.wav"}

ENT.ReloadingSounds = {"nextbots/mercenary/reload1.wav", --Standing reloading sounds 
"nextbots/mercenary/reload2.wav",
"nextbots/mercenary/reload3.wav",
"nextbots/mercenary/reload4.wav",
"nextbots/mercenary/reload5.wav",
"nextbots/mercenary/reload6.wav",
"nextbots/mercenary/reload7.wav"} 
ENT.ReloadingSounds2 = {"nextbots/mercenary/scared1.wav", --If running away to reload
"nextbots/mercenary/scared2.wav",
"nextbots/mercenary/scared3.wav",
"nextbots/mercenary/scared4.wav"}

function ENT:SetWeaponType( wep )
	
	self.RunningReloadAnim = "Run_Reload_AK"
	self.StandingReloadAnim = "Run_Reload_AK"
	self.CrouchingReloadAnim = "Run_Reload_AK"
	self.WalkAnim = ACT_RUN
	self.CrouchAnim = ACT_RUN_CROUCH
	self.FlinchWalkAnim = ACT_WALK
	self.ShootAnim = "Run_Shoot_AK"
	
end

function ENT:EquipWeapon()
	local att = "primary"
	local shootpos = self:GetAttachment(self:LookupAttachment(att))
		
	local wep = ents.Create( self.WeaponClass )
	wep:SetOwner(self)
	wep:SetPos(shootpos.Pos)
	--wep:SetAngles(ang)
	wep:Spawn()
	wep:SetSolid(SOLID_NONE)
	wep:SetParent(self)
	wep:SetNotSolid(true)
	wep:SetTrigger(false)
	wep:Fire("setparentattachment", "primary")
	wep:AddEffects(EF_BONEMERGE)
	wep:SetAngles(self:GetForward():Angle())
	wep:SetOwner( self )
	self.Weapon = wep
	self.BulletsUsed = 0
	self.ClipAmount = self.ClipAmount
	self.Reloading = false
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

	--PrintTable( self:GetAttachments() )
	
	local weapon = table.Random( self.Weapons )
		if weapon == "" or nil then
		self.WeaponClass = self.WeaponClass
		self:SetWeaponType( self.WeaponClass )
	else
		self.WeaponClass = weapon
		self:SetWeaponType( weapon )
	end
	
	self:EquipWeapon()
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
		else
			self:TakeDamage( dmg, ent )
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

function ENT:BodyUpdate()

	if !self.ReloadAnimation then

		if ( self:GetActivity() == self.WalkAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.Speed )
			
		elseif ( self:GetActivity() == self.SprintingAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.SprintingSpeed )
			
		elseif ( self:GetActivity() == self.PatrolWalkAnim ) then
			
			self:BodyMoveXY()
			self.loco:SetDesiredSpeed( self.PatrolSpeed )	
			
		end

	else
	
		self:SetPoseParameter( "move_x", 0 )
		self:SetPoseParameter( "move_y", 0 )
		self.loco:SetDesiredSpeed( 0 )
	
	end
	
	self:FrameAdvance()

end

function ENT:MovementFunction( type )
	if type == "reloading" then
		self:StartActivity( self.SprintingAnim )
		self.loco:SetDesiredSpeed( self.SprintingSpeed )
	elseif type =="standreload" then
		self:StartActivity( self.WalkAnim )
		self.loco:SetDesiredSpeed( self.Speed )
	elseif type == "crouching" then
		self:StartActivity( self.CrouchAnim )
		self.loco:SetDesiredSpeed( self.CrouchSpeed )
	elseif type == nil then
		if self:HaveEnemy() then
			self:StartMovementAnim( self.WalkAnim, self.Speed )
		else
			self:StartMovementAnim( self.PatrolWalkAnim, self.PatrolSpeed )
		end
	end
end

function ENT:RunBehaviour()

	while ( true ) do

		if self:HaveEnemy() then
						
			local enemy = self:GetEnemy()	
						
			self.Patrolling = false
			
			if !self.Reloading then
					
				pos = enemy:GetPos()	
							
				if ( pos ) and enemy:IsValid() and enemy:Health() > 0 then
						
					self:MovementFunction()	

					if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange and self:GetRangeSquaredTo( enemy ) > self.BackupRange*self.BackupRange and !self.Crouching ) then
		
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
						
				if !self.LookingForReload and !self.ReloadAnimation then
					if ( ( self:Health() < ( self.HealthAmount / 2 ) or self:GetRangeSquaredTo( self:GetEnemy() ) < 100*100 ) and !self.FollowingPlayer and self.CanRunReload ) then
						self:PlayReloadingSound( 2 )
						self:FindReloadSpot()
					else
						self:PlayReloadingSound()
						if math.random(1,2) == 1 then
							self:ReloadWeapon( "running" )
						elseif math.random(1,2) == 2 then
							self:ReloadWeapon( "standing" )
						end
					end
				end
						
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
		
		coroutine.yield()
		
	end

end

function ENT:ReloadWeapon( type )

	if !self.Crouching or self.Downed then

		if type == "running" or type == "standing" then
			if !self.ReloadAnimation then
		
				if !self.Downed then
					self:MovementFunction( "standreload" )
				end
		
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

function ENT:Melee( ent, type )
	self:PlayAttackSound()
	self:PlayGestureSequence( self.MeleeAnim )
	self.loco:FaceTowards( ent:GetPos() )
	
	timer.Simple( 0.2, function()
		if ( IsValid(self) and self:Health() > 0) and IsValid(ent) then
		
			if self:GetRangeSquaredTo( ent ) > self.MeleeRange*self.MeleeRange then return end
		
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
			
			--ent:EmitSound( data.hitsound, 50, math.random( 80, 160 ) )
		
		end
	end)
	
end

function ENT:PoseParameters()
	self.loco:FaceTowards( self.Enemy:GetPos() )
				
	local muzzpos
	muzzpos = self:GetPos()+Vector(0,0,68)
				
	local target = self.Enemy
			
	local targetpos = target:GetPos() + Vector(0,0,60) --or target:GetPos() --  target:HeadTarget(self:GetPos())

	local TargetOffset = WorldToLocal(targetpos, Angle(), muzzpos, self:GetAngles())
	local Distance = targetpos:Distance(muzzpos)
			
	local newYaw=-math.deg(math.atan(TargetOffset.Y/TargetOffset.X )) --Determine what angle Tangent of X and Y combined will yield, in degrees form.
	local newPitch=math.deg(math.asin(TargetOffset.Z/Distance))	 --Much more simple with a single dimesion.

	--When the target is behind us, aim pos is going to behave as if is has eyes on the back of it's head:
	if TargetOffset.X/Distance < 0 then
		newYaw=newYaw+180
	end
			
	local Pitch=math.NormalizeAngle(newPitch)
	local Yaw=math.NormalizeAngle(newYaw)
			
	if Pitch > 90 then
		Pitch=90
	elseif Pitch < -45 then
		Pitch = -45
	end
			
	if Yaw > 42 then
		Yaw = 41
		self.loco:FaceTowards( targetpos )
	elseif Yaw < -42 then
		Yaw = -41
		self.loco:FaceTowards( targetpos )
	end
	
	self:SetPoseParameter( "body_pitch", -Pitch )
	self:SetPoseParameter( "body_yaw", -Yaw )
end

function ENT:OnKilled( dmginfo )

	if dmginfo:GetAttacker().NEXTBOTZOMBIE or self:IsPlayerZombie( dmginfo:GetAttacker() ) then
	
		if self:GetModel() == "models/player/t_guerilla.mdl" then
			self:SetModel( "models/player/guerilla.mdl" )
		elseif self:GetModel() == "models/player/t_leet.mdl" then
			self:SetModel( "models/player/leet.mdl" )
		elseif self:GetModel() == "models/player/t_phoenix.mdl" then
			self:SetModel( "models/player/phoenix.mdl" )
		elseif self:GetModel() == "models//player/t_arctic.mdl" then
			self:SetModel( "models/player/arctic.mdl" )
		end
	
		self:RiseAsZombie( self, "nb_rise_base", "nb_freshdead", "", 100, true )
	
		if self.Weapon then
			SafeRemoveEntity( self.Weapon)
		end
	
	else

		self:BecomeRagdoll( dmginfo )
		self:DropWeapon()
	
	end
	
	self:PlayDeathSound()
	
end