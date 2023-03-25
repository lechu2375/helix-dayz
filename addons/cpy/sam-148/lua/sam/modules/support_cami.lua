if SAM_LOADED then return end

local ranks_loaded
if SERVER then
	ranks_loaded = sam.ranks.ranks_loaded()
else
	ranks_loaded = sam.ranks.get_ranks() ~= nil
end

do
	local load_ranks = function()
		for name, rank in pairs(sam.ranks.get_ranks()) do
			if not sam.ranks.is_default_rank(name) then
				CAMI.RegisterUsergroup({Name = name, Inherits = rank.inherit}, "SAM")
			end
		end
	end

	if ranks_loaded then
		load_ranks()
	else
		hook.Add("SAM.LoadedRanks", "SAM.CAMI.LoadRanksToCAMI", load_ranks)
	end
end

hook.Add("SAM.AddedRank", "SAM.CAMI.AddedRank", function(name, rank)
	if not sam.ranks.is_default_rank(name) then
		CAMI.RegisterUsergroup({Name = name, Inherits = rank.inherit}, "SAM")
	end
end)

hook.Add("SAM.RemovedRank", "SAM.CAMI.RemovedRank", function(name)
	CAMI.UnregisterUsergroup(name, "SAM")
end)

hook.Add("SAM.RankNameChanged", "SAM.CAMI.RankNameChanged", function(old, new)
	CAMI.UnregisterUsergroup(old, "SAM")
	CAMI.RegisterUsergroup({Name = new, Inherits = sam.ranks.get_rank(new).inherit}, "SAM")
end)

hook.Add("SAM.ChangedPlayerRank", "SAM.CAMI.ChangedPlayerRank", function(ply, new_rank, old_rank)
	CAMI.SignalUserGroupChanged(ply, old_rank, new_rank, "SAM")
end)

hook.Add("SAM.ChangedSteamIDRank", "SAM.CAMI.ChangedSteamIDRank", function(steamid, new_rank, old_rank)
	CAMI.SignalSteamIDUserGroupChanged(steamid, old_rank, new_rank, "SAM")
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------

if SERVER then
	do
		local on_user_group_registered = function(rank, source)
			if source ~= "SAM" then
				sam.ranks.add_rank(rank.Name, sam.ranks.is_rank(rank.Inherits) and rank.Inherits or "user")
			end
		end

		local load_ranks = function()
			for _, rank in pairs(CAMI.GetUsergroups()) do
				on_user_group_registered(rank, "CAMI")
			end
			hook.Add("CAMI.OnUsergroupRegistered", "SAM.CAMI.OnUsergroupRegistered", on_user_group_registered)
		end

		if ranks_loaded then
			load_ranks()
		else
			hook.Add("SAM.LoadedRanks", "SAM.CAMI.LoadRanksFromCAMI", load_ranks)
		end
	end

	hook.Add("CAMI.OnUsergroupUnregistered", "SAM.CAMI.OnUsergroupUnregistered", function(rank, source)
		if source ~= "SAM" then
			sam.ranks.remove_rank(rank.Name)
		end
	end)

	hook.Add("CAMI.PlayerUsergroupChanged", "SAM.CAMI.PlayerUsergroupChanged", function(ply, _, new_rank, source)
		if ply and IsValid(ply) and source ~= "SAM" then
			sam.player.set_rank(ply, new_rank)
		end
	end)

	hook.Add("CAMI.SteamIDUsergroupChanged", "SAM.CAMI.SteamIDUsergroupChanged", function(steamid, _, new_rank, source)
		if sam.is_steamid(steamid) and source ~= "SAM" then
			sam.player.set_rank_id(steamid, new_rank)
		end
	end)
end

do
	local on_privilege_registered = function(privilege)
		sam.permissions.add(privilege.Name, "CAMI", privilege.MinAccess)
	end

	local load_privileges = function()
		for _, privilege in pairs(CAMI.GetPrivileges()) do
			on_privilege_registered(privilege)
		end
		hook.Add("CAMI.OnPrivilegeRegistered", "SAM.CAMI.OnPrivilegeRegistered", on_privilege_registered)
	end

	if ranks_loaded then
		load_privileges()
	else
		hook.Add("SAM.LoadedRanks", "SAM.CAMI.LoadPrivileges", load_privileges)
	end
end

hook.Add("CAMI.OnPrivilegeUnregistered", "SAM.CAMI.OnPrivilegeUnregistered", function(privilege)
	sam.permissions.remove(privilege.Name)
end)

hook.Add("CAMI.PlayerHasAccess", "SAM.CAMI.PlayerHasAccess", function(ply, privilege, callback, target)
	if sam.type(ply) ~= "Player" then return end

	local has_permission = ply:HasPermission(privilege)
	if sam.type(target) == "Player" then
		callback(has_permission and ply:CanTarget(target))
	else
		callback(has_permission)
	end

	return true
end)