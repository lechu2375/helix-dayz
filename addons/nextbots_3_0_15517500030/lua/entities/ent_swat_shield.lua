AddCSLuaFile()
ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= ""
ENT.Category 		= ""

ENT.Model = ("")

if SERVER then
	function ENT:Initialize()
	 
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion( true )
		end
		
	end
end

function ENT:ShieldDamage( dmginfo )

	local wepowner = dmginfo:GetInflictor():GetOwner()
	local attacker = dmginfo:GetAttacker()
	
	if ( wepowner.NEXTBOT ) or ( attacker.NEXTBOT ) or attacker:IsPlayer() then
	
		if dmginfo:GetDamage() > 1 then
	
			self:EmitSound("hits/armor_hit.wav")
			
			local effectdata = EffectData()
			effectdata:SetStart( dmginfo:GetDamagePosition() ) 
			effectdata:SetOrigin( dmginfo:GetDamagePosition() )
			effectdata:SetScale( 1 )
			util.Effect( "StunStickImpact", effectdata )

		end

	end
	
end

function ENT:OnTakeDamage( dmginfo )

	self:ShieldDamage( dmginfo )
	
	dmginfo:ScaleDamage(0)
	
	return dmginfo
end

function ENT:Think()
end
