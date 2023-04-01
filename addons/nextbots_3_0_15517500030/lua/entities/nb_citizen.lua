AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_citizen", "Citizen")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_citizen", 	
{	Name = "Citizen", 
	Class = "nb_citizen",
	Category = "Rebels"	
})

ENT.Base = "nb_citizen_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 80

ENT.Speed = 80
ENT.SprintingSpeed = 180
ENT.PanickedSpeed = 250

ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.MeleeRange = 60
ENT.StopRange = 200

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Models = {"models/player/group01/male_01.mdl",
"models/player/group01/male_01.mdl",
"models/player/group01/male_03.mdl",
"models/player/group01/male_04.mdl",
"models/player/group01/male_05.mdl",
"models/player/group01/male_06.mdl"}

ENT.FemaleModels = {"models/player/group01/female_01.mdl",
"models/player/group01/female_02.mdl",
"models/player/group01/female_03.mdl",
"models/player/group01/female_04.mdl",
"models/player/group01/female_05.mdl",
"models/player/group01/female_06.mdl"}

ENT.WalkAnim = ACT_HL2MP_WALK
ENT.SprintingAnim = ACT_HL2MP_RUN
ENT.PanickedAnim = ACT_HL2MP_RUN_PANICKED

ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_FIST 
ENT.JumpAnim = ACT_HL2MP_JUMP_FIST

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnim = "range_melee_shove_2hand"

--Sounds--
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
"vo/npc/male01/help01.wav",
"vo/npc/male01/uhoh.wav",
"vo/npc/male01/startle01.wav",
"vo/npc/male01/startle02.wav",
"vo/npc/male01/runforyourlife01.wav",
"vo/npc/male01/runforyourlife02.wav",
"vo/npc/male01/runforyourlife03.wav",
"vo/npc/male01/takecover02.wav",
"vo/npc/male01/strider_run.wav",
"vo/npc/male01/gethellout.wav"}

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

ENT.IdleSounds = {"vo/npc/male01/question01.wav",
"vo/npc/male01/question02.wav",
"vo/npc/male01/question03.wav",
"vo/npc/male01/question04.wav",
"vo/npc/male01/question05.wav",
"vo/npc/male01/question06.wav",
"vo/npc/male01/question07.wav",
"vo/npc/male01/question08.wav",
"vo/npc/male01/question09.wav",
"vo/npc/male01/question10.wav",
"vo/npc/male01/question11.wav",
"vo/npc/male01/question12.wav",
"vo/npc/male01/question13.wav",
"vo/npc/male01/question14.wav",
"vo/npc/male01/question15.wav",
"vo/npc/male01/question16.wav",
"vo/npc/male01/question17.wav",
"vo/npc/male01/question18.wav",
"vo/npc/male01/question19.wav",
"vo/npc/male01/question20.wav",
"vo/npc/male01/question21.wav",
"vo/npc/male01/question22.wav",
"vo/npc/male01/question23.wav",
"vo/npc/male01/question24.wav",
"vo/npc/male01/question25.wav",
"vo/npc/male01/question26.wav",
"vo/npc/male01/question27.wav",
"vo/npc/male01/question28.wav",
"vo/npc/male01/question29.wav",
"vo/npc/male01/question30.wav",
"vo/npc/male01/question31.wav"}

ENT.FollowingSounds = {"vo/npc/male01/leadon01.wav",  --Following sounds
"vo/npc/male01/leadon02.wav",
"vo/npc/male01/leadtheway01.wav",
"vo/npc/male01/leadtheway02.wav",
"vo/npc/male01/readywhenyouare01.wav",
"vo/npc/male01/readywhenyouare02.wav"}
ENT.FollowingSounds2 = {"vo/npc/male01/imstickinghere01.wav", --Unfollow sounds
"vo/npc/male01/littlecorner01.wav",
"vo/npc/male01/illstayhere01.wav"}

ENT.WavingSounds = {"vo/npc/male01/hi01.wav",
"vo/npc/male01/hi02.wav"}

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
	"vo/npc/female01/help01.wav",
	"vo/npc/female01/uhoh.wav",
	"vo/npc/female01/startle01.wav",
	"vo/npc/female01/startle02.wav",
	"vo/npc/female01/runforyourlife01.wav",
	"vo/npc/female01/runforyourlife02.wav",
	"vo/npc/female01/runforyourlife03.wav",
	"vo/npc/female01/takecover02.wav",
	"vo/npc/female01/strider_run.wav",
	"vo/npc/female01/gethellout.wav"}

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

	self.IdleSounds = {"vo/npc/female01/question01.wav",
	"vo/npc/female01/question02.wav",
	"vo/npc/female01/question03.wav",
	"vo/npc/female01/question04.wav",
	"vo/npc/female01/question05.wav",
	"vo/npc/female01/question06.wav",
	"vo/npc/female01/question07.wav",
	"vo/npc/female01/question08.wav",
	"vo/npc/female01/question09.wav",
	"vo/npc/female01/question10.wav",
	"vo/npc/female01/question11.wav",
	"vo/npc/female01/question12.wav",
	"vo/npc/female01/question13.wav",
	"vo/npc/female01/question14.wav",
	"vo/npc/female01/question15.wav",
	"vo/npc/female01/question16.wav",
	"vo/npc/female01/question17.wav",
	"vo/npc/female01/question18.wav",
	"vo/npc/female01/question19.wav",
	"vo/npc/female01/question20.wav",
	"vo/npc/female01/question21.wav",
	"vo/npc/female01/question22.wav",
	"vo/npc/female01/question23.wav",
	"vo/npc/female01/question24.wav",
	"vo/npc/female01/question25.wav",
	"vo/npc/female01/question26.wav",
	"vo/npc/female01/question27.wav",
	"vo/npc/female01/question28.wav",
	"vo/npc/female01/question29.wav",
	"vo/npc/female01/question30.wav",
	"vo/npc/female01/question31.wav"}
	
	self.FollowingSounds = {"vo/npc/female01/leadon01.wav",
	"vo/npc/female01/leadon02.wav",
	"vo/npc/female01/leadtheway01.wav",
	"vo/npc/female01/leadtheway02.wav",
	"vo/npc/female01/readywhenyouare01.wav",
	"vo/npc/female01/readywhenyouare02.wav"}
	self.FollowingSounds2 = {"vo/npc/female01/imstickinghere01.wav",
	"vo/npc/female01/littlecorner01.wav",
	"vo/npc/female01/illstayhere01.wav"}

	self.WavingSounds = {"vo/npc/female01/hi01.wav",
	"vo/npc/female01/hi02.wav"}
	
	self.AFemale = true
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		
		self.AFemale = false
		
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
	
	self:MovementFunction()
	
end

function ENT:BodyUpdate()

	if !self.Waving then

		if ( self:GetActivity() == self.WalkAnim ) then
				
			self:BodyMoveXY()
		
		elseif ( self:GetActivity() == self.SprintingAnim ) then
		
			self:BodyMoveXY()
		
		elseif ( self:GetActivity() == self.PanickedAnim ) then
		
			self:BodyMoveXY()
		
		end

	else
	
		self:SetPoseParameter("move_x", 0 )
		self.loco:SetDesiredSpeed(0)
	
	end
	
	self:FrameAdvance()

end

function ENT:CustomOnInjured( dmginfo )

	if !self.InPanic and !self.GoingToRevive then
	
		self:StartPanic( self )
		
		self:AlertNearbyCitizens()
		
	end

end