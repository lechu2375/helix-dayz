local GAS = GAS
local setmetatable = setmetatable
local SysTime = SysTime
local Color = Color
local IsValid = IsValid
local pairs = pairs
local ipairs = ipairs

--################ Props ################--

local PROP_KILLS_MODULE = GAS.Logging:MODULE()

PROP_KILLS_MODULE.Category = "PvP"
PROP_KILLS_MODULE.Name     = "Prop Kills"
PROP_KILLS_MODULE.Colour   = Color(255,0,0)

--################ PvP ################--

local DEATHS_MODULE = GAS.Logging:MODULE()

DEATHS_MODULE.Category = "PvP"
DEATHS_MODULE.Name     = "Deaths"
DEATHS_MODULE.Colour   = Color(255,0,0)

-------------------------------------------

local MISC_DMG_MODULE = GAS.Logging:MODULE()

MISC_DMG_MODULE.Category = "PvP"
MISC_DMG_MODULE.Name     = "Misc Damage"
MISC_DMG_MODULE.Colour   = Color(255,0,0)

-------------------------------------------

local PVP_COMBAT_MODULE = GAS.Logging:MODULE()
GAS.Logging.PVP_COMBAT_MODULE = PVP_COMBAT_MODULE

PVP_COMBAT_MODULE.Category = "PvP"
PVP_COMBAT_MODULE.Name     = "Combat Events"
PVP_COMBAT_MODULE.Colour   = Color(255,0,0)

local function GetVehicleOwner(vehicle)
	if (DarkRP and vehicle.getDoorOwner) then
		local owner = vehicle:getDoorOwner()
		if (IsValid(owner)) then
			return owner
		end
	end
	return GAS.Logging:GetEntityCreator(vehicle)
end

