local settings = {
	["low"] = {
		["cl_litegibs_fx_blood_stream_enabled"] = "0",
		["cl_litegibs_fx_blood_stream_time"] = "5",
		["cl_litegibs_fx_blood_spray_enabled"] = "1",
		["cl_litegibs_fx_blood_hud_enabled"] = "0",
		["cl_litegibs_fx_blood_wep_enabled"] = "0",
		["cl_litegibs_fx_blood_pool_enabled"] = "1",
		["cl_litegibs_fx_gibs_enabled"] = "1",
		["cl_litegibs_fx_gibs_time"] = "15",
		["cl_litegibs_fx_gibs_blood"] = "0",
		["cl_litegibs_fx_gibs_sound"] = "0",
		["cl_litegibs_fx_limbs_enabled"] = "1",
		["cl_litegibs_fx_wounds_enabled"] = "0",
		["cl_litegibs_fx_wounds_live"] = "0",
		["cl_litegibs_fx_wounds_limit"] = "2",
		["cl_litegibs_footsteps"] = "0",
		["cl_litegibs_damage_multiplier"] = "0.8"
	},
	["mid"] = {
		["cl_litegibs_fx_blood_stream_enabled"] = "1",
		["cl_litegibs_fx_blood_stream_time"] = "3",
		["cl_litegibs_fx_blood_spray_enabled"] = "1",
		["cl_litegibs_fx_blood_hud_enabled"] = "1",
		["cl_litegibs_fx_blood_wep_enabled"] = "1",
		["cl_litegibs_fx_blood_pool_enabled"] = "1",
		["cl_litegibs_fx_gibs_enabled"] = "1",
		["cl_litegibs_fx_gibs_time"] = "15",
		["cl_litegibs_fx_gibs_blood"] = "1",
		["cl_litegibs_fx_gibs_sound"] = "1",
		["cl_litegibs_fx_limbs_enabled"] = "1",
		["cl_litegibs_fx_wounds_enabled"] = "0",
		["cl_litegibs_fx_wounds_live"] = "0",
		["cl_litegibs_fx_wounds_limit"] = "16",
		["cl_litegibs_footsteps"] = "1",
		["cl_litegibs_damage_multiplier"] = "1"
	},
	["high"] = {
		["cl_litegibs_fx_blood_stream_enabled"] = "1",
		["cl_litegibs_fx_blood_stream_time"] = "5",
		["cl_litegibs_fx_blood_spray_enabled"] = "1",
		["cl_litegibs_fx_blood_hud_enabled"] = "1",
		["cl_litegibs_fx_blood_wep_enabled"] = "1",
		["cl_litegibs_fx_blood_pool_enabled"] = "1",
		["cl_litegibs_fx_gibs_enabled"] = "1",
		["cl_litegibs_fx_gibs_time"] = "15",
		["cl_litegibs_fx_gibs_blood"] = "1",
		["cl_litegibs_fx_gibs_sound"] = "1",
		["cl_litegibs_fx_limbs_enabled"] = "1",
		["cl_litegibs_fx_wounds_enabled"] = "1",
		["cl_litegibs_fx_wounds_live"] = "1",
		["cl_litegibs_fx_wounds_limit"] = "32",
		["cl_litegibs_footsteps"] = "1",
		["cl_litegibs_damage_multiplier"] = "1"
	}
}

local function ApplySettings(t)
	for k, v in pairs(t) do
		local cv = GetConVar(k)

		if cv then
			cv:SetString(v)
			print(k)
			print(cv:GetString())
		end
	end
end

local panelBlackColor = Color(0, 0, 0, 225)
local bloodColor = Color(192, 8, 0, 225)
local textColor = Color(192, 192, 192, 255)
local textColorButton = Color(225, 225, 225, 255)
local textColorHighlight = Color(255, 255, 255, 255)
local textColorDown = Color(128, 128, 128, 255)

local function SimpleDarkTranslucent(p, w, h)
	surface.SetDrawColor(panelBlackColor)
	surface.DrawRect(0, 0, w, h)
