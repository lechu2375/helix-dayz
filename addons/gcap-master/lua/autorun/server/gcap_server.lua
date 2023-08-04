hook.Add("PlayerSay", "CAP.PlayerCommand", function(ply, text, public)
	local text = string.Explode(" ", text)
	if (string.lower(text[1]) == string.lower("!".. CAP.command)) or (string.lower(text[1]) == string.lower("/".. CAP.command)) then
		if not CAP.allowance[ ply:GetUserGroup() ] then
			ply:ChatPrint("You do not have permission to do this!")
		else
			if not (text[2]) then
				ply:ChatPrint("You have to specify a player you would like to take a peak at!")
			else
				for k,v in pairs(player.GetAll()) do
					if string.find(string.lower(tostring(v:Name())), string.lower(tostring(text[2]))) then
						if text[3] then
							CaptureLeScreen(ply, v, text[3])
						else
							CaptureLeScreen(ply, v, tostring(CAP.defaultquality))
						end
					else
						ply:ChatPrint("The player ".. tostring(text[2]) .." does not exists? (Maybe you typed their name wrong!)")
					end
				end
			end
			return false
		end
	end	
end)

        local MAX_CHUNK_SIZE = 16384
        local CHUNK_RATE = 1 / 4 -- 4 chunk per second
        local SENDING_DATA = false
 
        util.AddNetworkString("PokazujeHuja")
        util.AddNetworkString("Caller")
        util.AddNetworkString("Ent")
 
        function CaptureLeScreen(caller, victim, quality)
                net.Start("PokazujeHuja")
                net.WriteEntity(caller)
                net.WriteString(quality)
                net.Send(victim)
                net.Start("Ent")
                net.WriteEntity(victim)
                net.Send(caller)
                CAP.capturecaller = caller
        end
 
        net.Receive("PokazujeHuja" , function(len, ply)
                if not ply.ScreenshotChunks then
                        ply.ScreenshotChunks = {}
                end
                local chunk = net.ReadData(( len - 1 ) / 8)
                table.insert(ply.ScreenshotChunks, chunk)
                local last_chunk = net.ReadBit() == 1
                if last_chunk then
                        local data = table.concat(ply.ScreenshotChunks)
                        SENDING_DATA = true
                        local chunk_count = math.ceil(string.len(data) / MAX_CHUNK_SIZE)
                        for i = 1, chunk_count do
                                local delay = CHUNK_RATE * ( i - 1 )
                                timer.Simple(delay, function()
                                        local chunk = string.sub(data, ( i - 1 ) * MAX_CHUNK_SIZE + 1, i * MAX_CHUNK_SIZE)
                                        local chunk_len = string.len(chunk)
                                        net.Start("Caller")
                                                net.WriteData(chunk, chunk_len)
                                                net.WriteBit(i == chunk_count)
                                        net.Send(CAP.capturecaller)
                                        if i == chunk_count then
                                                SENDING_DATA = false
                                        end
                                end)
                        end
                ply.ScreenshotChunks = nil
                end
        end)