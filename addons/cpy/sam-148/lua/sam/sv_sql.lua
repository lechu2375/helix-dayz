if SAM_LOADED then return end

local SQL = sam.SQL
SQL.SetAddonName("SAM")

if file.Exists("sam_sql_config.lua", "LUA") then
	local config = sam.load_file("sam_sql_config.lua", "sv_")
	if sam.istable(config) then
		SQL.SetConfig(config)
	end
end

local current_version = 0

local versions = {}

local add_version = function(version, fn)
	table.insert(versions, {version, fn})
end

local update = function()
	for _, v in ipairs(versions) do
		local version = v[1]
		if version > current_version then
			v[2]()
		end
	end
end

local check_updates = function()
	-- SQL.Query([[DROP TABLE IF EXISTS `sam_players`]])
	-- SQL.Query([[DROP TABLE IF EXISTS `sam_bans`]])
	-- SQL.Query([[DROP TABLE IF EXISTS `sam_ranks`]])
	-- SQL.Query([[DROP TABLE IF EXISTS `sam_version`]])
	-- SQL.Query([[DROP TABLE IF EXISTS `sam_config`]])

	SQL.TableExists("sam_version", function(exists)
		if exists then
			SQL.Query([[
				SELECT
					`version`
				FROM
					`sam_version`
			]], function(version_data)
				current_version = tonumber(version_data.version)

				if sam.version > current_version then
					update()

					SQL.FQuery([[
						UPDATE
							`sam_version`
						SET
							`version` = {1}
					]], {sam.version}):wait()
				end

				hook.Call("SAM.DatabaseLoaded")
			end, true):wait()
		else
			update()

			SQL.Query([[
				CREATE TABLE `sam_version`(
					`version` SMALLINT(255)
				)
			]])

			SQL.FQuery([[
				INSERT INTO
					`sam_version`(`version`)
				VALUES
					({1})
			]], {sam.version}):wait()

			hook.Call("SAM.DatabaseLoaded")
		end
	end):wait()
end

add_version(100, function()
	local auto_increment = SQL.IsMySQL() and "AUTO_INCREMENT" or ""

	SQL.FQuery([[
		CREATE TABLE `sam_players`(
			`id` INT PRIMARY KEY {1f},
			`steamid` VARCHAR(32),
			`name` VARCHAR(255),
			`rank` VARCHAR(30),
			`expiry_date` INT UNSIGNED,
			`first_join` INT UNSIGNED,
			`last_join` INT UNSIGNED,
			`play_time` MEDIUMINT UNSIGNED
		)
	]], {auto_increment})

	SQL.FQuery([[
		CREATE TABLE `sam_bans`(
			`id` INT PRIMARY KEY {1f},
			`steamid` VARCHAR(32),
			`name` VARCHAR(255),
			`reason` VARCHAR(255),
			`admin` VARCHAR(32),
			`unban_date` INT UNSIGNED
		)
	]], {auto_increment})

	SQL.Query([[
		CREATE TABLE `sam_ranks`(
			`name` VARCHAR(30),
			`immunity` TINYINT UNSIGNED,
			`ban_limit` INT UNSIGNED,
			`data` TEXT
		)
	]])
end)

add_version(110, function()
	SQL.Query([[
		ALTER TABLE `sam_ranks`
			ADD `inherit` VARCHAR(30)
	]])

	SQL.Query([[
		UPDATE
			`sam_ranks`
		SET
			`inherit` = 'user'
		WHERE
			`name` != 'user'
	]])

	if not SQL.IsMySQL() then
		SQL.Query([[
			ALTER TABLE
				`sam_players` RENAME TO `tmp_sam_players`
		]])

		SQL.Query([[
			CREATE TABLE `sam_players`(
				`id` INT PRIMARY KEY,
				`steamid` VARCHAR(32),
				`name` VARCHAR(255),
				`rank` VARCHAR(30),
				`expiry_date` INT UNSIGNED,
				`first_join` INT UNSIGNED,
				`last_join` INT UNSIGNED,
				`play_time` INT UNSIGNED
			)
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
				`steamid`,
				`name`,
				`rank`,
				`expiry_date`,
				`first_join`,
				`last_join`,
				`play_time` * 60
			FROM
				`tmp_sam_players`
		]])

		SQL.Query([[DROP TABLE `tmp_sam_players`]])
	else
		SQL.Query([[
			ALTER TABLE
				`sam_players`
			MODIFY
				`play_time` INT UNSIGNED
		]])

		SQL.Query([[
			UPDATE `sam_players`
				SET `play_time` = `play_time` * 60
		]])
	end
end)

