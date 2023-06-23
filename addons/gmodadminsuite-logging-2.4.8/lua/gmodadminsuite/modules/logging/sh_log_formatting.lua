local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "logging")
	else
		return GAS:PhraseFormat(phrase, "logging", ...)
	end
end

GAS.Logging.LogFormattingSettings_Default = {
	Colors = {
		Highlight = Color(255,125,0),
		Money = Color(0,200,20),
		Weapon = Color(255,70,60),
		Vehicle = Color(200,0,255),
		Entity = Color(255,125,0),
		Health = Color(255,70,60),
		Armor = Color(30,90,255),
		Usergroup = Color(255,125,0),
		Unavailable = Color(90,90,90),
	},
	PlayerDataOrder = {
		"Role", "Team", "Health", "Armor", "Weapon", "Usergroup"
	}
}
if (CLIENT) then
	GAS.Logging.LogFormattingSettings = GAS:GetLocalConfig("logging_log_formatting", GAS.Logging.LogFormattingSettings_Default)
else
	GAS.Logging.LogFormattingSettings = GAS.Logging.LogFormattingSettings_Default
end

local function comma_value(amount)
	local formatted = amount
	while (true) do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if (k==0) then
			break
		end
	end
	return formatted
end
function GAS.Logging:FormatCurrencyStr(amount)
	amount = tonumber(amount)
	if (GAS.Logging.Config.OverrideMoneyFormat == true) then
		return GAS.Logging.Config.MoneyFormat:format(comma_value(amount))
	elseif (DarkRP and DarkRP.formatMoney) then
		return DarkRP.formatMoney(amount)
	else
		return "$" .. comma_value(amount)
	end
end

local function EncapsulateColor(color, text, allow_color)
	if (allow_color == false) then
		return GAS:EscapeMarkup(text)
	else
		return "<color=" .. GAS:Unvectorize(color) .. ">" .. GAS:EscapeMarkup(text) .. "</color>"
	end
end

local function EncapsulateMarkdown(text, special_char, markdown_format)
	if (markdown_format == true) then
		if (special_char == "`") then
			return "`" .. (text:gsub("`","")) .. "`"
		elseif (special_char) then
			return special_char .. GAS:EscapeMarkdown(text) .. special_char
		else
			return GAS:EscapeMarkdown(text)
		end
	else
		return text
	end
end

local function IsDamageType(dmg_type, is_dmg_type)
	return bit.band(dmg_type, is_dmg_type) == is_dmg_type
end

