GAS.Logging.Modules = {}
local AfterRetrieveIDs = {}

function GAS.Logging.Modules:IsAddonInstalled(addon_name)
	if (GAS.Logging.Config.InstalledAddons[addon_name] ~= nil and GAS.Logging.Config.InstalledAddons[addon_name] ~= 0) then
		return GAS.Logging.Config.InstalledAddons[addon_name] == 1
	elseif (GAS.Logging.ThirdPartyAddons[addon_name]) then
		return GAS.Logging.ThirdPartyAddons[addon_name].installed()
	else
		return false
	end
end

local Modules = {}
function GAS.Logging:GetModules()
	return Modules
end
function GAS.Logging:GetModule(category, name)
	if (Modules[category]) then
		return Modules[category][name]
	end
end

GAS.Logging.IndexedModules = {}
function GAS.Logging:GetModuleFromID(id)
	return GAS.Logging.IndexedModules[id]
end

function GAS.Logging.Modules:GetDiscordWebhooks(module_tbl)
	if (GAS.Logging.Config.Modules[module_tbl.Category]) then
		if (GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name]) then
			if (GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name].DiscordWebhooks) then
				local webhooks = {}
				for webhook_name in pairs(GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name].DiscordWebhooks) do
					webhooks[#webhooks + 1] = {webhook_name, GAS.Logging.Config.DiscordWebhooks[webhook_name]}
				end
				return webhooks
			end
		end
	end
	return nil
end

function GAS.Logging.Modules:IsSimulated(module_tbl)
	if (GAS.Logging.Config.Modules[module_tbl.Category]) then
		if (GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name]) then
			return GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name].Simulate == true
		end
	end
	return false
end

function GAS.Logging.Modules:IsEnabled(module_tbl)
	if (GAS.Logging.Config.Modules[module_tbl.Category]) then
		if (GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name]) then
			return GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name].Disabled ~= true
		end
	end
	return true
end

function GAS.Logging.Modules:IsLiveLogsDisabled(module_tbl)
	if (GAS.Logging.Config.Modules[module_tbl.Category]) then
		if (GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name]) then
			return GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name].LiveLogsDisabled == true
		end
	end
	return false
end

function GAS.Logging:MODULE()
	local module_tbl = {
		Hooks = {},
		Hook = function(self, hook_name, identifier, func)
			if (self.Disabled) then return end
			GAS:hook(hook_name, "logging:" .. identifier, func)

			self.Hooks[hook_name] = self.Hooks[hook_name] or {}
			self.Hooks[hook_name][identifier] = self
		end,
		UnHook = function(self, hook_name, identifier, func)
			GAS:unhook(hook_name, "logging:" .. identifier)

			self.Hooks[hook_name] = self.Hooks[hook_name] or {}
			self.Hooks[hook_name][identifier] = nil
		end,
		SuperiorHook = function(self, hook_name, identifier, func)
			if (self.Disabled) then return end
			GAS.Hooking:SuperiorHook(hook_name, "logging:" .. identifier, func)
		end,
		InferiorHook = function(self, hook_name, identifier, func)
			if (self.Disabled) then return end
			GAS.Hooking:InferiorHook(hook_name, "logging:" .. identifier, func)
		end,
		FeedbackHook = function(self, hook_name, identifier, func)
			if (self.Disabled) then return end
			GAS.Hooking:FeedbackHook(hook_name, "logging:" .. identifier, func)
		end,
		ObserverHook = function(self, hook_name, identifier, func)
			if (self.Disabled) then return end
			GAS.Hooking:ObserverHook(hook_name, "logging:" .. identifier, func)
		end,
		Log = function(self, log)
			if (self.Disabled) then return end
			GAS.Logging:Log(self, log)
		end,
		LogPhrase = function(self, log_phrase, ...)
			if (self.Disabled) then return end
			GAS.Logging:LogPhrase(self, log_phrase)
		end,
		Setup = function(self, func)
			self.SetupFunc = func
		end,
	}
	return module_tbl
end

function GAS.Logging:AddModule(module_tbl)
	module_tbl.Disabled = false
	if (GAS.Logging.Config.Modules[module_tbl.Category]) then
		local module_config_tbl = GAS.Logging.Config.Modules[module_tbl.Category][module_tbl.Name]
		if (module_config_tbl) then
			module_tbl.Disabled = module_config_tbl.Disabled == true
		end
	end

	Modules[module_tbl.Category] = Modules[module_tbl.Category] or {}
	Modules[module_tbl.Category][module_tbl.Name] = module_tbl

	if (not module_tbl.Disabled and module_tbl.SetupFunc ~= nil) then
		module_tbl:SetupFunc()
	end

	if (AfterRetrieveIDs == true) then
		GAS.Logging.Modules:RetrieveIDs()
	end
end

