if (not GAS.Logging.Modules:IsAddonInstalled("Cuffs - Handcuffs and Restraints")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Cuffs"
MODULE.Name     = "Handcuffs"
MODULE.Colour   = Color(255,130,0)

MODULE:Setup(function()
	MODULE:Hook("OnHandcuffed","handcuffed",function(cuffer,cuffed)
		MODULE:LogPhrase("handcuffed", GAS.Logging:FormatPlayer(cuffer), GAS.Logging:FormatPlayer(cuffed))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Cuffs"
MODULE.Name     = "Cuff Breaks"
MODULE.Colour   = Color(255,130,0)

MODULE:Setup(function()
	MODULE:Hook("OnHandcuffBreak","cuffbreaks",function(cuffed,_,mate)
		if (IsValid(mate)) then
			MODULE:LogPhrase("handcuffs_broken_by", GAS.Logging:FormatPlayer(mate), GAS.Logging:FormatPlayer(cuffed))
		else
			MODULE:LogPhrase("handcuffs_broken", GAS.Logging:FormatPlayer(cuffed))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
