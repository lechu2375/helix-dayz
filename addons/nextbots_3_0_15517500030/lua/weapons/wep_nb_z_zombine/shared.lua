if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

list.Set( "sean_nextbot_weapons", "wep_nb_z_zombine", 	
{	Name = "Infested Combine", 
	Class = "wep_nb_z_zombine",
	Category = "Zombie SWEPs"	
})

SWEP.PrintName	= "Infested Combine"

SWEP.Author		= "Sean"
SWEP.Purpose	= "Kill nextbot humans to turn them into zombies!"
SWEP.Instructions = "Left Click: Attack | Right Click: Pull grenade"

SWEP.Spawnable	= true
SWEP.UseHands	= false
SWEP.DrawAmmo	= false

SWEP.ViewModel = "models/weapons/conjurer/zombine/v_zombine.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"

SWEP.ViewModelFOV	= 70
SWEP.Slot			= 0
SWEP.SlotPos		= 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.HitDistance = 60
SWEP.LastPlayerModel = nil
SWEP.SetPlayerModelTo = "models/zombie/zombineplayer.mdl"

--ACT DECIMAL = ACT SEQ
--0	=	draw
--1	=	melee1
--2	=	melee2
--3	=	grenade_pickup
--4	=	grenade_start
--5	=	idle

hook.Add( "ScalePlayerDamage", "nb_z_zombine_dmg", function( ply, hitgroup, dmginfo )
	if ply:HasWeapon( "wep_nb_z_zombine" ) then
		if ply:GetActiveWeapon():GetClass() == "wep_nb_z_zombine" then
			dmginfo:ScaleDamage( 0.1 )
		end
	end
end)

hook.Add("CalcMainActivity", "nb_z_zombine_anims", function(ply, velocity)
	if ply:Alive() and IsValid(ply) then
		if ply:HasWeapon( "wep_nb_z_zombine" ) then
			if ply:GetActiveWeapon():GetClass() == "wep_nb_z_zombine" then
			
				if velocity:Length2D() > 1 then
					local vel = velocity/velocity:Length2D()
					if vel:IsEqualTol( ply:GetForward(), 1) then --If we are moving forward
						if IsValid( ply:GetActiveWeapon() ) then
							if ply:OnGround() and !ply:Crouching() then
								if ply:KeyDown( IN_WALK ) then
									return ACT_WALK, -1
								else
									return ACT_RUN, -1
								end
							end
						end
					else --If we are moving backwards
						if ply:OnGround() and !ply:Crouching() then
							return ACT_HL2MP_RUN_ZOMBIE, -1
						end
					end
				else
					if !ply:OnGround() then
						return ACT_HL2MP_JUMP_KNIFE, -1
					elseif !ply:Crouching() then
						return ACT_IDLE, -1
					end
				end

				if ply:Crouching() then
					return ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, -1
				end
				
			end
		end
	end
end)

if CLIENT then
	function SWEP:DrawWorldModel()
		if self.PulledGrenade then
			self:DrawModel()
		end
	end
end

function SWEP:Deploy()

	self:SendWeaponAnim(0) --0 = Draw
	
	self:UpdateNextIdle()
	
	self.LastPlayerModel = self:GetOwner():GetModel()
	self:GetOwner():SetModel( self.SetPlayerModelTo )
	
	return true

end

function SWEP:Holster()

	if self.PulledGrenade then

		return false
	
	else
	
		if self.LastPlayerModel != nil then
			self:GetOwner():SetModel( self.LastPlayerModel )
		end

	   return true
   
   end
   
end

function SWEP:OnRemove()

end

function SWEP:Initialize()
	self.ZOMBIENEXTBOTWEP = true --Used in wOs hook to prevent zombies getting downed
	self.PulledGrenade = false
	self:SetHoldType( "knife" )
end

function SWEP:SetupDataTables()
	
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	
end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:PrimaryAttack( right )

	if SERVER then
		self.Owner:EmitSound("nextbots/zombine/attack"..math.random(1, 2)..".wav")
	end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)

	local anim
	if math.random(1,2) == 1 then
		anim = "melee1"
	else
		anim = "melee2"
	end
	
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	
	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.7 )
	
	self:SetNextPrimaryFire( CurTime() + 1.6 )
	self:SetNextSecondaryFire( CurTime() + 1.6 )

end

