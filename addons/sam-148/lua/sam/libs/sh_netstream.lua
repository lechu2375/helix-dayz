if SAM_LOADED then return end

--[[
	NetStream - 2.0.1
	https://github.com/alexgrist/NetStream/blob/master/netstream2.lua

	Alexander Grist-Hucker
	http://www.revotech.org
]]--

--[[
	if SERVER then
		netstream.Hook("Hi", function(ply, ...) -- Third argument is called to check if the player has permission to send the net message before decoding
			print(...)
		end, function(ply)
			if not ply:IsAdmin() then
				return false
			end
		end)
		-- OR
		netstream.Hook("Hi", function(ply, ...)
			print(...)
		end)
		netstream.Start(Entity(1), "Hi", "a", 1, {}, true, false, nil, "!") -- First argument player or table of players or any other argument to send to all players
		netstream.Start({Entity(1), Entity(2)}, "Hi", "a", 1, {}, true, false, nil, "!")
		netstream.Start(nil, "Hi", "a", 1, {}, true, false, nil, "!")
	end
	if CLIENT then
		netstream.Hook("Hi", function(...)
			print(...)
		end)
		netstream.Start("Hi", "a", 1, {}, true, false, nil, "!")
	end
]]--

-- Config

local addonName = "SAM"
local mainTable = sam -- _G.netstream = netstream

local mp = sam.mp

--

local type = sam.type
local pcall = pcall
local unpack = unpack

local net = net
local table_maxn = table.maxn

local netStreamSend = addonName .. ".NetStreamDS.Sending"

local netstream = {}
if istable(mainTable) then
	mainTable.netstream = netstream
end

local checks = {}
local receivers = {}

local concat = table.concat
local pack = function(t, n)
	local buffer = {}
	mp.packers["array"](buffer, t, n)
	return concat(buffer)
end

if SERVER then
	util.AddNetworkString(netStreamSend)

	-- local str_sub = string.sub
	-- local function Split(str, buffer, result)
	--	 if not result then
	--		 result = {}
	--	 end

	--	 if not buffer then
	--		 buffer = 32768
	--	 end

	--	 local len = #str
	--	 if len >= buffer then
	--		 result[#result + 1] = str_sub(str, 1, buffer - 1)
	--		 str = str_sub(str, buffer, len)
	--	 else
	--		 result[#result + 1] = str
	--		 return result
	--	 end

	--	 return Split(str, buffer, result)
	-- end

	local player_GetAll = player.GetAll
	function netstream.Start(ply, name, ...)
		local ply_type = type(ply)
		if ply_type ~= "Player" and ply_type ~= "table" then
			ply = player_GetAll()
		end

		local encoded_data = pack({...}, select("#", ...))
		local length = #encoded_data

		net.Start(netStreamSend)
			net.WriteString(name)
			net.WriteUInt(length, 17)
			net.WriteData(encoded_data, length)
		net.Send(ply)
	end

	function netstream.Hook(name, callback, check)
		receivers[name] = callback
		if type(check) == "function" then
			checks[name] = check
		end
	end

	net.Receive(netStreamSend, function(_, ply)
		local name = net.ReadString()

		local callback = receivers[name]
		if not callback then return end

		local length = net.ReadUInt(17)

		local check = checks[name]
		if check and check(ply, length) == false then return end

		local data = net.ReadData(length)

		local status
		status, data = pcall(mp.unpack, data)
		if not status or not sam.istable(data) then return end

		callback(ply, unpack(data, 1, table_maxn(data)))
	end)
else
	checks = nil

	function netstream.Start(name, ...)
		local encoded_data = pack({...}, select("#", ...))
		local length = #encoded_data

		net.Start(netStreamSend)
			net.WriteString(name)
			net.WriteUInt(length, 17)
			net.WriteData(encoded_data, length)
		net.SendToServer()
	end

	function netstream.Hook(name, callback)
		receivers[name] = callback
	end

	net.Receive(netStreamSend, function()
		local callback = receivers[net.ReadString()]
		if not callback then return end

		local length = net.ReadUInt(17)
		local data = net.ReadData(length)

		data = mp.unpack(data)
		callback(unpack(data, 1, table_maxn(data)))
	end)
end

return netstream