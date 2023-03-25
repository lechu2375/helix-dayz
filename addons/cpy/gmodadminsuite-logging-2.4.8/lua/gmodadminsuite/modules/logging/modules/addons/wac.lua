if (not GAS.Logging.Modules:IsAddonInstalled("WAC Aircraft")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "WAC Aircraft"
MODULE.Name     = "Aircraft Damage"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("EntityTakeDamage","wacdamage",function(ent,dmginfo)
		if (ent:IsWorld()) then return end
		if (ent:GetClass():sub(1,4) ~= "wac_") then return end
		if (not IsValid(dmginfo:GetAttacker())) then return end
		if (not dmginfo:GetAttacker():IsPlayer()) then return end
		local owner = GAS.Logging:GetEntityCreator(ent)
		local weapon = dmginfo:GetAttacker():GetActiveWeapon()
		if (IsValid(owner) and IsValid(weapon)) then
			MODULE:LogPhrase("wac_damage_owned_weapon", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())), GAS.Logging:FormatEntity(weapon))
		elseif (IsValid(owner)) then
			MODULE:LogPhrase("wac_damage_owned", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())))
		elseif (IsValid(weapon)) then
			MODULE:LogPhrase("wac_damage_weapon", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())), GAS.Logging:FormatEntity(weapon))
		else
			MODULE:LogPhrase("wac_damage", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
