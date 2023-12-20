if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nb_vehicle_hit_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")

ENT.SpawnNpc = ""
ENT.WeaponClass = ""

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

function ENT:Precache()
end

function ENT:Initialize()

	if SERVER then
			--print(self.SpawnNpc)
			--print(self)
			--print(self.WeaponClass)
		
		if self.health == nil then
			self:SetHealth( 50 )
		else
			self:SetHealth( self.health )	
		end
		
		self:SetModel(self.Model)
		
		if !( self.WeaponClass == "" ) then
			self:EquipWeapon()
		end
		
		self.BASENEXTBOT = true
	end
	
	if CLIENT then
		self.BASENEXTBOT = true
	end
	
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:PhysicsInitShadow(true, false)
end

function ENT:CollisionSetup( collisionside, collisionheight, collisiongroup )
	
end

function ENT:DropWeapon()
	
	if !self.Weapon then return end
	
	local ent = ents.Create( self.WeaponClass )
	
	if ent:IsValid() and self:IsValid() then	
	
		ent:SetModel( self.Weapon:GetModel() )
		ent:SetPos( self:GetPos() + Vector( 0,0,45 ) )
		ent:SetAngles( self.Weapon:GetAngles() )
		ent:Spawn()
	
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-100, 100))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-100, 100))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 200, 200 ))
				
		end
		
	end
	
	SafeRemoveEntity( self.Weapon )

end

function ENT:OnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		self.HitByVehicle = true
		
		local veh = ent:GetPhysicsObject()
		local dmg = math.Round( (ent:GetVelocity():Length() / 3 + ( veh:GetMass() / 50 ) ), 0 )
		
		if ent:GetOwner():IsValid() then
			self:TakeDamage( dmg, ent:GetOwner() )
		end
		
		self:VehicleHit( ent, "nb_rise_base", self.SpawnNpc, self.WeaponClass, ( self:Health() - dmg ), false )
		--damage: speed / 4 + mass / 15
		print( dmg )
		
	end

end

function ENT:EquipWeapon()
	local att = "anim_attachment_RH"
	local shootpos = self:GetAttachment(self:LookupAttachment(att))
		
	local wep = ents.Create( self.WeaponClass )
	if wep:IsValid() then
	wep:SetOwner(self)
	wep:SetPos(shootpos.Pos)
	--wep:SetAngles(ang)
	wep:Spawn()
	wep:SetSolid(SOLID_NONE)
	wep:SetParent(self)
	wep:SetNotSolid(true)
	wep:SetTrigger(false)
	wep:Fire("setparentattachment", "anim_attachment_RH")
	wep:AddEffects(EF_BONEMERGE)
	wep:SetAngles(self:GetForward():Angle())
	wep:SetOwner( self )
		
	self.Weapon = wep
	end
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

function ENT:RunBehaviour()

	while ( true ) do	
	
	if SERVER then

		self:StartActivity( ACT_HL2MP_ZOMBIE_SLUMP_IDLE )
		
		self:PlaySequenceAndWait( "zombie_slump_rise_01", 1 )
		
		local zombie = ents.Create( self.SpawnNpc )
		if zombie:IsValid() and self:IsValid() then
			
			zombie:SetPos( self:GetPos() )
			zombie:SetModel( self:GetModel() )
			zombie:SetAngles( self:GetAngles() )
			zombie.Risen = true 
			zombie:SetHealth( self.health )
			zombie:Spawn()
					
			zombie:SetSkin( self:GetSkin() )
			zombie:SetColor( self:GetColor() )
			zombie:SetMaterial( self:GetMaterial() )
						
			zombie:SetBodygroup( 1, self:GetBodygroup(1) )
			zombie:SetBodygroup( 2, self:GetBodygroup(2) )
			zombie:SetBodygroup( 3, self:GetBodygroup(3) )
			zombie:SetBodygroup( 4, self:GetBodygroup(4) )
			zombie:SetBodygroup( 5, self:GetBodygroup(5) )
			zombie:SetBodygroup( 6, self:GetBodygroup(6) )
			zombie:SetBodygroup( 7, self:GetBodygroup(7) )
			zombie:SetBodygroup( 8, self:GetBodygroup(8) )
			zombie:SetBodygroup( 9, self:GetBodygroup(9) )
		
			SafeRemoveEntity( self )
						
		end

	end
		
	
	coroutine.wait( 0 )
	
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
	self:BecomeRagdoll(dmginfo)
	self:DropWeapon()
	--self:Remove()
end

function ENT:OnInjured( dmginfo )
end