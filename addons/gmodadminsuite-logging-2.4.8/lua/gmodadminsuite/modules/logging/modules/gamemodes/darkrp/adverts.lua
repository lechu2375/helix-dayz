local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Adverts"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerAdverted","advert",function(ply,arg)
		MODULE:Log(GAS.Logging:FormatPlayer(ply) .. ": " .. GAS.Logging:Escape(arg))
	end)
end)

GAS.Logging:AddModule(MODULE)
