local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "DNA"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("TTTFoundDNA","tttdna",function(ply,dna_owner,ent)
		if (ent:IsWeapon()) then
			MODULE:LogPhrase("ttt_founddna", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(dna_owner), GAS.Logging:FormatEntity(ent))
		else
			MODULE:LogPhrase("ttt_founddna_corpse", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(dna_owner))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
