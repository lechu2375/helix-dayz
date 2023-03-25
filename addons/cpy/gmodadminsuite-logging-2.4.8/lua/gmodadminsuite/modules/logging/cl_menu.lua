local function L(phrase, discriminator)
	return GAS:Phrase(phrase, "logging", discriminator)
end

if (IsValid(GAS.Logging.Menu)) then
	GAS.Logging.Menu:Close()
end
if (GAS.Logging.EvidenceBox and IsValid(GAS.Logging.EvidenceBox.Menu)) then
	GAS.Logging.EvidenceBox.Menu:Close()
end

local deep_storage_category_item
local advanced_search_category_item
local all_logs_category_item
local damage_logs_category_item

local user_icons   = {"user.png", "user_green.png", "user_orange.png", "user_red.png", "user_suit.png", "user_gray.png"}
local string_icons = {"tag_blue.png", "tag_green.png", "tag_orange.png", "tag_pink.png", "tag_purple.png", "tag_red.png", "tag_yellow.png"}
function GAS.Logging:OpenLogsContextMenu(row)
	local format_submenus = {
		[GAS.Logging.FORMAT_PLAYER]    = {L"players","icon16/user.png",},
		[GAS.Logging.FORMAT_WEAPON]    = {L"weapons","icon16/bomb.png"},
		[GAS.Logging.FORMAT_ENTITY]    = {L"entities","icon16/bricks.png"},
		[GAS.Logging.FORMAT_PROP]      = {L"props","icon16/box.png"},
		[GAS.Logging.FORMAT_RAGDOLL]   = {L"ragdolls","icon16/status_online.png"},
		[GAS.Logging.FORMAT_CURRENCY]  = {L"money","icon16/money.png"},
		[GAS.Logging.FORMAT_DAMAGE]    = {L"damage","icon16/emoticon_unhappy.png"},
		[GAS.Logging.FORMAT_COUNTRY]   = {L"countries","icon16/world.png"},
		[GAS.Logging.FORMAT_AMMO]      = {L"ammo","icon16/coins.png"},
		[GAS.Logging.FORMAT_TEAM]      = {L"teams","icon16/flag_red.png"},
		[GAS.Logging.FORMAT_USERGROUP] = {L"usergroups","icon16/group.png"},
		[GAS.Logging.FORMAT_ROLE]      = {L"roles","icon16/tag_red.png"},
		[GAS.Logging.FORMAT_VEHICLE]   = {L"vehicles","icon16/car.png"}
	}

	GAS:PlaySound("btn_heavy")

	local menu = DermaMenu()

	menu:AddOption(L"copy_log", function()
		if (row.IsColored) then
			GAS:SetClipboardText(GAS:MarkupToPlaintext(row.LabelsData[3]))
		else
			GAS:SetClipboardText(row.LabelsData[3])
		end
	end):SetIcon("icon16/page_copy.png")

	menu:AddOption(L"add_to_evidence_box", function()
		GAS.Logging.EvidenceBox:Add(row)
	end):SetIcon("icon16/box.png")

	if (row.Data[6]) then
		menu:AddOption(L"open_pvp_event_report", function()
			GAS:PlaySound("jump")
			if (IsValid(damage_logs_category_item)) then
				GAS:netStart("logging:PvPEventReport")
					net.WriteUInt(row.Data[6], 16)
				net.SendToServer()
			end
		end):SetIcon("icon16/bomb.png")
	end

	local user_icon_i = 1
	local string_icon_i = 1
	local data_submenu, category_submenus
	local duplicate_prevention = {}
	for _,replacement in ipairs(row.Data[1]) do
		if (replacement[1] == nil or (replacement[1] ~= GAS.Logging.FORMAT_STRING and replacement[1] ~= GAS.Logging.FORMAT_HIGHLIGHT and format_submenus[replacement[1]] == nil)) then continue end
		if (not data_submenu) then
			local _data_submenu, __ = menu:AddSubMenu(L"data")
			__:SetIcon("icon16/database_gear.png")
			data_submenu = _data_submenu
			category_submenus = {}
		end
		if (not category_submenus[replacement[1]]) then
			if (replacement[1] == GAS.Logging.FORMAT_STRING or replacement[1] == GAS.Logging.FORMAT_HIGHLIGHT) then
				local newsub,_ = data_submenu:AddSubMenu(L"strings")
				_:SetIcon("icon16/style.png")
				category_submenus[GAS.Logging.FORMAT_STRING] = newsub
				category_submenus[GAS.Logging.FORMAT_HIGHLIGHT] = newsub
			else
				local newsub,_ = data_submenu:AddSubMenu(format_submenus[replacement[1]][1])
				_:SetIcon(format_submenus[replacement[1]][2])
				category_submenus[replacement[1]] = newsub
			end
		end

		if (replacement[1] == GAS.Logging.FORMAT_TEAM) then
			if (duplicate_prevention[GAS.Logging.FORMAT_TEAM] and duplicate_prevention[GAS.Logging.FORMAT_TEAM][replacement[3]]) then
				continue
			else
				duplicate_prevention[GAS.Logging.FORMAT_TEAM] = duplicate_prevention[GAS.Logging.FORMAT_TEAM] or {}
				duplicate_prevention[GAS.Logging.FORMAT_TEAM][replacement[3]] = true
			end
		else
			if (duplicate_prevention[replacement[1]] and duplicate_prevention[replacement[1]][replacement[2]]) then
				continue
			else
				duplicate_prevention[replacement[1]] = duplicate_prevention[replacement[1]] or {}
				duplicate_prevention[replacement[1]][replacement[2]] = true
			end
		end

		if (replacement[1] == GAS.Logging.FORMAT_PLAYER) then

			local icon
			if (replacement[2] == "CONSOLE") then
				icon = "icon16/application_osx_terminal.png"
			elseif (replacement[2] == "BOT") then
				icon = "icon16/server.png"
			else
				icon = "icon16/" .. user_icons[user_icon_i]
			end

			local nick_label
			if (replacement[3] ~= nil and replacement[3][1] ~= nil) then
				nick_label = replacement[3][1]
			elseif (replacement[2] == "CONSOLE" or replacement[2] == "BOT") then
				nick_label = replacement[2]
			elseif (replacement[2] == nil) then
				nick_label = "UNKNOWN"
			else
				nick_label = GAS:AccountIDToSteamID(replacement[2])
			end

			if (replacement[2] == "CONSOLE" or replacement[2] == "BOT" or replacement[2] == nil) then
				category_submenus[replacement[1]]:AddOption(nick_label):SetIcon(icon)
			else
				local option = category_submenus[replacement[1]]:AddOption(nick_label, function()
					bVGUI.PlayerTooltip.Focus()
				end)
				option:SetIcon(icon)
				
				bVGUI.PlayerTooltip.Attach(option, {
					account_id = tonumber(replacement[2]),
					creator = option,
					focustip = L"click_to_focus"
				})
			end

			user_icon_i = user_icon_i + 1
			if (user_icon_i > #user_icons) then user_icon_i = 1 end

		elseif (replacement[1] == GAS.Logging.FORMAT_WEAPON) then

			local option = category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end)
			option:SetIcon(format_submenus[replacement[1]][2])

			GAS_Logging_DisplayEntity(function(pnl)
				pnl:SetWeapon(replacement[2])
			end, option, true)

		elseif (replacement[1] == GAS.Logging.FORMAT_PROP) then

			local option = category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end)
			option:SetIcon(format_submenus[replacement[1]][2])

			GAS_Logging_DisplayEntity(function(pnl)
				pnl:SetProp(replacement[2])
			end, option, true)

		elseif (replacement[1] == GAS.Logging.FORMAT_AMMO) then

			local option = category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end)
			option:SetIcon(format_submenus[replacement[1]][2])

			GAS_Logging_DisplayEntity(function(pnl)
				pnl:SetAmmo(replacement[2])
			end, option, true)

		elseif (replacement[1] == GAS.Logging.FORMAT_VEHICLE) then
			
			local option = category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end)
			option:SetIcon(format_submenus[replacement[1]][2])

			GAS_Logging_DisplayEntity(function(pnl)
				pnl:SetVehicle(replacement[2], replacement[3])
			end, option, true)

		elseif (replacement[1] == GAS.Logging.FORMAT_ENTITY) then

			local option = category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2] == "WORLD" and "worldspawn" or replacement[2])
			end)
			option:SetIcon(format_submenus[replacement[1]][2])

			if (replacement[2] ~= "WORLD") then
				GAS_Logging_DisplayEntity(function(pnl)
					pnl:SetEntity(replacement[2], replacement[3])
				end, option, true)
			end
			
		elseif (replacement[1] == GAS.Logging.FORMAT_TEAM) then

			bVGUI_DermaMenuOption_ColorIcon(category_submenus[replacement[1]]:AddOption(replacement[3], function()
				GAS:SetClipboardText(replacement[3])
			end), replacement[4])
			
		elseif (replacement[1] == GAS.Logging.FORMAT_COUNTRY) then

			local icon = "icon16/world.png"
			if (GAS.CountryCodesReverse[replacement[2]] ~= nil) then
				local country_code = GAS.CountryCodesReverse[replacement[2]]:lower()
				if (file.Exists("materials/flags16/" .. country_code .. ".png", "GAME")) then
					icon = "flags16/" .. country_code .. ".png"
				end
			end

			category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end):SetIcon(icon)
			
		elseif (replacement[1] == GAS.Logging.FORMAT_CURRENCY) then

			category_submenus[replacement[1]]:AddOption(GAS.Logging:FormatCurrencyStr(replacement[2]), function()
				GAS:SetClipboardText(replacement[2])
			end):SetIcon("icon16/money.png")

		elseif (replacement[1] == GAS.Logging.FORMAT_STRING or replacement[1] == GAS.Logging.FORMAT_HIGHLIGHT) then

			category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end):SetIcon("icon16/" .. string_icons[string_icon_i])

			string_icon_i = string_icon_i + 1
			if (string_icon_i > #string_icons) then string_icon_i = 1 end

		else

			category_submenus[replacement[1]]:AddOption(replacement[2], function()
				GAS:SetClipboardText(replacement[2])
			end):SetIcon(format_submenus[replacement[1]][2])

		end
	end

	menu:Open()
end

GAS.Logging.EvidenceBox = {}
function GAS.Logging.EvidenceBox:Open()
	if (IsValid(GAS.Logging.EvidenceBox.Menu)) then return true end

	GAS:PlaySound("popup")

	GAS.Logging.EvidenceBox.Menu = vgui.Create("bVGUI.Frame")
	GAS.Logging.EvidenceBox.Menu:SetSize(500,350)
	GAS.Logging.EvidenceBox.Menu:SetMinimumSize(500,350)
	GAS.Logging.EvidenceBox.Menu:SetTitle(L"evidence_box")
	GAS.Logging.EvidenceBox.Menu:Center()
	GAS.Logging.EvidenceBox.Menu:MakePopup()

	GAS.Logging.EvidenceBox.Rows = vgui.Create("bVGUI.Table", GAS.Logging.EvidenceBox.Menu)
	GAS.Logging.EvidenceBox.Rows.AddedLogs = {}
	GAS.Logging.EvidenceBox.Rows:Dock(FILL)
	GAS.Logging.EvidenceBox.Rows:AddColumn(L"log")
	GAS.Logging.EvidenceBox.Rows:SetRowCursor("hand")

	function GAS.Logging.EvidenceBox.Rows:OnRowClicked(row)
		GAS:PlaySound("btn_heavy")
		local menu = DermaMenu()
		menu:AddOption(L"remove", function()
			GAS:PlaySound("delete")
			GAS.Logging.EvidenceBox.Rows:RemoveRow(row.RowIndex)
		end):SetIcon("icon16/delete.png")
		menu:Open()
	end

	GAS.Logging.EvidenceBox.ExportContainer = vgui.Create("bVGUI.BlankPanel", GAS.Logging.EvidenceBox.Menu)
	GAS.Logging.EvidenceBox.ExportContainer:Dock(BOTTOM)
	GAS.Logging.EvidenceBox.ExportContainer:SetTall(40)
	function GAS.Logging.EvidenceBox.ExportContainer:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
		surface.DrawRect(0,0,w,h)
	end

	GAS.Logging.EvidenceBox.ExportBtn = vgui.Create("bVGUI.Button", GAS.Logging.EvidenceBox.ExportContainer)
	GAS.Logging.EvidenceBox.ExportBtn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	GAS.Logging.EvidenceBox.ExportBtn:SetText(L"export_to_clipboard")
	GAS.Logging.EvidenceBox.ExportBtn:SetSize(150,25)
	function GAS.Logging.EvidenceBox.ExportBtn:DoClick()
		GAS:SetClipboardText(GAS.Logging.EvidenceBox:Export(GAS.Logging.EvidenceBox.Rows.Rows))
	end

	function GAS.Logging.EvidenceBox.ExportContainer:PerformLayout()
		GAS.Logging.EvidenceBox.ExportBtn:Center()
	end

	GAS.Logging.EvidenceBox.Menu:EnableUserResize()

	return false
end
function GAS.Logging.EvidenceBox:Add(row)
	if (GAS.Logging.EvidenceBox:Open()) then
		GAS:PlaySound("flash")
	end
	if (not GAS.Logging.EvidenceBox.Rows.AddedLogs[row.Data[7]]) then
		GAS.Logging.EvidenceBox.Rows:AddRow(row.LabelsData[3]).Data = row.Data
		GAS.Logging.EvidenceBox.Rows.AddedLogs[row.Data[7]] = true
	end
end
local EvidenceBox_Logo = string.Explode("\n",[[   ___ _ _ _       _        __                 
  / __(_) | |_   _( )__    / /  ___   __ _ ___ 
 /__\// | | | | | |/ __|  / /  / _ \ / _` / __|
/ \/  \ | | | |_| |\__ \ / /__| (_) | (_| \__ \
\_____/_|_|_|\__, ||___/ \____/\___/ \__, |___/
             |___/                   |___/     ]])
function GAS.Logging.EvidenceBox:Export(logs)
	local all_involved_steamids = {}

	local columns = {{},{},{},{},{}}

	local sorted_rows = {}
	for _,row in ipairs(logs) do
		table.insert(sorted_rows, {timestamp = row.Data[3], row = row})
	end
	table.SortByMember(sorted_rows, "timestamp", true)

	for _,sorted_row in pairs(sorted_rows) do
		local row = sorted_row.row
		local module_tbl = GAS.Logging.IndexedModules[row.Data[2]]
		table.insert(columns[1], "[" .. module_tbl.Category .. "]")
		table.insert(columns[2], "[" .. module_tbl.Name .. "]")
		table.insert(columns[3], "[" .. row.Data[7] .. "]")
		table.insert(columns[4], "[" .. GAS:FormatFullTimestamp(row.Data[3]) .. "]")
		local formatted_log = GAS.Logging:FormatMarkupLog(row.Data, false)
		local log_str
		if (row.Data[5]) then
			log_str = L(row.Data[5], "Logs")
		elseif (row.Data[4]) then
			log_str = row.Data[4]
		end
		for _,replacement in ipairs(row.Data[1]) do
			if (replacement[1] == GAS.Logging.FORMAT_PLAYER) then
				local nick = "UNKNOWN"
				if (replacement[2] == "CONSOLE" or replacement[2] == "BOT") then
					nick = replacement[2]
				elseif (replacement[3] ~= nil) then
					nick = GAS:utf8_force_strip(replacement[3][1])
				end
				all_involved_steamids[GAS:AccountIDToSteamID(replacement[2])] = nick
			end
		end
		table.insert(columns[5], formatted_log)
	end
	local column_lengths = {}
	for i,rows in ipairs(columns) do
		column_lengths[i] = 0
		for _,row in ipairs(rows) do
			if (#row > column_lengths[i]) then
				column_lengths[i] = #row
			end
		end
	end

	local exported = ""

	local longest_row

	local date = GAS:FormatFullTimestamp(os.time())
	local exported_by = GAS:utf8_force_strip(LocalPlayer():Nick()) .. " (" .. LocalPlayer():SteamID() .. ")"

	local longest_nick
	local longest_steamid
	if (not GAS:table_IsEmpty(all_involved_steamids)) then
		for steamid, nick in pairs(all_involved_steamids) do
			if (not longest_nick or utf8.len(nick) > longest_nick) then
				longest_nick = utf8.len(nick)
			end
			if (not longest_steamid or #steamid > longest_steamid) then
				longest_steamid = #steamid
			end
		end
	end
	local longest_involved_player
	if (longest_nick and longest_steamid) then
		longest_involved_player = longest_nick + longest_steamid + 1
	end

	if (longest_involved_player) then
		longest_row = math.max(utf8.len(exported_by) + 13, #date + 6, longest_involved_player)
	else
		longest_row = math.max(utf8.len(exported_by) + 13, #date + 6)
	end

	local logo_padding = math.max(math.ceil((longest_row + 2) / 2 - 47 / 2), 0)
	for _,line in ipairs(EvidenceBox_Logo) do
		exported = exported .. (" "):rep(logo_padding) .. line .. "\r\n"
	end

	exported = exported .. "\r\n" .. ("\\"):rep(longest_row + 4) .. "\r\n"
	exported = exported .. "[" .. (" "):rep(longest_row + 2) .. "]\r\n"

	local header_margin = math.max(math.ceil((longest_row - 19) / 2), 0)
	local header_margin_right = math.max(math.floor((longest_row - 19) / 2), 0)
	exported = exported .. "[ " .. (" "):rep(header_margin) .. "Evidence Box Export" .. (" "):rep(header_margin_right) .. " ]\r\n"

	exported = exported .. "[" .. (" "):rep(longest_row + 2) .. "]\r\n"
	exported = exported .. "[ Date: " .. (" "):rep(longest_row - 6 - #date) .. date .. " ]\r\n"
	exported = exported .. "[ Exported by: " .. (" "):rep(longest_row - 13 - utf8.len(exported_by)) .. exported_by .. " ]\r\n"
	exported = exported .. "[" .. (" "):rep(longest_row + 2) .. "]\r\n"

	if (longest_involved_player) then
		local header_margin = math.max(math.ceil((longest_row - 16) / 2), 0)
		local header_margin_right = math.max(math.floor((longest_row - 16) / 2), 0)
		exported = exported .. "[ " .. (" "):rep(header_margin) .. "Involved Players" .. (" "):rep(header_margin_right) .. " ]\r\n"
		exported = exported .. "[" .. (" "):rep(longest_row + 2) .. "]\r\n"

		for steamid, nick in pairs(all_involved_steamids) do
			exported = exported .. "[ " .. nick .. (" "):rep(longest_row - #steamid - utf8.len(nick)) .. steamid .. " ]\r\n"
		end

		exported = exported .. "[" .. (" "):rep(longest_row + 2) .. "]\r\n"
	end

	exported = exported .. ("/"):rep(longest_row + 4) .. "\r\n\r\n"
	exported = exported .. "[ Category / Module / ID / Timestamp / Log ]\r\n"

	local row_count = #columns[1]
	local row_index = 1
	while (row_index <= row_count) do
		exported = exported .. "\r\n"
		for i,rows in ipairs(columns) do
			local row = rows[row_index]
			local spaces = 0
			if (i ~= #columns) then
				spaces = math.max(column_lengths[i] - #row + 1, 1)
			end
			exported = exported .. row .. (" "):rep(spaces)
		end
		row_index = row_index + 1
	end

	return exported
end

function GAS.Logging:ShowClassSelector(content)
	GAS.Logging.ClassSelector = vgui.Create("bVGUI.Frame")
	GAS.Logging.ClassSelector:SetTitle(L"class_selector")
	GAS.Logging.ClassSelector:SetSize(560,500)
	GAS.Logging.ClassSelector:SetMinimumSize(560,500)
	GAS.Logging.ClassSelector:Center()
	GAS.Logging.ClassSelector:MakePopup()

	GAS.Logging.ClassSelector.Categories = vgui.Create("DPanel", GAS.Logging.ClassSelector)
	GAS.Logging.ClassSelector.Categories:Dock(LEFT)
	GAS.Logging.ClassSelector.Categories:SetWide(130)
	GAS.Logging.ClassSelector.Categories:DockPadding(10,10,10,10)
	function GAS.Logging.ClassSelector.Categories:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_SLATE)
		surface.DrawRect(0,0,w,h)

		if (not IsValid(GAS.Logging.Menu) or not GAS.Logging.Menu.AdvancedSearch:IsVisible()) then
			GAS.Logging.ClassSelector:Close()
		end
	end

	GAS.Logging.ClassSelector.Search = vgui.Create("bVGUI.Button", GAS.Logging.ClassSelector.Categories)
	GAS.Logging.ClassSelector.Search:Dock(BOTTOM)
	GAS.Logging.ClassSelector.Search:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	GAS.Logging.ClassSelector.Search:SetText(L"search")
	GAS.Logging.ClassSelector.Search:SetTall(25)
	function GAS.Logging.ClassSelector.Search:DoClick()
		if (GAS.Logging.ClassSelector.SearchQuery ~= nil) then
			GAS:PlaySound("delete")

			GAS.Logging.ClassSelector.SearchQuery = nil
			
			GAS.Logging.ClassSelector.Search:SetColor(bVGUI.BUTTON_COLOR_BLUE)
			GAS.Logging.ClassSelector.Search:SetText(L"search")

			GAS.Logging.ClassSelector.Pagination:SetPage(1)
			GAS.Logging.ClassSelector.Pagination:OnPageSelected(1)
		else
			GAS:PlaySound("flash")

			GAS.Logging.ClassSelector.CloseFrames = GAS.Logging.ClassSelector.CloseFrames or {}
			GAS.Logging.ClassSelector.CloseFrames[
				bVGUI.StringQuery(L"class_search_title", L"class_search_text", L"class_name_ellipsis", function(query)
					GAS.Logging.ClassSelector.SearchQuery = query

					GAS.Logging.ClassSelector.Search:SetColor(bVGUI.BUTTON_COLOR_RED)
					GAS.Logging.ClassSelector.Search:SetText(L"cancel")

					GAS.Logging.ClassSelector.Pagination:SetPage(1)
					GAS.Logging.ClassSelector.Pagination:OnPageSelected(1)
				end)
			] = true
		end
	end

	local class_type_names = GAS.Logging:ClassTypeNames(L)
	local allowed_types = {}
	for i,v in pairs(class_type_names) do
		local container = vgui.Create("bVGUI.BlankPanel", GAS.Logging.ClassSelector.Categories)
		container:Dock(TOP)
		container:SetTall(18)
		container:DockMargin(0,0,0,10)
		container:SetCursor("hand")
		container:SetMouseInputEnabled(true)

		local checkbox = vgui.Create("bVGUI.Checkbox", container)
		checkbox:Dock(LEFT)
		checkbox:SetChecked(true)
		checkbox:SetText(v)
		checkbox:DockMargin(0,0,10,0)
		function container:OnMouseReleased(m)
			checkbox:OnMouseReleased(m)
		end

		allowed_types[i] = true
		function checkbox:OnChange()
			if (self:GetChecked()) then
				allowed_types[i] = true
			else
				allowed_types[i] = nil
			end
			GAS.Logging.ClassSelector.Pagination:SetPage(1)
			GAS.Logging.ClassSelector.Pagination:OnPageSelected(1)
		end

		local label = vgui.Create("DLabel", container)
		label:SetText(v)
		label:SetTextColor(bVGUI.COLOR_WHITE)
		label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
		label:Dock(FILL)
		label:SetContentAlignment(4)
	end

	GAS.Logging.ClassSelector.ContentTable = vgui.Create("bVGUI.Table", GAS.Logging.ClassSelector)
	GAS.Logging.ClassSelector.ContentTable:Dock(FILL)
	GAS.Logging.ClassSelector.ContentTable:AddColumn(L"class_type", bVGUI.TABLE_COLUMN_SHRINK)
	GAS.Logging.ClassSelector.ContentTable:AddColumn(L"value")
	GAS.Logging.ClassSelector.ContentTable:SetRowCursor("hand")
	GAS.Logging.ClassSelector.ContentTable:SetLoading(true)

	function GAS.Logging.ClassSelector.ContentTable:OnRowRightClicked(row, column_index)
		if (column_index == 2 and row.Data[2] == GAS.Logging.ClassType_PLAYER) then
			bVGUI.PlayerTooltip.Focus()
		end
	end
	function GAS.Logging.ClassSelector.ContentTable:OnRowClicked(row)
		GAS:PlaySound("btn_heavy")

		local item = vgui.Create("GAS.Logging.AdvancedSearchItem", content)
		item:SetValue(tostring(row.Data[3]))
		item:SetText("(" .. row.LabelsData[1] .. ") " .. row.LabelsData[2])
		item:SetColor(Color(255,120,0))
		if (row.AccountID) then
			item:SetAccountID(row.AccountID)
			GAS.Logging.Menu.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(2, item)
		else
			GAS.Logging.Menu.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(3, item)
		end
	end
	function GAS.Logging.ClassSelector.ContentTable:OnColumnHovered(row, column_index)
		if (row.AccountID) then
			if (column_index == 2) then
				bVGUI.PlayerTooltip.Create({
					account_id = tonumber(row.AccountID),
					creator = row,
					focustip = L"right_click_to_focus"
				})
			else
				bVGUI.PlayerTooltip.Close()
			end
		end
	end

	GAS.Logging.ClassSelector.PaginationContainer = vgui.Create("bVGUI.BlankPanel", GAS.Logging.ClassSelector)
	GAS.Logging.ClassSelector.PaginationContainer:Dock(BOTTOM)
	GAS.Logging.ClassSelector.PaginationContainer:SetTall(30)
	function GAS.Logging.ClassSelector.PaginationContainer:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
		surface.DrawRect(0,0,w,h)
	end

	GAS.Logging.ClassSelector.Pagination = vgui.Create("bVGUI.Pagination", GAS.Logging.ClassSelector.PaginationContainer)
	GAS.Logging.ClassSelector.Pagination:Dock(FILL)
	GAS.Logging.ClassSelector.Pagination:SetPages(1)
	function GAS.Logging.ClassSelector.Pagination:OnPageSelected(page)
		GAS.Logging.ClassSelector.ContentTable:Clear()
		GAS.Logging.ClassSelector.ContentTable:SetLoading(true)
		GAS:netStart("logging:ClassSelector:GetPage")
			net.WriteUInt(page, 10)
			local allowed_types_count = table.Count(allowed_types)
			if (allowed_types_count ~= table.Count(class_type_names)) then
				net.WriteBool(true)
				net.WriteUInt(allowed_types_count, 6)
				for allowed_type in pairs(allowed_types) do
					net.WriteUInt(allowed_type, 6)
				end
			else
				net.WriteBool(false)
			end
			if (GAS.Logging.ClassSelector.SearchQuery ~= nil) then
				net.WriteBool(true)
				net.WriteString(GAS.Logging.ClassSelector.SearchQuery)
			else
				net.WriteBool(false)
			end
		net.SendToServer()
	end

	function GAS.Logging.ClassSelector.ContentTable:PaintOver(w,h)
		surface.SetDrawColor(255,255,255,150)
		surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
		surface.DrawTexturedRect(0,0,10,h)
	end

	GAS.Logging.ClassSelector:EnableUserResize()
	GAS.Logging.ClassSelector.Pagination:OnPageSelected(1)
end

GAS:netReceive("logging:ClassSelector:GetPage", function()
	local pages = net.ReadUInt(10)
	local data_len = net.ReadUInt(16)
	local data = GAS:DeserializeTable(util.Decompress(net.ReadData(data_len)))
	if (not IsValid(GAS.Logging.ClassSelector)) then return end
	GAS.Logging.ClassSelector.Pagination:SetPages(pages)
	GAS.Logging.ClassSelector.ContentTable:Clear()
	GAS.Logging.ClassSelector.ContentTable:SetLoading(false)
	
	local class_type_names = GAS.Logging:ClassTypeNames(L)
	for _,row in ipairs(data) do
		local class_type = class_type_names[tonumber(row.class_type)] or L"unknown"
		local row_pnl
		if (tonumber(row.class_type) == GAS.Logging.ClassType_PLAYER) then
			if (row.class_name == "BOT") then
				row_pnl = GAS.Logging.ClassSelector.ContentTable:AddRow(class_type, "BOT")
			else
				row_pnl = GAS.Logging.ClassSelector.ContentTable:AddRow(class_type, GAS:AccountIDToSteamID(row.class_name))
			end
			row_pnl.AccountID = tonumber(row.class_name)
		else
			row_pnl = GAS.Logging.ClassSelector.ContentTable:AddRow(class_type, row.class_name)
		end
		row_pnl.Data = {tonumber(row.id), tonumber(row.class_type), row.class_name}
	end
end)

GAS:hook("gmodadminsuite:ModuleSize:logging", "logging:framesize", function()
	return 1000,600
end)

local search_tab_mat = Material("gmodadminsuite/search_tab.vtf")
local database_mat = Material("gmodadminsuite/database.vtf")
local search_mat = Material("gmodadminsuite/search.vtf")
local logo_mat = Material("gmodadminsuite/blogs.vtf")
local advancedsearch_dropshadow = Material("gmodadminsuite/advancedsearch_dropshadow.vtf")
GAS:hook("gmodadminsuite:ModuleFrame:logging", "logging:menu", function(ModuleFrame)
	GAS.Logging.Menu = ModuleFrame

	local is_operator = OpenPermissions:IsOperator(LocalPlayer())

	ModuleFrame.Tabs = vgui.Create("bVGUI.Tabs", ModuleFrame)
	ModuleFrame.Tabs:Dock(TOP)
	ModuleFrame.Tabs:SetTall(40)

	ModuleFrame.logs_content = ModuleFrame.Tabs:AddTab(L"logs", bVGUI.COLOR_GMOD_BLUE)

	ModuleFrame.logs_content.Categories = vgui.Create("bVGUI.Categories", ModuleFrame.logs_content)
	ModuleFrame.logs_content.Categories:Dock(LEFT)
	ModuleFrame.logs_content.Categories:SetWide(175)
	ModuleFrame.logs_content.Categories:EnableSearchBar()
	ModuleFrame.logs_content.Categories:SetLoading(true)

	function ModuleFrame.logs_content:PaintOver(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
		surface.DrawTexturedRect(self.Categories:GetWide(),0,10,h)
	end

	GAS.Logging.Menu.LogsTable = vgui.Create("bVGUI.Table", ModuleFrame.logs_content)
	GAS.Logging.Menu.LogsTable:Dock(FILL)
	GAS.Logging.Menu.LogsTable:AddColumn(L"module", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
	GAS.Logging.Menu.LogsTable:AddColumn(L"when", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
	GAS.Logging.Menu.LogsTable:AddColumn(L"log", bVGUI.TABLE_COLUMN_GROW)
	GAS.Logging.Menu.LogsTable:SetRowCursor("hand")

	function GAS.Logging.Menu.LogsTable:OnRowRightClicked(row)
		self:OnRowClicked(row)
	end
	function GAS.Logging.Menu.LogsTable:OnRowClicked(row)
		GAS.Logging:OpenLogsContextMenu(row)
	end

	function GAS.Logging.Menu.LogsTable:OnColumnHovered(row, column_index)
		if (column_index == 1) then
			bVGUI.CreateTooltip({
				Text = GAS.Logging.IndexedModules[row.Data[2]].Category,
				TextColor = GAS.Logging.IndexedModules[row.Data[2]].Colour,
				VGUI_Element = row
			})
		elseif (column_index == 2) then
			bVGUI.CreateTooltip({
				Text = GAS:FormatFullTimestamp(row.Data[3]),
				VGUI_Element = row
			})
		else
			bVGUI.DestroyTooltip()
		end
	end

	GAS.Logging.Menu.LogsTable.CurrentPage = 1
	GAS.Logging.Menu.LogsTable.ModuleID = false
	GAS.Logging.Menu.LogsTable.DeepStorage = false

	local pagination_container
	local pagination

	local damage_logs_mode = false

	local time_taken
	local function LoadLogs()
		if (IsValid(all_logs_category_item)) then
			if (GAS.Logging.Menu.LogsTable.ModuleID == false) then
				all_logs_category_item:SetActive(true)
			end
		end

		ModuleFrame.AdvancedSearch:SetVisible(false)
		ModuleFrame.DeepStorage:SetVisible(false)
		pagination_container:SetVisible(true)
		GAS.Logging.Menu.SearchTab:SetVisible(true)
		GAS.Logging.Menu.QuickSearch:SetVisible(true)

		time_taken:SetVisible(true)
		time_taken:SetText(L"loading_ellipsis")
		time_taken:SizeToContents()
		local time_taken_SysTime = SysTime()

		GAS.Logging.Menu.LogsTable:Clear()
		GAS.Logging.Menu.LogsTable:SetLoading(true)
		GAS.Logging.Menu.LogsTable:SetVisible(true)
		GAS.Logging.Menu.LogsTable:MoveToAfter(GAS.Logging.Menu.DamageLogs)
		time_taken:MoveToAfter(GAS.Logging.Menu.LogsTable)

		GAS.Logging.Menu.DamageLogs:SetVisible(false)
		GAS.Logging.Menu.DamageLogs.Padding:SetVisible(false)
		GAS.Logging.Menu.DamageLogs.NoData:SetVisible(false)

		local function LogsLoaded(data_present, len, filtered)
			if (not IsValid(GAS.Logging.Menu.LogsTable)) then return end
			GAS.Logging.Menu.LogsTable:SetLoading(false)

			pagination:SetPage(GAS.Logging.Menu.LogsTable.CurrentPage)

			if (data_present) then
				local benchmark = net.ReadFloat()

				if (filtered ~= true) then
					local pages = net.ReadUInt(16)
					pagination:SetPages(math.max(pages, 1))
				end
				pagination:SetInfinite(filtered == true)

				local cl_time = math.Round(SysTime() - time_taken_SysTime, 2)
				if (cl_time >= 1) then
					cl_time = cl_time .. "s"
				else
					cl_time = cl_time * 1000 .. "ms"
				end

				local sv_time = math.Round(benchmark, 2)
				if (sv_time >= 1) then
					sv_time = sv_time .. "s"
				else
					sv_time = sv_time * 1000 .. "ms"
				end

				time_taken:SetText("cl " .. cl_time .. " / sv " .. sv_time)
				time_taken:SizeToContents()
			else
				pagination:SetInfinite(false)
				if (filtered == true) then
					pagination:SetPages(pagination:GetPage())
				end

				local cl_time = math.Round(SysTime() - time_taken_SysTime, 2)
				if (cl_time >= 1) then
					cl_time = cl_time .. "s"
				else
					cl_time = cl_time * 1000 .. "ms"
				end

				time_taken:SetText("cl " .. cl_time)
				time_taken:SizeToContents()
			end
		end

		if (GAS.Logging.Menu.LogsTable.Filters) then
			GAS.Logging.Menu.SendLogs_TransactionID = GAS:StartNetworkTransaction("logging:GetFilteredPage", function()
				net.WriteUInt(GAS.Logging.Menu.LogsTable.CurrentPage, 16)
				local data = util.Compress(GAS:SerializeTable(GAS.Logging.Menu.LogsTable.Filters))
				net.WriteUInt(#data, 32)
				net.WriteData(data, #data)
				net.WriteBool(GAS.Logging.Menu.LogsTable.DeepStorage)
				net.WriteBool(ModuleFrame.AdvancedSearch.Greedy:GetChecked())
				net.WriteString(GAS.Languages:GetSelectedLanguage("logging"))
				if (GAS.Logging.Menu.LogsTable.ModuleID ~= false) then
					net.WriteBool(true)
					net.WriteUInt(GAS.Logging.Menu.LogsTable.ModuleID, 12)
				else
					net.WriteBool(false)
				end
			end, function(data_present, len)
				LogsLoaded(data_present, len, true)
			end)
		else
			GAS.Logging.Menu.SendLogs_TransactionID = GAS:StartNetworkTransaction("logging:GetPage", function()
				net.WriteUInt(GAS.Logging.Menu.LogsTable.CurrentPage, 16)
				net.WriteBool(GAS.Logging.Menu.LogsTable.ModuleID ~= false)
				net.WriteUInt(GAS.Logging.Menu.LogsTable.ModuleID or 0, 12)
				net.WriteBool(GAS.Logging.Menu.LogsTable.DeepStorage)
			end, LogsLoaded)
		end
	end

	local function LoadDamageLogs()
		if (IsValid(damage_logs_category_item)) then damage_logs_category_item:SetActive(true) end

		ModuleFrame.AdvancedSearch:SetVisible(false)
		ModuleFrame.DeepStorage:SetVisible(false)
		pagination_container:SetVisible(true)
		GAS.Logging.Menu.SearchTab:SetVisible(true)
		GAS.Logging.Menu.QuickSearch:SetVisible(true)

		time_taken:SetVisible(true)
		time_taken:SetText(L"loading_ellipsis")
		time_taken:SizeToContents()
		local time_taken_SysTime = SysTime()

		GAS.Logging.Menu.LogsTable:Clear()
		GAS.Logging.Menu.LogsTable:SetVisible(false)

		GAS.Logging.Menu.DamageLogs:Clear()
		GAS.Logging.Menu.DamageLogs:SetVisible(true)
		GAS.Logging.Menu.DamageLogs.Padding:SetVisible(true)
		GAS.Logging.Menu.DamageLogs:SetLoading(true)
		GAS.Logging.Menu.DamageLogs:MoveToAfter(GAS.Logging.Menu.LogsTable)
		GAS.Logging.Menu.DamageLogs.NoData:SetVisible(false)

		GAS.Logging.Menu.SendLogs_TransactionID = GAS:StartNetworkTransaction("logging:GetDamageLogsPage", function()
			net.WriteUInt(GAS.Logging.Menu.DamageLogs.CurrentPage, 16)
			net.WriteUInt(GAS.Logging.Menu.DamageLogs.FilterLen, 7)
			for v in pairs(GAS.Logging.Menu.DamageLogs.Filter) do
				net.WriteUInt(v, 31)
			end
		end, function(data_present, len)
			if (not IsValid(GAS.Logging.Menu.DamageLogs)) then return end
			if (not IsValid(pagination)) then return end
			GAS.Logging.Menu.DamageLogs:SetLoading(false)

			if (data_present) then
				local benchmark = net.ReadFloat()

				local is_not_filtered = net.ReadBool()
				if (is_not_filtered) then
					local pages = net.ReadUInt(16)
					pagination:SetInfinite(false)
					pagination:SetPages(math.max(pages, 1))
				else
					pagination:SetInfinite(true)
				end

				local cl_time = math.Round(SysTime() - time_taken_SysTime, 2)
				if (cl_time >= 1) then
					cl_time = cl_time .. "s"
				else
					cl_time = cl_time * 1000 .. "ms"
				end

				local sv_time = math.Round(benchmark, 2)
				if (sv_time >= 1) then
					sv_time = sv_time .. "s"
				else
					sv_time = sv_time * 1000 .. "ms"
				end

				time_taken:SetText("cl " .. cl_time .. " / sv " .. sv_time)
				time_taken:SizeToContents()
				time_taken:MoveToAfter(GAS.Logging.Menu.DamageLogs.Padding)
			else
				pagination:SetInfinite(false)
				if (GAS.Logging.Menu.DamageLogs.FilterLen > 0) then
					pagination:SetPages(pagination:GetPage())
				end

				GAS.Logging.Menu.DamageLogs.NoData:SetVisible(true)

				local cl_time = math.Round(SysTime() - time_taken_SysTime, 2)
				if (cl_time >= 1) then
					cl_time = cl_time .. "s"
				else
					cl_time = cl_time * 1000 .. "ms"
				end

				time_taken:SetText("cl " .. cl_time)
				time_taken:SizeToContents()
			end
		end)
	end

	time_taken = vgui.Create("DLabel", ModuleFrame.logs_content)
	time_taken:SetText("")
	time_taken:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	bVGUI.AttachTooltip(time_taken, {Text = L"cl_sv_tooltip"})

	function ModuleFrame.logs_content:PerformLayout()
		time_taken:AlignRight(7)
		time_taken:AlignTop(4)
		if (not self.StoreX or not self.StoreY or self.StoreX ~= self:GetWide() or self.StoreY ~= self:GetTall()) then
			self.StoreX = self:GetWide()
			self.StoreY = self:GetTall()

			GAS.Logging.Menu.SearchTab:AlignRight(10)
			if (GAS.Logging.Menu.QuickSearch.Open) then
				GAS.Logging.Menu.SearchTab:AlignBottom(pagination_container:GetTall() + GAS.Logging.Menu.QuickSearch:GetTall())
				GAS.Logging.Menu.QuickSearch:AlignBottom(pagination_container:GetTall())
			else
				GAS.Logging.Menu.SearchTab:AlignBottom(pagination_container:GetTall())
				GAS.Logging.Menu.QuickSearch:AlignBottom(pagination_container:GetTall() - GAS.Logging.Menu.QuickSearch:GetTall())
			end
		end
	end

	--############# DAMAGE LOGS #############--

	GAS.Logging.Menu.DamageLogs = vgui.Create("bVGUI.LoadingScrollPanel", ModuleFrame.logs_content)
	GAS.Logging.Menu.DamageLogs:Dock(FILL)
	GAS.Logging.Menu.DamageLogs:SetMouseInputEnabled(true)
	GAS.Logging.Menu.DamageLogs.Filter = {}
	GAS.Logging.Menu.DamageLogs.FilterLen = 0

	GAS.Logging.Menu.DamageLogs.Padding = vgui.Create("bVGUI.BlankPanel", ModuleFrame.logs_content)
	GAS.Logging.Menu.DamageLogs.Padding:Dock(TOP)
	GAS.Logging.Menu.DamageLogs.Padding:SetTall(24)
	GAS.Logging.Menu.DamageLogs.Padding:SetVisible(false)
	function GAS.Logging.Menu.DamageLogs.Padding:Paint(w,h)
		surface.SetDrawColor(51,80,114)
		surface.DrawRect(0,0,w,h - 1)

		surface.SetDrawColor(31,48,68)
		surface.DrawLine(0,h - 1,w,h - 1)
	end

	GAS.Logging.Menu.DamageLogs.NoData = vgui.Create("DLabel", ModuleFrame.logs_content)
	GAS.Logging.Menu.DamageLogs.NoData:Dock(FILL)
	GAS.Logging.Menu.DamageLogs.NoData:SetMouseInputEnabled(false)
	GAS.Logging.Menu.DamageLogs.NoData:SetText(L"no_data")
	GAS.Logging.Menu.DamageLogs.NoData:SetTextColor(bVGUI.COLOR_WHITE)
	GAS.Logging.Menu.DamageLogs.NoData:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	GAS.Logging.Menu.DamageLogs.NoData:SetContentAlignment(5)
	GAS.Logging.Menu.DamageLogs.NoData:SetVisible(false)

	GAS.Logging.Menu.DamageLogs.SearchPanel = vgui.Create("bVGUI.BlankPanel", ModuleFrame.logs_content)
	GAS.Logging.Menu.DamageLogs.SearchPanel:SetWide(0)
	GAS.Logging.Menu.DamageLogs.SearchPanel:DockPadding(10,10,10,10)
	GAS.Logging.Menu.DamageLogs.SearchPanel.Open = false
	function GAS.Logging.Menu.DamageLogs.SearchPanel:Paint(w,h)
		self:SetSize(175, ModuleFrame.logs_content:GetTall() - 30 - 24)
		self:SetPos(ModuleFrame:GetWide() - w, 24)
		surface.SetDrawColor(19,19,19,255)
		surface.DrawRect(0,0,w,h)
	end
	function GAS.Logging.Menu.DamageLogs.SearchPanel:PaintOver(w,h)
		surface.SetDrawColor(255,255,255,150)
		surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
		surface.DrawTexturedRect(0,0,10,h)
	end

	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter = vgui.Create("bVGUI.Button", GAS.Logging.Menu.DamageLogs.SearchPanel)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:SetText(L"clear_filter")
	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:SetColor(bVGUI.BUTTON_COLOR_RED)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:SetDisabled(true)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:SetTall(30)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:Dock(TOP)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:DockMargin(0,0,0,10)
	function GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:DoClick()
		GAS.Logging.Menu.DamageLogs.Filter = {}
		GAS.Logging.Menu.DamageLogs.FilterLen = 0
		self:SetDisabled(true)
		GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetDisabled(true)
		LoadDamageLogs()
		for _,v in ipairs(GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer.CheckboxItems) do
			if (v.checkbox:GetChecked()) then
				GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetDisabled(false)
				break
			end
		end
	end

	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply = vgui.Create("bVGUI.Button", GAS.Logging.Menu.DamageLogs.SearchPanel)
	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetText(L"apply_filter")
	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetDisabled(true)
	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetTall(30)
	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:Dock(TOP)
	GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:DockMargin(0,0,0,10)
	function GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:DoClick()
		GAS.Logging.Menu.DamageLogs.Filter = {}
		GAS.Logging.Menu.DamageLogs.FilterLen = 0
		for _,v in ipairs(GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer.CheckboxItems) do
			if (v.checkbox:GetChecked()) then
				GAS.Logging.Menu.DamageLogs.Filter[v.AccountID] = true
				GAS.Logging.Menu.DamageLogs.FilterLen = GAS.Logging.Menu.DamageLogs.FilterLen + 1
			end
		end
		GAS.Logging.Menu.DamageLogs.SearchPanel.ClearFilter:SetDisabled(false)
		self:SetDisabled(true)
		LoadDamageLogs()
	end

	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID = vgui.Create("bVGUI.Button", GAS.Logging.Menu.DamageLogs.SearchPanel)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID:SetText(L"manual_steamid_ellipsis")
	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID:SetTall(30)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID:Dock(TOP)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID:DockMargin(0,0,0,10)
	GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID.AccountIDs = {}
	function GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID:DoClick()
		GAS.SelectionPrompts:PromptAccountID(function(accountid)
			if (table.HasValue(GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID.AccountIDs, accountid)) then return end
			GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID.AccountIDs[#GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID.AccountIDs + 1] = accountid
			GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer:Refresh()
		end)
	end

	GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer = vgui.Create("bVGUI.ScrollPanel", GAS.Logging.Menu.DamageLogs.SearchPanel)
	GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer:Dock(FILL)
	GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer.CheckboxItems = {}
	function GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer:Refresh()
		local this = self
		local plys = {}
		for _,ply in ipairs(player.GetHumans()) do
			plys[#plys + 1] = {accountid = ply:AccountID(), name = ply:Nick()}
		end
		for _,accountid in ipairs(GAS.Logging.Menu.DamageLogs.SearchPanel.ManualSteamID.AccountIDs) do
			plys[#plys + 1] = {accountid = accountid, name = GAS:AccountIDToSteamID(accountid)}
		end
		table.SortByMember(plys, "name", true)
		for i,v in ipairs(plys) do
			if (self.CheckboxItems[i] == nil or self.CheckboxItems[i].AccountID ~= v.accountid) then
				local checkbox_item = vgui.Create("bVGUI.BlankPanel", self)
				checkbox_item:Dock(TOP)
				checkbox_item:DockPadding(0,0,0,10)
				checkbox_item:SetTall(28)
				checkbox_item.AccountID = v.accountid
				checkbox_item:SetCursor("hand")
				checkbox_item:SetMouseInputEnabled(true)
				function checkbox_item:OnMouseReleased(m)
					if (m == MOUSE_RIGHT) then
						bVGUI.PlayerTooltip.Focus()
					else
						checkbox_item.checkbox:OnMouseReleased(MOUSE_LEFT)
					end
				end

				bVGUI.PlayerTooltip.Attach(checkbox_item, {
					account_id = checkbox_item.AccountID,
					creator = checkbox_item,
					focustip = L"right_click_to_focus"
				})

				checkbox_item.checkbox = vgui.Create("bVGUI.Checkbox", checkbox_item)
				checkbox_item.checkbox:Dock(LEFT)
				checkbox_item.checkbox:DockMargin(0,0,10,0)
				function checkbox_item.checkbox:OnChange()
					local checked = false
					for _,v in ipairs(this.CheckboxItems) do
						if (v.checkbox:GetChecked()) then
							checked = true
						end
						if (GAS.Logging.Menu.DamageLogs.Filter[v.AccountID] ~= (self:GetChecked() or nil)) then
							GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetDisabled(false)
							if (checked) then break end
						end
					end
					if (not checked) then
						GAS.Logging.Menu.DamageLogs.SearchPanel.Apply:SetDisabled(true)
					end
				end

				checkbox_item.label = vgui.Create("DLabel", checkbox_item)
				checkbox_item.label:Dock(FILL)
				checkbox_item.label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
				checkbox_item.label:SetTextColor(bVGUI.COLOR_WHITE)
				checkbox_item.label:SetContentAlignment(4)
				checkbox_item.label:SetText(v.name)

				checkbox_item.avatar = vgui.Create("AvatarImage", checkbox_item)
				checkbox_item.avatar:Dock(RIGHT)
				checkbox_item.avatar:DockMargin(10,0,10,0)
				checkbox_item.avatar:SetSize(18,18)
				checkbox_item.avatar:SetSteamID(GAS:AccountIDToSteamID64(checkbox_item.AccountID), 16)
				checkbox_item.avatar:SetMouseInputEnabled(false)
				
				table.insert(self.CheckboxItems, i, checkbox_item)
			else
				self.CheckboxItems[i].label:SetText(v.name)
			end
			if (IsValid(self.CheckboxItems[i + 1])) then self.CheckboxItems[i]:MoveToBefore(self.CheckboxItems[i + 1]) end
		end
		self.pnlCanvas:InvalidateLayout()
		self:InvalidateLayout()
	end

	GAS.Logging.Menu.DamageLogs.CurrentPage = 1

	--############# ADVANCED SEARCH #############--

	ModuleFrame.AdvancedSearch = vgui.Create("bVGUI.BlankPanel", ModuleFrame.logs_content)
	ModuleFrame.AdvancedSearch:Dock(FILL)
	ModuleFrame.AdvancedSearch:SetVisible(false)

	ModuleFrame.AdvancedSearch.Image = vgui.Create("DImage", ModuleFrame.AdvancedSearch)
	ModuleFrame.AdvancedSearch.Image:SetSize(64,64)
	ModuleFrame.AdvancedSearch.Image:SetMaterial(search_mat)

	ModuleFrame.AdvancedSearch.Button = vgui.Create("bVGUI.Button", ModuleFrame.AdvancedSearch)
	ModuleFrame.AdvancedSearch.Button:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	ModuleFrame.AdvancedSearch.Button:SetText(L"tutorial")
	ModuleFrame.AdvancedSearch.Button:SetSize(125,30)
	function ModuleFrame.AdvancedSearch.Button:DoClick()
		GAS:OpenURL("https://gmodsto.re/blogs-advancedsearch-help")
	end

	ModuleFrame.AdvancedSearch.Greedy = vgui.Create("bVGUI.Switch", ModuleFrame.AdvancedSearch)
	ModuleFrame.AdvancedSearch.Greedy:SetChecked(true)
	ModuleFrame.AdvancedSearch.Greedy:SetText(L"greedy")
	bVGUI.AttachTooltip(ModuleFrame.AdvancedSearch.Greedy.ClickableArea, {Text = L"greedy_tip"})

	ModuleFrame.AdvancedSearch.Filters = vgui.Create("DPanel", ModuleFrame.AdvancedSearch)
	ModuleFrame.AdvancedSearch.Filters:SetSize(600,275)
	function ModuleFrame.AdvancedSearch.Filters:Paint(w,h)
		surface.SetDrawColor(39,43,53,255)
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(255,255,255,200)
		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT_LARGE)
		surface.DrawTexturedRect(0,0,w,h)

		surface.SetDrawColor(0,0,0,150)
		local children_num = #self.Headers:GetChildren()
		local h_w = w / children_num
		for i=1,#self.Headers:GetChildren() do
			surface.DrawLine((i * h_w) - 1, 0, (i * h_w) - 1, h)
		end
	end

	function ModuleFrame.AdvancedSearch:Paint(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(advancedsearch_dropshadow)
		local x,y = self.Filters:GetPos()
		surface.DrawTexturedRect(x - 10, y - 10, 1024, 1024)
	end

	ModuleFrame.AdvancedSearch.Filters.Headers = vgui.Create("bVGUI.BlankPanel", ModuleFrame.AdvancedSearch.Filters)
	ModuleFrame.AdvancedSearch.Filters.Headers:Dock(TOP)
	ModuleFrame.AdvancedSearch.Filters.Headers:SetTall(24)
	function ModuleFrame.AdvancedSearch.Filters.Headers:PerformLayout()
		local w = self:GetWide() / #self:GetChildren()
		local accumulative_w = 0
		for _,child in ipairs(self:GetChildren()) do
			child:SetWide(w)
			child:AlignLeft(accumulative_w)
			accumulative_w = accumulative_w + w
		end
	end

	ModuleFrame.AdvancedSearch.Filters.Buttons = vgui.Create("bVGUI.BlankPanel", ModuleFrame.AdvancedSearch.Filters)
	ModuleFrame.AdvancedSearch.Filters.Buttons:Dock(BOTTOM)
	ModuleFrame.AdvancedSearch.Filters.Buttons:SetTall(25)
	ModuleFrame.AdvancedSearch.Filters.Buttons:DockMargin(0,0,0,10)
	function ModuleFrame.AdvancedSearch.Filters.Buttons:PerformLayout()
		local w = self:GetWide() / #self:GetChildren()
		local accumulative_w = 0
		for _,child in ipairs(self:GetChildren()) do
			child:SetWide(w - 20)
			child:AlignLeft(accumulative_w + 10)
			accumulative_w = accumulative_w + w
		end
	end

	ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems = vgui.Create("bVGUI.BlankPanel", ModuleFrame.AdvancedSearch.Filters)
	ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:Dock(FILL)
	ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.Items = {{},{},{},{}}
	ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.Contents = {}
	function ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(index, item)
		item.SearchIndex = index
		if (self.Items[index][item:GetValue()]) then
			item:Remove()
		else
			self.Items[index][item:GetValue()] = item
			self:Update()
		end
	end
	function ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:RemoveItem(item)
		self.Items[item.SearchIndex][item:GetValue()] = nil
		item:Remove()
		self:Update()
	end
	function ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:Update()
		for _,items in ipairs(self.Items) do
			for i in pairs(items) do
				ModuleFrame.AdvancedSearch.Filters.ClearButton:SetDisabled(false)
				ModuleFrame.AdvancedSearch.Filters.DoSearch:SetDisabled(false)
				advanced_search_category_item:SetForcedActive(GAS.Logging.Menu.LogsTable.Filters ~= nil)
				return
			end
		end
		GAS.Logging.Menu.LogsTable.Filters = nil
		ModuleFrame.AdvancedSearch.Filters.ClearButton:SetDisabled(true)
		ModuleFrame.AdvancedSearch.Filters.DoSearch:SetDisabled(true)
		advanced_search_category_item:SetForcedActive(false)
	end
	function ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:GetFilters()
		local all_filters = {}
		for filter_i,filters in ipairs(self.Items) do
			all_filters[filter_i] = {}
			for i,item in pairs(filters) do
				all_filters[filter_i][i] = true
			end
		end
		return all_filters
	end

	function ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:PerformLayout()
		local w = self:GetWide() / #self:GetChildren()
		local accumulative_w = 0
		for _,child in ipairs(self:GetChildren()) do
			child:SetSize(w, self:GetTall())
			child:AlignLeft(accumulative_w)
			accumulative_w = accumulative_w + w
		end
	end

	ModuleFrame.AdvancedSearch.Filters.Categories = {}
	for i,v in ipairs({
		{
			label = L"modules",
			btn = L"add_module",
			color = Color(135,0,135),
			tooltip = L"modules_search_tooltip",
			func = function(content, col)
				GAS:PlaySound("btn_light")
				local is_operator = OpenPermissions:IsOperator(LocalPlayer())
				local menu = DermaMenu()
				for category_name, modules in pairs(GAS.Logging.Modules) do
					if (GAS:table_IsEmpty(modules)) then continue end
					local category_submenu, category_option
					local colored_the_icon = false
					for module_name, module_data in pairs(modules) do
						if (not is_operator and OpenPermissions:GetPermission(LocalPlayer(), "gmodadminsuite_logging/" .. category_name .. "/" .. module_name) == OpenPermissions.CHECKBOX.CROSSED) then continue end
						if (not category_submenu) then
							category_submenu, category_option = menu:AddSubMenu(category_name)
						end
						if (not colored_the_icon) then
							colored_the_icon = true
							bVGUI_DermaMenuOption_ColorIcon(category_option, module_data.Colour)
						end
						bVGUI_DermaMenuOption_ColorIcon(category_submenu:AddOption(module_name, function()
							GAS:PlaySound("btn_heavy")
							local item = vgui.Create("GAS.Logging.AdvancedSearchItem", content)
							item:SetValue(module_data.ModuleID)
							item:SetText(category_name .. " ➞ " .. module_name)
							item:SetColor(module_data.Colour)
							ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(1, item)
						end), module_data.Colour)
					end
				end
				menu:Open()
			end,
		},
		{
			label = L"players",
			btn = L"add_player",
			color = bVGUI.COLOR_GMOD_BLUE,
			tooltip = L"players_search_tooltip",
			func = function(content)
				GAS.SelectionPrompts:PromptAccountID(function(account_id, ply)
					local item = vgui.Create("GAS.Logging.AdvancedSearchItem", content)
					item:SetAccountID(account_id)
					item:SetValue(tostring(account_id))
					if (IsValid(ply)) then
						item:SetText(ply:Nick())
						item:SetColor(team.GetColor(ply:Team()))
					else
						item:SetText(GAS:AccountIDToSteamID(account_id))
					end
					ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(2, item)
				end)
			end,
		},
		{
			label = L"entities",
			btn = L"add_entity",
			color = Color(255,120,0),
			tooltip = L"entities_search_tooltip",
			func = function(content, col)
				GAS:PlaySound("popup")
				GAS.Logging:ShowClassSelector(content)
	
				ModuleFrame.CloseFrames = ModuleFrame.CloseFrames or {}
				ModuleFrame.CloseFrames[GAS.Logging.ClassSelector] = true
			end,
		},
		{
			label = L"strings",
			btn = L"add_string",
			color = Color(76,216,76),
			tooltip = L"strings_search_tooltip",
			func = function(content, col)
				GAS:PlaySound("popup")
				
				ModuleFrame.CloseFrames = ModuleFrame.CloseFrames or {}
				ModuleFrame.CloseFrames[
					bVGUI.StringQuery(L"add_string_popup_title", L"add_string_popup_text", L"text_ellipsis", function(str)
						local item = vgui.Create("GAS.Logging.AdvancedSearchItem", content)
						item:SetValue(str)
						item:SetColor(col)
						ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(4, item)
					end)
				] = true
			end,
		},
	}) do
		local header = vgui.Create("bVGUI.Header", ModuleFrame.AdvancedSearch.Filters.Headers)
		header:SetText(v.label)
		header:SetColor(v.color)

		local content = vgui.Create("bVGUI.ScrollPanel", ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems)
		ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.Contents[i] = content
		content.pnlCanvas:DockPadding(5,5,10,5)

		if (i == 2) then
			ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.PlayerPnl = content
		end

		function content.pnlCanvas:RemoveItem(item)
			ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:RemoveItem(item)
		end

		local button = vgui.Create("bVGUI.Button", ModuleFrame.AdvancedSearch.Filters.Buttons)
		button:SetTall(25)
		button:SetText(v.btn)
		button:SetColor(v.color)
		if (v.func) then
			function button:DoClick()
				v.func(content, v.color)
			end
		end

		if (v.tooltip) then
			button:SetTooltip({
				Text = v.tooltip,
				VGUI_Element = button
			})
			function header:OnCursorEntered()
				bVGUI.CreateTooltip({
					Text = v.tooltip,
					VGUI_Element = self
				})
			end
			function header:OnCursorExit()
				bVGUI.DestroyTooltip()
			end
		end
	end

	ModuleFrame.AdvancedSearch.Actions = vgui.Create("bVGUI.BlankPanel", ModuleFrame.AdvancedSearch)
	ModuleFrame.AdvancedSearch.Actions:SetSize(125 + 15 + 125, 30)

	ModuleFrame.AdvancedSearch.Filters.ClearButton = vgui.Create("bVGUI.Button", ModuleFrame.AdvancedSearch.Actions)
	ModuleFrame.AdvancedSearch.Filters.ClearButton:SetSize(125,30)
	ModuleFrame.AdvancedSearch.Filters.ClearButton:SetColor(bVGUI.BUTTON_COLOR_RED)
	ModuleFrame.AdvancedSearch.Filters.ClearButton:SetText(L"clear_filters")
	ModuleFrame.AdvancedSearch.Filters.ClearButton:SetDisabled(true)
	function ModuleFrame.AdvancedSearch.Filters.ClearButton:DoClick()
		GAS:PlaySound("flash")
		GAS.Logging.Menu.LogsTable.Filters = nil
		self:SetDisabled(true)
		for _,filters in ipairs(ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.Items) do
			for _,filter in pairs(filters) do
				filter:Remove()
			end
		end
		ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.Items = {{},{},{},{}}
		ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:Update()
	end

	ModuleFrame.AdvancedSearch.Filters.DoSearch = vgui.Create("bVGUI.Button", ModuleFrame.AdvancedSearch.Actions)
	ModuleFrame.AdvancedSearch.Filters.DoSearch:SetSize(125,30)
	ModuleFrame.AdvancedSearch.Filters.DoSearch:SetColor(bVGUI.BUTTON_COLOR_GREEN)
	ModuleFrame.AdvancedSearch.Filters.DoSearch:SetText(L"advanced_search")
	ModuleFrame.AdvancedSearch.Filters.DoSearch:SetDisabled(true)
	bVGUI.AttachTooltip(ModuleFrame.AdvancedSearch.Filters.DoSearch, {Text = L"deep_storage_advanced_search_warning"})
	function ModuleFrame.AdvancedSearch.Filters.DoSearch:DoClick()
		GAS:PlaySound("success")

		damage_logs_mode = false
		GAS.Logging.Menu.LogsTable.CurrentPage = 1
		GAS.Logging.Menu.LogsTable.ModuleID = false
		GAS.Logging.Menu.LogsTable.Filters = GAS.Logging.Menu.AdvancedSearch.Filters.AdvancedSearchItems:GetFilters() or nil

		advanced_search_category_item:SetForcedActive(true)
		LoadLogs()
	end

	function ModuleFrame.AdvancedSearch.Actions:PerformLayout()
		local w = ModuleFrame.AdvancedSearch.Filters.ClearButton:GetWide() + ModuleFrame.AdvancedSearch.Filters.DoSearch:GetWide() + 15
		ModuleFrame.AdvancedSearch.Filters.ClearButton:AlignLeft(self:GetWide() / 2 - w / 2)
		ModuleFrame.AdvancedSearch.Filters.DoSearch:AlignLeft(self:GetWide() / 2 - w / 2 + ModuleFrame.AdvancedSearch.Filters.ClearButton:GetWide() + 15)
	end

	function ModuleFrame.AdvancedSearch:PerformLayout()
		local x,y = self:GetSize()
		x = x / 2
		y = y / 2
		local h = self.Image:GetTall() + 20 + self.Button:GetTall() + 20 + self.Greedy:GetTall() + 20 + self.Filters:GetTall() + 20 + self.Actions:GetTall()

		self.Image:SetPos(x - self.Image:GetWide() / 2, y - h / 2)
		self.Button:SetPos(x - self.Button:GetWide() / 2, y - h / 2 + self.Image:GetTall() + 20)
		self.Greedy:SetPos(x - self.Greedy:GetWide() / 2, y - h / 2 + self.Image:GetTall() + 20 + self.Button:GetTall() + 20)
		self.Filters:SetPos(x - self.Filters:GetWide() / 2, y - h / 2 + self.Image:GetTall() + 20 + self.Button:GetTall() + 20 + self.Greedy:GetTall() + 20)
		self.Actions:SetPos(x - self.Actions:GetWide() / 2, y - h / 2 + self.Image:GetTall() + 20 + self.Button:GetTall() + 20 + self.Greedy:GetTall() + 20 + self.Filters:GetTall() + 20)
	end

	--############# DEEP STORAGE #############--

	ModuleFrame.DeepStorage = vgui.Create("bVGUI.BlankPanel", ModuleFrame.logs_content)
	ModuleFrame.DeepStorage:Dock(FILL)
	ModuleFrame.DeepStorage:SetVisible(false)

	ModuleFrame.DeepStorage.Image = vgui.Create("DImage", ModuleFrame.DeepStorage)
	ModuleFrame.DeepStorage.Image:SetSize(64,64)
	ModuleFrame.DeepStorage.Image:SetMaterial(database_mat)

	ModuleFrame.DeepStorage.Text = vgui.Create("DLabel", ModuleFrame.DeepStorage)
	ModuleFrame.DeepStorage.Text:SetText(L"deep_storage_help")
	ModuleFrame.DeepStorage.Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	ModuleFrame.DeepStorage.Text:SetContentAlignment(8)
	ModuleFrame.DeepStorage.Text:SetSize(400,0)
	ModuleFrame.DeepStorage.Text:SetWrap(true)
	ModuleFrame.DeepStorage.Text:SetAutoStretchVertical(true)

	ModuleFrame.DeepStorage.ButtonContainer = vgui.Create("bVGUI.BlankPanel", ModuleFrame.DeepStorage)
	ModuleFrame.DeepStorage.ButtonContainer:SetSize(125 + 125 + 10, 30)

	ModuleFrame.DeepStorage.Button = vgui.Create("bVGUI.Button", ModuleFrame.DeepStorage.ButtonContainer)
	ModuleFrame.DeepStorage.Button:SetText(L"view_deep_storage")
	ModuleFrame.DeepStorage.Button:SetColor(bVGUI.BUTTON_COLOR_GREEN)
	ModuleFrame.DeepStorage.Button:SetSize(125,30)
	function ModuleFrame.DeepStorage.Button:DoClick()
		if (GAS.Logging.Menu.LogsTable.DeepStorage == false) then
			GAS.Logging.Menu.LogsTable.DeepStorage = true
			ModuleFrame.DeepStorage.Button:SetColor(bVGUI.BUTTON_COLOR_RED)
			ModuleFrame.DeepStorage.Button:SetText(L"exit_deep_storage")
			bVGUI.UnattachTooltip(ModuleFrame.AdvancedSearch.Filters.DoSearch)
			GAS:PlaySound("btn_on")
		else
			GAS.Logging.Menu.LogsTable.DeepStorage = false
			ModuleFrame.DeepStorage.Button:SetColor(bVGUI.BUTTON_COLOR_GREEN)
			ModuleFrame.DeepStorage.Button:SetText(L"view_deep_storage")
			bVGUI.AttachTooltip(ModuleFrame.AdvancedSearch.Filters.DoSearch, {Text = L"deep_storage_advanced_search_warning"})
			GAS:PlaySound("btn_off")
		end
		deep_storage_category_item:SetForcedActive(GAS.Logging.Menu.LogsTable.DeepStorage)
	end

	ModuleFrame.DeepStorage.LearnMore = vgui.Create("bVGUI.Button", ModuleFrame.DeepStorage.ButtonContainer)
	ModuleFrame.DeepStorage.LearnMore:SetText(L"learn_more")
	ModuleFrame.DeepStorage.LearnMore:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	ModuleFrame.DeepStorage.LearnMore:SetSize(125,30)
	function ModuleFrame.DeepStorage.LearnMore:DoClick()
		GAS:OpenURL("https://gmodsto.re/blogs-deepstorage-help")
	end

	function ModuleFrame.DeepStorage.ButtonContainer:PerformLayout()
		ModuleFrame.DeepStorage.Button:SetPos(self:GetWide() / 2 - ModuleFrame.DeepStorage.Button:GetWide() - 5, 0)
		ModuleFrame.DeepStorage.LearnMore:SetPos(self:GetWide() / 2 + 5, 0)
	end

	function ModuleFrame.DeepStorage:PerformLayout()
		local x,y = self:GetSize()
		x = x / 2
		y = y / 2
		local h = self.Image:GetTall() + 20 + self.Text:GetTall() + 20 + self.Button:GetTall()

		self.Image:SetPos(x - self.Image:GetWide() / 2, y - h / 2)
		self.Text:SetPos(x - self.Text:GetWide() / 2, y - h / 2 + self.Image:GetTall() + 20)
		self.ButtonContainer:SetPos(x - self.ButtonContainer:GetWide() / 2, y - h / 2 + self.Image:GetTall() + 20 + self.Text:GetTall() + 20)
	end

	--############# SETTINGS TAB #############--

	local settings_content = ModuleFrame.Tabs:AddTab(L"settings", Color(75,75,216))
	local settings_tabs = vgui.Create("bVGUI.Tabs", settings_content)
	settings_tabs:Dock(TOP)
	settings_tabs:SetTall(40)

	local info_content = settings_tabs:AddTab(L"module_name", Color(216,75,75))
	info_content.Logo = vgui.Create("DImage", info_content)
	info_content.Logo:SetMaterial(logo_mat)
	info_content.Logo:SetSize(256,256)

	info_content.ScriptPage = vgui.Create("bVGUI.Button", info_content)
	info_content.ScriptPage:SetText(L"script_page")
	info_content.ScriptPage:SetColor(bVGUI.BUTTON_COLOR_RED)
	info_content.ScriptPage:SetSize(150,30)
	function info_content.ScriptPage:DoClick()
		GAS:OpenURL("https://gmodsto.re/blogs")
	end

	info_content.Wiki = vgui.Create("bVGUI.Button", info_content)
	info_content.Wiki:SetText(L"wiki")
	info_content.Wiki:SetColor(bVGUI.BUTTON_COLOR_GREEN)
	info_content.Wiki:SetSize(150,30)
	function info_content.Wiki:DoClick()
		GAS:OpenURL("https://gmodsto.re/blogs-wiki")
	end

	info_content.Discord = vgui.Create("bVGUI.Button", info_content)
	info_content.Discord:SetText("Discord")
	info_content.Discord:SetColor(Color(114, 137, 218))
	info_content.Discord:SetSize(150,30)
	function info_content.Discord:DoClick()
		GAS:OpenURL("https://gmodsto.re/gmodadminsuite-discord")
	end

	function info_content:PerformLayout()
		local h = (self:GetTall() - 110 - 256 - 20) / 2
		self.Logo:SetPos((self:GetWide() - self.Logo:GetWide()) / 2, h)
		self.ScriptPage:SetPos((self:GetWide() - self.ScriptPage:GetWide()) / 2, h + ((256 + 145) / 2) + 20)
		self.Wiki:SetPos((self:GetWide() - self.Wiki:GetWide()) / 2, h + ((256 + 145) / 2) + 20 + 30 + 10)
		self.Discord:SetPos((self:GetWide() - self.Discord:GetWide()) / 2, h + ((256 + 145) / 2) + 20 + 30 + 10 + 30 + 10)
	end

	local livelogs_tab_content, livelogs_tab = settings_tabs:AddTab(L"livelogs", Color(75,216,75), OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite_logging/see_live_logs"))
	local livelogs_content

	local function LiveLogsSettings()
		if (IsValid(livelogs_content)) then
			if (IsValid(livelogs_content.btncontainer)) then
				livelogs_content.btncontainer:Remove()
			end
			livelogs_content:Remove()
		end

		livelogs_content = vgui.Create("bVGUI.ScrollPanel", livelogs_tab_content)
		livelogs_content:Dock(FILL)

		livelogs_content.btncontainer = vgui.Create("bVGUI.BlankPanel", livelogs_tab_content)
		livelogs_content.btncontainer:Dock(BOTTOM)
		livelogs_content.btncontainer:SetTall(50)
		function livelogs_content.btncontainer:Paint(w,h)
			surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
			surface.DrawRect(0,0,w,h)
			surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
			surface.DrawTexturedRect(0,0,w,h)
		end
		
		local livelogs_help = vgui.Create("bVGUI.Button", livelogs_content.btncontainer)
		livelogs_help:SetColor(bVGUI.BUTTON_COLOR_GREEN)
		livelogs_help:SetText(L"help")
		livelogs_help:SetSize(150,30)
		livelogs_help.DoClick = function()
			GAS:OpenURL("https://gmodsto.re/blogs-livelogs-help")
		end
		
		local livelogs_defaults = vgui.Create("bVGUI.Button", livelogs_content.btncontainer)
		livelogs_defaults:SetColor(bVGUI.BUTTON_COLOR_RED)
		livelogs_defaults:SetText(L"reset_to_defaults")
		livelogs_defaults:SetSize(150,30)
		livelogs_defaults.DoClick = function()
			GAS:PlaySound("success")
			bVGUI.MouseInfoTooltip.Create(L"done_exclamation")
			GAS.Logging.LiveLogs_Config = table.Copy(GAS.Logging.LiveLogs_DefaultConfig)
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_DefaultConfig)
			LiveLogsSettings()
		end

		function livelogs_content.btncontainer:PerformLayout()
			local w = (self:GetWide() - livelogs_help:GetWide() - 10 - livelogs_defaults:GetWide()) / 2
			livelogs_help:SetPos(w, (self:GetTall() - livelogs_help:GetTall()) / 2)
			livelogs_defaults:SetPos(w + livelogs_help:GetWide() + 10, (self:GetTall() - livelogs_defaults:GetTall()) / 2)
		end

		local livelogs_enabled = vgui.Create("bVGUI.Switch", livelogs_content)
		livelogs_enabled:Dock(TOP)
		livelogs_enabled:DockMargin(10,10,10,10)
		livelogs_enabled:SetText(L"livelogs_enabled")
		livelogs_enabled:SetChecked(GAS.Logging.LiveLogs_Config.enabled)
		function livelogs_enabled:OnChange()
			GAS.Logging.LiveLogs_Config.enabled = self:GetChecked()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
			if (self:GetChecked()) then
				GAS.Logging:OpenLiveLogs()
			else
				if (IsValid(GAS_Logging_LiveLogs)) then
					GAS_Logging_LiveLogs:Remove()
				end
				GAS:netStart("logging:LiveLogs")
					net.WriteBool(false)
				net.SendToServer()
			end
		end
		
		local livelogs_color = vgui.Create("bVGUI.Switch", livelogs_content)
		livelogs_color:Dock(TOP)
		livelogs_color:DockMargin(10,0,10,10)
		livelogs_color:SetText(L"color")
		livelogs_color:SetHelpText(L"livelogs_color_help")
		livelogs_color:SetChecked(GAS.Logging.LiveLogs_Config.color)
		function livelogs_color:OnChange()
			GAS.Logging.LiveLogs_Config.color = self:GetChecked()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local livelogs_rows = vgui.Create("bVGUI.NumberWang", livelogs_content)
		livelogs_rows:Dock(TOP)
		livelogs_rows:DockMargin(10,0,10,10)
		livelogs_rows:SetText(L"livelogs_rows")
		livelogs_rows:SetHelpText(L"livelogs_rows_help")
		livelogs_rows.NumberWang:SetValue(GAS.Logging.LiveLogs_Config.rows)
		livelogs_rows.NumberWang:SetDecimals(0)
		livelogs_rows.NumberWang:SetMin(1)
		livelogs_rows.NumberWang:SetMax(100)
		function livelogs_rows.NumberWang:OnValueChanged()
			GAS.Logging.LiveLogs_Config.rows = self:GetValue()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local livelogs_show_logs_for = vgui.Create("bVGUI.NumberWang", livelogs_content)
		livelogs_show_logs_for:Dock(TOP)
		livelogs_show_logs_for:DockMargin(10,0,10,10)
		livelogs_show_logs_for:SetText(L"livelogs_show_logs_for")
		livelogs_show_logs_for:SetHelpText(L"livelogs_show_logs_for_help")
		livelogs_show_logs_for.NumberWang:SetValue(GAS.Logging.LiveLogs_Config.y)
		livelogs_show_logs_for.NumberWang:SetDecimals(0)
		livelogs_show_logs_for.NumberWang:SetMin(0)
		function livelogs_show_logs_for.NumberWang:OnValueChanged()
			GAS.Logging.LiveLogs_Config.show_logs_for = self:GetValue()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local livelogs_width = vgui.Create("bVGUI.NumberWang", livelogs_content)
		livelogs_width:Dock(TOP)
		livelogs_width:DockMargin(10,0,10,10)
		livelogs_width:SetText(L"width")
		livelogs_width.NumberWang:SetValue(GAS.Logging.LiveLogs_Config.width)
		livelogs_width.NumberWang:SetDecimals(0)
		livelogs_width.NumberWang:SetMin(1)
		livelogs_width.NumberWang:SetMax(ScrW())
		function livelogs_width.NumberWang:OnValueChanged()
			GAS.Logging.LiveLogs_Config.width = self:GetValue()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local livelogs_padding = vgui.Create("bVGUI.NumberWang", livelogs_content)
		livelogs_padding:Dock(TOP)
		livelogs_padding:DockMargin(10,0,10,10)
		livelogs_padding:SetText(L"padding")
		livelogs_padding.NumberWang:SetValue(GAS.Logging.LiveLogs_Config.padding)
		livelogs_padding.NumberWang:SetDecimals(0)
		livelogs_padding.NumberWang:SetMin(0)
		function livelogs_padding.NumberWang:OnValueChanged()
			GAS.Logging.LiveLogs_Config.padding = self:GetValue()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local livelogs_position_x = vgui.Create("bVGUI.NumberWang", livelogs_content)
		livelogs_position_x:Dock(TOP)
		livelogs_position_x:DockMargin(10,0,10,10)
		livelogs_position_x:SetText(L"livelogs_position_x")
		livelogs_position_x.NumberWang:SetValue(GAS.Logging.LiveLogs_Config.x)
		livelogs_position_x.NumberWang:SetDecimals(0)
		livelogs_position_x.NumberWang:SetMin(0)
		livelogs_position_x.NumberWang:SetMax(ScrW())
		function livelogs_position_x.NumberWang:OnValueChanged()
			GAS.Logging.LiveLogs_Config.x = self:GetValue()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local livelogs_position_y = vgui.Create("bVGUI.NumberWang", livelogs_content)
		livelogs_position_y:Dock(TOP)
		livelogs_position_y:DockMargin(10,0,10,10)
		livelogs_position_y:SetText(L"livelogs_position_y")
		livelogs_position_y.NumberWang:SetValue(GAS.Logging.LiveLogs_Config.y)
		livelogs_position_y.NumberWang:SetDecimals(0)
		livelogs_position_y.NumberWang:SetMin(0)
		livelogs_position_y.NumberWang:SetMax(ScrH())
		function livelogs_position_y.NumberWang:OnValueChanged()
			GAS.Logging.LiveLogs_Config.y = self:GetValue()
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local background_color = vgui.Create("bVGUI.ColorMixer", livelogs_content)
		background_color:Dock(TOP)
		background_color:DockMargin(10,0,10,0)
		background_color:SetTall(150)
		background_color:SetColor(GAS.Logging.LiveLogs_Config.bgcolor)
		background_color:SetLabel(L"background_color")
		function background_color.ColorMixer:ValueChanged(col)
			GAS.Logging.LiveLogs_Config.bgcolor = col
			GAS:SaveLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_Config)
		end

		local padding = vgui.Create("bVGUI.BlankPanel", livelogs_content)
		padding:Dock(TOP)
		padding:SetTall(10)
	end
	livelogs_tab:SetFunction(LiveLogsSettings)

	local log_coloring_tab_content, log_coloring_tab = settings_tabs:AddTab(L"log_colouring", Color(75,75,216))
	local function LogColouringSettings()
		if (IsValid(log_coloring_tab_content.Content)) then log_coloring_tab_content.Content:Remove() end
		if (IsValid(log_coloring_tab_content.Reset)) then log_coloring_tab_content.Reset:Remove() end

		log_coloring_tab_content.Content = vgui.Create("bVGUI.Grid", log_coloring_tab_content)
		log_coloring_tab_content.Content:Dock(FILL)
		log_coloring_tab_content.Content:SetPadding(15,15)
		function log_coloring_tab_content.Content:Think()
			if (self.UpdateTimer ~= nil and self.UpdateTimer - CurTime() <= 0) then
				self.UpdateTimer = nil
				GAS:SaveLocalConfig("logging_log_formatting", GAS.Logging.LogFormattingSettings)
			end
		end

		log_coloring_tab_content.Reset = vgui.Create("bVGUI.BlankPanel", log_coloring_tab_content)
		local reset_to_defaults_c = log_coloring_tab_content.Reset
		reset_to_defaults_c:Dock(BOTTOM)
		reset_to_defaults_c:SetTall(50)
		function reset_to_defaults_c:Paint(w,h)
			surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
			surface.DrawRect(0,0,w,h)
			surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
			surface.DrawTexturedRect(0,0,w,h)
		end

		local reset_to_defaults = vgui.Create("bVGUI.Button", reset_to_defaults_c)
		reset_to_defaults:SetText(L"reset_to_defaults")
		reset_to_defaults:SetColor(bVGUI.BUTTON_COLOR_RED)
		reset_to_defaults:SetSize(150,30)
		function reset_to_defaults:DoClick()
			GAS:PlaySound("success")
			bVGUI.MouseInfoTooltip.Create(L"done_exclamation")
			GAS.Logging.LogFormattingSettings = table.Copy(GAS.Logging.LogFormattingSettings_Default)
			GAS:SaveLocalConfig("logging_log_formatting", GAS.Logging.LogFormattingSettings_Default)
			LogColouringSettings()
		end

		function reset_to_defaults_c:PerformLayout()
			reset_to_defaults:Center()
		end

		for _,v in ipairs({
			{
				label = L"highlight_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Highlight,
			},
			{
				label = L"weapon_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Weapon,
			},
			{
				label = L"money_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Money,
			},
			{
				label = L"vehicle_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Vehicle,
			},
			{
				label = L"entity_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Entity,
			},
			{
				label = L"health_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Health,
			},
			{
				label = L"armor_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Armor,
			},
			{
				label = L"usergroup_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Usergroup,
			},
			{
				label = L"unavailable_color",
				setting = GAS.Logging.LogFormattingSettings.Colors.Unavailable,
			},
		}) do
			local colormixer = vgui.Create("bVGUI.ColorMixer", log_coloring_tab_content.Content)
			colormixer:SetSize(250,150)
			colormixer:SetColor(v.setting)
			colormixer:SetLabel(v.label)
			function colormixer.ColorMixer:ValueChanged(col)
				v.setting.r = col.r
				v.setting.g = col.g
				v.setting.b = col.b
				log_coloring_tab_content.Content.UpdateTimer = CurTime() + .5
			end
			log_coloring_tab_content.Content:AddToGrid(colormixer)
		end
	end
	log_coloring_tab:SetFunction(LogColouringSettings)

	if (is_operator) then
		local operator_content, operator_tab = ModuleFrame.Tabs:AddTab(L"operator", Color(216,75,75))
		operator_tab:SetFunction(function()
			local save_btn_disabled = not IsValid(operator_content.save_btn) or operator_content.save_btn:GetDisabled()
			if (IsValid(operator_content.Content)) then operator_content.Content:Remove() end
			operator_content.Content = vgui.Create("bVGUI.BlankPanel", operator_content)
			operator_content.Content:Dock(FILL)

			local categories_container = vgui.Create("bVGUI.BlankPanel", operator_content.Content)
			categories_container:Dock(LEFT)
			categories_container:SetWide(175)

			local categories = vgui.Create("bVGUI.Categories", categories_container)
			categories:Dock(FILL)
			categories:SetWide(175)
			categories:SetLoading(true)

			local save_btn_container = vgui.Create("bVGUI.BlankPanel", categories_container)
			save_btn_container:Dock(BOTTOM)
			save_btn_container:SetTall(64)
			save_btn_container:DockPadding(7,0,7,7)
			function save_btn_container:Paint(w,h)
				surface.SetDrawColor(bVGUI.COLOR_SLATE)
				surface.DrawRect(0,0,w,h)
			end

			local permissions_btn = vgui.Create("bVGUI.Button", save_btn_container)
			permissions_btn:Dock(TOP)
			permissions_btn:DockMargin(0,0,0,7)
			permissions_btn:SetTall(25)
			permissions_btn:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
			permissions_btn:SetText(L"permissions")
			function permissions_btn:DoClick()
				GAS:PlaySound("flash")
				RunConsoleCommand("openpermissions", "gmodadminsuite_logging")
			end

			local save_btn = vgui.Create("bVGUI.Button", save_btn_container)
			operator_content.save_btn = save_btn
			save_btn:Dock(TOP)
			save_btn:SetText(L"save_settings")
			save_btn:SetColor(bVGUI.BUTTON_COLOR_RED)
			save_btn:SetSize(150,25)
			save_btn:SetDisabled(save_btn_disabled)

			function operator_content:PaintOver(w,h)
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
				surface.DrawTexturedRect(categories:GetWide(),0,10,h)
			end

			local settings_content
			local function init_content()
				if (IsValid(settings_content)) then
					settings_content:Remove()
				end
				settings_content = vgui.Create("bVGUI.BlankPanel", operator_content.Content)
				settings_content:Dock(FILL)
			end

			local function OpenFilterEditor(filter_data, title, text, placeholder, callback)
				if (not IsValid(ModuleFrame)) then return end

				GAS:PlaySound("popup")

				local filter_editor = vgui.Create("bVGUI.Frame")

				ModuleFrame.CloseFrames = ModuleFrame.CloseFrames or {}
				ModuleFrame.CloseFrames[filter_editor] = true

				filter_editor:SetSize(250,300)
				filter_editor:SetTitle(title)
				filter_editor:MakePopup()
				filter_editor:Center()

				local filters = vgui.Create("bVGUI.Table", filter_editor)
				filters:Dock(FILL)
				filters:AddColumn(L"weapon_class")
				filters:SetRowCursor("hand")
				for weapon_class in pairs(filter_data) do
					filters:AddRow(weapon_class)
				end
				function filters:OnRowClicked(row)
					GAS:PlaySound("delete")
					filters:RemoveRow(row.RowIndex)
				end

				local save_btn_container = vgui.Create("bVGUI.BlankPanel", filter_editor)
				save_btn_container:Dock(BOTTOM)
				save_btn_container:SetTall(45)
				function save_btn_container:Paint(w,h)
					surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
					surface.DrawRect(0,0,w,h)
				end

				local add_btn = vgui.Create("bVGUI.Button", save_btn_container)
				add_btn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
				add_btn:SetText(L"add_new")
				add_btn:SetSize(150,25)
				function add_btn:DoClick()
					GAS:PlaySound("popup")

					ModuleFrame.CloseFrames = ModuleFrame.CloseFrames or {}
					ModuleFrame.CloseFrames[
						bVGUI.StringQuery(title, text, placeholder, function(class_name)
							filters:AddRow(class_name)
						end)
					] = true
				end

				local save_btn = vgui.Create("bVGUI.Button", save_btn_container)
				save_btn:SetColor(bVGUI.BUTTON_COLOR_GREEN)
				save_btn:SetText(L"save")
				save_btn:SetSize(150,25)
				function save_btn:DoClick()
					GAS:PlaySound("success")
					local new_filter_data = {}
					for _,row in ipairs(filters.Rows) do
						new_filter_data[row.LabelsData[1]] = true
					end
					bVGUI.MouseInfoTooltip.Create(L"saved_exclamation")
					callback(new_filter_data)
				end

				function save_btn_container:PerformLayout()
					local w = (self:GetWide() - 20 - 10) / 2
					add_btn:SetWide(w)
					save_btn:SetWide(w)
					add_btn:SetPos(10, self:GetTall() / 2 - add_btn:GetTall() / 2)
					save_btn:SetPos(10 + add_btn:GetWide() + 10, self:GetTall() / 2 - save_btn:GetTall() / 2)
				end
			end

			GAS.ConfigCache["logging"] = nil
			GAS:GetConfig("logging", function(logging_config)
				if (not IsValid(categories)) then return end
				categories:SetLoading(false)

				function save_btn:DoClick()
					GAS:PlaySound("success")
					local data = util.Compress(GAS:SerializeTable(logging_config))
					GAS:netStart("logging:SaveConfig")
						net.WriteData(data, #data)
					net.SendToServer()
					bVGUI.MouseInfoTooltip.Create(L"saved_exclamation")
					self:SetDisabled(true)
				end

				local category = categories:AddCategory(L"settings", bVGUI.COLOR_GMOD_BLUE)

				category:AddItem(L"logging_settings", function()
					init_content()

					settings_content:DockPadding(15,15,15,15)

					local form = vgui.Create("bVGUI.Form", settings_content)
					form:Dock(FILL)
					form:SetPaddings(15,15)

					form:AddSwitch(L"Player_RecordTeam", logging_config.Player_RecordTeam, "", function(state)
						logging_config.Player_RecordTeam = state
						save_btn:SetDisabled(false)
					end)
					form:AddSwitch(L"Player_RecordUsergroup", logging_config.Player_RecordUsergroup, "", function(state)
						logging_config.Player_RecordUsergroup = state
						save_btn:SetDisabled(false)
					end)
					form:AddSwitch(L"Player_RecordHealth", logging_config.Player_RecordHealth, "", function(state)
						logging_config.Player_RecordHealth = state
						save_btn:SetDisabled(false)
					end)
					form:AddSwitch(L"Player_RecordArmor", logging_config.Player_RecordArmor, "", function(state)
						logging_config.Player_RecordArmor = state
						save_btn:SetDisabled(false)
					end)
					form:AddSwitch(L"Player_RecordWeapon", logging_config.Player_RecordWeapon, "", function(state)
						logging_config.Player_RecordWeapon = state
						save_btn:SetDisabled(false)
					end)
					form:AddButton(L"Player_RecordWeapon_DoNotRecord", bVGUI.BUTTON_COLOR_BLUE, L"Player_RecordWeapon_DoNotRecord_help", function()
						OpenFilterEditor(logging_config.Player_RecordWeapon_DoNotRecord, L"Player_RecordWeapon_DoNotRecord", L"enter_weapon_class", L"weapon_class", function(filter_data)
							logging_config.Player_RecordWeapon_DoNotRecord = filter_data
							save_btn:SetDisabled(false)
						end)
					end)

					form:AddSpacing(15)

					form:AddSwitch(L"OverrideMoneyFormat", logging_config.OverrideMoneyFormat, L"OverrideMoneyFormat_help", function(state)
						logging_config.OverrideMoneyFormat = state
						save_btn:SetDisabled(false)
					end)
					form:AddTextEntry(L"MoneyFormat", logging_config.MoneyFormat, L"MoneyFormat_help", function(val)
						logging_config.MoneyFormat = val
						save_btn:SetDisabled(false)
					end, function(val)
						return val:find("%%s") ~= nil
					end)
				end, Color(55,0,255))

				category:AddItem(L"module_settings", function()
					init_content()

					local tabs = vgui.Create("bVGUI.Tabs", settings_content)
					tabs:Dock(TOP)
					tabs:SetTall(40)

					local enabled_modules, enabled_modules_tab = tabs:AddTab(L"enabled_modules", Color(216,75,75))
					enabled_modules_tab:SetFunction(function()
						if (IsValid(enabled_modules.Content)) then enabled_modules.Content:Remove() end
						enabled_modules.Content = vgui.Create("bVGUI.BlankPanel", enabled_modules)
						enabled_modules.Content:Dock(FILL)
						enabled_modules.Content:DockMargin(15,15,15,15)

						local label = vgui.Create("DLabel", enabled_modules.Content)
						label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
						label:SetText(L"server_restart_required")
						label:SetTextColor(bVGUI.COLOR_WHITE)
						label:SetContentAlignment(5)
						label:Dock(TOP)
						label:SetTall(35)

						local enabled_modules_selector = vgui.Create("bVGUI.PermissionsSelector", enabled_modules.Content)
						enabled_modules_selector:Dock(FILL)
						enabled_modules_selector:DockMargin(15,15,15,15)

						enabled_modules_selector:NormalCheckboxes()
						enabled_modules_selector:AddPermission(L"enabled")

						function enabled_modules_selector:OnPermissionsChanged()
							for category_name, modules in pairs(self:GetPermissions()) do
								for module_name, _enabled in pairs(modules) do
									local enabled = _enabled[1]
									if (not enabled) then
										logging_config.Modules[category_name] = logging_config.Modules[category_name] or {}
										logging_config.Modules[category_name][module_name] = logging_config.Modules[category_name][module_name] or {}
										logging_config.Modules[category_name][module_name].Disabled = true
									else
										if (logging_config.Modules[category_name]) then
											if (logging_config.Modules[category_name][module_name]) then
												logging_config.Modules[category_name][module_name].Disabled = nil
												if (GAS:table_IsEmpty(logging_config.Modules[category_name][module_name])) then
													logging_config.Modules[category_name][module_name] = nil
												end
											end
											if (GAS:table_IsEmpty(logging_config.Modules[category_name])) then
												logging_config.Modules[category_name] = nil
											end
										end
									end
								end
							end
							save_btn:SetDisabled(false)
						end

						for category_name, modules in pairs(GAS.Logging.Modules) do
							local rows = {}
							local category_color
							for module_name, module_data in pairs(modules) do
								if (not category_color) then
									category_color = module_data.Colour
								end
								local checked = true
								if (logging_config.Modules[category_name] and logging_config.Modules[category_name][module_name]) then
									checked = logging_config.Modules[category_name][module_name].Disabled ~= true
								end
								table.insert(rows, {
									text = module_name,
									checked = {checked}
								})
							end
							enabled_modules_selector:AddPermissionGroup(category_name, category_color, rows)
						end
					end)
					enabled_modules_tab:OnMouseReleased(MOUSE_LEFT)

					local gamemode_modules, gamemode_modules_tab = tabs:AddTab(L"gamemode_modules", Color(75,75,216))
					gamemode_modules_tab:SetFunction(function()
						if (IsValid(gamemode_modules.Content)) then gamemode_modules.Content:Remove() end
						gamemode_modules.Content = vgui.Create("bVGUI.BlankPanel", gamemode_modules)
						gamemode_modules.Content:Dock(FILL)

						local label = vgui.Create("DLabel", gamemode_modules.Content)
						label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
						label:SetText(L"server_restart_required" .. "\n\n" .. L"gamemode_modules_tip")
						label:SetTextColor(bVGUI.COLOR_WHITE)
						label:SetContentAlignment(5)
						label:SizeToContents()
						label:SetPos(15,15)

						local form = vgui.Create("bVGUI.Form", gamemode_modules.Content)
						form:Dock(FILL)
						form:SetPaddings(15,15)
						form:SetColumns(bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK, bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK)

						form:AddCheckbox("DarkRP", logging_config.ForcedGamemode_DarkRP, "", function(state)
							logging_config.ForcedGamemode_DarkRP = state
							save_btn:SetDisabled(false)
						end)
						form:AddCheckbox("Trouble in Terrorist Town", logging_config.ForcedGamemode_TTT, "", function(state)
							logging_config.ForcedGamemode_TTT = state
							save_btn:SetDisabled(false)
						end)
						form:AddCheckbox("Murder", logging_config.ForcedGamemode_Murder, "", function(state)
							logging_config.ForcedGamemode_Murder = state
							save_btn:SetDisabled(false)
						end)
						form:AddCheckbox("Cinema", logging_config.ForcedGamemode_Cinema, "", function(state)
							logging_config.ForcedGamemode_Cinema = state
							save_btn:SetDisabled(false)
						end)
						form:AddCheckbox("Sandbox", logging_config.ForcedGamemode_Sandbox, "", function(state)
							logging_config.ForcedGamemode_Sandbox = state
							save_btn:SetDisabled(false)
						end)

						function gamemode_modules.Content:PerformLayout()
							self:DockPadding(15,15 + label:GetTall() + 15,15,15)
						end
					end)

					local third_party_addons, third_party_addons_tab = tabs:AddTab(L"third_party_addons", Color(216,100,0))
					third_party_addons_tab:SetFunction(function()
						if (IsValid(third_party_addons.Content)) then third_party_addons.Content:Remove() end
						third_party_addons.Content = vgui.Create("bVGUI.BlankPanel", third_party_addons)
						third_party_addons.Content:Dock(FILL)

						local label = vgui.Create("DLabel", third_party_addons.Content)
						label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
						label:SetText(L"server_restart_required" .. "\n\n" .. L"third_party_addons_tip")
						label:SetTextColor(bVGUI.COLOR_WHITE)
						label:SetContentAlignment(5)
						label:SizeToContents()
						label:SetPos(15,15)

						local form = vgui.Create("bVGUI.Form", third_party_addons.Content)
						form:Dock(FILL)
						form:SetPaddings(15,15)
						form:SetColumns(bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK, bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK, bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK)

						for name, info in pairs(GAS.Logging.ThirdPartyAddons) do
							local btn = ""
							if (info.workshop) then
								btn = vgui.Create("bVGUI.Button", form)
								btn:SetColor(Color(26,26,26))
								btn:SetText("Steam Workshop")
								function btn:DoClick()
									GAS:OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. info.workshop)
								end
							elseif (info.website) then
								btn = vgui.Create("bVGUI.Button", form)
								btn:SetColor(bVGUI.BUTTON_COLOR_RED)
								btn:SetText(L"website")
								function btn:DoClick()
									GAS:OpenURL(info.website)
								end
							elseif (info.gmodstore) then
								btn = vgui.Create("bVGUI.Button", form)
								btn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
								btn:SetText("GmodStore")
								function btn:DoClick()
									GAS:OpenURL("https://gmodstore.com/market/view/" .. info.gmodstore)
								end
							end
							if (ispanel(btn)) then
								btn:SetSize(150,25)
							end
							form:AddCheckbox(name, logging_config.InstalledAddons[name] or 0, btn, function(state)
								if (state == 0) then
									logging_config.InstalledAddons[name] = nil
								else
									logging_config.InstalledAddons[name] = state
								end
							end)
						end

						function third_party_addons.Content:PerformLayout()
							self:DockPadding(15,15 + label:GetTall() + 15,15,15)
						end
					end)

					local discord, discord_tab = tabs:AddTab("Discord", Color(114, 137, 218))
					discord_tab:SetFunction(function()
						if (IsValid(discord.Content)) then discord.Content:Remove() end
						discord.Content = vgui.Create("bVGUI.BlankPanel", discord)
						discord.Content:Dock(FILL)
						discord.Content:DockMargin(15,15,15,15)

						local discord_selector
						local function CreateDiscordSelector()
							discord_selector = vgui.Create("bVGUI.PermissionsSelector", discord.Content)
							discord_selector:Dock(FILL)
							discord_selector:DockMargin(15,15,15,15)

							discord_selector:NormalCheckboxes()

							local sorted_webhooks = {}
							for name, webhook in pairs(logging_config.DiscordWebhooks) do
								table.insert(sorted_webhooks, {name = name, webhook = webhook})
							end
							table.SortByMember(sorted_webhooks, "name")

							for _,webhook in ipairs(sorted_webhooks) do
								discord_selector:AddPermission(webhook.name)
							end

							function discord_selector:OnPermissionsChanged()
								for category_name, modules in pairs(self:GetPermissions()) do
									for module_name, webhooks_enabled in pairs(modules) do
										for webhook_index, webhook_enabled in ipairs(webhooks_enabled) do
											if (webhook_enabled) then
												logging_config.Modules[category_name] = logging_config.Modules[category_name] or {}
												logging_config.Modules[category_name][module_name] = logging_config.Modules[category_name][module_name] or {}
												logging_config.Modules[category_name][module_name].DiscordWebhooks = logging_config.Modules[category_name][module_name].DiscordWebhooks or {}
												logging_config.Modules[category_name][module_name].DiscordWebhooks[sorted_webhooks[webhook_index].name] = true
											else
												if (logging_config.Modules[category_name]) then
													if (logging_config.Modules[category_name][module_name]) then
														if (logging_config.Modules[category_name][module_name].DiscordWebhooks) then
															logging_config.Modules[category_name][module_name].DiscordWebhooks[sorted_webhooks[webhook_index].name] = nil
														end
													end
												end
											end
										end
									end
								end
								logging_config.Modules = GAS:table_RemoveEmptyChildren(logging_config.Modules)
								save_btn:SetDisabled(false)
							end

							for category_name, modules in pairs(GAS.Logging.Modules) do
								local rows = {}
								local category_color
								for module_name, module_data in pairs(modules) do
									if (not category_color) then
										category_color = module_data.Colour
									end
									local checked = {}
									for _,webhook in ipairs(sorted_webhooks) do
										if (logging_config.Modules[category_name]) then
											if (logging_config.Modules[category_name][module_name]) then
												if (logging_config.Modules[category_name][module_name].DiscordWebhooks) then
													if (logging_config.Modules[category_name][module_name].DiscordWebhooks[webhook.name] == true) then
														table.insert(checked, true)
														continue
													end
												end
											end
										end
										table.insert(checked, false)
									end
									table.insert(rows, {
										text = module_name,
										checked = checked
									})
								end
								discord_selector:AddPermissionGroup(category_name, category_color, rows)
							end
						end

						local btn_container = vgui.Create("bVGUI.BlankPanel", discord.Content)
						btn_container:Dock(TOP)
						btn_container:SetTall(40)

						local btn = vgui.Create("bVGUI.Button", btn_container)
						btn:SetSize(150,25)
						btn:SetText(L"edit_discord_webhooks")
						btn:SetColor(Color(114,137,218))
						function btn:DoClick()
							if (not IsValid(ModuleFrame)) then return end

							GAS:PlaySound("popup")

							local discord_webhook_editor = vgui.Create("bVGUI.Frame")

							ModuleFrame.CloseFrames = ModuleFrame.CloseFrames or {}
							ModuleFrame.CloseFrames[discord_webhook_editor] = true

							discord_webhook_editor:SetSize(450,300)
							discord_webhook_editor:SetTitle(L"edit_discord_webhooks")
							discord_webhook_editor:Center()
							discord_webhook_editor:MakePopup()

							local discord_webhooks = vgui.Create("bVGUI.Table", discord_webhook_editor)
							discord_webhooks:Dock(FILL)
							discord_webhooks:AddColumn(L"name")
							discord_webhooks:AddColumn(L"webhook")
							discord_webhooks:SetRowCursor("hand")

							function discord_webhooks:OnRowClicked(row)
								GAS:PlaySound("btn_heavy")
								local menu = DermaMenu()
								menu:AddOption(L"remove", function()
									GAS:PlaySound("delete")
									discord_webhooks:RemoveRow(row.RowIndex)
								end):SetIcon("icon16/delete.png")
								menu:AddOption(L"copy_webhook", function()
									GAS:SetClipboardText(row.LabelsData[2])
								end):SetIcon("icon16/page_copy.png")
								menu:Open()
							end

							for name, webhook in pairs(logging_config.DiscordWebhooks) do
								discord_webhooks:AddRow(name, webhook)
							end

							local save_btn_container = vgui.Create("bVGUI.BlankPanel", discord_webhook_editor)
							save_btn_container:Dock(BOTTOM)
							save_btn_container:SetTall(45)
							function save_btn_container:Paint(w,h)
								surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
								surface.DrawRect(0,0,w,h)
							end

							local add_btn = vgui.Create("bVGUI.Button", save_btn_container)
							add_btn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
							add_btn:SetText(L"add_new")
							add_btn:SetSize(150,25)
							function add_btn:DoClick()
								GAS:PlaySound("popup")
								
								discord_webhook_editor.CloseFrames = discord_webhook_editor.CloseFrames or {}
								discord_webhook_editor.CloseFrames[
									bVGUI.StringQuery(L"webhook_name", L"webhook_name_tip", L"webhook_name", function(webhook_name)
										GAS:PlaySound("jump")
										discord_webhook_editor.CloseFrames[
											bVGUI.StringQuery(webhook_name, L"webhook_url_tip", L"webhook_url", function(webhook_url)
												discord_webhooks:AddRow(webhook_name, webhook_url)
											end, function(text)
												return text:lower():gsub("discordapp%.com", "discord%.com"):find("^https://discord%.com/api/webhooks/%d+/.-$") ~= nil
											end)
										] = true
									end)
								] = true
							end

							local discord_save_btn = vgui.Create("bVGUI.Button", save_btn_container)
							discord_save_btn:SetColor(bVGUI.BUTTON_COLOR_GREEN)
							discord_save_btn:SetText(L"save")
							discord_save_btn:SetSize(150,25)
							function discord_save_btn:DoClick()
								GAS:PlaySound("success")
								bVGUI.MouseInfoTooltip.Create(L"saved_exclamation")
								for webhook_name in pairs(logging_config.DiscordWebhooks) do
									local found = false
									for _,row in ipairs(discord_webhooks.Rows) do
										if (row.LabelsData[1] == webhook_name) then
											found = true
											break
										end
									end
									if (not found) then
										for category, modules in pairs(logging_config.Modules) do
											for module_name, data in pairs(modules) do
												if (data.DiscordWebhooks) then
													data.DiscordWebhooks[webhook_name] = nil
													if (GAS:table_IsEmpty(data.DiscordWebhooks)) then
														data.DiscordWebhooks = nil
														if (GAS:table_IsEmpty(data)) then
															modules[module_name] = nil
															if (GAS:table_IsEmpty(modules)) then
																logging_config.Modules[category] = nil
															end
														end
													end
												end
											end
										end
									end
								end
								logging_config.DiscordWebhooks = {}
								for _,row in ipairs(discord_webhooks.Rows) do
									logging_config.DiscordWebhooks[row.LabelsData[1]] = row.LabelsData[2]
								end
								CreateDiscordSelector()
								save_btn:SetDisabled(false)
							end

							function save_btn_container:PerformLayout()
								local w = (self:GetWide() - 20 - 10) / 2
								add_btn:SetWide(w)
								discord_save_btn:SetWide(w)
								add_btn:SetPos(10, self:GetTall() / 2 - add_btn:GetTall() / 2)
								discord_save_btn:SetPos(10 + add_btn:GetWide() + 10, self:GetTall() / 2 - discord_save_btn:GetTall() / 2)
							end
						end

						local btn2 = vgui.Create("bVGUI.Button", btn_container)
						btn2:SetColor(bVGUI.BUTTON_COLOR_GREEN)
						btn2:SetText(L"help")
						btn2:SetSize(150,25)
						function btn2:DoClick()
							GAS:OpenURL("https://gmodsto.re/blogs-webhooks-help")
						end

						function btn_container:PerformLayout()
							local w = (self:GetWide() - btn:GetWide() - 10 - btn2:GetWide()) / 2
							btn:SetPos(w, self:GetTall() / 2 - btn:GetTall() / 2)
							btn2:SetPos(w + 10 + btn:GetWide(), self:GetTall() / 2 - btn2:GetTall() / 2)
						end

						CreateDiscordSelector()
					end)
				end, Color(255,0,120))

				category:AddItem(L"storage_settings", function()
					init_content()

					settings_content:DockPadding(15,15,15,15)

					local form = vgui.Create("bVGUI.Form", settings_content)
					form:Dock(FILL)
					form:SetPaddings(15,15)

					form:AddSwitch(L"DeepStorageEnabled", logging_config.DeepStorageEnabled == nil or logging_config.DeepStorageEnabled == true, L"DeepStorageEnabled_help", function(state)
						logging_config.DeepStorageEnabled = state
						save_btn:SetDisabled(false)
					end)

					form:AddSwitch(L"DeepStorageCommitOnShutdown", logging_config.DeepStorageCommitOnShutdown == nil or logging_config.DeepStorageCommitOnShutdown == true, L"DeepStorageCommitOnShutdown_help", function(state)
						logging_config.DeepStorageCommitOnShutdown = state
						save_btn:SetDisabled(false)
					end)

					form:AddNumberEntry(L"DeepStorageCommitPeriod", logging_config.DeepStorageCommitPeriod or 60, L"DeepStorageCommitPeriod_help", function(state)
						logging_config.DeepStorageCommitPeriod = state
						save_btn:SetDisabled(false)
					end)

					form:AddNumberEntry(L"DeepStorageTooOld", logging_config.DeepStorageTooOld, L"DeepStorageTooOld_help", function(state)
						logging_config.DeepStorageTooOld = state
						save_btn:SetDisabled(false)
					end)
				end, Color(0,150,255))

				category:AddItem(L"pvp_settings", function()
					init_content()

					settings_content:DockPadding(15,15,15,15)

					local form = vgui.Create("bVGUI.Form", settings_content)
					form:Dock(FILL)
					form:SetPaddings(15,15)

					form:AddNumberEntry(L"TimeBetweenPvPEvents", logging_config.TimeBetweenPvPEvents, L"TimeBetweenPvPEvents_help", function(val)
						logging_config.TimeBetweenPvPEvents = val
						save_btn:SetDisabled(false)
					end)

					form:AddButton(L"NonPvPWeapons", bVGUI.BUTTON_COLOR_BLUE, L"NonPvPWeapons_help", function(val)
						OpenFilterEditor(logging_config.NonPvPWeapons, L"NonPvPWeapons", L"enter_weapon_class", L"weapon_class", function(filter_data)
							logging_config.NonPvPWeapons = filter_data
							save_btn:SetDisabled(false)
						end)
					end)
				end, Color(255,0,0))

				category:AddItem(L"live_logs_settings", function()
					init_content()

					local livelogs_settings_tabs = vgui.Create("bVGUI.Tabs", settings_content)
					livelogs_settings_tabs:Dock(TOP)
					livelogs_settings_tabs:SetTall(40)

					local general_content = livelogs_settings_tabs:AddTab(L"general", Color(76,216,76))

						general_content:DockPadding(15,15,15,15)

						local form = vgui.Create("bVGUI.Form", general_content)
						form:Dock(FILL)
						form:SetPaddings(15,15)

						form:AddSwitch(L"LiveLogsEnabled", logging_config.LiveLogsEnabled, L"LiveLogsEnabled_help", function(state)
							logging_config.LiveLogsEnabled = state
							save_btn:SetDisabled(false)
						end)

						form:AddNumberEntry(L"LiveLogsIn10Seconds", logging_config.LiveLogsIn10Seconds, L"LiveLogsIn10Seconds_help", function(val)
							logging_config.LiveLogsIn10Seconds = val
							save_btn:SetDisabled(false)
						end)

						form:AddSwitch(L"NotifyLiveLogsAntispam", logging_config.NotifyLiveLogsAntispam, L"NotifyLiveLogsAntispam_help", function(state)
							logging_config.NotifyLiveLogsAntispam = state
							save_btn:SetDisabled(false)
						end)

					local modules_content = livelogs_settings_tabs:AddTab(L"modules", Color(216,76,216))

						modules_content:DockPadding(15,15,15,15)

						local modules_permission_editor

						local btns_container = vgui.Create("bVGUI.BlankPanel", modules_content)
						btns_container:Dock(TOP)
						btns_container:SetTall(40)

						local check_all = vgui.Create("bVGUI.Button", btns_container)
						check_all:SetSize(150,25)
						check_all:SetColor(bVGUI.BUTTON_COLOR_GREEN)
						check_all:SetText(L"check_all")
						function check_all:DoClick()
							GAS:PlaySound("flash")
							for _,row in ipairs(modules_permission_editor.Rows) do
								for _,checkbox in ipairs(row.Checkboxes) do
									checkbox:SetChecked(true)
								end
							end
							save_btn:SetDisabled(false)
						end

						local uncheck_all = vgui.Create("bVGUI.Button", btns_container)
						uncheck_all:SetSize(150,25)
						uncheck_all:SetColor(bVGUI.BUTTON_COLOR_RED)
						uncheck_all:SetText(L"uncheck_all")
						function uncheck_all:DoClick()
							GAS:PlaySound("delete")
							for _,row in ipairs(modules_permission_editor.Rows) do
								for _,checkbox in ipairs(row.Checkboxes) do
									checkbox:SetChecked(false)
								end
							end
							save_btn:SetDisabled(false)
						end

						function btns_container:PerformLayout(w)
							local _w = (w - check_all:GetWide() - 10 - uncheck_all:GetWide()) / 2
							check_all:AlignLeft(_w)
							uncheck_all:AlignLeft(_w + 10 + 150)
						end

						modules_permission_editor = vgui.Create("bVGUI.PermissionsSelector", modules_content)
						modules_permission_editor:Dock(FILL)
						modules_permission_editor:NormalCheckboxes()
						modules_permission_editor:AddPermission(L"livelogs_enabled")

						function modules_permission_editor:OnPermissionsChanged()
							for category_name, modules in pairs(self:GetPermissions()) do
								for module_name, _enabled in pairs(modules) do
									local enabled = _enabled[1]
									if (not enabled) then
										logging_config.Modules[category_name] = logging_config.Modules[category_name] or {}
										logging_config.Modules[category_name][module_name] = logging_config.Modules[category_name][module_name] or {}
										logging_config.Modules[category_name][module_name].LiveLogsDisabled = true
									else
										if (logging_config.Modules[category_name]) then
											if (logging_config.Modules[category_name][module_name]) then
												logging_config.Modules[category_name][module_name].LiveLogsDisabled = nil
												if (GAS:table_IsEmpty(logging_config.Modules[category_name][module_name])) then
													logging_config.Modules[category_name][module_name] = nil
												end
											end
											if (GAS:table_IsEmpty(logging_config.Modules[category_name])) then
												logging_config.Modules[category_name] = nil
											end
										end
									end
								end
							end
							save_btn:SetDisabled(false)
						end

						for category_name, modules in pairs(GAS.Logging.Modules) do
							local rows = {}
							local category_color
							for module_name, module_data in pairs(modules) do
								if (not category_color) then
									category_color = module_data.Colour
								end
								local checked = true
								if (logging_config.Modules[category_name] and logging_config.Modules[category_name][module_name]) then
									checked = logging_config.Modules[category_name][module_name].LiveLogsDisabled ~= true
								end
								table.insert(rows, {
									text = module_name,
									checked = {checked}
								})
							end
							modules_permission_editor:AddPermissionGroup(category_name, category_color, rows)
						end

				end, Color(0,255,115))

				category:AddItem(L"wipes_and_resets", function()
					init_content()

					settings_content:DockPadding(15,15,15,15)

					local enable_buttons = vgui.Create("bVGUI.Button", settings_content)
					enable_buttons:SetText(L"enable_buttons")
					enable_buttons:SetColor(bVGUI.BUTTON_COLOR_RED)
					enable_buttons:SetSize(150, 30)
					enable_buttons:AlignTop(15)
					enable_buttons:AlignLeft(15)

					local wipe_deepstorage = vgui.Create("bVGUI.Button", settings_content)
					wipe_deepstorage:SetText(L"wipe_deepstorage")
					wipe_deepstorage:SetColor(bVGUI.BUTTON_COLOR_RED)
					wipe_deepstorage:SetSize(150, 30)
					wipe_deepstorage:AlignTop(15 + 30 + 10)
					wipe_deepstorage:AlignLeft(15)
					wipe_deepstorage:SetDisabled(true)
					function wipe_deepstorage:DoClick()
						GAS:PlaySound("delete")
						GAS:netStart("logging:WipeDeepStorage")
						net.SendToServer()
					end

					local wipe_session = vgui.Create("bVGUI.Button", settings_content)
					wipe_session:SetText(L"wipe_session")
					wipe_session:SetColor(bVGUI.BUTTON_COLOR_RED)
					wipe_session:SetSize(150, 30)
					wipe_session:AlignTop(15 + 30 + 10 + 30 + 10)
					wipe_session:AlignLeft(15)
					wipe_session:SetDisabled(true)
					function wipe_session:DoClick()
						GAS:PlaySound("delete")
						GAS:netStart("logging:WipeSession")
						net.SendToServer()
					end

					local wipe_all_logs = vgui.Create("bVGUI.Button", settings_content)
					wipe_all_logs:SetText(L"wipe_all_logs")
					wipe_all_logs:SetColor(bVGUI.BUTTON_COLOR_RED)
					wipe_all_logs:SetSize(150, 30)
					wipe_all_logs:AlignTop(15 + 30 + 10 + 30 + 10 + 30 + 10)
					wipe_all_logs:AlignLeft(15)
					wipe_all_logs:SetDisabled(true)
					function wipe_all_logs:DoClick()
						GAS:PlaySound("delete")
						GAS:netStart("logging:WipeAllLogs")
						net.SendToServer()
					end

					local reset_config = vgui.Create("bVGUI.Button", settings_content)
					reset_config:SetText(L"reset_config")
					reset_config:SetColor(bVGUI.BUTTON_COLOR_RED)
					reset_config:SetSize(150, 30)
					reset_config:AlignTop(15 + 30 + 10 + 30 + 10 + 30 + 10 + 30 + 10)
					reset_config:AlignLeft(15)
					reset_config:SetDisabled(true)
					function reset_config:DoClick()
						GAS:PlaySound("delete")
						GAS:netStart("logging:ResetConfig")
						net.SendToServer()
						GAS:netReceive("logging:ResetConfig", function()
							operator_tab:OnMouseReleased(MOUSE_LEFT)
							net.Receivers["gmodadminsuite:logging:ResetConfig"] = nil
						end)
					end

					function enable_buttons:DoClick()
						if (wipe_deepstorage:GetDisabled()) then
							GAS:PlaySound("error")
							self:SetColor(bVGUI.BUTTON_COLOR_BLUE)
							self:SetText(L"disable_buttons")
							wipe_deepstorage:SetDisabled(false)
							wipe_session:SetDisabled(false)
							wipe_all_logs:SetDisabled(false)
							reset_config:SetDisabled(false)
						else
							GAS:PlaySound("success")
							self:SetColor(bVGUI.BUTTON_COLOR_RED)
							self:SetText(L"enable_buttons")
							wipe_deepstorage:SetDisabled(true)
							wipe_session:SetDisabled(true)
							wipe_all_logs:SetDisabled(true)
							reset_config:SetDisabled(true)
						end
					end
				end, Color(255,0,0))
			end)
		end)
	end

	GAS:StartNetworkTransaction("logging:GetModules", nil, function()
		if (not IsValid(livelogs_tab)) then return end
		
		livelogs_tab:SetEnabled(net.ReadBool())
		local data_len = net.ReadUInt(16)

		if (not IsValid(ModuleFrame)) then return end

		GAS.Logging.Modules = {}
		GAS.Logging.IndexedModules = GAS:DeserializeTable(util.Decompress(net.ReadData(data_len)))
		for module_id, module_data in pairs(GAS.Logging.IndexedModules) do
			if (module_data.Offline) then continue end
			GAS.Logging.Modules[module_data.Category] = GAS.Logging.Modules[module_data.Category] or {}
			GAS.Logging.Modules[module_data.Category][module_data.Name] = module_data
		end

		ModuleFrame.logs_content.Categories:SetLoading(false)

		ModuleFrame.logs_content.Categories:Clear()

		all_logs_category_item = ModuleFrame.logs_content.Categories:AddItem(L"all_logs", function()
			if (GAS.Logging.Menu.DamageLogs.SearchPanel.Open) then
				GAS.Logging.Menu.DamageLogs.SearchPanel.Open = false
				GAS.Logging.Menu.DamageLogs.SearchPanel:SetWide(0)
			end
			GAS.Logging.Menu.LogsTable.CurrentPage = 1
			damage_logs_mode = false
			GAS.Logging.Menu.LogsTable.ModuleID = false
			LoadLogs()
		end, Color(0,150,255))
		all_logs_category_item:OnMouseReleased(MOUSE_LEFT)
		
		if (GAS.Logging.Config.DeepStorageEnabled ~= false) then
			deep_storage_category_item = ModuleFrame.logs_content.Categories:AddItem(L"deep_storage", function()
				if (GAS.Logging.Menu.DamageLogs.SearchPanel.Open) then
					GAS.Logging.Menu.DamageLogs.SearchPanel.Open = false
					GAS.Logging.Menu.DamageLogs.SearchPanel:SetWide(0)
				end
				damage_logs_mode = false
				GAS.Logging.Menu.DamageLogs.NoData:SetVisible(false)
				ModuleFrame.AdvancedSearch:SetVisible(false)
				ModuleFrame.DeepStorage:SetVisible(true)
				time_taken:SetVisible(false)
				GAS.Logging.Menu.LogsTable:SetVisible(false)
				GAS.Logging.Menu.DamageLogs:SetVisible(false)
				GAS.Logging.Menu.DamageLogs.Padding:SetVisible(false)
				pagination_container:SetVisible(false)
				GAS.Logging.Menu.SearchTab:SetVisible(false)
				GAS.Logging.Menu.QuickSearch:SetVisible(false)
			end, Color(130,0,255))
		end

		advanced_search_category_item = ModuleFrame.logs_content.Categories:AddItem(L"advanced_search", function()
			if (GAS.Logging.Menu.DamageLogs.SearchPanel.Open) then
				GAS.Logging.Menu.DamageLogs.SearchPanel.Open = false
				GAS.Logging.Menu.DamageLogs.SearchPanel:SetWide(0)
			end
			GAS.Logging.Menu.DamageLogs.NoData:SetVisible(false)
			ModuleFrame.AdvancedSearch:SetVisible(true)
			ModuleFrame.DeepStorage:SetVisible(false)
			time_taken:SetVisible(false)
			GAS.Logging.Menu.LogsTable:SetVisible(false)
			GAS.Logging.Menu.DamageLogs:SetVisible(false)
			GAS.Logging.Menu.DamageLogs.Padding:SetVisible(false)
			pagination_container:SetVisible(false)
			GAS.Logging.Menu.SearchTab:SetVisible(false)
			GAS.Logging.Menu.QuickSearch:SetVisible(false)
		end, Color(76,255,76))

		local sorted_categories = {}
		for category_name, modules in pairs(GAS.Logging.Modules) do
			table.insert(sorted_categories, category_name)
		end
		table.sort(sorted_categories)
		for _,category_name in ipairs(sorted_categories) do
			local modules = GAS.Logging.Modules[category_name]
			local category
			local sorted_modules = table.ClearKeys(modules)
			table.ClearKeys(sorted_modules)
			table.SortByMember(sorted_modules, "Name", true)
			for i, module_data in ipairs(sorted_modules) do
				if (module_data.Disabled) then continue end
				if (not is_operator and OpenPermissions:GetPermission(LocalPlayer(), "gmodadminsuite_logging/" .. category_name .. "/" .. module_data.Name) == OpenPermissions.CHECKBOX.CROSSED) then continue end
				if (not category) then
					category = ModuleFrame.logs_content.Categories:AddCategory(category_name, module_data.Colour)
				end
				if (category_name == "PvP" and module_data.Name == "Combat Events") then
					damage_logs_category_item = ModuleFrame.logs_content.Categories:AddItem(L"player_combats", function()
						if (GAS.Logging.Menu.QuickSearch.Open) then
							GAS.Logging.Menu.SearchTab:OnMouseReleased(MOUSE_LEFT)
						end
						GAS.Logging.Menu.DamageLogs.CurrentPage = 1
						damage_logs_mode = true
						LoadDamageLogs()
					end, Color(255,0,0))
				else
					category:AddItem(module_data.Name, function()
						if (GAS.Logging.Menu.DamageLogs.SearchPanel.Open) then
							GAS.Logging.Menu.DamageLogs.SearchPanel.Open = false
							GAS.Logging.Menu.DamageLogs.SearchPanel:SetWide(0)
						end
						GAS.Logging.Menu.LogsTable.CurrentPage = 1
						damage_logs_mode = false
						GAS.Logging.Menu.LogsTable.ModuleID = module_data.ModuleID
						LoadLogs()
					end, module_data.Colour)
				end
			end
		end

		if (GAS.Logging.ViewLogs) then
			GAS.Logging.Menu:ViewPlayerLogs(GAS.Logging.ViewLogs, GAS.Logging.ViewLogsPly, GAS.Logging.ViewLogsDeepStorage)

			GAS.Logging.ViewLogs = nil
			GAS.Logging.ViewLogsPly = nil
			GAS.Logging.ViewLogsDeepStorage = nil
		end
	end)

	GAS.Logging.Menu.SearchTab = vgui.Create("bVGUI.BlankPanel", ModuleFrame.logs_content)
	GAS.Logging.Menu.SearchTab:SetSize(50,25)
	GAS.Logging.Menu.SearchTab:SetMouseInputEnabled(true)
	GAS.Logging.Menu.SearchTab:SetCursor("hand")
	function GAS.Logging.Menu.SearchTab:OnCursorEntered()
		bVGUI.CreateTooltip({
			Text = L"quick_search",
			VGUI_Element = self
		})
	end
	function GAS.Logging.Menu.SearchTab:OnCursorExited()
		bVGUI.DestroyTooltip()
	end
	function GAS.Logging.Menu.SearchTab:OnMouseReleased(m)
		local this = self
		if (m ~= MOUSE_LEFT) then return end
		if (damage_logs_mode) then
			GAS.Logging.Menu.DamageLogs.SearchPanel.Open = not GAS.Logging.Menu.DamageLogs.SearchPanel.Open
			GAS.Logging.Menu.DamageLogs.SearchPanel:SetTall(ModuleFrame.logs_content:GetTall() - 30 - 24)
			if (GAS.Logging.Menu.DamageLogs.SearchPanel.Open) then
				GAS:PlaySound("btn_on")
				GAS.Logging.Menu.DamageLogs.SearchPanel:Stop()
				GAS.Logging.Menu.DamageLogs.SearchPanel:SizeTo(175, -1, .25)
				GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer:Refresh()
				timer.Create("GAS:logging:DamageLogsSearchPanelPlayerRefresh", 1, 0, function()
					if (not IsValid(this) or not IsValid(GAS.Logging.Menu) or not IsValid(GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer)) then timer.Remove("GAS:logging:DamageLogsSearchPanelPlayerRefresh")return end		
					GAS.Logging.Menu.DamageLogs.SearchPanel.CheckboxContainer:Refresh()
				end)
			else
				GAS:PlaySound("btn_off")
				GAS.Logging.Menu.DamageLogs.SearchPanel:Stop()
				GAS.Logging.Menu.DamageLogs.SearchPanel:SizeTo(0, -1, .25)
				timer.Remove("GAS:logging:DamageLogsSearchPanelPlayerRefresh")
			end
		else
			GAS.Logging.Menu.QuickSearch.Open = not GAS.Logging.Menu.QuickSearch.Open
			if (not GAS.Logging.Menu.QuickSearch.Open) then
				GAS:PlaySound("btn_off")
				for _,row in ipairs(GAS.Logging.Menu.LogsTable.Rows) do
					row:SetVisible(true)
				end
				GAS.Logging.Menu.LogsTable:SortRows()
			else
				GAS:PlaySound("btn_on")
				GAS.Logging.Menu.QuickSearch.TextEntry:OnValueChange(GAS.Logging.Menu.QuickSearch.TextEntry:GetValue())
			end
		end
	end
	function GAS.Logging.Menu.SearchTab:Paint(w,h)
		surface.SetDrawColor(255,255,255,235)
		surface.SetMaterial(search_tab_mat)
		surface.DrawTexturedRect(0,0,64,64)
	end

	GAS.Logging.Menu.QuickSearch = vgui.Create("DPanel", ModuleFrame.logs_content)
	GAS.Logging.Menu.QuickSearch.Open = false
	GAS.Logging.Menu.QuickSearch:SetSize(160,30)
	GAS.Logging.Menu.QuickSearch:DockPadding(5,5,5,5)
	GAS.Logging.Menu.QuickSearch:SetMouseInputEnabled(true)
	function GAS.Logging.Menu.QuickSearch:Paint(w,h)
		surface.SetDrawColor(19,19,19,235)
		surface.DrawRect(0,0,w,h)
	end
	function GAS.Logging.Menu.QuickSearch:Think()
		if (not self.Y) then
			self.Y = ModuleFrame.logs_content:GetTall() - pagination_container:GetTall()
		end
		if (not GAS.Logging.Menu.SearchTab.Y) then
			GAS.Logging.Menu.SearchTab.Y = ModuleFrame.logs_content:GetTall() - pagination_container:GetTall() - GAS.Logging.Menu.SearchTab:GetTall()
		end
		local x = ModuleFrame.logs_content:GetWide() - self:GetWide() - 10
		local x2 = ModuleFrame.logs_content:GetWide() - GAS.Logging.Menu.SearchTab:GetWide() - GAS.Logging.Menu.DamageLogs.SearchPanel:GetWide() - 10
		if (self.Open) then
			self.Y = math.floor(Lerp(0.05, self.Y, ModuleFrame.logs_content:GetTall() - pagination_container:GetTall() - self:GetTall()))

			GAS.Logging.Menu.SearchTab.Y = math.floor(Lerp(0.05, GAS.Logging.Menu.SearchTab.Y, ModuleFrame.logs_content:GetTall() - pagination_container:GetTall() - self:GetTall() - GAS.Logging.Menu.SearchTab:GetTall()))
		else
			self.Y = math.ceil(Lerp(0.05, self.Y, ModuleFrame.logs_content:GetTall() - pagination_container:GetTall()))

			GAS.Logging.Menu.SearchTab.Y = math.ceil(Lerp(0.05, GAS.Logging.Menu.SearchTab.Y, ModuleFrame.logs_content:GetTall() - pagination_container:GetTall() - GAS.Logging.Menu.SearchTab:GetTall()))
		end
		self:SetPos(x, self.Y)
		GAS.Logging.Menu.SearchTab:SetPos(x2, GAS.Logging.Menu.SearchTab.Y)
	end

	GAS.Logging.Menu.QuickSearch.TextEntry = vgui.Create("bVGUI.TextEntry", GAS.Logging.Menu.QuickSearch)
	GAS.Logging.Menu.QuickSearch.TextEntry:Dock(FILL)
	GAS.Logging.Menu.QuickSearch.TextEntry:SetPlaceholderText(L"quick_search_ellipsis")
	GAS.Logging.Menu.QuickSearch.TextEntry:SetUpdateOnType(true)
	function GAS.Logging.Menu.QuickSearch.TextEntry:OnValueChange(_val)
		local val = _val:lower()
		for _,row in ipairs(GAS.Logging.Menu.LogsTable.Rows) do
			row:SetVisible(row.LabelsData[3]:lower():find(val) ~= nil)
		end
		GAS.Logging.Menu.LogsTable:SortRows()
	end
	
	pagination_container = vgui.Create("DPanel", ModuleFrame.logs_content)
	function pagination_container:Paint(w,h)
		surface.SetDrawColor(19,19,19,255)
		surface.DrawRect(0,0,w,h)
	end
	pagination_container:Dock(BOTTOM)
	pagination_container:SetTall(30)

	pagination = vgui.Create("bVGUI.Pagination", pagination_container)
	pagination:SetPages(1)
	pagination:Dock(FILL)

	function pagination:OnPageSelected(page)
		if (damage_logs_mode == true) then
			GAS.Logging.Menu.DamageLogs:SetLoading(true)
			GAS.Logging.Menu.DamageLogs.CurrentPage = page
			LoadDamageLogs()
		else
			GAS.Logging.Menu.LogsTable:SetLoading(true)
			GAS.Logging.Menu.LogsTable.CurrentPage = page
			LoadLogs()
		end
	end

	function GAS.Logging.Menu:ViewPlayerLogs(account_id, ply, deep_storage)
		local item = vgui.Create("GAS.Logging.AdvancedSearchItem", ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems.PlayerPnl)
		item:SetAccountID(account_id)
		item:SetValue(tostring(account_id))
		if (IsValid(ply)) then
			item:SetText(ply:Nick())
			item:SetColor(team.GetColor(ply:Team()))
		end
		ModuleFrame.AdvancedSearch.Filters.AdvancedSearchItems:AddItem(2, item)

		ModuleFrame.AdvancedSearch.Greedy:SetChecked(true)
		if (deep_storage) then
			GAS.Logging.Menu.LogsTable.DeepStorage = true
			ModuleFrame.DeepStorage.Button:SetColor(bVGUI.BUTTON_COLOR_RED)
			ModuleFrame.DeepStorage.Button:SetText(L"exit_deep_storage")
		else
			GAS.Logging.Menu.LogsTable.DeepStorage = false
			ModuleFrame.DeepStorage.Button:SetColor(bVGUI.BUTTON_COLOR_GREEN)
			ModuleFrame.DeepStorage.Button:SetText(L"view_deep_storage")
		end
		if (IsValid(deep_storage_category_item)) then deep_storage_category_item:SetForcedActive(GAS.Logging.Menu.LogsTable.DeepStorage) end

		ModuleFrame.AdvancedSearch.Filters.DoSearch:DoClick()
	end
end)

GAS:netReceive("logging:SendLogs", function(len)
	local data = GAS:DeserializeTable(util.Decompress(net.ReadData(len)))
	if (not IsValid(GAS.Logging.Menu)) then return end
	if (GAS.Logging.Menu.SendLogs_TransactionID ~= data[1]) then return end

	local module_data
	if (GAS.Logging.Menu.LogsTable.ModuleID) then
		module_data = GAS.Logging.IndexedModules[GAS.Logging.Menu.LogsTable.ModuleID]
	end
	for _,log in ipairs(data[2]) do
		module_data = module_data or GAS.Logging.IndexedModules[log[2]]

		local formatted_log = GAS.Logging:FormatMarkupLog(log, GAS.Logging.Config.ColoredLogs or true)
		local log_row = GAS.Logging.Menu.LogsTable:AddRow("<color=" .. GAS:Unvectorize(module_data.Colour or bVGUI.COLOR_WHITE) .. ">" .. GAS:EscapeMarkup(module_data.Name) .. "</color>", GAS:SimplifyTimestamp(log[3]), formatted_log)
		log_row.Data = log
		log_row.IsColored = GAS.Logging.Config.ColoredLogs or true

		module_data = nil
	end
	if (GAS.Logging.Menu.QuickSearch.Open) then
		GAS.Logging.Menu.QuickSearch.TextEntry:OnValueChange(GAS.Logging.Menu.QuickSearch.TextEntry:GetValue())
	end
end)

GAS:netReceive("logging:SendDamageLogs", function(len)
	local data = GAS:DeserializeTable(util.Decompress(net.ReadData(len)))
	if (not data) then return end
	if (not IsValid(GAS.Logging.Menu)) then return end
	if (GAS.Logging.Menu.SendLogs_TransactionID ~= data[1]) then return end
	for i,row in ipairs(data[2]) do
		local dmg_log = vgui.Create("GAS.Logging.DamageLog", GAS.Logging.Menu.DamageLogs)
		dmg_log.RowIndex = i
		dmg_log:Dock(TOP)
		dmg_log:Setup(row)
	end
end)

GAS:netReceive("logging:PvPEventReport", function(len)
	local data = net.ReadData(len)
	data = GAS:DeserializeTable(util.Decompress(data))

	local dmglog = vgui.Create("GAS.Logging.DamageLog")
	dmglog:SetSize(0,0)
	dmglog:Setup(data)
	dmglog.DeleteMeOnClose = true
	dmglog:DoClick()
end)

GAS:ContextProperty("gas_logging", {
	MenuLabel = L"module_name",
	MenuIcon = "icon16/database_lightning.png",
	MenuOpen = function(self, option, ply, tr)
		option:AddOption(L"open_menu", function()
			RunConsoleCommand("gmodadminsuite", "logging")
		end):SetIcon("icon16/application_form_magnify.png")

		option:AddSpacer()

		option:AddOption(L"view_logs", function()
			if (IsValid(GAS.Logging.Menu)) then
				GAS.Logging.Menu:ViewPlayerLogs(ply:AccountID(), ply)
			else
				GAS.Logging.ViewLogs = ply:AccountID()
				GAS.Logging.ViewLogsPly = ply
				GAS.Logging.ViewLogsDeepStorage = nil
				RunConsoleCommand("gmodadminsuite", "logging")
			end
		end):SetIcon("icon16/user_go.png")

		option:AddOption(L"deep_storage", function()
			if (IsValid(GAS.Logging.Menu)) then
				GAS.Logging.Menu:ViewPlayerLogs(ply:AccountID(), ply, true)
			else
				GAS.Logging.ViewLogs = ply:AccountID()
				GAS.Logging.ViewLogsPly = ply
				GAS.Logging.ViewLogsDeepStorage = true
				RunConsoleCommand("gmodadminsuite", "logging")
			end
		end):SetIcon("icon16/database_lightning.png")
	end,
	Filter = function(self, ent, ply)
		return ent:IsPlayer() and not ent:IsBot() and OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite/logging")
	end
})