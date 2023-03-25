local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "Bodies"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("TTTBodyFound","tttbody",function(ply,deadply,rag)
		MODULE:LogPhrase("ttt_foundbody", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(deadply))
	end)
end)

GAS.Logging:AddModule(MODULE)
