bLogs = {}

function bLogs:Module()
	return GAS.Logging:MODULE()
end

function bLogs:FormatPlayer(ply)
	return GAS.Logging:FormatPlayer(ply)
end

function bLogs:Highlight(str)
	return GAS.Logging:Highlight(str)
end

function bLogs:FormatEntity(ent)
	return GAS.Logging:FormatEntity(ent)
end

function bLogs:FormatCurrency(amnt)
	return GAS.Logging:FormatMoney(amnt)
end

function bLogs:FormatMoney(amnt)
	return GAS.Logging:FormatMoney(amnt)
end

function bLogs:FormatVehicle(ent)
	return GAS.Logging:FormatEntity(ent)
end

function bLogs:Escape(str)
	return GAS.Logging:Escape(str)
end

function bLogs:AddModule(MODULE)
	GAS:print("[bLogs] Registered backwards-compatible module from old bLogs: " .. MODULE.Category .. " -> " .. MODULE.Name)
	
	if (GAS.Logging.OpenPermissions) then
		local category = GAS.Logging.OpenPermissions.RegisteredCategories[MODULE.Category]
		if (not category) then
			GAS.Logging.OpenPermissions.RegisteredCategories[MODULE.Category] = GAS.Logging.OpenPermissions:AddToTree({
				Label = MODULE.Category,
				Color = MODULE.Colour,
				Value = MODULE.Category
			})
			category = GAS.Logging.OpenPermissions.RegisteredCategories[MODULE.Category]
		end
		if (not GAS.Logging.OpenPermissions.RegisteredModules[MODULE.Category .. MODULE.Name]) then
			GAS.Logging.OpenPermissions.RegisteredModules[MODULE.Category .. MODULE.Name] = true
			category:AddToTree({
				Label = MODULE.Name,
				Color = MODULE.Colour,
				Value = MODULE.Name,
				Tip = "Can see logs in " .. MODULE.Name .. "?",
			})
		end
	end

	return GAS.Logging:AddModule(MODULE)
end