if SAM_LOADED then return end

local sam, command = sam, sam.command

command.new_argument("text")
	:OnExecute(function(argument, input, ply, _, result, i)
		if sam.isstring(input) then
			input = input:sub(1, 255)
		end

		local invalid = false
		if input == nil then
			if not argument.optional then
				invalid = true
			end
		elseif argument.check and not argument.check(input, ply) then
			invalid = true
		end

		if invalid then
			ply:sam_send_message("invalid", {
				S = argument.hint or "text", S_2 = input
			})
			return false
		end

		result[i] = input
	end)
	:Menu(function(set_result, body, buttons, argument)
		local text_entry = buttons:Add("SAM.TextEntry")
		text_entry:SetTall(25)

		local default = argument.default
		text_entry:SetCheck(function(text)
			local valid = true
			if text == "" then
				if default then
					text = default
				elseif not argument.optional then
					valid = false
				end
			elseif argument.check and not argument.check(text, LocalPlayer()) then
				valid = false
			end

			set_result(valid and text or nil)

			return valid
		end)

		local hint = argument.hint or "text"
		if default then
			hint = hint .. " = " .. tostring(default)
		end

		text_entry:SetPlaceholder(hint)

		return text_entry
	end)
:End()