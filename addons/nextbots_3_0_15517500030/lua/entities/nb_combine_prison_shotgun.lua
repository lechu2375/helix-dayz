AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_combine_prison_shotgun", "Prison Shotgunner")
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
list.Set( "sean_nextbots", "nb_combine_prison_shotgun", 	
{	Name = "Prison Shotgunner", 
	Class = "nb_combine_prison_shotgun",
	Category = "Combine"	
})

ENT.Base = "nb_combine_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 9

ENT.HealthAmount = 325

ENT.Speed = 185
ENT.PatrolSpeed = 55
ENT.SprintingSpeed = 255
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 0

ENT.AccelerationAmount = 800
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

ENT.MeleeDamage = 50
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 30
ENT.WeaponSpread = 0.1
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_shotgun"

ENT.Weapons = {"wep_nb_shotgun"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/player/combine_soldier_prisonguard.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_AR2
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnims = {"range_melee_shove_2hand"}

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
	
	if wep == "wep_nb_shotgun" then
	
		self.RunningReloadAnim = "reload_shotgun"
		self.StandingReloadAnim = "reload_smg1_shotgun"
		self.CrouchingReloadAnim = "reload_shotgun"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
		
		self.WeaponSpread = 1.1
		self.ShootRange = 600
		self.StopRange = 400
		self.BackupRange = 250
		self.BulletForce = 15
		self.ShootDelay = 0.9
		self.BulletNum = 5
		self.BulletDamage = 10
		self.ClipAmount = 8
	
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
	
		self:SetSkin( 1 )
	
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
		self.WeaponClass = "wep_nb_shotgun"
		self:SetWeaponType( "wep_nb_shotgun" )
	end
	
	self:EquipWeapon()
	
	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	self.Downed = false
	self.DownedOnGround = false
	self.GettingUp = false

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
					
					--if !self.Reloading then
					
						--if self.Reloading then
							--self:ReloadWeapon( "running" )
						--end
					
					if self.Reloading then
						self:ReloadBehaviour()
					end
						
					if !self.GoingToSpot then
					
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

					end		
				
				else
					
					self.Strafing = false
					self.Patrolling = true

					if !self.GoingToRevive then
				
						self:PlayIdleSound()
					
						self:MovementFunction()

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