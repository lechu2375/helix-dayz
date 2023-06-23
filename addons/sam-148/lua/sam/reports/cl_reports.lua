if SAM_LOADED then return end

local sam = sam
local netstream = sam.netstream
local SUI = sam.SUI

local config = sam.config

local Trim = string.Trim

local muted_var = CreateClientConVar("sam_mute_reports", "0", false, false, "", 0, 1)

local position = config.get_updated("Reports.Position", "Left")
local max_reports = config.get_updated("Reports.MaxReports", 4)
local always_show = config.get_updated("Reports.AlwaysShow", true)
local pad_x = config.get_updated("Reports.XPadding", 5)
local pad_y = config.get_updated("Reports.YPadding", 5)

local duty_jobs = {}
config.hook({"Reports.DutyJobs"}, function()
	local jobs = config.get("Reports.DutyJobs", ""):Split(",")
	for i = #jobs, 1, -1 do
		local v = Trim(jobs[i])
		if v ~= "" then
			jobs[v] = true
		end
		jobs[i] = nil
	end
	duty_jobs = jobs
end)

local commands = {}
config.hook({"Reports.Commands"}, function()
	local cmds = config.get("Reports.Commands", ""):Split(",")
	for i = 1, #cmds do
		local v = Trim(cmds[i])
		if v ~= "" then
			cmds[i] = {
				name = v,
				func = function(_, ply)
					if IsValid(ply) then
						RunConsoleCommand("sam", v, "#" .. ply:EntIndex())
					end
				end
			}
		end
	end
	commands = cmds
end)

local reports = {}
local queued_reports = {}

local new_report, remove_report, check_queued, get_report, append_report

get_report = function(ply, index)
	for i = 1, #reports do
		local v = reports[i]
		local _ply = index and v.index or v.ply
		if _ply == ply then return v end
	end

	for i = 1, #queued_reports do
		local v = queued_reports[i]
		local _ply = index and v.index or v.ply
		if _ply == ply then return v, i end
	end
end

remove_report = function(ply)
	local report, delayed_i = get_report(ply)

	if delayed_i then
		return table.remove(queued_reports, delayed_i)
	end

	local panel = report.panel
	panel:MoveToNewX(position.value == "Right" and ScrW() or -panel:GetWide(), function()
		for i = report.pos + 1, #reports do
			local v = reports[i]
			v.pos = v.pos - 1
			v.panel:MoveToNewY(v.panel:GetY())
		end

		panel:Remove()
		table.remove(reports, report.pos)

		check_queued()
	end)
end

