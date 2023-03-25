if (not GAS.Logging.Modules:IsAddonInstalled("Wyozi Cinema Kit")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Wyozi Cinema Kit"
MODULE.Name     = "Video Queues"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("WCKVideoQueued","WCK",function(queuetable)
		MODULE:LogPhrase("wyozi_cinema_queued", GAS.Logging:FormatPlayer(queuetable.player), GAS.Logging:Highlight(queuetable.video_title), GAS.Logging:Highlight(queuetable.video_url), GAS.Logging:Highlight(queuetable.cinema))
	end)
end)

GAS.Logging:AddModule(MODULE)
