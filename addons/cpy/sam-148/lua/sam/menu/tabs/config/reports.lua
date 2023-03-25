if SAM_LOADED then return end

local sam = sam
local config = sam.config

local not_empty = function(s)
	return s and s ~= ""
end

local number_entry = function(setting, config_key, default)
	local entry = setting:Add("SAM.TextEntry")
	entry:SetWide(50)
	entry:SetPlaceholder("")
	entry:SetBackground(Color(34, 34, 34))
	entry:SetNumeric(true)
	entry:DisallowFloats()
	entry:DisallowNegative()
	entry:SetCheck(not_empty)
	entry:SetConfig(config_key, default)

	return entry
end

config.add_tab("Reports", function(parent)
	local body = parent:Add("SAM.ScrollPanel")
	body:Dock(FILL)
	body:LineMargin(0, 6, 0, 0)

	local i = 0
	body:GetCanvas():On("OnChildAdded", function(s, child)
		i = i + 1
		child:SetZPos(i)

		if not body.making_line then
			body:Line()
		end
	end)

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Enable")
		setting:DockMargin(8, 6, 8, 0)

		local enable = setting:Add("SAM.ToggleButton")
		enable:SetConfig("Reports", true)
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Commands")
		setting:DockMargin(8, 6, 8, 0)

		local entry = setting:Add("SAM.TextEntry")
		entry:SetWide(200)
		entry:SetNoBar(true)
		entry:SetPlaceholder("")
		entry:SetMultiline(true)
		entry:SetConfig("Reports.Commands")
		entry.no_scale = true

		function entry:OnValueChange()
			self:SetTall(self:GetNumLines() * (sam.SUI.Scale(16) --[[font size]] + 1) + 1 + 2)
		end
		entry:OnValueChange()
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Max Reports (Number of reports that can show on your screen)")
		setting:DockMargin(8, 6, 8, 0)

		number_entry(setting, "Reports.MaxReports", 4)
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Auto Close Time (Time to wait before automatically closing claimed reports)")
		setting:DockMargin(8, 6, 8, 0)

		local entry = setting:Add("SAM.TextEntry")
		entry:SetWide(70)
		entry:SetNoBar(false)
		entry:SetPlaceholder("")
		entry:SetCheck(function(time)
			time = sam.parse_length(time)
			if not time then
				return false
			end
		end)
		entry:SetConfig("Reports.AutoCloseTime", "10m")
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Always Show (Show the popups even if you are not on duty)")
		setting:DockMargin(8, 6, 8, 0)

		local enable = setting:Add("SAM.ToggleButton")
		enable:SetConfig("Reports.AlwaysShow", true)
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("On Duty Jobs")
		setting:DockMargin(8, 6, 8, 0)

		local entry = setting:Add("SAM.TextEntry")
		entry:SetWide(300)
		entry:SetNoBar(true)
		entry:SetPlaceholder("")
		entry:SetMultiline(true)
		entry:SetConfig("Reports.DutyJobs", "")
		entry.no_scale = true

		function entry:OnValueChange()
			self:SetTall(self:GetNumLines() * (sam.SUI.Scale(16) --[[font size]] + 1) + 1 + 2)
		end
		entry:OnValueChange()
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Position")
		setting:DockMargin(8, 6, 8, 0)

		local combo = setting:Add("SAM.ComboBox")
		combo:SetWide(60)
		combo:AddChoice("Left", nil, true)
		combo:AddChoice("Right")
		combo:SetConfig("Reports.Position", "Left")
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("X Padding")
		setting:DockMargin(8, 6, 8, 0)

		number_entry(setting, "Reports.XPadding", 5)
	end

	do
		local setting = body:Add("SAM.LabelPanel")
		setting:Dock(TOP)
		setting:SetLabel("Y Padding")
		setting:DockMargin(8, 6, 8, 0)

		number_entry(setting, "Reports.YPadding", 5)
	end

	return body
end, function()
	return LocalPlayer():HasPermission("manage_config")
end, 2)