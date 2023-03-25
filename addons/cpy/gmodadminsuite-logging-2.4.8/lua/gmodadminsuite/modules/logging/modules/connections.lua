local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Connections"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	gameevent.Listen("player_connect")

	MODULE:Hook("player_connect","player_connect",function(data)
		if (tonumber(data.bot) == 1) then return end
		local account_id
		if (data.networkid:find("^STEAM_%d:%d:%d+$")) then
			account_id = GAS:SteamIDToAccountID(data.networkid)
		elseif (data.networkid:find("^7656119%d+$")) then
			account_id = GAS:SteamID64ToAccountID(data.networkid)
		else
			return
		end

		local ipaddress = data.address
		if (data.address:find("^192%.168")) then
			ipaddress = game.GetIPAddress()
		end
		ipaddress = (ipaddress:gsub(":%d+$",""))

		local function log_connection(country)
			if (country and country ~= "(unknown!)") then
				MODULE:LogPhrase("connected_from_country", GAS.Logging:FormatPlayer(account_id), GAS.Logging:FormatCountry(country))
			else
				MODULE:LogPhrase("connected", GAS.Logging:FormatPlayer(account_id))
			end
		end
		http.Fetch("http://lib.venner.io/service/geoip.php?ip=" .. ipaddress, function(body, size, headers, httpCode)
			if (httpCode == 200 and size > 0 and body:sub(1,4) == "#!# ") then
				log_connection(body:sub(5))
			else
				log_connection(false)
			end
		end, function(...)
			PrintTable({...})
			log_connection(false)
		end)
	end)

	MODULE:Hook("PlayerInitialSpawn", "PlayerInitialSpawn", function(ply)
		MODULE:LogPhrase("finished_connecting", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)

--###################################################################################--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Disconnections"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	gameevent.Listen("player_disconnect")

	MODULE:Hook("player_disconnect","player_disconnect",function(data)
		local account_id
		if (data.networkid:find("^STEAM_%d:%d:%d+$")) then
			account_id = GAS:SteamIDToAccountID(data.networkid)
		elseif (data.networkid:find("^7656119%d+$")) then
			account_id = GAS:SteamID64ToAccountID(data.networkid)
		else
			return
		end
		local ply = player.GetByAccountID(account_id)
		if (IsValid(ply)) then
			ply = GAS.Logging:FormatPlayer(ply)
		else
			ply = GAS.Logging:FormatPlayer(account_id)
		end
		MODULE:LogPhrase("disconnected", ply, GAS.Logging:Highlight((data.reason:gsub("%.$",""):gsub("\\n"," "):gsub(" $",""))))
	end)
end)

GAS.Logging:AddModule(MODULE)

--###################################################################################--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Respawns"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerSpawn", "PlayerSpawn", function(ply)
		if (ply.GAS_FirstSpawn ~= true) then
			ply.GAS_FirstSpawn = true
		else
			MODULE:LogPhrase("respawned", GAS.Logging:FormatPlayer(ply))
		end
	end)
end)

GAS.Logging:AddModule(MODULE)