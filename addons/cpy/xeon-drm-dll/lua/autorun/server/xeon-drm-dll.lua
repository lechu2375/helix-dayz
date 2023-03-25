local function JohnLua()
	local quotes = {"In the beginning was the Statement, and the Statement was with Lua, and the Statement was Lua.","Greater love has no one than Lua, that the compiler lay down his life for our code.","Do not think that I will debug with the Stack Trace; For had ye believed the Compiler Errors, ye would have believed Me, for he wrote of Lua; But if ye believe not his Stack Traces, how shall ye believe My code?","Even though my types remain weak, I fear no error, for Lua is with me.","Lua is the chain that ties our health and bodies together.","Rip scripts, you must not. Let the Lua flow straight from your fingers.","Variables are changed by your example, not by your opinion.","The meaning of Lua is to give Lua a meaning.","Doubt has killed more scripts than errors will.","The hottest places in Hell are for those who never declare local variables.","Crashes and overflows may break my bones; But pcalls will never harm me.","Wise men code because they have something to make; Fools because they want to make something.","Lua is the joy of the good, the wonder of the wise, the amazement of the Gods.","You dump functions. You dump memory regions and crash reports that look like hell. You dump unused variables and collected garbage and tables. But people?","Whoever believes in the Trace is not condemned, but whoever does not believe stands condemned already because they have not believed in the name of John Lua's one and only Function.","It is written: \"Lua shall not live on interpreter alone, but on every instruction that comes from the mouth of Mike Pall.\"","Because of Mike Pall's great love we are not consumed, for his Traces never fail. They are new every loop; great is your Just-In-Time compilation.","I give them eternal life, and they shall never perish; no one will collect them out of my heap. My Allocator, who has given them to me, is greater than all; no one can Mark-and-Sweep them out of my Garbage-Collectors hand. I and the Collector are one."}
	return "\"" .. quotes[math.random(1, #quotes)] .. "\" - John Lua\n"
end

do
	local hookId = {}
	for i = 1, math.random(10, 20) do
		hookId[i] = string.char(math.random(0, 1) == 0 and math.random(97, 122) or math.random(65, 90))
	end
	hookId = table.concat(hookId)

	local ipConVar = GetConVar("ip")
	local function getIPAddress()
		local ip = game.GetIPAddress()
		if ip and #ip > 0 and not ip:StartWith("0.0.0.0") and not ip:StartWith("localhost") and not ip:StartWith("loopback") then
			return true
		end

		ip = ipConVar:GetString()
		if ip and #ip > 0 and not ip:StartWith("0.0.0.0") and not ip:StartWith("localhost") and not ip:StartWith("loopback") then
			return true
		end

		return false
	end

	local function init()
		if not getIPAddress() then return end

		hook.Remove("GetGameDescription", hookId)
		hook.Remove("PlayerConnect", hookId)

		MsgC(Color(0,255,255), "\n[ Y88b   d88P 8888888888 .d88888b.  888b    888 ]\n[  Y88b d88P  888       d88P\" \"Y88b 8888b   888 ]\n[   Y88o88P   888       888     888 88888b  888 ]\n[    Y888P    8888888   888     888 888Y88b 888 ]\n[    d888b    888       888     888 888 Y88b888 ]\n[   d88888b   888       888     888 888  Y88888 ]\n[  d88P Y88b  888       Y88b. .d88P 888   Y8888 ]\n[ d88P   Y88b 8888888888 \"Y88888P\"  888    Y888 ]\n\n")
		MsgC(Color(0,255,0), "DRM (digital rights management) for Billy's scripts\n\n")
		MsgC(Color(255,255,255), JohnLua())

		MsgC(Color(255,0,255), "\nSupport\n")
		MsgC(Color(255,255,255), "https://support.billy.enterprises\n")

		MsgC(Color(255,0,255), "\nServer Status\n")
		MsgC(Color(255,255,255), "https://xeon.network\n")

		MsgC(Color(255,0,255), "\nServer/Licenses Panel\n")
		MsgC(Color(255,255,255), "https://xeon.network/servers\n")

		if system.IsOSX() then
			print()
			for i = 1, 10 do
				MsgC(Color(255,0,0), "XEON DRM is not compatible with your operating system. You are unable to use Billy's scripts on this computer.\n")
			end
			print()
			hook.Run("XEON.Error", "XEON DRM is not compatible with your operating system. You are unable to use Billy's scripts on this computer.")
			return
		end

		local platform = system.IsWindows() and (jit.arch == "x86" and "win32" or "win64") or (jit.arch == "x86" and "linux" or "linux64")
		if not file.Exists("bin/gmsv_xeon_drm_" .. platform .. ".dll", "LUA") then
			print()
			for i = 1, 10 do
				MsgC(Color(255,0,0), "Your server is running ", Color(255,255,255), (system.IsWindows() and "Windows" or "Linux"), Color(255,0,0), " on the ", Color(255,255,255), (jit.arch == "x86" and "main" or "x86-64"), Color(255,0,0), " branch\n")
				MsgC(Color(255,0,0), "Couldn't find ", Color(255,255,255), "garrysmod/lua/bin/gmsv_xeon_drm_" .. platform .. ".dll", Color(255,0,0), " on your server!\n")
				MsgC(Color(255,0,0), "You didn't install the XEON DRM binary module! This is required to use Billy's scripts.\n")
				MsgC(Color(255,0,0), "Please download it here: ", Color(255,255,255), "https://xeon.network/download\n\n")
			end
			print()
			hook.Run("XEON.Error", "Your server is running " .. (system.IsWindows() and "Windows" or "Linux") .. " on the " .. (jit.arch == "x86" and "main" or "x86-64") .. " branch")
			hook.Run("XEON.Error", "Couldn't find garrysmod/lua/bin/gmsv_xeon_drm_" .. platform .. ".dll on your server!")
			hook.Run("XEON.Error", "You didn't install the XEON DRM binary module! This is required to use Billy's scripts.")
			hook.Run("XEON.Error", "Please download it here: https://xeon.network/download")
			return
		end

		print()

		require("xeon_drm")

		if not XEON then
			print()
			for i = 1, 10 do
				MsgC(Color(255,0,0), "XEON DRM failed to load! Please read your server's console for more information.\n")
			end
			print()
			hook.Run("XEON.Error", "XEON DRM failed to load! Please read your server's console for more information.")
			return
		end
	end

	hook.Add("GetGameDescription", hookId, init)
	hook.Add("PlayerConnect", hookId, init)
end

do
	util.AddNetworkString("XEON.Error")

	local cached, cachedTick
	local function getSuperAdmins()
		if cached and cachedTick == engine.TickCount() then
			return cached
		end

		local filter = RecipientFilter()
		for _, ply in ipairs(player.GetHumans()) do
			if ply:IsSuperAdmin() then
				filter:AddPlayer(ply)
			end
		end

		cached, cachedTick = filter, engine.TickCount()

		return filter
	end

	local errors = setmetatable({}, (function()
		local meta = {}
		meta.__index = meta

		function meta:add(error)
			table.insert(self, error)
		end

		function meta:transmit(ply)
			if #self == 0 then return end
			if player.GetCount() == 0 then return end
			if ply ~= nil and (not IsValid(ply) or not ply:IsSuperAdmin()) then return end
			net.Start("XEON.Error")
				net.WriteUInt(#self, 16)
				for _, error in ipairs(self) do
					net.WriteString(error)
				end
			net.Send(ply == nil and getSuperAdmins() or ply)
		end

		return meta
	end)())

	hook.Add("XEON.Error", "XEON.Error", function(error)
		errors:add(error)
		errors:transmit()
	end)

	hook.Add("PlayerInitialSpawn", "XEON.Error", function(ply)
		timer.Simple(5, function()
			if not IsValid(ply) or not ply:IsSuperAdmin() then return end
			errors:transmit(ply)
		end)
	end)

	net.Receive("XEON.Error", function(_, ply)
		if ply:IsSuperAdmin() then
			errors:transmit(ply)
		end
	end)
end

do
	local linksRequired = {}

	local function startAuth(ply)
		local timerName = "XEON.Auth:" .. ply:SteamID64()
		timer.Create(timerName, 1, 0, function()
			if IsValid(ply) then
				net.Start("XEON.Auth")
					net.WriteBool(false)
				net.Send(ply)
			else
				timer.Remove(timerName)
			end
		end)
	end

	local function authSpawn(ply)
		if not linksRequired[ply:SteamID64()] then return end
		startAuth(ply)
	end

	net.Receive("XEON.Auth", function(len, ply)
		if not ply:IsSuperAdmin() then return end
		local steamid64 = ply:SteamID64()
		if not linksRequired[steamid64] then return end
		if len == 0 then
			timer.Remove("XEON.Auth:" .. ply:SteamID64())
		else
			linksRequired[steamid64] = nil
			if table.IsEmpty(linksRequired) then
				hook.Remove("PlayerSpawn", "XEON.Auth")
			end
			XEON:LinkServer(ply, net.ReadData(32))
		end
	end)

	hook.Add("XEON.Auth", "XEON.Auth", function(steamid64)
		local ply = player.GetBySteamID64(steamid64)
		linksRequired[steamid64] = true
		if IsValid(ply) then
			startAuth(ply)
		else
			hook.Add("PlayerSpawn", "XEON.Auth", authSpawn)
		end
	end)
end

do
	util.AddNetworkString("XEON.ReloadMap")
	net.Receive("XEON.ReloadMap", function(_, ply)
		if not ply:IsSuperAdmin() then return end
		RunConsoleCommand("changelevel", game.GetMap())
	end)
end

MsgC(Color(0,255,255), "XEON DRM is waiting for your server to get an IP address...\n")