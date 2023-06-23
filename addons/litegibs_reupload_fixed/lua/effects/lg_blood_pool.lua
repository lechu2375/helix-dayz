local gravvar = GetConVar("sv_gravity")
local svc = GetConVar("sv_cheats")
local hts = GetConVar("host_timescale")
local m_Rand = math.Rand
local BLOOD_COLOR_SYNTH = BLOOD_COLOR_SYNTH or BLOOD_COLOR_ANTLION_WORKER + 2

EFFECT.Colors = {
	[BLOOD_COLOR_RED] = Color(96, 8, 0, 128),
	[BLOOD_COLOR_GREEN] = Color(96, 128, 8, 128),
	[BLOOD_COLOR_YELLOW] = Color(128, 128, 8, 128),
	[BLOOD_COLOR_ANTLION] = Color(96, 128, 8, 128),
	[BLOOD_COLOR_SYNTH] = Color(200,200,200, 128)
}

EFFECT.ParticleCount = 20
EFFECT.Size = 5
EFFECT.SizeEnd = 40
EFFECT.SizeEndSplat = 5
EFFECT.SizeRate = 0.4
EFFECT.SizeRateSplat = 2.5
EFFECT.Velocity = 10
EFFECT.Life = 15
EFFECT.LifeSplat = 15
EFFECT.Fade = 5
EFFECT.BonePositionVariation = 5

EFFECT.Dripping = false
EFFECT.DecalNormal = Vector(0,0,1)

EFFECT.Decal = false
EFFECT.DecalThreshold = 15 --size*scale
EFFECT.DecalChance = 0.5

local upVec = Vector(0, 0, 1)

local id = 0

local MatCache = {}
local MatCacheDecal = {}

