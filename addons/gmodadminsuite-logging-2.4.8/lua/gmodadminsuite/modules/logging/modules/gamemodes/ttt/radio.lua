local L = {}

L.quick_yes     = "Yes."
L.quick_no      = "No."
L.quick_help    = "Help!"
L.quick_imwith  = "I'm with {player}."
L.quick_see     = "I see {player}."
L.quick_suspect = "{player} acts suspicious."
L.quick_traitor = "{player} is a Traitor!"
L.quick_inno    = "{player} is innocent."
L.quick_check   = "Anyone still alive?"

L.quick_nobody    = "nobody"
L.quick_disg      = "someone in disguise"
L.quick_corpse    = "an unidentified body"
L.quick_corpse_id = "{player}'s corpse"

local function RADIO_ToPrintable(target)
	if (type(target) == "string") then
		return L[target]
	elseif (IsValid(target)) then
		if (target:IsPlayer()) then
			return GAS.Logging:FormatPlayer(target)
		elseif (target:GetClass() == "prop_ragdoll") then
			local ply = target:GetDTEntity(CORPSE.dti.ENT_PLAYER)
			if (IsValid(ply)) then
				return "the corpse of " .. GAS.Logging:FormatPlayer(ply)
			else
				return "the corpse of " .. target:GetNWString("nick", "an unknown terrorist")
			end
		end
	end
end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "Radio"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:FeedbackHook("TTTPlayerRadioCommand", "TTTPlayerRadioCommand", function(theirReturn, ply, msg_name, msg_target)
		if theirReturn and theirReturn[1] == true then return end
		MODULE:Log(GAS.Logging:FormatPlayer(ply) .. ": " .. util.Capitalize(string.Interp(L[msg_name], {player = RADIO_ToPrintable(msg_target)})))
	end)
end)

GAS.Logging:AddModule(MODULE)