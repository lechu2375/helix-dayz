local math = math
local gui = gui
local draw = draw
local surface = surface

local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid
local ipairs = ipairs

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name
local TDLib = sui.TDLib

local FRAME_FONT = SUI.CreateFont("Frame", "Roboto", 18)

local Panel = FindMetaTable("Panel")

local PANEL = {}

AccessorFunc(PANEL, "m_bHeaderHeight", "HeaderHeight", FORCE_NUMBER)
AccessorFunc(PANEL, "m_bTitleFont", "TitleFont", FORCE_STRING)
AccessorFunc(PANEL, "m_bSizable", "Sizable", FORCE_BOOL)
AccessorFunc(PANEL, "m_iMinWidth", "MinWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iMinHeight", "MinHeight", FORCE_NUMBER)

local header_Think = function(s)
	local parent = s.parent
	local sw, sh = ScrW(), ScrH()

	if s.dragging then
		local x, y = input.GetCursorPos()
		x, y = math.Clamp(x, 1, sw - 1), math.Clamp(y, 1, sh - 1)
		x, y = x - s.dragging[1], y - s.dragging[2]

		parent:SetPos(x, y)
		parent:InvalidateLayout(true)
		parent:OnPosChanged()
	else
		local x, y, w, h = parent:GetBounds()
		parent:SetPos(math.Clamp(x, 5, sw - w - 5), math.Clamp(y, 5, sh - h - 5))
	end
end

local header_OnMousePressed = function(s)
	local parent = s.parent
	s.dragging = {gui.MouseX() - parent.x, gui.MouseY() - parent.y}
	s:MouseCapture(true)
end

local header_OnMouseReleased = function(s)
	s.dragging = nil
	s:MouseCapture(false)
end

local title_SetBGColor = function(s, c)
	s:SetVisible(c and true or false)
end

local title_update_color = function(s)
	s:SetTextColor(SUI.GetColor("title"))
end

local close_DoClick = function(s)
	s.frame:Remove()
end

function PANEL:Init()
	local header_buttons = {}
	self.header_buttons = header_buttons

	self:Center()
	self:SetHeaderHeight(28)

	local header = self:Add("PANEL")
	header:Dock(TOP)
	header.Paint = self.HeaderPaint
	header:SetCursor("sizeall")

	header.parent = self
	header.Think = header_Think
	header.OnMousePressed = header_OnMousePressed
	header.OnMouseReleased = header_OnMouseReleased
	self.header = header

	local title = header:Add(NAME .. ".Label")
	title:Dock(LEFT)
	title:DockMargin(6, 2, 0, 2)
	title:SetText("")
	title:SetTextColor(SUI.GetColor("title"))
	title:SizeToContents()
	title.SetBGColor = title_SetBGColor
	hook.Add(NAME .. ".ThemeChanged", title, title_update_color)
	self.title = title

	self.close = self:AddHeaderButton("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sui/close.png", "close", close_DoClick)
	self.close.frame = self

	self:SetSize(SUI.Scale(520), SUI.Scale(364))
	self:SetTitleFont(FRAME_FONT)
	SUI.OnScaleChanged(self, self.ScaleChanged)

	function self:PerformLayout(w, h)
		if IsValid(title) then
			title:SizeToContents()
		end

		if IsValid(header) then
			header:SetTall(SUI.Scale(self:GetHeaderHeight()))
		end

		for k, v in ipairs(header_buttons) do
			if IsValid(v) then
				v:SetWide(v:GetTall())
				local margin = SUI.Scale(4)
				v.image:DockMargin(margin, margin, margin, margin)
			end
		end
	end
end

function PANEL:SetSize(w, h)
	self.real_w, self.real_h = w, h
	self:ScaleChanged()
end

function PANEL:HeaderPaint(w, h)
	draw.RoundedBoxEx(3, 0, 0, w, h, SUI.GetColor("header"), true, true)
end

local SetSize = Panel.SetSize
PANEL.RealSetSize = SetSize
function PANEL:ScaleChanged()
	if self.sizing then return end

	local new_w, new_h = SUI.Scale(self.real_w), SUI.Scale(self.real_h)
	self.x, self.y = self.x + (self:GetWide() / 2 - new_w / 2), self.y + (self:GetTall() / 2 - new_h / 2)
	SetSize(self, new_w, new_h)
	self:InvalidateLayout(true)
end

