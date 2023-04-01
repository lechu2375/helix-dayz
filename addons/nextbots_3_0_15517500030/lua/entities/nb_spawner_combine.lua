AddCSLuaFile()

ENT.Spawnable        = false
ENT.AdminSpawnable   = false

ENT.Base = "nb_spawner_base"
ENT.Type = "anim"

--Spawnmenu--
list.Set( "sean_nextbots", "nb_spawner_combine", 	
{	Name = "Combines", 
	Class = "nb_spawner_combine",
	Category = "Spawners"	
})

--Model--
ENT.Model = "models/props_junk/popcan01a.mdl"

--LIST--
ENT.NEXTBOTLIST = {"nb_combine",
"nb_combine",
"nb_combine",
"nb_combine_shotgun",
"nb_combine_prison",
"nb_combine_prison_shotgun",
"nb_combine_elite",
"nb_combine_juggernaut"}