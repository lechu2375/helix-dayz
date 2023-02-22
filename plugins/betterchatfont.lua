PLUGIN.name = "Yelling and whispering chat size"
PLUGIN.author = "Lechu2375"
function PLUGIN:InitializedChatClasses()



		-- Whisper chat.
		ix.chat.Register("w", {
			format = "%s whispers \"%s\"",
			GetColor = function(self, speaker, text)
				local color = ix.chat.classes.ic:GetColor(speaker, text)

				-- Make the whisper chat slightly darker than IC chat.
				return Color(color.r - 35, color.g - 35, color.b - 35)
			end,
			CanHear = ix.config.Get("chatRange", 280) * 0.25,
			prefix = {"/W", "/Whisper"},
			description = "@cmdW",
			indicator = "chatWhispering",
            font  = "ixSmallFont"
		})

		-- Yelling out loud.
		ix.chat.Register("y", {
			format = "%s yells \"%s\"",
			GetColor = function(self, speaker, text)
				local color = ix.chat.classes.ic:GetColor(speaker, text)

				-- Make the yell chat slightly brighter than IC chat.
				return Color(color.r + 35, color.g + 35, color.b + 35)
			end,
			CanHear = ix.config.Get("chatRange", 280) * 2,
			prefix = {"/Y", "/Yell"},
			description = "@cmdY",
			indicator = "chatYelling",
            font  = "ixBigFont"
		})

end