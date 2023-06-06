
if SERVER then 
	util.AddNetworkString("fpsfog_3dsky") 
	util.AddNetworkString("fpsfog_sendskycamera") 
end

if CLIENT then LocalPlayer().fpsfog_3dsky = GetConVar("r_3dsky"):GetFloat() end

CreateConVar( "fpsfog_active", 0, 8192 + 128, "enables fps saving fog", 0, 1 )
CreateConVar( "fpsfog_skybox", 1, 8192 + 128, "disables skybox", 0, 1 )
CreateConVar( "fpsfog_distance", 6500, 8192 + 128, "distance at which fog becomes opaque", 0, 20000 )
CreateConVar( "fpsfog_thickness", 50, 8192 + 128, "distance at which fog starts", 0, 100 )
CreateConVar( "fpsfog_color_r", 200, 8192 + 128, "red component", 0, 255 )
CreateConVar( "fpsfog_color_g", 200, 8192 + 128, "blue component", 0, 255 )
CreateConVar( "fpsfog_color_b", 200, 8192 + 128, "green component", 0, 255 )

local fpsfog_SC_pos = fpsfog_SC_pos 
local fpsfog_SC_scale = fpsfog_SC_scale

cvars.AddChangeCallback("fpsfog_skybox", function(name, old, new)

	if #player.GetAll() > 0 and SERVER then

		local skyscale = 1
		local skypos = Vector(0,0,0)
		local skybox = 0

		if IsValid(fpsfog_skycamera) then 
			skyscale = fpsfog_skycamera:GetKeyValues().scale 
			skypos = fpsfog_skycamera:GetPos()
			skybox = new
		end

		net.Start("fpsfog_3dsky")
		net.WriteInt(skybox, 3)
		net.WriteInt(skyscale, 8)
		net.WriteVector(skypos)
		net.Broadcast()

	end

end)

net.Receive("fpsfog_3dsky", function(len, ply)

	local active = net.ReadInt(3)
	fpsfog_SC_scale = net.ReadInt(8)
	fpsfog_SC_pos = net.ReadVector()

	LocalPlayer():ConCommand("r_3dsky " .. tostring(active))
	

end)

local fogactive = true
local fogend = 5000
local fogstart = 3000
local fogcolor = Color(83,83,83)

local fpsfog_newcontroller = nil

if SERVER then

	fpsfog_newcontroller = ents.Create("env_fog_controller")

end

--gmod wiki my beloved

local load_queue = {}

hook.Add("PlayerInitialSpawn", "fpsfog_plyspawn", function(ply)
	load_queue[ply] = true
end)

hook.Add("SetupMove", "fpsfog_plyload", function(ply, _, cmd)
	if load_queue[ply] and not cmd:IsForced() then
		load_queue[ply] = nil

		local skyscale = 1
		local skypos = Vector(0,0,0)
		if IsValid(fpsfog_skycamera) then 
			skyscale = fpsfog_skycamera:GetKeyValues().scale 
			skypos = fpsfog_skycamera:GetPos()
		end


		net.Start("fpsfog_3dsky")
		net.WriteInt(GetConVar("fpsfog_skybox"):GetFloat(), 3)
		net.WriteInt(skyscale, 8)
		net.WriteVector(skypos)
		net.Send(ply)

	end
end)


hook.Add( "InitPostEntity", "fpsfog_postinit", function()

	local existingcontrollers = ents.FindByClass("env_fog_controller")

	PrintTable(existingcontrollers)

	for _, v in ipairs(existingcontrollers) do

		v.fpsfog_originalvalue = v:GetKeyValues().farz

	end

	if #existingcontrollers > 1 and SERVER then

		fpsfog_newcontroller:Remove()

	end

	fpsfog_skycamera = ents.FindByClass("sky_camera")[1]

end )


hook.Add("Think", "fpsfog_farz", function()

	local active = GetConVar("fpsfog_active"):GetFloat()
	local fogend = GetConVar("fpsfog_distance"):GetFloat()

	if SERVER then 

		if active == 1 then

			for k, v in pairs(ents.FindByClass("env_fog_controller")) do
			
				v:SetKeyValue("farz", fogend + 250)

			end

		else

			for k, v in pairs(ents.FindByClass("env_fog_controller")) do

				v:SetKeyValue("farz", v.fpsfog_originalvalue or -1)

			end

		end
		
	end

end)

hook.Add("ShutDown", "fpsfog_returnsky", function()

	if CLIENT then
		RunConsoleCommand( "r_3dsky", 1)
	end

end)


local constructmat = Material("gm_construct/color_room")

hook.Add("PreDrawOpaqueRenderables", "fpsfog_removeskybox", function(depth, skybox)


		local active = GetConVar("fpsfog_active"):GetFloat()

		if active == 1 and fpsfog_SC_scale ~= nil then 

			local ply = LocalPlayer()
			local view = render.GetViewSetup()
			local lookdir = view.angles
			local lookpos = view.origin
			local looknorm = Vector(1,0,0)
			looknorm:Rotate(lookdir)
			local fogend = GetConVar("fpsfog_distance"):GetFloat()
			local fpsfog_r = GetConVar("fpsfog_color_r"):GetFloat()
			local fpsfog_g = GetConVar("fpsfog_color_g"):GetFloat()
			local fpsfog_b = GetConVar("fpsfog_color_b"):GetFloat()

			if skybox and GetConVar("fpsfog_skybox"):GetFloat() == 1 then

				render.SetMaterial(constructmat)
				render.DrawQuadEasy((lookpos + looknorm * fogend) / fpsfog_SC_scale + fpsfog_SC_pos, looknorm * -1, 1000000, 1000000, Color(fpsfog_r, fpsfog_g, fpsfog_b))

			elseif GetConVar("fpsfog_skybox"):GetFloat() == 0 then

				render.SetMaterial(constructmat)
				render.DrawQuadEasy((lookpos + looknorm * fogend), looknorm * -1, 1000000, 1000000, Color(fpsfog_r, fpsfog_g, fpsfog_b))

			end

		end




end)

