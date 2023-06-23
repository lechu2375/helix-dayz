if SAM_LOADED then return end

local sam = sam
local SQL = sam.SQL
local SUI = sam.SUI
local netstream = sam.netstream

sam.permissions.add("manage_bans", nil, "superadmin")

local get_pages_count = function(bans_count)
	bans_count = bans_count / 35
	local i2 = math.floor(bans_count)
	return bans_count ~= i2 and i2 + 1 or bans_count
end

if SERVER then
	local check = function(ply)
		return ply:HasPermission("manage_bans") and ply:sam_check_cooldown("MenuManageBans", 0.1)
	end

	local limit = 35

	local get_page_count = function(res, callback, page, order_by, keyword)
		local current_time = os.time()
		local query = [[
			SELECT
				COUNT(`steamid`) AS `count`
			FROM
				`sam_bans`
			WHERE
				(`unban_date` >= %d OR `unban_date` = 0)]]

		query = query:format(current_time)

		if keyword then
			query = query .. " AND `steamid` LIKE " .. SQL.Escape("%" .. keyword .. "%")
		end

		SQL.Query(query, callback, true, {res, page, order_by, keyword, current_time})
	end

	local resolve_promise = function(data, arguments)
		local res = arguments[1]
		arguments[1] = data
		res(arguments)
	end

	local get_bans = function(count_data, arguments)
		local res, page, order_by, keyword, current_time = unpack(arguments)
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
				`sam_bans`.*,
				IFNULL(`p1`.`name`, '') AS `name`,
				IFNULL(`p2`.`name`, '') AS `admin_name`
			FROM
				`sam_bans`
			LEFT OUTER JOIN
				`sam_players` AS `p1`
			ON
				`sam_bans`.`steamid` = `p1`.`steamid`
			LEFT OUTER JOIN
				`sam_players` AS `p2`
			ON
				`sam_bans`.`admin` = `p2`.`steamid`
			WHERE
				(`sam_bans`.`unban_date` >= %d OR `sam_bans`.`unban_date` = 0)]]

		query = query:format(current_time)

		if keyword then
			query = query .. " AND `sam_bans`.`steamid` LIKE " .. SQL.Escape("%" .. keyword .. "%")
		end

		local offset = math.abs(limit * (page - 1))
		query = query .. ([[
			ORDER BY
				`sam_bans`.`id` %s
			LIMIT
				%d OFFSET %d]]):format(order_by, limit, offset)

		SQL.Query(query, resolve_promise, nil, {res, count, current_page})
	end

	netstream.async.Hook("SAM.GetBans", function(res, ply, page, order_by, keyword)
		if not isnumber(page) then return end
		if order_by ~= "ASC" and order_by ~= "DESC" then return end
		if keyword ~= nil and not sam.isstring(keyword) then return end

		get_page_count(res, get_bans, page, order_by, keyword)
	end, check)

	return
end

local GetColor = SUI.GetColor
local Line = sui.TDLib.LibClasses.Line

local COLUMN_FONT = SUI.CreateFont("Column", "Roboto", 18)
local LINE_FONT = SUI.CreateFont("Line", "Roboto", 16)
local NEXT_FONT = SUI.CreateFont("NextButton", "Roboto", 18)

