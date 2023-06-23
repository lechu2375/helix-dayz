--TODO: WASH IT OFF
LiteGibs.WeaponBlood = LiteGibs.WeaponBlood or {}
LiteGibs.WeaponBlood.NeutralColor = Color(127,127,127,255)
local BLOOD_COLOR_SYNTH = BLOOD_COLOR_SYNTH or BLOOD_COLOR_ANTLION_WORKER + 2

local MYHOOK = "PostDrawEffects"
LiteGibs.WeaponBlood.RTCache = LiteGibs.WeaponBlood.RTCache or {}
local MatCache = {}
local rtSize = math.pow(2, math.floor(math.log(math.min(ScrW(), ScrH()), 2)))

local vmtParameters = {
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$translucent"] = 1
}

local function GenerateBloodMats()
	for _, v in pairs(LiteGibs.WeaponBlood.Decals) do
		for l, b in pairs(v) do
			if not b then
				local t = table.Copy(vmtParameters)
				t["$basetexture"] = Material(l):GetString("$basetexture") or "decals/blood1"
				v[l] = CreateMaterial("lgdecal" .. SysTime() .. l, "UnlitGeneric", t)
			end
		end
	end
end

local function RunOnNextDraw(func, ...)
	local id = util.CRC("LGWepBlood" .. tostring(SysTime()))
	local t = {...}

	hook.Add(MYHOOK, id, function()
		hook.Remove(MYHOOK, id)
		func(unpack(t))
	end)
end

local function ClearRT(rt)
	render.ClearRenderTarget(rt, color_white)
	render.PushRenderTarget(rt, 0, 0, rtSize, rtSize)
	cam.Start2D()
	render.Clear(0, 0, 0, 255, true, true)
	surface.SetDrawColor(128, 128, 128, 255)
	surface.DrawRect(-0, -0, rtSize, rtSize)
	cam.End2D()
	render.PopRenderTarget()
end

local function ApplyRTToMaterial(matName, rt)
	if not MatCache[matName] then
		local mat = Material(matName)
		MatCache[matName] = mat

		if not (mat:GetInt("$translucent") == 1 and mat:GetInt("$additive") == 1) then
			mat:SetTexture("$detail", rt)
			mat:SetFloat("$detailscale", 1)
			mat:SetFloat("$detailblendfactor", 1.5)
		end
	end
end

local function ApplyDecalToRT(rt, decalMat, decalX, decalY, decalSize, decalRot, tint)
	local texDim = rtSize * decalSize
	render.PushRenderTarget(rt, 0, 0, rtSize, rtSize)
	cam.Start2D()
	surface.SetMaterial(decalMat)
	if tint then
		surface.SetDrawColor(tint.r, tint.g, tint.b, tint.a)
	else
		surface.SetDrawColor(255, 255, 255, 255)
	end
	surface.DrawTexturedRectRotated(decalX, decalY, texDim, texDim, decalRot)
	cam.End2D()
	render.PopRenderTarget()
end

local function ApplyWeaponBlood(matTable, bloodTable, scale)
	local rt
	rtSize = math.pow(2, math.floor(math.log(math.min(ScrW(), ScrH()), 2)))
	local bMat = table.Random(bloodTable)
	local bloodSize = scale * math.Rand(0.8, 1.2)
	local bloodX = math.Rand(0, rtSize)
	local bloodY = math.Rand(0, rtSize)
	local rot = math.Rand(-180, 180)
	local mdl = {}

	for k, model in pairs(matTable) do
		if LiteGibs.WeaponBlood.RTCache[model] then
			rt = LiteGibs.WeaponBlood.RTCache[model]
		else
			rt = GetRenderTargetEx(model .. "lgDecals", rtSize, rtSize, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, TEXTUREFLAGS_ANISOTROPIC or 0, CREATERENDERTARGETFLAGS_AUTOMIPMAP, IMAGE_FORMAT_ABGR8888)
			ClearRT(rt)
			LiteGibs.WeaponBlood.RTCache[model] = rt
		end

		ApplyRTToMaterial(k, rt)
		mdl[model] = rt
	end

	for _, tmpRT in pairs(mdl) do
		ApplyDecalToRT(tmpRT, bMat, bloodX, bloodY, bloodSize, rot)
		--[[
		hook.Add("HUDPaint", "Test", function()
			render.DrawTextureToScreenRect(tmpRT, 0, 0, 512, 512)
		end)
		]]
		--
	end
end

local plyC = LocalPlayer()
local matTable = {}
local getMaterialsCache = {}

local function table_append(dest, source)
	table.insert(dest, source)
	return dest
end