hook.Add("SetupWorldFog", "fpsfog_fog", function()

	local active = GetConVar("fpsfog_active"):GetFloat()

	if active == 1 then

		local fogend = GetConVar("fpsfog_distance"):GetFloat()
		local fogstart = fogend - fogend * (GetConVar("fpsfog_thickness"):GetFloat() / 100)
		local fpsfog_r = GetConVar("fpsfog_color_r"):GetFloat()
		local fpsfog_g = GetConVar("fpsfog_color_g"):GetFloat()
		local fpsfog_b = GetConVar("fpsfog_color_b"):GetFloat()

		render.FogMode(active)
		render.FogColor( fpsfog_r, fpsfog_g, fpsfog_b )
		render.FogMaxDensity(1)
		render.FogStart(fogstart)
		render.FogEnd(fogend)

		return true

	end


end)

hook.Add("SetupSkyboxFog", "fpsfog_skyfog", function(scale)

	local active = GetConVar("fpsfog_active"):GetFloat()

	if active == 1 then

		local fogend = GetConVar("fpsfog_distance"):GetFloat()
		local fogstart = fogend - fogend * (GetConVar("fpsfog_thickness"):GetFloat() / 100)
		local fpsfog_r = GetConVar("fpsfog_color_r"):GetFloat()
		local fpsfog_g = GetConVar("fpsfog_color_g"):GetFloat()
		local fpsfog_b = GetConVar("fpsfog_color_b"):GetFloat()

		render.FogMode(active)
		render.FogColor( fpsfog_r, fpsfog_g, fpsfog_b )
		render.FogMaxDensity(1)
		render.FogStart(fogstart * scale)
		render.FogEnd(fogend * scale)

		return true

	end


end)

list.Set( "DesktopWindows", "fpsfog", {

	title		= "Fps Fog Menu",
	icon		= "icon16/weather_clouds.png",
	width		= 300,
	height		= 380,
	onewindow	= true,
	init		= function( icon, frame )

	local mainframe = frame:Add( "DPanel" )
	mainframe:Dock(FILL)

	local fogenablevar = mainframe:Add( "DCheckBoxLabel" )
	fogenablevar:SetValue(GetConVar("fpsfog_active"):GetFloat() or 0)
	fogenablevar:SetTextColor(Color(0,0,0))
	fogenablevar:SetText("Fog Enabled")
	fogenablevar:Dock(TOP)
	fogenablevar:DockMargin(9, 10, 0, 0)
	fogenablevar:SetConVar("fpsfog_active")

	local fogskyboxvar = mainframe:Add( "DCheckBoxLabel" )
	fogskyboxvar:SetValue(GetConVar("fpsfog_active"):GetFloat() or 0)
	fogskyboxvar:SetTextColor(Color(0,0,0))
	fogskyboxvar:SetText("Skybox Enabled")
	fogskyboxvar:Dock(TOP)
	fogskyboxvar:DockMargin(9, 10, 0, 0)
	fogskyboxvar:SetConVar("fpsfog_skybox")

	local fogendvar = mainframe:Add("DNumSlider")
	fogendvar:SetDecimals(0)
	fogendvar:SetValue(GetConVar("fpsfog_distance"):GetFloat() or 5000)
	fogendvar:SetMinMax(0, 20000)
	fogendvar:Dock(TOP)
	fogendvar:Center()
	fogendvar:DockPadding(10, 10, 0, 0)
	fogendvar.Label:SetTextColor(Color(0,0,0))
	fogendvar:SetText("Fog Distance")
	fogendvar:SetConVar("fpsfog_distance")

	local fogstartvar = mainframe:Add("DNumSlider")
	fogstartvar:SetDecimals(0)
	fogstartvar:SetValue(GetConVar("fpsfog_thickness"):GetFloat() or 25)
	fogstartvar:SetMinMax(0, 100)
	fogstartvar:Dock(TOP)
	fogstartvar:Center()
	fogstartvar:DockPadding(10, 10, 0, 0)
	fogstartvar.Label:SetTextColor(Color(0,0,0))
	fogstartvar:SetText("Fog Thickness")
	fogstartvar:SetConVar("fpsfog_thickness")


	local fogcolorvar = mainframe:Add( "DColorMixer" )
	fogcolorvar:Dock( TOP )
	fogcolorvar:SetAlphaBar(false)
	fogcolorvar:DockPadding(10, 10, 10, 10)
	fogcolorvar:SetConVarR("fpsfog_color_r")
	fogcolorvar:SetConVarG("fpsfog_color_g")
	fogcolorvar:SetConVarB("fpsfog_color_b")

end})






if(SERVER) then
    timer.Simple(5, function()
        RunConsoleCommand("fpsfog_active",1)
        RunConsoleCommand("fpsfog_distance",2700)
        RunConsoleCommand("fpsfog_thickness",100)
        RunConsoleCommand("fpsfog_skybox",0)
        
    end)
end