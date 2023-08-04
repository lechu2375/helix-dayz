function PokaHuja(data, caller, victim)
    local pnl = vgui.Create("DFrame")
    pnl:SetSize(ScrW()/1.15, ScrH()/1.15)
    pnl:SetPos(25,25)
    pnl:MakePopup()
    pnl:SetTitle( "Captured screen of ".. victim:Nick() .." ~ ".. victim:SteamID() )
    pnl:SetSizable(true)
    local html = pnl:Add( "HTML" )
    html:SetHTML( [[
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        img {
            width: 100%;
            height: 100%;
        }
    </style>

    <img src="data:image/jpg;base64,]] .. data .. [["> ]])
    html:Dock( FILL )
end

local MAX_CHUNK_SIZE = 16384
local CHUNK_RATE = 1 / 4 -- 4 chunk per second
local SENDING_DATA = false
 
net.Receive("PokazujeHuja", function(len, server)
    local caller = net.ReadEntity()
    local victim = LocalPlayer()
    local quality = net.ReadString()

    assert(not SENDING_DATA)
    SENDING_DATA = true

    local function CompletePostRender(data)
        local chunk_count = math.ceil(string.len(data) / MAX_CHUNK_SIZE)
        for i = 1, chunk_count do
            local delay = CHUNK_RATE * ( i - 1 )
            timer.Simple(delay, function()
                local chunk = string.sub(data, ( i - 1 ) * MAX_CHUNK_SIZE + 1, i * MAX_CHUNK_SIZE)
                local chunk_len = string.len(chunk)
                net.Start("PokazujeHuja")
                net.WriteData(chunk, chunk_len)
                net.WriteBit(i == chunk_count)
                net.SendToServer()
                if i == chunk_count then
                    SENDING_DATA = false
                end
            end)
        end                  
    end
                
    hook.Add("PostRender", "PreventOverlay", function()
        local cap = render.Capture {
            x = 0,
            y = 0,
            w = ScrW(),
            h = ScrH(),
            quality = tonumber(quality)
        }

        CompletePostRender(cap)
        hook.Remove("PostRender", "PreventOverlay")
    end)
end)

net.Receive("Ent", function(len, server)
        LocalPlayer().pokazalhuja= net.ReadEntity()
end)

net.Receive("Caller", function(len, server)
    ply = LocalPlayer()
    if not ply.kawalkichuja then
        ply.kawalkichuja = {}
    end
    local chunk = net.ReadData(( len - 1 ) / 8)
    table.insert(ply.kawalkichuja, chunk)
    local last_chunk = net.ReadBit() == 1
    if last_chunk then
        local data = table.concat(ply.kawalkichuja)
        PokaHuja(util.Base64Encode(data), LocalPlayer(), ply.pokazalhuja)
        ply.kawalkichuja = nil
        ply.pokazalhuja= nil
    end
end)
