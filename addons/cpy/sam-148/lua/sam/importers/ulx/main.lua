-- PLEASE READ
-- PLEASE READ
-- PLEASE READ
-- PLEASE READ

-- Set the timing module to import times from when importing users
-- Supported modules: "utime"
-- If your timing module is not here then STOP and make a support ticket so I can add support for it before you import your users
local TIME_MODULE = "utime" -- Set this to nil if you don't want to import times

-- PLEASE READ
-- PLEASE READ
-- PLEASE READ
-- PLEASE READ

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

local sam, SQL = sam, sam.SQL

local ulib_unescape_backslash = function(s)
	return s:gsub("\\\\", "\\")
end

local ulib_explode = function(separator, str, limit)
	local t = {}
	local curpos = 1
	while true do -- We have a break in the loop
		local newpos, endpos = str:find(separator, curpos) -- find the next separator in the string
		if newpos ~= nil then -- if found then..
			table.insert(t, str:sub(curpos, newpos - 1)) -- Save it in our table.
			curpos = endpos + 1 -- save just after where we found it for searching next time.
		else
			if limit and #t > limit then
				return t -- Reached limit
			end
			table.insert(t, str:sub(curpos)) -- Save what's left in our array.
			break
		end
	end
	return t
end

local ulib_split_args = function(args, start_token, end_token)
	args = args:Trim()
	local argv = {}
	local curpos = 1 -- Our current position within the string
	local in_quote = false -- Is the text we're currently processing in a quote?
	start_token = start_token or "\""
	end_token = end_token or "\""
	local args_len = args:len()

	while in_quote or curpos <= args_len do
		local quotepos = args:find(in_quote and end_token or start_token, curpos, true)

		-- The string up to the quote, the whole string if no quote was found
		local prefix = args:sub(curpos, (quotepos or 0) - 1)
		if not in_quote then
			local trimmed = prefix:Trim()
			if trimmed ~= "" then -- Something to be had from this...
				local t = ulib_explode("%s+", trimmed)
				table.Add(argv, t)
			end
		else
			table.insert(argv, prefix)
		end

		-- If a quote was found, reduce our position and note our state
		if quotepos ~= nil then
			curpos = quotepos + 1
			in_quote = not in_quote
		else -- Otherwise we've processed the whole string now
			break
		end
	end

	return argv, in_quote
end

local ulib_parse_key_values = function(str, convert)
	local lines = ulib_explode("\r?\n", str)
	local parent_tables = {} -- Traces our way to root
	local current_table, n = {}, 0
	local is_insert_last_op = false
	local tmp_string = string.char(01, 02, 03) -- Replacement

	for i, line in ipairs(lines) do
		local tokens = ulib_split_args((line:gsub("\\\"", tmp_string)))

		for i, token in ipairs(tokens) do
			tokens[ i ] = ulib_unescape_backslash(token):gsub(tmp_string, "\"")
		end

		local num_tokens = #tokens

		if num_tokens == 1 then
			local token = tokens[ 1 ]
			if token == "{" then
				local new_table = {}
				if is_insert_last_op then
					current_table[ table.remove(current_table) ] = new_table
				else
					table.insert(current_table, new_table)
				end
				is_insert_last_op = false
				table.insert(parent_tables, current_table)
				current_table = new_table

			elseif token == "}" then
				is_insert_last_op = false
				current_table = table.remove(parent_tables)
				if current_table == nil then
					return nil, "Mismatched recursive tables on line " .. i
				end

			else
				is_insert_last_op = true
				table.insert(current_table, tokens[ 1 ])
			end

		elseif num_tokens == 2 then
			is_insert_last_op = false
			if convert and tonumber(tokens[ 1 ]) then
				tokens[ 1 ] = tonumber(tokens[ 1 ])
			end

			current_table[ tokens[ 1 ] ] = tokens[ 2 ]

		elseif num_tokens > 2 then
			return nil, "Bad input on line " .. i
		end
	end

	if #parent_tables ~= 0 then
		return nil, "Mismatched recursive tables"
	end

	if convert and n == 1 and
		type(current_table.Out) == "table" then -- If we caught a stupid garry-wrapper

		current_table = current_table.Out
	end

	return current_table
end

local ulib_remove_comment_header = function(data, comment_char)
	comment_char = comment_char or ";"
	local lines = ulib_explode("\r?\n", data)
	local end_comment_line = 0
	for _, line in ipairs(lines) do
		local trimmed = line:Trim()
		if trimmed == "" or trimmed:sub(1, 1) == comment_char then
			end_comment_line = end_comment_line + 1
		else
			break
		end
	end

	local not_comment = table.concat(lines, "\n", end_comment_line + 1)
	return not_comment:Trim()
end

