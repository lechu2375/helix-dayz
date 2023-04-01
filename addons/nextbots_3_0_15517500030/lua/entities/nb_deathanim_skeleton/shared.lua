AddCSLuaFile()

ENT.Base             = "nb_deathanim_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")

ENT.WeaponClass = ""
ENT.WeaponModel = ""

function ENT:Precache()
end

function ENT:Initialize()

	if SERVER then
	
		self:SetHealth(999999)
		self:SetModel(self.Model)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

		self.BASENEXTBOT = true
	end

	if CLIENT then
		self.BASENEXTBOT = true
	end
	
end

function ENT:RunBehaviour()
	while ( true ) do	
	
		if SERVER then

			self:PlaySequenceAndWait( "death_04", 1 )
			
			local zombie = ents.Create("nb_fakebody_skeleton")
				if not ( self:IsValid() ) then return end
				if zombie:IsValid() then 
				
					local effectdata = EffectData()
						effectdata:SetStart( self:GetPos() + ( self:GetForward() * 80 ) )
						effectdata:SetOrigin( self:GetPos() + ( self:GetForward() * 80 ) )
						effectdata:SetScale( 100 )
						util.Effect( "ThumperDust", effectdata )
				
					zombie:SetPos(self:GetPos() + ( self:GetForward() * 80 ))
					zombie:SetModel(self:GetModel())
					zombie:SetAngles(self:GetAngles())
					zombie:Spawn()
					zombie:SetModelScale(self:GetModelScale(), 0)
					zombie:SetSkin(self:GetSkin())
					zombie:SetColor(self:GetColor())
					zombie:SetMaterial(self:GetMaterial())
					
					zombie:SetBodygroup( 1, self:GetBodygroup(1) )
					zombie:SetBodygroup( 2, self:GetBodygroup(2) )
					zombie:SetBodygroup( 3, self:GetBodygroup(3) )
					zombie:SetBodygroup( 4, self:GetBodygroup(4) )
					zombie:SetBodygroup( 5, self:GetBodygroup(5) )
					zombie:SetBodygroup( 6, self:GetBodygroup(6) )
					zombie:SetBodygroup( 7, self:GetBodygroup(7) )
					zombie:SetBodygroup( 8, self:GetBodygroup(8) )
					zombie:SetBodygroup( 9, self:GetBodygroup(9) )
					
					if self.EquipWeapons then
						zombie.EquipWeapons = true
					end
					
					if self.SpawnNpc then
						zombie.SpawnNpc = self.SpawnNpc
					end
					
					SafeRemoveEntity( self )
				end
			
			coroutine.wait( 0.01 )
			
		end
		
	end
end	

function ENT:OnInjured( dmginfo )
	dmginfo:ScaleDamage(0)
	dmginfo:SetDamage(0)
end