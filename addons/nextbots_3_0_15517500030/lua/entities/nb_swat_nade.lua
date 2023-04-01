AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_swat_nade", "SWAT Veteran")
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
list.Set( "sean_nextbots", "nb_swat_nade", 	
{	Name = "SWAT Veteran", 
	Class = "nb_swat_nade",
	Category = "SWATs"	
})

ENT.Base = "nb_swat_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 7

ENT.HealthAmount = 225

ENT.Speed = 215
ENT.PatrolSpeed = 75
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 900
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.GrenadeDelay = 7
ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.GrenadeRange = 700
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
ENT.WeaponClass = "wep_nb_m3gauge"

ENT.Weapons = {"wep_nb_m3gauge", 
"wep_nb_mp5",
"wep_nb_m4a1",
"wep_nb_famas",
"wep_nb_usps",
"wep_nb_usp",
"wep_nb_ump",
"wep_nb_m4a1s",
"wep_nb_aug"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/player/gasmask.mdl",
"models/player/riot.mdl",
"models/player/swat.mdl",
"models/player/urban.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_AR2
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnims = {"aoc_spearshield_slash_02_mod",
"aoc_swordshield_slash_01_mod",
"aoc_halberd_slash_01_mod"}

--Sounds--
ENT.AttackSounds = {"nextbots/swat/attack1.wav", --Melee Sounds
"nextbots/swat/attack2.wav",
"nextbots/swat/attack3.wav",
"nextbots/swat/attack4.wav",
"nextbots/swat/attack5.wav",
"nextbots/swat/attack6.wav",
"nextbots/swat/attack7.wav",
"nextbots/swat/attack8.wav",
"nextbots/swat/attack9.wav"}
ENT.AttackSounds2 = {"nextbots/swat/suppressing1.wav", --Shooting Sounds
"nextbots/swat/suppressing2.wav",
"nextbots/swat/suppressing3.wav",
"nextbots/swat/suppressing4.wav",
"nextbots/swat/suppressing5.wav",
"nextbots/swat/suppressing6.wav",
"nextbots/swat/suppressing7.wav",
"nextbots/swat/suppressing8.wav",
"nextbots/swat/suppressing9.wav",
"nextbots/swat/suppressing10.wav",
"nextbots/swat/suppressing11.wav",
"nextbots/swat/suppressing12.wav"}

ENT.PainSounds = {"nextbots/swat/pain1.wav",
"nextbots/swat/pain2.wav",
"nextbots/swat/pain3.wav",
"nextbots/swat/pain4.wav",
"nextbots/swat/pain5.wav",
"nextbots/swat/pain6.wav"}

ENT.AlertSounds = {"nextbots/swat/alert1.wav",
"nextbots/swat/alert2.wav",
"nextbots/swat/alert3.wav",
"nextbots/swat/alert4.wav",
"nextbots/swat/alert5.wav",
"nextbots/swat/alert6.wav"}

ENT.DeathSounds = {"nextbots/swat/death1.wav",
"nextbots/swat/death2.wav",
"nextbots/swat/death3.wav",
"nextbots/swat/death4.wav",
"nextbots/swat/death5.wav",
"nextbots/swat/death6.wav"}

ENT.IdleSounds = {"nextbots/swat/idle1.wav",
"nextbots/swat/idle2.wav",
"nextbots/swat/idle3.wav",
"nextbots/swat/idle4.wav",
"nextbots/swat/idle5.wav",
"nextbots/swat/idle6.wav",
"nextbots/swat/idle7.wav",
"nextbots/swat/idle8.wav",
"nextbots/swat/idle9.wav",
"nextbots/swat/idle10.wav",
"nextbots/swat/idle11.wav",
"nextbots/swat/idle12.wav"}

ENT.ReloadingSounds = {"nextbots/swat/reloading1.wav", --Standing reloading sounds 
"nextbots/swat/reloading2.wav",
"nextbots/swat/reloading3.wav",
"nextbots/swat/reloading4.wav",
"nextbots/swat/reloading5.wav",
"nextbots/swat/reloading6.wav"} 
ENT.ReloadingSounds2 = {"nextbots/swat/reloading1.wav", --If running away to reload
"nextbots/swat/reloading2.wav",
"nextbots/swat/reloading3.wav",
"nextbots/swat/reloading4.wav",
"nextbots/swat/reloading5.wav",
"nextbots/swat/reloading6.wav"} 

ENT.ThrowingGrenadeSounds = {"nextbots/swat/throwgrenade1.wav",
"nextbots/swat/throwgrenade2.wav",
"nextbots/swat/throwgrenade3.wav",
"nextbots/swat/throwgrenade4.wav",
"nextbots/swat/throwgrenade5.wav",
"nextbots/swat/throwgrenade6.wav",
"nextbots/swat/throwgrenade7.wav",
"nextbots/swat/throwgrenade8.wav",
"nextbots/swat/throwgrenade9.wav"} 

ENT.RevivingFriendlySounds = {"nextbots/swat/medic2.wav",
"nextbots/swat/medic3.wav",
"nextbots/swat/medic4.wav",
"nextbots/swat/medic5.wav",
"nextbots/swat/medic6.wav",
"nextbots/swat/medic7.wav",
"nextbots/swat/medic11.wav"}

function ENT:SetWeaponType( wep )
	
	if ( wep == "wep_nb_m4a1" or wep == "wep_nb_m4a1s" ) then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt_original"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		
		if wep == "wep_nb_m4a1" then
			self.WeaponSound = "sean_wepnb_sound_m4a1"
		else
			self.WeaponSound = "sean_wepnb_sound_m4a1s"
		end
		
		self.WeaponSpread = 0.3
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 10
		self.ShootDelay = 0.2
		self.BulletNum = 1
		self.BulletDamage = 10
		self.ClipAmount = 30
	
	elseif wep == "wep_nb_m3gauge" then
	
		self.RunningReloadAnim = "reload_shotgun"
		self.StandingReloadAnim = "reload_shotgun_original"
		self.CrouchingReloadAnim = "reload_shotgun"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
		self.WeaponSound = "sean_wepnb_sound_m3gauge"
		self.WeaponSpread = 1
		self.ShootRange = 500
		self.StopRange = 200
		self.BackupRange = 150
		self.BulletForce = 10
		self.ShootDelay = 1.5
		self.BulletNum = 5
		self.BulletDamage = 8
		self.ClipAmount = 7
		
	elseif ( wep == "wep_nb_mp5" or wep == "wep_nb_ump" ) then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt"
		self.WalkAnim = ACT_HL2MP_RUN_SMG1
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		
		if wep == "wep_nb_mp5" then
			self.WeaponSound = "sean_wepnb_sound_mp5"
		else
			self.WeaponSound = "sean_wepnb_sound_ump"
		end
		
		self.WeaponSpread = 0.5
		self.ShootRange = 800
		self.StopRange = 500
		self.BulletForce = 5
		self.ShootDelay = 0.1
		self.BulletNum = 1
		self.BulletDamage = 8
		self.ClipAmount = 30
		
	elseif wep == "wep_nb_famas" then
		
		self.RunningReloadAnim = "reload_ar2"
		self.StandingReloadAnim = "reload_ar2_original"
		self.CrouchingReloadAnim = "reload_ar2"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.WeaponSound = "sean_wepnb_sound_famas"
		self.WeaponSpread = 0.3
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 10
		self.ShootDelay = 1
		self.BulletNum = 1
		self.BulletDamage = 12
		self.ClipAmount = 30
		self.TimesShot = 0
		
	elseif ( wep == "wep_nb_usps" or wep == "wep_nb_usp" ) then
	
		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WalkAnim = ACT_HL2MP_RUN_REVOLVER
		self.AimWalkAnim = ACT_HL2MP_RUN_PISTOL
		self.PatrolWalkAnim = ACT_HL2MP_WALK
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_REVOLVER 
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		
		if wep == "wep_nb_usps" then
			self.WeaponSound = "sean_wepnb_sound_usps"
		else
			self.WeaponSound = "sean_wepnb_sound_usp"
		end
		
		self.WeaponSpread = 0.05
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 5
		self.ShootDelay = 0.3
		self.BulletNum = 1
		self.BulletDamage = 10
		self.ClipAmount = 12
	
	elseif wep == "wep_nb_aug" then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt_original"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.WeaponSound = "sean_wepnb_sound_aug"
		self.WeaponSpread = 0.05
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 10
		self.ShootDelay = 0.25
		self.BulletNum = 1
		self.BulletDamage = 14
		self.ClipAmount = 30
	
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
		self.WeaponClass = "wep_nb_usp"
		self:SetWeaponType( "wep_nb_usp" )
	end
	
	self:EquipWeapon()
	
	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	
	self.Downed = false
	self.DownedOnGround = false
	
	if nb_revive_players then
		wOS.LastStand.InLastStand[ self ] = false
	end
	
	self.WOS_InLastStand = false
	self.GettingUp = false
	
	self.GrenadeThrowAnims = { ACT_GMOD_GESTURE_RANGE_THROW, ACT_GMOD_GESTURE_ITEM_DROP, ACT_GMOD_GESTURE_ITEM_GIVE }
	self.ThrowingGrenade = false
	
end

function ENT:Melee( ent, type )
	self.IsAttacking = true

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
			if !self.Downed then
				self:SetPlaybackRate(2)
			end
		end
	end)
