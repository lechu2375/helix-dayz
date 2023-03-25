local sui = sui

local draw_material = sui.draw_material

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local GetColor = SUI.GetColor

local RoundedBox = sui.TDLib.LibClasses.RoundedBox
local TextColor = sui.TDLib.LibClasses.TextColor

local TABS_FONT = SUI.CreateFont("CategoryListTabs", "Roboto Bold", 13)
local ITEMS_FONT = SUI.CreateFont("CategoryListItems", "Roboto Medium", 14)

local Panel = {}

local item_OnRemove = function(s)
	local parent = s.parent

	local items = parent.items
	for k, v in ipairs(items) do
		if v == s then
			table.remove(items, k)
			break
		end
	end

	if #items == 0 then
		local category = s.category
		category:Remove()
		parent.categories[category.name] = nil
	end
end

local item_DoClick = function(s)
	local parent = s.parent
	parent:select_item(s)
end

function Panel:Init()
	local categories = {}
	local items = {}

	self.categories = categories
	self.items = items

	self:SetVBarPadding(1)

	local get_category = function(name)
		local category = categories[name]
		if category then return category end

		local expanded = false

		category = self:Add("Panel")
		category:Dock(TOP)
		category:DockMargin(0, 0, 0, 3)
		category.name = name

		local header = category:Add("DButton")
		header:Dock(TOP)
		header:DockMargin(0, 0, 0, 3)
		header:SetFont(TABS_FONT)
		header:SetContentAlignment(4)
		header:SetTextInset(6, 0)
		header:SetText(name)
		header:SizeToContentsY(SUI.Scale(14))

		local cur_col
		local cur_col_text = Color(GetColor("collapse_category_header_text"):Unpack())
		function header:Paint(w, h)
			if expanded then
				cur_col = GetColor("collapse_category_header_active")
				cur_col_text = GetColor("collapse_category_header_text_active")
			elseif self.Hovered then
				cur_col = GetColor("collapse_category_header_hover")
				cur_col_text = GetColor("collapse_category_header_text_hover")
			else
				cur_col = GetColor("collapse_category_header")
				cur_col_text = GetColor("collapse_category_header_text")
			end

			RoundedBox(self, "Background", 3, 0, 0, w, h, cur_col)
			TextColor(self, cur_col_text)
		end

		local image = header:Add(NAME .. ".Image")
		image:Dock(FILL)
		image:SetImage("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sui/arrow.png")

		function image:Draw(w, h)
			local size = SUI.ScaleEven(10)
			draw_material(nil, w - (size / 2) - 6, h / 2, size, cur_col_text, expanded and 180)
		end

		local current_h
		function category.RefreshHeight()
			local h
			if expanded then
				local _
				_, h = category:ChildrenSize()
				if self.searching and h == header:GetTall() then
					h = 0
				end
			else
				h = header:GetTall()
			end

			if current_h == h then return end

			if h > 0 then
				category:SetVisible(true)
			end

			current_h = h

			category:Stop()
			category:SizeTo(-1, h, 0.2, 0, -1, function()
				if h == 0 then
					category:SetVisible(false)
				end
			end)
		end

		function category.SetExpanded(_, set_expanded)
			if expanded == set_expanded then return end

			if sam.isbool(set_expanded) then
				expanded = set_expanded
			else
				expanded = not expanded
			end

			category.RefreshHeight()

			if expanded then
				self:OnCategoryExpanded(category)
			end

			self:InvalidateLayout(true)
		end
		header.DoClick = category.SetExpanded

		category:SetTall(header:GetTall())
		categories[name] = category

		return category
	end

	function self:add_item(name, category_name)
		local category = get_category(category_name)

		local item = category:Add("DButton")
		item:Dock(TOP)
		item:DockMargin(0, 0, 0, 3)
		item:SetFont(ITEMS_FONT)
		item:SetText(name)
		item:SizeToContentsY(SUI.Scale(3 * 2))
		item.name = name
		item.parent = self
		item.category = category

		local cur_col
		local cur_col_text = Color(GetColor("collapse_category_item_text"):Unpack())
		function item:Paint(w, h)
			if self.selected then
				cur_col = GetColor("collapse_category_item_active")
				cur_col_text = GetColor("collapse_category_item_text_active")
			elseif self.Hovered then
				cur_col = GetColor("collapse_category_item_hover")
				cur_col_text = GetColor("collapse_category_item_text_hover")
			else
				cur_col = GetColor("collapse_category_item")
				cur_col_text = GetColor("collapse_category_item_text")
			end

			RoundedBox(self, "Background", 4, 0, 0, w, h, cur_col)
			TextColor(self, cur_col_text)
		end

		item.DoClick = item_DoClick
		item.OnRemove = item_OnRemove

		table.insert(items, item)

		return item
	end
end

function Panel:OnCategoryExpanded(category)
end

function Panel:select_item(item)
	if self.selected_item ~= item then
		if IsValid(self.selected_item) then
			self.selected_item.selected = false
		end
		item.selected = true
		self.selected_item = item
		self:item_selected(item)
	end
end

function Panel:item_selected()
end

function Panel:Search(text, names)
	local items = self.items
	self.searching = true
	for i = 1, #items do
		local item = items[i]
		local category = item.category
		category:SetExpanded(true)

		if not names then
			if item.name:find(text, nil, true) then
				item:SetVisible(true)
			else
				item:SetVisible(false)
			end
		else
			local found = false
			for _, name in ipairs(item.names) do
				if name:find(text, nil, true) then
					found = true
					item:SetVisible(true)
				end
			end
			if not found then
				item:SetVisible(false)
			end
		end

		if text == "" then
			category:SetExpanded(false)
		end

		category:RefreshHeight()
		category:InvalidateLayout(true)
	end
	self.searching = false
end

sui.register("CollapseCategory", Panel, NAME .. ".ScrollPanel")