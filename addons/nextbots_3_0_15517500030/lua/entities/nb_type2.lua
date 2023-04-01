AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_type2", "Type 2")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_type2", 	
{	Name = "Type 2", 
	Class = "nb_type2",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 70

ENT.Speed = 185
ENT.SprintingSpeed = 185
ENT.FlinchWalkSpeed = 60
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2.1

ENT.ShootRange = 150
ENT.MeleeRange = 55
ENT.StopRange = 20

ENT.MeleeDamage = 35
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/player/charple.mdl"

ENT.WalkAnim = ACT_HL2MP_RUN_FAST
ENT.SprintingAnim = ACT_HL2MP_RUN_FAST
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_KNIFE
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL

--Sounds--
ENT.AttackSounds = {""}

ENT.PainSounds = {""}

ENT.AlertSounds = {""}

ENT.DeathSounds = {"nextbots/type2/idle1.wav",
"nextbots/type2/idle2.wav"}

ENT.IdleSounds = {"nextbots/type2/idle1.wav",
"nextbots/type2/idle2.wav"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")

ENT.HitSounds = {"nextbots/type2/attack_hit1.wav",
"nextbots/type2/attack_hit2.wav"}

ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end
	
	self.SlumpAnim = math.random(1,2)
	
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
	
end

function ENT:OnSpawn()
	
	if !self.Entrance then return end
	
	if self.SlumpAnim == 1 then
	
		self:PlaySequenceAndWait( "zombie_slump_idle_01", 1 )
		self:PlaySequenceAndWait( "zombie_slump_rise_01", 1 )

	elseif self.SlumpAnim == 2 then

		self:PlaySequenceAndWait( "zombie_slump_idle_02", 1 )
		
		if math.random(1,2) == 1 then
			self:PlaySequenceAndWait( "zombie_slump_rise_02_fast", 1 )
		else
			self:PlaySequenceAndWait( "zombie_slump_rise_02_slow", 1 )
		end
		
	end
	
	self.Entrance = false
	
end