AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_skeleton_fast", "Fast Skeleton")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_skeleton_fast", 	
{	Name = "Fast Skeleton", 
	Class = "nb_skeleton_fast",
	Category = "Skeletons"	
})

ENT.Base = "nb_skeleton_melee_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 80

ENT.Speed = 305
ENT.SprintingSpeed = 305
ENT.FlinchWalkSpeed = 65
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 750
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 75
ENT.MeleeRange = 50
ENT.StopRange = 20

ENT.MeleeDamage = 25
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/player/skeleton.mdl"
ENT.RandomModels = {"models/player/skeleton.mdl",
"models/player/skeleton_zombie.mdl"}

ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_02
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_02 
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

	self:SetBloodColor( 2 )
	
	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end

	local walkanims = { ACT_HL2MP_RUN_ZOMBIE, ACT_HL2MP_RUN_FAST }
	self.WalkAnim = table.Random( walkanims )
	self.SprintingAnim = self.WalkAnim
	
	self:SetModel( table.Random( self.RandomModels ) )
	if self.RandomModels == "models/player/skeleton_zombie.mdl" then
		self.MeleeDamage = 20
		self.MeleeRange = 60
	end
	
	self:SetSkin( math.random(0,3) )
	
end

function ENT:Flinch( dmginfo, hitgroup )
	
	if ( self.NextFlinchTimer or 0 ) < CurTime() then
						
		if hitgroup == HITGROUP_HEAD then
			self:PlayGestureSequence( "flinch_head_0"..math.random(1,2) )
		elseif hitgroup == HITGROUP_RIGHTARM then
			self:PlayGestureSequence( "flinch_shoulder_r" )
		elseif hitgroup == HITGROUP_LEFTARM then
			self:PlayGestureSequence( "flinch_shoulder_l" )
		elseif hitgroup == HITGROUP_CHEST then
			self:PlayGestureSequence( "flinch_phys_0"..math.random(1,2) )
		elseif hitgroup == ( HITGROUP_GEAR or HITGROUP_STOMACH ) then
			self:PlayGestureSequence( "flinch_stomach_0"..math.random(1,2) )
		elseif hitgroup == ( HITGROUP_RIGHTLEG or HITGROUP_LEFTLEG ) then
			self:PlayGestureSequence( "flinch_0"..math.random(1,2) )	
		end	
		
		self.NextFlinchTimer = CurTime() + 0.15
		
		if dmginfo:GetDamage() > 15 then
			self.WalkAnim = self.FlinchWalkAnim
			self.Speed = self.FlinchWalkSpeed
			self:MovementFunction()
			
			timer.Simple( 1.08, function()
				if ( IsValid(self) and self:Health() > 0) then
					self.Speed = self.SprintingSpeed
					self.WalkAnim = self.SprintingAnim
					self:MovementFunction()
				end
			end)
			
			self.NextFlinchTimer = CurTime() + 1.1
		end
		
	end
	
end

function ENT:OnKilled( dmginfo )

	self:BecomeRagdoll( dmginfo )
	self:PlayDeathSound()
	
end