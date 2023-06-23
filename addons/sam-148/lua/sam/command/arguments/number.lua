if SAM_LOADED then return end

local sam, command = sam, sam.command

local get_number = function(argument, input, gsub)
	if (input == "" or input == nil) and argument.optional then
		if argument.default ~= nil then
			return argument.default
		end
		return ""
	end

	local number = tonumber(input)
	if gsub ~= false and not isnumber(number) then
		number = tonumber(input:gsub("%D", ""), 10 /*gsub returns two args*/)
	end

	return number
end

command.new_argument("number")
	:OnExecute(function(argument, input, ply, _, result, i)
		local number = get_number(argument, input)
		if number == "" then
			result[i] = nil
		elseif not number then
			ply:sam_send_message("invalid", {
				S = argument.hint or "number", S_2 = input
			})
			return false
		else
			if argument.min then
				number = math.max(number, argument.min)
			end

			if argument.max then
				number = math.min(number, argument.max)
			end

			if argument.round then
				number = math.Round(number)
			end

			result[i] = number
		end
	end)
	:Menu(function(set_result, body, buttons, argument)
		local number_entry = buttons:Add("SAM.TextEntry")
		number_entry:SetUpdateOnType(true)
		number_entry:SetNumeric(true)
		number_entry:SetTall(25)

		number_entry:SetCheck(function(number)
			number = get_number(argument, number, false)
			set_result(number)
			return number or false
		end)

		local hint = argument.hint or "number"
		if argument.default then
			hint = hint .. " = " .. tostring(argument.default)
		end
		number_entry:SetPlaceholder(hint)

		return number_entry
	end)
:End()