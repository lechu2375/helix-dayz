if (not GAS.Logging.Modules:IsAddonInstalled("Star Wars Vehicles")) then return end

local SWVehicles = {}
for _,v in pairs(list.Get("SWVehicles")) do
	SWVehicles[v.ClassName] = true
end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Star Wars Vehicles"
MODULE.Name     = "Vehicle Damage"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("EntityTakeDamage","swdamage",function(ent,dmginfo)
		if (ent:IsWorld()) then return end
		if (SWVehicles[ent:GetClass()] == nil) then return end
		if (not IsValid(dmginfo:GetAttacker()) or not dmginfo:GetAttacker():IsPlayer()) then return end
		local owner = GAS.Logging:GetEntityCreator(ent)
		local weapon = dmginfo:GetAttacker():GetActiveWeapon()
		if (IsValid(owner) and IsValid(weapon)) then
			MODULE:LogPhrase("starwarsvehicle_damage_owned_weapon", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())), GAS.Logging:FormatEntity(weapon))
		elseif (IsValid(owner)) then
			MODULE:LogPhrase("starwarsvehicle_damage_owned", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())))
		elseif (IsValid(weapon)) then
			MODULE:LogPhrase("starwarsvehicle_damage_weapon", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())), GAS.Logging:FormatEntity(weapon))
		else
			MODULE:LogPhrase("starwarsvehicle_damage", GAS.Logging:FormatPlayer(dmginfo:GetAttacker()), GAS.Logging:FormatEntity(ent), GAS.Logging:Highlight(math.floor(dmginfo:GetDamage())))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
