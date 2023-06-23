local ScrW, ScrH = ScrW, ScrH
local DisableClipping = DisableClipping
local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local BlurPanel = sui.TDLib.BlurPanel
local lerp_color = sui.lerp_color

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local GetColor = SUI.GetColor

local PANEL = {}

function PANEL:SetCallback(callback)
	self.callback = callback
end

function PANEL:Init()
	self:SetSize(0, 0)

	local bottom = self:Add("Panel")
	bottom:Dock(BOTTOM)
	bottom:DockMargin(4, 10, 4, 4)
	bottom:SetZPos(100)

	local save = bottom:Add(NAME .. ".Button")
	save:SetText("SAVE")
	save:Dock(RIGHT)
	save:SetEnabled(false)
	self.save = save

	function save.DoClick()
		self.callback()
		self:Remove()
	end

	local cancel = bottom:Add(NAME .. ".Button")
	cancel:Dock(RIGHT)
	cancel:DockMargin(0, 0, 4, 0)
	cancel:SetContained(false)
	cancel:SetColors(GetColor("query_box_cancel"), GetColor("query_box_cancel_text"))
	cancel:SetText("CANCEL")
	self.cancel = cancel

	function cancel.DoClick()
		self:Remove()
	end

	bottom:SetSize(save:GetWide() * 2 + 4, SUI.Scale(30))

	local body = self:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(4, 4, 4, 4)
	body:DockPadding(3, 3, 3, 3)
	body:InvalidateLayout(true)
	body:InvalidateParent(true)

	local added = 1
	function body.OnChildAdded(s, child)
		added = added + 1
		child:Dock(TOP)
		child:SetZPos(added)
		child:InvalidateLayout(true)
		s:InvalidateLayout(true)
	end
	self.body = body

	function self:Add(name)
		return body:Add(name)
	end

	local old_Paint = self.Paint
	local trans = Color(0, 0, 0, 0)
	local new_col = Color(70, 70, 70, 100)
	function self:Paint(w, h)
		lerp_color(trans, new_col)

		local x, y = self:LocalToScreen(0, 0)
		DisableClipping(true)
			BlurPanel(self)
			SetDrawColor(trans)
			DrawRect(x * -1, y * -1, ScrW(), ScrH())
		DisableClipping(false)

		old_Paint(self, w, h)
	end
end

function PANEL:ChildrenHeight()
	local body = self.body

	self.header:InvalidateLayout(true)
	local height = self.header:GetTall()

	body:InvalidateLayout(true)
	self:InvalidateLayout(true)
	height = height + select(2, body:ChildrenSize())

	height = height + SUI.Scale(30) + 14 + 6

	return height
end

function PANEL:Paint(w, h)
	if GetColor("frame_blur") then
		BlurPanel(self)
	end

	self:RoundedBox("Background", 8, 0, 0, w, h, GetColor("query_box_bg"))
end

function PANEL:Done()
	self:InvalidateChildren(true)

	self.size_to_children = function()
		local h = self:ChildrenHeight()
		self:RealSetSize(self:GetWide(), h)
		self.real_h = h
	end

	self:Center()
	self:MakePopup()
	self:DoModal(true)

	timer.Simple(0.08, function()
		self:AddAnimations(self:GetWide(), self:ChildrenHeight(), true)
	end)
end

sui.register("QueryBox", PANEL, NAME .. ".Frame")