PLUGIN.name = "Radiostation"
PLUGIN.name = "Radio morenka"


ix.util.Include("sh_voicechannel.lua")
voicechannel.CreateBand("Radio")

resource.AddFile("models/mic.mdl")
resource.AddFile("materials/models/Mic/mic.vmt")

ix.util.Include("sv_plugin.lua")