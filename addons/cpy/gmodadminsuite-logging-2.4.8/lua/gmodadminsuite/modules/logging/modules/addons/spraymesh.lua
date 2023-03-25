if (not GAS.Logging.Modules:IsAddonInstalled("SprayMesh")) then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "SprayMesh"
MODULE.Name     = "Sprays"
MODULE.Colour   = Color(130,0,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSprayMesh","spraymesh",function(ply)
		MODULE:LogPhrase("spraymesh", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(ply:GetInfo("SprayMesh_URL")))
	end)
end)

GAS.Logging:AddModule(MODULE)
