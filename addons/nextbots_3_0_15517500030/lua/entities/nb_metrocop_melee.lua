AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_metrocop_melee", "Melee Metrocop")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_metrocop_melee", 	
{	Name = "Melee Metrocop", 
	Class = "nb_metrocop_melee",
	Category = "Combine"	
})

ENT.Base = "nb_combine_melee_base"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 155

ENT.Speed = 135
ENT.SprintingSpeed = 175
ENT.PatrolSpeed = 50
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 600
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 0.4
ENT.MeleeDelay = 1.2

ENT.ShootRange = 60
ENT.MeleeRange = 55
ENT.StopRange = 35
ENT.BackupRange = 15

ENT.MeleeDamage = 65
ENT.MeleeDamageType = DMG_SLASH
 
ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.WeaponClass = "ent_melee_weapon"
ENT.WeaponModel = "models/weapons/w_stunbaton.mdl"

--Model--
ENT.Models = {"models/player/police.mdl"}

ENT.WalkAnim = ACT_HL2MP_RUN_MELEE
ENT.PatrolWalkAnim = ACT_HL2MP_WALK
ENT.SprintingAnim = ACT_HL2MP_RUN_MELEE
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_MELEE
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_MELEE
ENT.JumpAnim = ACT_HL2MP_JUMP_MELEE2

ENT.MeleeAnim = {"aoc_shortswordshield_stab.smd_mod",
"aoc_shortswordshield_slash_01_mod",
"aoc_dagger2_throw",
"aoc_kite_stab_mod",
"aoc_slash_01",
"aoc_slash_02",
"aoc_slash_03",
"aoc_slash_04",
"aoc_slash_05"}

ENT.BlockAnimation = "aoc_kite_deflect"

--Sounds--
ENT.AttackSounds = {""} --Melee Sounds

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

function ENT:CustomInitialize()

	self:SetModel( table.Random( self.Models ) )
	
	self:SetHealth( self.HealthAmount )
	
	self:EquipWeapon()
	
	self.OrgWalkAnim = self.WalkAnim
	
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
	
	--self:FrameAdvance()

end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end

	self.IsAttacking = true 
	self.FacingTowards = ent	
	
	self:PlayAttackSound()
	
	self:PlayGestureSequence( table.Random( self.MeleeAnim ), 1 )
		
	self.loco:SetDesiredSpeed( 0 )
	
	timer.Simple( 0.3, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:EmitSound( "weapons/stunstick/stunstick_swing"..math.random(1,2)..".wav" )
		end
	end)

	timer.Simple( 0.5, function()
		if ( IsValid(self) and self:Health() > 0) and IsValid(ent) then
		
			if self:GetRangeSquaredTo( ent ) > self.MeleeRange*self.MeleeRange then return end

			if ent:Health() > 0 then
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
				
				local effectdata = EffectData()
					effectdata:SetStart( ent:GetPos() + Vector(0,0,50) ) 
					effectdata:SetOrigin( ent:GetPos() + Vector(0,0,50) ) 
					effectdata:SetScale( 1 )
				util.Effect( "StunStickImpact", effectdata )
				
				if ent:IsPlayer() then
					if ( ent:GetActiveWeapon().CanBlock ) then
						if ( ent:GetActiveWeapon():GetStatus( TFA.GetStatus("blocking") ) ) == 21 then
							--blocksound
						else
							ent:EmitSound( "weapons/stunstick/stunstick_fleshit"..math.random(1,2)..".wav" )
							ent:EmitSound( "Flesh.ImpactHard" )
						end
					else
						if ( ent:GetNetworkedBool("Block") ) then
							--blocksound
						else
							ent:EmitSound( "weapons/stunstick/stunstick_fleshit"..math.random(1,2)..".wav" )
							ent:EmitSound( "Flesh.ImpactHard" )
						end
					end
				else
					if ent.NEXTBOT then
						if !ent.Blocking then
							ent:EmitSound( "weapons/stunstick/stunstick_fleshit"..math.random(1,2)..".wav" )
							ent:EmitSound( "Flesh.ImpactHard" )
						end
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
	
	timer.Simple( 1, function()
		if ( IsValid(self) and self:Health() > 0) then
			self.IsAttacking = false
			self.loco:SetDesiredSpeed( self.Speed )
		end
	end)
	
end