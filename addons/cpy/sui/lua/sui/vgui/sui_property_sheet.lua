local draw = draw
local surface = surface
local vgui = vgui

local TYPE_MATERIAL = TYPE_MATERIAL

local RealFrameTime = RealFrameTime
local IsValid = IsValid
local Lerp = Lerp
local pairs = pairs
local TypeID = TypeID

local TDLib_Classes = sui.TDLib.LibClasses
local TextColor = TDLib_Classes.TextColor
local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local PROPERTY_SHEET_FONT = SUI.CreateFont("PropertySheet", "Roboto Regular", 18)

local PANEL = {}

AccessorFunc(PANEL, "m_FontName", "Font", FORCE_STRING)

function PANEL:Init()
	self.tabs = {}

	self:SetFont(PROPERTY_SHEET_FONT)

	local tab_scroller = self:Add("DHorizontalScroller")
	tab_scroller:Dock(TOP)

	self.tabs_tall = 26
	self.tab_scroller = tab_scroller

	self:ScaleChanged()
	SUI.OnScaleChanged(self, self.ScaleChanged)
end

function PANEL:ScaleChanged()
	self.tab_scroller:SetTall(SUI.Scale(self.tabs_tall))

	for k, v in pairs(self.tab_scroller.Panels) do
		if v:IsValid() then
			if v.Material then
				v:SetWide(self.tab_scroller:GetTall())
			else
				v:SizeToContentsX()
			end
		end
	end

	self:InvalidateLayout(true)
end

function PANEL:Paint(w, h)
	self:RoundedBox("Background", 1, 0, 0, w, self.tab_scroller:GetTall(), SUI.GetColor("property_sheet_bg"))
end

function PANEL:PaintOver(w, h)
	local active_tab = self:GetActiveTab()
	if not IsValid(active_tab) then return end

	local tab_scroller = self.tab_scroller
	local offset = tab_scroller:GetTall() - SUI.Scale(1)

	local x = active_tab:LocalToScreen(0) - self:LocalToScreen(0)

	if not self.activeTabX then
		self.activeTabX = x
		self.activeTabW = active_tab:GetWide()
	end

	local delta = RealFrameTime() * 6
	if delta then
		self.activeTabX = Lerp(delta, self.activeTabX, x)
		self.activeTabW = Lerp(delta, self.activeTabW, active_tab:GetWide())
	end

	self:RoundedBox("Background2", 1, self.activeTabX, tab_scroller.y + offset, self.activeTabW, SUI.Scale(1), SUI.GetColor("property_sheet_tab_active"))
end

local tab_Paint = function(s, w, h)
	s.circle_click_color = SUI.GetColor("property_sheet_tab_click")
	if s.property_sheet:GetActiveTab() == s then
		TextColor(s, SUI.GetColor("property_sheet_tab_active"))
	else
		TextColor(s, SUI.GetColor("property_sheet_tab"))
	end
end

local tab_DoClick = function(s)
	s.parent:SetActiveTab(s)
end

local image_paint = function(s, w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(s.Material)
	surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, w - 10, h - 10, 0)
end

function PANEL:AddSheet(name, load_func)
	local tab = vgui.Create("DButton")
	if TypeID(name) == TYPE_MATERIAL then
		tab:SetText("")
		tab.Material = name
		tab.Paint = image_paint
		tab:SetWide(self.tab_scroller:GetTall())
	else
		tab:SetFont(self:GetFont())
		tab:SetText(name)
		tab:SetTextInset(10, 0)
		tab:SizeToContentsX()

		tab.Paint = tab_Paint
	end

	tab.parent = self
	tab.DoClick = tab_DoClick

	tab.load_func = load_func
	tab.property_sheet = self

	tab.On = TDLib_Classes.On
	TDLib_Classes.CircleClick(tab)

	self.tab_scroller:AddPanel(tab)

	if not self:GetActiveTab() then
		self:SetActiveTab(tab)
	end

	table.insert(self.tabs, tab)

	return tab
end

function PANEL:GetActiveTab()
	return self.active_tab
end

function PANEL:SetActiveTab(new_tab)
	if IsValid(new_tab) and not IsValid(new_tab.panel) then
		local panel = new_tab.load_func(self)
		panel:SetParent(self)
		panel:SetVisible(false)

		panel.tab = new_tab
		new_tab.panel = panel
	end

	if self.active_tab and IsValid(self.active_tab.panel) then
		self.active_tab.panel:SetVisible(false)
	end

	if IsValid(new_tab) then
		new_tab.panel:SetVisible(true)
	end

	self.active_tab = new_tab
end

sui.register("PropertySheet", PANEL, "EditablePanel")