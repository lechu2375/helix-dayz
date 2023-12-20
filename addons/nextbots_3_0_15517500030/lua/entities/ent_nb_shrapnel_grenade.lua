AddCSLuaFile()

if SERVER then
ENT.Base = "nb_projectile_base"
end

--Kill Feed
if CLIENT then
	language.Add("ent_nb_kb_grenade", "Grenade")
end

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.Category 		= ""

if SERVER then
	function ENT:Initialize()

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
		
function ENT:Explode( ent, power )

	local ents = ents.FindInSphere( self:GetPos(), 80 )
	for _,v in pairs(ents) do
		
		if ( v:IsPlayer() or v.NEXTBOT ) then
		
			if self:GetOwner():IsValid() then
			
				if self:GetOwner().NEXTBOTMERCENARY then
					if !v.NEXTBOTMERCENARY then
						self:DealInitialDamage( v, power )
					end
				elseif self:GetOwner().NEXTBOTZOMBIE then
					if !v.NEXTBOTZOMBIE then
						self:DealInitialDamage( v, power )
					end
				elseif ( self:GetOwner().NEXTBOT and !self:GetOwner().NEXTBOTMERCENARY and !self:GetOwner().NEXTBOTZOMBIE ) then
					if ( ( !v.NEXTBOTMERCENARY and !v.NEXTBOTZOMBIE ) or ( v:IsPlayer() and self:IsPlayerZombie( v ) ) ) then
						self:DealInitialDamage( v, power )	
					end
				end
				
			else
				self:DealInitialDamage( v, power )
			end
			
		end	

	end

end		
	
function ENT:ReleaseShrapnel()

	for i=0,math.random(6,12) do
		local bullet = {}
			bullet.Num = 1
			bullet.Src = self:GetPos() + Vector(0,0,5)
			bullet.Dir = Angle( math.random( -180,180 ), math.random( -180,180 ), math.random( -180,180 ) ):Up()
			bullet.Spread = Vector( math.random(-15,15) * 0.1 , math.random(-15,15) * 0.1, 0)
			bullet.Tracer = 1
			bullet.TracerName = "Tracer"
			bullet.Force = 5
			bullet.Damage = 5
					
		bullet.Callback = function(attacker, tr, dmginfo)
			if IsValid( self:GetOwner() ) then
				dmginfo:SetAttacker( self:GetOwner() )
			else
				dmginfo:SetAttacker( self )
			end
			dmginfo:SetInflictor( self )
			dmginfo:SetDamageType( DMG_BULLET )
		end

		self:FireBullets( bullet )
	end
	
end
	
function ENT:DealInitialDamage( ent, amt )

	local dmg = DamageInfo()
	
	if !IsValid( self:GetOwner() ) then 
		self:SetOwner( self )
	end
				
	dmg:SetAttacker( self:GetOwner() )
	dmg:SetInflictor( self )
	dmg:SetDamage( amt )
	dmg:SetDamageType( DMG_BLAST )
	ent:TakeDamageInfo( dmg )
			
	if ent:IsPlayer() then
		ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
	end
	
	self:ReleaseShrapnel()
	
end
	
function ENT:PhysicsCollide(data, physobj)

	if IsValid( self ) then
		if SERVER then
			local explode = ents.Create("env_explosion")
			explode:SetPos( self:GetPos() )
			explode:Spawn()
			explode:SetKeyValue( "iMagnitude", 0 )
			explode:SetOwner(self:GetOwner())	
			explode:Fire( "Explode", 1, 0 )	
			
			self:Explode( self, math.random( 20, 25 ) )
			
			SafeRemoveEntity( self )
			
			self:ReleaseShrapnel()
		end
	end
	
end	
