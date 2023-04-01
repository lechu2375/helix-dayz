AddCSLuaFile()

ENT.Spawnable        = false
ENT.AdminSpawnable   = false

ENT.Base = "nb_spawner_base"
ENT.Type = "anim"

--Spawnmenu--
list.Set( "sean_nextbots", "nb_spawner_soldier", 	
{	Name = "Soldiers", 
	Class = "nb_spawner_soldier",
	Category = "Spawners"	
})

--Model--
ENT.Model = "models/props_junk/popcan01a.mdl"

--LIST--
ENT.NEXTBOTLIST = {"nb_soldier","nb_soldier_nade"}