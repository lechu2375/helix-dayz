AddCSLuaFile()

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= "Shield"
ENT.Category 		= ""

ENT.Model = ("models/props_vehicles/carparts_door01a.mdl")

if SERVER then

	function ENT:Initialize()
	 
		self:SetHealth(900)
		self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	 
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
	end
	 
	function ENT:Think()
	end

end

function ENT:OnInjured(dmginfo)
dmginfo:ScaleDamage(0)
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
end