local INSTIGATOR_COL = Color(255,0,0)
local VICTIM_COL = Color(0,255,0)
function GAS.Logging:ProcessReplacement(replacement, allow_color, markdown_format, victim_account_id, instigator_account_id)
	if (replacement[1] == GAS.Logging.FORMAT_PLAYER) then
		local ply_replacement = ""
		if (replacement[2] == "CONSOLE") then
			ply_replacement = EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Unavailable, "CONSOLE", allow_color)
		elseif (replacement[2] == "BOT") then
			ply_replacement = EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Entity, "BOT", allow_color)
		elseif (victim_account_id ~= nil and tonumber(replacement[2]) == victim_account_id) then
			ply_replacement = EncapsulateColor(VICTIM_COL, "[" .. string.upper(L"victim") .. "]", allow_color)
		elseif (instigator_account_id ~= nil and tonumber(replacement[2]) == instigator_account_id) then
			ply_replacement = EncapsulateColor(INSTIGATOR_COL, "[" .. string.upper(L"instigator") .. "]", allow_color)
		elseif (tonumber(replacement[2])) then
			local ply = player.GetByAccountID(tonumber(replacement[2]))
			if (IsValid(ply)) then
				ply_replacement = EncapsulateColor(team.GetColor(ply:Team()), ply:Nick(), allow_color)
			elseif (replacement[3] ~= nil and replacement[3][1] ~= nil) then
				ply_replacement = EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Unavailable, replacement[3][1], allow_color)
			else
				ply_replacement = EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Unavailable, GAS:AccountIDToSteamID(replacement[2]), allow_color)
			end
		end
		local metadata = ""
		if (replacement[3] ~= nil) then
			if (replacement[3][2] == "Joining/Connecting") then replacement[3][2] = TEAM_CONNECTING end
			if (replacement[3][2] == "Unassigned") then replacement[3][2] = TEAM_UNASSIGNED end
			if (replacement[3][2] == "Spectator") then replacement[3][2] = TEAM_SPECTATOR end
			for _,v in ipairs(GAS.Logging.LogFormattingSettings.PlayerDataOrder) do
				if (v == "Team" and replacement[3][2] ~= nil) then
					local team_index = replacement[3][2]
					if (isstring(team_index)) then
						team_index = OpenPermissions:GetTeamFromIdentifier(team_index)
					end
					metadata = metadata .. " " .. EncapsulateColor(team.GetColor(team_index), team.GetName(team_index), allow_color)
				elseif (v == "Health" and replacement[3][4] ~= nil) then
					metadata = metadata .. " " .. EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Health, L("health_abbrieviated", replacement[3][4]), allow_color)
				elseif (v == "Armor" and replacement[3][5] ~= nil) then
					metadata = metadata .. " " .. EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Armor, L("armor_abbrieviated", replacement[3][5]), allow_color)
				elseif (v == "Weapon" and replacement[3][6] ~= nil) then
					metadata = metadata .. " " .. EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Weapon, replacement[3][6], allow_color)
				elseif (v == "Usergroup" and replacement[3][3] ~= nil) then
					metadata = metadata .. " " .. EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Usergroup, replacement[3][3], allow_color)
				elseif (v == "Role" and replacement[3][7] ~= nil) then
					local role_name, role_color = hook.Run("GAS:logging:GetRoleInfo", replacement[3][7])
					metadata = metadata .. " " .. EncapsulateColor(role_color or GAS.Logging.LogFormattingSettings.Colors.Unavailable, role_name or replacement[3][7], allow_color)
				end
			end
		end
		if (#metadata > 0) then
			metadata = " ➞ " .. EncapsulateMarkdown(metadata:sub(2), "_", markdown_format)
		end
		return ply_replacement .. metadata
	elseif (replacement[1] == GAS.Logging.FORMAT_WEAPON) then
		return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Weapon, replacement[2], allow_color)
	elseif (replacement[1] == GAS.Logging.FORMAT_USERGROUP) then
		return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Usergroup, replacement[2], allow_color)
	elseif (replacement[1] == GAS.Logging.FORMAT_VEHICLE) then
		if (replacement[4] ~= nil) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Vehicle, replacement[2], allow_color) .. " (" .. L"vehicle_driver" .. " " .. GAS.Logging:ProcessReplacement({GAS.Logging.FORMAT_PLAYER, replacement[4], replacement[5]}, allow_color, markdown_format, victim_account_id, instigator_account_id) .. ")"
		else
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Vehicle, replacement[2], allow_color)
		end
	elseif (replacement[1] == GAS.Logging.FORMAT_ENTITY) then
		return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Entity, replacement[2], allow_color)
	elseif (replacement[1] == GAS.Logging.FORMAT_DAMAGE) then
		if (IsDamageType(replacement[3], DMG_AIRBOAT)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_airboat", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_PHYSGUN)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_gravgun", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_VEHICLE)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_vehicle", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_FALL)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_fall", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_CRUSH)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_crush", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_SNIPER)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_sniper", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_BUCKSHOT)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_buckshot", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_SONIC)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_sonic", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_SHOCK)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_shock", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_CLUB)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_club", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_ENERGYBEAM)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_energybeam", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_PLASMA)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_plasma", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_DROWN)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_drown", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_SLASH)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_slash", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_NERVEGAS)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_nervegas", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_BLAST)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_blast", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_RADIATION)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_radiation", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_ACID)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_acid", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_BULLET)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_bullet", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_BURN) or IsDamageType(replacement[3], DMG_SLOWBURN)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_burn", "logging", replacement[2]), allow_color)
		elseif (IsDamageType(replacement[3], DMG_POISON) or IsDamageType(replacement[3], DMG_PARALYZE)) then
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_poison", "logging", replacement[2]), allow_color)
		else
			return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, GAS:PhraseFormat("pvp_dmgtype_generic", "logging", replacement[2]), allow_color)
		end
	elseif (replacement[1] == GAS.Logging.FORMAT_CURRENCY) then
		return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Money, GAS.Logging:FormatCurrencyStr(replacement[2]), allow_color)
	elseif (replacement[1] == GAS.Logging.FORMAT_STRING) then
		return EncapsulateMarkdown(GAS:EscapeMarkup(replacement[2]), nil, markdown_format)
	elseif (replacement[1] == GAS.Logging.FORMAT_HIGHLIGHT) then
		return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, EncapsulateMarkdown(replacement[2], "`", markdown_format), allow_color)
	elseif (replacement[1] == GAS.Logging.FORMAT_TEAM) then
		if (replacement[4] == nil or replacement[3] == nil) then
			if (replacement[2] == -1) then
				replacement[4] = GAS.Logging.LogFormattingSettings.Colors.Unavailable
				replacement[3] = L"deleted_team"
			else
				replacement[4] = team.GetColor(replacement[2])
				replacement[3] = team.GetName(replacement[2])
			end
		end
		return EncapsulateColor(replacement[4], replacement[3], allow_color)
	else
		return EncapsulateColor(GAS.Logging.LogFormattingSettings.Colors.Highlight, replacement[2], allow_color)
	end
