if SAM_LOADED then return end

local sam = sam
local SQL = sam.SQL
local SUI = sam.SUI
local netstream = sam.netstream

sam.permissions.add("manage_players", nil, "superadmin")

local get_pages_count = function(count)
	count = count / 35
	local i2 = math.floor(count)
	return count ~= i2 and i2 + 1 or count
end

if SERVER then
	local check = function(ply)
		return ply:HasPermission("manage_players") and ply:sam_check_cooldown("MenuViewPlayers", 0.1)
	end

	local limit = 35

	local get_page_count = function(callback, res, page, column, order_by, sort_by, keyword)
		local query = [[
			SELECT
				COUNT(`steamid`) AS `count`
			FROM
				`sam_players`]]
		if keyword then
			if column == "steamid" and sam.is_steamid64(keyword) then
				keyword = util.SteamIDFrom64(keyword)
			end

			query = string.format("%s WHERE `%s` LIKE %s", query, column, SQL.Escape("%" .. keyword .. "%"))
		end
		SQL.Query(query, callback, true, {res, page, column, order_by, sort_by, keyword})
	end

	local valid_columns = {
		steamid = true,
		name = true,
		rank = true
	}

	local valid_sorts = {
		id = true,
		name = true,
		rank = true,
		play_time = true,
		last_join = true
	}

	local resolve_promise = function(data, arguments)
		local res = arguments[1]
		arguments[1] = data
		res(arguments)
	end

	local get_players = function(count_data, arguments)
		local res, page, column, order_by, sort_by, keyword = unpack(arguments)
		local count = count_data.count

		local current_page
		if page < 1 then
			page, current_page = 1, 1
		end

		local pages_count = get_pages_count(count)
		if page > pages_count then
			page, current_page = pages_count, pages_count
		end

		local query = [[
			SELECT
				`steamid`,
				`name`,
				`rank`,
				`expiry_date`,
				`first_join`,
				`last_join`,
				`play_time`
			FROM
				`sam_players`
		]]

		local args = {}

		if keyword then
			args[1] = column
			args[2] = "%" .. keyword .. "%"

			query = query .. [[
				WHERE
					`{1f}` LIKE {2}
			]]
		end

		args[3] = sort_by
		if order_by == "DESC" then
			query = query .. [[
				ORDER BY `{3f}` DESC
			]]
		else
			query = query .. [[
				ORDER BY `{3f}` ASC
			]]
		end

		args[4] = limit
		args[5] = math.abs(limit * (page - 1))

		query = query .. [[
			LIMIT {4} OFFSET {5}
		]]

		SQL.FQuery(query, args, resolve_promise, false, {res, count, current_page})
	end

	netstream.async.Hook("SAM.GetPlayers", function(res, ply, page, column, order_by, sort_by, keyword)
		if not isnumber(page) then return end
		if not valid_columns[column] then return end
		if order_by ~= "ASC" and order_by ~= "DESC" then return end
		if not valid_sorts[sort_by] then return end
		if keyword ~= nil and not sam.isstring(keyword) then return end

		get_page_count(get_players, res, page, column, order_by, sort_by, keyword)
	end, check)

	return
end

local GetColor = SUI.GetColor
local Line = sui.TDLib.LibClasses.Line

local COLUMN_FONT = SUI.CreateFont("Column", "Roboto", 18)
local LINE_FONT = SUI.CreateFont("Line", "Roboto", 16)
local NEXT_FONT = SUI.CreateFont("NextButton", "Roboto", 18)

local button_click = function(s)
	local v = s.v

	local dmenu = vgui.Create("SAM.Menu")
	dmenu:SetInternal(s)
	if v.name and v.name ~= "" then
		dmenu:AddOption("Copy Name", function()
			SetClipboardText(v.name)
		end)
	end

	dmenu:AddOption("Copy SteamID", function()
		SetClipboardText(v.steamid)
	end)

	dmenu:AddOption("Copy Rank", function()
		SetClipboardText(v.rank)
	end)

	dmenu:AddOption("Copy Play Time", function()
		SetClipboardText(sam.reverse_parse_length(tonumber(v.play_time) / 60))
	end)

	dmenu:AddSpacer()

	dmenu:AddOption("Change Rank", function()
		local querybox = vgui.Create("SAM.QueryBox")
		querybox:SetTitle(string.format("Change rank for '%s'", v.name or v.steamid))
		querybox:SetWide(360)

		local ranks = querybox:Add("SAM.ComboBox")
		ranks:SetTall(28)

		for rank_name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
			if v.rank ~= rank_name then
				ranks:AddChoice(rank_name, nil, true)
			end
		end

		querybox:Done()
		querybox.save:SetEnabled(true)

		querybox:SetCallback(function()
			RunConsoleCommand("sam", "setrankid", v.steamid, ranks:GetValue())
		end)
	end)

	dmenu:Open()
