local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Laws"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("addLaw","addlaw",function(_,law,ply)
		if (IsValid(ply)) then
			MODULE:LogPhrase("darkrp_added_law", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(law))
		else
			MODULE:LogPhrase("darkrp_added_law", GAS.Logging:Highlight("Unknown"), GAS.Logging:Highlight(law))
		end
	end)
	MODULE:Hook("removeLaw","removeLaw",function(_,law,ply)
		if (IsValid(ply)) then
			MODULE:LogPhrase("darkrp_removed_law", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(law))
		else
			MODULE:LogPhrase("darkrp_removed_law", GAS.Logging:Highlight("Unknown"), GAS.Logging:Highlight(law))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
