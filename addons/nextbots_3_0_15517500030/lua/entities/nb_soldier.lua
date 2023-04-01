AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_soldier", "Soldier")
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
list.Set( "sean_nextbots", "nb_soldier", 	
{	Name = "Soldier", 
	Class = "nb_soldier",
	Category = "Mercenaries"	
})

ENT.Base = "nb_soldier_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 9

ENT.HealthAmount = 250

ENT.Speed = 175
ENT.PatrolSpeed = 55
ENT.SprintingSpeed = 255
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

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
"wep_nb_xm1014",
"wep_nb_ak47",
"wep_nb_mac10"}

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
ENT.MeleeAnims = {"aoc_spearshield_slash_02_mod",
"aoc_swordshield_slash_01_mod",
"aoc_halberd_slash_01_mod"}

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
ENT.AttackSoundPitch = math.random(80,90)

ENT.PainSounds = {"nextbots/mercenary/pain1.wav",
"nextbots/mercenary/pain2.wav",
"nextbots/mercenary/pain3.wav",
"nextbots/mercenary/pain4.wav",
"nextbots/mercenary/pain5.wav",
"nextbots/mercenary/pain6.wav"}
ENT.PainSoundPitch = math.random(90,95)

ENT.AlertSounds = {""}

ENT.DeathSounds = {"nextbots/mercenary/death1.wav",
"nextbots/mercenary/death2.wav",
"nextbots/mercenary/death3.wav",
"nextbots/mercenary/death4.wav",
"nextbots/mercenary/death5.wav",
"nextbots/mercenary/death6.wav",
"nextbots/mercenary/death7.wav"}
ENT.DeathSoundPitch = math.random(80,90)

ENT.IdleSounds = {"nextbots/mercenary/idle1.wav",
"nextbots/mercenary/idle2.wav",
"nextbots/mercenary/idle3.wav",
"nextbots/mercenary/idle4.wav",
"nextbots/mercenary/idle5.wav",
"nextbots/mercenary/idle6.wav"}
ENT.IdleSoundPitch = math.random(80,90)

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
ENT.ReloadingSoundPitch = math.random(80,90)

ENT.RevivingFriendlySounds = {""}

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_ak47" then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt_original"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.WeaponSound = "sean_wepnb_sound_ak47"
		self.WeaponSpread = 0.4
		self.ShootRange = 1500
		self.StopRange = 800
		self.BulletForce = 10
		self.ShootDelay = 0.2
		self.BulletNum = 1
		self.BulletDamage = 12
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
		self.WeaponSpread = 0.8
		self.ShootRange = 800
		self.StopRange = 500
		self.BulletForce = 5
		self.ShootDelay = 0.1
		self.BulletNum = 1
		self.BulletDamage = 7
		self.ClipAmount = 30
		
	elseif wep == "wep_nb_mac10" then
		
		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WalkAnim = ACT_HL2MP_RUN_PISTOL
		self.PatrolWalkAnim = ACT_HL2MP_WALK
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_PISTOL
		self.FlinchWalkAnim = ACT_HL2MP_WALK_PISTOL
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		self.WeaponSound = "sean_wepnb_sound_mac10"
		self.WeaponSpread = 0.4
		self.ShootRange = 650
		self.StopRange = 500
		self.BulletForce = 5
		self.ShootDelay = 0.08
		self.BulletNum = 1
		self.BulletDamage = 5
		self.ClipAmount = 15
		
	elseif wep == "wep_nb_xm1014" then
	
		self.RunningReloadAnim = "reload_shotgun"
		self.StandingReloadAnim = "reload_shotgun_original"
		self.CrouchingReloadAnim = "reload_shotgun"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN
		self.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
		self.WeaponSound = "sean_wepnb_sound_xm1014"
		self.ShootDelay = 0.3
		self.BulletForce = 30
		self.BulletDamage = 7
		self.BulletNum = 3
		self.ClipAmount = 7
		self.ShootRange = 300
		self.StopRange = 150
		self.BackupRange = 80
	
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
	
		self:SetSkin( math.random(0,14) )
		self:SetBodygroup( 4, 1 )
		self:SetBodygroup( 5, math.random(0,1) )
		self:SetBodygroup( 6, 1 )
		self:SetBodygroup( 7, 1 )
		for i=0,2 do
			self:SetBodygroup( 8+i, 1 )
		end
	
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
		self.WeaponClass = "wep_nb_mac10"
		self:SetWeaponType( "wep_nb_mac10" )
	end
	
	self:EquipWeapon()
	
	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	self.Downed = false
	self.DownedOnGround = false
	self.GettingUp = false

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