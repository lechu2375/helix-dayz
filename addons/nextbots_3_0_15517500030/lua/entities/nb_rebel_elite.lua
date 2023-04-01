AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_rebel_elite", "Elite Rebel")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_rebel_elite", 	
{	Name = "Elite Rebel", 
	Class = "nb_rebel_elite",
	Category = "Rebels"	
})

ENT.Base = "nb_rebel_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 150

ENT.Speed = 180
ENT.PatrolSpeed = 60
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 600
ENT.DecelerationAmount = 600

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
ENT.BulletForce = 30
ENT.WeaponSpread = 0.6
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_shotgun"

ENT.Weapons = {"wep_nb_shotgun", 
"wep_nb_smg",
"wep_nb_revolver",
"wep_nb_pistol",
"wep_nb_galil",
"wep_nb_ump"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

ENT.PistolClass = "wep_nb_pistol"
ENT.PistolSound = "Weapon_Pistol.Single"

--Model--
ENT.Models = {"models/bloocobalt/rebel_elite.mdl",
"models/bloocobalt/rebel_elite2.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_SHOTGUN  
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40 
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnim = "range_melee_shove_2hand"

--Sounds--
ENT.AttackSounds = {"", --Meleeing Sounds
}
ENT.AttackSounds2 = {"" --Shooting Sounds
}

ENT.PainSounds = {"vo/npc/male01/pain01.wav",
"vo/npc/male01/pain02.wav",
"vo/npc/male01/pain03.wav",
"vo/npc/male01/pain04.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain06.wav",
"vo/npc/male01/pain07.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pain09.wav",
"vo/npc/male01/ow01.wav",
"vo/npc/male01/ow02.wav"}

ENT.AlertSounds = {"vo/npc/male01/watchout.wav", --Normal alert sounds
"vo/npc/male01/heretheycome01.wav",
"vo/npc/male01/headsup01.wav",
"vo/npc/male01/headsup02.wav",
"vo/npc/male01/help01.wav",
"vo/npc/male01/uhoh.wav",
"vo/npc/male01/startle01.wav",
"vo/npc/male01/startle02.wav",
"vo/npc/male01/incoming02.wav"}
ENT.AlertSounds2 = {"vo/npc/male01/watchout.wav", --If spotted zombie
"vo/npc/male01/zombies01.wav",
"vo/npc/male01/zombies02.wav",
"vo/npc/male01/incoming02.wav"}

ENT.DeathSounds = {"vo/npc/male01/no01.wav",
"vo/npc/male01/no02.wav",
"vo/npc/male01/ohno.wav",
"vo/npc/male01/pain02.wav",
"vo/npc/male01/pain03.wav",
"vo/npc/male01/pain04.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain06.wav",
"vo/npc/male01/pain07.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pain09.wav",
"vo/npc/male01/ow01.wav",
"vo/npc/male01/ow02.wav"}

ENT.IdleSounds = {""}

ENT.FollowingSounds = {"vo/npc/male01/leadon01.wav",  --Following sounds
"vo/npc/male01/leadon02.wav",
"vo/npc/male01/leadtheway01.wav",
"vo/npc/male01/leadtheway02.wav",
"vo/npc/male01/readywhenyouare01.wav",
"vo/npc/male01/readywhenyouare02.wav"}
ENT.FollowingSounds2 = {"vo/npc/male01/imstickinghere01.wav", --Unfollow sounds
"vo/npc/male01/littlecorner01.wav",
"vo/npc/male01/illstayhere01.wav"}

ENT.ReloadingSounds = {"vo/npc/male01/coverwhilereload01.wav", --Standing reloading sounds 
"vo/npc/male01/coverwhilereload02.wav",}  
ENT.ReloadingSounds2 = {"vo/npc/male01/runforyourlife01.wav", --If running away to reload
"vo/npc/male01/runforyourlife02.wav",
"vo/npc/male01/runforyourlife03.wav",
"vo/npc/male01/takecover02.wav",
"vo/npc/male01/strider_run.wav",
"vo/npc/male01/gethellout.wav"}

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_smg" or wep == "wep_nb_ump" then
	
		self.RunningReloadAnim = "reload_smg1"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1"
		
		if wep == "wep_nb_smg" then
			self.WeaponSound = "Weapon_Smg1.Single"
		else
			self.WeaponSound = "sean_wepnb_sound_ump"
		end
		
		self.WalkAnim = ACT_HL2MP_RUN_SMG1
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1
		self.FlinchWalkAnim = ACT_HL2MP_WALK_SMG1
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ShootDelay = 0.1
		self.BulletForce = 5
		self.ClipAmount = 45
		self.ShootRange = 700
		self.StopRange = 500
		self.BackupRange = 200
	
	elseif wep == "wep_nb_galil" then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1"
		self.WeaponSound = "sean_wepnb_sound_galil"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.FlinchWalkAnim = ACT_HL2MP_WALK_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.ShootDelay = 0.15
		self.BulletDamage = 12
		self.BulletForce = 7
		self.ClipAmount = 30
		self.ShootRange = 750
		self.StopRange = 550
		self.BackupRange = 300
	
	elseif wep == "wep_nb_shotgun" then
	
		self.RunningReloadAnim = "reload_shotgun"
		self.StandingReloadAnim = "reload_shotgun_original"
		self.CrouchingReloadAnim = "reload_shotgun"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN
		self.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
		self.BulletNum = 5
		self.BulletDamage = 8
		self.ShootRange = 550
		self.StopRange = 350
		self.BackupRange = 200
		
	elseif wep == "wep_nb_revolver" then
		
		self.RunningReloadAnim = "reload_revolver"
		self.StandingReloadAnim = "reload_revolver_original"
		self.CrouchingReloadAnim = "reload_revolver"
		self.WeaponSound = "weapons/357/357_fire2.wav"
		self.WalkAnim = ACT_HL2MP_RUN_REVOLVER
		self.PatrolWalkAnim = ACT_HL2MP_WALK
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_REVOLVER
		self.FlinchWalkAnim = ACT_HL2MP_WALK_REVOLVER
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
		self.ShootRange = 600
		self.BulletForce = 5
		self.ShootDelay = 1
		self.BulletNum = 1
		self.BulletDamage = 30
		self.ClipAmount = 6
		self.BulletOffSet = 6
		self.ShootRange = 800
		self.StopRange = 550
		self.BackupRange = 300
		
	elseif wep == "wep_nb_pistol" then
	
		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WeaponSound = self.PistolSound
		self.WalkAnim = ACT_HL2MP_RUN_PISTOL
		self.PatrolWalkAnim = ACT_HL2MP_WALK
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_PISTOL
		self.FlinchWalkAnim = ACT_HL2MP_WALK_PISTOL
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		self.ShootRange = 600
		self.BulletForce = 5
		self.ShootDelay = 0.2
		self.BulletNum = 1
		self.BulletDamage = 12
		self.ClipAmount = 18
		self.ShootRange = 750
		self.StopRange = 550
		self.BackupRange = 300
		
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		
		util.PrecacheModel( table.ToString( self.Models ) )
		
		local model = table.Random( self.Models )
		
		self:SetModel( model )

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
		self.WeaponClass = self.PistolClass
		self:SetWeaponType( self.PistolClass )
	end
	
	self:EquipWeapon()
	
end

function ENT:BodyUpdate()

	--if !self.ReloadAnimation then

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

	--else
	
		--self:SetPoseParameter( "move_x", 0 )
		--self:SetPoseParameter( "move_y", 0 )
		--self.loco:SetDesiredSpeed( 0 )
	
	--end
	
	--self:FrameAdvance()

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
		if self.FollowingPlayer then
			self:StartMovementAnim( self.WalkAnim, self.Speed )
		else
			if self:HaveEnemy() then
				self:StartMovementAnim( self.WalkAnim, self.Speed )
			else
				self:StartMovementAnim( self.PatrolWalkAnim, self.PatrolSpeed )
			end
		end
	end
end

function ENT:RunBehaviour()

	while ( true ) do

		if self:HaveEnemy() then
						
			local enemy = self:GetEnemy()	
				
			local pos
				
			self.Patrolling = false
			
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
					
				end
					
			else
						
				self.Strafing = false
						
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

				if !self.Reloading and !self.ReloadAnimation and !self.GoingToRevive and !self.GoingToSpot then

					self.Strafing = false
					self.Patrolling = true
				
					if self.BulletsUsed != 0 and ( !self.Enemy ) then
							
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
		
		coroutine.yield()
		
	end

end