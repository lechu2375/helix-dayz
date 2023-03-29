PLUGIN.name = "Stats"
PLUGIN.author = "Lechu2375"
PLUGIN.description = "Includes useless stats for character"

ix.char.RegisterVar("distance", {
	field = "distance",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})
ix.util.Include("sv_distancer.lua")

ix.char.RegisterVar("steps", {
	field = "steps",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})
ix.util.Include("sv_stepcounter.lua")
ix.char.RegisterVar("playtime", {
	field = "playtime",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})
ix.util.Include("sv_playtime.lua")
