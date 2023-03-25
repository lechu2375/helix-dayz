local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Steam Family Sharing"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("PlayerAuthed", "PlayerAuthed", function(ply)
		local timerName = "logging:SteamFam:" .. ply:SteamID64()
		local function check()
			if not IsValid(ply) then
				GAS:untimer(timerName)
				return
			elseif not ply:IsFullyAuthenticated() then
				return
			end
			
			GAS:untimer(timerName)

			local owner = ply:OwnerSteamID64()
			if owner and owner:match("^7%d+$") and owner ~= ply:SteamID64() then
				MODULE:LogPhrase("steamfam", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(owner))
			end
		end
		if ply:IsFullyAuthenticated() then
			check()
		else
			GAS:timer(timerName, 1, 0, check)
		end
	end)
end)

GAS.Logging:AddModule(MODULE)