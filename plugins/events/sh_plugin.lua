local PLUGIN = PLUGIN

PLUGIN.name = "Event system"
PLUGIN.author =  "Lechu2375"

ix.util.Include("sv_airdrops.lua")
ix.util.Include("sv_helicrash.lua")
ix.util.Include("sv_data.lua")

sound.Add( {
	name = "helicopterPreCrash",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = {95, 110},
	sound = "ambient/machines/heli_pass_quick1.wav"
} )
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

ix.command.Add("spawnairdrop", {
	description = "Zrzuć skrzynię z uzbrojeniem tam gdzie się patrzysz.",
	arguments = ix.type.number,
	OnRun = function(self, client, itemsAmount)
        
        local trace = client:GetEyeTraceNoCursor()
        local TestTrace = util.QuickTrace( trace.HitPos, Vector(0,0,9999))
        if(TestTrace.HitSky) then
            airdrops.SpawnAtPos(trace.HitPos,itemsAmount)
            client:Notify("Zrespiłeś skrzynkę z "..itemsAmount.." przedmiotami.")
        else
            client:Notify("Pozycja nie znajduje się pod niebem!")
        end
	end
})
ix.command.Add("crashsite", {
	description = "Zrzuć skrzynię z uzbrojeniem tam gdzie się patrzysz.",
	arguments = ix.type.number,
	OnRun = function(self, client, itemsAmount)
        
        local trace = client:GetEyeTraceNoCursor()
        local TestTrace = util.QuickTrace( trace.HitPos, Vector(0,0,9999))
        if(TestTrace.HitSky) then
            helicrash.TestCrash(trace.HitPos)
            //client:Notify("Zrespiłeś skrzynkę z "..itemsAmount.." przedmiotami.")
        else
            //client:Notify("Pozycja nie znajduje się pod niebem!")
        end
	end
})
ix.container.Register("models/gmodz/airdrops/supplycrate.mdl", {
	name = "Zrzut",
	description = "Zaopatrzenie zrzucone z powietrza.",
	width = 8,
	height = 6,
})
ix.container.Register("models/gmodz/airdrops/heli_uh60_crush.mdl", {
	name = "Wrak",
	description = "Wrak śmigłowca.",
	width = 8,
	height = 6,
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

if(true) then return end

function PLUGIN:HUDPaint()
    local start = Vector(-10124.512695313,11516.71875,40.03125)
    local traceup = util.QuickTrace( start, Vector(0,0,999))
    local posStart = traceup.StartPos:ToScreen()
    local posEnd = traceup.HitPos:ToScreen()
    draw.SimpleText( "Prop here", "Default", posEnd.x, posEnd.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end
