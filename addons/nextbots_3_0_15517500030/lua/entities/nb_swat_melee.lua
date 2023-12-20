AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_swat_melee", "SWAT Protector")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_swat_melee", 	
{	Name = "SWAT Protector", 
	Class = "nb_swat_melee",
	Category = "SWATs"	
})

ENT.Base = "nb_swat_melee_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 7

ENT.HealthAmount = 200

ENT.Speed = 90
ENT.SprintingSpeed = 90
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 0.4
ENT.MeleeDelay = 2

ENT.ShootRange = 65
ENT.MeleeRange = 55
ENT.StopRange = 60
ENT.BackupRange = 61

ENT.MeleeDamage = 25
ENT.MeleeDamageType = DMG_SLASH
 
ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.WeaponClass = "ent_swat_shield"
ENT.WeaponModel = "models/bf4/bf4_shield.mdl"

--Model--
ENT.Models = {"models/player/gasmask.mdl",
"models/player/riot.mdl",
"models/player/swat.mdl",
"models/player/urban.mdl"}

ENT.WalkAnim = ACT_HL2MP_WALK_DUEL
ENT.SprintingAnim = ACT_HL2MP_RUN_DUEL
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_DUEL 
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_DUEL
ENT.JumpAnim = ACT_HL2MP_JUMP_DUEL

--ENT.MeleeAnim = {"aoc_slash_01","aoc_slash_02","aoc_slash_03","aoc_slash_04","aoc_dagger2_throw"}
ENT.MeleeAnim = "range_melee_shove_2hand"

--Sounds--
ENT.AttackSounds = {"nextbots/swat/attack1.wav", --Melee Sounds
"nextbots/swat/attack2.wav",
"nextbots/swat/attack3.wav",
"nextbots/swat/attack4.wav",
"nextbots/swat/attack5.wav",
"nextbots/swat/attack6.wav",
"nextbots/swat/attack7.wav",
"nextbots/swat/attack8.wav",
"nextbots/swat/attack9.wav"}

ENT.PainSounds = {"nextbots/swat/pain1.wav",
"nextbots/swat/pain2.wav",
"nextbots/swat/pain3.wav",
"nextbots/swat/pain4.wav",
"nextbots/swat/pain5.wav",
"nextbots/swat/pain6.wav"}

ENT.AlertSounds = {"nextbots/swat/alert1.wav",
"nextbots/swat/alert2.wav",
"nextbots/swat/alert3.wav",
"nextbots/swat/alert4.wav",
"nextbots/swat/alert5.wav",
"nextbots/swat/alert6.wav"}

ENT.DeathSounds = {"nextbots/swat/death1.wav",
"nextbots/swat/death2.wav",
"nextbots/swat/death3.wav",
"nextbots/swat/death4.wav",
"nextbots/swat/death5.wav",
"nextbots/swat/death6.wav"}

ENT.IdleSounds = {"nextbots/swat/idle1.wav",
"nextbots/swat/idle2.wav",
"nextbots/swat/idle3.wav",
"nextbots/swat/idle4.wav",
"nextbots/swat/idle5.wav",
"nextbots/swat/idle6.wav",
"nextbots/swat/idle7.wav",
"nextbots/swat/idle8.wav",
"nextbots/swat/idle9.wav",
"nextbots/swat/idle10.wav",
"nextbots/swat/idle11.wav",
"nextbots/swat/idle12.wav"}

function ENT:CustomInitialize()

	local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end
	
	self:SetHealth( self.HealthAmount )

	self.Crouching = false
	self.Strafing = false
	self.Patrolling = true
	self.Blocking = true
	self.EquipAnimation = false
	
	self:MovementFunction()
	
	self:UnEquipWeapon()
	
end

function ENT:UnEquipWeapon()

	local shield = ents.Create( self.WeaponClass )
	
	shield:SetPos( self:GetPos() + Vector(0,0,75) + ( self:GetForward() * 7 ) - ( self:GetRight() * 15 ) )
	shield:SetAngles( Angle( 0, self:EyeAngles().y - 180, self:EyeAngles().r - 180 ) )
	shield:SetParent( self )
	shield:SetOwner( self )
	shield:Fire("SetParentAttachmentMaintainOffset", "chest", 0.01) 
	shield:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	shield:SetModel( self.WeaponModel )
	
	shield:Spawn()
	
	if self.Weapon and IsValid( self.Weapon ) then
		SafeRemoveEntity( self.Weapon )
	end
	
	self.Weapon = shield
	
	self.Blocking = false
	self.EquipAnimation = false
	
end

function ENT:EquipWeapon()

	local shield = ents.Create( self.WeaponClass )
	
	shield:SetPos( self:GetPos() + Vector(0,0,20) + ( self:GetForward() * 3 ) - ( self:GetRight() * 15 ) )
	shield:SetAngles( self:GetForward():Angle() )
	shield:SetParent( self )
	shield:SetOwner( self )
	shield:Fire("SetParentAttachmentMaintainOffset", "eyes", 0.01) 
	shield:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	shield:SetModel( self.WeaponModel )
	
	shield:Spawn()
	
	if self.Weapon and IsValid( self.Weapon ) then
		SafeRemoveEntity( self.Weapon )
	end
	
	self.Weapon = shield
	
	self.Blocking = true
	self.EquipAnimation = false
	
end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end

	self.IsAttacking = true 
	self.FacingTowards = ent	
	
	self:PlayAttackSound()
	
	self:PlayGestureSequence( self.MeleeAnim, 1 )
		
	self.loco:SetDesiredSpeed( 0 )
	
	timer.Simple( 0.3, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:EmitSound( "weapons/slam/throw.wav" )
		end
	end)

	timer.Simple( 0.45, function()
		if ( IsValid(self) and self:Health() > 0) and IsValid(ent) then
		
			if self:GetRangeTo( ent ) > self.MeleeRange then return end

			self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
			
			if ent:Health() > 0 then
				if ent:IsPlayer() then
					if ( ent:GetActiveWeapon().CanBlock ) then
						if ( ent:GetActiveWeapon():GetStatus( TFA.GetStatus("blocking") ) ) == 21 then
							--blocksound
						else
							self:EmitSound( "physics/metal/metal_barrel_impact_hard"..math.random(5,7)..".wav" )
						end
					else
						if ( ent:GetNetworkedBool("Block") ) then
							--blocksound
						else
							self:EmitSound( "physics/metal/metal_barrel_impact_hard"..math.random(5,7)..".wav" )
						end
					end
				else
					if ent.NEXTBOT then
						if !ent.Blocking then
							self:EmitSound( "physics/metal/metal_barrel_impact_hard"..math.random(5,7)..".wav" )
						end
					end
				end
			end
		
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
				--Prop hit sound
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 10
			end
		
		end
	end)
	
	timer.Simple( 0.8, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
			self.loco:SetDesiredSpeed( self.Speed )
		end
	end)
	
end

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() then
		
		if ( self:GetRangeTo( self.Enemy ) < self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then

			if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then

				self:Melee( self.Enemy )
				
				self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
			end

		end
				
		if self.IsAttacking then
			if self.FacingTowards:IsValid() and self.FacingTowards:Health() > 0 then
				self.loco:FaceTowards( self.FacingTowards:GetPos() )
			end
		end
				
	end

end