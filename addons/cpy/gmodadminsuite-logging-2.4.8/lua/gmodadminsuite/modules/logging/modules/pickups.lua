local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Pickups"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:FeedbackHook("PlayerCanPickupWeapon", "Pickups:PlayerCanPickupWeapon", function(theirReturn, ply, wep)
		if theirReturn and theirReturn[1] == false then return end

		if (not IsValid(wep) or not IsValid(ply)) then return end
		if (ply:HasWeapon(wep:GetClass())) then return end
		if (wep:GetClass() == "gas_weapon_hands") then return end
		if (ply.GAS_Logging_WeaponPickups == false) then return end

		if (ROLE_TRAITOR ~= nil and WEPS ~= nil and ply.CanCarryWeapon ~= nil) then -- love that TTT has no standardized way of detecting whether it is running
			-- TTT spams this hook for some stupid reason, so here's a stupid fix
			if ply:HasWeapon(wep:GetClass()) then
				return
			elseif not ply:CanCarryWeapon(wep) then
				return
			elseif WEPS.IsEquipment(wep) and wep.IsDropped and (not ply:KeyDown(IN_USE)) then
				return
			end
		end

		MODULE:LogPhrase("picked_up_weapon", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(wep))
	end)
	MODULE:FeedbackHook("PlayerCanPickupItem", "Pickups:PlayerCanPickupItem", function(theirReturn, ply, item)
		if theirReturn and theirReturn[1] == false then return end

		if (
			not IsValid(item) or (
				(
					item:GetClass() == "item_healthvial" or item:GetClass() == "item_healthkit") and
					ply:Health() >= ply:GetMaxHealth()
				)
			or
				(
					item:GetClass() == "item_battery" and
					ply:Armor() >= ply:GetMaxArmor()
				)
		) then return end
		MODULE:LogPhrase("picked_up_item", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(item))
	end)

	local function Pickup_Antispam(ply)
		ply.GAS_Logging_WeaponPickups = false
		timer.Simple(2, function()
			if (not IsValid(ply)) then return end
			ply.GAS_Logging_WeaponPickups = nil
		end)
	end
	GAS:hook("PlayerSpawn", "Pickups:PlayerSpawn", Pickup_Antispam)
	GAS:hook("OnPlayerChangedTeam", "Pickups:OnPlayerChangedTeam", Pickup_Antispam)
end)

GAS.Logging:AddModule(MODULE)