if SAM_LOADED then return end

local permissions = {}

local give_permission
if SERVER then
	local permissions_to_add = {}

	give_permission = function(name, permission)
		if sam.ranks.ranks_loaded() then
			local rank = sam.ranks.get_rank(name)
			if rank and rank.data.permissions[permission] == nil then
				sam.ranks.give_permission(name, permission)
			end
		else
			table.insert(permissions_to_add, {name, permission})
		end
	end

	hook.Add("SAM.LoadedRanks", "SAM.Command.GivePermissions", function()
		for k, v in ipairs(permissions_to_add) do
			give_permission(v[1], v[2])
		end
	end)
end

local get_next_Other = function()
	for i, v in ipairs(permissions) do
		if v.category == "Other" then
			return i
		end
	end
	return #permissions + 1
end

function sam.permissions.add(permission, category, rank)
	if not sam.isstring(category) then
		category = "Other"
	end

	local permission_data = {
		name = permission,
		category = category,
		rank = rank,
		value = value
	}

	local index = sam.permissions.get_index(permission)
	if not index then
		if category ~= "Other" then
			table.insert(permissions, get_next_Other(), permission_data)
		else
			table.insert(permissions, permission_data)
		end
		hook.Call("SAM.AddedPermission", nil, permission, category, rank, value)
	else
		permissions[index] = permission_data
		hook.Call("SAM.PermissionModified", nil, permission, category, rank, value)
	end

	if SERVER and rank then
		give_permission(rank, permission)
	end
end

function sam.permissions.get_index(permission)
	for i, v in ipairs(permissions) do
		if v.name == permission then
			return i
		end
	end
end

function sam.permissions.remove(permission)
	local index = sam.permissions.get_index(permission)
	if index then
		table.remove(permissions, index)
		hook.Call("SAM.RemovedPermission", nil, permission)
	end
end

function sam.permissions.exists(permission)
	return sam.permissions.get_index(permission) and true or false
end

function sam.permissions.get()
	return permissions
end