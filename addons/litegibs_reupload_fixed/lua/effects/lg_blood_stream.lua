local gravvar = GetConVar("sv_gravity")
local upVec = Vector(0, 0, 1)
local m_Rand = math.Rand
local BLOOD_COLOR_SYNTH = BLOOD_COLOR_SYNTH or BLOOD_COLOR_ANTLION_WORKER + 2

EFFECT.Colors = {
	[BLOOD_COLOR_RED] = Color(64, 0, 0, 225),
	[BLOOD_COLOR_GREEN] = Color(96, 128, 8, 225),
	[BLOOD_COLOR_YELLOW] = Color(128, 128, 8, 225),
	[BLOOD_COLOR_ANTLION] = Color(96, 128, 8, 225),
	[BLOOD_COLOR_SYNTH] = Color(200,200,200, 128)
}

local particlesPerSecond = 30
local decalsPerSecond = 10
local soundsPerSecond = 20
local lastDecal = 0 --we can decal rate globally, not per particle
local dropDistanceThreshold = 2.5
local lastSound = 0
EFFECT.FPS = particlesPerSecond

EFFECT.PoolCounter = 0
EFFECT.PoolCounterMax = 3
EFFECT.LastPos = Vector()
EFFECT.LastImpact = Vector()

EFFECT.Velocity = 100
EFFECT.SpurtPeriod = 0.7
EFFECT.SpurtFactor = 0.35

EFFECT.PoolParticles = {}
EFFECT.PoolMovementThreshold = 2

local PoolProperties = {
	["startSize"] = 0.3, --start size, multiplied by droplet particle size
	["endSize"] = 2, --amount to expand to
	["growth"] = 3,
	["longgrowth"] = 1.3,
	["life"] = 15
}

local dropFade = 2

local function dropDecay(p)
	local mult = math.Clamp(p:GetDieTime() - p:GetLifeTime(),0,dropFade) / dropFade
	p:SetStartAlpha(255 * mult)
	p:SetEndAlpha(255 * mult)
	p:SetNextThink(CurTime())
end

local function dropNextStage(p)
	local mult = math.Clamp( p:GetLifeTime() / ( PoolProperties.growth * 0.925 ), 0, 1)
	p:SetStartSize(mult*(p:GetEndSize()-p:GetStartSize())+p:GetStartSize())
	p:SetEndSize(p:GetStartSize()*PoolProperties.longgrowth)
	p:SetLifeTime(0)
	p:SetDieTime(PoolProperties.life - PoolProperties.growth)
	p:SetNextThink( CurTime() + PoolProperties.life - PoolProperties.growth - dropFade )
	p:SetThinkFunction( dropDecay )
	p.Fin = true
end

function EFFECT:Init(data)
	if not LiteGibs or not LiteGibs.Ragdolls then return end
	if not LiteGibs.CVars.BloodStreamEnabled:GetBool() then return end
	self.Pos = data:GetOrigin()
	self.emitter = ParticleEmitter(self.Pos)
	self.emitter3D = ParticleEmitter(self.Pos,true)
	self.targentindex = math.Round(data:GetFlags())
	self.targent = LiteGibs.Ragdolls[self.targentindex]
	self.targbone = math.Round(data:GetMagnitude())

	if self.targbone < 0 then
		self.targbone = 0
	end

	if not IsValid(self.targent) then return end
	self.Grav = Vector(0, 0, -gravvar:GetFloat())
	self.DieTime = CurTime() + LiteGibs.CVars.BloodStreamTime:GetFloat()
	self.LastBleed = 0
	self.PoolCounterMax = self.FPS * self.SpurtPeriod
	self.BoneName = string.lower(self.targent:GetBoneName(self.targbone))
	self.RawColor = data:GetColor()
	self.Color = self.Colors[self.RawColor or BLOOD_COLOR_RED] or self.Colors[BLOOD_COLOR_RED]
	LiteGibs.BloodStreamTable = LiteGibs.BloodStreamTable or {}
	local index = #LiteGibs.BloodStreamTable
	LiteGibs.BloodStreamTable[index + 1] = self
	self.index = index
end

function EFFECT:StopPoolGrowth()
	for k, part in ipairs(self.PoolParticles) do
		if not part.Fin then
			local mult = math.Clamp( part:GetLifeTime() / ( PoolProperties.growth * 0.925 ), 0, 1)
			part:SetStartSize(mult*(part:GetEndSize()-part:GetStartSize())+part:GetStartSize())
			part:SetEndSize(part:GetStartSize()*PoolProperties.longgrowth)
			part.Fin = true
		end
	end
	table.Empty(self.PoolParticles)
end

local ops = {
	["valvebiped.bip01_r_thigh"] = function(ang) return ang:RotateAroundAxis(ang:Up(), -90) end,
	["valvebiped.bip01_l_thigh"] = function(ang) return ang:RotateAroundAxis(ang:Up(), -90) end
}

