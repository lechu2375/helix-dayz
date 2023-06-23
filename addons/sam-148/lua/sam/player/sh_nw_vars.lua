if SAM_LOADED then return end

local netstream = sam.netstream

local nwvars = {}

if SERVER then
	function sam.player.set_nwvar(ply, key, value, force)
		local id = ply:EntIndex()
		if force or nwvars[id][key] ~= value then
			nwvars[id][key] = value
			netstream.Start(nil, "SetNWVar", id, key, value)
		end
	end
end

if CLIENT then
	function sam.player.set_nwvar(ply, key, value)
		local id_vars = nwvars[ply:EntIndex()]
		id_vars[key] = value
	end

	netstream.Hook("SetNWVar", function(id, key, value)
		local id_vars = nwvars[id]
		if id_vars == nil then
			nwvars[id] = {
				[key] = value
			}
		else
			id_vars[key] = value
		end
	end)

	netstream.Hook("SendNWVars", function(vars)
		nwvars = vars
	end)

	netstream.Hook("RemoveNWVar", function(id)
		nwvars[id] = nil
	end)
end

function sam.player.get_nwvar(ply, key, default)
	local value = nwvars[ply:EntIndex()]
	if value then
		value = value[key]
		if value ~= nil then
			return value
		end
	end
	return default
end

if SERVER then
	hook.Add("OnEntityCreated", "SAM.NWVars", function(ent)
		if ent:IsPlayer() and ent:IsValid() then
			nwvars[ent:EntIndex()] = {}
			netstream.Start(ent, "SendNWVars", nwvars)
		end
	end)

	hook.Add("EntityRemoved", "SAM.NWVars", function(ent)
		if ent:IsPlayer() then
			local id = ent:EntIndex()
			nwvars[id] = nil
			netstream.Start(nil, "RemoveNWVar", id)
		end
	end)
end