function SWEP:SecondaryAttack()
	
	if SERVER then
		if math.random(1,2) == 1 then
			self.Owner:EmitSound("nextbots/zombine/enrage"..math.random(1, 2)..".wav")
		else
			self.Owner:EmitSound("nextbots/zombine/fall"..math.random(1, 2)..".wav")
		end
	end
	
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "grenade_pickup" ) )

	self.PulledGrenade = true
	
	if SERVER then
		self.Owner:DrawWorldModel( true )
	end
	
	self.Owner:DoAnimationEvent( 2387 )
	
	timer.Simple( 0.5, function()
		if !IsValid( self ) then return end
		if !IsValid( self.Owner ) then return end
		if !self.Owner:Alive() then return end
		
		if IsValid( self.Owner:GetActiveWeapon() ) then
			if self.Owner:GetActiveWeapon( "wep_nb_z_zombine" ) then
				vm:SendViewModelMatchingSequence( vm:LookupSequence( "grenade_start" ) )
			end
		end
	end)
	
	timer.Simple( 3, function()
		if !IsValid( self ) then return end
		if !IsValid( self.Owner ) then return end
		if !self.Owner:Alive() then return end
		
		if IsValid( self.Owner:GetActiveWeapon() ) then
			if self.Owner:GetActiveWeapon( "wep_nb_z_zombine" ) then
				
				if SERVER then
					local explode = ents.Create("env_explosion")
					explode:SetPos( self.Owner:GetPos() + Vector(0,0,30) + (self:GetRight()*5) )
					explode:Spawn()
					explode:SetKeyValue( "iMagnitude", 0 )
					explode:SetOwner( self.Owner )	
					explode:Fire( "Explode", 1, 0 )	
				
					local ents = ents.FindInSphere( self:GetPos(), 150 )
					for _,v in pairs(ents) do
						local dmg = DamageInfo()

						dmg:SetAttacker( self.Owner )
						dmg:SetInflictor( self )
						dmg:SetDamage( 300 )
						dmg:SetDamageType( DMG_BLAST )
						v:TakeDamageInfo( dmg )
								
						if v:IsPlayer() then
							v:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
						end
					end
					
					self.Owner:Kill()
				end
				
			end
		end
	end)
	
	self:SetNextPrimaryFire( CurTime() + 10 )
	self:SetNextSecondaryFire( CurTime() + 10 )
	
end

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP.
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
	end

	local hit = false

	if SERVER && IsValid( tr.Entity ) then
		local dmginfo = DamageInfo()
	
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		
		dmginfo:SetDamageType( DMG_SLASH )
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		
		dmginfo:SetDamage( math.random( 76, 85 ) )
		
		if ( anim == "melee1" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "melee2" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		end

		tr.Entity:TakeDamageInfo( dmginfo )
		
		if tr.Entity:IsPlayer() or tr.Entity.NEXTBOT or tr.Entity:IsNPC() then
			self:BleedVisual( 0.2, tr.HitPos )
		end
		
		hit = true

	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:Think()
	
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		self:SendWeaponAnim(5) --5 = Idle
		
		self:UpdateNextIdle()
		
	end	
			
	local meleetime = self:GetNextMeleeAttack()
	
	if ( meleetime > 0 && CurTime() > meleetime ) then
	
		self:DealDamage()
		
		self:SetNextMeleeAttack( 0 )

	elseif ( meleetime > 0 && CurTime() > meleetime - 0.3 ) then
	
		self:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
		
	else
	
		if ( self.NextMoanTimer or 0 ) < CurTime() then
	
			if SERVER then
				self.Owner:EmitSound("nextbots/zombine/idle"..math.random(1, 4)..".wav")
			end
		
			self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
		
			self.NextMoanTimer = CurTime() + math.random(8,40)
		end
	
	end
	
end

function SWEP:BleedVisual( time, pos, dmginfo )
	local bleed = ents.Create("info_particle_system")
	bleed:SetKeyValue("effect_name", "blood_impact_red_01")
	bleed:SetPos( pos )
	bleed:Spawn()
	bleed:Activate()
	bleed:Fire("Start", "", 0)
	bleed:Fire("Kill", "", time)
end

function SWEP:NextbotType()
	return zombie
end

hook.Add( "TranslateActivity", "UpdateZombieAnimations", function( ply, act )
	
end )