PVP_COMBAT_MODULE:Setup(function()
	GAS.Logging.PvP = {}
	GAS.Logging.PvP.EventID = 0
	GAS.Logging.PvP.AllEvents     = {}
	GAS.Logging.PvP.OngoingEvents = {}
	GAS.Logging.PvP.PlayerEvents  = {}

	local function calcKey(a, b)
		if a > b then
			return a .. b
		else
			return b .. a
		end
	end

	GAS:timer("logging:PvP:ExpireEvents", 1, 0, function()
		for _,event in pairs(GAS.Logging.PvP.OngoingEvents) do
			if (SysTime() >= event.Properties[GAS.Logging.PvP_LAST_UPDATED] + GAS.Logging.Config.TimeBetweenPvPEvents) then
				event:End()
			end
		end
	end)

	GAS.Logging.PvP.PVP_EVENT = {}
	GAS.Logging.PvP.PVP_EVENT.__index = GAS.Logging.PvP.PVP_EVENT
	function GAS.Logging.PvP.PVP_EVENT:Init(instigator, victim, dmginfo)
		local instigator_id, victim_id = instigator:AccountID(), victim:AccountID()

		GAS.Logging.PvP.EventID = GAS.Logging.PvP.EventID + 1
		local event_id = GAS.Logging.PvP.EventID

		GAS.Database:Query("INSERT INTO " .. GAS.Database:ServerTable("gas_logging_pvp_events") .. " (`id`, `victim`, `instigator`, `timestamp`) VALUES(" .. event_id .. ", " .. victim_id .. ", " .. instigator_id .. ", " .. os.time() .. ")")

		GAS.Logging.PvP.OngoingEvents[calcKey(instigator_id, victim_id)] = self
		GAS.Logging.PvP.AllEvents[event_id] = self

		GAS.Logging.PvP.PlayerEvents[instigator_id] = GAS.Logging.PvP.PlayerEvents[instigator_id] or {}
		GAS.Logging.PvP.PlayerEvents[instigator_id][event_id] = self

		GAS.Logging.PvP.PlayerEvents[victim_id] = GAS.Logging.PvP.PlayerEvents[victim_id] or {}
		GAS.Logging.PvP.PlayerEvents[victim_id][event_id] = self

		self.Properties[GAS.Logging.PvP_EVENT_ID]              = event_id          -- id of the pvp event

		self.Properties[GAS.Logging.PvP_PRECISE_CREATION_TIME] = SysTime()         -- accurate creation time
		self.Properties[GAS.Logging.PvP_LAST_UPDATED]          = SysTime()         -- accurate last updated
		self.Properties[GAS.Logging.PvP_CREATION_TIMESTAMP]    = os.time()         -- UNIX timestamp of creation time

		self.Properties[GAS.Logging.PvP_INSTIGATOR]            = instigator_id     -- person who started the PvP
		self.Properties[GAS.Logging.PvP_INSTIGATOR_WEPS]       = {}                -- weapons used by instigator
		self.Properties[GAS.Logging.PvP_INSTIGATOR_DMG_TKN]    = 0                 -- damage taken by instigator
		self.Properties[GAS.Logging.PvP_INSTIGATOR_DMG_GVN]    = 0                 -- damage given by instigator to victim
		self.Properties[GAS.Logging.PvP_INSTIGATOR_TEAM]       = instigator:Team() -- instigator team
		self.Properties[GAS.Logging.PvP_INSTIGATOR_NICK]       = instigator:Nick() -- instigator name

		self.Properties[GAS.Logging.PvP_VICTIM]                = victim_id         -- person who was started on
		self.Properties[GAS.Logging.PvP_VICTIM_WEPS]           = {}                -- weapons used by victim
		self.Properties[GAS.Logging.PvP_VICTIM_DMG_TKN]        = 0                 -- damage taken by victim
		self.Properties[GAS.Logging.PvP_VICTIM_DMG_GVN]        = 0                 -- damage given by victim to instigator
		self.Properties[GAS.Logging.PvP_VICTIM_TEAM]           = victim:Team()     -- victim team
		self.Properties[GAS.Logging.PvP_VICTIM_NICK]           = victim:Nick()     -- victim name

		self.Properties[GAS.Logging.PvP_TOTAL_DMG]             = 0                 -- total damage
		self.Properties[GAS.Logging.PvP_LINKED_EVENTS]         = {}                -- linked events
		self.Properties[GAS.Logging.PvP_EVENT_LOGS]            = {}                -- damage events and logs
		self.Properties[GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY] = {}                -- chronological accurate timestamps per log
		self.Properties[GAS.Logging.PvP_WEP_VEHICLES]          = {}                -- weapons that are actually vehicles

		self.Properties[GAS.Logging.PvP_ONGOING] = true -- ongoing

		self.Properties[GAS.Logging.PvP_FLAGS] = { -- flags

			[GAS.Logging.PvP_FLAG_ADMIN] = ((instigator:IsAdmin() and not instigator:IsSuperAdmin()) or (victim:IsAdmin() and not victim:IsSuperAdmin())) or nil,
			[GAS.Logging.PvP_FLAG_SUPERADMIN] = (instigator:IsSuperAdmin() or victim:IsSuperAdmin()) or nil,
			[GAS.Logging.PvP_FLAG_LAWENFORCEMENT] = (GAS.Logging.GamemodeModulesEnabled.DarkRP and DarkRP ~= nil and (instigator:isCP() or victim:isCP())) or nil,
			[GAS.Logging.PvP_FLAG_ONGOING] = true,

		}

		local combat_scene = setmetatable({
			Properties = {},
			Scenes = {}
		}, GAS.Logging.PvP.CombatScene)

		self.Properties[GAS.Logging.PvP_COMBAT_SCENE] = combat_scene:Init(victim, instigator, dmginfo)

		if (GAS.Logging.GamemodeModulesEnabled.DarkRP) then
			if (victim:isCP() and instigator:isCP()) then
				self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_FRIENDLYFIRE] = true
			else
				local victim_agenda, instigator_agenda = victim:getAgendaTable(), instigator:getAgendaTable()
				if (victim_agenda ~= nil and instigator_agenda ~= nil and victim_agenda == instigator_agenda) then
					self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_FRIENDLYFIRE] = true
				else
					for _,gc in ipairs(DarkRP.getGroupChats()) do
						if (gc(victim) == true and gc(instigator) == true) then
							self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_FRIENDLYFIRE] = true
							break
						end
					end
				end
			end
		else
			self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_FRIENDLYFIRE] = (self.Properties[GAS.Logging.PvP_VICTIM_TEAM] == self.Properties[GAS.Logging.PvP_INSTIGATOR_TEAM]) or nil
		end

		if (GAS.Logging.PvP.PlayerEvents[instigator_id] ~= nil) then
			for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[instigator_id]) do
				if (event == self) then continue end

				event.Properties[GAS.Logging.PvP_LINKED_EVENTS][self.Properties[GAS.Logging.PvP_EVENT_ID]] = true
				self.Properties[GAS.Logging.PvP_LINKED_EVENTS][event.Properties[GAS.Logging.PvP_EVENT_ID]] = true

				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_LINKED] = true
				self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_LINKED] = true
			end
		end
		if (GAS.Logging.PvP.PlayerEvents[victim_id] ~= nil) then
			for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[victim_id]) do
				if (event == self) then continue end

				event.Properties[GAS.Logging.PvP_LINKED_EVENTS][self.Properties[GAS.Logging.PvP_EVENT_ID]] = true
				self.Properties[GAS.Logging.PvP_LINKED_EVENTS][event.Properties[GAS.Logging.PvP_EVENT_ID]] = true

				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_LINKED] = true
				self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_LINKED] = true
			end
		end

		PVP_COMBAT_MODULE:LogPhrase("pvp_combat_begin", GAS.Logging:FormatPlayer(instigator), GAS.Logging:FormatPlayer(victim))
	end
	function GAS.Logging.PvP.PVP_EVENT:AddLog(logtbl)
		self.Properties[GAS.Logging.PvP_EVENT_LOGS][#self.Properties[GAS.Logging.PvP_EVENT_LOGS] + 1] = logtbl
		self.Properties[GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY][#self.Properties[GAS.Logging.PvP_EVENT_LOGS]] = SysTime() - self.Properties[GAS.Logging.PvP_PRECISE_CREATION_TIME]
		self.Properties[GAS.Logging.PvP_LAST_UPDATED] = SysTime()
		logtbl[6] = self.Properties[GAS.Logging.PvP_EVENT_ID]
	end
	function GAS.Logging.PvP.PVP_EVENT:AddDamage(log_phrase, victim, inflictor, inflictor_wep, dmginfo, ...)
		local victim_id = victim:AccountID()
		local inflictor_id
		if (IsValid(inflictor) and inflictor:IsPlayer()) then inflictor_id = inflictor:AccountID() end

		if (victim_id == self.Properties[GAS.Logging.PvP_INSTIGATOR]) then
			self.Properties[GAS.Logging.PvP_INSTIGATOR_DMG_TKN] = self.Properties[GAS.Logging.PvP_INSTIGATOR_DMG_TKN] + dmginfo:GetDamage() -- damage taken by instigator
			if (inflictor_id and inflictor_id == self.Properties[GAS.Logging.PvP_VICTIM]) then
				self.Properties[GAS.Logging.PvP_VICTIM_DMG_GVN] = self.Properties[GAS.Logging.PvP_VICTIM_DMG_GVN] + dmginfo:GetDamage() -- damage given by victim to instigator
				if (IsValid(inflictor_wep)) then
					self.Properties[GAS.Logging.PvP_VICTIM_WEPS][inflictor_wep:GetClass()] = (self.Properties[GAS.Logging.PvP_VICTIM_WEPS][inflictor_wep:GetClass()] or 0) + dmginfo:GetDamage() -- damage given by victim weapon
				end
			end
		elseif (victim_id == self.Properties[GAS.Logging.PvP_VICTIM]) then
			self.Properties[GAS.Logging.PvP_VICTIM_DMG_TKN] = self.Properties[GAS.Logging.PvP_VICTIM_DMG_TKN] + dmginfo:GetDamage() -- damage taken by victim
			if (inflictor_id and inflictor_id == self.Properties[GAS.Logging.PvP_INSTIGATOR]) then
				self.Properties[GAS.Logging.PvP_INSTIGATOR_DMG_GVN] = self.Properties[GAS.Logging.PvP_INSTIGATOR_DMG_GVN] + dmginfo:GetDamage() -- damage given by instigator to victim
				if (IsValid(inflictor_wep)) then
					self.Properties[GAS.Logging.PvP_INSTIGATOR_WEPS][inflictor_wep:GetClass()] = (self.Properties[GAS.Logging.PvP_INSTIGATOR_WEPS][inflictor_wep:GetClass()] or 0) + dmginfo:GetDamage() -- damage given by instigator weapon
				end
			end
		end
		self.Properties[GAS.Logging.PvP_TOTAL_DMG] = self.Properties[GAS.Logging.PvP_TOTAL_DMG] + dmginfo:GetDamage() -- total damage

		if (IsValid(inflictor_wep) and inflictor_wep:IsVehicle()) then
			self.Properties[GAS.Logging.PvP_WEP_VEHICLES][inflictor_wep:GetClass()] = true
			self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_VEHICLE] = true
		end

		local dmgtbl = {SysTime() - self.Properties[GAS.Logging.PvP_PRECISE_CREATION_TIME], log_phrase, victim_id, inflictor_id, GAS.Logging.CurrentLog[1], dmginfo:GetDamage(), {}}

		for i,dmgtype in ipairs(GAS.Logging.PvP_DAMAGE_TYPES) do
			if (dmginfo:IsDamageType(dmgtype)) then
				dmgtbl[7][i] = true
			end
		end

		self.Properties[GAS.Logging.PvP_EVENT_LOGS][#self.Properties[GAS.Logging.PvP_EVENT_LOGS] + 1] = dmgtbl
		self.Properties[GAS.Logging.PvP_LAST_UPDATED] = SysTime()
		GAS.Logging.CurrentLog = {{}}
	end
	function GAS.Logging.PvP.PVP_EVENT:End()
		PVP_COMBAT_MODULE:LogPhrase("pvp_combat_end", GAS.Logging:FormatPlayer(self.Properties[GAS.Logging.PvP_INSTIGATOR]), GAS.Logging:FormatPlayer(self.Properties[GAS.Logging.PvP_VICTIM]))

		self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_ONGOING] = nil
		self.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_FINISHED] = true
		self.Properties[GAS.Logging.PvP_ONGOING] = false

		GAS.Logging.PvP.CombatScenes[self.Properties[GAS.Logging.PvP_COMBAT_SCENE]]:End()

		GAS.Logging.PvP.OngoingEvents[calcKey(self.Properties[GAS.Logging.PvP_INSTIGATOR], self.Properties[GAS.Logging.PvP_VICTIM])] = nil -- remove event from ongoing events table

		GAS.Logging.PvP.PlayerEvents[self.Properties[GAS.Logging.PvP_INSTIGATOR]][self.Properties[GAS.Logging.PvP_EVENT_ID]] = nil  -- remove event from instigator's ongoing events table
		GAS.Logging.PvP.PlayerEvents[self.Properties[GAS.Logging.PvP_VICTIM]][self.Properties[GAS.Logging.PvP_EVENT_ID]] = nil      -- remove event from victim's ongoing events table
	end

	function GAS.Logging.PvP:GetEvent(attacker, defender, dmginfo)
		local id = calcKey(attacker:AccountID(), defender:AccountID())
		if (GAS.Logging.PvP.OngoingEvents[id]) then
			return GAS.Logging.PvP.OngoingEvents[id]
		else
			local new_event = setmetatable({ Properties = {} }, GAS.Logging.PvP.PVP_EVENT)
			new_event:Init(attacker, defender, dmginfo)
			return new_event
		end
	end

	local function EntityTakeDamage(victim, dmginfo, took)
		if (not took or not victim:IsPlayer() or victim:HasGodMode() or not victim:Alive() or dmginfo:GetDamage() <= 0) then return end
		if (victim:IsBot()) then return end

		local account_id = victim:AccountID()

		local attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()
		if (not IsValid(attacker) and IsValid(inflictor)) then
			attacker = inflictor
		end

		if (not IsValid(attacker) or attacker:IsWorld() or (not attacker:IsPlayer() and not attacker:IsVehicle())) then
			local prop
			if (IsValid(attacker) and not attacker:IsWorld() and (attacker:GetClass() == "prop_physics" or attacker:GetClass() == "prop_ragdoll")) then
				prop = attacker
			end
			if (IsValid(prop)) then
				local creator = GAS.Logging:GetEntityCreator(prop)
				if (not IsValid(creator)) then
					MISC_DMG_MODULE:LogPhrase("pvp_misc_dmg_prop", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatDamage(dmginfo), GAS.Logging:FormatProp(prop))
				end
			else
				if (IsValid(attacker) and not attacker:IsWorld()) then
					MISC_DMG_MODULE:LogPhrase("pvp_misc_dmg_attacker", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatDamage(dmginfo), GAS.Logging:FormatEntity(attacker))
				else
					MISC_DMG_MODULE:LogPhrase("pvp_misc_dmg_other", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatDamage(dmginfo))
				end
			end
		end

		if (attacker:IsWorld() or (IsValid(inflictor) and inflictor:IsWorld())) then
			if (GAS.Logging.PvP.PlayerEvents[account_id]) then
				for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
					if (dmginfo:IsDamageType(DMG_FALL)) then
						event:AddDamage("pvp_fall_damage", victim, nil, nil, dmginfo, GAS.Logging:FormatPlayer(victim))
					elseif (dmginfo:IsDamageType(DMG_CRUSH)) then
						event:AddDamage("pvp_world_crush_damage", victim, nil, nil, dmginfo, GAS.Logging:FormatPlayer(victim))
					else
						event:AddDamage("pvp_world_damage", victim, nil, nil, dmginfo, GAS.Logging:FormatPlayer(victim))
					end
					event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_WORLD] = true
				end
			end
		elseif ((attacker:GetClass() == "prop_physics" or attacker:GetClass() == "prop_ragdoll") or (IsValid(inflictor) and (inflictor:GetClass() == "prop_physics" or inflictor:GetClass() == "prop_ragdoll"))) then
			local prop
			if (attacker:GetClass() == "prop_physics" or attacker:GetClass() == "prop_ragdoll") then prop = attacker else prop = inflictor end
			local creator = GAS.Logging:GetEntityCreator(prop)
			if (IsValid(creator)) then
				if (creator == victim) then
					if (GAS.Logging.PvP.PlayerEvents[account_id]) then
						for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
							event:AddDamage("pvp_prop_self_damage", victim, nil, nil, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatProp(prop))
							event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_PROPS] = true
						end
					end
				else
					local pvp_event = GAS.Logging.PvP:GetEvent(creator, victim)
					pvp_event:AddDamage("pvp_prop_damage", victim, creator, nil, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatProp(prop), GAS.Logging:FormatPlayer(creator))
					pvp_event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_PROPS] = true
				end
			else
				if (GAS.Logging.PvP.PlayerEvents[account_id]) then
					for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
						event:AddDamage("pvp_world_prop_damage", victim, nil, nil, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatProp(prop))
						event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_PROPS] = true
					end
				end
			end
		elseif ((IsValid(attacker) and attacker:IsVehicle()) or (IsValid(inflictor) and inflictor:IsVehicle())) then
			local vehicle = (IsValid(attacker) and attacker:IsVehicle() and attacker) or inflictor
			local driver = vehicle:GetDriver()
			if (IsValid(driver)) then
				if (driver == victim) then
					if (GAS.Logging.PvP.PlayerEvents[account_id]) then
						for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
							event:AddDamage("pvp_vehicle_damage_self", victim, nil, vehicle, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(vehicle, true))
						end
					end
				else
					local pvp_event = GAS.Logging.PvP:GetEvent(driver, victim)
					pvp_event:AddDamage("pvp_vehicle_damage", victim, driver, vehicle, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(vehicle), GAS.Logging:FormatPlayer(driver))
				end
			else
				if (GAS.Logging.PvP.PlayerEvents[account_id]) then
					for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
						event:AddDamage("pvp_driverless_vehicle_damage", victim, nil, vehicle, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(vehicle, true))
					end
				end
			end
		elseif (attacker == victim or inflictor == victim) then
			if (GAS.Logging.PvP.PlayerEvents[account_id]) then
				for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
					if (attacker == victim and inflictor:IsWeapon()) then
						event:AddDamage("pvp_dmg_self", victim, victim, inflictor, dmginfo, GAS.Logging:FormatPlayer(victim))
					else
						event:AddDamage("pvp_dmg_self", victim, victim, nil, dmginfo, GAS.Logging:FormatPlayer(victim))
					end
				end
			end
		elseif (attacker:IsPlayer()) then
			local pvp_event = GAS.Logging.PvP:GetEvent(attacker, victim, dmginfo)
			local attacker_wep
			if (IsValid(inflictor) and inflictor:IsWeapon()) then
				attacker_wep = inflictor
			elseif (IsValid(attacker:GetActiveWeapon())) then
				attacker_wep = attacker:GetActiveWeapon()
			end
			if (attacker_wep) then
				pvp_event:AddDamage("pvp_player_damage_weapon", victim, attacker, attacker_wep, dmginfo, GAS.Logging:FormatPlayer(attacker), GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatWeapon(attacker_wep))
			else
				pvp_event:AddDamage("pvp_player_damage", victim, attacker, nil, dmginfo, GAS.Logging:FormatPlayer(attacker), GAS.Logging:FormatPlayer(victim))
			end
		elseif (GAS.Logging.PvP.PlayerEvents[account_id] ~= nil) then
			for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[account_id]) do
				event:AddDamage("pvp_misc_dmg", victim, nil, nil, dmginfo, GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatEntity(attacker))
			end
		end
	end
	GAS.Hooking:SuperiorHook("PostEntityTakeDamage", "logging:PvP:TrackDamage", EntityTakeDamage)

	GAS.Hooking:SuperiorHook("DoPlayerDeath", "logging:PvP:TrackDeathDmg", function(victim, attacker, dmginfo)
		if (dmginfo:GetDamage() <= 0) then return end
		EntityTakeDamage(victim, dmginfo, true)
	end)
	GAS:hook("PlayerSilentDeath", "logging:PvP:TrackSilentDeath", function(victim)
		DEATHS_MODULE:LogPhrase("pvp_player_silent_death", GAS.Logging:FormatPlayer(victim))
		if (not GAS.Logging.PvP.PlayerEvents[victim:AccountID()]) then return end
		for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[victim:AccountID()]) do
			if (victim:AccountID() == event.Properties[GAS.Logging.PvP_VICTIM]) then
				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_VICTIM_DEATH] = true
			elseif (victim:AccountID() == event.Properties[GAS.Logging.PvP_INSTIGATOR]) then
				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_INSTIGATOR_DEATH] = true
			end
			event:End()
		end
	end)
	GAS:hook("PlayerDeath", "logging:PvP:TrackDeath", function(victim, inflictor, _attacker)
		local attacker = _attacker or inflictor

		if (IsValid(inflictor) and not inflictor:IsWorld() and (inflictor:GetClass() == "prop_physics" or inflictor:GetClass() == "prop_ragdoll")) then
			local creator = GAS.Logging:GetEntityCreator(inflictor)
			if (IsValid(creator)) then
				if (creator == victim) then
					PROP_KILLS_MODULE:LogPhrase("pvp_death_propkill_self", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatProp(inflictor))
				else
					PROP_KILLS_MODULE:LogPhrase("pvp_death_propkill", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatPlayer(creator), GAS.Logging:FormatProp(inflictor))
				end
			else
				PROP_KILLS_MODULE:LogPhrase("pvp_death_propkill_world", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatProp(inflictor))
			end
		elseif (not attacker:IsWorld() and attacker:IsPlayer()) then
			local attacker_wep
			if (IsValid(inflictor) and inflictor:IsWeapon()) then
				attacker_wep = inflictor
			elseif (IsValid(attacker:GetActiveWeapon())) then
				attacker_wep = attacker:GetActiveWeapon()
			end
			if (attacker_wep) then
				DEATHS_MODULE:LogPhrase("pvp_death_player_weapon", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatPlayer(attacker), GAS.Logging:FormatWeapon(attacker_wep))
			elseif (inflictor:IsVehicle()) then
				if (IsValid(inflictor:GetDriver())) then
					DEATHS_MODULE:LogPhrase("pvp_death_player_weapon", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatPlayer(inflictor:GetDriver()), GAS.Logging:FormatVehicle(inflictor, true))
				else
					local owner = GetVehicleOwner(inflictor)
					if (IsValid(owner)) then
						DEATHS_MODULE:LogPhrase("pvp_vehicle_owned_killed", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(inflictor, true), GAS.Logging:FormatPlayer(owner))
					else
						DEATHS_MODULE:LogPhrase("pvp_vehicle_killed", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(inflictor, true))
					end
				end
			elseif (victim == attacker) then
				DEATHS_MODULE:LogPhrase("pvp_killed_self", GAS.Logging:FormatPlayer(victim))
			else
				DEATHS_MODULE:LogPhrase("pvp_death_player", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatPlayer(attacker))
			end
		elseif (attacker:IsWorld()) then
			DEATHS_MODULE:LogPhrase("pvp_death_world", GAS.Logging:FormatPlayer(victim))
		elseif ((IsValid(attacker) and attacker:IsVehicle()) or (IsValid(inflictor) and inflictor:IsVehicle())) then
			local vehicle = (IsValid(attacker) and attacker:IsVehicle() and attacker) or inflictor:IsVehicle()
			if (IsValid(vehicle:GetDriver())) then
				DEATHS_MODULE:LogPhrase("pvp_death_player_weapon", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatPlayer(vehicle:GetDriver()), GAS.Logging:FormatVehicle(vehicle, true))
			else
				local owner = GetVehicleOwner(vehicle)
				if (IsValid(owner)) then
					DEATHS_MODULE:LogPhrase("pvp_vehicle_owned_killed", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(vehicle, true), GAS.Logging:FormatPlayer(owner))
				else
					DEATHS_MODULE:LogPhrase("pvp_vehicle_killed", GAS.Logging:FormatPlayer(victim), GAS.Logging:FormatVehicle(vehicle, true))
				end
			end
		else
			DEATHS_MODULE:LogPhrase("pvp_death", GAS.Logging:FormatPlayer(victim))
		end

		if (not GAS.Logging.PvP.PlayerEvents[victim:AccountID()]) then return end

		if (IsValid(inflictor) and not inflictor:IsWorld() and (inflictor:GetClass() == "prop_physics" or inflictor:GetClass() == "prop_ragdoll")) then
			local creator = GAS.Logging:GetEntityCreator(inflictor)
			if (IsValid(creator)) then
				if (creator == victim) then
					for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[victim:AccountID()]) do
						event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_PROPS] = true
						event:End()
					end
				else
					local pvp_event = GAS.Logging.PvP:GetEvent(creator, victim)
					pvp_event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_PROPS] = true
					pvp_event:End()
				end
			else
				for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[victim:AccountID()]) do
					event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_PROPS] = true
					event:End()
				end
			end
		end

		if (not attacker:IsWorld() and attacker:IsPlayer() and (attacker ~= victim)) then
			local pvp_event = GAS.Logging.PvP:GetEvent(attacker, victim)
			if (victim:AccountID() == pvp_event.Properties[GAS.Logging.PvP_VICTIM]) then
				pvp_event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_VICTIM_DEATH] = true
			elseif (victim:AccountID() == pvp_event.Properties[GAS.Logging.PvP_INSTIGATOR]) then
				pvp_event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_INSTIGATOR_DEATH] = true
			end
			pvp_event:End()
		end

		for _,event in ipairs(GAS.Logging.PvP.PlayerEvents[victim:AccountID()]) do
			if (victim:AccountID() == event.Properties[GAS.Logging.PvP_VICTIM]) then
				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_VICTIM_DEATH] = true
			elseif (victim:AccountID() == event.Properties[GAS.Logging.PvP_INSTIGATOR]) then
				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_INSTIGATOR_DEATH] = true
			end
			if (attacker:IsWorld()) then
				event.Properties[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_WORLD] = true
			end
			event:End()
		end
	end)
	
	GAS.Logging.PvP.CombatScenes = {}

	GAS.Logging.PvP.CombatScene = {}
	GAS.Logging.PvP.CombatScene.__index = GAS.Logging.PvP.CombatScene
	function GAS.Logging.PvP.CombatScene:TakeSnapshot(ply, dmginfo)
		local snapshot = {}
		
		snapshot[GAS.Logging.PvP_SCENE_MODEL]     = ply:GetModel()
		snapshot[GAS.Logging.PvP_SCENE_POS]       = ply:GetPos()
		snapshot[GAS.Logging.PvP_SCENE_ANG]       = ply:GetAngles()
		snapshot[GAS.Logging.PvP_SCENE_PLY_COLOR] = ply:GetPlayerColor()
		snapshot[GAS.Logging.PvP_SCENE_EYE_POS]   = ply:EyePos()

		snapshot[GAS.Logging.PvP_SCENE_ANG].p = 0

		local vehicle = ply:GetVehicle()
		if (not IsValid(vehicle) or ply:GetAllowWeaponsInVehicle()) then
			local wep = ply:GetActiveWeapon()
			if (IsValid(wep)) then
				if (#wep:GetModel() > 0) then
					snapshot[GAS.Logging.PvP_SCENE_WEAPON_MDL] = wep:GetModel()
				end
				snapshot[GAS.Logging.PvP_SCENE_WEAPON_CLASS] = wep:GetClass()
			end
		end

		if (IsValid(vehicle)) then
			snapshot[GAS.Logging.PvP_SCENE_VEHICLE_MODEL] = vehicle:GetModel()
			snapshot[GAS.Logging.PvP_SCENE_VEHICLE_POS] = vehicle:GetPos()
			snapshot[GAS.Logging.PvP_SCENE_VEHICLE_ANG] = vehicle:GetAngles()
			snapshot[GAS.Logging.PvP_SCENE_VEHICLE_ATTACHMENT] = ply:GetParentAttachment()
		end

		local head = ply:LookupBone("ValveBiped.Bip01_Head1")
		if (head and head ~= 0) then
			local pos,ang = ply:GetBonePosition(head)
			snapshot[GAS.Logging.PvP_SCENE_HEAD_ANG] = ang
		end
		
		if (dmginfo == nil) then
			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + (ply:GetAimVector() * (4096 * 8)),
				filter = ply,
				mask = MASK_SHOT
			})
			snapshot[GAS.Logging.PvP_SCENE_SHOOT_POS] = tr.HitPos
		else
			snapshot[GAS.Logging.PvP_SCENE_SHOOT_POS] = dmginfo:GetDamagePosition()
		end

		if (ply:GetSequence()) then
			snapshot[GAS.Logging.PvP_SCENE_SEQUENCE] = ply:GetSequenceInfo(ply:GetSequence()).label
		end
		timer.Simple(0, function()
			if (ply:Alive()) then
				if (ply:GetSequence()) then
					snapshot[GAS.Logging.PvP_SCENE_SEQUENCE] = ply:GetSequenceInfo(ply:GetSequence()).label
				end
			end
		end)

		return snapshot
	end
	function GAS.Logging.PvP.CombatScene:Init(victim, instigator, dmginfo)
		GAS.Logging.PvP.CombatScenes[#GAS.Logging.PvP.CombatScenes + 1] = self
		self.ID = #GAS.Logging.PvP.CombatScenes

		self.Victim, self.Instigator = victim, instigator

		local victim_id = victim:AccountID()
		self.Properties[1] = victim_id

		self.Scenes.Start = {}
		self.Scenes.Start[1] = self:TakeSnapshot(victim)

		local instigator_id
		if (IsValid(instigator)) then
			instigator_id = instigator:AccountID()
			self.Properties[2] = instigator_id

			self.Scenes.Start[2] = self:TakeSnapshot(instigator, dmginfo)
		end

		return self.ID
	end
	function GAS.Logging.PvP.CombatScene:End()
		if (IsValid(self.Victim)) then
			self.Scenes.End = {}
			self.Scenes.End[1] = self:TakeSnapshot(self.Victim)
		end
		if (IsValid(self.Instigator)) then
			self.Scenes.End = self.Scenes.End or {}
			self.Scenes.End[2] = self:TakeSnapshot(self.Instigator)
		end

		self.Victim, self.Instigator = nil
	end
end)

--################ Register Modules ################--

GAS.Logging:AddModule(PROP_KILLS_MODULE)
GAS.Logging:AddModule(DEATHS_MODULE)
GAS.Logging:AddModule(PVP_COMBAT_MODULE)
GAS.Logging:AddModule(MISC_DMG_MODULE)