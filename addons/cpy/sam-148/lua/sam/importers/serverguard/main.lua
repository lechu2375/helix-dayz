local sam, SQL = sam, sam.SQL

local von = include("sam/importers/serverguard/sam_von.lua")
if not von then
	return sam.print("Download the importer folder again from gmodstore.")
end

local no_bans_msg = "No bans to import from serverguard."
local import_bans = function()
	SQL.TableExists("serverguard_bans", function(exists)
		if not exists then
			return sam.print(no_bans_msg)
		end

		SQL.Query([[
			DELETE FROM `sam_bans`
		]])

		SQL.Query([[
			INSERT INTO
				`sam_bans`(
					`id`,
					`steamid`,
					`reason`,
					`admin`,
					`unban_date`
				)
			SELECT
				`id`,
				`steam_id`,
				`reason`,
				'Console',
				`end_time`
			FROM
				`serverguard_bans`
		]], function()
			sam.print("Imported bans from serverguard.")
		end)
	end)
end

local no_ranks_msg = "No ranks to import from serverguard."
local import_ranks = function()
	SQL.TableExists("serverguard_ranks", function(exists)
		if not exists then
			return sam.print(no_ranks_msg)
		end

		SQL.Query([[
			SELECT
				*
			FROM
				`serverguard_ranks`
		]], function(serverguard_ranks)
			for _, v in pairs(serverguard_ranks) do
				local name = v.unique_id

				if not sam.ranks.is_rank(name) then
					sam.ranks.add_rank(name, "user", tonumber(v.immunity), tonumber(v.banlimit))
				end

				local data = sam.isstring(v.data) and util.JSONToTable(v.data)
				local tools = sam.istable(data) and sam.istable(data.Restrictions) and sam.istable(data.Restrictions.Tools) and data.Restrictions.Tools

				if not tools then continue end

				for tool_name, value in pairs(tools) do
					if value == false then
						sam.ranks.take_permission(name, tool_name)
					else
						sam.ranks.give_permission(name, tool_name)
					end
				end
			end

			sam.print("Imported ranks from serverguard.")
		end)
	end)
end

local no_users_msg = "No users to import from serverguard."

local import_expires = function(data)
	if data and #data > 0 then
		local began = false
		for _, v in ipairs(data) do
			local ply_data = v.data and von.deserialize(v.data) or {}
			if not sam.isnumber(tonumber(ply_data.groupExpire)) then continue end

			if not began then
				began = true
				SQL.Begin()
			end

			SQL.FQuery([[
				UPDATE
					`sam_players`
				SET
					`expiry_date` = {1}
				WHERE
					`steamid` = {2}
			]], {tonumber(ply_data.groupExpire), v.steam_id})
		end
		SQL.Commit(function()
			sam.print("Imported users from serverguard.")
		end)
	else
		sam.print("Imported users from serverguard.")
	end
end

local import_users = function()
	SQL.TableExists("serverguard_users", function(exists)
		if not exists then
			return sam.print(no_users_msg)
		end

		SQL.Query([[
			DELETE FROM `sam_players`
		]])

		SQL.Query([[
			INSERT INTO
				`sam_players`(
					`id`,
					`steamid`,
					`name`,
					`rank`,
					`expiry_date`,
					`first_join`,
					`last_join`,
					`play_time`
				)
			SELECT
				`id`,
				`steam_id`,
				`name`,
				`rank`,
				0,
				`last_played`,
				`last_played`,
				0
			FROM
				`serverguard_users`
		]], function()
				SQL.Query([[
					SELECT
						`steam_id`,
						`data`
					FROM
						`serverguard_users`
				]], import_expires)
			end)
	end)
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

sam.print("Starting to import data from serverguard...")
timer.Simple(0, function()
	import_bans()
	import_ranks()
	import_users()

	hook.Remove("CheckPassword", "SAM.ImportingData")
end)