if (not GAS.Logging.Modules:IsAddonInstalled("Pointshop Trading System")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Pointshop Trading"
MODULE.Name     = "Logs"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("TradingLogs","tradinglogs",function(log)
		MODULE:Log(log)
	end)
end)

GAS.Logging:AddModule(MODULE)
