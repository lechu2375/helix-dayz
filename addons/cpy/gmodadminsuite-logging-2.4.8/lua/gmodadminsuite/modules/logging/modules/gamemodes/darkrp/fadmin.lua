if (not FAdmin) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "FAdmin"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	local logging = GetConVar("FAdmin_logging")

	GAS_Logging_FAdmin_Log = GAS_Logging_FAdmin_Log or FAdmin.Log

	FAdmin.Log = function(text, ...)
		if (logging:GetBool() and text and text ~= "" and debug.traceback():find("'FireNotification'")) then
			MODULE:Log(text)
		end
		return GAS_Logging_FAdmin_Log(text, ...)
	end
end)

GAS.Logging:AddModule(MODULE)