end

local function ButtonDrawMat(p, w, h)
	if p.mat then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(p.mat)
		surface.DrawTexturedRect(0, 0, w, h)
	else
		SimpleDarkTranslucent(p,w,h)
	end
	if p:IsDown() then
		p:SetTextColor(textColorDown)
	elseif p:IsHovered() then
		p:SetTextColor(textColorHighlight)
	else
		p:SetTextColor(textColorButton)
	end
end

local logoMat = Material("vgui/litegibs_logo.png", "smooth")
local goreLowMat = Material("vgui/gore_low.png", "smooth")
local goreMidMat = Material("vgui/gore_mid.png", "smooth")
local goreHighMat = Material("vgui/gore_high.png", "smooth")
local baseFontHeight = 48
local buttonFontHeight = 96

local function scaleFontHeight(h)
	return h * ScrH() / 1080
end

local function setupFonts()
	local scaledHeight = scaleFontHeight(baseFontHeight)
	local scaledHeightButton = scaleFontHeight(buttonFontHeight)

	surface.CreateFont("LGDescriptionFont", {
		font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = scaledHeight,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	})

	surface.CreateFont("LGButtonFont", {
		font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = scaledHeightButton,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	})
end

local hasMadeFonts = false

LiteGibs.DisplayBrutalConfirmation = function()
	if not hasMadeFonts then
		setupFonts()
	end

	local totalW, totalH = ScrW() * 0.75, ScrH() * 0.25
	local frame = vgui.Create("DPanel")
	frame:SetSize(totalW, totalH)
	frame:Center()
	frame:MakePopup()
	frame.startTime = SysTime()

	frame.Paint = function(p, w, h)
		Derma_DrawBackgroundBlur(p, p.startTime)
		SimpleDarkTranslucent(p, w, h)
	end
	local text = vgui.Create("DLabel")
	text:DockMargin(8, 8, 8, 0)
	text:SetParent(frame)
	text:Dock(TOP)
	text:SetFont("LGDescriptionFont")
	text:SetTextColor(textColor)
	text:SetContentAlignment(5)
	text:SetText("Are you sure?")
	text:SizeToContentsY()
	text:Center()
	local text2 = vgui.Create("DLabel")
	text2:DockMargin(8, 0, 8, 8)
	text2:SetParent(frame)
	text2:Dock(TOP)
	text2:SetFont("LGDescriptionFont")
	text2:SetTextColor(textColor)
	text2:SetContentAlignment(5)
	text2:SetText("This mode is extremely graphic and may be disturbing.")
	text2:SizeToContentsY()
	text2:Center()
	local buttonDocker = vgui.Create("DPanel")
	buttonDocker:SetParent(frame)
	buttonDocker:Dock(FILL)
	buttonDocker.Paint = function(p, w, h) end
	local buttonNo = vgui.Create("DButton")
	buttonNo:DockMargin(8, 8, 8, 8)
	buttonNo:SetParent(buttonDocker)
	buttonNo:Dock(LEFT)
	buttonNo:SetWidth(totalW / 2)
	buttonNo:SetText("No")
	buttonNo:SetFont("LGButtonFont")
	buttonNo:SetTextColor(textColor)
	buttonNo.Paint = ButtonDrawMat

	buttonNo.DoClick = function()
		LiteGibs.SetupMenu()
		if IsValid(frame) then
			frame:Remove()
		end
	end

	local buttonYes = vgui.Create("DButton")
	buttonYes:DockMargin(8, 8, 8, 8)
	buttonYes:SetParent(buttonDocker)
	buttonYes:Dock(LEFT)
	buttonYes:SetWidth(totalW / 2)
	buttonYes:SetText("Yes")
	buttonYes:SetFont("LGButtonFont")
	buttonYes:SetTextColor(textColor)
	buttonYes.Paint = ButtonDrawMat

	buttonYes.DoClick = function()
		ApplySettings(settings["high"])
		if IsValid(frame) then
			frame:Remove()
		end
	end
