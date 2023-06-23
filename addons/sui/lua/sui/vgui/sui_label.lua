local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name
local MOUSE_LEFT = MOUSE_LEFT

local SysTime = SysTime

local PANEL = {}

AccessorFunc(PANEL, "m_colText", "TextColor")
AccessorFunc(PANEL, "m_colTextStyle", "TextStyleColor")
AccessorFunc(PANEL, "m_FontName", "Font")

AccessorFunc(PANEL, "m_bDoubleClicking", "DoubleClickingEnabled", FORCE_BOOL)
AccessorFunc(PANEL, "m_bAutoStretchVertical", "AutoStretchVertical", FORCE_BOOL)
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)

AccessorFunc(PANEL, "m_bBackground", "PaintBackground",	FORCE_BOOL)
AccessorFunc(PANEL, "m_bBackground", "DrawBackground",	FORCE_BOOL)
AccessorFunc(PANEL, "m_bDisabled", "Disabled", FORCE_BOOL)

AccessorFunc(PANEL, "m_bIsToggle", "IsToggle", FORCE_BOOL)
AccessorFunc(PANEL, "m_bToggle", "Toggle", FORCE_BOOL)

AccessorFunc(PANEL, "m_bBright", "Bright", FORCE_BOOL)
AccessorFunc(PANEL, "m_bDark", "Dark", FORCE_BOOL)
AccessorFunc(PANEL, "m_bHighlight",	"Highlight", FORCE_BOOL)

PANEL:SetIsToggle(false)
PANEL:SetToggle(false)
PANEL:SetDisabled(false)
PANEL:SetDoubleClickingEnabled(true)

local Panel = FindMetaTable("Panel")
local SetMouseInputEnabled = Panel.SetMouseInputEnabled
local SetPaintBackgroundEnabled = Panel.SetPaintBackgroundEnabled
local SetPaintBorderEnabled = Panel.SetPaintBorderEnabled
local InvalidateLayout = Panel.InvalidateLayout
local SetFGColor = Panel.SetFGColor
function PANEL:Init()
	SetMouseInputEnabled(self, false)
	SetPaintBackgroundEnabled(self, false)
	SetPaintBorderEnabled(self, false)
end

function PANEL:AllowScale()
	SUI.OnScaleChanged(self, self.ScaleChanged)
end

function PANEL:ScaleChanged()
	self:SizeToContents()
end

function PANEL:SetFont(font)
	if self.m_FontName == font then return end

	self.m_FontName = font
	self:SetFontInternal(self.m_FontName)
end

function PANEL:SetTextColor(col)
	if self.m_colText == col then return end

	self.m_colText = col
	SetFGColor(self, col.r, col.g, col.b, col.a)
end
PANEL.SetColor = PANEL.SetTextColor

function PANEL:GetColor()
	return self.m_colText or self.m_colTextStyle
end

function PANEL:Toggle()
	if not self:GetIsToggle() then return end

	self:SetToggle(not self:GetToggle())
	self:OnToggled(self:GetToggle())
end

function PANEL:SetDisabled(bDisabled)
	self.m_bDisabled = bDisabled
	InvalidateLayout(self)
end

function PANEL:SetEnabled(bEnabled)
	self:SetDisabled(not bEnabled)
end

function PANEL:IsEnabled()
	return not self:GetDisabled()
end

function PANEL:ApplySchemeSettings()
	local col = self:GetColor()
	if not col then return end

	self:SetFGColor(col.r, col.g, col.b, col.a)
end

function PANEL:AutoStretchVerticalThink()
	self:SizeToContentsY()
end

function PANEL:SetAutoStretchVertical(enable)
	self.m_bAutoStretchVertical = enable
	self.Think = enable and self.AutoStretchVerticalThink or nil
end

function PANEL:OnCursorEntered()
	InvalidateLayout(self, true)
end

function PANEL:OnCursorExited()
	InvalidateLayout(self, true)
end

function PANEL:OnMousePressed(mousecode)
	if self:GetDisabled() then return end

	if mousecode == MOUSE_LEFT and not dragndrop.IsDragging() and self.m_bDoubleClicking then
		if self.LastClickTime and SysTime() - self.LastClickTime < 0.2 then

			self:DoDoubleClickInternal()
			self:DoDoubleClick()
			return
		end

		self.LastClickTime = SysTime()
	end

	if self:IsSelectable() and mousecode == MOUSE_LEFT and input.IsShiftDown() then
		return self:StartBoxSelection()
	end

	self:MouseCapture(true)
	self.Depressed = true
	self:OnDepressed()
	InvalidateLayout(self, true)

	self:DragMousePress(mousecode)
end

function PANEL:OnMouseReleased(mousecode)
	self:MouseCapture(false)

	if self:GetDisabled() then return end
	if not self.Depressed and dragndrop.m_DraggingMain ~= self then return end

	if self.Depressed then
		self.Depressed = nil
		self:OnReleased()
		InvalidateLayout(self, true)
	end

	if self:DragMouseRelease(mousecode) then return end

	if self:IsSelectable() and mousecode == MOUSE_LEFT then
		local canvas = self:GetSelectionCanvas()
		if canvas then
			canvas:UnselectAll()
		end
	end

	if not self.Hovered then return end

	self.Depressed = true

	if mousecode == MOUSE_RIGHT then
		self:DoRightClick()
	end

	if mousecode == MOUSE_LEFT then
		self:DoClickInternal()
		self:DoClick()
	end

	if mousecode == MOUSE_MIDDLE then
		self:DoMiddleClick()
	end

	self.Depressed = nil
end

function PANEL:OnReleased()
end

function PANEL:OnDepressed()
end

function PANEL:OnToggled(bool)
end

function PANEL:DoClick()
	self:Toggle()
end

function PANEL:DoRightClick()
end

function PANEL:DoMiddleClick()
end

function PANEL:DoClickInternal()
end

function PANEL:DoDoubleClick()
end

function PANEL:DoDoubleClickInternal()
end

sui.register("Label", PANEL, "Label")