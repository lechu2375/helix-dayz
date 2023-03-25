local surface = surface

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local NUMBER_SLIDER_FONT = SUI.CreateFont("NumberSlider", "Roboto Regular", 14)

local PANEL = {}

sui.scaling_functions(PANEL)

function PANEL:Init()
	self:ScaleInit()

	local slider = vgui.Create(NAME .. ".Slider", self, "NumberSlider")
	slider:Dock(FILL)

	self.slider = slider

	local label = self:Add(NAME .. ".Label")
	label:Dock(RIGHT)
	label:DockMargin(3, 0, 0, 0)
	label:SetFont(NUMBER_SLIDER_FONT)
	self.label = label

	function label:Think()
		self:SetText(slider:GetValue())

		self:SizeToContents()
	end

	self:SetSize(100, 12)
	self:InvalidateLayout(true)
end

sui.register("NumberSlider", PANEL, "Panel")