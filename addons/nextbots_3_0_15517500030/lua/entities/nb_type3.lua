AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_type3", "Type 3")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_type3", 	
{	Name = "Type 3", 
	Class = "nb_type3",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 250

ENT.Speed = 180
ENT.SprintingSpeed = 180
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 600
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 125
ENT.MeleeRange = 65
ENT.StopRange = 20

ENT.MeleeDamage = 35
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/player/poison_player.mdl"

ENT.WalkAnim = ACT_HL2MP_RUN_ZOMBIE_FAST
ENT.SprintingAnim = ACT_HL2MP_RUN_ZOMBIE
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL

--Sounds--
ENT.AttackSounds = {"npc/zombie/zombie_alert1.wav",
"npc/zombie/zombie_alert2.wav",
"npc/zombie/zombie_alert3.wav"}
ENT.AttackSoundPitch = math.random(75,85)

ENT.PainSounds = { "npc/zombie_poison/pz_pain1.wav", 
"npc/zombie_poison/pz_pain2.wav",
"npc/zombie_poison/pz_pain3.wav"}
ENT.PainSoundPitch = math.random(90,110)

ENT.AlertSounds = {"npc/zombie/zo_attack1.wav", 
"npc/zombie/zo_attack2.wav"}
ENT.AlertSoundPitch = math.random(70,80)

ENT.DeathSounds = { "npc/zombie_poison/pz_die1.wav",
"npc/zombie_poison/pz_die2.wav"}
ENT.DeathSoundPitch = math.random(90,110)

ENT.IdleSounds = { "npc/zombie_poison/pz_idle2.wav",
"npc/zombie_poison/pz_idle3.wav",
"npc/zombie_poison/pz_idle4.wav"}
ENT.IdleSoundPitch = math.random(90,110)

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"npc/zombie/claw_strike1.wav"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	if !self.Risen then
		
		self:SetModel( self.Model )
		self:SetHealth( self.HealthAmount )
	
		local walkanims = { ACT_HL2MP_RUN_ZOMBIE, ACT_HL2MP_RUN_ZOMBIE_FAST }
		self.WalkAnim = table.Random( walkanims )
	
	end

	self:MovementFunction()
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		self.HitByVehicle = true
		
		local veh = ent:GetPhysicsObject()
		local dmg = math.Round( (ent:GetVelocity():Length() / 3 + ( veh:GetMass() / 50 ) ), 0 )
		
		if ent:GetOwner():IsValid() then
			self:TakeDamage( dmg, ent:GetOwner() )
		end
		
		self:SetModel( "models/zombie/poison.mdl" )
		self:VehicleHit( ent, "nb_rise_base", self:GetClass(), "", ( self:Health() - dmg ), true )

	end
	
	if ent != self.Enemy then
		if ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) or ( ent.NEXTBOT and !ent.NEXTBOTZOMBIE ) then
			if ( self.NextMeleeTimer or 0 ) < CurTime() then
				self:Melee( ent )
				self:SetEnemy( ent )
				self:BehaveStart()
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
		end
	end
	
	self:CustomOnContact2( ent )
	
end

function ENT:OnKilled( dmginfo )

	self:SetModel( "models/zombie/poison.mdl" )
	self:BecomeRagdoll( dmginfo )
	self:PlayDeathSound()
	
end