local ScrW = ScrW
local ScrH = ScrH

local sin = math.sin
local cos = math.cos
local rad = math.rad
local ceil = math.ceil

local Start2D = cam.Start2D
local End2D = cam.End2D

local PushRenderTarget = render.PushRenderTarget
local OverrideAlphaWriteEnable = render.OverrideAlphaWriteEnable
local Clear = render.Clear
local CopyRenderTargetToTexture = render.CopyRenderTargetToTexture
local BlurRenderTarget = render.BlurRenderTarget
local PopRenderTarget = render.PopRenderTarget
local SetMaterial = render.SetMaterial
local DrawScreenQuadEx = render.DrawScreenQuadEx
local DrawScreenQuad = render.DrawScreenQuad

local RenderTarget, RenderTarget2
local load_render_targets = function()
	local w, h = ScrW(), ScrH()
	RenderTarget = GetRenderTarget("sui_bshadows_original" .. w .. h, w, h)
	RenderTarget2 = GetRenderTarget("sui_bshadows_shadow" .. w .. h,  w, h)
end
load_render_targets()
hook.Add("OnScreenSizeChanged", "SUI.BShadows", load_render_targets)

local ShadowMaterial = CreateMaterial("sui_bshadows", "UnlitGeneric", {
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["alpha"] = 1
})

local ShadowMaterialGrayscale = CreateMaterial("sui_bshadows_grayscale", "UnlitGeneric", {
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$alpha"] = 1,
	["$color"] = "0 0 0",
	["$color2"] = "0 0 0"
})

local SetTexture = ShadowMaterial.SetTexture

local BSHADOWS = {}

BSHADOWS.BeginShadow = function()
	PushRenderTarget(RenderTarget)

	OverrideAlphaWriteEnable(true, true)
	Clear(0, 0, 0, 0)
	OverrideAlphaWriteEnable(false, false)

	Start2D()
end

BSHADOWS.EndShadow = function(intensity, spread, blur, opacity, direction, distance, _shadowOnly)
	opacity = opacity or 255
	direction = direction or 0
	distance = distance or 0

	CopyRenderTargetToTexture(RenderTarget2)

	if blur > 0 then
		OverrideAlphaWriteEnable(true, true)
		BlurRenderTarget(RenderTarget2, spread, spread, blur)
		OverrideAlphaWriteEnable(false, false)
	end

	PopRenderTarget()

	SetTexture(ShadowMaterial, "$basetexture", RenderTarget)
	SetTexture(ShadowMaterialGrayscale, "$basetexture", RenderTarget2)

	local xOffset = sin(rad(direction)) * distance
	local yOffset = cos(rad(direction)) * distance

	SetMaterial(ShadowMaterialGrayscale)
	for i = 1, ceil(intensity) do
		DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
	end

	if not _shadowOnly then
		SetTexture(ShadowMaterial, "$basetexture", RenderTarget)
		SetMaterial(ShadowMaterial)
		DrawScreenQuad()
	end

	End2D()
end

sui.BSHADOWS = BSHADOWS