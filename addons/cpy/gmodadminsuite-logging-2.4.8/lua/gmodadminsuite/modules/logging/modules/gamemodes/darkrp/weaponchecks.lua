local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Weapon Checker"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerWeaponsChecked","weaponschecked",function(checker,target)
		MODULE:LogPhrase("darkrp_weapons_checked", GAS.Logging:FormatPlayer(checker), GAS.Logging:FormatPlayer(target))
	end)

	MODULE:Hook("playerWeaponsConfiscated","weaponsconfiscated",function(checker,target)
		MODULE:LogPhrase("darkrp_weapons_confiscated", GAS.Logging:FormatPlayer(checker), GAS.Logging:FormatPlayer(target))
	end)

	MODULE:Hook("playerWeaponsReturned","weaponsreturned",function(checker,target)
		MODULE:LogPhrase("darkrp_weapons_returned", GAS.Logging:FormatPlayer(checker), GAS.Logging:FormatPlayer(target))
	end)
end)

GAS.Logging:AddModule(MODULE)
