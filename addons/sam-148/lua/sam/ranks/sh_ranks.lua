if SAM_LOADED then return end

SAM_IMMUNITY_SUPERADMIN = 100
SAM_IMMUNITY_ADMIN = 50
SAM_IMMUNITY_USER = 1

function sam.ranks.get_ranks()
	return sam.get_global("Ranks")
end

function sam.ranks.get_rank(rank)
	local ranks = sam.ranks.get_ranks()
	return ranks[rank]
end

function sam.ranks.is_rank(rank)
	if sam.ranks.get_rank(rank) then
		return true
	else
		return false
	end
end

function sam.ranks.is_default_rank(rank)
	return rank == "superadmin" or rank == "admin" or rank == "user"
end

function sam.ranks.inherits_from(rank, rank_2)
	if rank == rank_2 then
		return true
	end

	while true do
		rank = sam.ranks.get_rank(rank)

		if rank then
			local inherits_from = rank.inherit
			if inherits_from == rank_2 then
				return true
			end

			rank = rank.inherit
		else
			return false
		end
	end
end

function sam.ranks.has_permission(rank, permission)
	while true do
		if rank == "superadmin" then
			return true
		end

		rank = sam.ranks.get_rank(rank)

		if rank then
			local rank_permission = rank.data.permissions[permission]
			if rank_permission ~= nil then
				return rank_permission
			end

			rank = rank.inherit
		else
			return false
		end
	end
end

function sam.ranks.get_limit(rank, limit_type)
	while true do
		if rank == "superadmin" then return -1 end

		rank = sam.ranks.get_rank(rank)

		if rank then
			local limit = rank.data.limits[limit_type]
			if limit ~= nil then
				return limit
			end

			rank = rank.inherit
		else
			return cvars.Number("sbox_max" .. limit_type, 0)
		end
	end
end

function sam.ranks.get_immunity(rank)
	rank = sam.ranks.get_rank(rank)
	return rank and rank.immunity or false
end

function sam.ranks.can_target(rank_1, rank_2)
	rank_1, rank_2 = sam.ranks.get_rank(rank_1), sam.ranks.get_rank(rank_2)
	if not rank_1 or not rank_2 then
		return false
	end
	return rank_1.immunity >= rank_2.immunity
end

function sam.ranks.get_ban_limit(rank)
	rank = sam.ranks.get_rank(rank)
	return rank and rank.ban_limit or false
end

if CLIENT then
	hook.Add("SAM.ChangedGlobalVar", "SAM.Ranks.CheckLoadedRanks", function(key, value)
		if key == "Ranks" then
			hook.Call("SAM.LoadedRanks", nil, value)
			hook.Remove("SAM.ChangedGlobalVar", "SAM.Ranks.CheckLoadedRanks")
		end
	end)
end