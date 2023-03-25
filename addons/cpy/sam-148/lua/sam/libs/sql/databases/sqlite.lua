local _SQL = sam.SQL
local _error = sam.SQL.Error
local sql_query = sql.Query

local SQL = {}

function SQL.Connect(callback)
	timer.Simple(0, callback)
	return true
end

--
--
--
local transactions

local add_transaction = function(query)
	table.insert(transactions, query)
end

function SQL.Begin()
	transactions = {}
	sql_query("BEGIN TRANSACTION")
	return add_transaction
end

function SQL.Commit(callback)
	for i = 1, #transactions do
		if sql_query(transactions[i]) == false then
			sql_query("ROLLBACK TRANSACTION")
			transactions = nil
			_error("Transaction error: " .. sql.LastError())
			return
		end
	end

	transactions = nil

	sql_query("COMMIT TRANSACTION")

	if callback then
		callback()
	end
end
--
--
--

--
--
--
local query_obj = {
	wait = function() end -- mysqloo has query:wait()
}

function SQL.Query(query, callback, first_row, callback_obj)
	local data = sql_query(query)
	if data == false then
		_error("Query error: " .. sql.LastError())
	elseif callback then
		if data == nil then
			if not first_row then
				data = {}
			end
		elseif first_row then
			data = data[1]
		end

		callback(data, callback_obj)
	end

	return query_obj
end

-- local concat = table.concat
-- local prepared_set_values = function(prepared_query, values)
--	 for i = 1, prepared_query.args_n do
--		 prepared_query[prepared_query[-i]] = _SQL.Escape(values[i])
--	 end
--	 return concat(prepared_query, "", 1, prepared_query.n)
-- end

-- local prepared_start = function()
-- end

-- local sub, find = string.sub, string.find
-- function SQL.Prepare(query, callback, first_row, callback_obj)
--	 local prepared_query = {}
--	 prepared_query.wait = query_obj.wait
--	 prepared_query.Start = prepared_start
--	 prepared_query.SetValues = prepared_set_values

--	 local count, args_n = 0, 0
--	 local pos, start, _end = 0, nil, 0
--	 while true do
--		 start, _end = find(query, "?", _end + 1, true)

--		 if not start then
-- 			break
-- 		end

--		 if pos ~= start then
--			 count = count + 1; prepared_query[count] = sub(query, pos, start - 1)
-- 		end

--		 count = count + 1; prepared_query[count] = "NULL"
--		 args_n = args_n - 1; prepared_query[args_n] = count

--		 pos = _end + 1
--	 end

--	 if pos <= #query then
--		 count = count + 1; prepared_query[count] = sub(query, pos)
-- 	end

--	 prepared_query.n = count
--	 prepared_query.args_n = abs(args_n)

--	 return prepared_query
-- end
--
--
--

local SQLStr = SQLStr
function SQL.EscapeString(value, no_quotes)
	return SQLStr(value, no_quotes)
end

function SQL.TableExistsQuery(name)
	return "SELECT `name` FROM `sqlite_master` WHERE `name` = " .. SQL.EscapeString(name) .. " AND `type` = 'table'"
end

--
--
--

return SQL