if SAM_LOADED then return end

local vgui = vgui
local draw = draw

local sam = sam
local sui = sui
local TDLib = sui.TDLib

local config = sam.config

do
	local funcs = {
		["SAM.ComboBox"] = {
			event = "OnSelect",
			function(s, _, value)
				config.set(s.config_key, value)
			end
		},
		["SAM.TextEntry"] = {
			event = "OnEnter",
			function(s)
				local v = s:GetText()
				if s:GetNumeric() then
					v = tonumber(v)
				end
				config.set(s.config_key, v)
			end
		},
		["SAM.ToggleButton"] = {
			event = "OnChange",
			function(s, v)
				config.set(s.config_key, v)
			end
		}
	}

	sam.SUI = sam.SUI or sui.new("SAM", true, {
		SetConfig = function(s, key, default)
			s.config_key = key

			local i = config.hook({key}, function(value, old)
				local v = config.get(key, default)
				s:SetValue(v)
			end)

			local t = funcs[s:GetName()]
			s[t.event] = t[1]

			s:On("OnRemove", function()
				config.remove_hook(i)
			end)
		end
	})
end

local SUI = sam.SUI
local GetColor = SUI.GetColor

sam.menu = {}

local tabs = {}
function sam.menu.add_tab(icon, func, check, pos)
	local tab = {
		icon = icon,
		func = func,
		check = check,
		pos = pos
	}
	for k, v in ipairs(tabs) do
		if v.icon == icon then
			tabs[k] = tab
			return
		end
	end
	table.insert(tabs, tab)
end

function sam.menu.remove_tab(name)
	for k, v in ipairs(tabs) do
		if v.name == name then
			table.remove(tabs, k)
			break
		end
	end
end

SAM_TAB_TITLE_FONT = SUI.CreateFont("TabTitle", "Roboto Bold", 22)
SAM_TAB_DESC_FONT = SUI.CreateFont("TabDesc", "Roboto Medium", 15)

local MENU_LOADING = SUI.CreateFont("MenuLoading", "Roboto", 30)

SUI.AddToTheme("Dark", {
	frame = "#181818",

	scroll_panel = "#181818",

	menu_tabs_title = "#ffffff",

	--=--
	player_list_titles = "#f2f1ef",

	player_list_names = "#eeeeee",
	player_list_names_2 = "#ff6347",
	player_list_data = "#e8e8e8",

	player_list_rank = "#41b9ff",
	player_list_console = "#00c853",
	player_list_rank_text = "#2c3e50",

	player_list_steamid = "#a4a4a4",
	--=--

	--=--
	actions_button = Color(0, 0, 0, 0),
	actions_button_hover = Color(200, 200, 200, 60),

	actions_button_icon = "#aaaaaa",
	actions_button_icon_hover = "#ffffff",
	--=--

	--=--
	page_switch_bg = "#222222",
	--=--
})

SUI.SetTheme("Dark")

function SUI.panels.Frame:Paint(w, h)
	if GetColor("frame_blur") then
		TDLib.BlurPanel(self)
	end

	draw.RoundedBox(8, 0, 0, w, h, GetColor("frame"))
end

function SUI.panels.Frame:HeaderPaint(w, h)
	draw.RoundedBoxEx(8, 0, 0, w, h, GetColor("header"), true, true, false, false)
	draw.RoundedBox(0, 0, h - 1, w, 1, GetColor("line"))
end

do
	function sam.menu.add_loading_panel(parent)
		local is_loading = false

		local loading_panel = parent:Add("Panel")
		loading_panel:SetVisible(false)
		loading_panel:SetZPos(999999)
		loading_panel:SetMouseInputEnabled(false)

		function loading_panel:Paint(w, h)
			draw.RoundedBox(3, 0, 0, w, h, Color(50, 50, 50, 200))
			draw.SimpleText(string.rep(".", (CurTime() * 3) % 3), MENU_LOADING, w/2, h/2, Color(200, 200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		parent:SUI_TDLib()
		parent:On("PerformLayout", function(s, w, h)
			loading_panel:SetSize(w, h)
		end)

		local first = true
		local toggle_loading = function(bool)
			if not IsValid(loading_panel) then return end

			is_loading = bool or not is_loading
			if is_loading and not first then
				loading_panel:SetVisible(is_loading and true or false)
				loading_panel:SetMouseInputEnabled(is_loading)
			else
				timer.Simple(0.2, function()
					if not IsValid(loading_panel) then return end
					loading_panel:SetVisible(is_loading and true or false)
					loading_panel:SetMouseInputEnabled(is_loading)
				end)
			end

			first = false
		end

		return toggle_loading, function()
			return is_loading
		end
	end
end

local sam_menu
function sam.menu.open_menu()
	if IsValid(sam_menu) then
		return sam_menu:IsVisible() and sam_menu:Hide() or sam_menu:Show()
		-- sam_menu:Remove()
	end

	sam_menu = vgui.Create("SAM.Frame")
	sam_menu:Center()
	sam_menu:MakePopup()
	sam_menu:SetTitle("SAM")

	sam_menu:AddAnimations(800, 600)

	sam_menu.close.DoClick = function()
		sam_menu:Hide()
	end

	local sheet = sam_menu:Add("SAM.ColumnSheet")
	sheet:Dock(FILL)
	sheet:InvalidateParent(true)
	sheet:InvalidateLayout(true)
	sheet.Paint = nil

	local tab_scroller = sheet.tab_scroller
	tab_scroller:DockMargin(0, 1, 0, 1)

	function tab_scroller:Paint(w, h)
		draw.RoundedBoxEx(8, 0, 0, w, h, GetColor("column_sheet_bar"), false, false, true, false)
	end

	local sheets = {}
	for _, v in SortedPairsByMemberValue(tabs, "pos") do
		sheets[v.icon] = sheet:AddSheet(v.icon, v.func)
	end

	tab_scroller = tab_scroller:GetCanvas()
	sam_menu:On("Think", function()
		for _, v in ipairs(tabs) do
			local tab = sheets[v.icon]
			if v.check and not v.check() then
				if tab:IsVisible() then
					tab:SetVisible(false)
					if sheet:GetActiveTab() == tab then
						sheet:SetActiveTab(sheet.tabs[1])
					end
					tab_scroller:InvalidateLayout()
				end
			elseif not tab:IsVisible() then
				tab:SetVisible(true)
				tab_scroller:InvalidateLayout()
			end
		end
	end)
end

function sam.menu.get()
	return sam_menu
end

hook.Add("GUIMouseReleased", "SAM.CloseMenu", function(mouse_code)
	local panel = vgui.GetHoveredPanel()
	if mouse_code == MOUSE_LEFT and panel == vgui.GetWorldPanel() and IsValid(sam_menu) and sam_menu:HasHierarchicalFocus() then
		sam_menu:Hide()
	end
end)

for _, f in ipairs(file.Find("sam/menu/tabs/*.lua", "LUA")) do
	sam.load_file("sam/menu/tabs/" .. f, "sh")
end