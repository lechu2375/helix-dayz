local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(255,0,0)

local blocked = {
	-- these are all commands that are logged in their own modules
	give = true,
	dropmoney = true,
	moneydrop = true,
	cheque = true,
	check = true,
	rpname = true,
	name = true,
	nick = true,
	buy = true,
	buyshipment = true,
	buyvehicle = true,
	buyammo = true,
	warrant = true,
	wanted = true,
	unwarrant = true,
	unwanted = true,
	agenda = true,
	addagenda = true,
	lottery = true,
	["/"] = true,
	ooc = true,
	requesthit = true,
}

MODULE:Setup(function()
	MODULE:Hook("onChatCommand","chatcommand",function(ply,cmd,args)
		if (type(args) == "table") then
			args = table.concat(args," ")
		end
		local lower_cmd = cmd:lower()
		if (blocked[lower_cmd]) then return end
		MODULE:Log(GAS.Logging:FormatPlayer(ply) .. ": /" .. GAS.Logging:Escape((cmd or "") .. " " .. (args or "")))
	end)
end)

GAS.Logging:AddModule(MODULE)