AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_mercenary_melee", "Melee Mercenary")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_mercenary_melee", 	
{	Name = "Melee Mercenary", 
	Class = "nb_mercenary_melee",
	Category = "Mercenaries"	
})

ENT.Base = "nb_mercenary_melee_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 150

ENT.Speed = 150
ENT.SprintingSpeed = 150
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 800
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 0.4
ENT.MeleeDelay = 1.6

ENT.ShootRange = 65
ENT.MeleeRange = 65
ENT.StopRange = 40
ENT.BackupRange = 20

ENT.MeleeDamage = 50
ENT.MeleeDamageType = DMG_SLASH
 
ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.WeaponClass = "ent_melee_weapon"
ENT.WeaponModel = "models/weapons/w_crowbar.mdl"

--Model--
ENT.Models = {"models/player/phoenix.mdl", 
"models/player/arctic.mdl", 
"models/player/guerilla.mdl",
"models/player/leet.mdl" }

ENT.WalkAnim = ACT_HL2MP_RUN_MELEE2
ENT.SprintingAnim = ACT_HL2MP_RUN_MELEE2
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_MELEE2 
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_MELEE2
ENT.JumpAnim = ACT_HL2MP_JUMP_MELEE2

--ENT.MeleeAnim = {"aoc_slash_01","aoc_slash_02","aoc_slash_03","aoc_slash_04","aoc_dagger2_throw"}
ENT.MeleeAnim = {"aoc_swordshield_slash_01","aoc_dagger2_throw"}

ENT.BlockAnimation = "aoc_kite_deflect"

--Sounds--
ENT.AttackSounds = {"nextbots/mercenary/attack1.wav", --Melee Sounds
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

ENT.AlertSounds = {"nextbots/mercenary/reload1.wav",
"nextbots/mercenary/reload2.wav",
"nextbots/mercenary/reload3.wav",
"nextbots/mercenary/reload4.wav",
"nextbots/mercenary/reload5.wav",
"nextbots/mercenary/reload6.wav",
"nextbots/mercenary/reload7.wav"} 

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

function ENT:CustomInitialize()

	local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end
	
	self:SetHealth( self.HealthAmount )

	if math.random(1,4) == 1 then
		self.WeaponModel = "models/weapons/w_eq_machete.mdl"
		self.ShootRange = 60
		self.MeleeRange = 60
		self.StopRange = 30
		self.BackupRange = 10
		self.MeleeAnim = {"aoc_spikedmaceshield_slash_01_mod",
		"aoc_swordshield_slash_01_mod",
		"aoc_shortswordshield_slash_01_mod",
		"aoc_slash_03",
		"aoc_slash_01"}
		self.ShootDelay = 0.3
		self.MeleeDelay = 1.2
		self.MeleeDamage = 40
		self.MeleeDamageType = DMG_SLASH
	elseif math.random(1,4) == 2 then
		self.WeaponModel = "models/weapons/w_eq_axe.mdl"
		self.ShootRange = 60
		self.MeleeRange = 60
		self.StopRange = 30
		self.BackupRange = 10
		self.MeleeAnim = {"aoc_swordshield_slash_01","aoc_doubleaxe_slash_02_mod","aoc_doubleaxe_slash_01_mod","aoc_halberd_slash_02_mod"}
		self.ShootDelay = 0.5
		self.MeleeDelay = 1.7
		self.MeleeDamage = 65
		self.MeleeDamageType = DMG_SLASH
	elseif math.random(1,4) == 3 then
		self.WeaponModel = "models/weapons/w_eq_sledgehammer.mdl"
		self.ShootRange = 75
		self.MeleeRange = 75
		self.StopRange = 50
		self.BackupRange = 30
		self.MeleeAnim = {"aoc_swordshield_slash_01","aoc_spearshield_slash_01","aoc_spikedmace_slash_02","aoc_swordshield_slash_02"}
		self.ShootDelay = 0.8
		self.MeleeDelay = 2
		self.MeleeDamage = 115
		self.MeleeDamageType = DMG_CLUB
	end
	
	self:EquipWeapon()
	
end