if SAM_LOADED then return end

local sam, netstream = sam, sam.netstream

local globals

if SERVER then
	globals = {}
	local order = {}

	local get_order_key = function(key)
		for i = 1, #order do
			if order[i] == key then
				return i
			end
		end
	end

	function sam.set_global(key, value, force)
		if force or globals[key] ~= value then
			globals[key] = value

			if value ~= nil then
				if not get_order_key(key) then
					table.insert(order, key)
				end
			else
				local i = get_order_key(key)
				if i then
					table.remove(order, i)
				end
			end

			netstream.Start(nil, "SetGlobal", key, value)
		end
	end

	hook.Add("OnEntityCreated", "SAM.Globals", function(ent)
		if ent:IsPlayer() and ent:IsValid() then
			netstream.Start(ent, "SendGlobals", globals, order)
		end
	end)
end

if CLIENT then
	function sam.set_global(key, value)
		if globals then
			globals[key] = value
			hook.Call("SAM.ChangedGlobalVar", nil, key, value)
		end
	end
	netstream.Hook("SetGlobal", sam.set_global)

	netstream.Hook("SendGlobals", function(vars, order)
		globals = vars

		for _, key in ipairs(order) do
			hook.Call("SAM.ChangedGlobalVar", nil, key, vars[key])
		end
	end)
end

function sam.get_global(key, default)
	if globals then
		local value = globals[key]
		if value ~= nil then
			return value
		end
	end

	return default
end