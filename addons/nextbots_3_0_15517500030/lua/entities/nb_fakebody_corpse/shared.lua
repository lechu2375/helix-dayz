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
	
		self:EquipWeapon()
		self:EquipShield()
	
		self.BASENEXTBOT = true
	end

	if CLIENT then
		self.BASENEXTBOT = true
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
	shield:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.ShieldModel = shield
	
end

function ENT:RunBehaviour()
	while ( true ) do
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