function PANEL:Paint(w, h)
	if SUI.GetColor("frame_blur") then
		TDLib.BlurPanel(self)
	end

	self:RoundedBox("Background", 3, 0, 0, w, h, SUI.GetColor("frame"))
end

function PANEL:SetTitleFont(font)
	self.m_bTitleFont = font
	self.title:SetFont(font)
end

function PANEL:SetTitle(text)
	self.title:SetText(text)
	self.title:SizeToContents()
end

function PANEL:AddHeaderButton(image_name, name, callback)
	local button = self.header:Add("DButton")
	button:SetText("")
	button:Dock(RIGHT)
	button:DockMargin(0, 2, #self.header:GetChildren() == 1 and 4 or 2, 2)

	local hover = name .. "_hover"
	local press = name .. "_press"
	local circle = {}
	button.Paint = function(s, w, h)
		if s:IsHovered() then
			TDLib.DrawCircle(circle, w / 2, h / 2, w / 2, SUI.GetColor(hover))
		end

		if s.Depressed then
			TDLib.DrawCircle(circle, w / 2, h / 2, w / 2, SUI.GetColor(press))
		end
	end
	button.DoClick = callback

	local image = button:Add(NAME .. ".Image")
	image:Dock(FILL)
	image:SetMouseInputEnabled(false)
	image:SetImage(image_name)

	button.image = image

	table.insert(self.header_buttons, button)

	return button
end

function PANEL:OnMousePressed(_, checking)
	if not self.m_bSizable then return end

	local x, y = self:LocalToScreen(0, 0)
	local w, h = self:GetSize()
	if gui.MouseX() > (x + w - 20) and gui.MouseY() > (y + h - 20) then
		if not checking then
			self.sizing = {gui.MouseX() - w, gui.MouseY() - h}
			self:MouseCapture(true)
		end

		self:SetCursor("sizenwse")

		return
	end

	if checking then
		self:SetCursor("arrow")
	end
end

function PANEL:OnMouseReleased()
	if not self.m_bSizable then return end

	self:MouseCapture(false)
	SUI.CallScaleChanged()
	self.sizing = nil
end

function PANEL:Think()
	if not self.m_bSizable then return end

	self:OnMousePressed(nil, true)

	if not self.sizing then return end

	local sw, sh = ScrW(), ScrH()

	local cx, cy = input.GetCursorPos()
	local mousex = math.Clamp(cx, 1, sw - 1)
	local mousey = math.Clamp(cy, 1, sh - 1)

	local x = mousex - self.sizing[1]
	x = math.Clamp(x, self.m_iMinWidth, sw - 10)

	local y = mousey - self.sizing[2]
	y = math.Clamp(y, self.m_iMinHeight, sh - 10)

	self.real_w, self.real_h = x, y
	SetSize(self, x, y)
	self:InvalidateLayout(true)
	self:SetCursor("sizenwse")
end

function PANEL:OnPosChanged()
end

local SetVisible = Panel.SetVisible
local Remove = Panel.Remove

local anim_speed = 0.2

local show = function(s)
	local w, h = s.real_w, s.real_h

	if s.anim_scale then
		w, h = SUI.Scale(w), SUI.Scale(h)
	end

	SetVisible(s, true)

	SetSize(s, w * 1.1, h * 1.1)
	s:Center()

	s:Stop()
	s:SizeTo(w, h, anim_speed, 0, -1)
	s:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), anim_speed, 0, -1)
	s:AlphaTo(255, anim_speed + 0.02, 0)
	s:MakePopup()
end

local remove = function(s, hide)
	if not hide and not s:IsVisible() then
		Remove(s)
		return
	end

	local w, h = s.real_w, s.real_h

	if s.anim_scale then
		w, h = SUI.Scale(w), SUI.Scale(h)
	end

	w, h = w * 1.1, h * 1.1

	s:Stop()
	s:SizeTo(w, h, anim_speed, 0, -1)
	s:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), anim_speed, 0, -1)
	s:SetMouseInputEnabled(false)
	s:SetKeyboardInputEnabled(false)
	s:AlphaTo(0, anim_speed + 0.02, 0, function()
		if hide then
			SetVisible(s, false)
		else
			Remove(s)
		end
	end)
end

local hide = function(s)
	remove(s, true)
end

function PANEL:AddAnimations(w, h, no_scale)
	self.anim_scale = not no_scale
	self.real_w, self.real_h = w, h

	self:SetAlpha(0)
	show(self)

	self.Remove = remove
	self.Hide = hide
	self.Show = show
end

sui.register("Frame", PANEL, "EditablePanel")