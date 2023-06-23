local _SQL = sam.SQL
local _error = _SQL.Error
local traceback = debug.traceback

local _mysqloo, database = nil, nil

local SQL = {}

function SQL.Connect(callback, failed_callback, config)
	if database then
		local status = database:status()
		if status == _mysqloo.DATABASE_CONNECTING or status == _mysqloo.DATABASE_CONNECTED then
			return true
		end
	end

	_SQL.SetConnected(false)

	require("mysqloo")

	if not mysqloo then
		_error("mysqloo module doesn't exist, get it from https://github.com/FredyH/MySQLOO")
		return false
	end

	_mysqloo = mysqloo

	database = _mysqloo.connect(
		config.Host,
		config.Username,
		config.Password,
		config.Database,
		config.Port
	)

	function database.onConnected()
		callback()
	end

	function database.onConnectionFailed(_, error_text)
		failed_callback(error_text)
	end

	database:connect()

	return true
end

--
--
--
local transaction

local add_transaction = function(query)
	transaction:addQuery(database:query(query))
end

function SQL.Begin()
	transaction = database:createTransaction()
	return add_transaction
end

function SQL.Commit(callback)
	transaction.SQL_traceback = traceback("", 2)

	transaction.onSuccess = callback
	transaction.onError = transaction_onError

	transaction:start()

	transaction = nil
end
--
--
--

--
--
--
local on_query_success = function(query, data)
	if query.SQL_first_row then
		data = data[1]
	end
	query.SQL_callback(data, query.SQL_callback_obj)
end

local on_query_fail = function(query, error_text)
	local status = database:status()

	-- https://github.com/Kamshak/LibK/blob/master/lua/libk/server/sv_libk_database.lua#L129
	if status == _mysqloo.DATABASE_NOT_CONNECTED or status == _mysqloo.DATABASE_CONNECTING or error_text:find("Lost connection to MySQL server during query", 1, true) then
		_SQL.SetConnected(false)
		SQL.Query(query.SQL_query_string, query.SQL_callback, query.SQL_first_row, query.SQL_callback_obj)
	else
		-- ab47e89125e51a79bdf5c52ebd30de60bff1f9040d80a4e984a047c634c6d92c
		_error("Query error: " .. error_text, query.SQL_traceback)
	end
end

function SQL.Query(query, callback, first_row, callback_obj)
	local status = database:status()
	if status == _mysqloo.DATABASE_NOT_CONNECTED or status == _mysqloo.DATABASE_INTERNAL_ERROR then
		_SQL.Connect()
		database:wait()
	end

	local query_string = query
	query = database:query(query)

	query.SQL_query_string = query_string

	if callback then
		query.onSuccess = on_query_success
		query.SQL_callback = callback
		query.SQL_first_row = first_row
		query.SQL_callback_obj = callback_obj
	end

	query.SQL_traceback = traceback("", 2)
	query.onError = on_query_fail

	query:start()

	return query
end

-- local prepared_set_values = function(prepared_query, values)
--	 for i = 1, #values do
--		 local v = values[i]
--		 local value_type = type(v)
--		 if value_type == "string" then
--			 prepared_query:setString(i, v)
--		 elseif value_type == "number" then
--			 prepared_query:setNumber(i, v)
--		 else
--			 error(
--				 string.format(
--					 "%s invalid type '%s' was passed to escape '%s'",
--					 "(" .. SQL.GetAddonName() .. " | MySQL)",
--					 value_type,
--					 v
--				 )
--			 )
--		 end
--	 end
-- end

-- function SQL.Prepare(query, callback, first_row, callback_obj)
--	 local prepared_query = database:prepare(query)
--	 prepared_query.SetValues = prepared_set_values

--	 if callback then
--		 prepared_query.onSuccess = on_query_success
--		 prepared_query.SQL_callback = callback
--		 prepared_query.SQL_first_row = first_row
--		 prepared_query.SQL_callback_obj = callback_obj
--	 end

--	 prepared_query.SQL_traceback = traceback("", 2)
--	 prepared_query.onError = on_query_fail

--	 return prepared_query
-- end

--
--
--

function SQL.EscapeString(value, no_quotes)
	if no_quotes then
		return database:escape(value)
	else
		return "'" .. database:escape(value) .. "'"
	end
end

function SQL.TableExistsQuery(name)
	return "SHOW TABLES LIKE " .. SQL.EscapeString(name)
end

return SQL