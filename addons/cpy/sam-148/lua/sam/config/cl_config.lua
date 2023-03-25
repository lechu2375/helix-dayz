if SAM_LOADED then return end

local sam = sam
local mp = sam.mp
local config = sam.config

function config.set(key, value, force)
	if not sam.isstring(key) then
		error("invalid setting name")
	end

	if not mp.packers[sam.type(value)] then
		error("not supported value type")
	end

	if not force and config.get(key) == value then return end
	sam.netstream.Start("Config.Set", key, value)
end

function config.get(key, default)
	local value = sam.get_global("Config")[key]
	if value ~= nil then
		return value
	end
	return default
end

local menu_settings = {}
function config.add_menu_setting(title, func)
	local i = #menu_settings + 1
	for k, v in ipairs(menu_settings) do
		if v.title == title then
			i = k
			break
		end
	end
	menu_settings[i] = {
		title = title,
		func = func,
	}
end

function config.get_menu_settings()
	return menu_settings
end

hook.Add("SAM.ChangedGlobalVar", "SAM.CheckLoadedConfig", function(key, value)
	if key == "Config" then
		config.loaded = true
		hook.Call("SAM.LoadedConfig", nil, value)
		hook.Remove("SAM.ChangedGlobalVar", "SAM.CheckLoadedConfig")
	end
end)