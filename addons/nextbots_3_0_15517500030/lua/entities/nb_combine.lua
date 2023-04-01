AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_combine", "Combine")
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
list.Set( "sean_nextbots", "nb_combine", 	
{	Name = "Combine", 
	Class = "nb_combine",
	Category = "Combine"	
})

ENT.Base = "nb_combine_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 9

ENT.HealthAmount = 300

ENT.Speed = 175
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

ENT.MeleeDamage = 30
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 30
ENT.WeaponSpread = 0.1
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_ar2"

ENT.Weapons = {"wep_nb_ar2",
"wep_nb_smg",
"wep_nb_shotgun"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/player/combine_soldier.mdl"}

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
	
	if wep == "wep_nb_ar2" then
	
		self.WeaponTracer = "AR2Tracer"
	
		self.RunningReloadAnim = "reload_ar2"
		self.StandingReloadAnim = "reload_ar2_original"
		self.CrouchingReloadAnim = "reload_ar2"
		self.WalkAnim = ACT_HL2MP_RUN_AR2
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_AR2
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

		self.WeaponSound = "Weapon_Ar2.Single"
		self.WeaponSpread = 0.8
		self.ShootRange = 1500
		self.StopRange = 800
		self.BackupRange = 500
		self.BulletForce = 10
		self.ShootDelay = 0.1
		self.BulletNum = 1
		self.BulletDamage = 8
		self.ClipAmount = 30
	
	elseif wep == "wep_nb_smg" then
	
		self.RunningReloadAnim = "reload_smg1"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1"
		self.WalkAnim = ACT_HL2MP_RUN_SMG1
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1

		self.WeaponSound = "Weapon_Smg1.Single"
		self.WeaponSpread = 0.6
		self.ShootRange = 850
		self.StopRange = 700
		self.BackupRange = 500
		self.BulletForce = 10
		self.ShootDelay = 0.05
		self.BulletNum = 1
		self.BulletDamage = 7
		self.ClipAmount = 45
	
	elseif wep == "wep_nb_shotgun" then
	
		self.RunningReloadAnim = "reload_shotgun"
		self.StandingReloadAnim = "reload_smg1_shotgun"
		self.CrouchingReloadAnim = "reload_shotgun"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
		
		self.WeaponSpread = 1
		self.ShootRange = 650
		self.StopRange = 450
		self.BackupRange = 300
		self.BulletForce = 15
		self.ShootDelay = 1.5
		self.BulletNum = 5
		self.BulletDamage = 8
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
		self.WeaponClass = "wep_nb_ar2"
		self:SetWeaponType( "wep_nb_ar2" )
	end
	
	self:EquipWeapon()
	
	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	self.Downed = false
	self.DownedOnGround = false
	self.GettingUp = false

end