local AfterLoad = {}
function GAS.Logging.Modules:Load()
	local load_files = {
		[""] = (file.Find("gmodadminsuite/modules/logging/modules/*.lua", "LUA")),
		["addons/"] = (file.Find("gmodadminsuite/modules/logging/modules/addons/*.lua", "LUA"))
	}
	if (GAS.Logging.GamemodeModulesEnabled.Sandbox) then
		load_files["sandbox/"] = (file.Find("gmodadminsuite/modules/logging/modules/sandbox/*.lua", "LUA"))
	end
	if (GAS.Logging.GamemodeModulesEnabled.DarkRP) then
		load_files["gamemodes/darkrp/"] = (file.Find("gmodadminsuite/modules/logging/modules/gamemodes/darkrp/*.lua", "LUA"))
	end
	if (GAS.Logging.GamemodeModulesEnabled.TTT) then
		load_files["gamemodes/ttt/"] = (file.Find("gmodadminsuite/modules/logging/modules/gamemodes/ttt/*.lua", "LUA"))
	end
	if (GAS.Logging.GamemodeModulesEnabled.Murder) then
		load_files["gamemodes/murder/"] = (file.Find("gmodadminsuite/modules/logging/modules/gamemodes/murder/*.lua", "LUA"))
	end
	if (GAS.Logging.GamemodeModulesEnabled.Cinema) then
		load_files["gamemodes/cinema/"] = (file.Find("gmodadminsuite/modules/logging/modules/gamemodes/cinema/*.lua", "LUA"))
	end
	for dir, files in pairs(load_files) do
		for _,f in ipairs(files) do
			include("gmodadminsuite/modules/logging/modules/" .. dir .. f)
		end
	end
	GAS:SaveConfig("logging", GAS.Logging.Config)

	GAS.Logging.ModulesLoaded = true
	for _,v in ipairs(AfterLoad) do
		v()
	end
	AfterLoad = {}
end
function GAS.Logging.Modules:AfterLoad(func)
	if (GAS.Logging.ModulesLoaded) then
		func()
	else
		table.insert(AfterLoad, func)
	end
end

function GAS.Logging.Modules:RetrieveID(module, callback)
	local fire_query = module.RetrievingCallbacks == nil
	module.RetrievingCallbacks = module.RetrievingCallbacks or {}
	table.insert(module.RetrievingCallbacks, callback)
	if (fire_query) then
		GAS.Database:Prepare("SELECT module.`id` AS 'retrieved_id' FROM " .. GAS.Database:ServerTable("gas_logging_modules") .. " AS module WHERE `category_id`=(SELECT category.`id` FROM " .. GAS.Database:ServerTable("gas_logging_module_categories") .. " AS category WHERE category.`name`=?) AND module.`name`=?", {module.Category, module.Name}, function(rows)
			if (not rows or #rows == 0) then
				GAS:print("[bLogs] Everybody panic! Module " .. module.Category .. " -> " .. module.Name .. " has no existing ID??", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			else
				local retrieved_id = tonumber(rows[1].retrieved_id)
				for _,v in ipairs(module.RetrievingCallbacks) do
					v(retrieved_id)
				end
				module.RetrievingCallbacks = nil
			end
		end)
	end
end

function GAS.Logging.Modules:RetrieveIDs(callback)
	GAS.Database:Query([[

		SELECT
			MAX(`id`) AS 'categories_max',
			(SELECT MAX(`id`) FROM ]] .. GAS.Database:ServerTable("gas_logging_modules") .. [[) AS 'modules_max'
		FROM ]] .. GAS.Database:ServerTable("gas_logging_module_categories") .. [[

	]], function(max_rows)
		local max_category_id, max_module_id = 0,0
		if (max_rows and #max_rows > 0) then
			max_category_id, max_module_id = tonumber(max_rows[1].categories_max) or 0, tonumber(max_rows[1].modules_max) or 0
		end

		GAS.Database:Query([[
			SELECT `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_module_categories`.`name` AS 'category', `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_module_categories`.`id` AS 'category_id', `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_modules`.`name` AS 'module', `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_modules`.`id` AS 'module_id' FROM `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_modules`
			INNER JOIN `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_module_categories` ON `]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_module_categories`.`id`=`]] .. GAS.Database.ServerTablePrefix .. [[gas_logging_modules`.`category_id`
		]], function(rows)
			local map = {categories = {}, modules = {}}
			for _,row in ipairs(rows) do
				map.categories[row.category] = map.categories[row.category] or tonumber(row.category_id)

				map.modules[row.category] = map.modules[row.category] or {}
				map.modules[row.category][row.module] = map.modules[row.category][row.module] or tonumber(row.module_id)
			end
			GAS.Database:BeginTransaction()
			for category, modules in pairs(Modules) do
				local category_id = map.categories[category]
				if (category_id == nil) then
					category_id, max_category_id = max_category_id + 1, max_category_id + 1

					GAS.Database:Prepare("INSERT INTO `" .. GAS.Database.ServerTablePrefix .. "gas_logging_module_categories` (`id`, `name`) VALUES(?,?)", {category_id, category})

					map.modules[category] = {}
					map.categories[category] = category_id
				end
				for module_name, module_tbl in pairs(modules) do
					local module_id = map.modules[category][module_name]
					if (module_id == nil) then
						module_id, max_module_id = max_module_id + 1, max_module_id + 1
						
						GAS.Database:Prepare("INSERT INTO `" .. GAS.Database.ServerTablePrefix .. "gas_logging_modules` (`category_id`, `id`, `name`) VALUES(?,?,?)", {category_id, module_id, module_name})
					end
					Modules[category][module_name].ModuleID = module_id
					GAS.Logging.IndexedModules[module_id] = Modules[category][module_name]
				end
			end
			for _,row in ipairs(rows) do
				if (GAS.Logging.IndexedModules[tonumber(row.module_id)] == nil) then
					GAS.Logging.IndexedModules[tonumber(row.module_id)] = {
						Category = row.category,
						Name = row.module,
						ModuleID = tonumber(row.module_id),
						Offline = true,
					}
				end
			end
			GAS.Database:CommitTransaction()
			if (AfterRetrieveIDs ~= true) then
				for _,v in ipairs(AfterRetrieveIDs) do
					v()
				end
				AfterRetrieveIDs = true
			end
			if (callback) then
				callback()
			end
		end)
	end)
end
function GAS.Logging.Modules:AfterRetrieveIDs(func)
	if (AfterRetrieveIDs == true) then
		func()
	else
		table.insert(AfterRetrieveIDs, func)
	end
end