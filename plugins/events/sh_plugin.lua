local PLUGIN = PLUGIN

PLUGIN.name = "Event system"
PLUGIN.author =  "Lechu2375"
ix.util.Include("sv_data.lua")
local evci = PLUGIN.eventCityInvasion
local function printnpcs()
    local ents = ents.GetAll()
    local count = 0
    for _,v in pairs(ents) do
        if (v:IsNextBot()) then count = count +1 end
    end
    print(count)
end
ix.command.Add("cityinvasion1", {
	description = "Event #1 Spawns bunch of zombies that run to the one of the mainest building in city",
	arguments = {ix.type.number,ix.type.number},
	OnRun = function(self, client, waveSize, wavesAmount)
        evci.StartEvent(waveSize, wavesAmount)
        client:Notify("Rozpoczęto event: Inwazja na miasto.")
	end
})


concommand.Add( "pos", function( ply, cmd, args )
    ply.getpostable = ply.getpostable or {}
    table.insert(ply.getpostable,ply:GetEyeTrace().HitPos)
    print("ok"..#ply.getpostable)
end )

concommand.Add( "resetpos", function( ply, cmd, args )
    ply.getpostable = {}
    print("ok")

end )

concommand.Add( "printpos", function( ply, cmd, args )
  
    print(table.ToString(ply.getpostable,"",true))
end )