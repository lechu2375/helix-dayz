if SAM_LOADED then return end

local sam = sam
local SQL = sam.SQL
local mp = sam.mp
local config = sam.config

local _config = {}

function config.sync()
	sam.set_global("Config", _config, true)
end

local to_hex
do
	local byte = string.byte
	local gsub = string.gsub
	local format = string.format

	local hex = function(c)
		return format("%02X", byte(c))
	end

	function to_hex(text)
		return (gsub(text, ".", hex))
	end
end

function config.set(key, value, force)
	if not sam.isstring(key) then
		error("invalid setting name")
	end

	if not mp.packers[sam.type(value)] then
		error("not supported value type")
	end

	local old = _config[key]
	if not force and value == old then return end

	SQL.FQuery([[
		REPLACE INTO
			`sam_config`(
				`key`,
				`value`
			)
		VALUES
			({1}, X{2})
	]], {key, to_hex(mp.pack(value))})

	_config[key] = value
	config.sync()
	sam.hook_call("SAM.UpdatedConfig", key, value, old)
end

function config.get(key, default)
	local value = _config[key]
	if value ~= nil then
		return value
	end
	return default
end

config.sync()

hook.Add("SAM.DatabaseLoaded", "LoadConfig", function()
	SQL.Query([[
		SELECT
			*
		FROM
			`sam_config`
	]], function(sam_config)
		for _, v in ipairs(sam_config) do
			_config[v.key] = mp.unpack(v.value)
		end

		config.loaded = true
		config.sync()
		hook.Call("SAM.LoadedConfig", nil, _config)
	end):wait()
end)

sam.netstream.Hook("Config.Set", function(ply, key, value)
	config.set(key, value)

	value = tostring(value)

	if value == "" then
		sam.player.send_message(nil, "{A} changed {S Blue} setting to: {S_2 Red}", {
			A = ply, S = key, S_2 = "none"
		})
	else
		sam.player.send_message(nil, "{A} changed {S Blue} setting to: {S_2}", {
			A = ply, S = key, S_2 = value
		})
	end
end, function(ply)
	return ply:HasPermission("manage_config")
end)