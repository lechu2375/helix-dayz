if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Zombie seeker"
ENT.Category = "DayZ"
ENT.Models = {"models/bloocobalt/infected_citizens/male_06.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED

-- Sounds --
ENT.OnDamageSounds = {"nextbots/seeker/pain1.wav","nextbots/seeker/pain2.wav","nextbots/seeker/pain3.wav","nextbots/seeker/pain4.wav"}
ENT.OnDeathSounds = {"nextbots/seeker/death1.wav","nextbots/seeker/death2.wav","nextbots/seeker/death3.wav","nextbots/seeker/death4.wav"}

-- Stats --
ENT.SpawnHealth = 200

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 150
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}

-- Movements/animations --
ENT.UseWalkframes = false
ENT.RunAnimation = ACT_RUN 
ENT.WalkAnimation = ACT_WALK
ENT.WalkSpeed = 20
ENT.WalkAnimRate = 1.2
ENT.RunSpeed = 250
-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Spine4"
ENT.EyeOffset = Vector(7.5, 0, 5)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
	{
		offset = Vector(0, 30, 20),
		distance = 100
	},
	{
		offset = Vector(7.5, 0, 0),
		distance = 0,
		eyepos = true
	}
}
ENT.PossessionBinds = {
	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			self:EmitSound("nextbots/seeker/attack"..math.random(1,4)..".wav")
			self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1.5, self.PossessionFaceForward)
		end
	}}
}

if SERVER then

	-- Init/Think --

	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
	end

	-- AI --

	function ENT:OnMeleeAttack(enemy)
		self:EmitSound("nextbots/seeker/attack"..math.random(1,4)..".wav")
		self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1.5, self.FaceEnemy)
	end

	function ENT:OnReachedPatrol()
		self:EmitSound("nextbots/seeker/idle"..math.random(1,4)..".wav")
		self:Wait(math.random(3, 7))
	end
	function ENT:OnIdle()
		self:AddPatrolPos(self:RandomPos(1500))
	end

	-- Damage --

	function ENT:OnDeath(dmg, delay, hitgroup)

	end

	-- Animations/Sounds --

	function ENT:OnNewEnemy()
		self:EmitSound("nextbots/seeker/alert"..math.random(1,4)..".wav")
	end

	function ENT:OnAnimEvent()
		if self:IsAttacking() and self:GetCycle() > 0.3 then
			self:Attack({
				damage = 40,
				type = DMG_SLASH,
				viewpunch = Angle(20, math.random(-10, 10), 0)
			}, function(self, hit)
				if #hit > 0 then
					self:EmitSound("Zombie.AttackHit")
				else self:EmitSound("Zombie.AttackMiss") end
			end)
		elseif math.random(2) == 1 then
			self:EmitSound("Zombie.FootstepLeft")
		else self:EmitSound("Zombie.FootstepRight") end
	end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