for i=1,2 do
	MatCache[i] = CreateMaterial(util.CRC("LiteGibsBPFX2") .. i,"UnlitGeneric",{
		["$basetexture"] = Material("particle/smokesprites_000" .. i):GetString("$basetexture"),
		["$translucent"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1"
	})
end
for i = 1,8 do
	MatCacheDecal[i] = CreateMaterial(util.CRC("LiteGibsBPDecal2") .. i,"UnlitGeneric",{
		["$basetexture"] = Material("decals/blood" .. i):GetString("$basetexture"),
		["$translucent"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1"
	})
end

function EFFECT:Init(data)
	if not LiteGibs or not LiteGibs.Ragdolls then return end
	id = id + 1
	self.z = (id % 10) / 100
	--if not LiteGibs.CVars.BloodSprayEnabled:GetBool() then return end
	self.Color = self.Colors[data:GetColor() or BLOOD_COLOR_RED] or self.Colors[BLOOD_COLOR_RED]
	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()
	self.Scale = data:GetScale()
	self.size = self.Size * self.Scale
	self.Grav = Vector(0, 0, -gravvar:GetFloat())
	local lVec = render.ComputeLighting(self.Pos, upVec)
	local avg = math.Clamp((lVec.r + lVec.g + lVec.b) / 3, 0.2, 0.8) / 0.8
	lVec.r = avg
	lVec.g = avg
	lVec.b = avg
	self.FinalColor = Color(math.Rand(self.Color.r * 0.7, self.Color.r) * math.Clamp(lVec.r, 0.3, 1), math.Rand(self.Color.g * 0.7, self.Color.g) * math.Clamp(lVec.b, 0.05, 1), math.Rand(self.Color.b * 0.7, self.Color.b) * math.Clamp(lVec.b, 0.025, 1))
	self.Bleeding = true
	self.Roll = math.Rand(-math.pi / 2, math.pi / 2)
	self.targentindex = math.Round(data:GetFlags())
	self.targent = LiteGibs.Ragdolls[self.targentindex]
	self.targbone = math.Round(data:GetMagnitude())
	self.NoTarget = math.Round(data:GetAttachment()) == LiteGibs.Bones.NoTarget
	if self.NoTarget then
		self.SizeEnd = self.SizeEndSplat
		self.SizeRate = self.SizeRateSplat
		self.Life = self.LifeSplat
	end

	local ogLife = self.Life
	local ct = CurTime()
	self.Life = self.Life * math.sqrt(self.Scale / 2)
	timer.Simple(math.min(self.Life-self.Fade,0.1), function()
		if self and self.Bleeding and not self.NoTarget then
			self.Scale = math.max(self.Scale, math.sqrt(self.Scale))
			self.Life = ogLife
			self.DieTime = ct + self.Life
		end
	end)

	self.Sprite = MatCache[math.random(1,8)]
	if math.abs(self.Normal:Dot(self.DecalNormal)) < 0.3 then
		self.Dripping = true
		self.SizeEnd = self.SizeEnd * 2
		self.Grav = self.Grav * 0.01
		if self.NoTarget then
			self.Sprite = MatCacheDecal[math.random(1,8)]
		end
	end

	if self.targbone < 0 then
		self.targbone = 0
	end
	self.DieTime = ct + self.Life

	if not IsValid(self.targent) then return end
	self.StartBonePos = self.targent:GetBonePosition(self.targbone)
end

function EFFECT:GetTimeScale()
	local ts = game.GetTimeScale()

	if svc and svc:GetBool() then
		ts = ts * hts:GetFloat()
	end

	return ts
end

local imats = {}

function EFFECT:Think()
	local t = FrameTime() * self:GetTimeScale()

	local tr = {
		["start"] = self:GetPos(),
		["endpos"] = self:GetPos() + self.Grav * t,
		["filter"] = function(ent)
			if ent:IsPlayer() or ent:IsNPC() then return false end

			return true
		end
	}
	local traceres = util.TraceLine(tr)
	if self.Dripping then
		self.Grav = LerpVector(t,self.Grav,vector_origin)
	else
		self.Normal = traceres.HitNormal
	end
	if traceres.HitSky then
		self:Remove()
		return false
	end
	self:SetPos(self:GetPos() + (traceres.HitPos - traceres.StartPos) * math.Clamp(traceres.Fraction, 0, 1))

	if not self.NoTarget then
		if IsValid(self.targent) then
			if self.targent:GetBonePosition(self.targbone) and self.targent:GetBonePosition(self.targbone):Distance(self.StartBonePos) > self.BonePositionVariation then
				self.Bleeding = false
			end
		else
			self.Bleeding = false
		end
	end

	if self.Bleeding then
		self.size = Lerp(FrameTime() * self.SizeRate, self.size, self.SizeEnd * self.Scale)
	end

	if self.size > self.DecalThreshold and CurTime() > self.DieTime - self.Fade and not self.Decal then
		self.Decal = true
		local r = self.Color.r
		local g = self.Color.g
		local b = self.Color.b
		local mat = ( g < r / 2 ) and "Blood" or "yellowblood"
		if math.Rand(0,1) < self.DecalChance and b < g * 0.8 then
			imats[mat] = imats[mat] or Material(string.Replace(util.DecalMaterial(mat),"_subrect",""))
			local imat = imats[mat]
			local tres = util.QuickTrace(self:GetPos(),self.Normal * -128)
			local decalscale = math.sqrt(self.size) * 0.1

			if self.size > 45 then
				util.Decal(mat, self:GetPos() + self.Normal * 4, self:GetPos() - self.Normal * 4)
			end

			if IsValid(tres.Entity) then
				util.DecalEx(imat, tres.Entity, tres.HitPos, tres.HitNormal, color_white, decalscale * math.Rand(0.8,1), decalscale * math.Rand(0.8,1))
			end
		end
	end

	if CurTime() > self.DieTime then return false end

	return true
end

function EFFECT:FadeOut()
	if not self.FadingOut then
		self.FadingOut = true
		self.DieTime = CurTime() - self.Fade
	end
end

function EFFECT:Render()
	if self.Sprite then
		render.SetMaterial(self.Sprite)
		render.DrawQuadEasy(self:GetPos() + self.z * self.Normal, self.Normal or upVec, self.size, self.size, ColorAlpha(self.FinalColor, math.Clamp((self.DieTime - CurTime()) / self.Fade, 0, 1) * 255), self.Roll)
	end
end