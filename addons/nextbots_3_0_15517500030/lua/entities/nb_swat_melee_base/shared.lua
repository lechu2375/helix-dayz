if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_doorinteraction = GetConVar("nb_doorinteraction")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

ENT.Base = "nb_rebel_melee_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
ENT.ChaseDistance = 3000

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.HealthAmount = 100

ENT.Speed = 150
ENT.PatrolSpeed = 75
ENT.SprintingSpeed = 230
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 0.4
ENT.MeleeDelay = 1.6

ENT.ShootRange = 65
ENT.MeleeRange = 65
ENT.StopRange = 40
ENT.BackupRange = 20

ENT.MeleeDamage = 25
ENT.MeleeDamageType = DMG_SLASH
 
ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.WeaponClass = "ent_melee_weapon"
ENT.WeaponModel = "models/weapons/w_crowbar.mdl"

--Model--
ENT.WalkAnim = ACT_HL2MP_RUN_MELEE2
ENT.PatrolWalkAnim = ACT_HL2MP_WALK
ENT.BlockWalkAnim = ACT_HL2MP_RUN_MAGIC
ENT.SprintingAnim = ACT_HL2MP_RUN_MELEE2
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_MELEE2 
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_MELEE2
ENT.JumpAnim = ACT_HL2MP_JUMP_MELEE2

ENT.MeleeAnim = {"range_melee_shove_2hand"}

ENT.BlockAnimation = "aoc_kite_deflect"

function ENT:CustomInitialize()

	local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end
	
	self:SetHealth( self.HealthAmount )
	
end

function ENT:EquipWeapon()

	local wep = ents.Create( self.WeaponClass )
	wep:SetOwner(self)
	wep:SetPos(self:GetPos())
	wep:Spawn()
	wep:SetSolid(SOLID_NONE)
	wep:SetParent(self)
	wep:Fire("setparentattachment", "anim_attachment_RH")
	wep:AddEffects(EF_BONEMERGE)
	wep:SetAngles( self:GetForward():Angle() )
	wep:SetOwner( self )
	wep:SetModel( self.WeaponModel )	
	
	self.Weapon = wep
	
end

function ENT:MovementFunction( type )
	if type == "crouching" then
		self:StartActivity( self.CrouchAnim )
		self.loco:SetDesiredSpeed( self.CrouchSpeed )
	elseif type == "running" then
		self:StartActivity( self.SprintingAnim )
		self.loco:SetDesiredSpeed( self.SprintingSpeed )
	elseif type == "panicked" then
		self:StartActivity( ACT_HL2MP_RUN_PANICKED )
		self.loco:SetDesiredSpeed( self.SprintingSpeed )
	elseif type == nil then
		if self.Patrolling then
			self:StartActivity( self.PatrolWalkAnim )
			self.loco:SetDesiredSpeed( self.PatrolSpeed )
		else
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )
		end
	end
end

function ENT:Use( activator, caller )

end

function ENT:RunBehaviour()

	while ( true ) do

		if self:HaveEnemy() then

			self.Patrolling = false
		
			if !self.Blocking then
				
				if !self.EquipAnimation then
				
					self.EquipAnimation = true
					
					if self.Weapon and IsValid( self.Weapon ) then
						 self.Weapon:Fire("SetParentAttachmentMaintainOffset", "chest", 0.01) 
					end
					
					self:PlayGestureSequence( "aoc_warhammer_draw" )
					
					timer.Simple( 0.5, function()
						if IsValid( self ) and self:Health() > 0 then
							self:EquipWeapon()
						end
					end)
					
				end
					
			else
		
				pos = self:GetEnemy():GetPos()

				if ( pos ) then
					
					local enemy = self:GetEnemy()
					
					self:MovementFunction()	
						
					local maxageScaled=math.Clamp(pos:Distance(self:GetPos())/1000,0.1,3)	
					local opts = {	lookahead = 30,
							tolerance = 20,
							draw = false,
							maxage = maxageScaled 
							}
						
					self:ChaseEnemy( opts )
						
				end
			
			end
			
		else
		
			self.Patrolling = true

			if self.Blocking then
				
				if !self.EquipAnimation then
				
					self.EquipAnimation = true
					
					if self.Weapon and IsValid( self.Weapon ) then
						 self.Weapon:Fire("SetParentAttachmentMaintainOffset", "anim_attachment_RH", 0.01) 
					end
					
					self:PlayGestureSequence( "aoc_warhammer_draw" )
					
					timer.Simple( 0.5, function()
						if IsValid( self ) and self:Health() > 0 then
							self:UnEquipWeapon()
						end
					end)
					
				end
					
			else
					
				self:PlayIdleSound()	
					
				self:MovementFunction()
				
				local pos = self:FindSpot( "random", { radius = 5000 } )

				if ( pos ) then

					self:MoveToPos( pos )

				end
					
			end
				
		end

		coroutine.yield()


	end


end

