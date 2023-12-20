AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_skeleton_hulk", "Skeleton Hulk")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_skeleton_hulk", 	
{	Name = "Skeleton Hulk", 
	Class = "nb_skeleton_hulk",
	Category = "Skeletons"	
})

ENT.Base = "nb_skeleton_melee_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 74
ENT.CollisionSide = 13

ENT.HealthAmount = 500

ENT.Speed = 45
ENT.SprintingSpeed = 45
ENT.FlinchWalkSpeed = 25
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 70
ENT.MeleeRange = 60
ENT.StopRange = 20

ENT.MeleeDamage = 50
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/player/skeleton.mdl"
ENT.RandomModels = {"models/player/skeleton.mdl",
"models/player/skeleton_zombie.mdl"}

ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

--Sounds--
ENT.AttackSounds = {"nextbots/skeleton/attack.mp3"}

ENT.PainSounds = {"nextbots/skeleton/pain1.mp3",
"nextbots/skeleton/pain2.mp3"}

ENT.AlertSounds = {"nextbots/skeleton/alert1.mp3",
"nextbots/skeleton/alert2.mp3",
"nextbots/skeleton/alert3.mp3"}

ENT.DeathSounds = {"nextbots/skeleton/death1.mp3",
"nextbots/skeleton/death2.mp3",
"nextbots/skeleton/death3.mp3"}

ENT.HeadShotSounds = {"physics/body/body_medium_break2.wav",
"physics/body/body_medium_break3.wav",
"physics/body/body_medium_break4.wav"}
ENT.HeadShotPitch = 100

ENT.IdleSounds = {"nextbots/skeleton/idle1.mp3",
"nextbots/skeleton/idle2.mp3",
"nextbots/skeleton/idle3.mp3",
"nextbots/skeleton/idle4.mp3"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"npc/zombie/claw_strike1.wav"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.Enraged = false

	self:SetModelScale( 1.3 )
	self:SetBloodColor( 2 )
	
	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end

	local walkanims = { ACT_HL2MP_WALK_ZOMBIE_01, ACT_HL2MP_WALK_ZOMBIE_02, ACT_HL2MP_WALK_ZOMBIE_03, ACT_HL2MP_WALK_ZOMBIE_04 }
	self.WalkAnim = table.Random( walkanims )
	
	self:SetModel( table.Random( self.RandomModels ) )
	if self.RandomModels == "models/player/skeleton_zombie.mdl" then
		self.MeleeDamage = 45
		self.MeleeRange = 72
	end
	
	self:SetSkin( math.random(0,3) )
	
end

function ENT:OnKilled( dmginfo )
	self:DeathAnimation( "nb_deathanim_skeleton", self:GetPos(), self.WalkAnim, self:GetModelScale(), 1 )
	self:PlayDeathSound()
end