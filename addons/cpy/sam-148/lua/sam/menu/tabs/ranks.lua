if SAM_LOADED then return end
if SERVER then return end

local sam = sam
local SUI = sam.SUI

local GetColor = SUI.GetColor
local Line = sui.TDLib.LibClasses.Line
local AnimatedSetVisible = sui.TDLib.LibClasses.AnimatedSetVisible

local RANK_NAME = SUI.CreateFont("RankName", "Roboto Bold", 18)
local RANK_INFO = SUI.CreateFont("RankInfo", "Roboto Medium", 12)

local CREATE_RANK = SUI.CreateFont("CreateRank", "Roboto Bold", 16, 200)
local RANK_TITLE = SUI.CreateFont("RankTitle", "Roboto Bold", 20)

local rank_menu = function(rank, data)
	local valid = sui.valid_options()

	local imm, banlim
	if rank then
		imm, banlim = data.immunity, data.ban_limit
	end

	local edit_rank = vgui.Create("SAM.QueryBox")
	edit_rank:SetWide(470)
	edit_rank:SetTitle(rank and string.format("Edit Rank '%s'", rank) or "Create Rank")

	local new_name = rank
	if not sam.ranks.is_default_rank(rank) then
		local name = edit_rank:Add("SAM.LabelPanel")
		name:SetLabel("Rank Name")

		local entry = name:Add("SAM.TextEntry")
		entry:SetSize(210, 28)
		entry:SetNoBar(false)
		entry:SetPlaceholder("")
		entry:SetValue(rank or "")
		entry:SetCheck(function(_name)
			new_name = _name

			if _name == rank then return end
			if _name == "" or sam.ranks.is_rank(_name) then
				return false
			end
		end)

		valid.Add(entry)
	end

	local new_immunity = imm
	do
		local immunity = edit_rank:Add("SAM.LabelPanel")
		immunity:SetLabel("Immunity (2~99)")
		immunity:DockMargin(0, 5, 0, 0)

		local entry = immunity:Add("SAM.TextEntry")
		entry:SetSize(210, 28)
		entry:SetNumeric(true)
		entry:DisallowFloats(true)
		entry:DisallowNegative(true)
		entry:SetPlaceholder("")
		entry:SetValue(imm or "2")
		entry:SetCheck(function(_immunity)
			new_immunity = _immunity

			if _immunity == "" then
				return false
			end

			_immunity = tonumber(_immunity)
			new_immunity = _immunity
			if _immunity < 2 or _immunity > 99 then
				return false
			end
		end)

		valid.Add(entry)
	end

	local new_banlimit = banlim
	do
		local banlimit = edit_rank:Add("SAM.LabelPanel")
		banlimit:SetLabel("Ban Limit (1y 1mo 1w 1d 1h 1m)")
		banlimit:DockMargin(0, 5, 0, 0)

		local entry = banlimit:Add("SAM.TextEntry")
		entry:SetSize(210, 28)
		entry:SetNoBar(false)
		entry:SetPlaceholder("")
		entry:SetValue(banlim and sam.reverse_parse_length(banlim) or "2w")
		entry:SetCheck(function(_banlimit)
			new_banlimit = sam.parse_length(_banlimit)
			if not new_banlimit and _banlimit ~= banlim then
				return false
			end
		end)

		valid.Add(entry)
	end

	local inherit = rank and sam.ranks.get_rank(rank).inherit or "user"
	local new_inherit = inherit
	do
		local inherits_from = edit_rank:Add("SAM.LabelPanel")
		inherits_from:SetLabel("Inherits From")
		inherits_from:DockMargin(0, 5, 0, 0)

		local entry = inherits_from:Add("SAM.ComboBox")
		entry:SetSize(210, 28)
		entry:SetValue(inherit)

		for name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
			if name ~= rank and not sam.ranks.inherits_from(name, rank) then
				entry:AddChoice(name)
			end
		end

		function entry:OnSelect(_, value)
			new_inherit = value
		end
	end


	edit_rank:Done()
	edit_rank.save:SetEnabled(true)
	edit_rank.save:SetText("SAVE")

	if rank then
		edit_rank:SetCallback(function()
			local to_run = {}

			if new_immunity ~= imm then
				table.insert(to_run, {"changerankimmunity", rank, new_immunity})
			end

			if new_banlimit ~= banlim then
				table.insert(to_run, {"changerankbanlimit", rank, new_banlimit})
			end

			if new_inherit ~= inherit then
				table.insert(to_run, {"changeinherit", rank, new_inherit})
			end

			if new_name ~= rank then
				table.insert(to_run, {"renamerank", rank, new_name})
			end
			sam.command.run_commands(to_run)
		end)
	else
		edit_rank:SetCallback(function()
			RunConsoleCommand("sam", "addrank", new_name, new_inherit, new_immunity, new_banlimit)
		end)
	end

	function edit_rank.save:Think()
		self:SetEnabled(valid.IsValid())
	end