end

function ENT:GrenadeThrow()

	if self.ThrowingGrenade then
		
		if self.Enemy then
		
			local randomsound = table.Random( self.ThrowingGrenadeSounds )
			self:EmitSound( Sound( randomsound ) )
		
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

	if nb_allow_reviving:GetInt() == 1 then
		self:LookForRevive()
	end

	if !( self.GoingToRevive and nb_allow_reviving:GetInt() == 1 ) then
	
		if self:HaveEnemy() and ( IsValid( self.Enemy ) and self.Enemy:Health() > 0 ) then
			
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
		--Gas Nade
		nade = "ent_nb_gas_grenade"
		nademodel = "models/weapons/w_eq_smokegrenade_thrown.mdl"
	elseif nadetype == 2 then
		--Frag Grenade
		nade = "ent_nb_kb_grenade"
		nademodel = "models/weapons/w_eq_fraggrenade_thrown.mdl"
	elseif nadetype == 3 then
		--Shrapnel Grenade
		nade = "ent_nb_shrapnel_grenade"
		nademodel = "models/weapons/w_eq_fraggrenade_thrown.mdl"
	end
			
	timer.Simple( 0.45, function()
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
					
					if nade == "ent_nb_gas_grenade" then
						phys:SetVelocityInstantaneous( v * 1.2 )
					else
						phys:SetVelocityInstantaneous( v * velocity or 3 )		
					end
					
				end
						
			end
				
		end
	end)
		
end