if SAM_LOADED then return end

local version = tonumber("148") or 148

sam = {}
sam.config = {}
sam.language = {}
sam.player = {}
sam.ranks = {}
sam.permissions = {}
sam.author = "Srlion"
sam.version = version

function sam.print(...)
	MsgC(
		Color(236, 240, 241), "(",
		Color(244, 67, 54), "SAM",
		Color(236, 240, 241), ") ",
		Color(236, 240, 241), ...
	) Msg("\n")
end

local FAILED = false
do
	local types = {
		sv_ = SERVER and include or function() end,
		cl_ = SERVER and AddCSLuaFile or include,
		sh_ = function(name)
			if SERVER then
				AddCSLuaFile(name)
			end
			return include(name)
		end
	}

	sam.load_file = function(name, type)
		if FAILED then return end

		if type and not type:EndsWith("_") then
			type = type .. "_"
		end

		local func = types[type] or types[name:GetFileFromFilename():sub(1, 3)] or types["sh_"]
		if func then
			local rets = {func(name)}
			if rets[1] == false then
				FAILED = true
				sam.print("Failed to load!")
			end
			return unpack(rets)
		end
	end
end
local load_file = sam.load_file

sam.print("Loading...")

load_file("sam/libs/sh_types.lua")
load_file("sam/libs/sh_pon.lua")
load_file("sam/libs/sh_mp.lua")
load_file("sam/libs/sh_netstream.lua")
load_file("sam/libs/sh_async_netstream.lua")
load_file("sam/libs/sh_globals.lua")
load_file("sam/libs/sql/sv_init.lua")
sam.Promise = load_file("sam/libs/sh_promises.lua")

load_file("sam/sh_colors.lua")

load_file("sam/sh_util.lua")
load_file("sam/sh_lang.lua")
load_file("sam/sv_sql.lua")
load_file("sam/sh_permissions.lua")

load_file("sam/ranks/sh_ranks.lua")
load_file("sam/ranks/sv_ranks.lua")

load_file("sam/config/sh_config.lua")
load_file("sam/config/sv_config.lua")
load_file("sam/config/cl_config.lua")

load_file("sam/player/sh_player.lua")
load_file("sam/player/sh_nw_vars.lua")
load_file("sam/player/sv_player.lua")
load_file("sam/player/cl_player.lua")
load_file("sam/player/sv_ranks.lua")
load_file("sam/player/sv_auth.lua")
load_file("sam/player/sv_bans.lua")

load_file("sam/command/sh_command.lua")
load_file("sam/command/sv_command.lua")
load_file("sam/command/cl_command.lua")

for _, f in ipairs(file.Find("sam/command/arguments/*.lua", "LUA")) do
	load_file("sam/command/arguments/" .. f, "sh")
end

load_file("sam/sh_restrictions.lua")

load_file("sam/menu/sh_init.lua")
load_file("sam/menu/cl_init.lua")

load_file("sam/sh_motd.lua")

local modules = file.Find("sam/modules/*.lua", "LUA")
for _, module in ipairs(modules) do
	load_file("sam/modules/" .. module)
end

load_file("sam/reports/cl_reports.lua")
load_file("sam/reports/sv_reports.lua")

do
	if SERVER then
		hook.Add("SAM.LoadedConfig", "SAM.AdvertsMain", function(config)
			if not config.Adverts then
				sam.config.set("Adverts", {})
			end
		end)
	end
	load_file("sam/cl_adverts.lua")
end

if not FAILED then
	sam.print("Loaded!")
end

if SERVER then
	local path = "sam/importers/"

	concommand.Add("sam_import", function(ply, _, args)
		if IsValid(ply) then return end

		local admin_mod = args[1]
		if not admin_mod then
			sam.print("You need to provide an admin mod to import!")
			return
		end

		if not file.Exists(path .. admin_mod, "LUA") then
			sam.print("There is no importer for '" .. admin_mod .. "'")
			return
		end

		CompileFile(path .. admin_mod .. "/main.lua")()
	end, nil, nil, FCVAR_PROTECTED)
end

SAM_LOADED = true