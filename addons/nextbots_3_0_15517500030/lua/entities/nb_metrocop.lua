AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_metrocop", "Metro Cop")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")
local nb_allow_reviving = GetConVar("nb_allow_reviving")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_metrocop", 	
{	Name = "Metro Cop", 
	Class = "nb_metrocop",
	Category = "Combine"	
})

ENT.Base = "nb_combine_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 72
ENT.CollisionSide = 9

ENT.HealthAmount = 175

ENT.Speed = 155
ENT.PatrolSpeed = 55
ENT.SprintingSpeed = 255
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 0

ENT.AccelerationAmount = 800
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 2
ENT.MeleeDelay = 1

ENT.ShootRange = 600
ENT.MeleeRange = 70
ENT.StopRange = 500
ENT.BackupRange = 300

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 30
ENT.WeaponSpread = 0.1
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 4
ENT.WeaponClass = "wep_nb_pistol"

ENT.Weapons = {"wep_nb_pistol",
"wep_nb_smg"}

ENT.WeaponSound = "Weapon_Shotgun.Single"

--Model--
ENT.Models = {"models/player/police.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_AR2
ENT.AimWalkAnim = ACT_HL2MP_RUN_RPG
ENT.PatrolWalkAnim = ACT_HL2MP_WALK_PASSIVE 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SHOTGUN
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SHOTGUN 
ENT.JumpAnim = ACT_HL2MP_JUMP_SHOTGUN

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
ENT.MeleeAnims = {"aoc_axe_stab_mod"}

--Sounds--
ENT.AttackSounds = {""} --Melee Sounds
ENT.AttackSounds2 = {""} --Shooting Sounds

ENT.PainSounds = {"npc/metropolice/pain1.wav",
"npc/metropolice/pain2.wav",
"npc/metropolice/pain3.wav",
"npc/metropolice/pain4.wav",
"npc/metropolice/knockout2.wav"}

ENT.AlertSounds = {"npc/metropolice/takedown.wav", --Normal alert sounds
"npc/metropolice/vo/acquiringonvisual.wav",
"npc/metropolice/vo/allunitsbol34sat.wav",
"npc/metropolice/vo/allunitscloseonsuspect.wav",
"npc/metropolice/vo/allunitscode2.wav",
"npc/metropolice/vo/allunitsbol34sat.wav",
"npc/metropolice/vo/allunitsmovein.wav",
"npc/metropolice/vo/allunitsrespondcode3.wav",
"npc/metropolice/vo/assaultpointsecureadvance.wav",
"npc/metropolice/vo/backup.wav",
"npc/metropolice/vo/breakhiscover.wav",
"npc/metropolice/vo/confirmadw.wav",
"npc/metropolice/vo/confirmpriority1sighted.wav",
"npc/metropolice/vo/contactwith243suspect.wav",
"npc/metropolice/vo/contactwithpriority2.wav",
"npc/metropolice/vo/converging.wav",
"npc/metropolice/vo/covermegoingin.wav",
"npc/metropolice/vo/dontmove.wav",
"npc/metropolice/vo/destroythatcover.wav",
"npc/metropolice/vo/holdit.wav",
"npc/metropolice/vo/holditrightthere.wav"}
ENT.AlertSounds2 = {"npc/metropolice/vo/infection.wav", --If spotted zombie
"npc/metropolice/vo/infested.wav",
"npc/metropolice/vo/lookout.wav",
"npc/metropolice/vo/looseparasitics.wav",
"npc/combine_soldier/vo/wehavefreeparasites.wav",
"npc/combine_soldier/vo/necrotics.wav",
"npc/combine_soldier/vo/necroticsinbound.wav",
"npc/combine_soldier/vo/infected.wav",
"npc/combine_soldier/vo/infected.wav",
"npc/combine_soldier/vo/infected.wav"}

ENT.DeathSounds = {"npc/metropolice/die1.wav",
"npc/metropolice/die2.wav",
"npc/metropolice/die3.wav",
"npc/metropolice/die4.wav"}

ENT.IdleSounds = {"npc/metropolice/vo/clearandcode100.wav",
"npc/metropolice/vo/classifyasdbthisblockready.wav",
"npc/metropolice/vo/clearno647no10-107.wav",
"npc/metropolice/vo/cprequestsallunitsreportin.wav",
"npc/metropolice/vo/checkformiscount.wav",
"npc/metropolice/vo/hidinglastseenatrange.wav",
"npc/metropolice/vo/highpriorityregion.wav",
"npc/metropolice/vo/holdingon10-14duty.wav",
"npc/metropolice/vo/holdthisposition.wav",
"npc/metropolice/vo/inposition.wav",
"npc/metropolice/vo/inpositionathardpoint.wav",
"npc/metropolice/vo/investigate.wav",
"npc/metropolice/vo/nocontact.wav",
"npc/metropolice/vo/novisualonupi.wav",
"npc/metropolice/vo/patrol.wav",
"npc/metropolice/vo/roger.wav",
"npc/metropolice/vo/search.wav",
"npc/metropolice/vo/searchforsuspect.wav",
"npc/metropolice/vo/investigating10-103.wav"}

ENT.ReloadingSounds = {"npc/metropolice/vo/cpiscompromised.wav", --Standing reloading sounds 
"npc/metropolice/vo/getdown.wav",
"npc/combine_soldier/vo/copy.wav",
"npc/metropolice/vo/keepmoving.wav",
"npc/metropolice/vo/line.wav",
"npc/metropolice/vo/minorhitscontinuing.wav",
"npc/metropolice/vo/moveit.wav",
"npc/metropolice/vo/moveit2.wav"} 
ENT.ReloadingSounds2 = {"npc/metropolice/hiding02.wav", --If running away to reload
"npc/metropolice/hiding03.wav",
"npc/metropolice/hiding04.wav",
"npc/metropolice/hiding05.wav",
"npc/metropolice/vo/backmeupimout.wav",
"npc/metropolice/vo/cpisoverrunwehavenocontainment.wav",
"npc/metropolice/vo/movingtocover.wav",
"npc/metropolice/vo/movingtohardpoint.wav",
"npc/metropolice/vo/movingtohardpoint2.wav",
"npc/metropolice/vo/help.wav"}	

ENT.RevivingFriendlySounds = {""}

function ENT:SetWeaponType( wep )
	
	if wep == "wep_nb_pistol" then

		self.RunningReloadAnim = "reload_pistol"
		self.StandingReloadAnim = "reload_pistol_original"
		self.CrouchingReloadAnim = "reload_pistol"
		self.WalkAnim = ACT_HL2MP_RUN_PISTOL
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_PISTOL
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
		self.PatrolWalkAnim = ACT_HL2MP_WALK
		self.AimWalkAnim = ACT_HL2MP_RUN_PISTOL
		
		self.WeaponSound = "Weapon_Pistol.Single"
		self.WeaponSpread = 0.7
		self.ShootRange = 1200
		self.StopRange = 800
		self.BackupRange = 500
		self.BulletForce = 10
		self.ShootDelay = 0.3
		self.BulletNum = 1
		self.BulletDamage = 11
		self.ClipAmount = 18
	
	elseif wep == "wep_nb_smg" then
	
		self.RunningReloadAnim = "reload_smg1"
		self.StandingReloadAnim = "reload_smg1_original"
		self.CrouchingReloadAnim = "reload_smg1"
		self.WalkAnim = ACT_HL2MP_RUN_SHOTGUN
		self.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1
		self.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1

		self.WeaponSound = "Weapon_Smg1.Single"
		self.WeaponSpread = 0.9
		self.ShootRange = 900
		self.StopRange = 600
		self.BackupRange = 500
		self.BulletForce = 10
		self.ShootDelay = 0.1
		self.BulletNum = 1
		self.BulletDamage = 8
		self.ClipAmount = 45
	
	end
	
end

function ENT:CustomInitialize()

	if !self.Risen then
		
		local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end

		self:SetHealth( self.HealthAmount )
	
	end
	
	local weapon = table.Random( self.Weapons )
		if weapon == "" or nil then
		self.WeaponClass = self.WeaponClass
		self:SetWeaponType( self.WeaponClass )
	else
		self.WeaponClass = weapon
		self:SetWeaponType( weapon )
	end

	if self.Risen then
		self.WeaponClass = "wep_nb_ar2"
		self:SetWeaponType( "wep_nb_ar2" )
	end
	
	self:EquipWeapon()
	
	self.Crouching = false
	self.Patrolling = true

end

function ENT:RunBehaviour()

	while ( true ) do

		self:GrenadeThrow()

		if self:HaveEnemy() and self.Enemy then
						
			local enemy = self:GetEnemy()	
						
			self.Patrolling = false
					
			if self.Reloading then
				self:ReloadBehaviour()
			end
						
			if !self.GoingToSpot then
					
				if enemy:IsValid() and enemy:Health() > 0 then	
					pos = enemy:GetPos()	
									
					if ( pos ) then		
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
					
			end		
				
		else

			if !self.Reloading and !self.ReloadAnimation and !self.GoingToRevive and !self.GoingToSpot then
		
				self.Patrolling = true

				if self.BulletsUsed != 0  and ( !self.Enemy ) then
					self:ReloadWeapon( "running" )
				end
					
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

function ENT:LookForRevive()
end

function ENT:OnInjured( dmginfo )

	--1=Zombie,2=Rebel,3=Mercenary,4=Combine
	if self:CheckFriendlyFire( dmginfo:GetAttacker(), 4 ) then 
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
				dmginfo:ScaleDamage(0.75)	
			end

			if hitgroup == HITGROUP_HEAD then
			
				local effectdata = EffectData()
					effectdata:SetStart( dmginfo:GetDamagePosition() ) 
					effectdata:SetOrigin( dmginfo:GetDamagePosition() )
					effectdata:SetScale( 1 )
				util.Effect( "StunStickImpact", effectdata )
				
				self:EmitSound("hits/armor_hit.wav")
			
				dmginfo:ScaleDamage(3)
			else
				self:EmitSound("hits/kevlar"..math.random(1,5)..".wav")
			end
			
			if hitgroup == ( HITGROUP_CHEST or HITGROUP_GEAR or HITGROUP_STOMACH ) then
				dmginfo:ScaleDamage(0.8)
			end
	end

	self:Flinch( dmginfo, hitgroup )
	self:CheckEnemyPosition( dmginfo )

	self:PlayPainSound()
	
end

function ENT:Melee( ent, type )
	self.IsAttacking = true

	self:PlayAttackSound()
	self:PlayGestureSequence( table.Random( self.MeleeAnims ) )
	
	self.loco:FaceTowards( ent:GetPos() )
	
	timer.Simple( 0.45, function()
		if ( IsValid(self) and self:Health() > 0) then
		
			if IsValid(ent) and ent:Health() > 0 then
		
				if self.Downed then return end
		
				if self:GetRangeTo( ent ) > self.MeleeRange then return end
			
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
				ent:EmitSound( "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav" )
				
				if ent:IsPlayer() or ent.NEXTBOT then
					moveAdd=ent:GetForward()*-1
					ent:SetVelocity( (moveAdd*250) + ( ( ent:GetPos() - self:GetPos() ):GetNormal() * 150 ) )
				end
				
				if type == 1 then --Prop
					local phys = ent:GetPhysicsObject()
					if (phys != nil && phys != NULL && phys:IsValid() ) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
					end
				elseif type == 2 then --Door
					ent.Hitsleft = ent.Hitsleft - 10
				end
		
			end
		
		end
		
	end)
	
	timer.Simple( 1, function()
		if ( IsValid(self) and self:Health() > 0 ) then
			self.IsAttacking = false
		end
	end)
end