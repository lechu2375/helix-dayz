if SAM_LOADED then return end

local sam = sam
local config = sam.config

local tabs = {}
if CLIENT then
	function config.add_tab(name, func, check, pos)
		local tab = {
			name = name,
			func = func,
			check = check,
			pos = pos
		}
		for k, v in ipairs(tabs) do
			if v.name == name then
				tabs[k] = tab
				return
			end
		end
		table.insert(tabs, tab)
	end
end

for _, f in ipairs(file.Find("sam/menu/tabs/config/*.lua", "LUA")) do
	sam.load_file("sam/menu/tabs/config/" .. f, "cl_")
end

if SERVER then return end

local SUI = sam.SUI
local GetColor = SUI.GetColor
local Line = sui.TDLib.LibClasses.Line

sam.menu.add_tab("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/config.png", function(column_sheet)
	local tab_body = column_sheet:Add("Panel")
	tab_body:Dock(FILL)
	tab_body:DockMargin(0, 1, 0, 0)

	do
		local title = tab_body:Add("SAM.Label")
		title:Dock(TOP)
		title:DockMargin(10, 10, 0, 0)
		title:SetFont(SAM_TAB_TITLE_FONT)
		title:SetText("Config")
		title:SetTextColor(GetColor("menu_tabs_title"))
		title:SizeToContents()

		local total = tab_body:Add("SAM.Label")
		total:Dock(TOP)
		total:DockMargin(10, 6, 0, 0)
		total:SetFont(SAM_TAB_DESC_FONT)
		total:SetText("Some settings may require a server restart")
		total:SetTextColor(GetColor("menu_tabs_title"))
		total:SetPos(10, SUI.Scale(40))
		total:SizeToContents()
	end

	local body = tab_body:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(10, 5, 10, 10)

	Line(body, nil, 0, 0, 0, 10)

	local sheet = body:Add("SAM.PropertySheet")
	sheet:Dock(FILL)
	sheet:InvalidateParent(true)
	sheet:InvalidateLayout(true)

	local sheets = {}
	for _, v in SortedPairsByMemberValue(tabs, "pos") do
		sheets[v.name] = sheet:AddSheet(v.name, v.func)
	end

	local tab_scroller = sheet.tab_scroller:GetCanvas()
	function tab_body.Think()
		for _, v in ipairs(tabs) do
			local tab = sheets[v.name]
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
	end

	return tab_body
end, function()
	return LocalPlayer():HasPermission("manage_config")
end, 5)