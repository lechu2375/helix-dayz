AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_swat", "SWAT Officer")
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
list.Set( "sean_nextbots", "nb_swat", 	
{	Name = "SWAT Officer", 
	Class = "nb_swat",
	Category = "SWATs"	
})

ENT.Base = "nb_swat_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 7

ENT.HealthAmount = 200

ENT.Speed = 215
ENT.PatrolSpeed = 75
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 850
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
ENT.WeaponClass = "wep_nb_m3gauge"

ENT.Weapons = {"wep_nb_m3gauge", 
"wep_nb_mp5",
"wep_nb_m4a1",
"wep_nb_famas",
"wep_nb_usps"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/easterncrisis/reinforcements/chernarus_infantry_mask.mdl","models/easterncrisis/reinforcements/chernarus_infantry_mask.mdl"}

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

ENT.RevivingFriendlySounds = {"nextbots/swat/medic2.wav",
"nextbots/swat/medic3.wav",
"nextbots/swat/medic4.wav",
"nextbots/swat/medic5.wav",
"nextbots/swat/medic6.wav",
"nextbots/swat/medic7.wav",
"nextbots/swat/medic11.wav"}

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_m4a1" then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt_original"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.WeaponSound = "sean_wepnb_sound_m4a1"
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
		
	elseif wep == "wep_nb_mp5" then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt"
		self.WalkAnim = ACT_HL2MP_RUN_SMG1
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.WeaponSound = "sean_wepnb_sound_mp5"
		self.WeaponSpread = 0.6
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
		self.WeaponSpread = 0.4
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 10
		self.ShootDelay = 1
		self.BulletNum = 1
		self.BulletDamage = 12
		self.ClipAmount = 30
		self.TimesShot = 0
		
	elseif wep == "wep_nb_usps" then
	
		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WalkAnim = ACT_HL2MP_RUN_REVOLVER
		self.AimWalkAnim = ACT_HL2MP_RUN_PISTOL
		self.PatrolWalkAnim = ACT_HL2MP_WALK
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_REVOLVER 
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		self.WeaponSound = "sean_wepnb_sound_usps"
		self.WeaponSpread = 0
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 5
		self.ShootDelay = 0.3
		self.BulletNum = 1
		self.BulletDamage = 8
		self.ClipAmount = 12
	
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
	self:SetSkin(math.random(0, self:SkinCount()))
	local bodyGroups = self:GetBodyGroups()
	for k,v in pairs(bodyGroups) do
		self:SetBodygroup(v.id, math.random(0, v.num))
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
			if !self.Downed then
				self:SetPlaybackRate(2)
			end
		end
	end)
end