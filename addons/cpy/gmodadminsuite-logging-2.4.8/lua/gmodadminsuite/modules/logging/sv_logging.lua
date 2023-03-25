local is_windows = system.IsWindows()
local is_linux = system.IsLinux()
local arch = jit.arch
local reqwest_module_filename = "gmsv_reqwest_" .. ((is_windows and (arch == "x64" and "win64" or "win32")) or (is_linux and (arch == "x64" and "linux64" or "linux"))) .. ".dll"
local chttp_module_filename = "gmsv_chttp_" .. ((is_windows and (arch == "x64" and "win64" or "win32")) or (is_linux and (arch == "x64" and "linux64" or "linux"))) .. ".dll"

local DISCORD_HTTP do (function()
	if ((is_windows or is_linux) and not reqwest and file.Exists("bin/" .. reqwest_module_filename, "LUA")) then
		local succ, err = pcall(require, "reqwest")
		if (not succ) then
			MsgC("\n")
			GAS:print("[bLogs] Could not load gmsv_reqwest!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			GAS:print("[bLogs] \"" .. tostring(err) .. "\"", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			GAS:print("[bLogs] You may want to report this here: https://github.com/WilliamVenner/gmsv_reqwest/issues", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			MsgC("\n")
		end
	end

	if reqwest then
		GAS:print("[bLogs] Using gmsv_reqwest for Discord HTTP requests")
		DISCORD_HTTP = reqwest
		return
	end

	if ((is_windows or is_linux) and not CHTTP and file.Exists("bin/" .. chttp_module_filename, "LUA")) then
		local succ, err = pcall(require, "chttp")
		if (not succ) then
			MsgC("\n")
			GAS:print("[bLogs] Could not load gmsv_chttp!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)

			if (err and err:lower():find("couldn't load module library!")) then
				GAS:print("[bLogs] There are some missing libraries from your server's operating system.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
				GAS:print("[bLogs] This is not the fault of bLogs!!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			else
				GAS:print("[bLogs] \"" .. tostring(err) .. "\"", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			end

			GAS:print("[bLogs] You may want to report this here: https://github.com/timschumi/gmod-chttp/issues or use the recommended alternative module: https://github.com/WilliamVenner/gmsv_reqwest", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
			MsgC("\n")
		end
	end

	if CHTTP then
		GAS:print("[bLogs] Using gmsv_chttp for Discord HTTP requests")
		DISCORD_HTTP = CHTTP
		return
	end
end)() end

if not DISCORD_HTTP then
	MsgC("\n")
	GAS:print("[bLogs] Could not find/load garrysmod/lua/bin/" .. reqwest_module_filename .. " or garrysmod/lua/bin/" .. chttp_module_filename .. " on your server! Discord webhooks cannot be dispatched.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
	GAS:print("[bLogs] Please read this article: https://www.gmodstore.com/help/addon/6016/discord/topics/curl-http", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
	GAS:print("[bLogs] If you do not need Discord webhooks, you can safely ignore this error.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
	MsgC("\n")
end

GAS.Logging.DefaultConfig = {
	ServerNickname = "Default",
	Modules = {},

	Permissions = {},

	DiscordWebhooks = {},

	ForcedGamemode_DarkRP = 0,
	ForcedGamemode_TTT = 0,
	ForcedGamemode_Murder = 0,
	ForcedGamemode_Cinema = 0,
	ForcedGamemode_Sandbox = 0,

	OverrideMoneyFormat = false,
	MoneyFormat = "£%s",

	Player_RecordTeam = true,
	Player_RecordUsergroup = true,
	Player_RecordHealth = false,
	Player_RecordArmor = false,
	Player_RecordWeapon = false,
	Player_RecordRole = true,

	Player_RecordWeapon_DoNotRecord = {
		weapon_physcannon = true,
		weapon_physgun = true,
		gmod_tool = true,
		keys = true,
		pocket = true,
		none = true,
		gas_weapon_hands = true,
	},

	NonPvPWeapons = {
		weapon_physcannon = true,
		weapon_physgun = true,
		gmod_tool = true,
		keys = true,
		pocket = true,
		none = true,
		gas_weapon_hands = true,
	},
	TimeBetweenPvPEvents = 20,

	LogCommitInterval = 15,

	LiveLogsEnabled = false,
	LiveLogsIn10Seconds = 75,
	NotifyLiveLogsAntispam = false,

	ServerGuard_Blacklist = {},

	InstalledAddons = {},

	DeepStorageEnabled = true,
	DeepStorageTooOld = 2,
	DeepStorageCommitPeriod = 60,
	DeepStorageCommitChunkSize = 50,
	DeepStorageCommitOnShutdown = true,
}
GAS.Logging.Config = GAS:GetConfig("logging", GAS.Logging.DefaultConfig)

GAS:netInit("logging:NetworkConfig")
function GAS.Logging:NetworkConfig(ply)
	local Player_RecordWeapon_DoNotRecord = table.GetKeys(GAS.Logging.Config.Player_RecordWeapon_DoNotRecord)
	GAS:netStart("logging:NetworkConfig")
		net.WriteBool(GAS.Logging.Config.OverrideMoneyFormat)
		net.WriteString(GAS.Logging.Config.MoneyFormat)
		net.WriteBool(GAS.Logging.Config.Player_RecordTeam)
		net.WriteBool(GAS.Logging.Config.Player_RecordUsergroup)
		net.WriteBool(GAS.Logging.Config.Player_RecordHealth)
		net.WriteBool(GAS.Logging.Config.Player_RecordArmor)
		net.WriteBool(GAS.Logging.Config.Player_RecordWeapon)
		net.WriteBool(GAS.Logging.Config.Player_RecordRole)
		net.WriteBool(GAS.Logging.Config.DeepStorageEnabled == nil or GAS.Logging.Config.DeepStorageEnabled == true)

		net.WriteUInt(#Player_RecordWeapon_DoNotRecord, 6)
		for _,k in ipairs(Player_RecordWeapon_DoNotRecord) do
			net.WriteString(k)
		end
	if (ply == true) then
		net.Broadcast()
	else
		net.Send(ply)
	end
end

GAS:netReceive("logging:NetworkConfig", function(ply)
	GAS.Logging:NetworkConfig(ply)
end)

--# Command #--

GAS:RegisterCommand("!blogs", "logging")

--# Superior & Inferior Hooks #--

function GAS.Logging:SuperiorHook(hook_name, identifier, func)
	return GAS.Hooking:SuperiorHook(hook_name, "logging:" .. identifier, func)
end
function GAS.Logging:InferiorHook(hook_name, identifier, func)
	return GAS.Hooking:InferiorHook(hook_name, "logging:" .. identifier, func)
end
function GAS.Logging:FeedbackHook(hook_name, identifier, func)
	return GAS.Hooking:FeedbackHook(hook_name, "logging:" .. identifier, func)
end
function GAS.Logging:ObserverHook(hook_name, identifier, func)
	return GAS.Hooking:ObserverHook(hook_name, "logging:" .. identifier, func)
end

--# Entity Ownership #--

function GAS.Logging:GetEntityCreator(ent)
	if (IsValid(ent:GetCreator())) then
		return ent:GetCreator()
	elseif (IsValid(ent.GAS_EntityCreator)) then
		return ent.GAS_EntityCreator
	elseif (IsValid(ent.FPPOwner)) then
		return ent.FPPOwner
	elseif (ent.IsDoor and ent:IsDoor() == true and IsValid(ent:getDoorOwner())) then
		return ent:getDoorOwner()
	else
		return nil
	end
end

local function RecordCreator(ply,ent)
	ent.GAS_EntityCreator = ply
end
local function RecordCreator_2(ply,_,ent)
	ent.GAS_EntityCreator = ply
end
GAS:hook("PlayerSpawnedProp","logging:record_creator_prop",RecordCreator_2)
GAS:hook("PlayerSpawnedEffect","logging:record_creator_effect",RecordCreator_2)
GAS:hook("PlayerSpawnedRagdoll","logging:record_creator_ragdoll",RecordCreator_2)
GAS:hook("PlayerSpawnedNPC","logging:record_creator_npc",RecordCreator)
GAS:hook("PlayerSpawnedSENT","logging:record_creator_sent",RecordCreator)
GAS:hook("PlayerSpawnedSWEP","logging:record_creator_swep",RecordCreator)
GAS:hook("PlayerSpawnedVehicle","logging:record_creator_vehicle",RecordCreator)

--# Modules #--

include("gmodadminsuite/modules/logging/sv_modules.lua")

--# Gamemode Modules #--

GAS:GMInitialize(function()
	GAS.Logging.GamemodeModulesEnabled = {
		DarkRP  = (GAS.Logging.Config.ForcedGamemode_DarkRP == 0 and DarkRP ~= nil) or GAS.Logging.Config.ForcedGamemode_DarkRP == 1,
		TTT     = (GAS.Logging.Config.ForcedGamemode_TTT == 0 and ConVarExists("ttt_spawn_wave_interval")) or GAS.Logging.Config.ForcedGamemode_TTT == 1,
		Murder  = (GAS.Logging.Config.ForcedGamemode_Murder == 0 and ConVarExists("mu_version")) or GAS.Logging.Config.ForcedGamemode_Murder == 1,
		Cinema  = (GAS.Logging.Config.ForcedGamemode_Cinema == 0 and ConVarExists("cinema_url")) or GAS.Logging.Config.ForcedGamemode_Cinema == 1,
		Sandbox = (GAS.Logging.Config.ForcedGamemode_Sandbox == 0 and (GM or GAMEMODE).IsSandboxDerived) or GAS.Logging.Config.ForcedGamemode_Sandbox == 1
	}

	GAS.Logging.Modules:Load()
end)

--# Class IDs #--

GAS.Logging.ClassIDs = {}
GAS.Logging.ClassIDs.Registry = {}
GAS.Logging.ClassIDs.IDRegistry = {}
GAS.Logging.ClassIDs.AmbigiousRegistry = {}
GAS.Logging.ClassIDs.NewClassID = 0

function GAS.Logging.ClassIDs:GetID(class_type, class_name, suppress_creation)
	class_name = utf8.force(tostring(class_name))
	if (GAS.Logging.ClassIDs.Registry[class_type .. class_name]) then
		return GAS.Logging.ClassIDs.Registry[class_type .. class_name]
	elseif (suppress_creation ~= true) then
		GAS.Logging.ClassIDs.NewClassID = GAS.Logging.ClassIDs.NewClassID + 1

		GAS.Logging.ClassIDs.Registry[class_type .. class_name] = GAS.Logging.ClassIDs.NewClassID
		GAS.Logging.ClassIDs.IDRegistry[GAS.Logging.ClassIDs.NewClassID] = {class_type, class_name}
		
		if (GAS.Logging.ClassIDs.AmbigiousRegistry[class_name] == nil) then
			GAS.Logging.ClassIDs.AmbigiousRegistry[class_name] = class_type
		elseif (istable(GAS.Logging.ClassIDs.AmbigiousRegistry[class_name])) then
			GAS.Logging.ClassIDs.AmbigiousRegistry[class_name][class_type] = true
		elseif (GAS.Logging.ClassIDs.AmbigiousRegistry[class_name] ~= class_type) then
			local stored_class_type = GAS.Logging.ClassIDs.AmbigiousRegistry[class_name]
			GAS.Logging.ClassIDs.AmbigiousRegistry[class_name] = {}
			GAS.Logging.ClassIDs.AmbigiousRegistry[class_name][stored_class_type] = true
			GAS.Logging.ClassIDs.AmbigiousRegistry[class_name][class_type] = true
		end

		GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_classes") .. " (`id`, `class_type`, `class_name`) VALUES(?,?,?)", {GAS.Logging.ClassIDs.NewClassID, class_type, class_name})

		return GAS.Logging.ClassIDs.NewClassID
	end
end

function GAS.Logging.ClassIDs:FromID(id)
	id = tonumber(id)
	if (GAS.Logging.ClassIDs.IDRegistry[id]) then
		return unpack(GAS.Logging.ClassIDs.IDRegistry[id])
	else
		return nil
	end
end

function GAS.Logging.ClassIDs:Init(callback)
	local max_id = 0
	GAS.Database:Query("SELECT * FROM " .. GAS.Database:ServerTable("gas_logging_classes"), function(rows)
		if (not rows or #rows == 0) then
			GAS:print("[bLogs] 0 classes registered")
			if (callback) then callback() end
			return
		end
		for _,row in ipairs(rows) do
			if (tonumber(row.id) > max_id) then
				max_id = tonumber(row.id)
			end
			if (row.class_type == nil or row.class_name == nil) then continue end
			
			GAS.Logging.ClassIDs.Registry[row.class_type .. row.class_name] = tonumber(row.id)
			GAS.Logging.ClassIDs.IDRegistry[tonumber(row.id)] = {row.class_type, row.class_name}
			
			if (GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name] == nil) then
				GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name] = row.class_type
			elseif (istable(GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name])) then
				GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name][row.class_type] = true
			elseif (GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name] ~= row.class_type) then
				local stored_class_type = GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name]
				GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name] = {}
				GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name][stored_class_type] = true
				GAS.Logging.ClassIDs.AmbigiousRegistry[row.class_name][row.class_type] = true
			end
		end
		GAS.Logging.ClassIDs.NewClassID = max_id
		GAS:print("[bLogs] " .. #rows .. " classes registered")
		if (callback) then callback() end
	end)
end

--# Runtime Log Data #--

GAS.Logging.Logs = {}
GAS.Logging.ModuleLogs = {}
GAS.Logging.LogCounts = {}
GAS.Logging.CurrentLog = {{}}

--# Formatting #--

GAS.Logging.FormatPlayer_64 = {}
GAS.Logging.FormatPlayer_32 = {}
GAS.Logging.FormatPlayer_3 = {}
GAS:hook("PlayerInitialSpawn", "logging:IndexPlayerIDs", function(ply)
	GAS.Logging.FormatPlayer_64[ply:SteamID64()] = ply
	GAS.Logging.FormatPlayer_32[ply:SteamID()]   = ply
	GAS.Logging.FormatPlayer_3[ply:AccountID()]  = ply
end)
GAS:hook("PlayerDisconnect", "logging:UnIndexPlayerIDs", function(ply)
	GAS.Logging.FormatPlayer_64[ply:SteamID64()] = nil
	GAS.Logging.FormatPlayer_32[ply:SteamID()]   = nil
	GAS.Logging.FormatPlayer_3[ply:AccountID()]  = nil
end)
for _,ply in ipairs(player.GetHumans()) do
	GAS.Logging.FormatPlayer_64[ply:SteamID64()] = ply
	GAS.Logging.FormatPlayer_32[ply:SteamID()]   = ply
	GAS.Logging.FormatPlayer_3[ply:AccountID()]  = ply
end

function GAS.Logging:PersistentPlayerData(account_id, ply)
	if (
		not GAS.Logging.Config.Player_RecordTeam and
		not GAS.Logging.Config.Player_RecordUsergroup and
		not GAS.Logging.Config.Player_RecordHealth and
		not GAS.Logging.Config.Player_RecordArmor and
		not GAS.Logging.Config.Player_RecordWeapon and
		not GAS.Logging.Config.Player_RecordRole
	) then
		return
	end
	if (IsValid(ply)) then
		local data = {}
		data[1] = ply:Nick()
		if (GAS.Logging.Config.Player_RecordTeam) then
			data[2] = ply:Team()
		end
		if (GAS.Logging.Config.Player_RecordUsergroup) then
			data[3] = ply:GetUserGroup()
		end
		if (GAS.Logging.Config.Player_RecordHealth) then
			data[4] = ply:Health()
		end
		if (GAS.Logging.Config.Player_RecordArmor) then
			data[5] = ply:Armor()
		end
		if (GAS.Logging.Config.Player_RecordWeapon) then
			local wep = ply:GetActiveWeapon()
			if (IsValid(wep)) then
				data[6] = wep:GetClass()
			end
		end
		if (GAS.Logging.Config.Player_RecordRole) then
			data[7] = hook.Run("GAS:logging:GetRole", ply)
		end
		return data
	elseif (account_id) then
		account_id = tonumber(account_id)
		local data = {}
		GAS.OfflinePlayerData:AccountID(account_id, function(success, offline_data)
			if (success) then
				data[1] = offline_data.nick
			end
		end)
		return data
	end
end
function GAS.Logging:FormatPlayer(ply)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	if (ply == "CONSOLE") then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, "CONSOLE"}
	elseif (type(ply) == "string") then
		if (ply:find("^7656119%d+$")) then
			local account_id = GAS:SteamID64ToAccountID(ply)
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, account_id, GAS.Logging:PersistentPlayerData(account_id, GAS.Logging.FormatPlayer_64[ply])}
			if (IsValid(GAS.Logging.FormatPlayer_64[ply])) then
				GAS.Logging.LogScanning.CurrentLogEntities[GAS.Logging.FormatPlayer_64[ply]] = true
			end
		elseif (ply:find("^STEAM_%d:%d:%d+$")) then
			local account_id = GAS:SteamIDToAccountID(ply)
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, account_id, GAS.Logging:PersistentPlayerData(account_id, GAS.Logging.FormatPlayer_32[ply])}
			if (IsValid(GAS.Logging.FormatPlayer_32[ply])) then
				GAS.Logging.LogScanning.CurrentLogEntities[GAS.Logging.FormatPlayer_32[ply]] = true
			end
		elseif (ply == "BOT" or (tonumber(ply) and tonumber(ply) >= 90071996842377216)) then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, "BOT"}
		elseif (tonumber(ply)) then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, ply, GAS.Logging:PersistentPlayerData(ply, GAS.Logging.FormatPlayer_3[ply])}
			if (IsValid(GAS.Logging.FormatPlayer_3[ply])) then
				GAS.Logging.LogScanning.CurrentLogEntities[GAS.Logging.FormatPlayer_3[ply]] = true
			end
		else
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, "NULL"}
		end
	elseif (type(ply) == "number") then
		if (ply >= 90071996842377216) then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, "BOT"}
		else
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, ply, GAS.Logging:PersistentPlayerData(ply, GAS.Logging.FormatPlayer_3[ply])}
			if (IsValid(GAS.Logging.FormatPlayer_3[ply])) then
				GAS.Logging.LogScanning.CurrentLogEntities[GAS.Logging.FormatPlayer_3[ply]] = true
			end
		end
	elseif (IsValid(ply)) then
		if (ply:IsNPC() or not ply:IsPlayer()) then
			return GAS.Logging:FormatEntity(ply)
		elseif (ply:IsBot()) then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, "BOT"}
		else
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, ply:AccountID(), GAS.Logging:PersistentPlayerData(ply:AccountID(), ply)}
			GAS.Logging.LogScanning.CurrentLogEntities[ply] = true
		end
	else
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PLAYER, "NULL"}
	end

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatEntity(ent)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	if (type(ent) == "string") then
		if (ent:sub(1,7) == "weapon_") then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_WEAPON, ent}
			return "{" .. rIndex .. "}"
		else
			if (game.GetAmmoID(ent) ~= -1) then
				GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_AMMO, ent}
			else
				GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_ENTITY, ent}
			end
			return "{" .. rIndex .. "}"
		end
	end
	if (ent:IsWorld()) then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_ENTITY, "WORLD"}
	elseif (not IsValid(ent)) then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_ENTITY, "NULL"}
	elseif (ent:GetClass() == "prop_physics") then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PROP, ent:GetModel()}
	elseif (ent:GetClass() == "prop_ragdoll") then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_RAGDOLL, ent:GetModel()}
	elseif (ent:IsVehicle()) then
		local driver = ent:GetDriver()
		if (IsValid(driver)) then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_VEHICLE, ent:GetClass(), ent:GetModel(), driver:AccountID(), GAS.Logging:PersistentPlayerData(driver:AccountID(), driver)}
		else
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_VEHICLE, ent:GetClass(), ent:GetModel()}
		end
	elseif (ent:IsWeapon()) then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_WEAPON, ent:GetClass()}
	elseif (ent:IsPlayer()) then
		return GAS.Logging:FormatPlayer(ent)
	elseif (game.GetAmmoID(ent:GetClass()) ~= -1) then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_AMMO, ent:GetClass(), ent:GetModel()}
	else
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_ENTITY, ent:GetClass(), ent:GetModel()}
	end

	if (IsValid(ent) and IsEntity(ent) and not ent:IsWorld()) then
		GAS.Logging.LogScanning.CurrentLogEntities[ent] = true
	end

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatDamage(dmginfo)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	local rounded_dmg = math.Round(dmginfo:GetDamage())
	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_DAMAGE, rounded_dmg, dmginfo:GetDamageType()}

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatVehicle(ent, hide_driver)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	local driver = not hide_driver and ent:GetDriver() or NULL
	if (IsValid(driver) and driver:IsPlayer()) then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_VEHICLE, ent:GetClass(), ent:GetModel(), driver:AccountID(), GAS.Logging:PersistentPlayerData(driver:AccountID(), driver)}
	else
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_VEHICLE, ent:GetClass(), ent:GetModel()}
	end

	GAS.Logging.LogScanning.CurrentLogEntities[ent] = true

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatProp(model_or_ent)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	if (type(model_or_ent) == "string") then
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PROP, model_or_ent}
	elseif (IsValid(model_or_ent) and IsEntity(model_or_ent)) then
		if (model_or_ent:GetClass() == "prop_ragdoll") then
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_RAGDOLL, model_or_ent:GetModel()}
		else
			GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PROP, model_or_ent:GetModel()}
		end
		GAS.Logging.LogScanning.CurrentLogEntities[model_or_ent] = true
	else
		GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_PROP, "NULL"}
	end

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatMoney(amount)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_CURRENCY, amount}

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatCountry(country)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_COUNTRY, tostring(country)}

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatAmmo(ammo_name)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1
	
	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_AMMO, tostring(ammo_name)}

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatTeam(team_index)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_TEAM, OpenPermissions:GetTeamIdentifier(team_index), team.GetName(team_index), team.GetColor(team_index)}

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatUsergroup(usergroup)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_USERGROUP, tostring(usergroup)}

	return "{" .. rIndex .. "}"
