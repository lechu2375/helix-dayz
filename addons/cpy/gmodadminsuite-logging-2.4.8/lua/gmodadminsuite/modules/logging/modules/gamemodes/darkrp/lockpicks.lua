local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Lockpicking"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("lockpickStarted","lockpick_started",function(ply,ent)
		local owner = ent:getDoorOwner()
		if (IsValid(owner)) then
			if (owner == ply) then
				if (ent:isDoor()) then
					MODULE:LogPhrase("darkrp_started_lockpick_own_door", GAS.Logging:FormatPlayer(ply))
				else
					MODULE:LogPhrase("darkrp_started_lockpick_own_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
				end
			else
				if (ent:isDoor()) then
					MODULE:LogPhrase("darkrp_started_lockpick_owned_door", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(owner))
				else
					MODULE:LogPhrase("darkrp_started_lockpick_owned_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner))
				end
			end
		else
			if (ent:isDoor()) then
				MODULE:LogPhrase("darkrp_started_lockpick_unowned_door", GAS.Logging:FormatPlayer(ply))
			else
				MODULE:LogPhrase("darkrp_started_lockpick_unowned_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
			end
		end
	end)

	MODULE:Hook("onLockpickCompleted","lockpick_started",function(ply,success,ent)
		local owner = ent:getDoorOwner()
		if (success) then
			if (IsValid(owner)) then
				if (owner == ply) then
					if (ent:isDoor()) then
						MODULE:LogPhrase("darkrp_successfully_lockpicked_own_door", GAS.Logging:FormatPlayer(ply))
					else
						MODULE:LogPhrase("darkrp_successfully_lockpicked_own_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
					end
				else
					if (ent:isDoor()) then
						MODULE:LogPhrase("darkrp_successfully_lockpicked_owned_door", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(owner))
					else
						MODULE:LogPhrase("darkrp_successfully_lockpicked_owned_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner))
					end
				end
			else
				if (ent:isDoor()) then
					MODULE:LogPhrase("darkrp_successfully_lockpicked_unowned_door", GAS.Logging:FormatPlayer(ply))
				else
					MODULE:LogPhrase("darkrp_successfully_lockpicked_unowned_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
				end
			end
		else
			if (IsValid(owner)) then
				if (owner == ply) then
					if (ent:isDoor()) then
						MODULE:LogPhrase("darkrp_failed_lockpick_own_door", GAS.Logging:FormatPlayer(ply))
					else
						MODULE:LogPhrase("darkrp_failed_lockpick_own_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
					end
				else
					if (ent:isDoor()) then
						MODULE:LogPhrase("darkrp_failed_lockpick_owned_door", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(owner))
					else
						MODULE:LogPhrase("darkrp_failed_lockpick_owned_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatPlayer(owner))
					end
				end
			else
				if (ent:isDoor()) then
					MODULE:LogPhrase("darkrp_failed_lockpick_unowned_door", GAS.Logging:FormatPlayer(ply))
				else
					MODULE:LogPhrase("darkrp_failed_lockpick_unowned_entity", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
				end
			end
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
