if (SERVER) then
	include("sv_backwards_compatibility.lua")

	GAS_Logging_ReadyCallbacks = {}
	function GAS_Logging_Init(callback)
		if (GAS and GAS.Logging and GAS.Logging.Loaded) then
			callback()
		else
			table.insert(GAS_Logging_ReadyCallbacks, callback)
		end
	end
	
	AddCSLuaFile("cl_menu.lua")
	AddCSLuaFile("cl_livelogs.lua")
	AddCSLuaFile("sh_log_formatting.lua")
	AddCSLuaFile("sh_scenes.lua")
end

GAS:hook("gmodadminsuite:LoadModule:logging", "LoadModule:jobwhitelist:logging", function(module_info)
	if (GAS.Logging and IsValid(GAS.Logging.Menu)) then
		GAS.Logging.Menu:Close()
	end

	GAS.Logging = {}

	GAS.Logging.FORMAT_PLAYER    = 0
	GAS.Logging.FORMAT_WEAPON    = 1
	GAS.Logging.FORMAT_ENTITY    = 2
	GAS.Logging.FORMAT_PROP      = 3
	GAS.Logging.FORMAT_RAGDOLL   = 4
	GAS.Logging.FORMAT_CURRENCY  = 5
	GAS.Logging.FORMAT_COUNTRY   = 6
	GAS.Logging.FORMAT_AMMO      = 7
	GAS.Logging.FORMAT_TEAM      = 8
	GAS.Logging.FORMAT_USERGROUP = 9
	GAS.Logging.FORMAT_STRING    = 10
	GAS.Logging.FORMAT_HIGHLIGHT = 11
	GAS.Logging.FORMAT_ROLE      = 12
	GAS.Logging.FORMAT_VEHICLE   = 13
	GAS.Logging.FORMAT_DAMAGE    = 14
	
	function GAS.Logging:ClassTypeNames(L) return {
		[GAS.Logging.FORMAT_PLAYER]    = L"class_type_player",
		[GAS.Logging.FORMAT_WEAPON]    = L"class_type_weapon",
		[GAS.Logging.FORMAT_ENTITY]    = L"class_type_entity",
		[GAS.Logging.FORMAT_PROP]      = L"class_type_prop",
		[GAS.Logging.FORMAT_RAGDOLL]   = L"class_type_ragdoll",
		[GAS.Logging.FORMAT_COUNTRY]   = L"class_type_country",
		[GAS.Logging.FORMAT_AMMO]      = L"class_type_ammo",
		[GAS.Logging.FORMAT_TEAM]      = L"class_type_team",
		[GAS.Logging.FORMAT_USERGROUP] = L"class_type_usergroup",
		[GAS.Logging.FORMAT_ROLE]      = L"class_type_role",
		[GAS.Logging.FORMAT_VEHICLE]   = L"class_type_vehicle",
		[GAS.Logging.FORMAT_DAMAGE]    = L"class_type_damage",
	} end

	GAS.Logging.PvP_LOG_TYPE_CHAT                = 0
	GAS.Logging.PvP_LOG_TYPE_CHAT_TEAM           = 1
	GAS.Logging.PvP_LOG_TYPE_WEAPON_PICKUP       = 2
	GAS.Logging.PvP_LOG_TYPE_WEAPON_DROPPED      = 3
	GAS.Logging.PvP_LOG_TYPE_ITEM_PICKUP         = 4
	GAS.Logging.PvP_LOG_TYPE_SPAWNMENU           = 5
	GAS.Logging.PvP_LOG_TYPE_DARKRP_PURCHASE     = 6
	GAS.Logging.PvP_LOG_TYPE_DISCONNECT          = 7
	GAS.Logging.PvP_LOG_TYPE_WEAPON_SWITCHED     = 8
	GAS.Logging.PvP_LOG_TYPE_TEAM_SWITCH         = 9
	GAS.Logging.PVP_LOG_TYPE_SILENT_DEATH        = 10
	GAS.Logging.PvP_LOG_TYPE_DEATH_WORLD         = 11
	GAS.Logging.PvP_LOG_TYPE_DEATH_PLAYER_WEP    = 12
	GAS.Logging.PvP_LOG_TYPE_DEATH_PLAYER        = 13
	GAS.Logging.PvP_LOG_TYPE_DEATH_ENT           = 14
	GAS.Logging.PvP_LOG_TYPE_DEATH               = 15
	GAS.Logging.PvP_LOG_TYPE_DEATH_PROPKILL_SELF = 16
	GAS.Logging.PvP_LOG_TYPE_DEATH_PROPKILL      = 17

	GAS.Logging.PvP_FLAG_FRIENDLYFIRE     = 0
	GAS.Logging.PvP_FLAG_LAWENFORCEMENT   = 1
	GAS.Logging.PvP_FLAG_LINKED           = 2
	GAS.Logging.PvP_FLAG_ADMIN            = 3
	GAS.Logging.PvP_FLAG_SUPERADMIN       = 4
	GAS.Logging.PvP_FLAG_VEHICLE          = 5
	GAS.Logging.PvP_FLAG_PROPS            = 6
	GAS.Logging.PvP_FLAG_DISCONNECT       = 7
	GAS.Logging.PvP_FLAG_WORLD            = 9
	GAS.Logging.PvP_FLAG_ONGOING          = 10
	GAS.Logging.PvP_FLAG_FINISHED         = 11
	GAS.Logging.PvP_FLAG_TEAM_SWITCHED    = 12
	GAS.Logging.PvP_FLAG_INSTIGATOR_DEATH = 13
	GAS.Logging.PvP_FLAG_VICTIM_DEATH     = 14

	GAS.Logging.PvP_EVENT_ID              = 1
	GAS.Logging.PvP_PRECISE_CREATION_TIME = 2
	GAS.Logging.PvP_LAST_UPDATED          = 3
	GAS.Logging.PvP_INSTIGATOR            = 4
	GAS.Logging.PvP_INSTIGATOR_WEPS       = 5
	GAS.Logging.PvP_INSTIGATOR_DMG_TKN    = 6
	GAS.Logging.PvP_INSTIGATOR_DMG_GVN    = 7
	GAS.Logging.PvP_INSTIGATOR_TEAM       = 8
	GAS.Logging.PvP_VICTIM                = 9
	GAS.Logging.PvP_VICTIM_WEPS           = 10
	GAS.Logging.PvP_VICTIM_DMG_TKN        = 11
	GAS.Logging.PvP_VICTIM_DMG_GVN        = 12
	GAS.Logging.PvP_VICTIM_TEAM           = 13
	GAS.Logging.PvP_TOTAL_DMG             = 14
	GAS.Logging.PvP_LINKED_EVENTS         = 15
	GAS.Logging.PvP_EVENT_LOGS            = 16
	GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY = 17
	GAS.Logging.PvP_WEP_VEHICLES          = 18
	GAS.Logging.PvP_FLAGS                 = 19
	GAS.Logging.PvP_ONGOING               = 20
	GAS.Logging.PvP_INSTIGATOR_NICK       = 21
	GAS.Logging.PvP_VICTIM_NICK           = 22
	GAS.Logging.PvP_COMBAT_SCENE          = 23
	GAS.Logging.PvP_CREATION_TIMESTAMP    = 24

	GAS.Logging.PvP_SCENE_MODEL              = 1
	GAS.Logging.PvP_SCENE_POS                = 2
	GAS.Logging.PvP_SCENE_ANG                = 3
	GAS.Logging.PvP_SCENE_PLY_COLOR          = 4
	GAS.Logging.PvP_SCENE_SHOOT_POS          = 5
	GAS.Logging.PvP_SCENE_EYE_POS            = 6
	GAS.Logging.PvP_SCENE_HEAD_ANG           = 7
	GAS.Logging.PvP_SCENE_WEAPON_MDL         = 8
	GAS.Logging.PvP_SCENE_WEAPON_CLASS       = 9
	GAS.Logging.PvP_SCENE_SEQUENCE           = 10
	GAS.Logging.PvP_SCENE_VEHICLE_MODEL      = 11
	GAS.Logging.PvP_SCENE_VEHICLE_POS        = 12
	GAS.Logging.PvP_SCENE_VEHICLE_ANG        = 13
	GAS.Logging.PvP_SCENE_VEHICLE_ATTACHMENT = 14

	GAS.Logging.PvP_DAMAGE_TYPES = {
		DMG_GENERIC,
		DMG_CRUSH,
		DMG_BULLET,
		DMG_SLASH,
		DMG_BURN,
		DMG_VEHICLE,
		DMG_FALL,
		DMG_BLAST,
		DMG_CLUB,
		DMG_SHOCK,
		DMG_SONIC,
		DMG_ENERGYBEAM,
		DMG_PREVENT_PHYSICS_FORCE,
		DMG_NEVERGIB,
		DMG_ALWAYSGIB,
		DMG_DROWN,
		DMG_PARALYZE,
		DMG_NERVEGAS,
		DMG_POISON,
		DMG_RADIATION,
		DMG_DROWNRECOVER,
		DMG_ACID,
		DMG_SLOWBURN,
		DMG_REMOVENORAGDOLL,
		DMG_PHYSGUN,
		DMG_PLASMA,
		DMG_AIRBOAT,
		DMG_DISSOLVE,
		DMG_BLAST_SURFACE,
		DMG_DIRECT,
		DMG_BUCKSHOT,
		DMG_SNIPER,
		DMG_MISSILEDEFENSE
	}

	GAS.Logging.ThirdPartyAddons = {
		["ULX Admin Mod"] = {installed = function()
			return ulx ~= nil
		end, website = "https://ulyssesmod.net"},

		["ServerGuard Admin Mod"] = {installed = function()
			return SERVERGUARD ~= nil
		end, gmodstore = "1847"},

		["AWarn"] = {installed = function()
			return AWarn ~= nil
		end, gmodstore = "629"},

		["Cuffs - Handcuffs and Restraints"] = {installed = function()
			return ConVarExists("cuffs_allowbreakout")
		end, gmodstore = "910"},

		["Medic / Armor NPC"] = {installed = function()
			return MavNPCModel ~= nil
		end, workshop = "912372779"},

		["PAC3"] = {installed = function()
			return pac ~= nil
		end, workshop = "104691717"},

		["Pointshop Trading System"] = {installed = function()
			return TRADING ~= nil
		end, gmodstore = "1672"},

		["Simple Party System"] = {installed = function()
			return party ~= nil
		end, gmodstore = "2109"},

		["SprayMesh"] = {installed = function()
			return SprayMesh ~= nil
		end, workshop = "394091909"},

		["Star Wars Vehicles"] = {installed = function()
			local SWVehicles = list.Get("SWVehicles")
			return SWVehicles and table.Count(SWVehicles) > 0
		end, workshop = "1311553933"},

		["WAC Aircraft"] = {installed = function()
			return wac ~= nil
		end, workshop = "104990330"},

		["Wyozi Cinema Kit"] = {installed = function()
			return wck ~= nil
		end, gmodstore = "1471"},

		["Wyozi DJ Kit"] = {installed = function()
			return wdj ~= nil
		end, gmodstore = "1534"},

		["bWhitelist"] = {installed = function()
			return GAS.JobWhitelist ~= nil
		end, gmodadminsuite = "jobwhitelist", gmodstore = "6017"},

		["bKeycardScanner"] = {installed = function()
			return bKeycardScanner ~= nil
		end, gmodstore = "3192"},
	}

	GAS.Logging.RolesEnabled = false
	function GAS.Logging:EnableRoles()
		GAS.Logging.RolesEnabled = true
	end

	if (SERVER) then
		include("gmodadminsuite/modules/logging/sv_logging.lua")
		include("gmodadminsuite/modules/logging/sv_logscanning.lua")

		GAS.XEON:PostLoad(function()
			XEON:Init("6016", "[GAS] Billy's Logs", "2.4", "gmodadminsuite/modules/logging/sv_drm.lua", include("gmodadminsuite/modules/logging/license.lua"))
		end)
	else
		include("gmodadminsuite/modules/logging/cl_menu.lua")
		include("gmodadminsuite/modules/logging/cl_livelogs.lua")
	end

	include("gmodadminsuite/modules/logging/sh_log_formatting.lua")
	include("gmodadminsuite/modules/logging/sh_scenes.lua")

	if (CLIENT) then
		local _,ds = file.Find("gmodadminsuite/modules/logging/modules/gamemodes/*", "LUA")
		for _,d in ipairs(ds) do
			if (file.Exists("gmodadminsuite/modules/logging/modules/gamemodes/" .. d .. "/_roles.lua", "LUA")) then
				include("gmodadminsuite/modules/logging/modules/gamemodes/" .. d .. "/_roles.lua")
			end
		end

		GAS:netReceive("logging:NetworkConfig", function()
			GAS.Logging.Config = {}
			GAS.Logging.Config.OverrideMoneyFormat = net.ReadBool()
			GAS.Logging.Config.MoneyFormat = net.ReadString()
			GAS.Logging.Config.Player_RecordTeam = net.ReadBool()
			GAS.Logging.Config.Player_RecordUsergroup = net.ReadBool()
			GAS.Logging.Config.Player_RecordHealth = net.ReadBool()
			GAS.Logging.Config.Player_RecordArmor = net.ReadBool()
			GAS.Logging.Config.Player_RecordWeapon = net.ReadBool()
			GAS.Logging.Config.Player_RecordRole = net.ReadBool()
			GAS.Logging.Config.DeepStorageEnabled = net.ReadBool()

			GAS.Logging.Config.Player_RecordWeapon_DoNotRecord = {}
			for i=1,net.ReadUInt(6) do
				GAS.Logging.Config.Player_RecordWeapon_DoNotRecord[net.ReadString()] = true
			end
		end)

		GAS:InitPostEntity(function()
			GAS:netStart("logging:NetworkConfig")
			net.SendToServer()
		end)
	end
end)