end

function GAS.Logging:FormatWeapon(wep)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_WEAPON, wep:GetClass()}

	GAS.Logging.LogScanning.CurrentLogEntities[wep] = true

	return "{" .. rIndex .. "}"
end

function GAS.Logging:Escape(str)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_STRING, tostring(str)}

	return "{" .. rIndex .. "}"
end
function GAS.Logging:Highlight(str)
	local rIndex = #GAS.Logging.CurrentLog[1] + 1

	GAS.Logging.CurrentLog[1][rIndex] = {GAS.Logging.FORMAT_HIGHLIGHT, tostring(str)}

	return "{" .. rIndex .. "}"
end

--# Live Logs #--

GAS:netInit("logging:LiveLogs")
GAS:netInit("logging:LiveLog")
GAS:netInit("logging:LiveLogAntispam")

GAS_Logging_LiveLogsPlayers = GAS_Logging_LiveLogsPlayers or {}
GAS_Logging_LiveLogsPlayers_Count = GAS_Logging_LiveLogsPlayers_Count or 0
GAS.Logging.LiveLogsIn10Seconds = 0

GAS:netReceive("logging:LiveLogs", function(ply)
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite/logging") or not OpenPermissions:HasPermission(ply, "gmodadminsuite_logging/see_live_logs")) then return end
	GAS_Logging_LiveLogsPlayers[ply] = true
	GAS_Logging_LiveLogsPlayers_Count = GAS_Logging_LiveLogsPlayers_Count + 1
end)
GAS:hook("PlayerDisconnect", "logging:RemoveFromLiveLogs", function(ply)
	if (GAS_Logging_LiveLogsPlayers[ply]) then
		GAS_Logging_LiveLogsPlayers[ply] = nil
		GAS_Logging_LiveLogsPlayers_Count = GAS_Logging_LiveLogsPlayers_Count - 1
	end
end)
GAS:timer("logging:LiveLogsCooldown", 10, 0, function()
	GAS.Logging.LiveLogsIn10Seconds = 0
end)

