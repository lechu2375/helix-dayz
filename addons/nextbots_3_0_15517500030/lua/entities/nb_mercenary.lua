AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_mercenary", "Mercenary")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_mercenary", 	
{	Name = "Mercenary", 
	Class = "nb_mercenary",
	Category = "Mercenaries"	
})

ENT.Base = "nb_mercenary_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 130

ENT.Speed = 180
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

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

ENT.Weapons = {"wep_nb_xm1014", 
"wep_nb_mac10",
"wep_nb_ak47",
"wep_nb_awp"}

ENT.WeaponModel = "models/weapons/w_rif_ak47.mdl"
ENT.WeaponSound = "sean_wepnb_sound_ak47"

--Model--
ENT.Models = {"models/gmodz/npc/bandit_exp.mdl","models/gmodz/npc/bandit_exp.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_SMG1
ENT.BombRunAnim = ACT_HL2MP_RUN_SLAM 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40 
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SMG1
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
ENT.MeleeAnim = "range_melee_shove_2hand"

--Sounds--
ENT.AttackSounds = {"nextbots/mercenary/attack1.wav", --Melee Sounds
"nextbots/mercenary/attack2.wav",
"nextbots/mercenary/attack3.wav",
"nextbots/mercenary/attack4.wav",
"nextbots/mercenary/attack5.wav",
"nextbots/mercenary/attack6.wav",
"nextbots/mercenary/attack7.wav"}

ENT.AttackSounds2 = {}

local str = "gmodz/npc/bandit/attack_"
for i=1,11 do
	ENT.AttackSounds2[#ENT.AttackSounds2+1] = str..i..".ogg"
end

ENT.PainSounds = {}
local str = "gmodz/npc/bandit/hit_"
for i=1,7 do
	ENT.PainSounds[#ENT.PainSounds+1] = str..i..".ogg"
end

ENT.AlertSounds = {""}

ENT.DeathSounds = {}
local str = "gmodz/npc/bandit/death_"
for i=1,7 do
	ENT.DeathSounds[#ENT.DeathSounds+1] = str..i..".ogg"
end

ENT.IdleSounds = {}
local str = "gmodz/npc/bandit/idle_"
for i=1,35 do
	ENT.IdleSounds[#ENT.IdleSounds+1] = str..i..".ogg"
end
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
	
	if wep == "wep_nb_mac10" then
	
		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WalkAnim = ACT_HL2MP_RUN_PISTOL
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_PISTOL
		self.FlinchWalkAnim = ACT_HL2MP_WALK_PISTOL
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		self.WeaponSound = "sean_wepnb_sound_mac10"
		self.ShootDelay = 0.08
		self.BulletForce = 5
		self.ShootRange = 650
		self.StopRange = 450
		self.BackupRange = 200
	
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
		self.BulletNum = 3
		self.ClipAmount = 7
		self.ShootRange = 500
		self.StopRange = 300
		self.BackupRange = 200
		
	elseif wep == "wep_nb_awp" then
		
		self.RunningReloadAnim = "reload_smg1"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt_original"
		self.WalkAnim = ACT_HL2MP_WALK_RPG
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_RPG
		self.FlinchWalkAnim = ACT_HL2MP_WALK_RPG
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
		self.WeaponSound = "sean_wepnb_sound_awp"
		self.ShootDelay = 3
		self.BulletForce = 50
		self.BulletDamage = 50
		self.WeaponSpread = 0.03
		self.ClipAmount = 5
		self.ShootRange = 1000
		self.StopRange = 1000
		self.BackupRange = 350
		self.Speed = 90	
		
	elseif wep == "wep_nb_ak47" then
	
		self.RunningReloadAnim = "reload_smg1_alt"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1_alt"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.FlinchWalkAnim = ACT_HL2MP_WALK_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
		self.ShootRange = 750
		self.StopRange = 600
		self.BackupRange = 300
		
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
		self:EquipBomb()
	else
		self:EquipWeapon()
	end
	
end