local draw = draw
local render = render

local TDLib = sui.TDLib
local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local lerp_color = sui.lerp_color
local contrast_color = sui.contrast_color

local BUTTON_FONT = SUI.CreateFont("Button", "Roboto Medium", 16)

local color_white = color_white
local color_transparent = Color(0, 0, 0, 0)

local PANEL = {}

AccessorFunc(PANEL, "m_Background", "Background")
AccessorFunc(PANEL, "m_bContained", "Contained", FORCE_BOOL)

sui.TDLib.Install(PANEL)
sui.scaling_functions(PANEL)

PANEL:ClearPaint()
PANEL:SetContained(true)

local Panel = FindMetaTable("Panel")
local SetMouseInputEnabled = Panel.SetMouseInputEnabled
local IsMouseInputEnabled = Panel.IsMouseInputEnabled
local SetCursor = Panel.SetCursor
local SetContentAlignment = Panel.SetContentAlignment
function PANEL:Init()
	self:ScaleInit()

	self.vertices, self.vertices_2 = {}, {}

	SetMouseInputEnabled(self, true)
	SetCursor(self, "hand")
	SetContentAlignment(self, 5)

	self:SetSize(90, 30)
	self:SetFont(BUTTON_FONT)

	self:CircleClick(nil, 7)

	self.OldPaint, self.Paint = self.Paint, self.Paint2

	self.cur_col = Color(0, 0, 0, 0)
end

function PANEL:SetEnabled(b)
	SetMouseInputEnabled(self, b)
end

function PANEL:IsEnabled()
	return IsMouseInputEnabled(self)
end

function PANEL:ContainedPaint(w, h)
	local enabled = self:IsEnabled()
	local col
	if enabled then
		col = self:GetBackground() or SUI.GetColor("button")
		self:SetTextColor(SUI.GetColor("button_text"))
	else
		col = SUI.GetColor("button_disabled")
		self:SetTextColor(SUI.GetColor("button_disabled_text"))
	end
	self:RoundedBox("Background", 4, 0, 0, w, h, col)

	if not enabled then return end

	self.circle_click_color = SUI.GetColor("button_click")

	if self.Hovered or self.Selected then
		self:RoundedBox("Hover", 4, 0, 0, w, h, SUI.GetColor("button_hover"))
	end
end

function PANEL:SetColors(hover_color, text_color)
	self.hover = hover_color
	self.text_color = text_color
end

function PANEL:Paint2(w, h)
	if self:GetContained() then
		self:ContainedPaint(w, h)
		self:OldPaint(w, h)
		return
	end

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	TDLib.RoundedBox(self.vertices, 4, 0, 0, w, h, color_white)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	local cur_col = self.cur_col
	if self.Selected then
		lerp_color(cur_col, SUI.GetColor("button2_selected"))
	elseif self.Hovered then
		lerp_color(cur_col, self.hover or SUI.GetColor("button2_hover"))
	else
		lerp_color(cur_col, color_transparent)
	end

	TDLib.RoundedBox(self.vertices_2, 4, 0, 0, w, h, cur_col)

	if self.text_color then
		self.circle_click_color = self.text_color
		self:SetTextColor(self.text_color)
	else
		local col = contrast_color(cur_col)
		self.circle_click_color = col
		self:SetTextColor(col)
	end

	self:OldPaint(w, h)

	render.SetStencilEnable(false)
	render.ClearStencil()
end

sui.register("Button", PANEL, NAME .. ".Label")