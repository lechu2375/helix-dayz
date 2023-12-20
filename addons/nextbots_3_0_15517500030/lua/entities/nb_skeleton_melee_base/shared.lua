if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

ENT.Base = "nb_zombie_base"
ENT.Spawnable = false
ENT.AdminSpawnable = false

--Stats--
ENT.ChaseDistance = 2000

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 50

ENT.Speed = 50
ENT.SprintingSpeed = 50
ENT.FlinchWalkSpeed = 25
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 200
ENT.DecelerationAmount = 900

ENT.JumpHeight = 58
ENT.StepHeight = 35
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 80
ENT.MeleeRange = 40
ENT.StopRange = 20

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

ENT.HitSound = "Flesh.ImpactHard"

--Model--
ENT.WalkAnim = ACT_HL2MP_WALK_ZOMBIE_01
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

function ENT:Initialize()

	if SERVER then
		--Make sure the model is SET before calling CollisionSetup() or else, nextbots will get stuck on eachother
		self:CustomInitialize()
	
		self.loco:SetDeathDropHeight( self.MaxDropHeight )	
		self.loco:SetAcceleration( self.AccelerationAmount )		
		self.loco:SetDeceleration( self.DecelerationAmount )
		self.loco:SetStepHeight( self.StepHeight )
		self.loco:SetJumpHeight( self.JumpHeight )

		self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
		
		self.NEXTBOTFACTION = 'NEXTBOTSKELETON'
		self.NEXTBOTSKELETON = true
		self.NEXTBOT = true
		
		--Status
		self.NextCheckTimer = CurTime() + 4
		self.StuckAttempts = 0
		self.TotalTimesStuck = 0
		self.IsJumping = false
		self.IsAttacking = false
		self.FacingTowards = nil
		self.HitByVehicle = false
		self.IsAlerted = false
		self.AlertedEntity = nil
		
		self:MovementFunction()
	end
	
	if CLIENT then
		self.NEXTBOTFACTION = 'NEXTBOTSKELETON'
		self.NEXTBOTSKELETON = true
		self.NEXTBOT = true
	end
	
end

function ENT:FindEnemy()

	if ( self.NextLookForTimer or 0 ) < CurTime() then

		local enemies
			
		if ai_ignoreplayers:GetInt() == 1 then
			enemies = table.Add( ents.FindByClass("nb_*") )
		else
			enemies = table.Add( player.GetAll(), ents.FindByClass("nb_*") )
		end

		if #enemies > 0 then
			for i=1,table.Count( enemies ) do -- Goal is to reduce amount of values to be sorted through in the table for better performance
				for k,v in pairs( enemies ) do
					if v.BASENEXTBOT then --Remove base nextbot entities (eg. nb_deathanim_base)
						table.remove( enemies, k )
					end
					if ( self.NEXTBOTFACTION == v.NEXTBOTFACTION ) then --Remove same faction from pool of enemies
						table.remove( enemies, k )
					end
					if !IsValid( v ) then --Remove unvalid targets from pool of enemies
						table.remove( enemies, k )
					end
					if v:Health() < 0 then
						table.remove( enemies, k )
					end
					if ai_ignoreplayers:GetInt() == 0 then --Remove players from pool of enemies if ignore players is true
						if v:IsPlayer() then
							if !v:Alive() then --Remove dead players from pool of enemies
								table.remove( enemies, k )
							end
						end
					end
				end
			end
				
			table.sort( enemies, 
			function( a,b ) 
				return self:GetRangeSquaredTo( a ) < self:GetRangeSquaredTo( b ) --Sort in order of closeness from pool of enemies
			end )

			self:SearchForEnemy( enemies )
			--PrintTable( enemies )
		end

		self.NextLookForTimer = CurTime() + ( self.EnemyCheckTime or math.random(1,3) )
	end
	
end

function ENT:OnInjured( dmginfo )

	if self:CheckFriendlyFire( dmginfo:GetAttacker() ) then 
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
				dmginfo:ScaleDamage( self.HeadShotMultipler or 8 )
				self:EmitSound(table.Random(self.HeadShotSounds), self.HeadShotPitch)
			end
			
	end
	
	self:Flinch( dmginfo, hitgroup )
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
end