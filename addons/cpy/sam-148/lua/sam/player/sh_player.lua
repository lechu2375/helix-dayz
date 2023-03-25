if SAM_LOADED then return end

local sam = sam
local config = sam.config

do
	local _player = {}
	sam.player = setmetatable(sam.player, {
		__index = _player,
		__newindex = function(_, k, v)
			_player[k] = v
			if sam.isfunction(v) and debug.getlocal(v, 1) == "ply" then
				FindMetaTable("Player")["sam_" .. k] = v
				sam.console["sam_" .. k] = v
			end
		end
	})
end

function sam.player.find_by_name(name)
	name = name:lower()
	local current, players = nil, player.GetAll()
	for i = 1, #players do
		local ply = players[i]
		local found = ply:Name():lower():find(name, 1, true)
		if found then
			if current then
				if not sam.istable(current) then
					current = {current, ply}
				else
					table.insert(current, ply)
				end
			else
				current = ply
			end
		end
	end
	return current
end

do
	if CLIENT then
		config.add_menu_setting("Chat Prefix (Leave empty for no prefix)", function()
			local entry = vgui.Create("SAM.TextEntry")
			entry:SetPlaceholder("")
			entry:SetNoBar(true)
			entry:SetConfig("ChatPrefix", "")

			return entry
		end)
	end

	function sam.player.send_message(ply, msg, tbl)
		if SERVER then
			if sam.isconsole(ply) then
				local result = sam.format_message(msg, tbl)
				sam.print(unpack(result, 1, result.__cnt))
			else
				return sam.netstream.Start(ply, "send_message", msg, tbl)
			end
		else
			local prefix_result = sam.format_message(config.get("ChatPrefix", ""))
			local prefix_n = #prefix_result

			local result = sam.format_message(msg, tbl, prefix_result, prefix_n)
			chat.AddText(unpack(result, 1, result.__cnt))
		end
	end

	if SERVER then
		function sam.player.add_text(ply, ...)
			if sam.isconsole(ply) then
				sam.print(...)
			else
				sam.netstream.Start(ply, "add_text", ...)
			end
		end
	end

	if CLIENT then
		sam.netstream.Hook("send_message", function(msg, tbl)
			sam.player.send_message(nil, msg, tbl)
		end)

		sam.netstream.Hook("add_text", function(...)
			chat.AddText(...)
		end)
	end
end

do
	local PLAYER = FindMetaTable("Player")

	function PLAYER:IsAdmin()
		return self:CheckGroup("admin")
	end

	function PLAYER:IsSuperAdmin()
		return self:CheckGroup("superadmin")
	end

	local inherits_from = sam.ranks.inherits_from
	function PLAYER:CheckGroup(name)
		return inherits_from(self:sam_getrank(), name)
	end

	local has_permission = sam.ranks.has_permission
	function PLAYER:HasPermission(perm)
		return has_permission(self:sam_getrank(), perm)
	end

	local can_target = sam.ranks.can_target
	function PLAYER:CanTarget(ply)
		return can_target(self:sam_getrank(), ply:sam_getrank())
	end

	function PLAYER:CanTargetRank(rank)
		return can_target(self:sam_getrank(), rank)
	end

	local get_ban_limit = sam.ranks.get_ban_limit
	function PLAYER:GetBanLimit(ply)
		return get_ban_limit(self:sam_getrank())
	end

	function PLAYER:sam_get_play_time()
		return self:sam_get_nwvar("play_time", 0) + self:sam_get_session_time()
	end

	function PLAYER:sam_get_session_time()
		return os.time() - self:sam_get_nwvar("join_time", 0)
	end

	function PLAYER:sam_getrank()
		return self:sam_get_nwvar("rank", "user")
	end

	function PLAYER:sam_setrank(name)
		return self:sam_set_nwvar("rank", name)
	end

	if SERVER then
		function PLAYER:Ban(length)
			self:sam_ban(length)
		end

		hook.Remove("PlayerInitialSpawn", "PlayerAuthSpawn")
	end
end

do
	local set_cooldown = function(ply, name, time)
		if not ply.sam_cool_downs then
			ply.sam_cool_downs = {}
		end
		ply.sam_cool_downs[name] = SysTime() + time
		return true
	end

	function sam.player.check_cooldown(ply, name, time)
		if not ply.sam_cool_downs or not ply.sam_cool_downs[name] then
			return set_cooldown(ply, name, time)
		end

		local current_time = SysTime()
		local cool_down = ply.sam_cool_downs[name]
		if cool_down > current_time then
			return false, cool_down - current_time
		else
			return set_cooldown(ply, name, time)
		end
	end
end