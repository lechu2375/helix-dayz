if SAM_LOADED then return end

local sam = sam
local config = sam.config

local times = {}

local entry_OnValueChange = function(s)
	s:SetTall(s:GetNumLines() * (sam.SUI.Scale(16) --[[font size]] + 1) + 1 + 2)
end

local entry_OnEnter = function(s)
	local ads = config.get("Adverts")
	local txt = s:GetText()
	if txt == "" then
		s:Remove()
		if s.i then
			table.remove(ads, s.i)
		end
	else
		if txt == s.ad then return end
		ads[s.i] = txt
		s.ad = txt
	end
	config.set("Adverts", ads, true)
end

local entry_OnKeyCodeTyped = function(s, code)
	if code == KEY_ENTER then
		s:old_OnKeyCodeTyped(code)
		return true
	else
		return s:old_OnKeyCodeTyped(code)
	end
end

config.add_menu_setting("Adverts", function(body)
	local adverts_body

	local adverts = body:Add("SAM.LabelPanel")
	adverts:Dock(TOP)
	adverts:DockMargin(8, 6, 8, 0)
	adverts:SetLabel("Adverts\n- Random adverts print every 60 seconds\n- Timed adverts can be done like this: {1m} This advert prints every 1 minute")

	local add_advert = adverts:Add("SAM.Button")
	add_advert:SetText("+")
	add_advert:SetSize(25, 25)

	local zpos = 0
	local add_func = function(ad, ad_i)
		zpos = zpos + 1

		local entry = adverts_body:Add("SAM.TextEntry")
		entry:SetPlaceholder("")
		entry:SetMultiline(true)
		entry:SetNoBar(true)
		entry:Dock(TOP)
		entry:DockMargin(8, 6, 8, 0)
		entry:SetZPos(zpos)
		entry.ad = ad
		entry.no_scale = true

		if not sam.ispanel(ad) then
			entry.i = ad_i
			entry:SetValue(ad)
		else
			entry.i = #config.get("Adverts") + 1
		end

		entry.OnValueChange = entry_OnValueChange
		entry.OnEnter = entry_OnEnter
		entry.old_OnKeyCodeTyped = entry.OnKeyCodeTyped
		entry.OnKeyCodeTyped = entry_OnKeyCodeTyped
	end
	add_advert:On("DoClick", add_func)

	adverts_body = body:Add("Panel")
	adverts_body:Dock(TOP)

	function adverts_body:PerformLayout(w, h)
		for k, v in ipairs(self:GetChildren()) do
			entry_OnValueChange(v)
		end
		self:SizeToChildren(false, true)
	end

	sam.config.hook({"Adverts"}, function()
		if not IsValid(adverts_body) then return end
		adverts_body:Clear()

		for k, v in ipairs(config.get("Adverts")) do
			add_func(v, k)
		end
	end)
end)

local random = {}

timer.Create("SAM.Advert.RandomAdverts", 60, 0, function()
	local ad = random[math.random(1, #random)]
	if not ad then return end
	sam.player.send_message(nil, ad)
end)

sam.config.hook({"Adverts"}, function()
	for i = #times, 1, -1 do
		times[i] = nil
		timer.Remove("SAM.Adverts." .. i)
	end

	random = {}
	for k, v in ipairs(config.get("Adverts")) do
		if v:sub(1, 1) == "{" then
			local time
			time, v = v:match("(%b{}) *(.*)")
			time = sam.parse_length(time)
			if time then
				timer.Create("SAM.Adverts." .. table.insert(times, true), time * 60, 0, function()
					sam.player.send_message(nil, v)
				end)
			end
		else
			table.insert(random, v)
		end
	end
end)