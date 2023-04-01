AddCSLuaFile()

ENT.Spawnable        = false
ENT.AdminSpawnable   = false

ENT.BASENEXTBOT = true

ENT.Type = "anim"
ENT.Model = "models/props_junk/popcan01a.mdl"

function ENT:Initialize()
	
	if SERVER then
	
		self:SetModel( self.Model )
		self:DrawShadow(false)
		self:SetNotSolid(true)
		self:SetNoDraw(true)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		
		self:SpawnEntities()
		
		self.BASENEXTBOT = true
		self.NEXTBOT = false
	end

	if CLIENT then
		self.BASENEXTBOT = true
		self.NEXTBOT = false
	end
	
end

function ENT:SpawnEntities()

	if self.NEXTBOTLIST then

		local nextbot = table.Random( self.NEXTBOTLIST )
		
		if nextbot then
		
			self.CURRENTNEXTBOT = ents.Create( nextbot )
			self.CURRENTNEXTBOT:SetPos( self:GetPos() + Vector(0,0,5) )
			self.CURRENTNEXTBOT:SetAngles( self:GetAngles() )
			self.CURRENTNEXTBOT:Spawn()
			self.CURRENTNEXTBOT:Activate()

		end
	
	end
	
end

function ENT:Think()

	if SERVER then

		if self.NEXTBOTLIST then
	
			if !IsValid( self.CURRENTNEXTBOT ) then
			
				local nextbot = table.Random( self.NEXTBOTLIST )
				
				if nextbot then
			
					self.CURRENTNEXTBOT = ents.Create( nextbot )
					self.CURRENTNEXTBOT:SetPos( self:GetPos() + Vector(0,0,5) )
					self.CURRENTNEXTBOT:SetAngles( self:GetAngles() )
					self.CURRENTNEXTBOT:Spawn()
					self.CURRENTNEXTBOT:Activate()

				end
				
				self:NextThink( CurTime() + 0.5 )
			end
	
		end
	
	end
	
end

function ENT:OnRemove()

	if self.CURRENTNEXTBOT then 
	
		SafeRemoveEntity( self.CURRENTNEXTBOT )
		
	end
	
end