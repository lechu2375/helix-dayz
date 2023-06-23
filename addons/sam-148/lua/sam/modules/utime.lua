if SAM_LOADED then return end

local PLAYER = FindMetaTable("Player")

function PLAYER:GetUTime()
	return self:sam_get_nwvar("TotalUTime")
end

function PLAYER:SetUTime(time)
	self:sam_set_nwvar("TotalUTime", time)
end

function PLAYER:GetUTimeStart()
	return self:sam_get_nwvar("UTimeStart")
end

function PLAYER:SetUTimeStart(time)
	self:sam_set_nwvar("UTimeStart", time)
end

function PLAYER:GetUTimeSessionTime()
	return CurTime() - self:GetUTimeStart()
end

function PLAYER:GetUTimeTotalTime()
	return self:GetUTime() + CurTime() - self:GetUTimeStart()
end

if SERVER then
	hook.Add("SAM.AuthedPlayer", "SAM.UTime", function(ply)
		ply:SetUTime(ply:sam_get_play_time())
		ply:SetUTimeStart(CurTime())
	end)
end