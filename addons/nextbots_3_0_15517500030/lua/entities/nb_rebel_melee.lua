AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_rebel_melee", "Melee Rebel")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_rebel_melee", 	
{	Name = "Melee Rebel", 
	Class = "nb_rebel_melee",
	Category = "Rebels"	
})

ENT.Base = "nb_rebel_melee_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 125

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
ENT.Models = {"models/player/group03/male_01.mdl",
"models/player/group03/male_01.mdl",
"models/player/group03/male_03.mdl",
"models/player/group03/male_04.mdl",
"models/player/group03/male_05.mdl",
"models/player/group03/male_06.mdl"}

ENT.FemaleModels = {"models/player/group03/female_01.mdl",
"models/player/group03/female_02.mdl",
"models/player/group03/female_03.mdl",
"models/player/group03/female_04.mdl",
"models/player/group03/female_05.mdl",
"models/player/group03/female_06.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_MELEE2
ENT.SprintingAnim = ACT_HL2MP_RUN_MELEE2
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_MELEE2 
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_MELEE2
ENT.JumpAnim = ACT_HL2MP_JUMP_MELEE2

ENT.MeleeAnim = {"aoc_swordshield_slash_01","aoc_dagger2_throw"}

ENT.BlockAnimation = "aoc_kite_deflect"

--Sounds--
ENT.AttackSounds = {""} --Melee Sounds

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

function ENT:ChangeVoice()

	self.PainSounds = {"vo/npc/female01/pain01.wav",
	"vo/npc/female01/pain02.wav",
	"vo/npc/female01/pain03.wav",
	"vo/npc/female01/pain04.wav",
	"vo/npc/female01/pain05.wav",
	"vo/npc/female01/pain06.wav",
	"vo/npc/female01/pain07.wav",
	"vo/npc/female01/pain08.wav",
	"vo/npc/female01/pain09.wav",
	"vo/npc/female01/ow01.wav",
	"vo/npc/female01/ow02.wav"}

	self.AlertSounds = {"vo/npc/female01/watchout.wav",
	"vo/npc/female01/heretheycome01.wav",
	"vo/npc/female01/headsup01.wav",
	"vo/npc/female01/headsup02.wav",
	"vo/npc/female01/help01.wav",
	"vo/npc/female01/uhoh.wav",
	"vo/npc/female01/startle01.wav",
	"vo/npc/female01/startle02.wav",
	"vo/npc/female01/incoming02.wav"}
	self.AlertSounds2 = {"vo/npc/female01/watchout.wav",
	"vo/npc/female01/zombies01.wav",
	"vo/npc/female01/zombies02.wav",
	"vo/npc/female01/incoming02.wav"}

	self.DeathSounds = {"vo/npc/female01/no01.wav",
	"vo/npc/female01/no02.wav",
	"vo/npc/female01/ohno.wav",
	"vo/npc/female01/pain02.wav",
	"vo/npc/female01/pain03.wav",
	"vo/npc/female01/pain04.wav",
	"vo/npc/female01/pain05.wav",
	"vo/npc/female01/pain06.wav",
	"vo/npc/female01/pain07.wav",
	"vo/npc/female01/pain08.wav",
	"vo/npc/female01/pain09.wav",
	"vo/npc/female01/ow01.wav",
	"vo/npc/female01/ow02.wav"}

	self.FollowingSounds = {"vo/npc/female01/leadon01.wav",
	"vo/npc/female01/leadon02.wav",
	"vo/npc/female01/leadtheway01.wav",
	"vo/npc/female01/leadtheway02.wav",
	"vo/npc/female01/readywhenyouare01.wav",
	"vo/npc/female01/readywhenyouare02.wav"}
	self.FollowingSounds2 = {"vo/npc/female01/imstickinghere01.wav",
	"vo/npc/female01/littlecorner01.wav",
	"vo/npc/female01/illstayhere01.wav"}

end

function ENT:CustomInitialize()

	util.PrecacheModel( table.ToString( self.Models ) )
	util.PrecacheModel( table.ToString( self.FemaleModels ) )
		
	local model
	if math.random(1,2) == 1 then
		model = table.Random( self.Models )
	else
		model = table.Random( self.FemaleModels )
		self:ChangeVoice()
	end
		
	self:SetModel( model )
	
	self:SetHealth( self.HealthAmount )
	
	if math.random(1,4) == 1 then
		self.WeaponModel = "models/props_canal/mattpipe.mdl"
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
		self.MeleeDamageType = DMG_CLUB
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
		self.WeaponModel = "models/weapons/w_eq_shovel.mdl"
		self.ShootRange = 75
		self.MeleeRange = 75
		self.StopRange = 50
		self.BackupRange = 30
		self.MeleeAnim = {"aoc_swordshield_slash_01","aoc_spearshield_slash_01","aoc_spikedmace_slash_02","aoc_swordshield_slash_02"}
		self.ShootDelay = 0.65
		self.MeleeDelay = 1.85
		self.MeleeDamage = 90
		self.MeleeDamageType = DMG_CLUB
	end
	
	self:EquipWeapon()
	
end