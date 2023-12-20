AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_mercenary_bomber", "Bomber")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_soldier_findreloadspot = GetConVar("nb_soldier_findreloadspot")
local nb_friendlyfire = GetConVar("nb_friendlyfire")
local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_mercenary_bomber", 	
{	Name = "Bomber", 
	Class = "nb_mercenary_bomber",
	Category = "Mercenaries"	
})

ENT.Base = "nb_mercenary"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 68
ENT.CollisionSide = 7

ENT.HealthAmount = 150

ENT.Speed = 180
ENT.SprintingSpeed = 300
ENT.FlinchWalkSpeed = 80
ENT.CrouchSpeed = 40

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 18
ENT.MaxDropHeight = 200

ENT.ShootDelay = 0.2
ENT.MeleeDelay = 1

ENT.ShootRange = 500
ENT.MeleeRange = 60
ENT.StopRange = 400
ENT.BackupRange = 200

ENT.MeleeDamage = 10
ENT.MeleeDamageType = DMG_CLUB

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Weapon--
ENT.BulletForce = 15
ENT.WeaponSpread = 0.6
ENT.BulletNum = 1
ENT.BulletDamage = 5
ENT.ClipAmount = 30
ENT.WeaponClass = "wep_nb_ak47"

ENT.WeaponModel = "models/weapons/w_rif_ak47.mdl"
ENT.WeaponSound = "weapons/tfa_csgo/ak47/ak47-1.wav"

--Model--
ENT.WalkAnim = ACT_HL2MP_RUN_SMG1
ENT.BombRunAnim = ACT_HL2MP_RUN_SLAM 
ENT.SprintingAnim = ACT_DOD_SPRINT_IDLE_MP40 
ENT.FlinchWalkAnim = ACT_HL2MP_WALK_SMG1
ENT.CrouchAnim = ACT_HL2MP_WALK_CROUCH_SMG1 
ENT.JumpAnim = ACT_HL2MP_JUMP_SLAM

ENT.ShootAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
ENT.MeleeAnim = "range_melee_shove_2hand"

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

	self:EquipBomb()
	
end

function ENT:OnInjured( dmginfo )

	if self:CheckFriendlyFire( dmginfo:GetAttacker() ) and ( dmginfo:GetAttacker() != self ) then 
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
				dmginfo:ScaleDamage(8)
				self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			end

	end

	self:Flinch( dmginfo, hitgroup )
	
	self:CheckEnemyPosition( dmginfo )
	
	self:PlayPainSound()
	
end