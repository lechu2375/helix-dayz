ix.leveling.config = {maxLevel = 50, passiveInterval = 200, passiveAmount = 10, levelMultiplier = 75, intelBonus = 0.02}

function ix.leveling.giveXP(player, XP, silent, muteSound)
	local character = player:GetCharacter()

	if !character then return end

	local CXP = character:GetData("XP", 0)
	local CLV = character:GetData("level", 0)
	local SKP = character:GetData("skillPoints", 0)

	local XPR = ix.leveling.requiredXP(CLV + 1)

	XP = math.Round(XP * (1 + (ix.leveling.config.intelBonus)), 2)
	CXP = CXP + XP

	if CXP >= XPR then
		CLV = CLV + 1
		character:SetData("level", CLV)

		character:SetData("skillPoints", SKP + 1)

		player:Notify("You've reached level " .. CLV )
	elseif !silent then
		netstream.Start(player, "getXP", XP, muteSound or false)
	end

	character:SetData("XP", CXP)
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	local id = client:SteamID64()
	if !timer.Exists(id .. "_leveling") then
		timer.Create(id .. "_leveling", ix.leveling.config.passiveInterval, 0, function()
			if IsValid(client) then
				ix.leveling.giveXP(client, ix.leveling.config.passiveAmount, true)
			else
				timer.Remove(id .. "_leveling")
			end
		end)
	end
end

function ix.leveling.RecalculateLevel(char)
	if char:GetData("level", 0) > ix.leveling.spike then
		local levelShouldBe
		local currentLevel = char:GetData("level", 0)
		local currentXP = char:GetData("XP", 0)

		for potentialLevel = currentLevel, 1, -1 do
			local xpRequired = ix.leveling.requiredXP(potentialLevel)

			if xpRequired <= currentXP then
				levelShouldBe = potentialLevel
				break
			end
		end

		if levelShouldBe != currentLevel then
			print(char:GetName() .. " is currently level " .. currentLevel .. " but should be level " .. levelShouldBe .. " fixing and resetting skills.")

			char:SetData("level", levelShouldBe)
			char:SetData("skillPoints", levelShouldBe)

			return true
		end
	end
end

hook.Add("PlayerLoadedCharacter", "RecalculateLevel", function(ply, char, oldChar)
	if ix.leveling.RecalculateLevel(char) then
		ply:ChatPrint("Your skills have been reset due to your level being readjusted to fit with the new leveling algorithm.")
	end
end)
