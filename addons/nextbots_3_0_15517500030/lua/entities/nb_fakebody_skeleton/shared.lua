AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
--Model Settings--
ENT.Model = ("")

ENT.WeaponClass = "ent_melee_weapon"
ENT.WeaponModel = "models/props_vehicles/carparts_muffler01a.mdl"

function ENT:Precache()
end

function ENT:Initialize()

	if SERVER then
	
		self:SetHealth(99999999999)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)

		self.BASENEXTBOT = true
	end

	if CLIENT then
		self.BASENEXTBOT = true
	end
	
end

function ENT:RunBehaviour()
	while ( true ) do

		timer.Simple( math.random(36,128), function()
			if IsValid( self ) then

				self:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
			
				local effectdata = EffectData()
					effectdata:SetStart( self:GetPos() ) 
					effectdata:SetOrigin( self:GetPos() )
					effectdata:SetScale( 1 )
				util.Effect( "effect_nb_skeleton_cloud", effectdata )
			
				SafeRemoveEntity(self)
				
			end
		end)
	
		self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)
		coroutine.wait( 99999999999 )
		self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)

	end
end	

function ENT:OnInjured( dmginfo )
	dmginfo:ScaleDamage(0)
	dmginfo:SetDamage(0)
end

function ENT:BehaveAct()
end

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:GetEnemy()
end

function ENT:OnStuck()
end

function ENT:OnUnStuck()
end

function ENT:SetEnemy()
end

function ENT:GetDoor()
end

function ENT:MoveToPos( pos, options )
end
	
function ENT:AttackProp()
end

function ENT:UpdateEnemy()
end

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
end