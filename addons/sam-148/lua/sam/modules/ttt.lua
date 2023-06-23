if SAM_LOADED then return end

local run = function(fn)
	if not GAMEMODE then
		timer.Simple(0, fn)
	else
		fn()
	end
end

run(function()
	if engine.ActiveGamemode() ~= "terrortown" then return end

	local sam, command, language = sam, sam.command, sam.language

	command.set_category("TTT")

	command.new("setslays")
		:SetPermission("setslays", "admin")

		:AddArg("player", {single_target = true})
		:AddArg("number", {hint = "amount", optional = true, min = 1, default = 1, round = true})

		:Help("setslays_help")

		:OnExecute(function(ply, targets, amount)
			targets[1]:sam_set_pdata("slays_amount", amount)

			sam.player.send_message(nil, "setslays", {
				A = ply, T = targets, V = amount
			})
		end)
	:End()

	command.new("removeslays")
		:SetPermission("removeslays", "admin")

		:AddArg("player", {single_target = true})

		:Help("removeslays_help")

		:OnExecute(function(ply, targets, amount)
			local target = targets[1]
			target:sam_set_pdata("slays_amount", nil)
			target:SetForceSpec(false)

			sam.player.send_message(nil, "removeslays", {
				A = ply, T = targets
			})
		end)
	:End()

	OldBeginRound = OldBeginRound or BeginRound
	function BeginRound(...)
		local players = player.GetAll()
		for i = 1, #players do
			local ply = players[i]

			local slays = ply:sam_get_pdata("slays_amount")
			if not slays then continue end

			if not ply:IsSpec() then
				ply:Kill()
			end

			GAMEMODE:PlayerSpawnAsSpectator(ply)

			ply:SetTeam(TEAM_SPEC)
			ply:SetForceSpec(true)
			ply:Spawn()

			ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here

			slays = slays - 1

			if slays == 0 then
				timer.Simple(0, function()
					ply:SetForceSpec(false)
				end)
				ply:sam_set_pdata("slays_amount", nil)
			else
				ply:sam_set_pdata("slays_amount", slays)
			end

			sam.player.send_message(nil, "setslays_slayed", {
				T = {ply}, V = slays
			})
		end

		return OldBeginRound(...)
	end
end)