if SAM_LOADED then return end

-- DONT EVER TALK TO ME ABOUT THIS CODE

local sam, command = sam, sam.command

command.set_category("Voting")

local start_vote, end_vote
if SERVER then
	local vote_on = false
	local options, players_voted

	local shuffle = function(tbl) -- https://gist.github.com/Uradamus/10323382
		for i = #tbl, 2, -1 do
			local j = math.random(i)
			tbl[i], tbl[j] = tbl[j], tbl[i]
		end
		return tbl
	end

	end_vote = function(ply, callback)
		if not vote_on then
			return ply:sam_add_text(color_white, "There is no vote to end.")
		end

		vote_on = false

		sam.set_global("Vote", nil)

		if callback then
			local tbl = {}
			local total_count = 0

			for i = 1, #options do
				local count = sam.get_global("Votings" .. i)
				total_count = total_count + count
				table.insert(tbl, {i, count})
				sam.set_global("Votings" .. i, nil)
			end

			if total_count == 0 then
				return sam.player.add_text(nil, color_white, "The vote have been canceled because nobody voted.")
			end

			table.sort(shuffle(tbl), function(a,b) return a[2] > b[2] end)

			local v = tbl[1]
			local winner, count = v[1], v[2]

			callback(winner, options[winner], count, total_count)
		else
			for i = 1, #options do
				sam.set_global("Votings" .. i, nil)
			end
		end

		options, players_voted = nil, nil

		timer.Remove("SAM.Vote")
	end

	start_vote = function(ply, callback, title, ...)
		if vote_on then
			return ply:sam_add_text(color_white, "There is an active vote, wait for it to finish.")
		end

		vote_on = true

		options, players_voted = {}, {}

		local args, n = {...}, select("#", ...)
		for i = 1, n do
			local v = args[i]
			if v then
				table.insert(options, v)
			end
		end

		sam.set_global("Vote", {title, options, CurTime()})

		for k in ipairs(options) do
			sam.set_global("Votings" .. k, 0)
		end

		timer.Create("SAM.Vote", 25, 1, function()
			end_vote(ply, callback)
		end)

		return true
	end

	sam.netstream.Hook("Vote", function(ply, index)
		if not sam.isnumber(index) or index > 5 then return end

		local votings = sam.get_global("Votings" .. index)
		if not votings then return end

		local old_index = players_voted[ply:AccountID()]
		if old_index == index then return end

		if old_index then
			sam.set_global("Votings" .. old_index, sam.get_global("Votings" .. old_index) - 1)
		end

		sam.set_global("Votings" .. index, votings + 1)

		players_voted[ply:AccountID()] = index
	end)
end

