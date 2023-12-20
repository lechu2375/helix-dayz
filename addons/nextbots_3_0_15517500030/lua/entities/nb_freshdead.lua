AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_freshdead", "Fresh Dead")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_freshdead", 	
{	Name = "Fresh Dead", 
	Class = "nb_freshdead",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 235
ENT.SprintingSpeed = 235
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 600
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 150
ENT.MeleeRange = 50
ENT.StopRange = 20

ENT.MeleeDamage = 20
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Models = {"models/player/group01/male_01.mdl",
"models/player/group01/male_01.mdl",
"models/player/group01/male_03.mdl",
"models/player/group01/male_04.mdl",
"models/player/group01/male_05.mdl",
"models/player/group01/male_06.mdl",
"models/player/group01/female_01.mdl",
"models/player/group01/female_02.mdl",
"models/player/group01/female_03.mdl",
"models/player/group01/female_04.mdl",
"models/player/group01/female_05.mdl",
"models/player/group01/female_06.mdl",
"models/player/phoenix.mdl", 
"models/player/arctic.mdl", 
"models/player/guerilla.mdl",
"models/player/leet.mdl",
"models/player/group03/male_01.mdl",
"models/player/group03/male_01.mdl",
"models/player/group03/male_03.mdl",
"models/player/group03/male_04.mdl",
"models/player/group03/male_05.mdl",
"models/player/group03/male_06.mdl",
"models/player/group03/female_01.mdl",
"models/player/group03/female_02.mdl",
"models/player/group03/female_03.mdl",
"models/player/group03/female_04.mdl",
"models/player/group03/female_05.mdl",
"models/player/group03/female_06.mdl",
"models/player/group03m/male_01.mdl",
"models/player/group03m/male_01.mdl",
"models/player/group03m/male_03.mdl",
"models/player/group03m/male_04.mdl",
"models/player/group03m/male_05.mdl",
"models/player/group03m/male_06.mdl",
"models/player/group03m/female_01.mdl",
"models/player/group03m/female_02.mdl",
"models/player/group03m/female_03.mdl",
"models/player/group03m/female_04.mdl",
"models/player/group03m/female_05.mdl",
"models/player/group03m/female_06.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_ZOMBIE
ENT.SprintingAnim = ACT_HL2MP_RUN_ZOMBIE
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

--Sounds--
ENT.AttackSounds = {"npc/zombie/zombie_alert1.wav",
"npc/zombie/zombie_alert2.wav",
"npc/zombie/zombie_alert3.wav"}
ENT.AttackSoundPitch = math.random(115,125)

ENT.PainSounds = { "nextbots/corpse/pain1.wav", 
"nextbots/corpse/pain2.wav",
"nextbots/corpse/pain3.wav",
"nextbots/corpse/pain4.wav"}

ENT.AlertSounds = { "nextbots/corpse/alert1.wav",
"nextbots/corpse/alert2.wav",
"nextbots/corpse/alert3.wav",
"nextbots/corpse/alert4.wav"}

ENT.DeathSounds = { "nextbots/corpse/death1.wav",
"nextbots/corpse/death2.wav",
"nextbots/corpse/death3.wav",
"nextbots/corpse/death4.wav"}

ENT.IdleSounds = {"nextbots/corpse/alert_no_enemy1.wav",
"nextbots/corpse/alert_no_enemy2.wav",
"nextbots/corpse/flinch1.wav",
"nextbots/corpse/flinch2.wav",
"nextbots/corpse/flinch3.wav"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"Flesh.ImpactHard"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	if !self.Risen then
		
		for k,v in pairs( self.Models ) do
			util.PrecacheModel( v )
		end
		self:SetModel( table.Random( self.Models ) )

		self:SetHealth( self.HealthAmount )
	
	end

	self:MovementFunction()
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