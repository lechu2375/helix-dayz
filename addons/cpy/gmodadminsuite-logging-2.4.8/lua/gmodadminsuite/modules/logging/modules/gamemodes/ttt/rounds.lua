local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "Rounds"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("TTTPrepareRound", "TTTPrepareRound", function()
		MODULE:LogPhrase("round_preparing")
	end)

	MODULE:Hook("TTTBeginRound", "TTTBeginRound", function()
		MODULE:LogPhrase("round_begin")
	end)

	MODULE:Hook("TTTEndRound", "TTTEndRound", function(result)
		if (result == WIN_TRAITOR) then
			MODULE:LogPhrase("ttt_win_traitor")
		elseif (result == WIN_INNOCENT) then
			MODULE:LogPhrase("ttt_win_innocent")
		elseif (result == WIN_TIMELIMIT) then
			MODULE:LogPhrase("ttt_win_timelimit")
		else
			MODULE:LogPhrase("round_end")
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
