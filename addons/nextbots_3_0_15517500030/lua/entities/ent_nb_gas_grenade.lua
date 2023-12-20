AddCSLuaFile()

if SERVER then
ENT.Base = "nb_projectile_base"
end

--Kill Feed
if CLIENT then
	language.Add("ent_nb_gas_grenade", "Gas Grenade")
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
		
function ENT:Explode( ent )

	local ents = ents.FindInSphere( self:GetPos(), 250 )
	for _,v in pairs(ents) do
		
		if ( v:IsPlayer() or v.NEXTBOT ) then
		
			if self:GetOwner():IsValid() then
			
				if self:GetOwner().NEXTBOTMERCENARY then
					if !v.NEXTBOTMERCENARY then
						self:DealInitialDamage( v, 5 )
					end
				elseif self:GetOwner().NEXTBOTZOMBIE then
					if !v.NEXTBOTZOMBIE then
						self:DealInitialDamage( v, 5 )
					end
				elseif ( self:GetOwner().NEXTBOT and !self:GetOwner().NEXTBOTMERCENARY and !self:GetOwner().NEXTBOTZOMBIE ) then
					if ( ( !v.NEXTBOTMERCENARY and !v.NEXTBOTZOMBIE ) or ( v:IsPlayer() and self:IsPlayerZombie( v ) ) ) then
						self:DealInitialDamage( v, 5 )	
					end
				end
				
			else
				self:DealInitialDamage( v, 5 )
			end
			
		end	

	end

	local effectdata = EffectData()
	effectdata:SetStart( ent:GetPos() ) 
	effectdata:SetOrigin( ent:GetPos() )
	effectdata:SetScale( 1 )
	util.Effect( "effect_nb_gas_cloud", effectdata )
	
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
			
	if ent:IsPlayer() then
		ent:ViewPunch(Angle(math.random(-1, 1)*2, math.random(-1, 1)*2, math.random(-1, 1)*2))
	end
end
	
function ENT:PhysicsCollide(data, physobj)

	if IsValid( self ) then
		if SERVER then
		
			self:EmitSound( "physics/metal/metal_grenade_impact_soft"..math.random(1,3)..".wav" )
			
			if ( self.NextGrenadeTimer or 0 ) < CurTime() then
			
				for i=0,4 do
					timer.Simple( i + 0.2, function()
						if IsValid( self ) then
							self:Explode( self )
						end
					end)
				end

				self:EmitSound( "weapons/smokegrenade/sg_explode.wav" )
				SafeRemoveEntityDelayed( self, 5 )
				self.NextGrenadeTimer = CurTime() + 6 --Only calls once
			end
			
		end
	end
	
end	
