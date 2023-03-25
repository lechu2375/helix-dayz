if (SERVER) then
	AddCSLuaFile()

	GAS:hook("GAS:logging:GetRole", "logging:TTT:GetRole", function(ply)
		return ply:GetRoleStringRaw()
	end)
end

GAS:hook("GAS:logging:GetRoleInfo", "logging:TTT:GetRoleInfo", function(role)
	local language_tbl
	if (CLIENT) then
		language_tbl = LANG.GetUnsafeLanguageTable()
	else
		language_tbl = {
			[ROLE_TRAITOR]   = "Traitor",
			[ROLE_INNOCENT]  = "Innocent",
			[ROLE_DETECTIVE] = "Detective",
		}
	end
	local role_name = language_tbl[role] or role
	if (role == "innocent") then
		return role_name, Color(25,200,25)
	elseif (role == "traitor") then
		return role_name, Color(200,25,25)
	elseif (role == "detective") then
		return role_name, Color(25,25,200)
	end
	return role_name, GAS.Logging.LogFormattingSettings.Colors.Highlight
end)

GAS.Logging:EnableRoles()