--
-- CONFIG
--

local UsersTableName = "xadminusers"
local GroupsTableName = "xadmingroups"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

local sam, SQL = sam, sam.SQL

local no_bans_msg = "No bans to import from xadmin."
local import_bans = function()
	SQL.TableExists("xadminbans", function(exists)
		if not exists then
			return sam.print(no_bans_msg)
		end

		SQL.Query([[
			SELECT
				`SteamID`,
				`Admin`,
				`Reason`,
				`EndTime`
			FROM
				`xadminbans`
		]], function(xadmin_bans)
			SQL.Begin()

			SQL.Query([[
				DELETE FROM `sam_bans`
			]])

			local args, steamid, admin = {}, nil, nil
			for _, v in ipairs(xadmin_bans) do
				steamid, admin = util.SteamIDFrom64(v.SteamID), v.Admin

				if admin == "CONSOLE" then
					admin = "Console"
				else
					admin = util.SteamIDFrom64(admin)
				end

				args[1] = steamid
				args[2] = v.Reason
				args[3] = admin
				args[4] = v.EndTime

				SQL.FQuery([[
					INSERT INTO
						`sam_bans`(
							`steamid`,
							`reason`,
							`admin`,
							`unban_date`
						)
					VALUES
						({1}, {2}, {3}, {4})
				]], args)
			end

			SQL.Commit(function()
				sam.print("Imported bans from xadmin.")
			end)
		end)
	end):wait()
end

local get_rank = function(rank)
	if rank == "Super Admin" then
		return "superadmin"
	elseif rank == "Admin" then
		return "admin"
	elseif rank == "Moderator" then
		return "moderator"
	elseif rank == "User" then
		return "user"
	end
	return rank
end

local no_ranks_msg = "No ranks to import from xadmin."
local import_ranks = function()
	SQL.TableExists(GroupsTableName, function(exists)
		if not exists then
			return sam.print(no_ranks_msg)
		end

		SQL.Query(([[
			SELECT
				`Name`,
				`Power`
			FROM
				`%s`
		]]):format(GroupsTableName), function(xadmin_ranks)
			for _, v in ipairs(xadmin_ranks) do
				local name = get_rank(v.Name)

				if not sam.ranks.is_rank(name) then
					sam.ranks.add_rank(name, "user", tonumber(v.Power), 20160)
				end
			end

			sam.print("Imported ranks from xadmin.")
		end):wait()
	end):wait()
end

local no_users_msg = "No users to import from xadmin."
local import_users = function()
	SQL.TableExists(UsersTableName, function(exists)
		if not exists then
			return sam.print(no_users_msg)
		end

		SQL.Query(([[
			SELECT
				`%s`.`SteamID`,
				`%s`.`AccessLevel`,
				IFNULL(SUM(`time`), 0) `total`
			FROM
				`%s`

			LEFT OUTER JOIN `xadmintimetracking` `times`
				on `%s`.`SteamID` = `times`.`SteamID`

			GROUP BY
				`%s`.`SteamID`
		]]):format(UsersTableName, UsersTableName, UsersTableName, UsersTableName, UsersTableName), function(xadmin_players)
			SQL.Begin()

			SQL.Query([[
				DELETE FROM `sam_players`
			]])

			local args = {}
			args[2] = ""
			args[4] = 0
			args[5] = os.time()
			args[6] = os.time()

			for k, v in ipairs(xadmin_players) do
				args[1] = v.SteamID

				local rank = get_rank(v.AccessLevel)
				if not sam.ranks.is_rank(rank) then
					rank = "user"
				end

				args[3] = rank
				args[7] = v.total

				SQL.FQuery([[
					INSERT INTO
						`sam_players`(
							`steamid`,
							`name`,
							`rank`,
							`expiry_date`,
							`first_join`,
							`last_join`,
							`play_time`
						)
					VALUES
						({1}, {2}, {3}, {4}, {5}, {6}, {7})
				]], args)
			end

			SQL.Commit(function()
				sam.print("Imported users from xadmin.")
			end)
		end):wait()
	end):wait()
end

if not sam.ranks.ranks_loaded() then
	return sam.print("Server is connecting to the Database, try again when it connects.")
end

for k, v in ipairs(player.GetAll()) do
	v:Kick("Importing data.")
end

for k, v in pairs(sam.get_connected_players()) do
	sam.player.kick_id(k, "Importing data.")
end

hook.Add("CheckPassword", "SAM.ImportingData", function()
	return false, "Importing data."
end)

sam.print("Starting to import data from xadmin...")
timer.Simple(0, function()
	import_bans()
	import_ranks()
	import_users()

	hook.Remove("CheckPassword", "SAM.ImportingData")
end)