local no_bans_msg = "No bans to import from ulx."
local import_bans = function()
	sam.print("Importing bans...")

	if not sql.TableExists("ulib_bans") then
		return sam.print(no_bans_msg)
	end

	local bans = sql.Query("SELECT `steamid`, `unban`, `reason`, `admin` FROM `ulib_bans`")

	if not sam.istable(bans) then
		return sam.print(no_bans_msg)
	end

	local bans_count = #bans

	if bans_count == 0 then
		return sam.print(no_bans_msg)
	end

	local began, imported_count = false, 0

	for i = 1, bans_count do
		local ban = bans[i]
		local steamid = ban.steamid

		if sam.is_steamid64(steamid) then
			steamid = util.SteamIDFrom64(ban.steamid)
		end

		if sam.is_steamid(steamid) then
			if not began then
				began = true
				SQL.Begin()
				SQL.Query([[
					DELETE FROM `sam_bans`
				]])
			end

			local name, reason, admin, unban_date = ban.name, ban.reason, ban.admin, tonumber(ban.unban)

			if name == "NULL" then
				name = ""
			end

			if reason == "NULL" then
				reason = "none"
			end

			if sam.isstring(admin) and admin ~= "NULL" and admin ~= "(Console)" then
				admin = admin:match("%(STEAM_%w:%w:%w*%)"):sub(2, -2)
			else
				admin = "Console"
			end

			if not sam.isnumber(unban_date) or unban_date < 0 then
				unban_date = 0
			end

			SQL.FQuery([[
				INSERT INTO
					`sam_bans`(
						`steamid`,
						`reason`,
						`admin`,
						`unban_date`
					)
				VALUES
					({1}, {2}, {3}, {4})
			]], {steamid, reason, admin, unban_date})

			imported_count = imported_count + 1
		end
	end

	if began then
		SQL.Commit(function()
			sam.print("Imported " .. imported_count .. " ban(s).")
		end)
	else
		sam.print(no_bans_msg)
	end
end

local groups_path = "ulib/groups.txt"
local no_ranks_msg = "No ranks to import from ulx."

local imported_ranks

local function add_rank(rank, info, ranks)
	if not sam.ranks.is_rank(rank) then
		local inherit = info.inherit_from
		if inherit and ranks[inherit] and not sam.ranks.is_rank(inherit) then
			add_rank(inherit, ranks[inherit], ranks)
		end
		imported_ranks = imported_ranks + 1
		sam.ranks.add_rank(rank, inherit)
	end
end

local import_ranks = function()
	sam.print("Importing ranks...")

	if not file.Exists(groups_path, "DATA") then
		return sam.print(no_ranks_msg)
	end

	local ranks_text = file.Read(groups_path, "DATA")

	if not sam.isstring(ranks_text) then
		return sam.print(no_ranks_msg)
	end

	local ranks, err = ulib_parse_key_values(ulib_remove_comment_header(ranks_text, "/"))
	if not ranks then
		return sam.print("ULX ranks file was not formatted correctly, make a support ticket. (include the error message if there is one)" .. (err and (" | error: " .. err) or ""))
	end

	imported_ranks = 0

	for rank, info in pairs(ranks) do
		if not sam.ranks.is_rank(rank) then
			add_rank(rank, info, ranks)
		end
	end

	if imported_ranks == 0 then
		sam.print(no_ranks_msg)
	else
		sam.print("Imported " .. imported_ranks .. " rank(s).")
	end
end

local users_path = "ulib/users.txt"
local no_users_msg = "No users to import from ulx."

local import_users = function()
	sam.print("Importing users...")

	if not file.Exists(users_path, "DATA") then
		return sam.print(no_users_msg)
	end

	local users_text = file.Read(users_path, "DATA")

	if not sam.isstring(users_text) then
		return sam.print(no_users_msg)
	end

	local users, err = ulib_parse_key_values(ulib_remove_comment_header(users_text, "/"))
	if not users then
		return sam.print("ULX users file was not formatted correctly, make a support ticket. (include the error message if there is one)" .. (err and (" | error: " .. err) or ""))
	end

	local current_time = os.time()
	local imported_users = 0

	local times = false

	if TIME_MODULE == "utime" then
		local utime = sql.Query("SELECT `player`, `lastvisit`, `totaltime` FROM `utime`")
		if sam.istable(utime) then
			times = {}
			for i = 1, #utime do
				local v = utime[i]
				times[v.player] = v
			end
		end
	end

	local began = false

	for steamid, info in pairs(users) do
		if sam.is_steamid64(steamid) then
			steamid = util.SteamIDFrom64(steamid)
		end

		if sam.is_steamid(steamid) then
			if not began then
				began = true
				SQL.Begin()
				SQL.Query([[
					DELETE FROM `sam_players`
				]])
			end

			local first_join, last_join, play_time = current_time, current_time, 0

			if times and TIME_MODULE == "utime" then
				local utime_user = times[util.CRC("gm_" .. steamid .. "_gm")]
				if utime_user then
					last_join, play_time = utime_user.lastvisit, math.floor(utime_user.totaltime)
					first_join = last_join
				end
			end

			local rank = info.group
			if not rank or not sam.ranks.is_rank(rank) then
				rank = "user"
			end

			SQL.FQuery([[
				INSERT INTO
					`sam_players`(
						`steamid`,
						`name`,
						`rank`,
						`expiry_date`,
						`first_join`,
						`last_join`,
						`play_time`
					)
				VALUES
					({1}, {2}, {3}, {4}, {5}, {6}, {7})
			]], {steamid, info.name or "", rank, 0, first_join, last_join, play_time})

			imported_users = imported_users + 1
		end
	end

	if began then
		SQL.Commit(function()
			sam.print("Imported " .. imported_users .. " user(s).")
		end)
	else
		sam.print(no_users_msg)
	end
end

if not sam.ranks.ranks_loaded() then
	return sam.print("Server is connecting to the Database, try again when it connects.")
end

for k, v in ipairs(player.GetAll()) do
	v:Kick("Importing data.")
end

for k, v in pairs(sam.get_connected_players()) do
	sam.player.kick_id(k, "Importing data.")
end

hook.Add("CheckPassword", "SAM.ImportingData", function()
	return false, "Importing data."
end)

sam.print("Starting to import data from ulx...")
timer.Simple(0, function()
	import_bans()
	import_ranks()
	import_users()

	hook.Remove("CheckPassword", "SAM.ImportingData")
end)