end

function GAS.Logging:FormatMarkupLogCustom(unreplaced_log, log_replacements, allow_color, markdown_format, victim_account_id, instigator_account_id)
	local replacements = {}
	for _,replacement in ipairs(log_replacements) do
		replacements[#replacements + 1] = GAS.Logging:ProcessReplacement(replacement, allow_color, markdown_format, victim_account_id, instigator_account_id)
	end

	local str = unreplaced_log
	while (true) do
		local s,e = str:find("%{%d+%}")
		if (not s) then break end
		local prepend = ""
		local append = ""
		local middle = replacements[tonumber(str:sub(s + 1, e - 1))]
		if (s > 1) then
			prepend = str:sub(1, s - 1)
		end
		if (e < #str) then
			append = str:sub(e + 1)
		end
		if (allow_color == false) then
			str = prepend .. (middle or "MISSING DATA") .. append
		else
			str = prepend .. (middle or "<color=255,0,0>MISSING DATA</color>") .. append
		end
	end

	return str
end

function GAS.Logging:FormatMarkupLog(log, allow_color, markdown_format, victim_account_id, instigator_account_id)
	local unreplaced_log
	if (log[4] ~= nil) then
		unreplaced_log = log[4]
	elseif (log[5] ~= nil) then
		unreplaced_log = GAS:Phrase(log[5], "logging", "Logs")
	end

	local replacements = {}
	for _,replacement in ipairs(log[1]) do
		replacements[#replacements + 1] = GAS.Logging:ProcessReplacement(replacement, allow_color, markdown_format, victim_account_id, instigator_account_id)
	end

	local str = unreplaced_log
	while (true) do
		local s,e = str:find("%{%d+%}")
		if (not s) then break end
		local prepend = ""
		local append = ""
		local middle = replacements[tonumber(str:sub(s + 1, e - 1))]
		if (s > 1) then
			prepend = str:sub(1, s - 1)
		end
		if (e < #str) then
			append = str:sub(e + 1)
		end
		if (allow_color == false) then
			str = prepend .. (middle or "MISSING DATA") .. append
		else
			str = prepend .. (middle or "<color=255,0,0>MISSING DATA</color>") .. append
		end
	end

	return str
end