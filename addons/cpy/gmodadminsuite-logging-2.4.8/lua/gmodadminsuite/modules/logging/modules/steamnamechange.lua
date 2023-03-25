local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Steam Name Changes"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	gameevent.Listen("player_changename")
	MODULE:Hook("player_changename","player_changename",function(data)
		local ply = Player(data.userid)
		if (not IsValid(ply)) then return end

		MODULE:LogPhrase("steam_name_changed", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(data.oldname), GAS.Logging:Highlight(data.newname))
	end)
end)

GAS.Logging:AddModule(MODULE)