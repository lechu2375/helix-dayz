LiteGibs = LiteGibs or {}

local flist = file.Find("litegibs/enums/*.lua","LUA")

for _, filename in pairs(flist) do

	local typev = "SHARED"
	if filename:StartWith("cl_") then
		typev = "CLIENT"
	elseif filename:StartWith("sv_") then
		typev = "SERVER"
	end

	if SERVER and typev ~= "SERVER" then
		AddCSLuaFile( "litegibs/enums/" .. filename )
	end

	if ( SERVER and typev ~= "CLIENT" ) or ( CLIENT and typev ~= "SERVER" ) then
		include( "litegibs/enums/" .. filename )
		--print("Initialized " .. filename .. " || " .. fileid .. "/" .. #flist )
	end

end

flist = file.Find("litegibs/modules/*.lua","LUA")

for _, filename in pairs(flist) do

	local typev = "SHARED"
	if filename:StartWith("cl_") then
		typev = "CLIENT"
	elseif filename:StartWith("sv_") then
		typev = "SERVER"
	end

	if SERVER and typev ~= "SERVER" then
		AddCSLuaFile( "litegibs/modules/" .. filename )
	end

	if ( SERVER and typev ~= "CLIENT" ) or ( CLIENT and typev ~= "SERVER" ) then
		include( "litegibs/modules/" .. filename )
		--print("Initialized " .. filename .. " || " .. fileid .. "/" .. #flist )
	end

end