end

LiteGibs.SetupMenu = function()
	if not hasMadeFonts then
		setupFonts()
	end

	local totalW, totalH = ScrW() * 0.75, ScrH() * 0.75
	local frame = vgui.Create("DPanel")
	frame:SetSize(totalW, totalH)
	frame:Center()
	frame:MakePopup()
	frame.startTime = SysTime()

	frame.Paint = function(p, w, h)
		Derma_DrawBackgroundBlur(p, p.startTime)
		SimpleDarkTranslucent(p, w, h)
	end

	local logo = vgui.Create("DPanel")
	logo:SetParent(frame)
	logo:Dock(TOP)
	logo:SetHeight(totalH / 3)

	logo.Paint = function(p, w, h)
		surface.SetMaterial(logoMat)
		surface.SetDrawColor(bloodColor)
		local nw = math.min(w, h * 2)
		local nh = nw / 2
		surface.DrawTexturedRect((w - nw) / 2, (h - nh) / 2, nw, nh)
	end

	local text = vgui.Create("DLabel")
	text:DockMargin(8, 8, 8, 0)
	text:SetParent(frame)
	text:Dock(TOP)
	--text:SetHeight(textHeight)
	text:SetFont("LGDescriptionFont")
	text:SetTextColor(textColor)
	text:SetContentAlignment(5)
	text:SetText("Welcome to LiteGibs.")
	text:SizeToContentsY()
	text:Center()
	local text2 = vgui.Create("DLabel")
	text2:DockMargin(8, 0, 8, 8)
	text2:SetParent(frame)
	text2:Dock(TOP)
	text2:SetFont("LGDescriptionFont")
	text2:SetTextColor(textColor)
	text2:SetContentAlignment(5)
	text2:SetText("Please select your level of violence.")
	text2:SizeToContentsY()
	text2:Center()
	local buttonDocker = vgui.Create("DPanel")
	buttonDocker:SetParent(frame)
	buttonDocker:Dock(FILL)
	buttonDocker.Paint = function(p, w, h) end
	local buttonLow = vgui.Create("DButton")
	buttonLow:SetParent(buttonDocker)
	buttonLow:Dock(LEFT)
	buttonLow:SetWidth(totalW / 3)
	buttonLow:SetText("Bloody")
	buttonLow:SetFont("LGButtonFont")
	buttonLow:SetTextColor(textColor)
	buttonLow.mat = goreLowMat
	buttonLow.Paint = ButtonDrawMat

	buttonLow.DoClick = function()
		ApplySettings(settings["low"])

		if IsValid(frame) then
			frame:Remove()
		end
	end

	local buttonMid = vgui.Create("DButton")
	buttonMid:SetParent(buttonDocker)
	buttonMid:Dock(LEFT)
	buttonMid:SetWidth(totalW / 3)
	buttonMid:SetText("Brutal")
	buttonMid:SetFont("LGButtonFont")
	buttonMid:SetTextColor(textColor)
	buttonMid.mat = goreMidMat
	buttonMid.Paint = ButtonDrawMat

	buttonMid.DoClick = function()
		ApplySettings(settings["mid"])

		if IsValid(frame) then
			frame:Remove()
		end
	end

	local buttonHigh = vgui.Create("DButton")
	buttonHigh:SetParent(buttonDocker)
	buttonHigh:Dock(LEFT)
	buttonHigh:SetWidth(totalW / 3)
	buttonHigh:SetText("Ludicrous")
	buttonHigh:SetFont("LGButtonFont")
	buttonHigh:SetTextColor(textColor)
	buttonHigh.mat = goreHighMat
	buttonHigh.Paint = ButtonDrawMat

	buttonHigh.DoClick = function()
		LiteGibs.DisplayBrutalConfirmation()

		if IsValid(frame) then
			frame:Remove()
		end
	end
end

concommand.Add("litegibs_setup", LiteGibs.SetupMenu)