function ENT:CustomBehaveUpdate()

	if self:HaveEnemy() and self.Enemy then
		
		if ( self:GetRangeSquaredTo( self.Enemy ) < self.MeleeRange*self.MeleeRange and self:IsLineOfSightClear( self.Enemy ) ) then

			if ( self.NextMeleeAttackTimer or 0 ) < CurTime() then
			
				if self.Blocking then return end

				self:Melee( self.Enemy )
				
				self.NextMeleeAttackTimer = CurTime() + self.MeleeDelay
			end

		end
				
		if self.IsAttacking then
			if self.FacingTowards:IsValid() and self.FacingTowards:Health() > 0 then
				self.loco:FaceTowards( self.FacingTowards:GetPos() )
			end
		end
				
	end

end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end

	self.IsAttacking = true 
	self.FacingTowards = ent	
	
	self:PlayAttackSound()
	
	if math.random(1,2) == 1 then
		self:PlayGestureSequence( self.MeleeAnim1, 1 )
	else
		self:PlayGestureSequence( self.MeleeAnim2, 1 )
	end
		
	self.loco:SetDesiredSpeed( 0 )
	
	timer.Simple( 0.3, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:EmitSound( "weapons/tfa_kf2/katana/katana_swing_miss"..math.random(1,4)..".wav" )
		end
	end)

	timer.Simple( 0.45, function()
		if ( IsValid(self) and self:Health() > 0) and IsValid(ent) then
		
			if self:GetRangeSquaredTo( ent ) > self.MeleeRange*self.MeleeRange then return end

			if ent:Health() > 0 then
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
				
				if ent.NEXTBOT then
					if !ent.Blocking then
						self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav")
						self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")	
					end
				end
			end
		
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
				--Prop hit sound
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 10
			end
		
		end
	end)
	
	timer.Simple( 0.8, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
			self.loco:SetDesiredSpeed( self.Speed )
		end
	end)
	
end

function ENT:SetEnemy( ent )
	
	self.Enemy = ent

	if self.Enemy != nil then
		
		if self.Enemy and self.Enemy:IsValid() and self.Enemy:Health() > 0 then
			self:PlayAlertSound()
			self:AlertNearby()
		end
		
		if math.random(1,2) == 1 then
			self:PlayGestureSequence( "gesture_signal_forward" )
		else
			self:PlayGestureSequence( "gesture_signal_group" )
		end
	end
	
end

function ENT:BodyUpdate()

	--if !self.IsAttacking then

		if ( self:GetActivity() == self.WalkAnim ) then
				
			self:BodyMoveXY()
		
		elseif ( self:GetActivity() == self.SprintingAnim ) then
		
			self:BodyMoveXY()
			
		elseif ( self:GetActivity() == self.PatrolWalkAnim ) then 
		
			self:BodyMoveXY()
		
		end

	--else
	
		--self:SetPoseParameter("move_x", 0.8 )
	
	--end
	
	self:FrameAdvance()

end

function ENT:ContactDoor( ent, type )
	if type == 1 then --Contacted Door, probably stuck
		if !self.TouchedDoor then
			self.TouchedDoor = true
	
			timer.Simple( 2, function()
				self.TouchedDoor = false
			end)
		end
	else
		ent:Fire("Open")
	end
end

function ENT:ChaseEnemy( options )

	local enemy = self:GetEnemy()
	local pos = enemy:GetPos()
	
	local options = options or {}
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 30 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if (!path:IsValid() ) then return "failed" end
	
	if !enemy then return "failed" end
	
	if !enemy:IsValid() then return "failed" end
	
	if enemy:Health() < 0 then return "failed" end
	
	while ( path:IsValid() and self:HaveEnemy() and ( enemy:IsValid() and enemy:Health() > 0) ) do

		if nb_allow_backingup:GetInt() == 1 then
			if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange and self:GetRangeSquaredTo( enemy ) > (self.BackupRange + 1)*(self.BackupRange + 1) ) and self:IsLineOfSightClear( enemy ) and !self.IsJumping then 
				return "failed" 
			elseif self:GetRangeSquaredTo( enemy ) <= self.BackupRange*self.BackupRange and self:IsLineOfSightClear( enemy ) and ( !self.loco:IsStuck() ) and !self.IsJumping then
				self:MovementFunction()
				self:BackUp()
			end
		else
			if ( self:GetRangeSquaredTo( enemy ) < self.StopRange*self.StopRange ) and self:IsLineOfSightClear( enemy ) and !self.IsJumping then 
				return "failed"
			end
		end
	
		if nb_doorinteraction:GetInt() == 1 then
			if !self:CheckDoor() then
			
			elseif ( self:CheckDoor():IsValid() and self:GetRangeSquaredTo( self:CheckDoor() ) < self.StopRange*self.StopRange and self:IsLineOfSightClear( self:CheckDoor() ) ) then
				self:ContactDoor( self:CheckDoor() )
				return "ok"
			end
		end
	
		if ( !self.Reloading and !self.loco:IsStuck() and ( enemy and enemy:IsValid() and enemy:Health() > 0) ) then
			if ( path:GetAge() > options.maxage ) then	
				path:Compute( self, enemy:GetPos() )
			end
		end

		path:Update( self )	
		
		if ( options.draw ) then
			path:Draw()
		end
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck( 0 )
			return "stuck"
		end
		
		coroutine.yield()
	end
	
	return "ok"
