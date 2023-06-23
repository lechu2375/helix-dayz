if (not GAS.Logging.Modules:IsAddonInstalled("bWhitelist")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "bWhitelist"
MODULE.Name     = "Whitelist Additions"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("bWhitelist:SteamIDAddedToWhitelist", "AddedToWhitelist", function(account_id, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_added_to_whitelist_by", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_added_to_whitelist", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:UsergroupAddedToWhitelist", "AddedToWhitelistUsergroup", function(usergroup, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_added_to_whitelist_by_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_added_to_whitelist_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:LuaFunctionAddedToWhitelist", "AddedToWhitelistLuaFunction", function(lua_func_name, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_added_to_whitelist_by_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_added_to_whitelist_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "bWhitelist"
MODULE.Name     = "Whitelist Removals"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("bWhitelist:SteamIDRemovedFromWhitelist", "RemovedFromWhitelist", function(account_id, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_removed_from_whitelist_by", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_removed_from_whitelist", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:UsergroupRemovedFromWhitelist", "RemovedFromWhitelistUsergroup", function(usergroup, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_removed_from_whitelist_by_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_removed_from_whitelist_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:LuaFunctionRemovedFromWhitelist", "RemovedFromWhitelistLuaFunction", function(lua_func_name, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_removed_from_whitelist_by_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_removed_from_whitelist_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "bWhitelist"
MODULE.Name     = "Whitelist Enabled/Disabled"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("bWhitelist:WhitelistEnabled", "WhitelistEnabled", function(job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_whitelist_enabled_by", GAS.Logging:FormatPlayer(by_account_id), GAS.Logging:FormatTeam(job_index))
		else
			MODULE:LogPhrase("bwhitelist_whitelist_enabled", GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:WhitelistDisabled", "WhitelistDisabled", function(job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_whitelist_disabled_by", GAS.Logging:FormatPlayer(by_account_id), GAS.Logging:FormatTeam(job_index))
		else
			MODULE:LogPhrase("bwhitelist_whitelist_disabled", GAS.Logging:FormatTeam(job_index))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "bWhitelist"
MODULE.Name     = "Blacklist Additions"
MODULE.Colour   = Color(255,0,50)

MODULE:Setup(function()
	MODULE:Hook("bWhitelist:SteamIDAddedToBlacklist", "AddedToBlacklist", function(account_id, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_added_to_blacklist_by", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_added_to_blacklist", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:UsergroupAddedToBlacklist", "AddedToBlacklistUsergroup", function(usergroup, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_added_to_blacklist_by_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_added_to_blacklist_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:LuaFunctionAddedToBlacklist", "AddedToBlacklistLuaFunction", function(lua_func_name, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_added_to_blacklist_by_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_added_to_blacklist_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "bWhitelist"
MODULE.Name     = "Blacklist Removals"
MODULE.Colour   = Color(255,0,50)

MODULE:Setup(function()
	MODULE:Hook("bWhitelist:SteamIDRemovedFromBlacklist", "RemovedFromBlacklist", function(account_id, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_removed_from_blacklist_by", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_removed_from_blacklist", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:UsergroupRemovedFromBlacklist", "RemovedFromBlacklistUsergroup", function(usergroup, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_removed_from_blacklist_by_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_removed_from_blacklist_usergroup", GAS.Logging:FormatUsergroup(usergroup), GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:LuaFunctionRemovedFromBlacklist", "RemovedFromBlacklistLuaFunction", function(lua_func_name, job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_removed_from_blacklist_by_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index), GAS.Logging:FormatPlayer(by_account_id))
		else
			MODULE:LogPhrase("bwhitelist_removed_from_blacklist_luafunc", GAS.Logging:Highlight(lua_func_name), GAS.Logging:FormatTeam(job_index))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "bWhitelist"
MODULE.Name     = "Blacklist Enabled/Disabled"
MODULE.Colour   = Color(255,0,50)

MODULE:Setup(function()
	MODULE:Hook("bWhitelist:BlacklistEnabled", "BlacklistEnabled", function(job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_blacklist_enabled_by", GAS.Logging:FormatPlayer(by_account_id), GAS.Logging:FormatTeam(job_index))
		else
			MODULE:LogPhrase("bwhitelist_blacklist_enabled", GAS.Logging:FormatTeam(job_index))
		end
	end)

	MODULE:Hook("bWhitelist:BlacklistDisabled", "BlacklistDisabled", function(job_index, by_account_id)
		if (by_account_id ~= nil) then
			MODULE:LogPhrase("bwhitelist_blacklist_disabled_by", GAS.Logging:FormatPlayer(by_account_id), GAS.Logging:FormatTeam(job_index))
		else
			MODULE:LogPhrase("bwhitelist_blacklist_disabled", GAS.Logging:FormatTeam(job_index))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)