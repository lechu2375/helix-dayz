local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local TEXT_FONT = SUI.CreateFont("ComboBox", "Roboto Regular", 16)

local GetColor = SUI.GetColor
local draw_material = sui.draw_material

local PANEL = {}

PANEL.NoOverrideClear = true

sui.scaling_functions(PANEL)

function PANEL:Init()
	self:ScaleInit()
	self.DropButton:Remove()
	self:SetFont(TEXT_FONT)
	self:SetSize(34, 22)
	self:SetIsMenu(true)

	local image = self:Add(NAME .. ".Image")
	image:Dock(FILL)
	image:SetImage("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sui/arrow.png")
	image.Draw = self.Paint
end

function PANEL:OpenMenu(pControlOpener)
	if pControlOpener and pControlOpener == self.TextEntry then return end
	if #self.Choices == 0 then return end

	if IsValid(self.Menu) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Menu = vgui.Create(NAME .. ".Menu", self)
	self.Menu:SetInternal(self)

	for k, v in ipairs(self.Choices) do
		self.Menu:AddOption(v, function()
			self:ChooseOption(v, k)
		end)
	end

	local x, y = self:LocalToScreen(0, self:GetTall())
	self.Menu:SetMinimumWidth(self:GetWide())
	self.Menu:Open(x, y, false, self)
end

function PANEL:Paint(w, h, from_image)
	local text_color = GetColor("menu_option_hover_text")

	if from_image then
		local size = SUI.ScaleEven(10)
		draw_material(nil, w - (size / 2) - 6, h / 2, size, text_color)
	else
		local col = GetColor("menu")
		self:RoundedBox("Background", 4, 0, 0, w, h, col)
		self:SetTextColor(text_color)
	end
end

function PANEL:PerformLayout()
end

sui.register("ComboBox", PANEL, "DComboBox")