AddCSLuaFile()

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

if SERVER then
	function ENT:Initialize()
	 
		self:SetHealth(999999)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
		SafeRemoveEntityDelayed( self, 15 ) 
		
	end
	
end

ENT.nxtPhysicsCollide = 0
function ENT:PhysicsCollide(data, physobj)

	if !self.nxtPhysicsCollide then self.nxtPhysicsCollide = 0 end
    if CurTime() < self.nxtPhysicsCollide then return end

    self.nxtPhysicsCollide = CurTime() + 0.2

	if ( self:IsValid() ) then
		self:EmitSound("helmet/metal_barrel_impact_hard"..math.random(1,7)..".wav", 55)
	end
end

function ENT:Think()
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
end
