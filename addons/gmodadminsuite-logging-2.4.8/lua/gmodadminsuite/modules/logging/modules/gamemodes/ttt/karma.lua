local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "Karma Kicking"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:FeedbackHook("TTTKarmaLow", "tttkarmakick", function(theirReturn, ply)
		if theirReturn and theirReturn[1] == false then return end
		MODULE:LogPhrase("ttt_karma", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
