local gravvar = GetConVar("sv_gravity")
local upVec = Vector(0, 0, 1)
local m_Rand = math.Rand
local BLOOD_COLOR_SYNTH = BLOOD_COLOR_SYNTH or BLOOD_COLOR_ANTLION_WORKER + 2

EFFECT.Colors = {
	[BLOOD_COLOR_RED] = Color(96, 0, 0, 225),
	[BLOOD_COLOR_GREEN] = Color(96, 128, 8, 225),
	[BLOOD_COLOR_YELLOW] = Color(128, 128, 8, 225),
	[BLOOD_COLOR_ANTLION] = Color(96, 128, 8, 225),
	[BLOOD_COLOR_SYNTH] = Color(200,200,200, 128)
}

local soundChance = 1 / 5
EFFECT.Velocity = 150
EFFECT.RandomVelocity = 125
EFFECT.ParticleCount = 50
EFFECT.Size = 3

local ops = {
	["valvebiped.bip01_r_thigh"] = function(ang) return ang:RotateAroundAxis(ang:Up(), -90) end,
	["valvebiped.bip01_l_thigh"] = function(ang) return ang:RotateAroundAxis(ang:Up(), -90) end
}

local dropFade = 2

local function dropDecay(p)
	local mult = math.Clamp(p:GetDieTime() - p:GetLifeTime(),0,dropFade) / dropFade
	p:SetStartAlpha(255 * mult)
	p:SetEndAlpha(255 * mult)
	if mult < 1 then
		p:SetNextThink(CurTime())
	end
end