end

sam.menu.add_tab("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/user.png", function(column_sheet)
	local refresh, pages
	local current_page, current_column, current_order, current_sort, keyword = nil, "steamid", "DESC", "id", nil

	local players_body = column_sheet:Add("Panel")
	players_body:Dock(FILL)
	players_body:DockMargin(0, 1, 0, 0)
	players_body:DockPadding(10, 10, 10, 10)

	local toggle_loading, is_loading = sam.menu.add_loading_panel(players_body)

	local title = players_body:Add("SAM.Label")
	title:Dock(TOP)
	title:SetFont(SAM_TAB_TITLE_FONT)
	title:SetText("Players")
	title:SetTextColor(GetColor("menu_tabs_title"))
	title:SizeToContents()

	local total = players_body:Add("SAM.Label")
	total:Dock(TOP)
	total:DockMargin(0, 6, 0, 0)
	total:SetFont(SAM_TAB_DESC_FONT)
	total:SetText("60 total players")
	total:SetTextColor(GetColor("menu_tabs_title"))
	total:SetPos(10, SUI.Scale(40))
	total:SizeToContents()

	local search_entry
	do
		local container = players_body:Add("SAM.Panel")
		container:Dock(TOP)
		container:DockMargin(0, 6, 10, 0)
		container:SetTall(30)

		local sort_by = container:Add("SAM.ComboBox")
		sort_by:Dock(RIGHT)
		sort_by:DockMargin(4, 0, 0, 0)
		sort_by:SetWide(106)
		sort_by:SetValue("Sort By (ID)")
		sort_by:AddChoice("ID")
		sort_by:AddChoice("Name")
		sort_by:AddChoice("Rank")
		sort_by:AddChoice("Play Time")

		function sort_by:OnSelect(_, value)
			value = value:lower():gsub(" ", "_")
			if current_sort ~= value then
				current_sort = value
				refresh()
			end
		end

		local sort_order = container:Add("SAM.ComboBox")
		sort_order:Dock(RIGHT)
		sort_order:SetWide(96)
		sort_order:SetValue("Desc")
		sort_order:AddChoice("Desc")
		sort_order:AddChoice("Asc")

		function sort_order:OnSelect(_, value)
			value = value:upper()
			if current_order ~= value then
				current_order = value
				refresh()
			end
		end

		local column = container:Add("SAM.ComboBox")
		column:Dock(RIGHT)
		column:DockMargin(0, 0, 4, 0)
		column:SetWide(140)

		column:SetValue("Search (SteamID)")
		column:AddChoice("SteamID")
		column:AddChoice("Name")
		column:AddChoice("Rank")

		function column:OnSelect(_, value)
			value = value:lower()
			if current_column ~= value then
				current_column = value
				refresh()
			end
		end

		search_entry = container:Add("SAM.TextEntry")
		search_entry:Dock(LEFT)
		search_entry:SetNoBar(true)
		search_entry:SetPlaceholder("Search...")
		search_entry:SetRadius(4)
		search_entry:SetWide(220)

		function search_entry:OnEnter(no_refresh)
			local value = self:GetValue()
			if keyword ~= value then
				keyword = value ~= "" and value or nil
				if not no_refresh then
					refresh()
				end
			end
		end
	end

	Line(players_body, nil, -5, SUI.Scale(15), -5, 0)

	do
		local columns = players_body:Add("Panel")
		columns:Dock(TOP)
		columns:DockMargin(0, 10, 0, 0)

		local info = columns:Add("SAM.Label")
		info:Dock(LEFT)
		info:DockMargin(4, 0, 0, 0)
		info:SetFont(COLUMN_FONT)
		info:SetText("Player")
		info:SetTextColor(GetColor("player_list_titles"))
		info:SetWide(SUI.Scale(280) + SUI.Scale(34))
		info:SizeToContentsY(3)

		local play_time = columns:Add("SAM.Label")
		play_time:Dock(LEFT)
		play_time:DockMargin(-4, 0, 0, 0)
		play_time:SetFont(COLUMN_FONT)
		play_time:SetText("Play Time")
		play_time:SetTextColor(GetColor("player_list_titles"))
		play_time:SetWide(SUI.Scale(180))
		play_time:SizeToContentsY(3)

		local rank_expiry = columns:Add("SAM.Label")
		rank_expiry:Dock(LEFT)
		rank_expiry:DockMargin(-4, 0, 0, 0)
		rank_expiry:SetFont(COLUMN_FONT)
		rank_expiry:SetText("Rank Expiry")
		rank_expiry:SetTextColor(GetColor("player_list_titles"))
		rank_expiry:SetWide(SUI.Scale(280))
		rank_expiry:SizeToContentsY(3)

		columns:SizeToChildren(false, true)
	end

	local body = players_body:Add("SAM.ScrollPanel")
	body:Dock(FILL)
	body:DockMargin(0, 10, 0, 0)
	body:SetVBarPadding(6)

	local set_data = function(data)
		body:GetCanvas():Clear()
		body.VBar.Scroll = 0

		local players, players_count, current_page_2 = unpack(data)
		total:SetText(players_count .. " total players")

		pages = get_pages_count(players_count)
		current_page.i = pages == 0 and 0 or current_page_2 or current_page.i
		current_page:SetText(current_page.i .. "/" .. pages)

		body:Line()

		for k, v in ipairs(players) do
			local line = body:Add("SAM.PlayerLine")
			line:DockMargin(0, 0, 0, 10)

			local name = v.name ~= "" and v.name or nil
			line:SetInfo({
				steamid = v.steamid,
				name = name,
				rank = v.rank
			})

			local play_time = line:Add("SAM.Label")
			play_time:Dock(LEFT)
			play_time:DockMargin(4, 0, 0, 0)
			play_time:SetFont(LINE_FONT)
			play_time:SetText(sam.reverse_parse_length(tonumber(v.play_time) / 60))
			play_time:SetTextColor(GetColor("player_list_data"))
			play_time:SetContentAlignment(4)
			play_time:SetWide(SUI.Scale(180))

			local expiry_date = tonumber(v.expiry_date)
			local rank_expiry = line:Add("SAM.Label")
			rank_expiry:Dock(LEFT)
			rank_expiry:DockMargin(-3, 0, 0, 0)
			rank_expiry:SetFont(LINE_FONT)
			rank_expiry:SetText(expiry_date == 0 and "Never" or sam.reverse_parse_length((expiry_date - os.time()) / 60))
			rank_expiry:SetTextColor(GetColor("player_list_data"))
			rank_expiry:SetContentAlignment(4)
			rank_expiry:SizeToContents()

			local but = line:Actions()
			but.v = v
			but:On("DoClick", button_click)

			body:Line()
		end
	end

	refresh = function()
		if not is_loading() and LocalPlayer():HasPermission("manage_players") then
			search_entry:OnEnter(true)
			local refresh_query = netstream.async.Start("SAM.GetPlayers", toggle_loading, current_page.i, current_column, current_order, current_sort, keyword)
			refresh_query:done(set_data)
		end
	end

	local bottom_panel = players_body:Add("SAM.Panel")
	bottom_panel:Dock(BOTTOM)
	bottom_panel:DockMargin(0, 6, 0, 0)
	bottom_panel:SetTall(30)
	bottom_panel:Background(GetColor("page_switch_bg"))

	local previous_page = bottom_panel:Add("SAM.Button")
	previous_page:Dock(LEFT)
	previous_page:SetWide(30)
	previous_page:SetText("<")
	previous_page:SetFont(NEXT_FONT)

	previous_page:On("DoClick", function()
		if current_page.i <= 1 then return end

		current_page.i = current_page.i - 1
		refresh()
	end)

	current_page = bottom_panel:Add("SAM.Label")
	current_page:Dock(FILL)
	current_page:SetContentAlignment(5)
	current_page:SetFont(SAM_TAB_DESC_FONT)
	current_page:SetText("loading...")
	current_page.i = 1

	local next_page = bottom_panel:Add("SAM.Button")
	next_page:Dock(RIGHT)
	next_page:SetWide(30)
	next_page:SetText(">")
	next_page:SetFont(NEXT_FONT)

	next_page:On("DoClick", function()
		if current_page.i == pages then return end

		current_page.i = current_page.i + 1
		refresh()
	end)

	function bottom_panel:Think()
		next_page:SetEnabled(current_page.i ~= pages)
		previous_page:SetEnabled(current_page.i > 1)
	end

	do
		local refresh_2 = function()
			timer.Simple(1, refresh)
		end

		for k, v in ipairs({"SAM.AuthedPlayer", "SAM.ChangedPlayerRank", "SAM.ChangedSteamIDRank"}) do
			hook.Add(v, "SAM.MenuPlayers", refresh_2)
		end
	end

	refresh()

	return players_body
end, function()
	return LocalPlayer():HasPermission("manage_players")
end, 2)