AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_boss_gargantuan", "Gargantuan")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_boss_gargantuan", 	
{	Name = "Gargantuan", 
	Class = "nb_boss_gargantuan",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 86
ENT.CollisionSide = 15

ENT.HeadShotMultipler = 1.5
ENT.HealthAmount = 5000

ENT.Speed = 75
ENT.SprintingSpeed = 65
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 250
ENT.MeleeRange = 90
ENT.StopRange = 70

ENT.MeleeDamage = 100
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Model = "models/zombie/poison.mdl"

ENT.WalkAnim = ACT_WALK
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_ZOMBIE_01 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.IdleAnim = ACT_IDLE

ENT.MeleeAnim = "melee_01"
ENT.ThrowAnim = "throw"

ENT.FlinchAnim1 = "FlinchC"
ENT.FlinchAnim2 = "FlinchL"
ENT.FlinchAnim3 = "FlinchR"

--Sounds--
ENT.AttackSounds = {"npc/zombie_poison/pz_warn1.wav", 
"npc/zombie_poison/pz_warn2.wav"}
ENT.AttackSoundPitch = math.random(60,70)

ENT.PainSounds = { "npc/zombie_poison/pz_pain1.wav", 
"npc/zombie_poison/pz_pain2.wav",
"npc/zombie_poison/pz_pain3.wav"}
ENT.PainSoundPitch = math.random(50,50)

ENT.AlertSounds = { "npc/zombie_poison/pz_alert1.wav",
"npc/zombie_poison/pz_alert2.wav"}
ENT.AlertSoundPitch = math.random(50,50)

ENT.DeathSounds = { "npc/zombie_poison/pz_die1.wav",
"npc/zombie_poison/pz_die2.wav"}
ENT.DeathSoundPitch = math.random(50,50)

ENT.IdleSounds = { "npc/zombie_poison/pz_idle2.wav",
"npc/zombie_poison/pz_idle3.wav",
"npc/zombie_poison/pz_idle4.wav"}
ENT.IdleSoundPitch = math.random(50,50)

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"npc/zombie/claw_strike1.wav"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.loco:SetMaxYawRate( 300 )

	if !self.Risen then
		self:SetModel(self.Model)
		self:SetModelScale( 2.2, 0 )
		self:SetHealth( self.HealthAmount )
	end

	self:SetMaterial("models/Zombie_Poison2/PoisonZombie_sheet")
	
	local bones = {
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32"
}

	for _, bone in pairs(bones) do
		local boneid = self:LookupBone(bone)
		if boneid and boneid > 0 then
			self:ManipulateBoneScale(boneid, Vector(2,2,2))
		end
	end
	
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

function ENT:MovementFunction()

	if !self.Enemy then
		
		self:StartActivity( self.IdleAnim )
		self.loco:SetDesiredSpeed( 0 )
		
	else
	
		if ( self.Enemy and IsValid(self.Enemy) and self.Enemy:Health() < 0 and !self.IsAttacking ) then
	
			self:StartActivity( self.IdleAnim )
			self.loco:SetDesiredSpeed( 0 )
	
		else
	
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )

		end
		
	end

end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self:PlayGestureSequence( self.MeleeAnim )
	self.loco:SetDesiredSpeed(0)
	self:PlayAttackSound()
	
	timer.Simple( 0.8, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			local misssound = table.Random( self.MissSounds )
			self:EmitSound( Sound( misssound ), 90, self.MissSoundPitch or 100 )
		
			if self.Flinching then return end
			if self:GetRangeTo( ent ) > self.MeleeRange then return end
		
			if ent:IsPlayer() then
			
				local moveAdd=Vector(0,0,50)
				if !ent:IsOnGround() then
					moveAdd=Vector(0,0,0)
				end
				
				ent:SetVelocity( moveAdd + ( ( ent:GetPos() - self:GetPos() ):GetNormal() * 1000 ) )
			
			end
		
			self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
	
			if type == nil then
				local hitsound = table.Random( self.HitSounds )
				ent:EmitSound( Sound( hitsound ), 90, self.HitSoundPitch or 100 )
			else
				ent:EmitSound( self.PropHitSound )
			end
	
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 10000 ) ) + Vector(0, 0, 2))
				end
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 5
			end
	
		end
	end)
	
	timer.Simple( 1.3, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:MovementFunction()
			self.IsAttacking = false
		end
	end)
	
