if SAM_LOADED then return end

local sam = sam
local mp = sam.load_file("sam/libs/message_pack/sh_messagepack.lua")
local EXT_VECTOR  = 1
local EXT_ANGLE   = 2
local EXT_ENTITY  = 3
local EXT_PLAYER  = 4
local EXT_COLOR   = 5
local EXT_CONSOLE = 6

mp.packers["Entity"] = function(buffer, ent)
	local buf = {}
	mp.packers["number"](buf, ent:EntIndex())
	mp.packers["ext"](buffer, EXT_ENTITY, buf[1])
end
mp.packers["Vehicle"] = mp.packers["Entity"]
mp.packers["Weapon"] = mp.packers["Entity"]
mp.packers["NPC"] = mp.packers["Entity"]
mp.packers["NextBot"] = mp.packers["Entity"]
mp.packers["PhysObj"] = mp.packers["Entity"]

mp.packers["Player"] = function(buffer, ply)
	local buf = {}
	mp.packers["number"](buf, ply:UserID())
	mp.packers["ext"](buffer, EXT_PLAYER, buf[1])
end

local VECTOR = {}
mp.packers["Vector"] = function(buffer, vec)
	VECTOR[1] = vec.x
	VECTOR[2] = vec.y
	VECTOR[3] = vec.z

	local buf = {}
	mp.packers["_table"](buf, VECTOR)
	mp.packers["ext"](buffer, EXT_VECTOR, table.concat(buf))
end

local ANGLE = {}
mp.packers["Angle"] = function(buffer, ang)
	ANGLE[1] = ang.p
	ANGLE[2] = ang.y
	ANGLE[3] = ang.r

	local buf = {}
	mp.packers["_table"](buf, ANGLE)
	mp.packers["ext"](buffer, EXT_ANGLE, table.concat(buf))
end

local COLOR = {}
mp.packers["Color"] = function(buffer, col)
	COLOR[1] = col.r
	COLOR[2] = col.g
	COLOR[3] = col.b
	COLOR[4] = col.a

	local buf = {}
	mp.packers["_table"](buf, COLOR)
	mp.packers["ext"](buffer, EXT_COLOR, table.concat(buf))
end

mp.packers["console"] = function(buffer)
	mp.packers["ext"](buffer, EXT_CONSOLE, "")
end

local Entity = Entity
local _Player
local Color = Color
local Vector = Vector
local Angle = Angle
local unpackers = {
	[EXT_ENTITY] = function(v)
		return Entity(v)
	end,
	[EXT_PLAYER] = function(v)
		return _Player(v)
	end,
	[EXT_VECTOR] = function(v)
		return Vector(v[1], v[2], v[3])
	end,
	[EXT_ANGLE] = function(v)
		return Angle(v[1], v[2], v[3])
	end,
	[EXT_COLOR] = function(v)
		return Color(v[1], v[2], v[3], v[4])
	end,
	[EXT_CONSOLE] = function(v)
		return sam.console
	end
}

local Player = Player
if CLIENT then
	local players = {}

	local Name = function(s)
		return s.name
	end

	_Player = function(id)
		local ply = Player(id)

		if not IsValid(ply) then
			local name = players[id]
			if name then
				return {
					name = name,
					Name = Name
				}
			end
		end

		return ply
	end

	hook.Add("OnEntityCreated", "SAM.GetPlayerName", function(ent)
		if ent:IsPlayer() and ent:IsValid() then
			ent.sam_userid = ent:UserID() -- userid is -1 in EntityRemoved?????
		end
	end)

	hook.Add("EntityRemoved", "SAM.GetPlayerName", function(ent)
		if not ent:IsPlayer() then return end

		local id = ent.sam_userid
		if not id then return end

		players[id] = ent:Name()

		timer.Simple(60, function()
			if not IsValid(ent) then
				players[id] = nil
			end
		end)
	end)
else
	_Player = Player
end

mp.build_ext = function(tag, data)
	local f = mp.unpacker(data)
	local _, v = f()
	return unpackers[tag](v)
end

sam.mp = mp