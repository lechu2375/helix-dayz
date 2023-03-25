local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Battering Ram"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("onDoorRamUsed","batteringram",function(success,ply,trace)
		local door = trace.Entity
		if (success) then
			if (IsValid(door:getDoorOwner())) then
				if (door:IsVehicle()) then
					MODULE:LogPhrase("darkrp_batteringram_owned_success", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(door:GetOwner() or door:GetCreator()))
				else
					MODULE:LogPhrase("darkrp_batteringram_owned_door_success", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(door:getDoorOwner()))
				end
			else
				if (door:IsVehicle()) then
					MODULE:LogPhrase("darkrp_batteringram_success", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(door))
				else
					MODULE:LogPhrase("darkrp_batteringram_door_success", GAS.Logging:FormatPlayer(ply))
				end
			end
		else
			if (IsValid(door:getDoorOwner())) then
				if (door:IsVehicle()) then
					MODULE:LogPhrase("darkrp_batteringram_owned_failed", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(door:GetOwner() or door:GetCreator()))
				else
					MODULE:LogPhrase("darkrp_batteringram_owned_door_failed", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(door:getDoorOwner()))
				end
			else
				if (door:IsVehicle()) then
					MODULE:LogPhrase("darkrp_batteringram_failed", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(door))
				else
					MODULE:LogPhrase("darkrp_batteringram_door_failed", GAS.Logging:FormatPlayer(ply))
				end
			end
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