check_queued = function()
	while (max_reports.value - #reports > 0 and #queued_reports > 0) do
		new_report(table.remove(queued_reports, 1))
	end
end

append_report = function(ply, text)
	local report, delayed = get_report(ply)
	if delayed then
		table.insert(report.comments, text)
	else
		report.panel:AddComment(text)
	end
end

new_report = function(report)
	if #reports >= max_reports.value then
		return table.insert(queued_reports, report)
	end

	report.pos = table.insert(reports, report)

	local panel = vgui.Create("SAM.Report")
	panel:SetReport(report)

	for k, v in ipairs(commands) do
		panel:AddButton(v.name:gsub("^%l", string.upper), v.func)
	end

	local claim = panel:AddButton("Claim", function(self, ply)
		if panel:HasReport() then
			return LocalPlayer():sam_send_message("You have an active case, close it first.")
		end

		self.DoClick = function()
		end

		local claim_query = netstream.async.Start("ClaimReport", nil, ply)
		claim_query:done(function(claimed)
			if not IsValid(panel) then return end

			if claimed then
				panel:SetHasReport(ply)

				self:SetText("Close")

				self.background = Color(231, 76, 60, 200)
				self.hover = Color(255, 255, 255, 25)

				panel:FixWide()

				for k, v in ipairs(panel:GetChildren()[3]:GetChildren()) do
					v:SetDisabled(false)
					v:SetCursor("hand")
				end

				self.DoClick = function()
					panel:Close()
				end
			else
				panel:SetClaimed()
			end
		end)
	end)

	panel.claim = claim

	claim:SetCursor("hand")
	claim:SetDisabled(false)

	claim.background = Color(39, 174, 96, 200)
	claim.hover = Color(255, 255, 255, 25)

	panel:FixWide()

	local x = pad_x.value
	if position.value == "Right" then
		x = (ScrW() - panel:GetWide()) - x
	end

	panel:MoveToNewX(x)
	panel:MoveToNewY(panel:GetY())

	panel.new = true
	for k, v in ipairs(report.comments) do
		panel:AddComment(v)
	end
	panel.new = nil
end

netstream.Hook("Report", function(ply, comment)
	if not IsValid(ply) then return end

	if muted_var:GetBool() then return end

	local report = get_report(ply)
	if not report then
		report = {
			ply = ply,
			index = ply:EntIndex(),
			comments = {comment}
		}

		if not always_show.value and not duty_jobs[team.GetName(LocalPlayer():Team())] then
			LocalPlayer():sam_send_message("({S Blue}) {S_2 Red}: {S_3}", {
				S = "Report", S_2 = ply:Name(), S_3 = comment
			})
		else
			new_report(report)
		end
	else
		append_report(ply, comment)
	end
end)

netstream.Hook("ReportClaimed", function(ply)
	local report, delayed = get_report(ply)
	if not report then return end

	if delayed then
		table.remove(queued_reports, delayed)
	else
		report.panel:SetClaimed()
	end
end)

netstream.Hook("ReportClosed", function(index)
	local report, delayed = get_report(index, true)
	if not report then return end

	if delayed then
		table.remove(queued_reports, delayed)
	else
		report.panel:SetClosed()
	end
end)

do
	local REPORTS_HEADER = SUI.CreateFont("ReportHeader", "Roboto", 14, 540)
	local REPORT_COMMENT = SUI.CreateFont("ReportComment", "Roboto", 13, 540)
	local REPORT_BUTTONS = SUI.CreateFont("ReportButtons", "Roboto", 13, 550)

	local Panel = {}

	function Panel:Init()
		sui.TDLib.Start()

		self:Blur()
			:Background(Color(30, 30, 30, 240))

		local p_w, p_h = SUI.Scale(300), SUI.Scale(125)
		self:SetSize(p_w, p_h)

		local x = p_w * 2

		if position.value == "Right" then
			x = ScrW() + x
		else
			x = -x
		end

		self:SetPos(x, -p_h)

		local top_panel = self:Add("Panel")
		top_panel:Dock(TOP)
		top_panel:SetTall(SUI.Scale(24))
		top_panel:Background(Color(60, 60, 60, 200))

		local ply_name = top_panel:Add("DLabel")
		ply_name:Dock(LEFT)
		ply_name:DockMargin(5, 0, 0, 0)
		ply_name:SetTextColor(Color(200, 200, 200))
		ply_name:SetFont(REPORTS_HEADER)
		self.ply_name = ply_name

		local scroll = self:Add("SAM.ScrollPanel")
		scroll:Dock(FILL)
		scroll:DockMargin(5, 5, 5, 5)
		scroll.Paint = nil
		self.scroll = scroll

		local comment = scroll:Add("DLabel")
		comment:Dock(TOP)
		comment:SetText("")
		comment:SetTextColor(Color(200, 200, 200))
		comment:SetFont(REPORT_COMMENT)
		comment:SetMultiline(true)
		comment:SetWrap(true)
		comment:SetAutoStretchVertical(true)
		self.comment = comment

		local bottom = self:Add("Panel")
		bottom:Dock(BOTTOM)
		bottom:SetTall(SUI.Scale(24))
		self.bottom = bottom

		sui.TDLib.End()
	end

	function Panel:GetY()
		return (self:GetTall() + 5) * (self.report.pos - 1) + pad_y.value
	end

	function Panel:Close()
		remove_report(self.report.ply)
	end

	local change_state = function(self, text)
		self.claim:SetText(text)
		self.claim.DoClick = function() end

		self.claim:SUI_TDLib()
			:Background(Color(41, 128, 185, 200))

		timer.Simple(5, function()
			if IsValid(self) then
				self:Close()
			end
		end)

		if self:HasReport() == self.report.ply then
			self:SetHasReport()
		end

		self:FixWide()
	end

	function Panel:SetClaimed()
		change_state(self, "Case clamied!")
	end

	function Panel:SetClosed()
		change_state(self, "Case closed!")
	end

	function Panel:SetReport(report)
		surface.PlaySound("garrysmod/balloon_pop_cute.wav")

		report.panel = self

		self.report = report
		self.ply_name:SetText(report.ply:Name())
		self.ply_name:SetWide(self:GetWide())
	end

	local disabled = Color(60, 60, 60, 200)
	local click = Color(255, 255, 255, 30)
	local button_paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self.background)

		if self:GetDisabled() then
			draw.RoundedBox(0, 0, 0, w, h, disabled)
		else
			if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, self.hover)
			end

			if self.Depressed then
				draw.RoundedBox(0, 0, 0, w, h, click)
			end
		end
	end

	local button_click = function(self)
		self.cb(self, self.report.ply)
	end

	local background = Color(60, 60, 60, 200)
	local hover = Color(14, 134, 204, 100)
	function Panel:AddButton(text, cb)
		local button = self.bottom:Add("DButton")
		button:Dock(LEFT)
		button:SetText(text)
		button:SetTextColor(Color(200, 200, 200))
		button:SetFont(REPORT_BUTTONS)
		button:SetDisabled(true)
		button:SetCursor("arrow")

		button.Paint = button_paint
		button.DoClick = button_click

		button.background = background
		button.hover = hover

		button.cb = cb
		button.report = self.report

		return button
	end

	function Panel:FixWide()
		local wide = 0

		for _, v in ipairs(self.bottom:GetChildren()) do
			v:SizeToContents()
			v:SetWide(v:GetWide() + 6)
			wide = wide + v:GetWide()
		end

		self:SetWide(wide)

		return wide
	end

	function Panel:OnRemove()
		local reporter = self:HasReport()
		if reporter then
			netstream.Start("CloseReport", reporter)
			self:SetHasReport()
		end
	end

	function Panel:AddComment(text)
		local comment = self.comment

		local old_text = comment:GetText()
		if old_text ~= "" then
			old_text = old_text .. "\n"
		end

		if not self.new then
			surface.PlaySound("ambient/water/drip4.wav")
		end

		comment:SetText(old_text .. "- " .. text)
		comment:SizeToContents()

		self.scroll:ScrollToBottom()
	end

	function Panel:HasReport()
		return LocalPlayer().sam_has_report
	end

	function Panel:SetHasReport(v)
		LocalPlayer().sam_has_report = v
	end

	local new_animation = function(panel, name)
		local new_name = "anim_" .. name
		panel["MoveToNew" .. name:upper()] = function(self, new, cb)
			if self[new_name] then
				table.RemoveByValue(self.m_AnimList, self[new_name])
			end

			self[new_name] = self:NewAnimation(0.2, 0, -1, function()
				self[new_name] = nil
				if cb then cb() end
			end)

			self[new_name].Think = function(_, _, frac)
				self[name] = Lerp(frac, self[name], new)
			end
		end
	end

	new_animation(Panel, "x")
	new_animation(Panel, "y")

	vgui.Register("SAM.Report", Panel, "EditablePanel")
end