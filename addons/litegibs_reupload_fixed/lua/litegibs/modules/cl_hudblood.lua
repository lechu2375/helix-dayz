--TODO: WASH IT OFF
LiteGibs.HUDBlood = LiteGibs.HUDBlood or {}

LiteGibs.HUDBlood.T = {
	--[[
	{
		["pos"] = {["x"]=0,["y"]=0},
		["angle"] = 0, --rotation
		["scale"] = 1, --portion of screen based on vertical axis
		["color"] = Color(),
		["death"] = CurTime()+5,--when it dies
		["fade"] = 1 --how long it takes to fade out
	}
	]]
}

local idcache = {}

local function DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )

	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )

	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )

end

function LiteGibs.HUDBlood.Render()
	local h = ScrH()
	for k, v in pairs(LiteGibs.HUDBlood.T) do
		if CurTime() > v.death then
			table.remove(LiteGibs.HUDBlood.T, k)
		else
			if not v.id then
				idcache[v.sprite] = idcache[v.sprite] or surface.GetTextureID(v.sprite)
				v.id = idcache[v.sprite]
			end
			surface.SetTexture(v.id)
			local a = v.color.a * math.Clamp( (v.death - CurTime()) / v.fade, 0, 1)
			surface.SetDrawColor(v.color.r,v.color.g,v.color.b,a)
			DrawTexturedRectRotatedPoint(v.pos.x,v.pos.y,v.scale * h, v.scale * h, v.angle, 0, 0)
		end
	end
end

function LiteGibs.HUDBlood.Clean()
	for _, v in pairs(LiteGibs.HUDBlood.T) do
		v.fade = 0.5
		v.death = math.min(v.death, CurTime() - v.fade)
	end
end

function LiteGibs.HUDBlood.CleanImmediate()
	table.Empty(LiteGibs.HUDBlood.T)
end

local maxdist = 96
local plyC

function LiteGibs.HUDBlood.FromDamage(damageAmount, damageType, damageVec, receiver, inflictor)
	if not LiteGibs.CVars.BloodScreenEnabled:GetBool() then return end
	if not IsValid(plyC) then
		plyC = LocalPlayer()

		return
	end

	if plyC:GetShootPos():Distance(damageVec) > maxdist then return end
	local c = receiver:GetBloodColorLG()
	local cTab = LiteGibs.HUDBlood.Colors[c]
	if not cTab then return end
	local typ = LiteGibs.HUDBlood.TYPE_GENERIC

	if bit.band(damageType, DMG_SLASH) == DMG_SLASH then
		typ = LiteGibs.HUDBlood.TYPE_SLASH
	elseif bit.band(damageType, DMG_CLUB) == DMG_CLUB or bit.band(damageType, DMG_CRUSH) == DMG_CRUSH then
		typ = LiteGibs.HUDBlood.TYPE_CLUB
	end

	if IsValid(inflictor) then
		typ = LiteGibs.HUDBlood.DamageTypes[inflictor:GetClass()] or typ
	end

	local sprTable = LiteGibs.HUDBlood.Sprites[typ]
	if not sprTable then return end
	local dist = plyC:GetShootPos():Distance(damageVec)
	local distFactor = dist / maxdist
	local splatterScale = math.Clamp(1 - distFactor, 0, 2.5) * (math.pow(damageAmount, 0.3) * 0.6)
	local t = {}
	--cam.Start3D(plyC:EyePos(),plyC:EyeAngles())
	t.pos = damageVec:ToScreen()
	local splatterRange = ScrH() * 0.25 * distFactor
	t.pos.x = math.Clamp(t.pos.x + math.Rand(-splatterRange,splatterRange), 0, ScrW())
	t.pos.y = math.Clamp(t.pos.y + math.Rand(-splatterRange,splatterRange), 0, ScrH())
	--cam.End3D()
	t.sprite = sprTable.path

	if sprTable.random then
		t.sprite = t.sprite .. tostring(sprTable.random_min, sprTable.random_max)
	end

	local r = cTab.r_min and math.Rand(cTab.r_min, cTab.r_max) or cTab.r
	local g = cTab.g_min and math.Rand(cTab.g_min, cTab.g_max) or cTab.g
	local b = cTab.b_min and math.Rand(cTab.b_min, cTab.b_max) or cTab.b
	t.color = Color(r, g, b, 192)
	t.angle = math.Rand(sprTable.angle_min, sprTable.angle_max)
	t.scale = math.Rand(sprTable.scale_min, sprTable.scale_max) * splatterScale
	t.death = CurTime() + math.sqrt(splatterScale + 0.5) * 0.3 + 0.5
	t.fade = (t.death - CurTime()) * 0.5
	LiteGibs.HUDBlood.T[#LiteGibs.HUDBlood.T + 1] = t
end

LiteGibs.HUDBlood.CleanImmediate()
hook.Add("HUDPaint", "LiteGibsHUD", LiteGibs.HUDBlood.Render)