AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_boss_corpse", "Corpse")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_boss_corpse", 	
{	Name = "Corpse", 
	Class = "nb_boss_corpse",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 11

ENT.HeadShotMultipler = 1.2
ENT.HealthAmount = 5000

ENT.Speed = 230
ENT.SprintingSpeed = 65
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 500
ENT.DecelerationAmount = 200

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2.3

ENT.ShootRange = 75
ENT.MeleeRange = 70
ENT.StopRange = 40

ENT.MeleeDamage = 80
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.WeaponClass = "ent_melee_weapon"
ENT.WeaponModel = "models/props_vehicles/carparts_muffler01a.mdl"

ENT.Model = "models/player/corpse1.mdl"

ENT.WalkAnim = ACT_HL2MP_RUN_CHARGING
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

--Sounds--
ENT.AttackSounds = {"nextbots/corpse/attack1.wav", 
"nextbots/corpse/attack2.wav",
"nextbots/corpse/attack3.wav",
"nextbots/corpse/attack4.wav"}
ENT.AttackSoundPitch = math.random(70,90)

ENT.PainSounds = { "nextbots/corpse/pain1.wav", 
"nextbots/corpse/pain2.wav",
"nextbots/corpse/pain3.wav",
"nextbots/corpse/pain4.wav"}
ENT.PainSoundPitch = math.random(70,90)

ENT.AlertSounds = { "nextbots/corpse/alert1.wav",
"nextbots/corpse/alert2.wav",
"nextbots/corpse/alert3.wav",
"nextbots/corpse/alert4.wav"}
ENT.AlertSoundPitch = math.random(70,90)

ENT.DeathSounds = { "nextbots/corpse/death1.wav",
"nextbots/corpse/death2.wav",
"nextbots/corpse/death3.wav",
"nextbots/corpse/death4.wav"}
ENT.DeathSoundPitch = math.random(70,90)

ENT.IdleSounds = {"nextbots/corpse/alert_no_enemy1.wav",
"nextbots/corpse/alert_no_enemy2.wav",
"nextbots/corpse/flinch1.wav",
"nextbots/corpse/flinch2.wav",
"nextbots/corpse/flinch3.wav"}
ENT.IdleSoundPitch = math.random(70,90)

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")

ENT.HitSounds = {"nextbots/corpse/hit1.wav",
"nextbots/corpse/hit2.wav",
"nextbots/corpse/hit3.wav"}

ENT.MissSounds = {"nextbots/corpse/swing1.wav",
"nextbots/corpse/swing2.wav"}

function ENT:CustomInitialize()

	if !self.Risen then
		self:SetModel(self.Model)
		self:SetHealth( self.HealthAmount )
	end
	
	self:SetModelScale(1.5, 0)
	
	if SERVER then
		self:EquipWeapon()
		self:EquipShield()
	end
	
end

function ENT:EquipWeapon()

	local club = ents.Create( self.WeaponClass )
	club:SetOwner(self)
    club:SetPos( self:GetPos())
    club:SetParent(self)
	club:SetModelScale(1.4, 0)
    club:Spawn()
    club:Fire("setparentattachment", "Anim_Attachment_RH")
	club:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	club:SetModel( self.WeaponModel )
	self.ClubModel = club
	
end

function ENT:EquipShield()

	local shield = ents.Create("ent_shield")
	shield:SetPos( self:GetPos() + Vector(0,0,70))
    shield:SetParent(self)
	shield:SetModelScale(1.3, 0)
    shield:Spawn()
    shield:Fire("setparentattachment", "Anim_Attachment_LH")
	shield:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.ShieldModel = shield
	
end

function ENT:BodyUpdate()

	if self.loco:GetVelocity():Length() < 0.5 then
		self:SetPoseParameter("move_x", 0.2 )
		
		if self.ClubModel and IsValid( self.ClubModel ) then
			self.ClubModel:Fire("setparentattachment", "Anim_Attachment_RH")
		end
		
		if self.ShieldModel and IsValid( self.ShieldModel ) then
			self.ShieldModel:Fire("setparentattachment", "Anim_Attachment_LH")
		end
		
	else

		if self.IsAttacking then
	
			self:SetPoseParameter("move_x", 0.7 )
			self:SetPlaybackRate( 1 )
	
		else
	
			self:SetPoseParameter("move_x", 0.9 )
			
	
		end

	end
	
	--self:BodyMoveXY()
	self:SetPlaybackRate( 0.5 )
	
	self:FrameAdvance()
	
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		--if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		
		local phys = ent:GetPhysicsObject()
		if (phys != nil && phys != NULL && phys:IsValid() ) then
			local knockback = ent:GetVelocity():Length() * 2000
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*(knockback) + Vector(0, 0, 2))
		end
		
		if ( self.NextDamageTimer or 0 ) < CurTime() then
	
			local veh = ent:GetPhysicsObject()
			local dmg = math.Round( (ent:GetVelocity():Length() / 3 + ( veh:GetMass() / 50 ) ), 0 )
		
			if ent:GetOwner():IsValid() then
				self:TakeDamage( dmg, ent:GetOwner() )
			else
				self:TakeDamage( dmg, ent )
			end
		
			self.NextDamageTimer = CurTime() + 1
		end
		
	end
	
	if ent != self.Enemy then
		if ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) or ( ent.NEXTBOT and !ent.NEXTBOTZOMBIE ) then
			if ( self.NextMeleeTimer or 0 ) < CurTime() then
				self:Melee( ent, 0, 1 )
				self:SetEnemy( ent )
				self:BehaveStart()
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
		end
	end
	
	self:CustomOnContact2( ent )
	
