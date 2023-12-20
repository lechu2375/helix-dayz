if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

list.Set( "sean_nextbot_weapons", "wep_nb_z_infested", 	
{	Name = "Infested", 
	Class = "wep_nb_z_infested",
	Category = "Zombie SWEPs"	
})

SWEP.PrintName	= "Infested"

SWEP.Author		= "Sean"
SWEP.Purpose	= "Kill nextbot humans to turn them into zombies!"
SWEP.Instructions = "Left/Right Click: Attack"

SWEP.Spawnable	= true
SWEP.UseHands	= false
SWEP.DrawAmmo	= false

SWEP.ViewModel = "models/weapons/conjurer/zombie/v_zombiearms.mdl"
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
SWEP.SetPlayerModelTo = "models/player/zombie_classic.mdl"

hook.Add( "ScalePlayerDamage", "nb_z_infested_dmg", function( ply, hitgroup, dmginfo )
	if ply:HasWeapon( "wep_nb_z_infested" ) then
		if ply:GetActiveWeapon():GetClass() == "wep_nb_z_infested" then
			dmginfo:ScaleDamage( 0.5 )
			if nb_revive_players then
				ply:WOSSetIncap( false )
			end
		end
	end
end)

hook.Add("CalcMainActivity", "nb_z_infested_anims", function(ply, velocity)
	if ply:Alive() and IsValid(ply) then
		if ply:HasWeapon( "wep_nb_z_infested" ) then
			if ply:GetActiveWeapon():GetClass() == "wep_nb_z_infested" then
				--velocity:Length2D() > 1
				if ply:OnGround() and !ply:Crouching() then
					return ACT_HL2MP_RUN_ZOMBIE, -1
				end
		
				if !ply:OnGround() then
					return ACT_HL2MP_JUMP_KNIFE, -1
				end
		
				if ply:Crouching() then
					return ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, -1
				end
			end
		end
	end
end)

function SWEP:Deploy()

	self:SendWeaponAnim(ACT_VM_DEPLOY)
	
	self:UpdateNextIdle()
	
	self.LastPlayerModel = self:GetOwner():GetModel()
	self:GetOwner():SetModel( self.SetPlayerModelTo )
	
	if ( SERVER ) then
		self:SetCombo( 0 )
	end
	
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

function SWEP:Initialize()
	self.ZOMBIENEXTBOTWEP = true --Used in wOs hook to prevent zombies getting downed
	self:SetHoldType( "knife" )
end

function SWEP:SetupDataTables()
	
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )
	
end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:PrimaryAttack( right )

	if SERVER then
		self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)

	local anim = "hitcenter2"
	if ( right ) then anim = "hitcenter1" end
	if ( self:GetCombo() >= 1 ) then
		anim = "altfire"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	
	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.7 )
	
	self:SetNextPrimaryFire( CurTime() + 1.6 )
	self:SetNextSecondaryFire( CurTime() + 1.6 )

end

function SWEP:SecondaryAttack()
	self:PrimaryAttack( true )
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
		
		dmginfo:SetDamage( math.random( 46, 65 ) )
		
		if ( anim == "hitcenter2" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "hitcenter1" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "altfire" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
			dmginfo:SetDamage( math.random( 80, 96 ) )
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

	if ( SERVER ) then
		if ( hit && anim != "altfire" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
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
			
	local meleetime = self:GetNextMeleeAttack()
	
	if ( meleetime > 0 && CurTime() > meleetime ) then
	
		self:DealDamage()
		
		self:SetNextMeleeAttack( 0 )

	elseif ( meleetime > 0 && CurTime() > meleetime - 0.3 ) then
	
		self:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
		
	else
	
		if ( self.NextMoanTimer or 0 ) < CurTime() then
	
			if SERVER then
				self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav")
			end
		
			self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
		
			self.NextMoanTimer = CurTime() + math.random(8,40)
		end
	
	end
	
	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then
		
		self:SetCombo( 0 )
		
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