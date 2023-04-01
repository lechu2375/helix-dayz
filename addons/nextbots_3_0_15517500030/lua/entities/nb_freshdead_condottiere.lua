AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_freshdead_condottiere", "Condottiere")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
--list.Set( "sean_nextbots", "nb_freshdead", 	
--{	Name = "Fresh Dead", 
	--Class = "nb_freshdead",
	--Category = "Zombies"	
--})

ENT.Base = "nb_zombie_base"
ENT.Type = "nextbot"
ENT.Spawnable = false

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 7

ENT.HealthAmount = 1000

ENT.Speed = 125
ENT.SprintingSpeed = 125
ENT.FlinchWalkSpeed = 30
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 600
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 100
ENT.MeleeRange = 70
ENT.StopRange = 20

ENT.MeleeDamage = 50
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Models = {"models/arachnit/csgoheavyphoenix/tm_phoenix_heavyplayer.mdl"}

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
ENT.PainSoundPitch = math.random(75,85)

ENT.AlertSounds = { "nextbots/corpse/alert1.wav",
"nextbots/corpse/alert2.wav",
"nextbots/corpse/alert3.wav",
"nextbots/corpse/alert4.wav"}
ENT.AlertSoundPitch = math.random(75,85)

ENT.DeathSounds = { "nextbots/corpse/death1.wav",
"nextbots/corpse/death2.wav",
"nextbots/corpse/death3.wav",
"nextbots/corpse/death4.wav"}
ENT.DeathSoundPitch = math.random(75,85)

ENT.IdleSounds = {"nextbots/corpse/alert_no_enemy1.wav",
"nextbots/corpse/alert_no_enemy2.wav",
"nextbots/corpse/flinch1.wav",
"nextbots/corpse/flinch2.wav",
"nextbots/corpse/flinch3.wav"}
ENT.IdleSoundPitch = math.random(75,85)

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"Flesh.ImpactHard"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	if SERVER then

		self:SetHealth( self.HealthAmount )
		self:SetModelScale( 1.1, 0 )
		
		if self:GetBodygroup( 4 ) == 1 then
			self.HeadArmor = -1
			self.HeadArmorBroken = true
		else
			self.HeadArmor = 75
			self.FrontArmorBroken = false
		end
		
		if self:GetBodygroup( 6 ) == 1 then
			self.FrontArmor = -1
			self.FrontArmorBroken = true
		else
			self.FrontArmor = 125
			self.FrontArmorBroken = false
		end
		
		if self:GetBodygroup( 7 ) == 1 then
			self.BackArmor = -1
			self.BackArmorBroken = true
		else
			self.BackArmor = 125
			self.BackArmorBroken = false
		end
		
		self:MovementFunction()
	
	end
	
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

function ENT:ArmorVisual( pos )

	local effectdata = EffectData()
		effectdata:SetStart( pos ) 
		effectdata:SetOrigin( pos )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )
		
	self:EmitSound("hits/armor_hit.wav")
		
end

function ENT:ArmorEffect( dmginfo, hitgroup )

	if hitgroup == HITGROUP_HEAD then
	
		if !self.HeadArmorBroken then 
			self.HeadArmor = self.HeadArmor - dmginfo:GetDamage()
			self:ArmorVisual( dmginfo:GetDamagePosition() )
		end
		
	end
		
	if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
		
		local attacker = dmginfo:GetAttacker()
		
		if attacker:IsValid() then
				if attacker:IsPlayer() then
				
					local attackerforward = attacker:GetForward()
					local forward = self:GetForward() 
					
					if attackerforward:Distance( forward ) < 1 then
						if !self.BackArmorBroken then 
							self:ArmorVisual( dmginfo:GetDamagePosition() )
							self.BackArmor = self.BackArmor - dmginfo:GetDamage()
						end
					else
						if !self.FrontArmorBroken then 
							self:ArmorVisual( dmginfo:GetDamagePosition() )
							self.FrontArmor = self.FrontArmor - dmginfo:GetDamage()
						end
					end
				
			end
		end
		
	end
	
end

function ENT:SpawnArmor( dmginfo, type )
	
	local ent = ents.Create( "ent_nb_fake_armor" )
	
	if ent:IsValid() and self:IsValid() then	
	
		local model
		local pos 
		
		if type == "head" then
			model = "models/arachnit/csgoheavyphoenix/items/mask.mdl"
			pos = Vector(0,0,10)
		elseif type == "front" then
			model = "models/arachnit/csgoheavyphoenix/items/frontcover.mdl"
			pos = Vector(0,0,5)
		elseif type == "back" then
			model = "models/arachnit/csgoheavyphoenix/items/backcover.mdl"
			pos = Vector(0,0,5)
		end
	
		ent:SetModel( model )
		ent:SetPos( self:GetPos() + pos )
		ent:Spawn()
	
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			if type == "back" then
			
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(-(ang:Forward()), math.Rand(-10, 10))
				phys:SetVelocityInstantaneous(-(ang:Forward()) * math.Rand( 200, 200 ))
			
			else
			
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 200, 200 ))
				
			end		
				
		end
		
	end

end

function ENT:BreakArmor( dmginfo, type )

	if SERVER then

		if type == "head" then
			if self.HeadArmorBroken then return end 
			self.HeadArmorBroken = true
			self:SetBodygroup( 4, 1 )
			self:SpawnArmor( dmginfo, "head" )
		end
		
		if type == "front" then
			if self.FrontArmorBroken then return end 
			self.FrontArmorBroken = true
			self:SetBodygroup( 6, 1 )
			self:SpawnArmor( dmginfo, "front" )
		end
		
		if type == "back" then
			if self.BackArmorBroken then return end 
			self.BackArmorBroken = true
			self:SetBodygroup( 7, 1 )
			self:SpawnArmor( dmginfo, "back" )
		end
		
		self:EmitSound( "physics/metal/metal_box_break"..math.random(1,2)..".wav", 70, math.random( 90,95 ) )
	
	end
	
end

function ENT:CheckArmor( dmginfo )

	if !self.HeadArmorBroken then
		if self.HeadArmor < 0 then
			self:BreakArmor( dmginfo, "head" )
		end
	end
	
	if !self.FrontArmorBroken then
		if self.FrontArmor < 0 then
			self:BreakArmor( dmginfo, "front" )
		end
	end
	
	if !self.BackArmorBroken then
		if self.BackArmor < 0 then
			self:BreakArmor( dmginfo, "back" ) 
		end
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
				if self.HeadArmorBroken then
					self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
					dmginfo:ScaleDamage(3)
				else
					dmginfo:ScaleDamage(1)
				end
			end
			
			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				if self.BackArmorBroken and self.FrontArmorBroken then
					dmginfo:ScaleDamage(0.5)
					self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
				else
					dmginfo:ScaleDamage(0.8)
				end
			end
	end

	self:CheckArmor( dmginfo )
	self:ArmorEffect( dmginfo, hitgroup )
	
	self:Flinch( dmginfo, hitgroup )
	self:CheckEnemyPosition( dmginfo )

	self:PlayPainSound()
	
end

function ENT:OnKilled( dmginfo )

	self:DropWeapon()
	self:DeathAnimation( "nb_deathanim_boss", self:GetPos(), self.WalkAnim, self:GetModelScale(), nil, "", 0 )
	
end