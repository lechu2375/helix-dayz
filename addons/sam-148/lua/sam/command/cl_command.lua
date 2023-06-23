if SAM_LOADED then return end

local sam = sam
local command = sam.command

local get_syntax = function(args, cmd_args, cmd_str)
	for i = 1, #cmd_args do
		cmd_str = cmd_str .. " "

		local cmd_arg = cmd_args[i]
		local arg = args[i]

		if arg == "" then
			arg = nil
		end

		local optional = cmd_arg.optional
		local c_1, c_2 = "<", ">"
		if optional then
			c_1, c_2 = "[", "]"
		end

		cmd_str = cmd_str .. (arg and "\"" or c_1)

		cmd_str = cmd_str .. (arg or cmd_arg.hint or cmd_arg.name)

		if not arg then
			local default = cmd_arg.default
			if default then
				cmd_str = cmd_str .. " = " .. tostring(default)
			end
		end

		cmd_str = cmd_str .. (arg and "\"" or c_2)
	end

	return cmd_str
end

--
-- Auto Complete
--
concommand.Add("sam", function(_, _, _, text)
	LocalPlayer():ConCommand("sam_run " .. text)
end, function(_, text)
	local ply = LocalPlayer()
	local result = {}

	local new_arg = text:EndsWith(" ")
	local args = sam.parse_args(text)

	local cmd_name = (args[1] or ""):lower()
	local cmd = command.get_command(cmd_name)

	if not cmd or (#args == 1 and not new_arg) then
		local commands = command.get_commands()

		for _, v in ipairs(commands) do
			local name = v.name
			if name:find(cmd_name, nil, true) and ply:HasPermission(name) then
				table.insert(result, "sam " .. name)
			end
		end

		return result
	end

	if not ply:HasPermission(cmd_name) then return end

	table.remove(args, 1)

	if new_arg then
		local syntax = get_syntax(args, cmd.args, "sam " .. cmd.name)
		if #args == 0 then
			print(syntax)
		end
		table.insert(result, syntax)
		return result
	end

	local arg_index = new_arg and #args + 1 or #args

	local cmd_args = cmd.args
	local cmd_args_n = #cmd_args
	if cmd_args_n == 0 then return end

	if arg_index >= cmd_args_n then
		arg_index = cmd_args_n

		if cmd.get_rest_args then
			local arg = table.concat(args, " ", cmd_args_n)
			if arg ~= "" then
				args[cmd_args_n] = arg
				for i = cmd_args_n + 1, #args do
					args[i] = nil
				end
			end
		end
	end

	local arguments = command.get_arguments()
	local cmd_arg = cmd_args[arg_index]
	local func = arguments[cmd_arg.name].auto_complete
	if func then
		func(cmd_arg, result, args[arg_index] or "")
	end

	local cmd_str = "sam " .. cmd_name .. " "
	if arg_index - 1 > 0 then
		cmd_str = cmd_str .. "\"" .. table.concat(args, "\" ", 1, arg_index - 1) .. "\" "
	end

	for k, v in ipairs(result) do
		result[k] = cmd_str .. "\"" .. v .. "\""
	end

	return result
end)