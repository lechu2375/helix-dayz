local gravvar = GetConVar("sv_gravity")
local m_Rand = math.Rand
local BLOOD_COLOR_SYNTH = BLOOD_COLOR_SYNTH or BLOOD_COLOR_ANTLION_WORKER + 2

EFFECT.Colors = {
	[BLOOD_COLOR_RED] = Color(96, 8, 0, 128),
	[BLOOD_COLOR_GREEN] = Color(96, 128, 8, 128),
	[BLOOD_COLOR_YELLOW] = Color(128, 128, 8, 128),
	[BLOOD_COLOR_ANTLION] = Color(96, 128, 8, 128),
	[BLOOD_COLOR_SYNTH] = Color(200,200,200, 128)
}

EFFECT.ParticleCount = 15
EFFECT.Size = 5
EFFECT.SizeEnd = 20
EFFECT.Velocity = 20
EFFECT.Life = 0.3
local upVec = Vector(0, 0, 1)

function EFFECT:Init(data)
	if not LiteGibs or not LiteGibs.Ragdolls then return end
	--if not LiteGibs.CVars.BloodSprayEnabled:GetBool() then return end
	self.Color = self.Colors[data:GetColor() or BLOOD_COLOR_RED] or self.Colors[BLOOD_COLOR_RED]
	self.Pos = data:GetOrigin()
	self.emitter = ParticleEmitter(self.Pos)
	self.Scale = data:GetScale()
	self.Grav = Vector(0, 0, -gravvar:GetFloat())
	self.DieTime = CurTime() + 5
	self.LastBleed = 0
	local lVec = render.ComputeLighting(self.Pos, upVec)
	local avg = math.Clamp((lVec.r + lVec.g + lVec.b) / 3, 0.2, 0.8) / 0.8
	lVec.r = avg
	lVec.g = avg
	lVec.b = avg

	for i = 1, self.ParticleCount * math.sqrt(self.Scale) do
		local part = self.emitter:Add("particle/smokesprites_000" .. math.random(1, 9), self.Pos)
		part:SetVelocity(VectorRand() * self.Velocity * math.sqrt(self.Scale))
		part:SetDieTime(m_Rand(self.Life * 0.5, self.Life))
		part:SetStartAlpha(math.Rand(self.Color.a * 0.5, self.Color.a))
		part:SetEndAlpha(0)
		local sz = m_Rand(self.Size / 2, self.Size) * self.Scale
		part:SetStartSize(sz)
		part:SetEndSize(sz * self.SizeEnd / self.Size)
		part:SetRoll(math.Rand(-math.pi, math.pi))
		part:SetCollide(true)
		part:SetBounce(0)
		part:SetAirResistance(20)
		part:SetColor(math.Rand(self.Color.r * 0.7, self.Color.r) * math.Clamp(lVec.r, 0.3, 1), math.Rand(self.Color.g * 0.7, self.Color.g) * math.Clamp(lVec.b, 0.05, 1), math.Rand(self.Color.b * 0.7, self.Color.b) * math.Clamp(lVec.b, 0.025, 1))
		part:SetLighting(false)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	return false
end