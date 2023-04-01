AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_rebel", "Rebel")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_rebel", 	
{	Name = "Rebel", 
	Class = "nb_rebel",
	Category = "Rebels"	
})

ENT.Base = "nb_rebel_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 125

ENT.Speed = 180
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

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
"wep_nb_revolver"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

ENT.PistolClass = "wep_nb_pistol"
ENT.PistolSound = "Weapon_Pistol.Single"

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

ENT.WalkAnim = ACT_HL2MP_RUN_SHOTGUN  
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

	self.ReloadingSounds = {"vo/npc/female01/coverwhilereload01.wav", 
	"vo/npc/female01/coverwhilereload02.wav",}  
	self.ReloadingSounds2 = {"vo/npc/female01/runforyourlife01.wav",
	"vo/npc/female01/runforyourlife02.wav",
	"vo/npc/female01/runforyourlife03.wav",
	"vo/npc/female01/takecover02.wav",
	"vo/npc/female01/strider_run.wav",
	"vo/npc/female01/gethellout.wav"}

end

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_smg" then
	
		self.RunningReloadAnim = "reload_smg1"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1"
		self.WalkAnim = ACT_HL2MP_RUN_SMG1
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1
		self.FlinchWalkAnim = ACT_HL2MP_WALK_SMG1
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.WeaponSound = "Weapon_Smg1.Single"
		self.ShootDelay = 0.1
		self.BulletForce = 5
		self.ClipAmount = 45
		self.ShootRange = 650
		self.StopRange = 450
		self.BackupRange = 200
	
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
		self.ShootRange = 500
		self.StopRange = 300
		self.BackupRange = 200
		
	elseif wep == "wep_nb_revolver" then
		
		self.RunningReloadAnim = "reload_revolver"
		self.StandingReloadAnim = "reload_revolver_original"
		self.CrouchingReloadAnim = "reload_revolver"
		self.WeaponSound = "sean_wepnb_sound_revolver"
		self.WalkAnim = ACT_HL2MP_RUN_REVOLVER
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_REVOLVER
		self.FlinchWalkAnim = ACT_HL2MP_WALK_REVOLVER
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
		self.BulletForce = 5
		self.ShootDelay = 1
		self.BulletNum = 1
		self.BulletDamage = 30
		self.ClipAmount = 6
		self.BulletOffSet = 6
		self.ShootRange = 750
		self.StopRange = 500
		self.BackupRange = 300
		
	elseif wep == "wep_nb_pistol" then
	
		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WeaponSound = self.PistolSound
		self.WalkAnim = ACT_HL2MP_RUN_PISTOL
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_PISTOL
		self.FlinchWalkAnim = ACT_HL2MP_WALK_PISTOL
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		self.BulletForce = 5
		self.ShootDelay = 0.5
		self.BulletNum = 1
		self.BulletDamage = 5
		self.ClipAmount = 12
		self.ShootRange = 650
		self.StopRange = 500
		self.BackupRange = 300
		
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		
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
	
	for k,v in pairs( self.FemaleModels ) do
		if self:GetModel() == v then
			self:ChangeVoice()
		end
	end
	
end