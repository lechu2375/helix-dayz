local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name
local TDLib = sui.TDLib

local Panel = {}

sui.scaling_functions(Panel)

AccessorFunc(Panel, "m_bValue", "Value", FORCE_NUMBER)
AccessorFunc(Panel, "m_bMin", "Min", FORCE_NUMBER)
AccessorFunc(Panel, "m_bMax", "Max", FORCE_NUMBER)
AccessorFunc(Panel, "m_bDecimals", "Decimals", FORCE_NUMBER)

function Panel:Init()
	self:ScaleInit()

	self:SetMin(0)
	self:SetMax(10)
	self:SetValue(1)
	self:SetDecimals(1)

	self:SetSize(100, 12)

	self.rounded_box = {}

	self.Knob.circle = {}
	self.Knob.Paint = self.KnobPaint
	self:SetTrapInside(true)
end

function Panel:SetMinMax(min, max)
	self:SetMin(min)
	self:SetMax(max)
end

function Panel:TranslateValues(x, y)
	self:SetValue(self:GetMin() + (x * self:GetRange()))
	return self:GetFraction(), y
end

function Panel:GetFraction()
	return (self:GetValue() - self:GetMin()) / self:GetRange()
end

function Panel:SetValue(val)
	val = math.Clamp(val, self:GetMin(), self:GetMax())
	val = math.Round(val, self:GetDecimals())

	self.m_bValue = val
	self:SetSlideX((val - self:GetMin()) / self:GetRange())

	self:OnValueChanged(val)
end

function Panel:OnValueChanged(val)
end

function Panel:GetRange()
	return self:GetMax() - self:GetMin()
end

function Panel:Paint(w, h)
	local _h = SUI.Scale(2)
	TDLib.RoundedBox(self.rounded_box, 3, 0, h / 2 - _h / 2, w, _h, SUI.GetColor("slider_track"))
end

function Panel:KnobPaint(w, h)
	if self.Depressed then
		TDLib.DrawCircle(self.circle, w / 2, h / 2, h / 1.1, SUI.GetColor("slider_pressed"))
	elseif self.Hovered then
		TDLib.DrawCircle(self.circle, w / 2, h / 2, h / 1.1, SUI.GetColor("slider_hover"))
	end

	TDLib.DrawCircle(self.circle, w / 2, h / 2, h / 2, SUI.GetColor("slider_knob"))
end

function Panel:PerformLayout(w, h)
	self.Knob:SetSize(SUI.Scale(12), SUI.Scale(12))
	DSlider.PerformLayout(self, w, h)
end

sui.register("Slider", Panel, "DSlider")