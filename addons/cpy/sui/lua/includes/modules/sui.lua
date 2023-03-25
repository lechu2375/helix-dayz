if sui then return end

AddCSLuaFile()

sui = {}

do
	local wspace_chs = {} -- whitespace  characters except a normal space " "
	for k, v in ipairs({0x0c, 0x0a, 0x0d, 0x09, 0x0b}) do
		wspace_chs[string.char(v)] = true
	end
	sui.wspace_chs = wspace_chs

	local cntrl_chs = {string.char(0x7f)} -- control characters
	for i = 0x00, 0x1f do
		cntrl_chs[string.char(i)] = true
	end
	sui.cntrl_chs = cntrl_chs
end

if SERVER then
	AddCSLuaFile("sui/libs/tdlib/cl_tdlib.lua")
	AddCSLuaFile("sui/libs/bshadows.lua")
	AddCSLuaFile("sui/libs/gif_loader.lua")
	AddCSLuaFile("sui/libs/png_encoder.lua")
	AddCSLuaFile("sui/libs/types.lua")
	AddCSLuaFile("sui/cl_base.lua")
else
	include("sui/libs/tdlib/cl_tdlib.lua")
	include("sui/libs/bshadows.lua")
	include("sui/libs/types.lua")
	include("sui/cl_base.lua")
end

if SERVER then
	for _, f in ipairs(file.Find("sui/vgui/*.lua", "LUA")) do
		AddCSLuaFile("sui/vgui/" .. f)
	end
end