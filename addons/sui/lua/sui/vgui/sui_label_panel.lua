local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local LABEL_FONT = SUI.CreateFont("LabelPanel", "Roboto", 18)

local PANEL = {}

local add = function(s, c)
	if IsValid(s.pnl) then
		s.pnl:Remove()
	end

	local pnl = vgui.Create(c, s)
	s.pnl = pnl

	return pnl
end

function PANEL:Init()
	self.title = ""

	local label = self:Add(NAME .. ".Label")
	label:Dock(LEFT)
	self.label = label

	self:SetFont(LABEL_FONT)

	self:Dock(TOP)
	self:InvalidateLayout(true)
	self.Add = add
end

function PANEL:SetPanel(pnl)
	if IsValid(self.pnl) then
		self.pnl:Remove()
	end

	pnl:SetParent(self)
	self.pnl = pnl
end

function PANEL:SetLabel(lbl)
	self.title = lbl
	self:InvalidateLayout(true)
end

function PANEL:SetFont(font)
	self.font = font
	self.label:SetFont(font)
end

function PANEL:PerformLayout(w, h)
	local label = self.label
	local pnl = self.pnl

	local pnl_w, pnl_h = 0, 0
	if pnl then
		pnl_w, pnl_h = pnl:GetSize()
	end

	label:SetWide(w - pnl_w - 4)
	label:SetText(sui.wrap_text(self.title, self.font, w - pnl_w - 4))

	local _, _h = label:GetTextSize()
	self:SetTall(math.max(_h, pnl_h))

	if pnl then
		pnl:SetPos(w - pnl_w, h / 2 - pnl_h / 2)
	end
end

sui.register("LabelPanel", PANEL, "PANEL")