if CLIENT then
	local SUI = sam.SUI
	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/client/player.lua

	local VOTING_TITLE = SUI.CreateFont("VotingTitle", "Roboto Bold", 15)
	local VOTING_OPTION = SUI.CreateFont("VotingTitle", "Roboto Medium", 14)

	local bind_translation = {}
	for i = 0, 9 do
		bind_translation["slot" .. i] = i
	end

	local voting_frame

	end_vote = function()
		if IsValid(voting_frame) then
			voting_frame:Remove()
		end
		hook.Remove("PlayerBindPress", "SAM.Voting")
		hook.Remove("SAM.ChangedGlobalVar", "SAM.VotingCount")
	end

	hook.Add("SAM.ChangedGlobalVar", "Voting", function(key, value)
		if key ~= "Vote" then return end

		if not value then
			end_vote()
			return
		end

		local title, options, start_time = value[1], value[2], value[3]

		sui.TDLib.Start()

		voting_frame = vgui.Create("EditablePanel")
		voting_frame:SetSize(SUI.Scale(165), SUI.Scale(230))
		voting_frame:SetPos(5, ScrH() * 0.25)
		voting_frame:DockPadding(4, 4, 4, 4)
		voting_frame:Blur()
			:Background(Color(30, 30, 30, 240))

		local voting_title = voting_frame:Add("SAM.Label")
		voting_title:Dock(TOP)
		voting_title:SetFont(VOTING_TITLE)
		voting_title:TextColor(Color(220, 220, 220))
		voting_title:SetText(title)
		voting_title:SetWrap(true)
		voting_title:SetAutoStretchVertical(true)

		local line = voting_frame:Add("SAM.Label")
		line:Dock(TOP)
		line:TextColor(Color(220, 220, 220))
		line:SetText("-")

		local options_added = {}
		for i, v in ipairs(options) do
			local option = voting_frame:Add("SAM.Label")
			option:Dock(TOP)
			option:SetFont(VOTING_OPTION)
			option:TextColor(Color(220, 220, 220), true)
			option:SetText(i .. ". " .. v .. " (0)")
			option:SetWrap(true)
			option:SetAutoStretchVertical(true)

			options_added[i] = option
		end

		function voting_frame:Think() -- fucking gmod
			self:SizeToChildren(false, true)

			local time_left = math.floor(25 - (CurTime() - start_time))
			if time_left <= 0 then
				end_vote()
				voting_frame.Think = nil
				return
			end

			voting_title:SetText(title .. " (" .. time_left .. ")")
		end

		line = voting_frame:Add("SAM.Label")
		line:Dock(TOP)
		line:TextColor(Color(220, 220, 220))
		line:SetText("-")

		local option = voting_frame:Add("SAM.Label")
		option:Dock(TOP)
		option:SetFont(VOTING_OPTION)
		option:TextColor(Color(220, 220, 220), true)
		option:SetText("0. Close")
		option:SetWrap(true)
		option:SetAutoStretchVertical(true)

		sui.TDLib.End()

		local current_index
		hook.Add("PlayerBindPress", "SAM.Voting", function(_, bind, down)
			if not down then return end

			local index = bind_translation[bind]
			if not index then return end

			if index == 0 then
				end_vote()
				return true
			end

			if not options[index] then return true end

			if current_index then
				options_added[current_index]:TextColor(Color(220, 220, 220), true)
			end

			options_added[index]:TextColor(Color(65, 185, 255), true)
			current_index = index

			sam.netstream.Start("Vote", index)

			return true
		end)

		hook.Add("SAM.ChangedGlobalVar", "SAM.VotingCount", function(key2, count)
			if key2:sub(1, 7) ~= "Votings" then return end
			if not count then return end

			local index = tonumber(key2:sub(8))
			options_added[index]:SetText(index .. ". " .. options[index] .. " (" .. count .. ")")
		end)
	end)
end

local vote_check = function(str)
	return str:match("%S") ~= nil
end

command.new("vote")
	:SetPermission("vote", "admin")

	:AddArg("text", {hint = "title", check = vote_check})
	:AddArg("text", {hint = "option", check = vote_check})
	:AddArg("text", {hint = "option", check = vote_check})
	:AddArg("text", {hint = "option", optional = true, check = vote_check})
	:AddArg("text", {hint = "option", optional = true, check = vote_check})
	:AddArg("text", {hint = "option", optional = true, check = vote_check})

	:Help("Start a vote!")

	:OnExecute(function(ply, title, ...)
		local callback = function(_, option, count, total_count)
			sam.player.send_message(nil, "Vote {V} for {V_2} has been passed. ({V_3}/{V_4})", {
				V = title, V_2 = option, V_3 = count, V_4 = total_count
			})
		end

		if start_vote(ply, callback, title, ...) then
			sam.player.send_message(nil, "{A} started a vote with title {V}.", {
				A = ply, V = title
			})
		end
	end)
:End()

command.new("endvote")
	:SetPermission("endvote", "admin")

	:Help("End current vote.")

	:OnExecute(function(ply)
		end_vote(ply)
	end)
:End()

command.new("votekick")
	:SetPermission("votekick", "admin")

	:AddArg("player", {single_target = true})
	:AddArg("text", {hint = "reason", optional = true})

	:GetRestArgs()

	:Help("Start a vote to kick a player.")

	:OnExecute(function(ply, targets, reason)
		local target = targets[1]
		local target_name = target:Name()

		local callback = function(index, option, count, total_count)
			if not IsValid(ply) then
				sam.player.send_message(nil, "Vote was canceled because {T} left.", {
					T = target_name
				})
				return
			end

			if index == 1 then
				target:Kick("Vote was successful (" .. (reason or "none") .. ")")

				sam.player.send_message(nil, "Vote was successful, {T} has been kicked. ({V})", {
					T = targets, V = reason
				})
			else
				sam.player.send_message(nil, "Vote was unsuccessful, {T} won't be kicked.", {
					T = target_name
				})
			end
		end

		local title = "Kick " .. target_name .. "?"
		if reason then
			title = title .. " (" .. reason .. ")"
		end

		if start_vote(ply, callback, title, "Yes", "No") then
			if reason then
				sam.player.send_message(nil, "{A} started a votekick against {T} ({V})", {
					A = ply, T = targets, V = reason
				})
			else
				sam.player.send_message(nil, "{A} started a votekick against {T}", {
					A = ply, T = targets
				})
			end
		end
	end)
