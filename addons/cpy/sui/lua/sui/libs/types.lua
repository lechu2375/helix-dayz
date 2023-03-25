-- https://gist.github.com/CapsAdmin/0d9c1e77d0fc22d910e182bfeb9812e5
local getmetatable = getmetatable

do
	local types = {
		["string"] = "",
		["boolean"] = true,
		["number"] = 0,
		["function"] = function() end,
		["thread"] = coroutine.create(getmetatable),
		["Color"] = Color(0, 0, 0),
	}

	for k, v in pairs(types) do
		if not getmetatable(v) then
			debug.setmetatable(v, {MetaName = k})
		else
			getmetatable(v).MetaName = k
		end
	end
end

function sui.type(value)
	if value == nil then
		return "nil"
	end
	local meta = getmetatable(value)
	if meta then
		meta = meta.MetaName
		if meta then
			return meta
		end
	end
	return "table"
end

do
	local function add(name)
		local new_name = name
		if name == "bool" then
			new_name = "boolean"
		end
		sui["is" .. name:lower()] = function(value)
			local meta = getmetatable(value)
			if meta and meta.MetaName == new_name then
				return true
			else
				return false
			end
		end
	end

	add("string")
	add("number")
	add("bool")
	add("function")

	add("Angle")
	add("Vector")
	add("Panel")
	add("Matrix")
end

function sui.isentity(value)
	local meta = getmetatable(value)
	if meta then
		if meta.MetaName == "Entity" then
			return true
		end
		meta = meta.MetaBaseClass
		if meta then
			return meta.MetaName == "Entity"
		end
	end
	return false
end
sui.IsEntity = sui.isentity

local type = sui.type
function sui.istable(value)
	return type(value) == "table"
end