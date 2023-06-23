if (not GAS.Logging.Modules:IsAddonInstalled("Wyozi DJ Kit")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Wyozi DJ Kit"
MODULE.Name     = "Audio Queued"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("WDJAudioQueued","WDJAudioQueued",function(queuedAudioInfo)
		MODULE:LogPhrase("wyozi_dj_queued", GAS.Logging:FormatPlayer(queuedAudioInfo.player), GAS.Logging:Highlight(queuedAudioInfo.audio_title), GAS.Logging:Highlight(queuedAudioInfo.audio_url), GAS.Logging:Highlight(queuedAudioInfo.channel_name))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Wyozi DJ Kit"
MODULE.Name     = "Channel Renamed"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("WDJChannelRenamed","WDJChannelRenamed",function(channelRenameInfo)
		MODULE:LogPhrase("wyozi_dj_channel_rename", GAS.Logging:FormatPlayer(channelRenameInfo.player), GAS.Logging:Highlight(channelRenameInfo.new_name))
	end)
end)

GAS.Logging:AddModule(MODULE)
