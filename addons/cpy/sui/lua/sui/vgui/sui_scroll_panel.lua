local math = math
local table = table

local pairs = pairs
local RealFrameTime = RealFrameTime

local TDLib = sui.TDLib
local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name
local RoundedBox = sui.TDLib.LibClasses.RoundedBox

local Panel = {}

AccessorFunc(Panel, "m_bFromBottom", "FromBottom", FORCE_BOOL)
AccessorFunc(Panel, "m_bVBarPadding", "VBarPadding", FORCE_NUMBER)

Panel:SetVBarPadding(0)

Panel.NoOverrideClear = true

-- VBar
local starting_scroll_speed = 3

local vbar_OnMouseWheeled = function(s, delta)
	s.scroll_speed = s.scroll_speed + (14 * RealFrameTime() --[[ slowly increase scroll speed ]])
	s:AddScroll(delta * -s.scroll_speed)
end

-- default set scroll clamps amount
local vbar_SetScroll = function(s, amount)
	if not s.Enabled then s.Scroll = 0 return end

	s.scroll_target = amount
	s:InvalidateLayout()
end

-- ¯\_(ツ)_/¯ https://github.com/Facepunch/garrysmod/blob/cd3d894288b847e3d081570129963d4089e36261/garrysmod/lua/vgui/dvscrollbar.lua#L234
local vbar_OnCursorMoved = function(s, _, y)
	if s.Dragging then
		y = y - s.HoldPos
		y = y / (s:GetTall() - s:GetWide() * 2 - s.btnGrip:GetTall())
		s.scroll_target = y * s.CanvasSize
	end
end

local vbar_Think = function(s)
	local frame_time = RealFrameTime() * 14
	local scroll_target = s.scroll_target

	s.Scroll = Lerp(frame_time, s.Scroll, scroll_target)

	if not s.Dragging then
		s.scroll_target = Lerp(frame_time, scroll_target, math.Clamp(scroll_target, 0, s.CanvasSize))
	end

	-- now start slowing it down!!!
	s.scroll_speed = Lerp(frame_time / 14, s.scroll_speed, starting_scroll_speed)
end

local vbar_Paint = function(s, w, h)
	TDLib.RoundedBox(s.vertices, 3, 0, 0, w, h, SUI.GetColor("scroll"))
end

local vbarGrip_Paint = function(s, w, h)
	TDLib.RoundedBox(s.vertices, 3, 0, 0, w, h, SUI.GetColor("scroll_grip"))
end

local vbar_PerformLayout = function(s, w, h)
	local scroll = s:GetScroll() / s.CanvasSize
	local bar_size = math.max(s:BarScale() * h, 10)

	local track = (h - bar_size) + 1
	scroll = scroll * track

	s.btnGrip.y = scroll
	s.btnGrip:SetSize(w, bar_size)
end
--

function Panel:Init()
	local canvas = self:GetCanvas()
	canvas:SUI_TDLib()

	local children = {}
	function canvas:OnChildAdded(child)
		table.insert(children, child)
	end
	function canvas:OnChildRemoved(child)
		for i = 1, #children do
			local v = children[i]
			if v == child then
				table.remove(children, i)
				return
			end
		end
	end
	canvas.GetChildren = function()
		return children
	end
	canvas.children = children

	local vbar = self.VBar
	vbar:SetHideButtons(true)
	vbar.btnUp:SetVisible(false)
	vbar.btnDown:SetVisible(false)

	vbar.vertices = {}
	vbar.scroll_target = 0
	vbar.scroll_speed = starting_scroll_speed

	vbar.OnMouseWheeled = vbar_OnMouseWheeled
	vbar.SetScroll = vbar_SetScroll
	vbar.OnCursorMoved = vbar_OnCursorMoved
	vbar.Think = vbar_Think
	vbar.Paint = vbar_Paint
	vbar.PerformLayout = vbar_PerformLayout

	vbar.btnGrip.vertices = {}
	vbar.btnGrip.Paint = vbarGrip_Paint

	self:ScaleChanged()
	SUI.OnScaleChanged(self, self.ScaleChanged)
end

function Panel:OnChildAdded(child)
	self:AddItem(child)
	self:ChildAdded(child)
end

function Panel:ChildAdded()
end

function Panel:ScaleChanged()
	local w = SUI.Scale(4)

	self.VBar:SetWide(w)
	self.VBar.btnDown:SetSize(w, 0)
	self.VBar.btnUp:SetSize(w, 0)
end

function Panel:Paint(w, h)
	local outline = SUI.GetColor("scroll_panel_outline")
	if outline then
		TDLib.DrawOutlinedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"), outline, 1)
	else
		RoundedBox(self, "Background", 3, 0, 0, w, h, SUI.GetColor("scroll_panel"))
	end
end

function Panel:ScrollToBottom()
	local vbar = self.VBar
	for k, anim in pairs(vbar.m_AnimList or {}) do
		anim:Think(vbar, 1)
		vbar.m_AnimList[k] = nil
	end

	self:InvalidateParent(true)
	self:InvalidateChildren(true)

	vbar:SetScroll(vbar.CanvasSize)
end

function Panel:PerformLayoutInternal(w, h)
	w = w or self:GetWide()
	h = h or self:GetTall()

	local canvas = self.pnlCanvas

	self:Rebuild()

	local vbar = self.VBar
	vbar:SetUp(h, canvas:GetTall())

	if vbar.Enabled then
		w = w - vbar:GetWide() - self.m_bVBarPadding
	end

	canvas:SetWide(w)

	self:Rebuild()
end

function Panel:Think()
	local canvas = self.pnlCanvas

	local vbar = self.VBar
	if vbar.Enabled then
		canvas.y = -vbar.Scroll
	else
		if self:GetFromBottom() then
			canvas._y = Lerp(14 * RealFrameTime(), canvas._y or canvas.y, self:GetTall() - canvas:GetTall())
		else
			canvas._y = Lerp(14 * RealFrameTime(), canvas._y or canvas.y, -vbar.Scroll)
		end
		canvas.y = canvas._y
	end
end

sui.register("ScrollPanel", Panel, "DScrollPanel")