:End()

command.new("voteban")
	:SetPermission("voteban", "admin")

	:AddArg("player", {single_target = true})
	:AddArg("length", {optional = true, default = 60, min = 30, max = 120})
	:AddArg("text", {hint = "reason", optional = true})

	:GetRestArgs()

	:Help("Start a vote to ban a player.")

	:OnExecute(function(ply, targets, length, reason)
		local target = targets[1]
		local target_steamid, target_name = target:SteamID(), target:Name()
		local ply_steamid = ply:SteamID()

		local callback = function(index, option, count, total_count)
			if index == 1 then
				sam.player.ban_id(target_steamid, length, "Vote was successful (" .. (reason or "none") .. ")", ply_steamid)

				sam.player.send_message(nil, "Vote was successful, {T} has been banned. ({V})", {
					T = target_name, V = reason
				})
			else
				sam.player.send_message(nil, "Vote was unsuccessful, {T} won't be banned.", {
					T = target_name
				})
			end
		end

		local title = "Ban " .. target_name .. "?"
		if reason then
			title = title .. " (" .. reason .. ")"
		end

		if start_vote(ply, callback, title, "Yes", "No") then
			if reason then
				sam.player.send_message(nil, "{A} started a voteban against {T} for {V} ({V_2})", {
					A = ply, T = targets, V = sam.format_length(length), V_2 = reason
				})
			else
				sam.player.send_message(nil, "{A} started a voteban against {T} for {V}", {
					A = ply, T = targets, V = sam.format_length(length)
				})
			end
		end
	end)
:End()

command.new("votemute")
	:SetPermission("votemute", "admin")

	:AddArg("player", {single_target = true})
	:AddArg("text", {hint = "reason", optional = true})

	:GetRestArgs()

	:Help("Start a vote to mute and gag a player.")

	:OnExecute(function(ply, targets, reason)
		local _reason = reason and (" (" .. reason .. ")") or ""

		local target = targets[1]
		local target_name = target:Name()

		local callback = function(index, option, count, total_count)
			if not IsValid(target) then
				sam.player.send_message(nil, "Vote was canceled because {T} left.", {
					T = target_name
				})
				return
			end

			if index == 1 then
				RunConsoleCommand("sam", "mute", "#" .. target:EntIndex(), 0, "votemute" .. _reason)
				RunConsoleCommand("sam", "gag", "#" .. target:EntIndex(), 0, "votemute" .. _reason)

				sam.player.send_message(nil, "Vote was successful, {T} has been muted. ({V})", {
					T = target_name, V = reason
				})
			else
				sam.player.send_message(nil, "Vote was unsuccessful, {T} won't be muted.", {
					T = target_name
				})
			end
		end

		local title = "Mute " .. target_name .. "?" .. _reason
		if start_vote(ply, callback, title, "Yes", "No") then
			if reason then
				sam.player.send_message(nil, "{A} started a votemute against {T} ({V}).", {
					A = ply, T = targets, V = reason
				})
			else
				sam.player.send_message(nil, "{A} started a votemute against {T}.", {
					A = ply, T = targets
				})
			end
		end
	end)
:End()

command.new("votemap")
	:SetPermission("votemap", "admin")

	:AddArg("map", {exclude_current = true})
	:AddArg("map", {optional =  true, exclude_current = true})
	:AddArg("map", {optional =  true, exclude_current = true})

	:GetRestArgs()

	:Help("Start a vote to change map.")

	:OnExecute(function(ply, ...)
		local callback = function(_, option, count, total_count)
			sam.player.send_message(nil, "Map vote for {V} has been passed. ({V_2}/{V_3})", {
				V = option, V_2 = count, V_3 = total_count
			})

			if sam.is_valid_map(option) then
				RunConsoleCommand("sam", "map", option)
			end
		end

		local args = {...}
		for i = select("#", ...), 1, -1 do
			if args[i] == "None" then
				args[i] = nil
			end
		end
		table.insert(args, "Extend Current Map")

		if start_vote(ply, callback, "Vote for the next map!", unpack(args)) then
			sam.player.send_message(nil, "{A} started a map change vote.", {
				A = ply
			})
		end
	end)
:End()