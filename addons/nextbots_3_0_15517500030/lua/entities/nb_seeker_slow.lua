AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_seeker_slow", "Seeker")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_seeker_slow", 	
{	Name = "Seeker Crippled", 
	Class = "nb_seeker_slow",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 55
ENT.SprintingSpeed = 55
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 90
ENT.MeleeRange = 60
ENT.StopRange = 20

ENT.MeleeDamage = 20
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Models = {"models/freshdead/freshdead_01.mdl",
"models/freshdead/freshdead_02.mdl",
"models/freshdead/freshdead_03.mdl",
"models/freshdead/freshdead_04.mdl",
"models/freshdead/freshdead_05.mdl",
"models/freshdead/freshdead_06.mdl",
"models/freshdead/freshdead_07.mdl",
"models/zombie/seeker_01.mdl",
"models/zombie/seeker_02.mdl",
"models/zombie/seeker_03.mdl"}

ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

--Sounds--
ENT.AttackSounds = {"nextbots/seeker/attack1.wav", 
"nextbots/seeker/attack2.wav",
"nextbots/seeker/attack3.wav",
"nextbots/seeker/attack4.wav"}

ENT.PainSounds = {"nextbots/seeker/pain1.wav", 
"nextbots/seeker/pain2.wav", 
"nextbots/seeker/pain3.wav", 
"nextbots/seeker/pain4.wav"}

ENT.AlertSounds = {"nextbots/seeker/alert1.wav", 
"nextbots/seeker/alert2.wav",
"nextbots/seeker/alert3.wav",
"nextbots/seeker/alert4.wav"}

ENT.DeathSounds = {"nextbots/seeker/death1.wav",
"nextbots/seeker/death2.wav",
"nextbots/seeker/death3.wav",
"nextbots/seeker/death4.wav"}

ENT.IdleSounds = {"nextbots/seeker/idle1.wav",
"nextbots/seeker/idle2.wav",
"nextbots/seeker/idle3.wav",
"nextbots/seeker/idle4.wav"}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"Flesh.ImpactHard"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.Enraged = false

	if !self.Risen then
		
		for k,v in pairs( self.Models ) do
			util.PrecacheModel( v )
		end
		
		local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end

		self:SetHealth( self.HealthAmount )
	
	end

	local walkanims = { ACT_HL2MP_WALK_ZOMBIE_01, ACT_HL2MP_WALK_ZOMBIE_02, ACT_HL2MP_WALK_ZOMBIE_03, ACT_HL2MP_WALK_ZOMBIE_04 }
	self.WalkAnim = table.Random( walkanims )
	
	self.FindRadius = 768

	local SpawnTime = CurTime()
	
	self.Leader = self
	self.TargetPos = self:GetPos()
	
	self.CreateTime = SpawnTime
	
	self.NextSearch = SpawnTime
	
	if math.random(1,2) == 1 then
		self.Follower = true
	end
	
end

function ENT:Think()

	--if SERVER then

		--if self.Leader == self then
		
			--self:SetColor( Color( 255, 0, 0, 255 ) )
		
		--else
		
			--self:SetColor( Color( 255, 255, 255, 255 ) )
		
		--end

	--end
	
end

function ENT:StartRoaming()
	--Set Our Walk Speed Each Frame
	self.loco:SetDesiredSpeed( self.Speed )
	self:MovementFunction()
	local SpawnTime = CurTime()
	--If time To Search
	if ( self.NextSearch < SpawnTime ) then
		--[		Don't Pile Up In Water :[											]--
		--if  ( self:WaterLevel() > 0 ) then
			--self:Remove()
		--end
				--[		Cache Some Variables Which Are Used Multiple Times					]--
		local MyPos = self:GetPos()
		local Leader = self.Leader
				--[		If We Are A leader													]--
		if ( Leader == self ) then
					--[		Find New Group Pos												]--
			self.TargetPos = MyPos + Vector( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * (self.FindRadius)
					--[		Find Other Leaders												]--
			for _,v in pairs(ents.FindInSphere(MyPos, self.FindRadius)) do
				if ( v.Follower ) then
							--[		If Not Us												]--
					if ( v != self ) then
								--[		If NPC Is A Leader									]--
						if ( v.Leader == v ) then
									--[ 	If They Are Older Than Us						]--
							if ( v.CreateTime > self.CreateTime ) then
										--[		Make Them Our Leader						]--
								self.Leader = v
										--[		Break The Loop								]--
								break
							end
						end
					end
				end
			end
				--[		If Were Not A Leader												]--
		elseif ( not IsValid(Leader) ) then
					--[		If Our Leader Is Not valid										]--
			self.Leader = self
					--[		Look For New leader												]--
			for _,v in pairs(ents.FindInSphere(MyPos, self.FindRadius)) do
						--[		If Not Us												]--
				if ( v != self ) then
					if ( v.Follower ) then
					--[		If NPC Is A Leader								]--
						if ( v.Leader == v ) then
					--[		Make Them Our Leader						]--
							self.Leader = v
							--[		Break The Loop								]--
							break
						end
					end
				end
			end
		end
			--[		Move To Group Position												]--
			if Leader.TargetPos then
				self:MoveToPos(Leader.TargetPos)
			end
			--[		Search Again In A Few												]--
			if self.Leader != self then
				if self.Leader and ( IsValid( self.Leader ) and self.Leader:Health() > 0 ) then
					if self.Leader:HaveEnemy() and self.Leader.Enemy then
						if !self:HaveEnemy() then
							self:SetEnemy( self.Leader:GetEnemy() )
							self:BehaveStart()
						end
					end
				end
			end
			
			self.NextSearch = SpawnTime + 5
		end

end

function ENT:RunBehaviour()

	self:OnSpawn()

	while ( true ) do
	
		if self:HaveEnemy() and self:CheckEnemyStatus( self.Enemy ) then
			
			pos = self:GetEnemy():GetPos()

			if ( pos ) then
				
				self:MovementFunction()
					
				local enemy = self:GetEnemy()
				local maxageScaled=math.Clamp(pos:Distance(self:GetPos())/1000,0.1,3)	
				local opts = {	lookahead = 30,
						tolerance = 20,
						draw = false,
						maxage = maxageScaled 
						}
					
				self:ChaseEnemy( opts )
					
			end
			
		else
		
			self:PlayIdleSound()
			self:StartRoaming()
			
		end
		
		coroutine.yield()
	end
	
end