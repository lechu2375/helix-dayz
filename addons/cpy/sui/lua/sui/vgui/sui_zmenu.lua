local BSHADOWS = sui.BSHADOWS
local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local GetColor = SUI.GetColor

local RoundedBox = sui.TDLib.LibClasses.RoundedBox
local TextColor = sui.TDLib.LibClasses.TextColor

local OPTION_FONT = SUI.CreateFont("MenuOption", "Roboto Medium", 15, 500)

local PANEL = {}

AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu")
AccessorFunc(PANEL, "m_bDeleteSelf", "DeleteSelf")
AccessorFunc(PANEL, "m_iMinimumWidth", "MinimumWidth")
AccessorFunc(PANEL, "m_SetInternal", "Internal")

PANEL:SetIsMenu(true)
PANEL:SetDeleteSelf(true)

local pad = 4
local max_height = 300

local PerformLayout = function(s)
	local w, h = s:ChildrenSize()
	if h > SUI.Scale(max_height) then
		h = SUI.Scale(max_height)
	end
	s:SetSize(math.max(s:GetMinimumWidth(), w), h)
end

function PANEL:Init()
	self:GetCanvas():DockPadding(0, pad, 0, pad)
	self:SetMinimumWidth(SUI.Scale(100))
	self:SetKeyboardInputEnabled(false)
	self:SetTall(pad * 2)
	self:SetAlpha(0)
	self.tall = pad * 2
	RegisterDermaMenuForClose(self)
	self:On("PerformLayoutInternal", PerformLayout)
end

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen()

	BSHADOWS.BeginShadow()
		self:RoundedBox("Background", pad, x, y, w, h, GetColor("menu"))
	BSHADOWS.EndShadow(1, 3, 3)

	self:MoveToFront()
end

function PANEL:Open(x, y)
	self:SizeToChildren(true, false)

	local w, h = self:GetSize()
	if h > SUI.Scale(max_height) then
		h = SUI.Scale(max_height)
	end

	local internal = self:GetInternal()
	internal:On("OnRemove", function()
		self:Remove()
	end)
	if not x then
		x, y = internal:LocalToScreen(0, 0)
		y = y + (internal:GetTall() + 2)
	end

	if y + h > ScrH() then
		y = y - h
	end

	if x + w > ScrW() then
		x = x - w
	end

	if y < 1 then
		y = 1
	end

	if x < 1 then
		x = 1
	end

	self:SetPos(x, y)
	self:MakePopup()
	self:AlphaTo(255, 0.23)
	self:SetDrawOnTop(true)
	self:MoveToFront()
end

local option_OnMouseReleased = function(s, mousecode)
	if s.Depressed and mousecode == MOUSE_LEFT then
		CloseDermaMenus()
	end
	DButton.OnMouseReleased(s, mousecode)
end

function PANEL:AddOption(str, callback)
	local option = self:Add("DButton")
	option:Dock(TOP)
	option:SetFont(OPTION_FONT)
	option:SetText(str)
	option:SizeToContentsX(20)
	option:SizeToContentsY(10)
	option:InvalidateLayout(true)
	option.OnMouseReleased = option_OnMouseReleased

	function option:Paint(w, h)
		RoundedBox(self, "Background", 0, 0, 0, w, h, self.Hovered and GetColor("menu_option_hover") or GetColor("menu_option"))
		TextColor(self, self.Hovered and GetColor("menu_option_hover_text") or GetColor("menu_option_text"))
	end

	option.DoClick = callback

	self.tall = self.tall + option:GetTall()
	self:SetTall(self.tall)

	return option
end

function PANEL:AddSpacer()
	local spacer = self:Add("Panel")
	spacer:Dock(TOP)
	spacer:DockMargin(0, 1, 0, 1)
	spacer:SetTall(2)

	function spacer:Paint(w, h)
		RoundedBox(self, "Background", 0, 0, 0, w, h, GetColor("menu_spacer"))
	end

	spacer:InvalidateLayout(true)
end

sui.register("Menu", PANEL, NAME .. ".ScrollPanel")