function EFFECT:Init(data)
	if not LiteGibs or not LiteGibs.Ragdolls then return end
	if not LiteGibs.CVars.BloodSprayEnabled:GetBool() then return end
	self.RawColor = data:GetColor()
	self.Color = self.Colors[self.RawColor or BLOOD_COLOR_RED] or self.Colors[BLOOD_COLOR_RED]
	self.Pos = data:GetOrigin()
	self.emitter = ParticleEmitter(self.Pos)
	self.emitter3D = ParticleEmitter(self.Pos,true)
	self.targent = LiteGibs.Ragdolls[math.Round(data:GetFlags())]
	self.targbone = math.Round(data:GetMagnitude())

	if self.targbone < 0 then
		self.targbone = 0
	end
	self.Grav = Vector(0, 0, -gravvar:GetFloat())

	local pos

	if not IsValid(self.targent) then
		self.Dir = upVec
		pos = self.Pos
	else
		self.DieTime = CurTime() + 5
		self.LastBleed = 0
		self.BoneName = string.lower(self.targent:GetBoneName(self.targbone))
		self.targent:SetupBones()
		pos = self.targent:GetBonePosition(self.targbone)
		if not pos then return end
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

		self.Dir = ang:Forward()
	end

	local lVec = render.ComputeLighting(self.Pos, upVec)
	local avg = math.Clamp( (lVec.r + lVec.g + lVec.b) / 3, 0.2, 0.8 ) / 0.8
	lVec.r = avg
	lVec.g = avg
	lVec.b = avg

	self.Scale = data:GetScale() or 1
	local sc = self.Scale
	local rc = self.RawColor

	local partCount = math.floor(self.ParticleCount * math.sqrt(sc))

	for i = 1, partCount do
		local part = self.emitter:Add("effects/blooddrop", pos - self.Dir * 5)
		local randDir = Angle(math.Rand(-360/2,360/2),math.Rand(-360/2,360/2),math.Rand(-360/2,360/2))
		part:SetVelocity( (self.Dir * self.Velocity + randDir:Forward() * self.RandomVelocity) * math.sqrt(self.Scale) * 0.75)
		part:SetDieTime(m_Rand(0.9, 1))
		part:SetStartAlpha(self.Color.a)
		part:SetEndAlpha(self.Color.a / 2)
		local sz = m_Rand(self.Size * 0.5, self.Size * 1)
		part:SetStartSize(sz * (sc + 0.5))
		part:SetEndSize(sz / 2 * (sc + 0.5))
		part:SetRoll(0)
		part:SetGravity(self.Grav)
		part:SetCollide(true)
		part:SetBounce(0)
		part:SetAirResistance(0.25)
		part:SetStartLength(sz * 0.01)
		part:SetEndLength(sz * 0.0175)
		part:SetVelocityScale(true)
		part:SetColor(self.Color.r * math.Clamp(lVec.r, 0.3, 1), self.Color.g * math.Clamp(lVec.b, 0.05, 1), self.Color.b * math.Clamp(lVec.b, 0.025, 1))
		part:SetCollideCallback(function(myself, hitPos, hitNormal)
			lVec = render.ComputeLighting(hitPos, upVec)
			avg = math.Clamp( (lVec.r + lVec.g + lVec.b) / 3, 0.2, 0.8 ) / 0.8
			lVec.r = avg
			lVec.g = avg
			lVec.b = avg

			local velFac = math.sqrt(part:GetVelocity():Length()) * 0.1

			local splash = self.emitter3D:Add("effects/blooddrop",hitPos + hitNormal)
			splash:SetAngles(hitNormal:Angle())
			splash:SetStartSize(part:GetStartSize() * 0.65)
			splash:SetEndSize(part:GetStartSize() * 2 * velFac)
			splash:SetDieTime(part:GetDieTime() / 3)
			splash:SetColor(self.Color.r * math.Clamp(lVec.r, 0.3, 1), self.Color.g * math.Clamp(lVec.b, 0.05, 1), self.Color.b * math.Clamp(lVec.b, 0.025, 1))
			splash:SetLighting(false)

			local decalChance = math.min(sz * math.sqrt(velFac) / 6, 1)

			if math.Rand(0, 1) < decalChance then
				if (sc > 2) then
					local r, g, _ = myself:GetColor()
					local fx2 = EffectData()
					fx2:SetOrigin(hitPos)
					fx2:SetNormal(hitNormal)
					fx2:SetColor((g < r / 2) and BLOOD_COLOR_RED or BLOOD_COLOR_GREEN)
					util.Effect("BloodImpact", fx2)
					util.Decal((g < r / 2) and "blood" or "yellowblood",hitPos + hitNormal * 4, hitPos - hitNormal * 4)
				else
					local drop = self.emitter3D:Add("particle/smokesprites_000" .. math.random(1,9), hitPos + hitNormal)
					drop:SetAngles(hitNormal:Angle())
					drop:SetStartSize(part:GetStartSize() * 0.75)
					drop:SetEndSize(part:GetStartSize() * 1.25)
					drop:SetDieTime(part:GetDieTime() * 20)
					drop:SetColor(self.Color.r * math.Clamp(lVec.r, 0.3, 1), self.Color.g * math.Clamp(lVec.b, 0.05, 1), self.Color.b * math.Clamp(lVec.b, 0.025, 1))
					drop:SetLighting(false)
					drop:SetStartAlpha(255)
					drop:SetEndAlpha(255)
					drop:SetThinkFunction(dropDecay)
					drop:SetNextThink(CurTime() + drop:GetDieTime() - dropFade)
				end
			end

			if math.Rand(0, 1) < soundChance then
				sound.Play("LG.BloodDrop", hitPos)
				lastSound = CurTime()
			end

			if IsValid(part) then
				part:Remove()
			end
		end)
		part:SetLighting(false)
	end
end

function EFFECT:Think()
	if self.emitter and self.emitter:GetNumActiveParticles() <= 0 then
		self.emitter:Finish()
		local em2d = self.emitter3D
		timer.Simple(5, function()
			if IsValid(em2d) then
				em2d:Finish()
			end
		end)
		return false
	else
		return true
	end
end

function EFFECT:Render()
	return false
end