--# Logging #--

GAS_Logging_NotReady_Queue = GAS_Logging_NotReady_Queue or {}

GAS.Logging.ExtraProcessingQueue = {}
GAS:hook("Tick", "logging:ExtraProcessingQueue", function()
	local log_session_id,logtbl = next(GAS.Logging.ExtraProcessingQueue)
	if (logtbl) then
		GAS.Logging.ExtraProcessingQueue[log_session_id] = nil

		local module = GAS.Logging.IndexedModules[logtbl[2]]

		if module == nil then
			ErrorNoHalt(module ~= nil, "Tried to create a log to an unknown module? (" .. tostring(logtbl[2]) .. ")\n")
			PrintTable(logtbl)
			return
		end

		if (GAS.Logging.PvP) then
			local processed_pvp_events = {}
			local processed_pvp_players = {}
			for _,replacement in ipairs(logtbl[1]) do
				if (replacement[1] == GAS.Logging.FORMAT_PLAYER) then
					if (processed_pvp_players[replacement[2]]) then continue end
					processed_pvp_players[replacement[2]] = true

					local pvp_events = GAS.Logging.PvP.PlayerEvents[replacement[2]]
					if (pvp_events) then
						for i,pvp_event in pairs(pvp_events) do
							if (processed_pvp_events[i]) then continue end
							processed_pvp_events[i] = true

							pvp_event:AddLog(logtbl)
						end
					end
				end
			end
		end

		local allow_livelog_send = false
		if (GAS.Logging.Config.LiveLogsEnabled and not GAS.Logging.Modules:IsLiveLogsDisabled(module)) then
			GAS.Logging.LiveLogsIn10Seconds = GAS.Logging.LiveLogsIn10Seconds + 1
			if (GAS_Logging_LiveLogsPlayers and GAS_Logging_LiveLogsPlayers_Count > 0) then
				if (GAS.Logging.LiveLogsIn10Seconds > GAS.Logging.Config.LiveLogsIn10Seconds) then
					if (GAS.Logging.Config.NotifyLiveLogsAntispam) then
						for ply in pairs(GAS_Logging_LiveLogsPlayers) do
							if (not IsValid(ply)) then continue end
							if (not OpenPermissions:IsOperator(ply)) then
								if (not OpenPermissions:HasPermission(ply, "gmodadminsuite/logging", false) or not OpenPermissions:HasPermission(ply, "gmodadminsuite_logging/see_live_logs", false)) then continue end
								if (not GAS.Logging.Permissions:CanAccessModule(ply, module, false)) then continue end
							end
							GAS:netStart("logging:LiveLogAntispam")
							net.Send(ply)
						end
					end
				else
					allow_livelog_send = true
				end
			end
		end
		if (allow_livelog_send) then
			local data = util.Compress(GAS:SerializeTable(logtbl))
			for ply in pairs(GAS_Logging_LiveLogsPlayers) do
				if (not IsValid(ply)) then continue end
				if (not OpenPermissions:IsOperator(ply)) then
					if (not OpenPermissions:HasPermission(ply, "gmodadminsuite/logging", false) or not OpenPermissions:HasPermission(ply, "gmodadminsuite_logging/see_live_logs", false)) then continue end
					if (not GAS.Logging.Permissions:CanAccessModule(ply, module, false)) then continue end
				end
				GAS:netStart("logging:LiveLog")
					net.WriteData(data, #data)
				net.Send(ply)
			end
		end

		local discord_webhooks = GAS.Logging.Modules:GetDiscordWebhooks(module)
		local allow_discord_send = discord_webhooks and (GAS_Logging_Discord_RateLimitedUntil == nil or os.time() >= GAS_Logging_Discord_RateLimitedUntil)
		if (allow_discord_send) then
			if (DISCORD_HTTP) then
				local title = module.Category .. " ➞ " .. module.Name
				local color = math.floor(module.Colour.b + (module.Colour.g * 16^2) + (module.Colour.r * 16^4))
				local footer = GAS:EscapeJSON(GAS.Config.MySQL.ServerNickname) .. " ➞ " .. GAS:EscapeJSON(game.GetIPAddress())
				local description = GAS.Logging:FormatMarkupLog(logtbl, false, true)

				local steam_avatar = ""

				local function send_discord_request()
					local function execute(webhook_i)
						webhook_i = webhook_i + 1
						if (discord_webhooks[webhook_i] == nil) then return end

						DISCORD_HTTP({
							method = "POST",
							url = discord_webhooks[webhook_i][2],
							headers = { ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36" },
							type = "application/json",
							body = '{"embeds":[{' .. steam_avatar .. '"timestamp":"' .. os.date("!%Y-%m-%dT%H:%M:%S+00:00") .. '","title":"' .. GAS:EscapeJSON(title) .. '","color":' .. color .. ',"footer":{"text":"' .. footer .. '"},"description":"' .. GAS:EscapeJSON(description) .. '"}]}',
							success = function(code, body, headers)
								if (code == 429) then
									if (headers["Retry-After"]) then
										GAS:print("[bLogs] We're being rate limited! Discarding all webhooks in the next " .. headers["Retry-After"] .. " second(s)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
										GAS_Logging_Discord_RateLimitedUntil = os.time() + headers["Retry-After"] + 1
									else
										GAS:print("[bLogs] We're being rate limited! Discarding webhook.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
									end
								elseif (code > 299 or code < 200) then
									GAS:print("[bLogs] [" .. module.Category .. " / " .. module.Name .. "] Discord proxy returned HTTP " .. code, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
									print(body)
								end
								execute(webhook_i)
							end,
							failure = function(reason)
								GAS:print("[bLogs] [" .. module.Category .. " / " .. module.Name .. "] Failed to send log to Discord proxy: " .. reason, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
							end
						})
					end
					execute(0)
				end

				if (not GAS.SteamAPI.Config.APIKey or #GAS.SteamAPI.Config.APIKey == 0) then
					send_discord_request()
				else
					local account_id, nick
					for _,replacement in ipairs(logtbl[1]) do
						if (replacement[1] == GAS.Logging.FORMAT_PLAYER) then
							if (account_id ~= nil) then
								account_id, nick = nil, nil
								break
							elseif (replacement[3] ~= nil and replacement[3][1] ~= nil) then
								account_id, nick = replacement[2], replacement[3][1]
							end
						end
					end
					if (account_id == nil) then
						send_discord_request()
					else
						GAS.SteamAPI:GetAvatar(account_id, function(success, avatar)
							if (success) then
								steam_avatar = '"author":{"name":"' .. GAS:EscapeJSON(nick) .. '","icon_url":"' .. avatar .. '","url":"https://steamcommunity.com/profiles/' .. GAS:AccountIDToSteamID64(account_id) .. '"},'
							end
							send_discord_request()
						end)
					end
				end
			else
				GAS:print("[bLogs] Cannot dispatch Discord webhook. READ THIS FOR THE FIX: https://www.gmodstore.com/help/addon/6016/discord/topics/curl-http", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			end
		end

		if (not GAS:table_IsEmpty(GAS.Logging.LogScanning.CurrentLogEntities)) then
			GAS.Logging.LogScanning:CommitToRegistry(log_session_id)
		end
	end
end)

function GAS.Logging:CreateLog(module, custom_str, log_value, logtbl)
	GAS.Logging.CurrentLog = {{}}
	if (not GAS.Logging.Loaded) then
		table.insert(GAS_Logging_NotReady_Queue, {module, custom_str, log_value, logtbl})
	elseif (not module.ModuleID) then
		GAS:print("[bLogs] Looks like a module has a missing ID, retrieving it...")
		GAS.Logging.Modules:RetrieveID(module, function(id)
			GAS:print("[bLogs] Retrieved successfully", GAS_PRINT_COLOR_GOOD)
			module.ModuleID = id
			GAS.Logging:CreateLog(module, custom_str, log_value, logtbl)
		end)
	else
		logtbl[2] = module.ModuleID
		logtbl[3] = os.time()
		if (custom_str) then
			logtbl[4] = log_value
		else
			logtbl[5] = log_value
		end
		if (pvp_event_id ~= nil) then
			logtbl[6] = pvp_event_id
		end

		GAS.Logging.DeepStorage.LogID = GAS.Logging.DeepStorage.LogID + 1
		logtbl[7] = GAS.Logging.DeepStorage.LogID

		GAS.Logging.Logs[#GAS.Logging.Logs + 1] = logtbl
		local log_session_id = #GAS.Logging.Logs

		if (GAS.Logging.Config.DeepStorageEnabled ~= false) then
			GAS.Logging.DeepStorage.UncommittedLogs[#GAS.Logging.DeepStorage.UncommittedLogs + 1] = logtbl
		end

		if (GAS.Logging.ModuleLogs[module.ModuleID] == nil) then
			GAS.Logging.ModuleLogs[module.ModuleID] = {}
		end
		GAS.Logging.ModuleLogs[module.ModuleID][#GAS.Logging.ModuleLogs[module.ModuleID] + 1] = logtbl

		if (GAS.Logging.LogCounts[module.ModuleID] == nil) then
			GAS.Logging.LogCounts[module.ModuleID] = 0
		end
		GAS.Logging.LogCounts[module.ModuleID] = GAS.Logging.LogCounts[module.ModuleID] + 1

		GAS.Logging.ExtraProcessingQueue[log_session_id] = logtbl

		return logtbl
	end
end
function GAS.Logging:Log(module, log)
	return GAS.Logging:CreateLog(module, true, log, GAS.Logging.CurrentLog)
end
function GAS.Logging:LogPhrase(module, log_phrase)
	return GAS.Logging:CreateLog(module, false, log_phrase, GAS.Logging.CurrentLog)
end

--## Database ##--

local function store_player_columns(log_id, i, account_id, persistent_data)
	local data = {log_id, i, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL}
	if (account_id == "CONSOLE") then
		data[3] = 1
	elseif (account_id == "BOT") then
		data[4] = 1
	elseif (account_id == "NULL") then
		data[5] = NULL
	else
		data[5] = account_id -- account id
	end
	if (persistent_data ~= nil) then -- persistent player data
		if (persistent_data[3] ~= nil) then
			if (persistent_data[3] == "NULL") then
				data[6] = NULL
			else
				data[6] = GAS.Logging.ClassIDs:GetID(GAS.Logging.FORMAT_USERGROUP, persistent_data[3]) -- usergroup
			end
		end
		if (persistent_data[2] ~= nil) then
			if (persistent_data[2] == "NULL") then
				data[7] = NULL
			else
				data[7] = GAS.Logging.ClassIDs:GetID(GAS.Logging.FORMAT_TEAM, OpenPermissions:GetTeamIdentifier(persistent_data[2])) -- team
			end
		end
		if (persistent_data[7] ~= nil) then
			if (persistent_data[7] == "NULL") then
				data[8] = NULL
			else
				data[8] = GAS.Logging.ClassIDs:GetID(GAS.Logging.FORMAT_ROLE, persistent_data[7]) -- role
			end
		end
		if (persistent_data[6] ~= nil) then
			if (persistent_data[6] == "NULL") then
				data[11] = NULL
			else
				data[11] = GAS.Logging.ClassIDs:GetID(GAS.Logging.FORMAT_WEAPON, persistent_data[6]) -- weapon
			end
		end
		if (persistent_data[4] ~= nil) then
			if (persistent_data[4] == "NULL") then
				data[9] = NULL
			else
				-- health
				data[9] = math.Clamp(persistent_data[4], 0, 65535)
			end
		end
		if (persistent_data[5] ~= nil) then
			if (persistent_data[5] == "NULL") then
				data[10] = NULL
			else
				-- armor
				data[10] = math.Clamp(persistent_data[5], 0, 65535)
			end
		end
	end
	return data
end

GAS.Logging.DeepStorage = {}
GAS.Logging.DeepStorage.UncommittedLogs = {}
GAS.Logging.DeepStorage.LogID = 0

function GAS.Logging.DeepStorage:Init(callback)
	local function finish()
		GAS.Database:Query("SELECT MAX(`id`) AS 'max' FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage"), function(rows)
			if (rows and #rows > 0) then
				GAS.Logging.DeepStorage.LogID = tonumber(rows[1].max) or 0
			end
			GAS:print("[bLogs] " .. GAS.Logging.DeepStorage.LogID .. " logs in deep storage")
			if (callback) then callback() end
		end)
	end
	local function delete_orphaned_data()
		GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " WHERE (SELECT 1 FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage") .. " WHERE `log_id`=`id`) IS NULL", function()
			finish()
		end)
	end
	local function update_sessions()
		GAS.Database:Query("UPDATE " .. GAS.Database:ServerTable("gas_logging_deepstorage") .. " SET `session`=0", function()
			delete_orphaned_data()
		end)
	end
	local function delete_old_logs()
		if (GAS.Logging.Config.DeepStorageTooOld ~= 0) then
			GAS:print("[bLogs] Deleting old deep storage logs...")
			GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage") .. " WHERE " .. Either(GAS.Database.MySQLDatabase ~= nil, "GREATEST", "MAX") .. "(" .. os.time() .. " - `timestamp`, 0) >= " .. (86400 * GAS.Logging.Config.DeepStorageTooOld), function()
				update_sessions()
			end)
		else
			update_sessions()
		end
	end
	GAS:print("[bLogs] Deleting old PvP events from registry...")
	GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_pvp_events"), function()
		if (not GAS.Database.MySQLDatabase) then
			GAS:print("[bLogs] Deleting deep storage logs from previous server sessions...")
			GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage") .. " WHERE `session`=0", function()
				delete_old_logs()
			end)
		else
			delete_old_logs()
		end
	end)
end

function GAS.Logging.DeepStorage:ProcessLog(logtbl)
	local data = {
		logtbl[7],
		logtbl[2],
		logtbl[3],
		logtbl[4] or NULL,
		logtbl[5] or NULL
	}

	GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage") .. " (`id`, `module_id`, `timestamp`, `log`, `log_phrase`) VALUES(?,?,?,?,?)", data)

	for i,replacement in ipairs(logtbl[1]) do
		if (replacement[1] == GAS.Logging.FORMAT_PLAYER) then

			local data = store_player_columns(logtbl[7], i, replacement[2], replacement[3])
			GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `console`, `bot`, `account_id`, `usergroup`, `team`, `role`, `health`, `armor`, `weapon`) VALUES(?,?,?,?,?,?,?,?,?,?,?)", data)

		elseif (replacement[1] == GAS.Logging.FORMAT_VEHICLE) then
			
			if (replacement[3] ~= nil) then
				local data = store_player_columns(logtbl[7], i, replacement[4], replacement[5])
				data[#data + 1] = GAS.Logging.ClassIDs:GetID(GAS.Logging.FORMAT_VEHICLE, replacement[2])
				GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `console`, `bot`, `account_id`, `usergroup`, `team`, `role`, `health`, `armor`, `weapon`, `vehicle`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", data)
			else
				GAS.Database:Query("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `vehicle`) VALUES(" .. logtbl[7] .. "," .. i .. "," .. GAS.Logging.ClassIDs:GetID(GAS.Logging.FORMAT_VEHICLE, replacement[2]) .. ")")
			end

		elseif (replacement[1] == GAS.Logging.FORMAT_DAMAGE) then

			GAS.Database:Query("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `dmg_amount`, `dmg_type`) VALUES(" .. logtbl[7] .. "," .. i .. "," .. math.Clamp(tonumber(replacement[2]) or 0, 0, 65535) .. "," .. math.Clamp(tonumber(replacement[3]) or 0, 0, 4294967295) .. ")")

		elseif (replacement[1] == GAS.Logging.FORMAT_CURRENCY) then

			GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `currency`) VALUES(?,?,?)", {logtbl[7], i, tostring(replacement[2]) or NULL})
			
		elseif (replacement[1] == GAS.Logging.FORMAT_STRING) then

			GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `string`) VALUES(?,?,?)", {logtbl[7], i, utf8.force(replacement[2])})
			
		elseif (replacement[1] == GAS.Logging.FORMAT_HIGHLIGHT) then

			GAS.Database:Prepare("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `highlight`) VALUES(?,?,?)", {logtbl[7], i, utf8.force(replacement[2])})

		else

			GAS.Database:Query("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " (`log_id`, `data_index`, `class_type`, `class_id`) VALUES(" .. logtbl[7] .. "," .. i .. "," .. replacement[1] .. "," .. GAS.Logging.ClassIDs:GetID(replacement[1], replacement[2]) .. ")")

		end
	end
end

function GAS.Logging.DeepStorage:ProcessAllLogs()
	while true do
		local i,logtbl = next(GAS.Logging.DeepStorage.UncommittedLogs)
		if (logtbl) then
			GAS.Logging.DeepStorage.UncommittedLogs[i] = nil
			GAS.Logging.DeepStorage:ProcessLog(logtbl)
		else
			break
		end
	end
end

GAS:hook("ShutDown", "logging:DeepStorage:ShutdownCommit", function()
	if (GAS.Logging.Config.DeepStorageCommitOnShutdown == false) then return end
	if (GAS.Database.MySQLDatabase ~= nil and GAS.Database.MySQLDatabase:status() ~= mysqloo.DATABASE_CONNECTED) then
		GAS:print("[bLogs] Not committing logs to deep storage... MySQL connection has gone away!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
		return
	end
	
	GAS:print("[bLogs] Committing logs to deep storage before server shutdown...")

	GAS:unhook("Tick", "logging:DeepStorage:ProcessQueue")
	GAS:untimer("logging:DeepStorage:PeriodicCommit")

	GAS.Database:BeginTransaction()

	GAS.Logging.DeepStorage:ProcessAllLogs()

	GAS.Database:CommitTransaction()

	if (GAS.Database.MySQLDatabase) then
		GAS:print("[bLogs] We're done here! Your server might hang while MySQLOO sends queries to the database. Goodbye!")
	else
		GAS:print("[bLogs] We're done here! Goodbye.")
	end
end)

-- stress testing
-- lua_run for i=1,5000 do GAS.Logging:CreateLog(GAS.Logging:GetModule("General", "Chat"), true, "{1}: {2}", {{{0,80628317,{"DESTROYER OF THOTS",1,"superadmin",100,0,"weapon_physgun"}},{10,"hi"}}}) end
-- lua_run GAS.Database:BeginTransaction() GAS.Logging.DeepStorage:ProcessAllLogs() GAS.Database:CommitTransaction()
-- lua_run local function a() for i=1,32 do RunConsoleCommand("bot") end end a() timer.Simple(5, a) timer.Simple(10, a) timer.Simple(15, a) timer.Simple(20, a)

GAS:unhook("Tick", "logging:DeepStorage:ProcessQueue")
if (GAS.Database.MySQLDatabase) then
	GAS:timer("logging:DeepStorage:PeriodicCommit", GAS.Logging.Config.DeepStorageCommitPeriod or 60, 0, function()
		GAS.Database:BeginTransaction()

		GAS.Logging.DeepStorage:ProcessAllLogs()

		GAS.Database:CommitTransaction()
	end)
else
	local next_tick = true
	GAS:hook("Tick", "logging:DeepStorage:ProcessQueue", function()
		if (not next_tick) then
			next_tick = true
			return
		else
			next_tick = false
		end
		
		local i,logtbl = next(GAS.Logging.DeepStorage.UncommittedLogs)
		if (logtbl) then
			GAS.Logging.DeepStorage.UncommittedLogs[i] = nil

			GAS.Database:BeginTransaction()

			GAS.Logging.DeepStorage:ProcessLog(logtbl)

			GAS.Database:CommitTransaction()
		end
	end)
end

function GAS.Logging:TablesInit()
	GAS:print("[bLogs] Waiting for server ID...")
	GAS.Database:ServerID(function()
		GAS.Logging.ClassIDs:Init(function()
			GAS.Logging.DeepStorage:Init(function()
				GAS:print("[bLogs] Waiting for modules...")
				GAS.Logging.Modules:AfterLoad(function()
					GAS:print("[bLogs] Getting module IDs...")
					GAS.Logging.Modules:RetrieveIDs(function()
						GAS:print("[bLogs] Loaded successfully!", GAS_PRINT_COLOR_GOOD)

						GAS.Logging.Loaded = true

						bLogs_FullyLoaded = true
						hook.Run("bLogs_FullyLoaded")

						for _,f in ipairs(GAS_Logging_ReadyCallbacks) do f() end
						GAS_Logging_ReadyCallbacks = {}

						for _,v in ipairs(GAS_Logging_NotReady_Queue) do
							GAS.Logging:CreateLog(unpack(v))
						end
						GAS_Logging_NotReady_Queue = {}
					end)
				end)
			end)
		end)
	end)
end

if (GAS.Database.MySQLDatabase) then
	GAS:print("[bLogs] Initializing MySQL database...")

	local function ver_2_0_0_tables()
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_module_categories") .. [[ (
				`id` smallint(5) unsigned NOT NULL,
				`name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (`id`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_modules") .. [[ (
				`id` smallint(5) unsigned NOT NULL,
				`category_id` smallint(5) unsigned NOT NULL,
				`name` varchar(191) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (`id`),
				UNIQUE KEY `category_module` (`category_id`,`name`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[ (
				`id` bigint(20) unsigned NOT NULL,
				`module_id` smallint(5) unsigned NOT NULL,
				`log` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
				`log_phrase` varchar(255) CHARACTER SET ascii DEFAULT NULL,
				`timestamp` int(10) unsigned NOT NULL,
				`session` tinyint(1) unsigned NOT NULL DEFAULT '1',
				PRIMARY KEY (`id`),
				KEY `module_id` (`module_id`) USING BTREE,
				KEY `session` (`session`) USING BTREE,
				KEY `log_phrase` (`log_phrase`),
				FULLTEXT KEY `log` (`log`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. [[ (
				`log_id` int(10) unsigned NOT NULL,
				`data_index` tinyint(1) unsigned NOT NULL,
				`string` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
				`highlight` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
				`currency` decimal(65,2) DEFAULT NULL,
				`console` tinyint(1) unsigned DEFAULT NULL,
				`bot` tinyint(1) unsigned DEFAULT NULL,
				`account_id` int(10) unsigned DEFAULT NULL,
				`usergroup` mediumint(8) unsigned DEFAULT NULL,
				`team` mediumint(8) unsigned DEFAULT NULL,
				`role` mediumint(8) unsigned DEFAULT NULL,
				`health` smallint(5) unsigned DEFAULT NULL,
				`armor` smallint(5) unsigned DEFAULT NULL,
				`weapon` mediumint(8) unsigned DEFAULT NULL,
				`vehicle` mediumint(8) unsigned DEFAULT NULL,
				`dmg_amount` smallint(5) unsigned DEFAULT NULL,
				`dmg_type` int(10) unsigned DEFAULT NULL,
				`class_type` tinyint(1) unsigned DEFAULT NULL,
				`class_id` mediumint(8) unsigned DEFAULT NULL,
				PRIMARY KEY (`log_id`,`data_index`),
				KEY `account_id` (`account_id`),
				KEY `class_id` (`class_id`),
				FULLTEXT KEY `string` (`string`),
				FULLTEXT KEY `highlight` (`highlight`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_classes") .. [[ (
				`id` int(10) unsigned NOT NULL,
				`class_type` tinyint(1) unsigned NOT NULL,
				`class_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (`id`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_pvp_events") .. [[ (
				`id` int(10) unsigned NOT NULL,
				`victim` int(10) unsigned NOT NULL,
				`instigator` int(10) unsigned NOT NULL,
				`timestamp` int(10) unsigned NOT NULL,
				INDEX pvp_event_victim_index (`victim`),
				INDEX pvp_event_instigator_index (`instigator`),
				PRIMARY KEY (`id`)
			);
			
		]], function()
			GAS.Database:Prepare("SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE `TABLE_NAME`=? AND `TABLE_SCHEMA`=? AND `COLUMN_NAME`='dmg_amount'", {GAS.Database:ServerTable("gas_logging_deepstorage_logdata", true), GAS.Config.MySQL.Database}, function(rows)
				if (rows and #rows == 0) then
					GAS.Database:Query("ALTER TABLE " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " ADD `dmg_type` INT UNSIGNED NULL DEFAULT NULL AFTER `vehicle`; ALTER TABLE " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " ADD `dmg_amount` SMALLINT UNSIGNED NULL DEFAULT NULL AFTER `dmg_type`", function()
						GAS.Logging:TablesInit()
					end)
				else
					GAS.Logging:TablesInit()
				end
			end)
		end)
	end
	GAS.Database:Query("SHOW TABLES LIKE '" .. GAS.Database:ServerTable("gas_logging_optimization_ids", true) .. "'", function(rows)
		if (rows and #rows > 0) then
			GAS:print("[bLogs] Dropping pre ver 2.0.0 tables...")
			GAS.Database:Query([[
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_optimization_ids") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_module_categories") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_modules") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_logs") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_logdata") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_simulation_data") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_pvpevents") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_pvpeventdata") .. [[;
			]], ver_2_0_0_tables)
		else
			ver_2_0_0_tables()
		end
	end)
else
	GAS:print("[bLogs] Initializing SQLite database...")

	local function ver_2_0_0_tables()
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_module_categories") .. [[ (
				`id`   INTEGER PRIMARY KEY,
				`name` VARCHAR(255) NOT NULL,
				UNIQUE (`name`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_modules") .. [[ (
				`id`          INTEGER PRIMARY KEY,
				`category_id` INTEGER NOT NULL,
				`name`        VARCHAR(255) NOT NULL,
				UNIQUE (`category_id`, `name`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[ (
				`id`         INTEGER PRIMARY KEY,
				`module_id`  INTEGER NOT NULL,
				`log`        VARCHAR(255) DEFAULT NULL,
				`log_phrase` VARCHAR(255) DEFAULT NULL,
				`timestamp`  INTEGER NOT NULL,
				`session`    INTEGER NOT NULL DEFAULT '1'
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. [[ (
				`log_id`     INTEGER NOT NULL,
				`data_index` INTEGER NOT NULL,
				`string`     VARCHAR(255) DEFAULT NULL,
				`highlight`  VARCHAR(255) DEFAULT NULL,
				`currency`   DECIMAL(65, 2) DEFAULT NULL,
				`console`    INTEGER DEFAULT NULL,
				`bot`        INTEGER DEFAULT NULL,
				`account_id` INTEGER DEFAULT NULL,
				`usergroup`  INTEGER DEFAULT NULL,
				`team`       INTEGER DEFAULT NULL,
				`role`       INTEGER DEFAULT NULL,
				`health`     INTEGER DEFAULT NULL,
				`armor`      INTEGER DEFAULT NULL,
				`weapon`     INTEGER DEFAULT NULL,
				`vehicle`    INTEGER DEFAULT NULL,
				`dmg_amount` INTEGER DEFAULT NULL,
				`dmg_type`   INTEGER DEFAULT NULL,
				`class_type` INTEGER DEFAULT NULL,
				`class_id`   INTEGER DEFAULT NULL,
				PRIMARY KEY (`log_id`, `data_index`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_classes") .. [[ (
				`id`         INTEGER PRIMARY KEY,
				`class_type` INTEGER NOT NULL,
				`class_name` VARCHAR(255) NOT NULL,
				UNIQUE (`class_type`, `class_name`)
			);

			CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_logging_pvp_events") .. [[ (
				`id`         INTEGER PRIMARY KEY,
				`victim`     INTEGER NOT NULL,
				`instigator` INTEGER NOT NULL,
				`timestamp`  INTEGER NOT NULL
			);

			CREATE INDEX IF NOT EXISTS pvp_event_victim_index ON ]] .. GAS.Database:ServerTable("gas_logging_pvp_events") .. [[ (`victim`);
			CREATE INDEX IF NOT EXISTS pvp_event_instigator_index ON ]] .. GAS.Database:ServerTable("gas_logging_pvp_events") .. [[ (`instigator`);

		]], function()
			GAS.Database:Query("PRAGMA table_info(" .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. ")", function(rows)
				local found_dmg_columns = false
				for _,row in ipairs(rows) do
					if (row.name == "dmg_amount") then
						found_dmg_columns = true
						break
					end
				end
				if (not found_dmg_columns) then
					GAS.Database:Query("ALTER TABLE " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " ADD `dmg_type` INTEGER NULL DEFAULT NULL; ALTER TABLE " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " ADD `dmg_amount` INTEGER NULL DEFAULT NULL", function()
						GAS.Logging:TablesInit()
					end)
				else
					GAS.Logging:TablesInit()
				end
			end)
		end)
	end
	GAS.Database:Query("SELECT 1 FROM sqlite_master WHERE type='table' AND name='" .. GAS.Database:ServerTable("gas_logging_optimization_ids", true) .. "'", function(rows)
		if (rows and #rows > 0) then
			GAS:print("[bLogs] Dropping pre ver 2.0.0 tables...")
			GAS.Database:Query([[
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_optimization_ids") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_module_categories") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_modules") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_logs") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_logdata") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_simulation_data") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_pvpevents") .. [[;
				DROP TABLE IF EXISTS ]] .. GAS.Database:ServerTable("gas_logging_pvpeventdata") .. [[;
			]], ver_2_0_0_tables)
		else
			ver_2_0_0_tables()
		end
	end)
end