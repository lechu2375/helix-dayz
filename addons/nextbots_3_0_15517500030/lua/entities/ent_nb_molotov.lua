AddCSLuaFile()

if SERVER then
ENT.Base = "nb_projectile_base"
end

--Kill Feed
if CLIENT then
	language.Add("ent_nb_molotov", "Fire")
end

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrintName		= "Grenade"
ENT.Category 		= ""

ENT.Model = "models/weapons/w_grenade.mdl"

if SERVER then
	function ENT:Initialize()
	 
		--if self:GetModel() == nil then
			--self:SetModel( self.Model )
		--end
		
		self:SetHealth( 999999 )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
	end
end

function ENT:OnInjured(dmginfo)
	dmginfo:ScaleDamage(0)
end

function ENT:Explode()
		
	if !self:GetOwner():IsValid() then return end
	if self:Health() < 0 then return end
	
	self.Entity:EmitSound("physics/glass/glass_largesheet_break" ..math.random(1,3).. ".wav", 500, math.random(90,110))
	if self.Entity:WaterLevel() > 0 then return end
	for i=1,12 do
		local pos = self.Entity:GetPos() + Vector(math.random(-88, 88), math.random(-88, 88), 32)
		local explfire = ents.Create("env_fire")
		explfire:SetPos(pos)
		explfire:SetKeyValue("health", i)
		explfire:SetKeyValue("firesize", "8")
		explfire:SetKeyValue("damagescale", "1")
		explfire:SetKeyValue("spawnflags", 128+(math.random(0,1)==0 and 2 or 0))
		explfire:Spawn()
		explfire:Fire("StartFire", "", 0)
		explfire:SetOwner(self.Owner)
	end
	
	local ents = ents.FindInSphere( self:GetPos(), 80 )
	for _,v in pairs(ents) do
		
		if ( v:IsPlayer() or v.NEXTBOT ) then
		
			if self:GetOwner():IsValid() then
			
				if self:GetOwner().NEXTBOTMERCENARY then
					if !v.NEXTBOTMERCENARY then
						self:DealInitialDamage( v, 25 )
					end
				elseif self:GetOwner().NEXTBOTZOMBIE then
					if !v.NEXTBOTZOMBIE then
						self:DealInitialDamage( v, 25 )
					end
				elseif ( self:GetOwner().NEXTBOT and !self:GetOwner().NEXTBOTMERCENARY and !self:GetOwner().NEXTBOTZOMBIE ) then
					if ( ( !v.NEXTBOTMERCENARY and !v.NEXTBOTZOMBIE ) or ( v:IsPlayer() and self:IsPlayerZombie( v ) ) ) then
						self:DealInitialDamage( v, 25 )	
					end
				end
				
			else
				self:DealInitialDamage( v, 25 )
			end
			
		end	

	end
	
end	
		
function ENT:DealInitialDamage( ent, amt )
	local dmg = DamageInfo()
	
	if !self:GetOwner():IsValid() then 
		self:SetOwner( self )
	end
				
	dmg:SetAttacker( self:GetOwner() )
	dmg:SetInflictor( self )
	dmg:SetDamage( amt )
	dmg:SetDamageType( DMG_BLAST )
	ent:TakeDamageInfo( dmg )
	ent:Ignite(3)
			
	if ent:IsPlayer() then
		ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
	end
end
		
function ENT:PhysicsCollide(data, physobj)
	if self:IsValid() then
		if SERVER then
			
		local explode = ents.Create("env_explosion")
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", 0 )
		explode:SetOwner(self:GetOwner())	
		explode:Fire( "Explode", 1, 0 )	
		
		self:Explode()
		
		SafeRemoveEntity( self )
		end
	end
end	
