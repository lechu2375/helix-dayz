if SAM_LOADED then return end

local sam, command = sam, sam.command

local can_target_player = function(arg, admin, target, cmd, input)
	if not IsValid(target) or not target:IsPlayer() or not target:sam_get_nwvar("is_authed") then
		if input then
			admin:sam_send_message("cant_find_target", {
				S = input
			})
		end
		return false
	end

	if not arg.allow_higher_target and not admin:CanTarget(target) then
		if cmd then
			admin:sam_send_message("cant_target_player", {
				S = target:Name()
			})
		end
		return false
	end

	if arg.cant_target_self and admin == target then
		if cmd then
			admin:sam_send_message("cant_target_self", {
				S = cmd.name
			})
		end
		return false
	end

	return true
end

local check_text_match = function(text, ply)
	if ply:Name():lower():find(text, 1, true) then return true end
	if ply:sam_getrank():lower():find(text, 1, true) then return true end
	if team.GetName(ply:Team()):lower():find(text, 1, true) then return true end

	if not ply:IsBot() then
		return ply:SteamID():lower():find(text, 1, true) or ply:SteamID64():lower():find(text, 1, true)
	end

	return false
end

command.new_argument("player")
	:OnExecute(function(arg, input, ply, cmd, result, n)
		if input == nil and arg.optional then
			if sam.isconsole(ply) then
				ply:sam_send_message("cant_target_self", {
					S = cmd.name
				})
				return false
			end
			result[n] = {ply, admin = ply, input = input}
			return
		end

		local single_target = arg.single_target
		local targets = {admin = ply, input = input}

		if input == "*" then
			if single_target then
				ply:sam_send_message("cant_target_multi_players")
				return false
			end
			local players = player.GetAll()
			for i = 1, #players do
				local v = players[i]
				if can_target_player(arg, ply, v) then
					table.insert(targets, v)
				end
			end
		elseif input:sub(1, 1) == "#" and not single_target then
			local tmp = {}
			for _, v in ipairs(input:sub(2):Trim():Split(",")) do
				v = tonumber(v)
				if not sam.isnumber(v) then continue end
				local target = Entity(v)
				if not tmp[target] and IsValid(target) and target:IsPlayer() then
					tmp[target] = true
					if can_target_player(arg, ply, target) then
						table.insert(targets, target)
					end
				end
			end
		else
			local target
			if input == "^" then
				target = ply
			elseif input == "@" and not sam.isconsole(ply) then
				target = ply:GetEyeTrace().Entity
			elseif sam.is_steamid(input) then
				target = player.GetBySteamID(input)
			elseif sam.is_steamid64(input) then
				target = player.GetBySteamID64(input)
			elseif input:sub(1, 1) == "#" then
				local index = input:sub(2):Trim()
				index = tonumber(index)

				if not isnumber(index) then
					ply:sam_send_message("invalid_id", {
						S = input
					})
					return false
				end

				target = Entity(index)

				if not IsValid(target) or not target:IsPlayer() then
					ply:sam_send_message("player_id_not_found", {
						S = index
					})
					return false
				end
			else
				if input:sub(1, 1) == "%" and #input > 1 then
					input = input:sub(2)
				end

				target = sam.player.find_by_name(input)
				if sam.istable(target) then
					if single_target then
						ply:sam_send_message("found_multi_players", {T = target})
						return false
					else
						for k, v in ipairs(target) do
							if can_target_player(arg, ply, v) then
								table.insert(targets, v)
							end
						end
						goto _end
					end
				end
			end

			if not can_target_player(arg, ply, target, cmd, input) then
				return false
			end

			table.insert(targets, target)
		end

		::_end::

		if #targets == 0 then
			ply:sam_send_message("cant_find_target", {
				S = input
			})
			return false
		end
		result[n] = targets
	end)

	-- Do NOT ask me about this code at all please because I feel shit about it but I'm not gonna make
	-- a file specially for this one
	:Menu(function(set_result, body, buttons, argument, childs)
		if body.ply_list then
			local ply_list = body.ply_list
			ply_list.argument = argument
			ply_list.set_result = set_result
			ply_list.multi_select = argument.single_target ~= true

			if argument.single_target == true and #ply_list:GetSelected() > 1 then
				ply_list:ClearSelection()
			end

			ply_list:OnRowSelected()
			ply_list:GetParent():Show()

			return
		end

		local SUI = sam.SUI

		local SetVisible = FindMetaTable("Panel").SetVisible

		local left_body = body:Add("SAM.Panel")
		left_body:Dock(LEFT)
		left_body:DockMargin(0, 0, 5, 0)
		left_body:SetWide(0)
		left_body.no_remove = true
		left_body.no_change = "player"

		SetVisible(left_body, false)
		left_body.SetVisible = function(s, visible)
			if visible == s:IsVisible() or visible == s.visible_state then return end

			if visible then
				SetVisible(s, true)
				s:InvalidateLayout(true)
			end

			s.visible_state = visible
			s:Stop()

			s:SizeTo(visible and SUI.Scale(320) or 0, -1, 0.2, 0, 0, function()
				SetVisible(s, visible)
				s:InvalidateParent(true)
			end)
		end
		left_body:Show()

		table.insert(childs, left_body)

		local ply_list = left_body:Add("SAM.ScrollPanel")
		ply_list:Dock(FILL)
		ply_list:Background(Color(34, 34, 34), 3)
		ply_list.argument = argument
		ply_list.set_result = set_result
		ply_list.multi_select = argument.single_target ~= true
		ply_list.Paint = function(s, w, h)
			s:RoundedBox("Background", 3, 0, 0, w, h, SUI.GetColor("text_entry_bg"))
		end

		local lines = {}
		function ply_list:OnClickLine(line, clear)
			local multi_select = ply_list.multi_select
			if not multi_select and not clear then return end

			if multi_select and input.IsKeyDown(KEY_LCONTROL) then
				if line.Selected then
					line.Selected = false
					self.main_selected_line = nil
					self:OnRowSelected()
					return
				end
				clear = false
			end

			if multi_select and input.IsKeyDown(KEY_LSHIFT) then
				local selected = self:GetSelectedLine()
				if selected then
					self.main_selected_line = self.main_selected_line or selected

					if clear then
						self:ClearSelection()
					end

					local first = math.min(self.main_selected_line.id, line.id)
					local last = math.max(self.main_selected_line.id, line.id)

					for id = first, last do
						local line_2 = lines[id]
						local was_selected = line_2.Selected

						line_2.Selected = true

						if not was_selected then
							self:OnRowSelected(line_2.id, line_2)
						end
					end

					return
				end
			end

			if not multi_select or clear then
				self:ClearSelection()
			end

			line.Selected = true

			self.main_selected_line = line
			self:OnRowSelected(line.id, line)
		end

		function ply_list:GetSelected()
			local ret = {}
			for _, v in ipairs(lines) do
				if v.Selected then
					table.insert(ret, v)
				end
			end
			return ret
		end

		function ply_list:GetSelectedLine()
			for _, line in ipairs(lines) do
				if line.Selected then return line end
			end
		end

		function ply_list:ClearSelection()
			for _, line in ipairs(lines) do
				line.Selected = false
			end
			self:OnRowSelected()
		end

		function ply_list:OnRowSelected()
			local plys = {}
			for k, v in ipairs(ply_list:GetSelected()) do
				plys[k] = v.ply:EntIndex()
			end
			if #plys == 0 then
				self.set_result(nil)
			else
				self.set_result("#" .. table.concat(plys, ","))
			end
		end

		function ply_list:OnRowRightClick(_, line)
			local dmenu = vgui.Create("SAM.Menu")
			dmenu:SetInternal(line)

			local name = line.ply:Name()
			dmenu:AddOption("Copy Name", function()
				SetClipboardText(name)
			end)

			dmenu:AddSpacer()

			local steamid = line.ply:SteamID()
			dmenu:AddOption("Copy SteamID", function()
				SetClipboardText(steamid)
			end)

			dmenu:AddOption("Copy SteamID64", function()
				SetClipboardText(util.SteamIDTo64(steamid))
			end)

			dmenu:Open()
			dmenu:SetPos(input.GetCursorPos())
		end

		local item_click = function(s)
			ply_list:OnClickLine(s, true)
		end

		local item_rightclick = function(s)
			if not s.Selected then
				ply_list:OnClickLine(s, true)
			end
			ply_list:OnRowRightClick(s.id, s)
		end

		local item_cursor = function(s)
			if input.IsMouseDown(MOUSE_LEFT) then
				ply_list:OnClickLine(s)
			end
		end

		local added_players = {}

		local add_player = function(ply, i)
			if can_target_player(ply_list.argument, LocalPlayer(), ply) then
				local player_button = ply_list:Add("SAM.Button")
				player_button:Dock(TOP)
				player_button:DockMargin(0, 0, 0, 2)
				player_button:DockPadding(4, 4, 4, 4)
				player_button:SetContained(false)
				player_button:SetText("")
				player_button:SetZPos(i)
				player_button.DoClick = item_click
				player_button.DoRightClick = item_rightclick
				player_button.OnCursorMoved = item_cursor

				local line = player_button:Add("SAM.PlayerLine")
				line:SetMouseInputEnabled(false)
				line:SetInfo({
					steamid = ply:IsBot() and "BOT" or ply:SteamID(),
					name = ply:Name(),
					rank = ply:sam_getrank()
				})

				player_button:InvalidateLayout(true)
				player_button:SizeToChildren(false, true)

				player_button.ply = ply
				player_button.line = line
				player_button.id = table.insert(lines, player_button)
				body.search_entry:OnValueChange()

				added_players[ply] = true
			end
		end

		ply_list:On("Think", function()
			local players = player.GetAll()
			for i = 1, #players do
				local ply = players[i]
				if not added_players[ply] then
					add_player(ply, i)
				end
			end

			local argument = ply_list.argument
			for i = 1, #lines do
				local line = lines[i]
				local ply = line.ply

				if not can_target_player(argument, LocalPlayer(), ply) then
					line:Remove()
					table.remove(lines, i)
					added_players[ply] = nil
					ply_list:OnRowSelected()
					break
				end

				line = line.line
				line:SetName(ply:Name())
				line:SetRank(ply:sam_getrank())
			end
		end)

		local search_entry = left_body:Add("SAM.TextEntry")
		search_entry:Dock(TOP)
		search_entry:DockMargin(0, 0, 0, 5)
		search_entry:SetPlaceholder("Search... (name/steamid/rank/job)")
		search_entry:SetBackground(Color(34, 34, 34))
		search_entry:SetTall(25)
		search_entry:SetNoBar(true)

		function search_entry:OnValueChange(text)
			if text == nil then
				text = self:GetValue()
			end
			if text ~= "" then
				ply_list:ClearSelection()
			end
			text = text:lower()
			for i, line in ipairs(lines) do
				local ply = line.ply
				if IsValid(ply) then
					line:SetVisible(check_text_match(text, ply))
				end
			end
			ply_list:GetCanvas():InvalidateLayout(true)
		end

		body.ply_list = ply_list
		body.search_entry = search_entry
	end)

	:AutoComplete(function(arg, result, name)
		local ply = LocalPlayer()
		for k, v in ipairs(player.GetAll()) do
			if can_target_player(arg, ply, v) and v:Name():lower():find(name, 1, true) then
				table.insert(result, "%" .. v:Name())
			end
		end
	end)
:End()