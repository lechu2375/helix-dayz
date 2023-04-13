local PLUGIN = PLUGIN
PLUGIN.name = "Polish electrican"
PLUGIN.description = "Nie weszłeś"
PLUGIN.author = "Lechu2375"

ix.util.Include("sh_hardcor.lua")
ix.util.Include("sv_rewards.lua")

if(SERVER) then
    resource.AddFile( "badend_r8b.wav" )
    resource.AddFile( "happyend_r8b.wav" )
    resource.AddFile( "stage1_r8b.wav" )
    resource.AddFile( "stage2_r8b.wav" )
    resource.AddFile( "stage3_r8b.wav" )
end
util.PrecacheSound("badend_r8b.wav")
util.PrecacheSound("happyend_r8b.wav")
util.PrecacheSound("stage1_r8b.wav")
util.PrecacheSound("stage2_r8b.wav")
util.PrecacheSound("stage3_r8b.wav")