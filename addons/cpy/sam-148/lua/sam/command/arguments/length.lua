if SAM_LOADED then return end

local sam, command = sam, sam.command

local get_length = function(arg, input)
	if (input == "" or input == nil) and arg.optional then
		if arg.default ~= nil then
			return arg.default
		end

		return ""
	end

	return sam.parse_length(input)
end

command.new_argument("length")
	:OnExecute(function(arg, input, ply, _, result, i)
		local length = get_length(arg, input)
		if length == "" then
			result[i] = nil
		elseif not length then
			ply:sam_send_message("invalid", {
				S = "length", S_2 = input
			})
			return false
		else
			if arg.min and length ~= 0 then
				length = math.max(length, arg.min)
			end

			if arg.max then
				if length == 0 then
					length = arg.max
				else
					length = math.min(length, arg.max)
				end
			end

			result[i] = length
		end
	end)

	:Menu(function(set_result, body, buttons, argument)
		local length_input = buttons:Add("SAM.TextEntry")
		length_input:SetTall(25)

		length_input:SetCheck(function(new_limit)
			new_limit = get_length(argument, new_limit) or nil
			set_result(new_limit)
			return new_limit or false
		end)

		local hint = argument.hint or "length"
		if argument.default then
			hint = hint .. " = " .. tostring(argument.default)
		end

		length_input:SetPlaceholder(hint)
		return length_input
	end)
:End()