end

function ENT:Flesh( amount, velocity, angle, pos )
	
	if !self:IsValid() then return end
	
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))	
	
	for i=1,amount do
	
		local flesh = ents.Create("nb_projectile_base") 
		
		if flesh:IsValid() then
			flesh:SetPos( pos )
			flesh:SetOwner( self )
			flesh:Spawn()
	
			local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-angle, angle))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-angle, angle))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( velocity, velocity + math.random(200,300) ) )
			end	
			
		end	
		
	end
		
end

function ENT:TossFlesh( ent )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = nil
	self.loco:SetMaxYawRate( 0 )
	
	self:PlayGestureSequence( self.ThrowAnim )
	self.loco:SetDesiredSpeed(0)
	self:PlayAttackSound()
		
	timer.Simple(1.2, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:Flesh( 30, 1200, 30, self:GetPos() + Vector(0,0,80) + ( self:GetRight() * 20 ) )
			self.loco:SetDesiredSpeed(0)
		end
	end)
	
	timer.Simple(2.5, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.loco:SetMaxYawRate( 300 )
			self:MovementFunction()
			self.IsAttacking = false
		end
	end)
	
end

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() and self:CheckEnemyStatus( self.Enemy ) then
		
		if self.Enemy:IsPlayer() then
		
			if ( ( self:GetRangeTo( self.Enemy ) < self.ShootRange and self:GetRangeTo( self.Enemy ) > self.MeleeRange + 1 ) and self:IsLineOfSightClear( self.Enemy ) ) then

				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:TossFlesh( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay + 1
				end

			end
		
			if ( self:GetRangeTo( self.Enemy ) < self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then
		
				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:Melee( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end
		
			end
			
		elseif self.Enemy.NEXTBOT then
		
			if ( self:GetRangeTo( self.Enemy ) < self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then
		
				if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
					self:Melee( self.Enemy )
					self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
				end
		
			end
		
		end
			
		if self.IsAttacking then
			if self.FacingTowards then
				if self.FacingTowards:IsValid() and self.FacingTowards:Health() > 0 then
					self.loco:FaceTowards( self.FacingTowards:GetPos() )
				end
			end
		end
			
	end
	
end

function ENT:EmitFlesh( amount, velocity, angle, pos )

	if ( self.NextFlesh or 0 ) < CurTime() then	

		self:Flesh( amount, velocity, angle, pos )

		self.NextFlesh = CurTime() + 4
	end
		
end

function ENT:HardFlinch( dmginfo, hitgroup )
	
	if ( self.NextFlinchTimer or 0 ) < CurTime() then
	
		local anim = math.random(1,3)
	
		if anim == 1 then
			self:PlayFlinchSequence( self.FlinchAnim1, 1, 0, 0, 0.6 )
		elseif anim == 2 then
			self:PlayFlinchSequence( self.FlinchAnim2, 1, 0, 0, 0.6 )
		elseif anim == 3 then
			self:PlayFlinchSequence( self.FlinchAnim3, 1, 0, 0, 0.6 )
		end
		
		self.NextFlinchTimer = CurTime() + 2	
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
				dmginfo:ScaleDamage( self.HeadShotMultipler or 8)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end

	end

	if !self.Flinching then
		if dmginfo:GetDamage() > 100 then
			self:HardFlinch( dmginfo, hitgroup )
		end
	end
	
	self:EmitFlesh( math.random(5,7), math.random(150,200), 105, self:GetPos() + Vector(0,0,80) )
	
	self:PlayPainSound()
	
	self:CheckEnemyPosition( dmginfo )
	
end

function ENT:OnKilled( dmginfo )

	self:EmitFlesh( math.random(5,7), math.random(150,200), 105, self:GetPos() + Vector(0,0,80) )
	self:BecomeRagdoll( dmginfo )
	self:PlayDeathSound()
	hook.Run( "OnNPCKilled",self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
end