end

function ENT:AttackDoor( ent )
end

function ENT:ContactDoor( ent )

	local door = ents.Create("prop_physics")
		if door then
			door:SetModel(ent:GetModel())
			door:SetPos(ent:GetPos())
			door:SetAngles(ent:GetAngles())
			door:Spawn()
			door.FalseProp = true
			door:EmitSound("Wood_Plank.Break")

			local phys = door:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
			end

			door:SetSkin(ent:GetSkin())
			door:SetColor(ent:GetColor())
			door:SetMaterial(ent:GetMaterial())

			SafeRemoveEntity( ent )
		
		end

end

function ENT:Melee( ent, type, attacktype )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = ent

	self:PlayAttackSound()
	
	local attacktype = math.random(1,4)
	
		if attacktype == 1 then
			self:PlayGestureSequence( "aoc_spearshield_slash_02_mod" )
			self.loco:SetDesiredSpeed( self.Speed / 2 )
			self:HitTimer( ent, type, 0.5 )
		elseif attacktype == 2 then
			self:PlayGestureSequence( "aoc_spikedmace_slash_02_mod" )
			self.loco:SetDesiredSpeed( self.Speed / 2 )
			self:HitTimer( ent, type, 0.7 )
		elseif attacktype == 3 then
			self:PlayGestureSequence( "aoc_spikedmace_slash_01_mod" )
			self.loco:SetDesiredSpeed( self.Speed / 2 )
			self:HitTimer( ent, type, 0.6 )
		elseif attacktype == 4 then
			self:PlayGestureSequence( "aoc_sword_slash_01_mod" )
			self.loco:SetDesiredSpeed( self.Speed / 2 )
			self:HitTimer( ent, type, 0.7 )
		end
		
end

function ENT:HitTimer( ent, type, time )

	timer.Simple( time, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			local misssound = table.Random( self.MissSounds )
		
			self:EmitSound( Sound( misssound ) )
		
			if self.Flinching then return end
			if self:GetRangeTo( ent ) > self.MeleeRange then return end
		
			local hitsound = table.Random( self.HitSounds )
		
			if ent:IsPlayer() then
			
				local moveAdd=Vector(0,0,50)
				if !ent:IsOnGround() then
					moveAdd=Vector(0,0,0)
				end
				
				ent:SetVelocity( moveAdd + ( ( ent:GetPos() - self:GetPos() ):GetNormal() * 500 ) )
			
					if ( ent:GetActiveWeapon().CanBlock ) then
						if ( ent:GetActiveWeapon():GetStatus( TFA.GetStatus("blocking") ) ) == 21 then
							--blocksound
						else
							ent:EmitSound( Sound( hitsound ) )
						end
					else
						if ( ent:GetNetworkedBool("Block") ) then
							--blocksound
						else
							ent:EmitSound( Sound( hitsound ) )
						end
					end
			else
				
					if ent.NEXTBOT then
						if !ent.Blocking then
							ent:EmitSound( Sound( hitsound ) )
						end
					end
					
			end

			self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
	
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
				ent:EmitSound( self.PropHitSound )
			end
	
		end
	end)

	timer.Simple( time + 0.4, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
			self.loco:SetDesiredSpeed( self.Speed )
		end
	end)

end

function ENT:HandleStuck()

	self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
	
	self.StuckAttempts = self.StuckAttempts + 1
	if self.StuckAttempts == 100 then
		self.loco:ClearStuck()
		self.StuckAttempts = 0
	end

end

function ENT:ChaseEnemy( options )

	local enemy = self:GetEnemy()
	local pos = enemy:GetPos()
	
	local options = options or {}
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 30 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if (!path:IsValid() ) then return "failed" end
	
	if !enemy then return "failed" end
	
	if !enemy:IsValid() then return "failed" end
	
	if enemy:Health() < 0 then return "failed" end
	
	if self:IsPlayerZombie( enemy ) then return "failed" end
	
	while ( path:IsValid() and self:HaveEnemy() and ( enemy:IsValid() and enemy:Health() > 0) ) do

		--if ( self:GetRangeTo( enemy ) < self.StopRange ) and !self.IsJumping then 
			--return "ok"
		--end
	
		if !self:CheckDoor() then
		
		elseif ( self:CheckDoor():IsValid() and self:GetRangeTo( self:CheckDoor() ) < self.StopRange and self:IsLineOfSightClear( self:CheckDoor() ) ) then
			self:ContactDoor( self:CheckDoor() )
			return "ok"
		end
	
		if ( !self.Reloading and !self.loco:IsStuck() and ( enemy and enemy:IsValid() and enemy:Health() > 0) ) then
			if ( path:GetAge() > options.maxage ) then	
				path:Compute( self, enemy:GetPos() )
			end
		end
		
		path:Update( self )	
		
		if ( options.draw ) then
			path:Draw()
		end
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck( 0 )
			return "stuck"
		end
		
		coroutine.yield()
	end
	
	return "ok"
end

function ENT:OnKilled( dmginfo )
	self:DeathAnimation( "nb_deathanim_corpse", self:GetPos(), self.WalkAnim, self:GetModelScale(), 1 )
	
	SafeRemoveEntity( self.ShieldModel )
	SafeRemoveEntity( self.ClubModel )
	
	self:PlayDeathSound()
end