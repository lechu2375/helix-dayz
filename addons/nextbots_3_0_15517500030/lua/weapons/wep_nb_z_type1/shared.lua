if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

list.Set( "sean_nextbot_weapons", "wep_nb_z_type1", 	
{	Name = "Type 1", 
	Class = "wep_nb_z_type1",
	Category = "Zombie SWEPs"	
})

SWEP.PrintName	= "Type 1"

SWEP.Author		= "Sean"
SWEP.Purpose	= "Kill nextbot humans to turn them into zombies!"
SWEP.Instructions = "Left Click: Attack | Right Click: Leap"

SWEP.Spawnable	= true
SWEP.UseHands	= false
SWEP.DrawAmmo	= false

SWEP.ViewModel = "models/weapons/conjurer/fastzombie/v_fza.mdl"
SWEP.WorldModel	= ""

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
SWEP.SetPlayerModelTo = "models/player/zombie_fast.mdl"

hook.Add( "ScalePlayerDamage", "nb_z_type1_dmg", function( ply, hitgroup, dmginfo )
	if ply:HasWeapon( "wep_nb_z_type1" ) then
		if ply:GetActiveWeapon():GetClass() == "wep_nb_z_type1" then
			dmginfo:ScaleDamage( 0.75 )
		end
	end
end)

hook.Add("CalcMainActivity", "nb_z_type1_anims", function(ply, velocity)
	if ply:Alive() and IsValid(ply) then
		if ply:HasWeapon( "wep_nb_z_type1" ) then
			if ply:GetActiveWeapon():GetClass() == "wep_nb_z_type1" then
				--velocity:Length2D() > 1
				if ply:OnGround() and !ply:Crouching() then
					return ACT_HL2MP_RUN_ZOMBIE_FAST, -1
				end
				
				if !ply:OnGround() and velocity:Length2D() > 1 then
					return ACT_ZOMBIE_LEAPING, -1
				elseif !ply:OnGround() then
					return ACT_HL2MP_JUMP_KNIFE, -1
				end
				
				if ply:Crouching() then
					return ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, -1
				end
					
			end
		end
	end
end)

function SWEP:Initialize()
	self.ZOMBIENEXTBOTWEP = true --Used in wOs hook to prevent zombies getting downed
	self:SetHoldType( "knife" )
end

function SWEP:Deploy()

	self:SendWeaponAnim(ACT_VM_DEPLOY)
	
	self:UpdateNextIdle()
	
	self.LastPlayerModel = self:GetOwner():GetModel()
	self:GetOwner():SetModel( self.SetPlayerModelTo )
	
	return true

end

function SWEP:Holster()

	if self.LastPlayerModel != nil then
		self:GetOwner():SetModel( self.LastPlayerModel )
	end

   return true
   
end

function SWEP:OnRemove()

end


function SWEP:SetupDataTables()
	
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 0, "NextMeleeAttack2" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	
end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:PrimaryAttack( right )

	if SERVER then
		--self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_FRENZY )

	local anim = "altfire"
	local vm = self.Owner:GetViewModel()
	
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	vm:SetPlaybackRate( 1.7 ) 
	
	self:UpdateNextIdle()
	
	timer.Simple( 0.2, function()
		if !self.Weapon then return end
		self:SetNextMeleeAttack( CurTime() + 0.15 )
	end)
	
	self:SetNextMeleeAttack( CurTime() + 0.15 )
	
	self:SetNextPrimaryFire( CurTime() + 0.4 )
	self:SetNextSecondaryFire( CurTime() + 1 )

end

function SWEP:SecondaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + 0.4 )
	self:SetNextSecondaryFire( CurTime() + 3 )
	
	local tr = util.QuickTrace(self.Owner:GetShootPos(), (self.Owner:GetForward() * -160), self.Owner);
	if (tr.Hit) then
		self:SetVelocity((self:GetUp() * 145) + (self:GetForward() * 555));
		self.Owner:ViewPunch(Angle(8, 0, 0));
		self.Owner:SetVelocity((self.Owner:GetForward() * 555) + (self.Owner:GetUp() * 145));

		if SERVER then
			self.Owner:EmitSound("NPC_FastZombie.Scream")
		end
		
		local anim = "hitcenter1"
		
		if math.random(1,2) == 1 then
			anim = "hitcenter2"
		end
		
		local vm = self.Owner:GetViewModel()
	
		vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
		
		self.Owner:DoAnimationEvent(ACT_ZOMBIE_LEAP_START)

		self:UpdateNextIdle()
		
	end
	
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
		if SERVER then
			self.Owner:EmitSound("npc/fast_zombie/claw_strike"..math.random(1, 3)..".wav")
		end
	end

	local hit = false

	if SERVER && IsValid( tr.Entity ) then
		local dmginfo = DamageInfo()
	
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		
		dmginfo:SetDamageType( DMG_SLASH )
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )

		dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
		dmginfo:SetDamage( math.random( 9, 16 ) )

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

		self:SendWeaponAnim(ACT_VM_IDLE)
		
		self:UpdateNextIdle()
		
	end	
		
	if ( self.NextMoanTimer or 0 ) < CurTime() then
	
		if SERVER then
			self.Owner:EmitSound("npc/fast_zombie/fz_frenzy1.wav", 70)
		end
		
		self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
		
		self.NextMoanTimer = CurTime() + math.random(16,40)
	end
	
	self:FrenzyAttack()
	
end

function SWEP:FrenzyAttack()

	local meleetime = self:GetNextMeleeAttack()
	
	if ( meleetime > 0 && CurTime() > meleetime ) then
	
		self:DealDamage()
		
		self:SetNextMeleeAttack( 0 )

	elseif ( meleetime > 0 && CurTime() > meleetime - 0.1 ) then
		self:EmitSound("npc/fast_zombie/claw_miss"..math.random(1, 2)..".wav")
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