sam.menu.add_tab("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/ban-user.png", function(column_sheet)
	local refresh, pages
	local current_page, current_order, keyword = nil, "DESC", nil

	local bans_body = column_sheet:Add("Panel")
	bans_body:Dock(FILL)
	bans_body:DockMargin(0, 1, 0, 0)
	bans_body:DockPadding(10, 10, 10, 10)

	local toggle_loading, is_loading = sam.menu.add_loading_panel(bans_body)

	local title = bans_body:Add("SAM.Label")
	title:Dock(TOP)
	title:SetFont(SAM_TAB_TITLE_FONT)
	title:SetText("Bans")
	title:SetTextColor(GetColor("menu_tabs_title"))
	title:SizeToContents()

	local total = bans_body:Add("SAM.Label")
	total:Dock(TOP)
	total:DockMargin(0, 6, 0, 0)
	total:SetFont(SAM_TAB_DESC_FONT)
	total:SetText("60 total bans")
	total:SetTextColor(GetColor("menu_tabs_title"))
	total:SetPos(10, SUI.Scale(40))
	total:SizeToContents()

	do
		local container = bans_body:Add("SAM.Panel")
		container:Dock(TOP)
		container:DockMargin(0, 6, 10, 0)
		container:SetTall(30)

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

		local search_entry = container:Add("SAM.TextEntry")
		search_entry:Dock(LEFT)
		search_entry:SetNoBar(true)
		search_entry:SetPlaceholder("Search...")
		search_entry:SetRadius(4)
		search_entry:SetWide(220)

		function search_entry:OnEnter()
			local value = self:GetValue()
			if keyword ~= value then
				keyword = value ~= "" and value or nil
				refresh()
			end
		end
	end

	Line(bans_body, nil, -5, 15, -5, 0)

	do
		local columns = bans_body:Add("Panel")
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

		local time_left = columns:Add("SAM.Label")
		time_left:Dock(LEFT)
		time_left:DockMargin(-4, 0, 0, 0)
		time_left:SetFont(COLUMN_FONT)
		time_left:SetText("Time Left")
		time_left:SetTextColor(GetColor("player_list_titles"))
		time_left:SetWide(SUI.Scale(180))
		time_left:SizeToContentsY(3)

		local reason = columns:Add("SAM.Label")
		reason:Dock(LEFT)
		reason:DockMargin(-4, 0, 0, 0)
		reason:SetFont(COLUMN_FONT)
		reason:SetText("Reason")
		reason:SetTextColor(GetColor("player_list_titles"))
		reason:SetWide(SUI.Scale(280))
		reason:SizeToContentsY(3)

		columns:SizeToChildren(false, true)
	end

	local body = bans_body:Add("SAM.ScrollPanel")
	body:Dock(FILL)
	body:DockMargin(0, 10, 0, 0)
	body:SetVBarPadding(6)

	local set_data = function(data)
		body:GetCanvas():Clear()
		body.VBar.Scroll = 0

		local bans, bans_count, current_page_2 = unpack(data)
		total:SetText(bans_count .. " total bans")

		pages = get_pages_count(bans_count)
		current_page.i = pages == 0 and 0 or current_page_2 or current_page.i
		current_page:SetText(current_page.i .. "/" .. pages)

		body:Line()

		for k, v in ipairs(bans) do
			local line = body:Add("SAM.PlayerLine")
			line:DockMargin(0, 0, 0, 10)

			local name = v.name ~= "" and v.name or nil
			local admin_name = v.admin_name ~= "" and v.admin_name or nil
			line:SetInfo({
				steamid = v.steamid,
				name = name,
				rank = admin_name or (v.admin == "Console" and "Console"),
				rank_bg = not admin_name and GetColor("player_list_console")
			})

			local unban_date = tonumber(v.unban_date)
			local time_left = line:Add("SAM.Label")
			time_left:Dock(LEFT)
			time_left:DockMargin(-3, 0, 0, 0)
			time_left:SetFont(LINE_FONT)
			time_left:SetText(unban_date == 0 and "Never" or sam.reverse_parse_length((unban_date - os.time()) / 60))
			time_left:SetTextColor(GetColor("player_list_data"))
			time_left:SetContentAlignment(4)
			time_left:SetWide(SUI.Scale(180))

			local reason = line:Add("SAM.Label")
			reason:Dock(LEFT)
			reason:DockMargin(4, 0, 0, 0)
			reason:SetFont(LINE_FONT)
			reason:SetText(v.reason)
			reason:SetTextColor(GetColor("player_list_data"))
			reason:SetContentAlignment(4)
			reason:SetWrap(true)
			reason:SetWide(SUI.Scale(200))

			local old_tall = line.size
			function reason:PerformLayout()
				local _, h = self:GetTextSize()
				if old_tall < h then
					line:SetTall(h)
				end
			end

			local but = line:Actions()
			but:On("DoClick", function()
				local dmenu = vgui.Create("SAM.Menu")
				dmenu:SetInternal(but)
				if name then
					dmenu:AddOption("Copy Name", function()
						SetClipboardText(name)
					end)
				end
				dmenu:AddOption("Copy SteamID", function()
					SetClipboardText(v.steamid)
				end)
				dmenu:AddOption("Copy Reason", function()
					SetClipboardText(v.reason)
				end)
				dmenu:AddOption("Copy Time Left", function()
					SetClipboardText(time_left:GetText())
				end)

				if v.admin ~= "Console" then
					dmenu:AddSpacer()

					if admin_name then
						dmenu:AddOption("Copy Admin Name", function()
							SetClipboardText(admin_name)
						end)
					end

					dmenu:AddOption("Copy Admin SteamID", function()
						SetClipboardText(v.admin)
					end)
				end

				if LocalPlayer():HasPermission("unban") then
					dmenu:AddSpacer()
					dmenu:AddOption("Unban", function()
						local user = name and ("%s (%s)"):format(name, v.steamid) or v.steamid
						local querybox = vgui.Create("SAM.QueryBox")
						querybox:SetWide(350)
						querybox:SetTitle(user)

						local check = querybox:Add("SAM.Label")
						check:SetText(sui.wrap_text("Are you sure that you want to unban\n" .. user, LINE_FONT, SUI.Scale(350)))
						check:SetFont(LINE_FONT)
						check:SizeToContents()

						querybox:Done()
						querybox.save:SetEnabled(true)
						querybox.save:SetText("UNBAN")

						querybox.save:SetContained(false)
						querybox.save:SetColors(GetColor("query_box_cancel"), GetColor("query_box_cancel_text"))

						querybox.cancel:SetContained(true)
						querybox.cancel:SetColors()

						querybox:SetCallback(function()
							RunConsoleCommand("sam", "unban", v.steamid)
						end)
					end)
				end
				dmenu:Open()
			end)

			body:Line()
		end

		body:InvalidateLayout(true)
		body:GetCanvas():InvalidateLayout(true)
	end

	refresh = function()
		if not is_loading() and LocalPlayer():HasPermission("manage_bans") then
			local refresh_query = netstream.async.Start("SAM.GetBans", toggle_loading, current_page.i, current_order, keyword)
			refresh_query:done(set_data)
		end
	end

	local bottom_panel = bans_body:Add("SAM.Panel")
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

	for k, v in ipairs({"SAM.BannedPlayer", "SAM.BannedSteamID", "SAM.EditedBan", "SAM.UnbannedSteamID"}) do
		hook.Add(v, "SAM.MenuBans", function()
			if IsValid(body) then
				refresh()
			end
		end)
	end

	refresh()

	return bans_body
end, function()
	return LocalPlayer():HasPermission("manage_bans")
end, 4)