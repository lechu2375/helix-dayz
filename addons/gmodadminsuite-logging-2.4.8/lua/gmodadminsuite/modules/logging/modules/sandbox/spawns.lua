local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "Effects"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedEffect","spawnedeffect",function(ply,model)
		MODULE:LogPhrase("spawned_effect", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatProp(model))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "NPCs"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedNPC","spawnednpc",function(ply,ent)
		MODULE:LogPhrase("spawned_npc", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "Props"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedProp","spawnedprop",function(ply,model)
		MODULE:LogPhrase("spawned_prop", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatProp(model))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "Ragdolls"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedRagdoll","spawnedragdoll",function(ply,model)
		MODULE:LogPhrase("spawned_ragdoll", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatProp(model))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "SENTs"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedSENT","spawnedsent",function(ply,ent)
		MODULE:LogPhrase("spawned_sent", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "SWEPs"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedSWEP","spawnedswep",function(ply,ent)
		MODULE:LogPhrase("spawned_swep", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "Vehicles"
MODULE.Colour   = Color(0,150,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawnedVehicle","spawnedswep",function(ply,ent)
		MODULE:LogPhrase("spawned_vehicle", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
	end)
end)

GAS.Logging:AddModule(MODULE)