if (not GAS.Logging.Modules:IsAddonInstalled("PAC3")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "PAC3"
MODULE.Name     = "Outfit Change"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PACSubmitAcknowledged","pacoutfit",function(ply, allowed, reason, name, data)
		if (allowed) then
			MODULE:LogPhrase("pac_outfit", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(name))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
