
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Radioactive Barell"
ENT.Category = "IX"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = false
ENT.bNoPersist = true

ENT.MaxRenderDistance = math.pow(256, 2)



//ix.area.Create(name, type, startPosition, endPosition, bNoReplicate, properties)
if (SERVER) then
	local startPosition = Vector( 300, 300, 300 )
	local endPosition = Vector( 300, 300, 40 ) //size of box
	local SafetyYellow = Color(238, 210, 2)
	function ENT:Initialize()
		self:SetModel("models/props_borealis/bluebarrel001.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		//self:SetUseType(SIMPLE_USE)
        self.UniqueID =  "gaszone:"..self:GetCreationID()
		self:SetColor(SafetyYellow)
		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
		local pos = self:GetPos()
		ix.area.Create(self.UniqueID, "gas", pos+startPosition, pos-endPosition, false, {color = color_white,display = false})

	end

    function ENT:Think()
        if(self:GetVelocity():LengthSqr()>0) then

			ix.area.Remove(self.UniqueID)
			local pos = self:GetPos()
			ix.area.Create(self.UniqueID, "gas", pos+startPosition, pos-endPosition, false, {color = color_white,display = false})
			//print("updated area")
        end
    
        self:NextThink( CurTime()+1) 
    
        return true -- Apply NextThink call
    end






	function ENT:Use(client)

	end

	function ENT:OnRemove()
		ix.area.Remove(self.UniqueID)
	end
else


	local color_red = Color(100, 20, 20, 255)
	local color_blue = Color(0, 50, 100, 255)
	local color_black = Color(60, 60, 60, 255)

	function ENT:Draw()
		self:DrawModel()

		local position = self:GetPos()

		if (LocalPlayer():GetPos():DistToSqr(position) > self.MaxRenderDistance) then
			return
		end

	end
end