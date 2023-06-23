if SAM_LOADED then return end
if SERVER then return end

local sam = sam
local SUI = sam.SUI
local type = sam.type

local Line = sui.TDLib.LibClasses.Line

local COMMAND_HELP = SUI.CreateFont("CommandHelp", "Roboto", 14)
local COMMAND_RUN = SUI.CreateFont("CommandRun", "Roboto Medium", 14)

sam.menu.add_tab("https://raw.githubusercontent.com/Srlion/Addons-Data/main/icons/sam/command_window.png", function(column_sheet)
	local tab_body = column_sheet:Add("Panel")
	tab_body:Dock(FILL)
	tab_body:DockMargin(0, 1, 0, 0)

	do
		local title = tab_body:Add("SAM.Label")
		title:Dock(TOP)
		title:DockMargin(10, 10, 0, 0)
		title:SetFont(SAM_TAB_TITLE_FONT)
		title:SetText("Commands")
		title:SetTextColor(SUI.GetColor("menu_tabs_title"))
		title:SizeToContents()
	end

	local body = tab_body:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(10, 5, 10, 10)

	Line(body)

	local left_body = body:Add("SAM.Panel")
	left_body:Dock(LEFT)
	left_body:SetWide(148)

	local search_entry = left_body:Add("SAM.TextEntry")
	search_entry:Dock(TOP)
	search_entry:SetNoBar(true)
	search_entry:SetPlaceholder("Search...")
	search_entry:SetRadius(4)
	search_entry:SetTall(27)

	local category_list = left_body:Add("SAM.CollapseCategory")
	category_list:Dock(FILL)
	category_list:DockMargin(0, SUI.Scale(10), 0, 0)

	local canvas = category_list:GetCanvas()

	local commands_refresh = function()
		if not IsValid(category_list) then return end

		canvas:Clear()
		table.Empty(category_list.items)
		table.Empty(category_list.categories)

		for k, v in ipairs(sam.command.get_commands()) do
			if (v.permission and not LocalPlayer():HasPermission(v.permission)) or v.menu_hide then
				continue
			end

			local item = category_list:add_item(v.name, v.category)
			item:InvalidateParent(true)
			item.help = v.help
			item.command = v

			item.names = {v.name:lower()}
			for _, aliase in ipairs(v.aliases) do
				table.insert(item.names, aliase:lower())
			end
		end
	end
	commands_refresh()

	do
		local hooks = {
			"SAM.CommandAdded", "SAM.CommandModified", "SAM.CommandRemoved",
			"SAM.RemovedPermission",
			{"SAM.ChangedPlayerRank", func = function(ply, rank, old_rank)
				if rank == old_rank then return end
				if ply == LocalPlayer() then
					commands_refresh()
				end
			end},
			{
				"SAM.RankPermissionGiven", "SAM.RankPermissionTaken", "SAM.ChangedInheritRank",
				func = function(rank)
					if rank == LocalPlayer():sam_getrank() then
						commands_refresh()
					end
				end
			},
			{
				"SAM.AddedPermission", "SAM.PermissionModified",
				func = function(_, _, rank)
					if rank == LocalPlayer():sam_getrank() then
						commands_refresh()
					end
				end
			}
		}
		for _, v in ipairs(hooks) do
			if type(v) == "table" then
				for _, v2 in ipairs(v) do
					hook.Add(v2, "SAM.Menu.RefreshCommands", v.func)
				end
			else
				hook.Add(v, "SAM.Menu.RefreshCommands", commands_refresh)
			end
		end
	end

	function search_entry:OnValueChange(text)
		category_list:Search(text:lower())
	end

	do
		local line = Line(body, LEFT)
		line:DockMargin(10, 0, 10, 0)
		line:SetWide(1)
	end

	local buttons = body:Add("SAM.ScrollPanel")
	buttons:Dock(FILL)

	local childs = {}
	local pos = 0
	buttons:GetCanvas():On("OnChildAdded", function(s, child)
		child:Dock(TOP)
		child:DockMargin(0, 0, 0, 5)
		child:SetAlpha(0)
		child:SetVisible(false)
		table.insert(childs, child)

		pos = pos + 1
		child:SetZPos(pos)
	end)

	local run_command = buttons:Add("SAM.Button")
	run_command:Dock(TOP)
	run_command:SetTall(25)
	run_command:SetFont(COMMAND_RUN)
	run_command:SetZPos(100)
	run_command:SetEnabled(false)

	run_command:On("DoClick", function(self)
		LocalPlayer():ConCommand("sam\"" .. self:GetText() .. "\"\"" .. table.concat(self.input_arguments, "\"\"") .. "\"")
	end)

	local help = buttons:Add("SAM.Label")
	help:Dock(TOP)
	help:SetFont(COMMAND_HELP)
	help:SetZPos(101)
	help:SetWrap(true)
	help:SetAutoStretchVertical(true)

	sam.menu.get():On("OnKeyCodePressed", function(s, key_code)
		if key_code == KEY_ENTER and IsValid(run_command) and run_command:IsEnabled() and run_command:IsMouseInputEnabled() and tab_body:IsVisible() then
			run_command:DoClick()
		end
	end)

	function category_list:item_selected(item)
		local arguments = sam.command.get_arguments()
		local command = item.command
		local command_arguments = command.args
		local input_arguments = {}

		for i = #childs, 3, -1 do
			local v = childs[i]
			if not v.no_change or not command:HasArg(v.no_change) then
				if v.no_remove ~= true then
					v:Remove()
				else
					v:Hide()
				end
			end
		end

		local NIL = {}
		for _, v in ipairs(command_arguments) do
			local func = arguments[v.name]["menu"]
			if not func then continue end

			local i = table.insert(input_arguments, NIL)
			local p = func(function(allow)
				if not IsValid(run_command) then return end
				input_arguments[i] = allow == nil and NIL or allow
				for i_2 = 1, #input_arguments do
					if input_arguments[i_2] == NIL then
						run_command:SetEnabled(false)
						return
					end
				end
				run_command:SetEnabled(true)
			end, body, buttons, v, childs)
			if p then
				p:AnimatedSetVisible(true)
			end
		end

		if #command_arguments == 0 then
			run_command:SetEnabled(true)
		end

		run_command:SetText(command.name)
		run_command:AnimatedSetVisible(true)
		run_command.input_arguments = input_arguments

		if command.help then
			help:SetText(command.help)
			help:AnimatedSetVisible(true)
			help:SizeToContents()
		else
			help:AnimatedSetVisible(false)
		end

		buttons:InvalidateLayout(true)
	end

	return tab_body
end, nil, 1)