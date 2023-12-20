AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_shambler", "Shambler")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_shambler", 	
{	Name = "Shambler", 
	Class = "nb_shambler",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.SearchRadius = 2000

ENT.CollisionHeight = 66
ENT.CollisionSide = 7

ENT.HealthAmount = 105

ENT.Speed = 50
ENT.SprintingSpeed = 50
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 80
ENT.MeleeRange = 40
ENT.StopRange = 20

ENT.MeleeDamage = 20
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Models = { "models/zombie/grabber_01.mdl",
"models/zombie/grabber_02.mdl",
"models/zombie/grabber_03.mdl",
"models/zombie/grabber_04.mdl",
"models/zombie/grabber_05.mdl",
"models/zombie/grabber_06.mdl",
"models/zombie/grabber_07.mdl",
"models/zombie/grabber_08.mdl",
"models/zombie/grabber_09.mdl",
"models/zombie/grabber_10.mdl",
"models/zombie/infected_01.mdl",
"models/zombie/infected_02.mdl",
"models/zombie/infected_03.mdl",
"models/zombie/infected_04.mdl",
"models/zombie/infected_05.mdl",
"models/zombie/infected_06.mdl",
"models/zombie/infected_07.mdl",
"models/zombie/infected_08.mdl",
"models/zombie/infected_09.mdl",
"models/zombie/infected_10.mdl",
"models/zombie/infected_11.mdl",
"models/zombie/infected_12.mdl" }

ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

--Sounds--
ENT.AttackSounds = {"nextbots/shambler/zo_attack1.wav",
"nextbots/shambler/zo_attack2.wav"}

ENT.PainSounds = {"nextbots/shambler/zombie_pain1.wav",
"nextbots/shambler/zombie_pain2.wav",
"nextbots/shambler/zombie_pain3.wav",
"nextbots/shambler/zombie_pain4.wav",
"nextbots/shambler/zombie_pain5.wav",
"nextbots/shambler/zombie_pain6.wav",
"nextbots/shambler/zombie_voice_idle9.wav"}

ENT.AlertSounds = {"nextbots/shambler/zombie_voice_idle14.wav",
"nextbots/shambler/zombie_voice_idle13.wav",
"nextbots/shambler/zombie_voice_idle12.wav"}

ENT.DeathSounds = {"nextbots/shambler/zombie_die1.wav",
"nextbots/shambler/zombie_die2.wav",
"nextbots/shambler/zombie_die3.wav"}

ENT.IdleSounds = {"nextbots/shambler/zombie_voice_idle1.wav",
"nextbots/shambler/zombie_voice_idle2.wav",
"nextbots/shambler/zombie_voice_idle3.wav",
"nextbots/shambler/zombie_voice_idle4.wav",
"nextbots/shambler/zombie_voice_idle5.wav",
"nextbots/shambler/zombie_voice_idle6.wav",
"nextbots/shambler/zombie_voice_idle7.wav",
"nextbots/shambler/zombie_voice_idle8.wav",
"nextbots/shambler/zombie_voice_idle9.wav"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"Flesh.ImpactHard"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.Flinching = false

	if !self.Risen then
		for k,v in pairs( self.Models ) do
			util.PrecacheModel( v )
		end
		self:SetModel( table.Random( self.Models ) )
		self:SetHealth( self.HealthAmount )
	end

	local walkanims = { ACT_HL2MP_WALK_ZOMBIE_01, ACT_HL2MP_WALK_ZOMBIE_02, ACT_HL2MP_WALK_ZOMBIE_03, ACT_HL2MP_WALK_ZOMBIE_04, ACT_WALK }
	self.WalkAnim = table.Random( walkanims )
	
	self.HealthAmount = self.HealthAmount + math.random(0,25)
	self.MeleeDamage = self.MeleeDamage + math.random(0,5)
	self.Speed = self.Speed + math.random(0,15)
	
end

function ENT:OnInjured( dmginfo )

	--1=Zombie,2=Rebel,3=Mercenary,4=Combine
	if self:CheckFriendlyFire( dmginfo:GetAttacker(), 1 ) then 
		dmginfo:ScaleDamage(0)
	return end

	if ( dmginfo:IsBulletDamage() ) then

		local attacker = dmginfo:GetAttacker()
	
			local trace = {}
			trace.start = attacker:EyePos()

			trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
			trace.mask = MASK_SHOT
			trace.filter = attacker
		
			local tr = util.TraceLine( trace )
			hitgroup = tr.HitGroup
			
			if hitgroup == ( HITGROUP_LEFTLEG or HITGROUP_RIGHTLEG ) then
				dmginfo:ScaleDamage(0.45)	
			end

			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage( self.HeadShotMultipler or 8)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end

	end

	if !self.Flinching then
		if dmginfo:GetDamage() > 35 then
			self:HardFlinch( dmginfo, hitgroup )
		else
			self:Flinch( dmginfo, hitgroup )
		end
	end
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
end

function ENT:MovementFunction()

	if self.Enemy then
		self:StartActivity( self.WalkAnim )
		self.loco:SetDesiredSpeed( self.Speed )
	else
		if ( self.NextIdleAnimTimer or 0 ) < CurTime() then
			self:StartActivity( ACT_IDLE )
			self.loco:SetDesiredSpeed( 0 )
			self.NextIdleAnimTimer = CurTime() + 2
		end
	end
	
end