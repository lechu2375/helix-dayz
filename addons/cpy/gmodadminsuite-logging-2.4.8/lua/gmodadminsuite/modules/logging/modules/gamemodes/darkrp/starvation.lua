if (GAS.Logging.GamemodeModulesEnabled.DarkRP and DarkRP and DarkRP.disabledDefaults.modules.hungermod) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Starvation"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerStarved","starved",function(ply)
		MODULE:LogPhrase("darkrp_starved", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