function LiteGibs.WeaponBlood.FromDamage(damage, position, color)
	if not LiteGibs.CVars.BloodFPEnabled:GetBool() then return end
	--if true then return end
	if not IsValid(plyC) then
		plyC = LocalPlayer()

		return
	end

	GenerateBloodMats()
	local bloodTable = LiteGibs.WeaponBlood.Decals[color or BLOOD_COLOR_RED]

	if not bloodTable then
		print("LiteGibs: Unknown blood type " .. tostring(color) .. "!")
		return
	end

	local scale = 1 / math.max(position:Distance(plyC:EyePos()) * 0.5 - 32, 1) --1 / math.sqrt(math.max(position:Distance(EyePos()) - 32, 1))
	if (scale < 0.1) then return end
	scale = scale * math.sqrt(damage / 50)
	if (scale < 0.1) then return end
	--ApplyWeaponBlood(vm:GetModel(), matTable, bloodTable, scale)
	local mats
	local vm = plyC:GetViewModel()
	local vmodel
	table.Empty(matTable)

	if IsValid(vm) then
		for _, ent in ipairs(table_append(vm:GetChildren(), vm)) do
			vmodel = ent:GetModel()
			if not vmodel then goto CONTINUE end

			getMaterialsCache[vmodel] = getMaterialsCache[vmodel] or ent:GetMaterials()
			mats = getMaterialsCache[vmodel]

			for _, v in ipairs(mats) do
				matTable[v] = vmodel
			end

			::CONTINUE::
		end
	else
		return
	end

	local hands = plyC:GetHands()

	if IsValid(hands) then
		for _, ent in ipairs(table_append(hands:GetChildren(), hands)) do
			local hmodel = ent:GetModel()
			if not hmodel then goto CONTINUE end
			getMaterialsCache[hmodel] = getMaterialsCache[hmodel] or ent:GetMaterials()
			mats = getMaterialsCache[hmodel]

			for _, v in ipairs(mats) do
				matTable[v] = hmodel
			end

			::CONTINUE::
		end
	end

	local wep = plyC:GetActiveWeapon()

	if IsValid(wep) then
		local wmodel = wep:GetModel()
		getMaterialsCache[wmodel] = getMaterialsCache[wmodel] or wep:GetMaterials()
		mats = getMaterialsCache[wmodel]

		for _, v in ipairs(mats) do
			matTable[v] = vmodel
		end

		local vEls = wep.VElements

		if vEls then
			for _, v in pairs(vEls) do
				local mdl = v.curmodel

				if IsValid(mdl) and v.active~=false then
					local modelpath = v.model
					getMaterialsCache[modelpath] = getMaterialsCache[modelpath] or mdl:GetMaterials()
					mats = getMaterialsCache[modelpath]

					for _, b in ipairs(mats) do
						matTable[b] = modelpath
					end
				end
			end
		end
	end

	local count = 1

	while (scale >= 0.6) do
		scale = math.sqrt(scale * 1.7) / 1.7
		count = count + 1
	end

	for i = 1, count do
		RunOnNextDraw(ApplyWeaponBlood, matTable, bloodTable, scale or 1)
	end
end

function LiteGibs.WeaponBlood.Clear()
	for k, v in pairs(LiteGibs.WeaponBlood.RTCache) do
		--print("Clearing: " .. v:GetName())
		ClearRT(v)
	end
end

function LiteGibs.WeaponBlood.Clean(bigDecals, smallDecals)
	GenerateBloodMats()
	local bloodTable = LiteGibs.WeaponBlood.Decals[BLOOD_COLOR_SYNTH]
	local scale = 2
	for i=1, (bigDecals or 1) do
		for _, tmpRT in pairs(LiteGibs.WeaponBlood.RTCache) do
			local bMat = table.Random(bloodTable)
			local bloodSize = scale * math.Rand(0.8, 1.2)
			local bloodX = math.Rand(0, tmpRT:Width())
			local bloodY = math.Rand(0, tmpRT:Height())
			local rot = math.Rand(-180, 180)
			ApplyDecalToRT(tmpRT, bMat, bloodX, bloodY, bloodSize, rot, LiteGibs.WeaponBlood.NeutralColor)
		end
	end
	local scale = 1
	for i=1, (smallDecals or 2) do
		for _, tmpRT in pairs(LiteGibs.WeaponBlood.RTCache) do
			local bMat = table.Random(bloodTable)
			local bloodSize = scale * math.Rand(0.8, 1.2)
			local bloodX = math.Rand(0, tmpRT:Width())
			local bloodY = math.Rand(0, tmpRT:Height())
			local rot = math.Rand(-180, 180)
			ApplyDecalToRT(tmpRT, bMat, bloodX, bloodY, bloodSize, rot, LiteGibs.WeaponBlood.NeutralColor)
		end
	end
end

local lastAlive = false

hook.Add("PreRender", "LGDeathClearBlood", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	if ply:Alive() ~= lastAlive then
		lastAlive = ply:Alive()
		RunOnNextDraw(LiteGibs.WeaponBlood.Clear)
	end
end)

hook.Add("PreCleanupMap", "LGCleanupWepaonBlood", LiteGibs.WeaponBlood.Clear)