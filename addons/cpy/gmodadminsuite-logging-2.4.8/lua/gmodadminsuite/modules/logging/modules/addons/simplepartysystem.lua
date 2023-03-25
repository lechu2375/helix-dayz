if (not GAS.Logging.Modules:IsAddonInstalled("Simple Party System")) then return end

local function party_name(party)
	if (type(party) == "string") then
		return party
	elseif (type(party) == "table") then
		return tostring(party.name)
	else
		return tostring(party)
	end
end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Chat"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSChat","partychat",function(ply,party,txt)
		MODULE:LogPhrase("party_chat", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)), GAS.Logging:Escape(txt))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Created"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSStartParty","partycreated",function(ply,party)
		MODULE:LogPhrase("party_created", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Joins"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSJoinParty","partyjoined",function(ply,party)
		MODULE:LogPhrase("party_join", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Join Requests"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSRequestJoin","partyreq",function(ply,party)
		MODULE:LogPhrase("party_join_request", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Invites"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSPartyInvite","partyinv",function(ply,party,ply2)
		MODULE:LogPhrase("party_invite", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Leaves"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSLeaveParty","partyleave",function(ply,party)
		MODULE:LogPhrase("party_leave", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Kicks"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSKickedParty","partykick",function(ply,ply2,party)
		MODULE:LogPhrase("party_kick", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Disbanded"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSDisbandedParty","partydisbanded",function(ply,party)
		MODULE:LogPhrase("party_disbanded", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Leader Left"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	MODULE:Hook("SPSPartyLeaderLeft","partyleaderleft",function(ply,party)
		MODULE:LogPhrase("party_abandoned", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(party_name(party)))
	end)
end)

GAS.Logging:AddModule(MODULE)