add_version(112, function()
	if not SQL.IsMySQL() then
		SQL.Query([[
			ALTER TABLE
				`sam_players` RENAME TO `tmp_sam_players`
		]])

		SQL.Query([[
			ALTER TABLE
				`sam_bans` RENAME TO `tmp_sam_bans`
		]])

		SQL.Query([[
			CREATE TABLE `sam_players`(
				`id` INTEGER PRIMARY KEY,
				`steamid` VARCHAR(32),
				`name` VARCHAR(255),
				`rank` VARCHAR(30),
				`expiry_date` INT UNSIGNED,
				`first_join` INT UNSIGNED,
				`last_join` INT UNSIGNED,
				`play_time` INT UNSIGNED
			)
		]])

		SQL.Query([[
			CREATE TABLE `sam_bans`(
				`id` INTEGER PRIMARY KEY,
				`steamid` VARCHAR(32),
				`name` VARCHAR(255),
				`reason` VARCHAR(255),
				`admin` VARCHAR(32),
				`unban_date` INT UNSIGNED
			)
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
				*
			FROM
				`tmp_sam_players`
		]])

		SQL.Query([[
			INSERT INTO
				`sam_bans`(
					`id`,
					`steamid`,
					`name`,
					`reason`,
					`admin`,
					`unban_date`
				)
			SELECT
				*
			FROM
				`tmp_sam_bans`
		]])

		SQL.Query([[DROP TABLE `tmp_sam_players`]])
		SQL.Query([[DROP TABLE `tmp_sam_bans`]])
	end
end)

add_version(114, function()
	SQL.Query([[
		SELECT
			`name`,
			`data`
		FROM
			`sam_ranks`
	]], function(ranks)
		for k, v in ipairs(ranks) do
			local name, permissions = v.name, v.data
			SQL.FQuery([[
				UPDATE
					`sam_ranks`
				SET
					`data` = {1}
				WHERE
					`name` == {2}
			]], {sam.pon.encode({permissions = sam.pon.decode(permissions), limits = {}}), name})
		end
	end):wait()
end)

add_version(120, function()
	if SQL.IsMySQL() then
		SQL.Query([[ALTER TABLE `sam_bans` ADD UNIQUE (`steamid`)]])
		SQL.Query([[ALTER TABLE `sam_bans` DROP `name`]])
	else
		SQL.Query([[
			ALTER TABLE
				`sam_bans` RENAME TO `tmp_sam_bans`
		]])

		SQL.Query([[
			CREATE TABLE `sam_bans`(
				`id` INTEGER PRIMARY KEY,
				`steamid` VARCHAR(32) UNIQUE,
				`reason` VARCHAR(255),
				`admin` VARCHAR(32),
				`unban_date` INT UNSIGNED
			)
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
				`steamid`,
				`reason`,
				`admin`,
				`unban_date`
			FROM
				`tmp_sam_bans`
		]])

		SQL.Query([[DROP TABLE `tmp_sam_bans`]])
	end

	SQL.Query([[
		SELECT
			`name`,
			`data`
		FROM
			`sam_ranks`
	]], function(ranks)
			for k, v in ipairs(ranks) do
				SQL.FQuery([[
					UPDATE
						`sam_ranks`
					SET
						`data` = {1}
					WHERE
						`name` = {2}
				]], {util.TableToJSON(sam.pon.decode(v.data)), v.name})
			end
		end
	):wait()
end)

add_version(135, function()
	if not SQL.IsMySQL() then return end
	SQL.Query([[ALTER TABLE `sam_ranks` MODIFY `name` BLOB;]])
end)

add_version(138, function()
	SQL.Query([[
		CREATE TABLE `sam_config`(
			`key` VARCHAR(40) UNIQUE,
			`value` TEXT
		)
	]])
end)

add_version(141, function()
	if not SQL.IsMySQL() then return end
	SQL.Query([[ALTER TABLE `sam_config` MODIFY `value` BLOB;]])
end)

add_version(143, function()
	SQL.Query([[DROP TABLE IF EXISTS `sam_config`]])
	SQL.Query([[
		CREATE TABLE `sam_config`(
			`key` VARCHAR(40) UNIQUE,
			`value` BLOB
		)
	]])
end)

add_version(147, function()
	SQL.Query([[CREATE UNIQUE INDEX sam_players_steamid_index ON `sam_players` (`steamid`);]])
	SQL.Query([[CREATE INDEX sam_bans_steamid_index ON `sam_bans` (`steamid`);]])
end)

hook.Add("SAM.DatabaseConnected", "CheckUpdates", check_updates)

hook.Add("SAM.DatabaseLoaded", "SAM.DatabaseLoaded", function()
	sam.DatabaseLoaded = true
	sam.print("Connected to database and loaded data successfully.")
end)

SQL.Connect()

timer.Create("SAM.CheckForUpdates", 60 * 20, 0, function()
	http.Fetch("https://raw.githubusercontent.com/Srlion/SAM-Docs/master/version.txt", function(version, _, _, code)
		if code ~= 200 then return end

		version = version:gsub("%s", "")

		if sam.version >= (tonumber(version) or 0) then return end

		sam.print(Color(255, 0, 0), "New update is available for SAM to download")

		local superadmins = {}
		for k, v in ipairs(player.GetAll()) do
			if v:IsSuperAdmin() then
				table.insert(superadmins, v)
			end
		end

		sam.player.add_text(superadmins, Color(255, 0, 0), "New update is available for SAM to download")
	end)
end)