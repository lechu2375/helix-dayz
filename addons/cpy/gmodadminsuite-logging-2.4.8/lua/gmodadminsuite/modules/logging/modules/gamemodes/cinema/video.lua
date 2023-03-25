local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Cinema"
MODULE.Name     = "Video Queued"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("PostVideoQueued", "videoqueued", function(vid, cinema)
		local d = vid:Duration()
		local s = d % 60
		local m = math.floor((d / 60) % 60)
		local h = math.floor(d / 60 / 60)

		MODULE:LogPhrase(
			"cinema_video_queued",
			GAS.Logging:Highlight(cinema:Name()),
			GAS.Logging:FormatPlayer(vid:GetOwner()),
			GAS.Logging:Highlight(string.format("%02u:%02u:%02u", h, m, s)),
			GAS.Logging:Highlight(vid:Title()),
			GAS.Logging:Escape(vid:Data())
		)
	end)
end)

GAS.Logging:AddModule(MODULE)
