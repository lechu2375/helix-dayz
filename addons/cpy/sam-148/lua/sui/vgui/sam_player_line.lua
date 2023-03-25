local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local TDLib = sui.TDLib
local draw_material = sui.draw_material
local lerp_color = sui.lerp_color

local GetColor = SUI.GetColor
local RoundedBox = TDLib.RoundedBox
local CircleAvatar = TDLib.LibClasses.CircleAvatar
local CircleClick2 = TDLib.LibClasses.CircleClick2

local PLAYER_LINE_NAME = SUI.CreateFont("PlayerLineName", "Roboto Bold", 17)
local PLAYER_LINE_RANK = SUI.CreateFont("PlayerLineRank", "Roboto Bold", 13)
local PLAYER_LINE_STEAMID = SUI.CreateFont("PlayerLineSteamID", "Roboto Medium", 12)

local PANEL = {}

function PANEL:Init()
	local size = SUI.Scale(34)

	self:Dock(TOP)
	self:SetTall(size)

	self.size = size
end

local rank_Paint = function(s, w, h)
	RoundedBox(s.rect, SUI.Scale(10), 0, 0, w, h, s.col)
end

function PANEL:SetInfo(info)
	local size = self.size

	local container
	do
		local w = SUI.Scale(280) + size

		local _container = self:Add("Panel")
		_container:Dock(LEFT)
		_container:SetMouseInputEnabled(false)
		_container:SetWide(w)

		container = _container:Add("Panel")
		container:SetSize(w, size)

		function _container:PerformLayout()
			container:Center()
		end
	end

	do
		local avatar = container:Add("Panel")
		avatar:Dock(LEFT)
		avatar:DockMargin(0, 0, 5, 0)
		avatar:SetWide(size)
		avatar:SetMouseInputEnabled(false)
		CircleAvatar(avatar)

		avatar:SetSteamID(util.SteamIDTo64(info.steamid), size)
	end

	do
		local top_container = container:Add("Panel")
		top_container:Dock(TOP)
		top_container:DockMargin(0, 0, 0, 2)

		local name = top_container:Add("SAM.Label")
		name:Dock(LEFT)
		name:SetFont(PLAYER_LINE_NAME)
		self.name = name

		local pname = info.name
		if not pname or pname == "" then
			name:SetTextColor(GetColor("player_list_names_2"))
			self:SetName("N/A")
		else
			name:SetTextColor(GetColor("player_list_names"))
			self:SetName(pname)
		end

		if info.rank then
			local rank_bg = top_container:Add("Panel")
			rank_bg:Dock(LEFT)
			rank_bg:DockMargin(5, 0, 0, 0)

			rank_bg.rect = {}
			rank_bg.col = info.rank_bg or GetColor("player_list_rank")
			rank_bg.Paint = rank_Paint

			local rank = rank_bg:Add("SAM.Label")
			rank:Dock(FILL)
			rank:DockMargin(SUI.Scale(8), 0, 0, 0)
			rank:SetTextColor(GetColor("player_list_rank_text"))
			rank:SetFont(PLAYER_LINE_RANK)
			rank.bg = rank_bg

			self.rank = rank
			self:SetRank(info.rank)

			rank_bg:SetSize(rank:GetTextSize() + SUI.Scale(8) * 2)
		end

		top_container:SizeToChildren(true, true)
	end

	local steamid = container:Add("SAM.Label")
	steamid:Dock(TOP)
	steamid:SetTextColor(GetColor("player_list_steamid"))
	steamid:SetFont(PLAYER_LINE_STEAMID)
	steamid:SetText(info.steamid)
	steamid:SizeToContents()
	steamid:SetAutoStretchVertical(true)

	self.container = container
end

function PANEL:SetName(new_name)
	local name =  self.name
	name:SetText(new_name)
	name:SizeToContents()
	if name:GetWide() > 160 then
		name:SetWide(158)
	end
end

function PANEL:SetRank(new_rank)
	local rank = self.rank
	rank:SetText(new_rank)
	rank:SizeToContents()
	rank.bg:SetSize(rank:GetTextSize() + SUI.Scale(8) * 2)
end

function PANEL:Actions()
	local container
		do
		local size = self.size

		local _container = self:Add("Panel")
		_container:Dock(RIGHT)
		_container:SetWide(size)

		container = _container:Add("Panel")
		container:SetSize(size, size)

		function _container:PerformLayout()
			container:Center()
		end
	end

	local actions_button = container:Add("SAM.Button")
	actions_button:SetText("")
	actions_button:ClearPaint()

	function container:PerformLayout(w, h)
		actions_button:SetSize(h, h)
		actions_button:Center()
	end

	local image = actions_button:Add("SAM.Image")
	image:Dock(FILL)
	image:SetImage("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/dots_verticle.png")

	local current_icon_color = Color(GetColor("actions_button_icon"):Unpack())
	function image:Draw(w, h)
		if not h then return end

		if actions_button.Hovered then
			lerp_color(current_icon_color, GetColor("actions_button_icon_hover"))
		else
			lerp_color(current_icon_color, GetColor("actions_button_icon"))
		end

		draw_material(nil, w / 2, h / 2, SUI.ScaleEven(20), current_icon_color)
	end

	CircleClick2(actions_button, Color(62, 62, 62), 10)
	actions_button:Center()

	return actions_button
end

sui.register("PlayerLine", PANEL, "Panel")