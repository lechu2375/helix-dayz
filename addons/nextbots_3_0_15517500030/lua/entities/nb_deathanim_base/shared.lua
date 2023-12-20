if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")
ENT.health = 5001

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth( self.health )
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	
	if SERVER then
		self.BASENEXTBOT = true
	end

	if CLIENT then
		self.BASENEXTBOT = true
	end
end

function ENT:EquipWeapon( weapon )
	local att = "anim_attachment_RH"
	local shootpos = self:GetAttachment(self:LookupAttachment(att))
		
	local wep = ents.Create( weapon )
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
	self.BulletsUsed = 0
	self.ClipAmount = self.ClipAmount
	self.Reloading = false
end

function ENT:DropWeapon( pos )
	
	if !self.DroppedWeapon then return end 
	
	local ent = ents.Create( self.DroppedWeapon )
	
	if ent:IsValid() and self:IsValid() then	
	
		ent:SetModel( self.Weapon:GetModel() )
		ent:SetPos( pos )
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

function ENT:DropWeaponDelay( time, pos )
	timer.Simple(time, function()
		if !self:IsValid() then return end
		self:DropWeapon( self:GetPos() + Vector(0,0,pos) )
	end)
end

function ENT:RunBehaviour()
	while ( true ) do	
	
		if SERVER then
	
			local anim = math.random(1,4)
			if anim == 1 then
			
				self:DropWeaponDelay( 0.55, 30 )
				self:PlaySequenceAndWait( "death_03", 1 )
				
			elseif anim == 2 then
			
				self:DropWeaponDelay( 0.8, 40 )
				self:PlaySequenceAndWait( "death_02", 1 )
				
			elseif anim == 3 then
			
				self:DropWeaponDelay( 0.55, 30 )
				self:PlaySequenceAndWait( "death_03", 1 )
				
			elseif anim == 4 then
			
				timer.Simple(1.6, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 85)
				end)
			
				timer.Simple(1, function()
					if !self:IsValid() then return end
					if self:Health() < 0 then return end
					self:EmitSound("hits/body_medium_impact_hard"..math.random(6)..".wav", 67, 90)
				end)
				
				self:DropWeapon( self:GetPos() + Vector( 0,0,50 ) )
				self:PlaySequenceAndWait( "death_04", 1.6 )
				
			end

			local dmginfo = DamageInfo()
				dmginfo:SetDamage(20)
				dmginfo:SetInflictor( self )
				dmginfo:SetAttacker( self )
			self:MorphRagdoll( dmginfo )
			
			coroutine.wait( 0 )
			
		end
		
	end
end	

function ENT:OnRemove()

	if self.Weapon then
		SafeRemoveEntity( self.Weapon )
	end

end

function ENT:OnKilled( dmginfo )

	dmginfo:SetDamage(1)
 
	self:MorphRagdoll( dmginfo )
	
end

function ENT:OnInjured( dmginfo )

	if !dmginfo:GetAttacker() == self and !dmginfo:GetInflictor() == self then
		dmginfo:ScaleDamage(0)
	end
	
end

function ENT:TransformRagdoll( dmginfo )

	if !self:IsValid() then return end
	
	local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			
			local num = ragdoll:GetPhysicsObjectCount()-1
			local v = self.loco:GetVelocity()	
   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
					bone:SetVelocity(v)
				end
	  
			end
			
			ragdoll:SetBodygroup( 1, self:GetBodygroup(1) )
			ragdoll:SetBodygroup( 2, self:GetBodygroup(2) )
			ragdoll:SetBodygroup( 3, self:GetBodygroup(3) )
			ragdoll:SetBodygroup( 4, self:GetBodygroup(4) )
			ragdoll:SetBodygroup( 5, self:GetBodygroup(5) )
			ragdoll:SetBodygroup( 6, self:GetBodygroup(6) )
			ragdoll:SetBodygroup( 7, self:GetBodygroup(7) )
			ragdoll:SetBodygroup( 8, self:GetBodygroup(8) )
			ragdoll:SetBodygroup( 9, self:GetBodygroup(9) )
			
			ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
		end
	
	SafeRemoveEntity( self )
	
end

function ENT:MorphRagdoll( dmginfo )

	if GetGlobalBool( "nb_use_ragdolls" ) then
		self:TransformRagdoll( dmginfo )
	else
		self:BecomeRagdoll( dmginfo )
	end
	
end

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
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