end

sam.menu.add_tab("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/military_rank.png", function(column_sheet)
	local current_rank

	local parent = column_sheet:Add("Panel")
	parent:Dock(FILL)
	parent:DockMargin(0, 1, 0, 0)

	local title = parent:Add("SAM.Label")
	title:Dock(TOP)
	title:DockMargin(10, 10, 0, 0)
	title:SetFont(SAM_TAB_TITLE_FONT)
	title:SetText("Ranks")
	title:SetTextColor(GetColor("menu_tabs_title"))
	title:SizeToContents()

	local total = parent:Add("SAM.Label")
	total:Dock(TOP)
	total:DockMargin(10, 6, 0, 0)
	total:SetFont(SAM_TAB_DESC_FONT)
	total:SetText(table.Count(sam.ranks.get_ranks()) .. " total ranks")
	total:SetTextColor(GetColor("menu_tabs_title"))
	total:SizeToContents()

	local search_entry
	do
		local container = parent:Add("SAM.Panel")
		container:Dock(TOP)
		container:DockMargin(10, 6, 10, SUI.Scale(15))
		container:SetTall(30)

		search_entry = container:Add("SAM.TextEntry")
		search_entry:Dock(LEFT)
		search_entry:SetNoBar(true)
		search_entry:SetPlaceholder("Search...")
		search_entry:SetRadius(4)
		search_entry:SetWide(220)
	end

	local create_rank = parent:Add("SAM.Button")
	create_rank:SetFont(CREATE_RANK)
	create_rank:SetText("Create Rank")
	create_rank:Dock(BOTTOM)
	create_rank:DockMargin(10, 0, 10, 10)

	create_rank:On("DoClick", function()
		rank_menu()
	end)

	local right_body = parent:Add("Panel")
	right_body:Dock(RIGHT)
	right_body:DockMargin(0, 5, 10, 10)
	right_body:SetWide(0)
	right_body:SetZPos(-1)

	local rank_title = right_body:Add("SAM.Label")
	rank_title:Dock(TOP)
	rank_title:DockMargin(0, 0, 0, 5)
	rank_title:SetFont(RANK_TITLE)
	rank_title:SetTextColor(GetColor("menu_tabs_title"))

	local permissions_body = right_body:Add("SAM.CollapseCategory")
	permissions_body:Dock(FILL)
	permissions_body:GetCanvas():DockPadding(0, 0, 5, 0)

	local function refresh_access()
		if not IsValid(current_rank) then return end

		for k, v in ipairs(permissions_body.items) do
			AnimatedSetVisible(v.img, sam.ranks.has_permission(current_rank.name, v.name))
		end
	end

	for k, v in ipairs({"SAM.ChangedInheritRank", "SAM.RankPermissionGiven", "SAM.RankPermissionTaken"}) do
		hook.Add(v, "SAM.Menu.RefreshPermissions ", refresh_access)
	end

	local function refresh_permissions()
		permissions_body:GetCanvas():Clear()
		table.Empty(permissions_body.items)
		table.Empty(permissions_body.categories)

		local item_click = function(s)
			local rank = current_rank.name
			if not sam.ranks.has_permission(rank, s.name) then
				RunConsoleCommand("sam", "givepermission", rank, s.name)
			else
				RunConsoleCommand("sam", "takepermission", rank, s.name)
			end
		end

		for k, v in ipairs(sam.permissions.get()) do
			local item = permissions_body:add_item(v.name, v.category)
			item:SetContentAlignment(4)
			item:SetTextInset(6, 0)
			item:SizeToContentsY(SUI.Scale(10))
			item:SetZPos(k)
			item.name = v.name
			item.DoClick = item_click

			local img = item:Add("SAM.Image")
			img:Dock(RIGHT)
			img:DockMargin(4, 4, 4, 4)
			img:InvalidateParent(true)
			img:SetWide(img:GetTall())
			img:SetImageColor(Color(52, 161, 224))
			img:SetImage("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/check_mark.png")

			item.img = img
		end
	end

	local limits_body

	do
		local permissions_search = right_body:Add("SAM.TextEntry")
		permissions_search:Dock(TOP)
		permissions_search:DockMargin(0, 0, 5, 10)
		permissions_search:SetNoBar(true)
		permissions_search:SetPlaceholder("Search...")
		permissions_search:SetRadius(4)
		permissions_search:SetTall(30)

		function permissions_search:OnValueChange(text)
			if limits_body and limits_body:IsVisible() then
				local children = limits_body:GetCanvas():GetChildren()
				for k, v in ipairs(children) do
					v:AnimatedSetVisible(v.title:find(text, nil, true) ~= nil)
				end
				limits_body:InvalidateLayout(true)
			else
				permissions_body:Search(text:lower())
			end
		end

		Line(right_body):SetZPos(2)
	end

	local function load_limits()
		if sam.limit_types then
			if limits_body then return end
		else
			if limits_body then
				limits_body:SetVisible(false)
				permissions_body:AnimatedSetVisible(true)
				limits_body:Remove()
				limits_body = nil
			end
			return
		end

		limits_body = right_body:Add("SAM.ScrollPanel")
		limits_body:Dock(FILL)
		limits_body:GetCanvas():DockPadding(0, 0, 5, 0)
		limits_body:SetVisible(false)

		local item_enter = function(s)
			if not IsValid(current_rank) then return end

			local rank = current_rank.name

			local limit = math.Clamp(s:GetValue(), -1, 1000)
			if limit ~= sam.ranks.get_limit(rank, s.limit_type) then
				RunConsoleCommand("sam", "changeranklimit", rank, s.limit_type, limit)
			else
				s:SetText(tostring(sam.ranks.get_limit(rank, s.limit_type)))
			end
		end

		local not_empty = function(s)
			return s and s ~= ""
		end

		local limit_values = {}
		for k, v in ipairs(sam.limit_types) do
			local immunity = limits_body:Add("SAM.LabelPanel")
			immunity:SetLabel(v)
			immunity:DockMargin(5, 0, 0, 5)

			local entry = immunity:Add("SAM.TextEntry")
			entry:SetSize(60, 26)
			entry:SetNumeric(true)
			entry:DisallowFloats(true)
			entry:SetPlaceholder("")
			entry:SetCheck(not_empty)
			entry.limit_type = v
			entry.OnEnter = item_enter

			table.insert(limit_values, entry)
		end

		function limits_body:Refresh()
			if not IsValid(current_rank) then return end

			local rank = current_rank.name
			for k, v in ipairs(limit_values) do
				v:SetValue(tostring(sam.ranks.get_limit(rank, v.limit_type)))
			end
		end

		local right_current_rank = right_body:Add("SAM.Button")
		right_current_rank:Dock(BOTTOM)
		right_current_rank:DockMargin(0, 5, 0, 0)
		right_current_rank:SetFont(CREATE_RANK)
		right_current_rank:SetText("Switch to Limits")
		right_current_rank:On("DoClick", function()
			limits_body:AnimatedToggleVisible()
			permissions_body:AnimatedToggleVisible()

			if permissions_body:AnimatedIsVisible() then
				right_current_rank:SetText("Switch to Limits")
			else
				right_current_rank:SetText("Switch to Permissions")
			end
		end)

		limits_body:On("OnRemove", function()
			right_current_rank:Remove()
		end)
		limits_body:Refresh()
	end

	local function refresh_all()
		timer.Create("SAM.Menu.Ranks.Refresh", 1, 1, function()
			load_limits()
			refresh_permissions()
			refresh_access()
		end)
	end

	sam.config.hook({"Restrictions.Limits"}, refresh_all)

	for k, v in ipairs({"SAM.AddedPermission", "SAM.PermissionModified", "SAM.RemovedPermission"}) do
		hook.Add(v, "SAM.Menu.RefreshPermissions", refresh_all)
	end

	local body = parent:Add("SAM.ScrollPanel")
	body:Dock(FILL)
	body:DockMargin(10, 0, 5, 10)
	body:SetVBarPadding(6)

	body:Line():SetZPos(-101)

	local select_rank = function(s)
		if not IsValid(s) then
			current_rank = nil
			right_body:SizeTo(0, -1, 0.3)
			return
		end

		if IsValid(current_rank) then
			current_rank.Selected = false

			if current_rank == s then
				current_rank = nil
				right_body:SizeTo(0, -1, 0.3)
				return
			end
		end

		s.Selected = true
		current_rank = s
		refresh_access()
		if limits_body then
			limits_body:Refresh()
		end
		right_body:SizeTo(SUI.Scale(300), -1, 0.3)

		rank_title:SetText(s.name)
		rank_title:SizeToContents()
	end

	local ranks = {}

	function search_entry:OnValueChange()
		local value = self:GetValue()
		for k, v in pairs(ranks) do
			local show = k:find(value, nil, true)
			show = show ~= nil
			v.line:AnimatedSetVisible(show)
			v:GetParent():AnimatedSetVisible(show)
		end
	end

	local add_rank = function(rank_name, data)
		if rank_name == "superadmin" then return end
		if not IsValid(body) then return end

		local line = body:Add("SAM.Panel")
		line:Dock(TOP)
		line:DockMargin(0, 0, 0, 10)
		line:SetTall(34)
		line:SetZPos(-data.immunity)
		line:InvalidateLayout(true)

		local container = line:Add("SAM.Button")
		container:Dock(FILL)
		container:DockMargin(0, 0, 5, 0)
		container:DockPadding(5, 5, 0, 5)
		container:SetText("")
		container:SetContained(false)
		container.name = rank_name

		ranks[rank_name] = container

		container:On("DoClick", select_rank)

		function container:DoRightClick()
			rank_name = container.name

			if rank_name == "user" then return end

			local dmenu = vgui.Create("SAM.Menu")
			dmenu:SetSize(w, h)
			dmenu:SetInternal(container)

			dmenu:AddOption("Edit Rank", function()
				rank_menu(rank_name, sam.ranks.get_rank(rank_name))
			end)

			if not sam.ranks.is_default_rank(rank_name) then
				dmenu:AddSpacer()

				dmenu:AddOption("Remove Rank", function()
					local remove_rank = vgui.Create("SAM.QueryBox")
					remove_rank:SetWide(350)

					local check = remove_rank:Add("SAM.Label")
					check:SetText("Are you sure that you want to remove '" .. rank_name .. "'?")
					check:SetFont("SAMLine")
					check:SetWrap(true)
					check:SetAutoStretchVertical(true)

					remove_rank:Done()
					remove_rank.save:SetEnabled(true)
					remove_rank.save:SetText("REMOVE")
					remove_rank.save:SetContained(false)
					remove_rank.save:SetColors(GetColor("query_box_cancel"), GetColor("query_box_cancel_text"))

					remove_rank.cancel:SetContained(true)
					remove_rank.cancel:SetColors()

					remove_rank:SetCallback(function()
						RunConsoleCommand("sam", "removerank", rank_name)
					end)
				end)
			end

			dmenu:Open()
			dmenu:SetPos(input.GetCursorPos())
		end

		do
			local name = container:Add("SAM.Label")
			name:Dock(TOP)
			name:DockMargin(0, 0, 0, 2)
			name:SetTextColor(GetColor("player_list_names"))
			name:SetFont(RANK_NAME)
			name:SetText(rank_name)
			name:SizeToContents()

			local immunity = container:Add("SAM.Label")
			immunity:Dock(TOP)
			immunity:SetTextColor(GetColor("player_list_steamid"))
			immunity:SetFont(RANK_INFO)
			immunity:SetText("Immunity: " .. data.immunity)
			immunity:SizeToContents()

			local banlimit = container:Add("SAM.Label")
			banlimit:Dock(TOP)
			banlimit:SetTextColor(GetColor("player_list_steamid"))
			banlimit:SetFont(RANK_INFO)
			banlimit:SetText("Ban limit: " .. sam.reverse_parse_length(sam.parse_length(data.ban_limit)))
			banlimit:SizeToContents()

			local inherit = container:Add("SAM.Label")
			inherit:Dock(TOP)
			inherit:SetTextColor(GetColor("player_list_steamid"))
			inherit:SetFont(RANK_INFO)
			inherit:SetText("Inherits from: " .. (sam.isstring(data.inherit) and data.inherit or "none"))
			inherit:SizeToContents()
		end

		container:InvalidateLayout(true)
		container:SizeToChildren(false, true)
		line:SizeToChildren(false, true)

		local _line = body:Line()
		_line:SetZPos(-data.immunity)

		container.line = _line
		container.data = data
	end

	for rank_name, v in pairs(sam.ranks.get_ranks()) do
		add_rank(rank_name, v)
	end

	hook.Add("SAM.AddedRank", "SAM.RefreshRanksList", function(name, rank)
		add_rank(name, rank)
	end)

	hook.Add("SAM.RemovedRank", "SAM.RefreshRanksList", function(name)
		local line = ranks[name]
		if not IsValid(line) then return end

		line.line:Remove()
		line:GetParent():Remove()
		ranks[name] = nil

		if line == current_rank then
			select_rank()
		end
	end)

	-- This is just better than caching panels for stuff that ain't gonna be called a lot
	hook.Add("SAM.RankNameChanged", "SAM.RefreshRanksList", function(name, new_name)
		local line = ranks[name]
		if not IsValid(line) then return end

		-- if current_rank == name then
		-- 	rank_name:SetText(new_name)
		-- end

		line:GetChildren()[1]:SetText(new_name)

		ranks[new_name], ranks[name] = line, nil
		line.name = new_name
	end)

	hook.Add("SAM.RankImmunityChanged", "SAM.RefreshRanksList", function(name, immunity)
		local line = ranks[name]
		if not IsValid(line) then return end

		line:GetChildren()[2]:SetText("Immunity: " .. immunity)
		line:GetParent():SetZPos(-immunity)

		-- SetZPos is kinda weird to deal with
		line.line:SetZPos(-immunity + 1)
		line.line:SetZPos(-immunity)
	end)

	hook.Add("SAM.RankBanLimitChanged", "SAM.RefreshRanksList", function(name, new_limit)
		local line = ranks[name]
		if IsValid(line) then
			line:GetChildren()[3]:SetText("Ban limit: " .. sam.reverse_parse_length(new_limit))
		end
	end)

	hook.Add("SAM.ChangedInheritRank", "SAM.RefreshRanksList", function(name, new_inherit)
		local line = ranks[name]
		if IsValid(line) then
			line:GetChildren()[4]:SetText("Inherits from: " .. new_inherit)
		end
	end)

	return parent
end, function()
	return LocalPlayer():HasPermission("manage_ranks")
end, 3)