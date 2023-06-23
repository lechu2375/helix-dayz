if (not GAS.Logging.Modules:IsAddonInstalled("Medic / Armor NPC")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Medic / Armor NPC"
MODULE.Name     = "Bought Health"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("bLogs_Maverick_BuyHealth","Maverick_BuyHealth",function(activator,MavHealthCost)
		if (not IsValid(activator)) then return end
		MODULE:LogPhrase("npc_health_bought", GAS.Logging:FormatPlayer(activator), GAS.Logging:FormatMoney(MavHealthCost))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Medic / Armor NPC"
MODULE.Name     = "Bought Armor"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("bLogs_Maverick_BuyArmor","Maverick_BuyArmor",function(activator,MavArmorCost)
		if (not IsValid(activator)) then return end
		MODULE:LogPhrase("npc_armor_bought", GAS.Logging:FormatPlayer(activator), GAS.Logging:FormatMoney(MavArmorCost))
	end)
end)

GAS.Logging:AddModule(MODULE)