if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_revive_players = GetGlobalBool("nb_revive_players")

local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

ENT.Base = "nb_swat_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
ENT.ChaseDistance = 5000

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 180
ENT.PatrolSpeed = 75
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 800
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.ShootRange = 300
ENT.MeleeRange = 60
ENT.StopRange = 200
ENT.BackupRange = 150

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 5
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_shotgun"
ENT.WeaponSound = "Weapon_Shotgun.Single"

ENT.PistolClass = "wep_nb_pistol"
ENT.PistolSound = "Weapon_Pistol.Single"

--Model--
ENT.WalkAnim = ACT_HL2MP_RUN_SHOTGUN  
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40 
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnim = "range_melee_shove_2hand"

function ENT:Initialize()

	if SERVER then
		self:CustomInitialize()
	
		self.loco:SetDeathDropHeight( self.MaxDropHeight )	
		self.loco:SetAcceleration( self.AccelerationAmount )		
		self.loco:SetDeceleration( self.DecelerationAmount )
		self.loco:SetStepHeight( self.StepHeight )
		self.loco:SetJumpHeight( self.JumpHeight )
	
		self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
	
		self.NEXTBOTFACTION = 'NEXTBOTMERCENARY'
		self.NEXTBOTMERCENARY = true
		self.NEXTBOT = true
		
		--Status
		self.StuckAttempts = 0
		self.TotalTimesStuck = 0
		self.IsJumping = false
		self.ReloadAnimation = false
		self.CanRunReload = true
		self.HitByVehicle = false
		self.FollowingPlayer = false
		self.EntityFollowing = nil
		self.TouchedDoor = false
		self.IsAlerted = false
		self.AlertedEntity = nil
		self.LookingForReload = false
		
		self:MovementFunction()
	end
	
	if CLIENT then
		self.NEXTBOTFACTION = 'NEXTBOTMERCENARY'
		self.NEXTBOTMERCENARY = true
		self.NEXTBOT = true
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel( "" )
		self:SetHealth( self.HealthAmount )
	end
	
end

function ENT:FindEnemy()

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
				if v:Health() < 0 then --Remove dead targets from pool of enemies
					table.remove( enemies, k )
				end
				if (v:IsPlayer() and v:IsBandit()) then
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
	
end

function ENT:HaveEnemy()

	local enemy = self:GetEnemy()

	if ( enemy and IsValid( enemy ) ) then
		if ( enemy:Health() < 0 ) then
			return self:FindEnemy()
		end
		
		if enemy:IsPlayer() and ai_ignoreplayers:GetInt() == 1 then 
			return self:FindEnemy()
		end
		
		if ( self.NextCheckTimer or 0 ) < CurTime() then --Every 4 seconds, find new and best target
			self:FindEnemy()
			if nb_targetmethod:GetInt() == 1 then
				self.LastEnemy = enemy
				timer.Simple(math.random(0.1,0.5),function()
					if IsValid( self ) and self:Health() > 0 then
						if !self.Enemy and self.LastEnemy then
							if IsValid( self.LastEnemy ) and self.LastEnemy:Health() > 0 then
								self:SetEnemy( self.LastEnemy )
							else
								self.LastEnemy = nil
							end
						end
					end
				end)
			end
			self.NextCheckTimer = CurTime() + 4
		end
		
		return true
		
	else
		return self:FindEnemy()
	end
end

function ENT:LookForRevive()

	if ( self.NextLookTimer or 0 ) < CurTime() then

		if !self.GoingToRevive then
	
			local allies
	
			allies = table.Add( ents.FindByClass("nb_soldier*") )
			
			for k,v in pairs( allies ) do
			
				if v != self then
			
					if !self.Reloading and !self.ReloadAnimation then
			
						if v:WOSGetIncapped() then
						
							if v == self.FollowingEntity then return end
							if v == self.RevivingEntity then return end
							if ( v:IsPlayer() and self:IsPlayerZombie( v ) ) then return end
						
							if self:GetRangeSquaredTo( v ) < 500*500 and self:Visible( v ) then
								
								self:PlayGestureSequence( "gesture_signal_halt" )
							
								self.GoingToRevive = true
								self.RevivingEntity = v
								self:BehaveStart()
							end
							
						end
			
					end
			
				end
			
			end
	
			self.NextLookTimer = CurTime() + math.random(5,8)
		
		end
	end

end

function ENT:CustomOnThink()

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
				dmginfo:ScaleDamage(4)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end
			
			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				dmginfo:ScaleDamage(0.5)
				self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
			end
	end

	if !self.Downed and !self.GettingUp then
		self:Flinch( dmginfo, hitgroup )
		self:CheckEnemyPosition( dmginfo )
	else
		dmginfo:ScaleDamage( 0.5 )
	end
	
	if nb_allow_reviving:GetInt() == 1 then
		self:CheckIfDowned( dmginfo )
	end

	self:PlayPainSound()
	
end