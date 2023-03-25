if SAM_LOADED then return end

local sam = sam

function sam.parse_args(str)
	local args = {}
	local tmp, in_quotes = "", false
	for i = 1, #str do
		local char = str:sub(i, i)
		if char == "\"" then
			-- i could use string.find to find the next double quotes but thats gonna be overkill
			in_quotes = not in_quotes
			if tmp ~= "" or not in_quotes then
				args[#args + 1], tmp = tmp, ""
			end
		elseif char ~= " " or in_quotes then
			tmp = tmp .. char
		elseif tmp ~= "" then
			args[#args + 1], tmp = tmp, ""
		end
	end
	if tmp ~= "" then
		args[#args + 1] = tmp
	end
	return args, #args
end

function sam.get_targets_list(targets)
	if sam.isstring(targets) then
		return {Color(244, 67, 54), targets}
	end

	local len = #targets

	if len == player.GetCount() and len > 1 then
		return {Color(244, 67, 54), sam.language.get("Everyone")}
	end

	local admin = targets.admin
	local result = {}
	local white = Color(236, 240, 241)
	for i = 1, len do
		local target = targets[i]

		if CLIENT and LocalPlayer() == target then
			table.insert(result, Color(255, 215, 0))
			if admin ~= LocalPlayer() then
				table.insert(result, sam.language.get("You"))
			else
				table.insert(result, sam.language.get("Yourself"))
			end
		elseif admin ~= target then
			local name
			if sam.isentity(target) and target.Name then
				name = target:Name()
			else
				name = "Unknown"
				table.insert(result, white)
				table.insert(result, "*")
			end

			table.insert(result, Color(244, 67, 54))
			table.insert(result, name)
		else
			table.insert(result, Color(255, 215, 0))
			table.insert(result, sam.language.get("Themself"))
		end

		if i ~= len then
			table.insert(result, white)
			table.insert(result, ",")
		end
	end

	return result
end

function sam.is_steamid(id, err) -- https://stackoverflow.com/questions/6724268/check-if-input-matches-steam-id-format
	if sam.isstring(id) and id:match("^STEAM_[0-5]:[0-1]:[0-9]+$") ~= nil then
		return true
	else
		return err and error("invalid steamid", 2) or false
	end
end

function sam.is_steamid64(id, err)
	if sam.isstring(id)
		and tonumber(id)
		and id:sub(1, 7) == "7656119"
		and (#id == 17 or #id == 18) then
		return true
	else
		return err and error("invalid steamid64", 2) or false
	end
end

do
	local console = {}

	do
		local return_console = function()
			return "Console"
		end
		for _, v in ipairs({"SteamID", "SteamID64", "Name", "Nick", "Name"}) do
			console[v] = return_console
		end
		setmetatable(console, {
			__tostring = return_console,
			MetaName = "console"
		})
	end

	function console.IsAdmin()
		return true
	end

	function console.IsSuperAdmin()
		return true
	end

	function console:IsUserGroup(name)
		return name == "superadmin"
	end

	function console.GetUserGroup()
		return "superadmin"
	end

	function console.sam_getrank()
		return "superadmin"
	end

	function console.HasPermission()
		return true
	end

	function console.CanTarget()
		return true
	end

	function console.CanTargetRank()
		return true
	end

	function console.GetBanLimit()
		return 0
	end

	function console.SetUserGroup()
	end

	function sam.isconsole(v)
		return v == console
	end

	sam.console = console
end

do
	local times = {
		"year"; 525600,
		"month"; 43800,
		"week"; 10080,
		"day"; 1440,
		"hour"; 60,
		"minute"; 1
	}

	for i = 1, #times, 2 do
		times[i] = " " .. times[i]
	end

	local floor = math.floor
	function sam.format_length(mins) -- Thanks to this guide https://stackoverflow.com/a/21323783
		if mins <= 0 then
			return "Indefinitely"
		elseif mins <= 1 then
			return "1 minute"
		end

		local str = ""
		for i = 1, #times, 2 do
			local n1, n2 = times[i + 1]
			n2, mins = floor(mins / n1), mins % n1

			if n2 > 0 then
				if str ~= "" then
					if mins == 0 then
						str = str .. " and "
					else
						str = str .. ", "
					end
				end
				str = str .. n2 .. times[i]
				if n2 > 1 then
					str = str .. "s"
				end
			end

			if mins == 0 then
				break
			end
		end
		return str
	end
end

do
	local times = {
		m = 1,
		h = 60,
		d = 1440,
		w = 10080,
		mo = 43800,
		y = 525600
	}

	function sam.parse_length(length)
		local time, found = tonumber(length), false
		if sam.isnumber(length) then
			time, found = length, true
		elseif time then
			found = true
		else
			time = 0
			for t, u in length:gmatch("(%d+)(%a+)") do
				u = times[u]
				if u then
					time = time + (u * t)
					found = true
				end
			end
		end
		if not found then return false end
		return math.Clamp(time, 0, 31536000)
	end

	local times2 = {}
	for k, v in SortedPairsByValue(times, true) do
		table.insert(times2, k)
		table.insert(times2, v)
	end

	local floor = math.floor
	function sam.reverse_parse_length(mins) -- Thanks to this guide https://stackoverflow.com/a/21323783
		if mins <= 0 then
			return "0"
		elseif mins <= 1 then
			return "1m"
		end

		local str = ""
		for i = 1, #times2, 2 do
			local n1, n2 = times2[i + 1]
			n2, mins = floor(mins / n1), mins % n1

			if n2 > 0 then
				if str ~= "" then
					str = str .. " "
				end
				str = str .. n2 .. times2[i]
			end

			if mins == 0 then
				break
			end
		end
		return str
	end
end

do
	if SERVER then
		function sam.hook_call(event, ...)
			hook.Call(event, nil, ...)
			sam.netstream.Start(nil, "HookCall", event, ...)
		end

		function sam.client_hook_call(event, ...)
			sam.netstream.Start(nil, "HookCall", event, ...)
		end
	else
		local function hook_call(event, ...)
			hook.Call(event, nil, ...)
		end
		sam.netstream.Hook("HookCall", hook_call)
	end
end

if SERVER then
	local maps = {}

	for k, v in ipairs(file.Find("maps/*.bsp", "GAME")) do
		maps[k] = v:sub(1, -5):lower()
	end

	sam.set_global("Maps", maps)
end

function sam.is_valid_map(name)
	local maps = sam.get_global("Maps")
	if name:sub(-4) == ".bsp" then
		name = name:sub(1, -5)
	end
	name = name:lower()
	for i = 1, #maps do
		if maps[i] == name then
			return name
		end
	end
	return false
end

function sam.is_valid_gamemode(name)
	name = name:lower()
	local gamemodes = engine.GetGamemodes()
	for i = 1, #gamemodes do
		local gamemode = gamemodes[i]
		if sam.isstring(gamemode.name) and gamemode.name:lower() == name then
			return true
		end
	end
	return false
end

function sam.hook_first(event, name, func)
	if HOOK_HIGH then
		return hook.Add(event, name, func, HOOK_HIGH)
	end

	return hook.Add(event, name, func)
end

function sam.hook_last(event, name, func)
	if HOOK_LOW then
		return hook.Add(event, name, func, HOOK_LOW)
	end

	return hook.Add(event, name, func)
end