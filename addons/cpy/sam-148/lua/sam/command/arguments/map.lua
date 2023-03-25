if SAM_LOADED then return end

local sam, command = sam, sam.command

command.new_argument("map")
	:OnExecute(function(argument, input, ply, _, result)
		local map_name = sam.is_valid_map(input)
		if not map_name and not (argument.optional and input == "None") then
			ply:sam_send_message("invalid", {
				S = "map", S_2 = input
			})
			return false
		end

		table.insert(result, map_name)
	end)

	:Menu(function(set_result, _, buttons, argument)
		local maps = buttons:Add("SAM.ComboBox")
		maps:SetTall(25)

		if argument.optional then
			maps:AddChoice("None", nil, true)
		end

		for _, map_name in ipairs(sam.get_global("Maps")) do
			if not (argument.exclude_current and map_name == game.GetMap()) then
				maps:AddChoice(map_name)
			end
		end

		function maps:OnSelect(_, value)
			set_result(value)
		end

		local value = argument.optional and "None" or maps:GetOptionText(1)
		maps:SetValue(value)
		maps:OnSelect(nil, value)

		return maps
	end)

	:AutoComplete(function(_, result, name)
		for _, map_name in ipairs(sam.get_global("Maps")) do
			if map_name:lower():find(name, 1, true) then
				table.insert(result, map_name)
			end
		end
	end)
:End()