function EFFECT:Think()
	if not self.DieTime then
		self:Die()
		return false
	end
	if not IsValid(self.targent) then
		self:Die()
		return false
	end
	if (self.targent:IsNPC() or self.targent:IsPlayer()) and self.targent.Dead then
		if self.targent.GetRagdollEntity and IsValid(self.targent:GetRagdollEntity()) then
			self.targent=self.targent:GetRagdollEntity()
			self.targentindex = self.targent.id or self.targent:EntIndex()
		end
	end
	if CurTime() > self.DieTime then
		self:Die()
		return false
	end
	local bmat = self.targent:GetBoneMatrix(self.targbone)
	if not bmat then
		self:Die()
		return
	end
	local bpos = bmat:GetTranslation()
	self.Pos = LerpVector(FrameTime() * 10, self.Pos, bpos)
	if not self.LastPos then
		self.LastPos = self.Pos
	else
		if self.Pos:Distance(self.LastPos) > self.PoolMovementThreshold then
			self.LastPos = self.Pos
			self:StopPoolGrowth()
		end
	end
	local lVec = render.ComputeLighting(self.Pos, upVec)
	local avg = math.Clamp((lVec.r + lVec.g + lVec.b) / 3, 0.2, 0.8) / 0.8
	lVec.r = avg
	lVec.g = avg
	lVec.b = avg

	if CurTime() > self.LastBleed + 1 / self.FPS - (1 / self.FPS) * math.sin(CurTime() * math.pi * 2 / self.SpurtPeriod) * self.SpurtFactor * 0.5 then
		self.LastBleed = CurTime()
		local pos = self.Pos
		local _, ang

		if self.targent.isGib then
			_, ang = self.targent:GetBonePosition(math.max(0, self.targbone))
			ang:RotateAroundAxis(ang:Up(), 180)
		else
			_, ang = self.targent:GetBonePosition(math.max(0, self.targent:GetBoneParent(self.targbone)))
		end

		local f = ops[self.BoneName]

		if f then
			f(ang)
		end

		self.emitter:SetPos(pos)
		self.emitter3D:SetPos(pos)
		self.Dir = ang:Forward()
		local part = self.emitter:Add("effects/blood_core", pos - self.Dir * 5)
		part:SetVelocity(self.Dir * self.Velocity * (1 + math.sin(CurTime() * math.pi * 2 / self.SpurtPeriod) * self.SpurtFactor))
		part:SetDieTime(m_Rand(0.9, 1))
		part:SetStartAlpha(self.Color.a)
		part:SetEndAlpha(self.Color.a / 2)
		local sz = m_Rand(5, 6)
		part:SetStartSize(sz)
		part:SetEndSize(sz)
		part:SetRoll(0)
		part:SetGravity(self.Grav)
		part:SetCollide(true)
		part:SetBounce(0)
		part:SetAirResistance(0.25)
		part:SetStartLength(0.15)
		part:SetEndLength(0.3)
		part:SetVelocityScale(true)
		part:SetColor(self.Color.r * math.Clamp(lVec.r, 0.3, 1), self.Color.g * math.Clamp(lVec.b, 0.05, 1), self.Color.b * math.Clamp(lVec.b, 0.025, 1))

		part:SetCollideCallback(function(pt, hitPos, hitNormal)
			if IsValid(self) and LiteGibs.CVars.BloodPoolEnabled and LiteGibs.CVars.BloodPoolEnabled:GetBool() then
				local lVec2 = render.ComputeLighting(self.Pos, upVec)
				local avg = math.Clamp((lVec2.r + lVec2.g + lVec2.b) / 3, 0.2, 0.8) / 0.8
				lVec2.r = avg
				lVec2.g = avg
				lVec2.b = avg
				local drop = self.emitter3D:Add("particle/smokesprites_000" .. math.random(1,9), hitPos + hitNormal)
				drop:SetAngles(hitNormal:Angle())
				drop:SetStartSize(pt:GetStartSize() * PoolProperties.startSize)
				drop:SetEndSize(pt:GetStartSize() * PoolProperties.endSize)
				drop:SetDieTime( PoolProperties.growth  + 0.05 )
				drop:SetColor(self.Color.r * math.Clamp(lVec2.r, 0.3, 1), self.Color.g * math.Clamp(lVec2.b, 0.05, 1), self.Color.b * math.Clamp(lVec2.b, 0.025, 1))
				drop:SetLighting(false)
				drop:SetStartAlpha(255)
				drop:SetEndAlpha(255)
				--drop:SetThinkFunction(dropDecay)
				--drop:SetNextThink(CurTime() + PoolProperties.life - dropFade)
				drop:SetThinkFunction(dropNextStage)
				drop:SetNextThink(CurTime() + PoolProperties.growth)
				self.PoolParticles[#self.PoolParticles+1]=drop
			end

			if CurTime() > lastSound + 1 / soundsPerSecond then
				sound.Play("LG.BloodDrop", hitPos)
				lastSound = CurTime()
			end

			if IsValid(pt) then
				pt:Remove()
			end
		end)

		part:SetLighting(false)
	end

	return true
end

function EFFECT:Render()
	return false
end

function EFFECT:Die()
	self:StopPoolGrowth()
	if IsValid(self.emitter) then
		self.emitter:Finish()
	end
	local em = self.emitter3D
	timer.Simple(PoolProperties.life, function()
		if IsValid(em) then
			em:Finish()
		end
	end)
end