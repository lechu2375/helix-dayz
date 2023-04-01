AddCSLuaFile()

ENT.Spawnable        = false
ENT.AdminSpawnable   = false

ENT.Base = "nb_spawner_base"
ENT.Type = "anim"

--Spawnmenu--
list.Set( "sean_nextbots", "nb_spawner_skeleton", 	
{	Name = "Skeletons", 
	Class = "nb_spawner_skeleton",
	Category = "Spawners"	
})

--Model--
ENT.Model = "models/props_junk/popcan01a.mdl"

--LIST--
ENT.NEXTBOTLIST = {"nb_skeleton_zombie","nb_skeleton_fast"}