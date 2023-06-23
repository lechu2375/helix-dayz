local IsValid = IsValid

local TDLib_Classes = sui.TDLib.LibClasses
local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local GetColor = SUI.GetColor

local Panel = {}

function Panel:Init()
	self.tabs = {}

	local tab_scroller = self:Add(NAME .. ".ScrollPanel")
	tab_scroller:Dock(LEFT)

	function tab_scroller:Paint(w, h)
		self:RoundedBox("Background", 1, 0, 0, w, h, GetColor("column_sheet_bar"))
	end

	self.tabs_wide = 48
	self.tab_scroller = tab_scroller

	self:ScaleChanged()
	SUI.OnScaleChanged(self, self.ScaleChanged)
end

function Panel:ScaleChanged()
	local tabs_wide = SUI.Scale(self.tabs_wide)
	self.tab_scroller:SetWide(tabs_wide)

	self:InvalidateLayout(true)

	local tabs = self.tabs
	for i = 1, #self.tabs do
		tabs[i].img:SetMinus(SUI.Scale(20))
	end
end

function Panel:Paint(w, h)
	self:RoundedBox("Background", 1, 0, 0, w, h, GetColor("column_sheet"))
end

local tab_DoClick = function(s)
	s.parent:SetActiveTab(s)
end

local tab_Paint = function(s, w, h)
	local cur_col
	if s.active then
		cur_col = GetColor("column_sheet_tab_active")
	elseif s.Hovered then
		cur_col = GetColor("column_sheet_tab_hover")
	else
		cur_col = GetColor("column_sheet_tab")
	end

	s:RoundedBox("Backgrounds", 0, 0, 0, w, h, cur_col)
end

local tab_OnRemove = function(s)
	table.RemoveByValue(s.parent.tabs, s)
end

function Panel:AddSheet(mat, load_func)
	local tab = self.tab_scroller:Add(NAME .. ".Button")
	tab:Dock(TOP)
	tab:SetText("")
	tab:SetTall(self.tabs_wide)

	tab.On = TDLib_Classes.On

	tab.DoClick = tab_DoClick
	tab.Paint = tab_Paint
	tab:On("OnRemove", tab_OnRemove)

	tab.parent = self
	tab.load_func = load_func

	local img = tab:Add(NAME .. ".Image")
	img:Dock(FILL)
	img:SetImage(mat)
	img:SetMinus(SUI.Scale(20))

	tab.img = img

	self.tab_scroller:AddItem(tab)

	if not self:GetActiveTab() then
		self:SetActiveTab(tab)
	end

	table.insert(self.tabs, tab)

	return tab
end

function Panel:GetActiveTab()
	return self.active_tab
end

function Panel:SetActiveTab(new_tab)
	if new_tab == self.active_tab then return end

	if not IsValid(new_tab.panel) then
		local panel = new_tab.load_func(self)
		panel:SetParent(self)
		panel:SetVisible(false)
		panel:SetAlpha(0)

		panel.tab = new_tab
		new_tab.panel = panel
	end

	local old_active_tab = self.active_tab
	local delay = 0
	if old_active_tab and IsValid(old_active_tab.panel) then
		old_active_tab.active = false
		delay = 0.2
		old_active_tab.panel:AlphaTo(0, delay, 0, function(_, p)
			if p:IsValid() then
				p:SetVisible(false)
			end
		end)
	end

	new_tab.active = true
	new_tab.panel:SetVisible(true)
	new_tab.panel:AlphaTo(255, 0.2, delay)
	self.active_tab = new_tab
end

sui.register("ColumnSheet", Panel, "EditablePanel")