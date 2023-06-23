local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "logging")
	else
		return GAS:PhraseFormat(phrase, "logging", ...)
	end
end

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
	self:Dock(TOP)
	self:SetTall(32 + 3 + 3)
	self:DockPadding(3,3,3,3)
	self:DockMargin(0,0,0,5)

	self.Color = Color(255,255,255)

	self.Label = vgui.Create("DLabel", self)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
	self.Label:Dock(FILL)
	self.Label:SetContentAlignment(5)
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:DockMargin(5,0,5,0)
end

function PANEL:SetAccountID(account_id)
	local steamid64 = GAS:AccountIDToSteamID64(account_id)

	self.AccountID = account_id

	self.AvatarImage = vgui.Create("AvatarImage", self)
	self.AvatarImage:SetMouseInputEnabled(false)
	self.AvatarImage:Dock(LEFT)
	self.AvatarImage:SetSize(32,32)
	self.AvatarImage:SetSteamID(steamid64, 32)
	self.Label:SetContentAlignment(4)

	self:UpdateTooltip()
end

function PANEL:SetColor(col)
	self.Color = col
end

function PANEL:SetTextColor(col)
	self.Label:SetTextColor(col)
	self:UpdateTooltip()
end

function PANEL:SetValue(val)
	self.Value = val
	self.Label:SetText(val)
	self:UpdateTooltip()
end

function PANEL:SetText(text)
	self.Label:SetText(text)
	self:UpdateTooltip()
end

function PANEL:GetValue()
	return self.Value
end

function PANEL:UpdateTooltip()
	if (self.AccountID ~= nil) then
		bVGUI.UnattachTooltip(self)
		bVGUI.PlayerTooltip.Attach(self, {
			account_id = self.AccountID,
			creator = self,
			focustip = L"right_click_to_focus",
		})
	else
		bVGUI.AttachTooltip(self, {
			Text = self.Label:GetText(),
			TextColor = self.Label:GetTextColor()
		})
	end
end

function PANEL:OnMouseReleased(m)
	if (m == MOUSE_LEFT) then
		GAS:PlaySound("delete")
		self:GetParent():RemoveItem(self)
	elseif (m == MOUSE_RIGHT and self.AccountID ~= nil) then
		bVGUI.PlayerTooltip.Focus()
	end
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
	surface.DrawRect(0,0,w,h)

	surface.SetDrawColor(self.Color)
	for i=0,2 do
		surface.DrawOutlinedRect(i,i,w - (i * 2),h - (i * 2))
	end
end

derma.DefineControl("GAS.Logging.AdvancedSearchItem", nil, PANEL, "bVGUI.BlankPanel")