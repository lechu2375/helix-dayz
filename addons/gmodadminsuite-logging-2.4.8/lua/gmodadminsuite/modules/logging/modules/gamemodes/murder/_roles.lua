if (SERVER) then
	AddCSLuaFile()
	
	GAS:hook("GAS:logging:GetRole", "logging:Murder:GetRole", function(ply)
		if (ply:GetMurderer()) then
			return "murderer"
		else
			return "bystander"
		end
	end)
end

GAS:hook("GAS:logging:GetRoleInfo", "logging:Murder:GetRoleInfo", function(role)
	if (role == "murderer") then
		return translate[role], Color(240,0,0)
	elseif (role == "bystander") then
		return translate[role], Color(75,175,0)
	else
		return role, GAS.Logging.LogFormattingSettings.Colors.Highlight
	end
end)

GAS.Logging:EnableRoles()