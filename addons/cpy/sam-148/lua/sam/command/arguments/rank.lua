if SAM_LOADED then return end

local sam, command = sam, sam.command

local is_good_rank = function(rank, arg, ply)
	if arg.check and not arg.check(rank, ply) then
		return false
	end
	return true
end

command.new_argument("rank")
	:OnExecute(function(arg, input, ply, _, result, i)
		if not input and arg.optional then
			result[i] = nil
			return
		end

		if not sam.ranks.is_rank(input) or not is_good_rank(input, arg, ply) then
			ply:sam_send_message("invalid", {
				S = arg.hint or "rank", S_2 = input
			})
			return false
		end

		result[i] = input
	end)

	:Menu(function(set_result, body, buttons, arg)
		local current_rank = arg.hint or "select rank"

		local ranks = buttons:Add("SAM.ComboBox")
		ranks:SetValue(current_rank)
		ranks:SetTall(25)

		function ranks:OnSelect(_, value)
			set_result(value)
			current_rank = value
		end

		function ranks:DoClick()
			if self:IsMenuOpen() then
				return self:CloseMenu()
			end

			self:Clear()
			self:SetValue(current_rank)

			for rank_name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
				if is_good_rank(rank_name, arg, LocalPlayer()) then
					self:AddChoice(rank_name)
				end
			end

			self:OpenMenu()
		end

		return ranks
	end)

	:AutoComplete(function(arg, result, name)
		for rank_name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
			if rank_name:lower():find(name, 1, true) and is_good_rank(rank_name, arg, LocalPlayer()) then
				table.insert(result, rank_name)
			end
		end
	end)
:End()