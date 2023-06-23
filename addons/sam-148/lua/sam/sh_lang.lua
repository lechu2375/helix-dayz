if SAM_LOADED then return end

local lang = sam.load_file("sam_language.lua", "sh")

local original = lang
if not isstring(lang) then
	lang = "english"
end

local lang_path = "sam_languages/" .. lang .. ".lua"

if not file.Exists(lang_path, "LUA") then
	lang_path = "sam_languages/english.lua"
	if not file.Exists(lang_path, "LUA") then
		-- maybe they deleted english lang????
		sam.print("SAM is broken!")
		sam.print("Language '" .. tostring(original) .. "' doesn't exist and 'english' language file doesn't exist")
		return false
	else
		sam.print("Language '" .. tostring(original) .. "' doesn't exist falling back to english")
	end
end

local Language = sam.load_file(lang_path, "sh_")

local sub, find = string.sub, string.find

local white_color = Color(236, 240, 241)

do
	local args = {}
	function sam.add_message_argument(arg, func)
		if isstring(arg) and isfunction(func) then
			args[arg] = func
		end
	end

	local insert = function(t, v)
		t.__cnt = t.__cnt + 1
		t[t.__cnt] = v
	end

	function sam.format_message(msg, tbl, result, result_n)
		msg = Language[msg] or msg

		result = result or {}
		result.__cnt = result_n or 0

		local pos = 0
		local start, _end, arg, arg2 = nil, 0, nil, nil

		while true do
			start, _end, arg, arg2 = find(msg, "%{ *([%w_%#]+)([^%{}]-) *%}", _end)
			if not start then break end

			if pos ~= start then
				local txt = sub(msg, pos, start - 1)
				if txt ~= "" then
					insert(result, white_color)
					insert(result, txt)
				end
			end

			local ma = args[sub(arg, 1, 1)]
			if not ma then
				insert(result, "{" .. arg .. " " .. arg2 .. "}")
			else
				ma(result, tbl and tbl[arg], arg, unpack(arg2:Trim():Split(" ")))
			end

			pos = _end + 1
		end

		if pos <= #msg then
			insert(result, white_color)
			insert(result, sub(msg, pos))
		end

		return result
	end

	/*
		Admin
	*/
	sam.add_message_argument("A", function(result, admin)
		if sam.isconsole(admin) then
			-- we need to show that it's the real console!!!!!
			insert(result, Color(236, 240, 241))
			insert(result, "*")
			insert(result, Color(13, 130, 223))
			insert(result, "Console")
		else
			if sam.type(admin) == "Player" then
				if CLIENT and LocalPlayer() == admin then
					insert(result, Color(255, 215, 0))
					insert(result, sam.language.get("You"))
				else
					insert(result, Color(13, 130, 223))
					insert(result, admin:Name())
				end
			else
				insert(result, Color(13, 130, 223))
				insert(result, admin)
			end
		end
	end)

	/*
		Target(s)
	*/
	sam.add_message_argument("T", function(result, targets)
		for k, v in ipairs(sam.get_targets_list(targets)) do
			insert(result, v)
		end
	end)

	/*
		Value(s)
	*/
	sam.add_message_argument("V", function(result, value)
		insert(result, Color(0, 230, 64))
		insert(result, tostring(value))
	end)

	/*
		Text(s)
	*/
	sam.add_message_argument("S", function(result, text, _, color)
		insert(result, sam.get_color(color) or white_color)
		insert(result, tostring(text))
	end)

	-- https://gist.github.com/fernandohenriques/12661bf250c8c2d8047188222cab7e28
	local hex_rgb = function(hex)
		local r, g, b
		if #hex == 4 then
			r, g, b = tonumber(hex:sub(2, 2), 16) * 17, tonumber(hex:sub(3, 3), 16) * 17, tonumber(hex:sub(4, 4), 16) * 17
		else
			r, g, b = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
		end

		if not r or not g or not b then
			return color_white
		end

		return Color(r, g, b)
	end

	/*
		Colored Text(s)
	*/
	sam.add_message_argument("#", function(result, _, color, ...)
		local text = table.concat({...}, " ")
		insert(result, hex_rgb(color))
		insert(result, text)
	end)
end

function sam.get_message(msg)
	msg = Language[msg]
	if not msg then
		return false
	else
		return {Color(236, 240, 241), msg}
	end
end

function sam.language.get(key)
	return Language[key]
end

function sam.language.Add(key, value)
	Language[key] = value
end