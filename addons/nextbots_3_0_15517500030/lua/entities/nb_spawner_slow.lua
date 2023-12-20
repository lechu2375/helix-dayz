AddCSLuaFile()

ENT.Spawnable        = false
ENT.AdminSpawnable   = false

ENT.Base = "nb_spawner_base"
ENT.Type = "anim"

--Spawnmenu--
list.Set( "sean_nextbots", "nb_spawner_slow", 	
{	Name = "Slow Zombies", 
	Class = "nb_spawner_slow",
	Category = "Spawners"	
})

--Model--
ENT.Model = "models/props_junk/popcan01a.mdl"

--LIST--
ENT.NEXTBOTLIST = {"nb_shambler","nb_infested","nb_seeker_slow","nb_ghoul"}