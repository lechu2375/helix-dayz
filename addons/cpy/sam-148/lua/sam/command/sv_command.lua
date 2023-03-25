if SAM_LOADED then return end

local sam = sam
local command = sam.command

local sub, match, lower = string.sub, string.match, string.lower
local WHITE, RED, BLUE, GREEN = Color(236, 240, 241), Color(244, 67, 54), Color(13, 130, 223), Color(0, 230, 64)

local prefix
local send_syntax = function(ply, args, cmd_name, cmd_args, cmd_args_n, from_console)
	local tbl = {
		WHITE,
		from_console and "sam " or prefix,
		cmd_name
	}

	for i = 1, cmd_args_n do
		table.insert(tbl, " ")

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

		table.insert(tbl, WHITE)
		table.insert(tbl, arg and "\"" or c_1)

		table.insert(tbl, cmd_arg.optional and BLUE or RED)
		table.insert(tbl, arg or cmd_arg.hint or cmd_arg.name)

		if not arg then
			local default = cmd_arg.default
			if default then
				table.insert(tbl, WHITE)
				table.insert(tbl, " = ")

				table.insert(tbl, GREEN)
				table.insert(tbl, tostring(default))
			end
		end

		table.insert(tbl, WHITE)
		table.insert(tbl, arg and "\"" or c_2)
	end

	sam.player.add_text(ply, unpack(tbl))
	return ""
end

local run_command = function(ply, text, from_console)
	local args = sam.parse_args(text)
	local cmd_name = args[1]
	if not cmd_name then return end

	cmd_name = lower(cmd_name)

	local cmd = command.get_command(cmd_name)
	if not cmd then return end

	if not cmd.can_console_run and sam.isconsole(ply) then
		ply:sam_send_message("cant_use_as_console", {
			S = cmd_name
		})
		return ""
	end

	if cmd.permission and not sam.isconsole(ply) and not ply:HasPermission(cmd.permission) then
		ply:sam_send_message("no_permission", {
			S = cmd_name
		})
		return ""
	end

	local can_run = hook.Call("SAM.CanRunCommand", nil, ply, cmd_name, args, cmd)
	if can_run == false then return "" end

	table.remove(args, 1)

	local cmd_args = cmd.args
	local cmd_args_n = #cmd_args

	-- !kick srlion fuck off > !kick "srlion" "fuck off"
	if cmd.get_rest_args then
		local arg = table.concat(args, " ", cmd_args_n)
		if arg ~= "" then
			args[cmd_args_n] = arg
			for i = cmd_args_n + 1, #args do
				args[i] = nil
			end
		end
	end

	-- we need to make sure that all required arguments are there
	for i = 1, cmd_args_n do
		if not cmd_args[i].optional then
			local arg = args[i]
			if arg == nil or arg == "" then
				send_syntax(ply, args, cmd_name, cmd_args, cmd_args_n, from_console)
				return ""
			end
		end
	end

	local result = {}
	local args_count = 0
	local arguments = command.get_arguments()
	for i = 1, cmd_args_n do
		local cmd_arg = cmd_args[i]
		local arg = args[i]

		if arg == nil or arg == "" then
			arg = cmd_arg.default
		else
			args_count = args_count + 1
		end

		if arguments[cmd_arg.name](cmd_arg, arg, ply, cmd, result, i) == false then
			return ""
		end
	end

	cmd.on_execute(ply, unpack(result, 1, table.maxn(result)))

	if not cmd.disable_notify then
		sam.print(
			RED, ply:Name(),
			WHITE, "(",
			BLUE, ply:SteamID(),
			WHITE, ") ran command '",
			RED, cmd_name,
			WHITE,
			args_count > 0
			and "' with arguments: \"" .. table.concat(args, "\" \"") .. "\""
			or "'"
		)
	end

	hook.Call("SAM.RanCommand", nil, ply, cmd_name, args, cmd, result)

	return ""
end

hook.Add("PlayerSay", "SAM.Command.RunCommand", function(ply, text)
	prefix = sub(text, 1, 1)
	if prefix ~= "!" then return end
	if match(sub(text, 2, 2), "%S") == nil then return end

	return run_command(ply, sub(text, 2), false)
end)

local console_run_command = function(ply, _, _, text)
	if match(sub(text, 2, 2), "%S") == nil then return end

	if not IsValid(ply) then
		ply = sam.console
	else
		-- making it same as PlayerSay delay
		-- https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/client.cpp#L747
		-- no delay for server console
		if not ply:sam_check_cooldown("RunCommand", 0.66) then
			return
		end
	end

	run_command(ply, text, true, false)
end
concommand.Add("sam", console_run_command)
concommand.Add("sam_run", console_run_command) -- for some dumb reason i cant make "sam" command clientside just for auto-complete