end

function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do
	
		if !self.GoingToRevive then
			if self:HaveEnemy() and !self.Reloading and self.Patrolling then
				return "failed"
			end
		end
	
		if nb_doorinteraction:GetInt() == 1 then
			if !self:CheckDoor() then
			
			elseif ( self:CheckDoor():IsValid() and self:GetRangeSquaredTo( self:CheckDoor() ) < (self.StopRange + 20)*(self.StopRange + 20) and self:IsLineOfSightClear( self:CheckDoor() ) ) then
				self:ContactDoor( self:CheckDoor() )
				return "ok"
			end
		end
	
		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end

		if !self.Downed then
			if ( self.loco:IsStuck() ) then
				self:HandleStuck()
				return "stuck"
			end
		end
		
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		
		coroutine.yield()

	end

	return "ok"

end

function ENT:OnInjured( dmginfo )

	if self:CheckFriendlyFire( dmginfo:GetAttacker() ) then 
		dmginfo:ScaleDamage(0)
	return end
	
	if ( dmginfo:IsBulletDamage() ) then

		local attacker = dmginfo:GetAttacker()
	
			local trace = {}
			trace.start = attacker:EyePos()

			trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
			trace.mask = MASK_SHOT
			trace.filter = attacker
		
			local tr = util.TraceLine( trace )
			hitgroup = tr.HitGroup
			
			if hitgroup == ( HITGROUP_LEFTLEG or HITGROUP_RIGHTLEG ) then
				dmginfo:ScaleDamage(0.45)	
			end

			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage(1.5)
				self:ArmorVisual( dmginfo:GetDamagePosition() )
				self:EmitSound("hits/armor_hit.wav")
			end
			
			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				dmginfo:ScaleDamage(0.7)
				
				--kevlar sound
			end
			
		self:PlayPainSound()
	end

	if ( dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_CLUB) ) and self:GetRangeSquaredTo( dmginfo:GetAttacker() ) < 80*80 and !self.IsAttacking then

		local enemyforward = dmginfo:GetAttacker():GetForward()
		local forward = self:GetForward() 
					
		if enemyforward:Distance( forward ) > 1 then
			--Hit from front
			if dmginfo:GetAttacker().NEXTBOT then
				self:ArmorVisual( ( self:GetPos() + Vector(0,0,50) + (self:GetForward() * 20) ) )
			else
				self:ArmorVisual( dmginfo:GetDamagePosition() + ( self:GetForward() * 22 ) )
			end

			self:EmitSound("hits/armor_hit.wav")
			dmginfo:ScaleDamage( 0.1 )
		else
			--Hit from behind
			self:PlayPainSound()
		end

	end
	
	self:CheckEnemyPosition( dmginfo )
	
end

function ENT:ArmorVisual( pos )

	local effectdata = EffectData()
		effectdata:SetStart( pos ) 
		effectdata:SetOrigin( pos )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )

end

function ENT:StartBlocking()
end

function ENT:BlockDamage()
end

function ENT:OnRemove()

	if self.Weapon then
		SafeRemoveEntity( self.Weapon )
	end
	
end

function ENT:OnKilled( dmginfo )
	
	if self.HitByVehicle then 
	return end
	
	if dmginfo:GetAttacker().NEXTBOTZOMBIE or self:IsPlayerZombie( dmginfo:GetAttacker() ) then
	
		self:RiseAsZombie( self, "nb_rise_base", "nb_freshdead", "", 100, true )
	
		if self.Weapon then
			SafeRemoveEntity( self.Weapon)
		end
	
	else
	
		self:BecomeRagdoll( dmginfo )
		self:DropWeapon()
	
	end
	
	self:PlayDeathSound()
	
end

function ENT:DropWeapon()
	
	if !self.Weapon then return end
	
	local ent = ents.Create( "ent_fakeweapon" )
	
	if ent:IsValid() and self:IsValid() then	
	
		ent:SetModel( self.Weapon:GetModel() )
		ent:SetPos( self:GetPos() + Vector( 0,0,50 ) )
		ent:SetAngles( self.Weapon:GetAngles() )
		ent:Spawn()
	
		ent:SetOwner( self )
				
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
		
			local ang = self:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 100))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 100))
			phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( 20, 200 ))
				
		end
		
	end
	
	SafeRemoveEntity( self.Weapon )

end

function ENT:WOSGetIncapped()
	return self.WOS_InLastStand
end