local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "logging")
	else
		return GAS:PhraseFormat(phrase, "logging", ...)
	end
end

surface.CreateFont("gas_logging_damagelog_pct", {
	size = 24,
	font = "Circular Std Medium",
	bold = true,
})

surface.CreateFont("gas_logging_damagelog_delay", {
	size = 12,
	font = "Circular Std Medium"
})

local module_icon_cache = {}
local module_noicon = Material("icon16/page_white_text.png")
local function GetModuleIcon(module_id)
	if (module_icon_cache[module_id]) then
		return module_icon_cache[module_id]
	else
		local module_data = GAS.Logging.IndexedModules[module_id]
		if (module_data.Icon ~= nil) then
			local mat = Material(module_data.Icon)
			module_icon_cache[module_id] = mat
			return mat
		else
			return module_noicon
		end
	end
end

GAS_Logging_PvPEventReports = {}

local PANEL = {}

function PANEL:DoClick()
	local this = self

	GAS:PlaySound("popup")
	if (IsValid(GAS_Logging_PvPEventReports[self.data[GAS.Logging.PvP_EVENT_ID]])) then
		GAS_Logging_PvPEventReports[self.data[GAS.Logging.PvP_EVENT_ID]]:MakePopup()
		GAS_Logging_PvPEventReports[self.data[GAS.Logging.PvP_EVENT_ID]]:Center()
	else
		local total_time = this.data[GAS.Logging.PvP_LAST_UPDATED] - this.data[GAS.Logging.PvP_PRECISE_CREATION_TIME]

		local pvp_event_report = vgui.Create("bVGUI.Frame")
		pvp_event_report.data = self.data

		GAS_Logging_PvPEventReports[self.data[GAS.Logging.PvP_EVENT_ID]] = pvp_event_report

		pvp_event_report:SetSize(800,500)
		pvp_event_report:SetMinimumSize(pvp_event_report:GetSize())
		pvp_event_report:SetTitle(L"pvp_event_report")
		pvp_event_report:MakePopup()
		pvp_event_report:Center()
		function pvp_event_report:OnClose()
			GAS.Logging.Scenes:ClearScene(pvp_event_report.data[GAS.Logging.PvP_COMBAT_SCENE])
			if (IsValid(this) and this.DeleteMeOnClose) then
				this:Remove()
			end
		end

		local info_container = vgui.Create("bVGUI.BlankPanel", pvp_event_report)
		info_container:Dock(FILL)

		local scene_container = vgui.Create("bVGUI.BlankPanel", pvp_event_report)
		scene_container:Dock(LEFT)
		scene_container:SetWide(200)

			local scene_beginning = vgui.Create("bVGUI.RenderScene", scene_container)
			scene_beginning:SetLabel(L"event_start")
			function scene_beginning:OnStartRender()
				GAS.Logging.Scenes:ViewScene(pvp_event_report.data[GAS.Logging.PvP_COMBAT_SCENE], true, function(pos, ang)
					if (not IsValid(self)) then return end
					if (self.SetDefaultPositioning) then return end
					self.SetDefaultPositioning = true
					self:SetOrigin(pos)
					self:SetAngle(ang)
				end)
			end
			function scene_beginning:OnEndRender()
				GAS.Logging.Scenes:ClearScene(pvp_event_report.data[GAS.Logging.PvP_COMBAT_SCENE], true)
			end

			local scene_end = vgui.Create("bVGUI.RenderScene", scene_container)
			scene_end:SetCanRender(not self.data[GAS.Logging.PvP_ONGOING])
			scene_end:SetLabel(L"event_end")
			function scene_end:OnStartRender()
				GAS.Logging.Scenes:ViewScene(pvp_event_report.data[GAS.Logging.PvP_COMBAT_SCENE], false, function(pos, ang)
					if (not IsValid(self)) then return end
					if (self.SetDefaultPositioning) then return end
					self.SetDefaultPositioning = true
					self:SetOrigin(pos)
					self:SetAngle(ang)
				end)
			end
			function scene_end:OnEndRender()
				GAS.Logging.Scenes:ClearScene(pvp_event_report.data[GAS.Logging.PvP_COMBAT_SCENE], false)
			end

			function scene_container:PerformLayout(w,_h)
				local h = _h + 5
				scene_beginning:SetSize(w,h/2)
				scene_end:SetSize(w,h/2)
				scene_end:AlignTop((h/2)-5)
			end

		local timeline = vgui.Create("bVGUI.BlankPanel", info_container)
		timeline:SetMouseInputEnabled(true)
		timeline:Dock(TOP)
		timeline:SetTall(70)
		timeline.Scale = math.max(1, total_time * 1.25)
		timeline.BlipOffset = 0
		timeline.DmgEventBlips = {}
		function timeline:OnMouseWheeled(delta)
			local scale_change = timeline.Scale
			if (delta == 1) then
				timeline.Scale = timeline.Scale * 2
			elseif (delta == -1) then
				timeline.Scale = timeline.Scale / 2
			end
			local max_scale = math.max(4, total_time * 1.25)

			timeline.Scale = math.Clamp(timeline.Scale, 0.25, max_scale)

			local x,y = timeline:ScreenToLocal(gui.MousePos())
			if (timeline.Scale >= max_scale) then
				timeline.BlipOffset = 0
			end

			timeline:RefreshBlips()
			timeline:RefreshDelayMarkup()
		end

		local blip_size = 7.5
		function timeline:RefreshBlips()
			local w,h = self:GetSize()

			local y_offset = 14 + 10

			timeline.DmgEventBlips = {}
			for i,log in ipairs(pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS]) do
				if (type(log[1]) == "table") then continue end

				local place = (log[1] / total_time) * (w * (total_time / timeline.Scale)) - timeline.BlipOffset

				local blip = {
					{x = place, y = y_offset},
					{x = place + blip_size, y = blip_size + y_offset},
					{x = place, y = (blip_size * 2) + y_offset},
					{x = place - blip_size, y = blip_size + y_offset},
				}
				if (log[3] == pvp_event_report.data[GAS.Logging.PvP_VICTIM] and log[4] == pvp_event_report.data[GAS.Logging.PvP_INSTIGATOR]) then
					timeline.DmgEventBlips[i] = {true, blip}
				elseif (log[3] == pvp_event_report.data[GAS.Logging.PvP_INSTIGATOR] and log[4] == pvp_event_report.data[GAS.Logging.PvP_VICTIM]) then
					timeline.DmgEventBlips[i] = {false, blip}
				else
					timeline.DmgEventBlips[i] = {nil, blip}
				end
			end
		end
		timeline:RefreshBlips()

		function timeline:RefreshDelayMarkup()
			local x,y = self:ScreenToLocal(gui.MousePos())
			local w,h = self:GetSize()
			if (x >= 0) then
				self.DelayMarkup = markup.Parse("<font=gas_logging_damagelog_delay>+" .. math.Round((x / (w * (total_time / self.Scale))) * total_time, 2) .. "s</font>")
			else
				self.DelayMarkup = markup.Parse("<font=gas_logging_damagelog_delay>+0s</font>")
			end
		end

		function timeline:PerformLayout()
			timeline:RefreshBlips()
		end

		local pvp_event = vgui.Create("GAS.Logging.DamageLog", info_container)
		pvp_event:Dock(TOP)
		pvp_event:Setup(self.data, false)

		local tabs = vgui.Create("bVGUI.Tabs", info_container)
		tabs:Dock(TOP)
		tabs:SetTall(40)

		local logs_tab_content, logs_tab = tabs:AddTab(L"logs", Color(216,76,76))
			
			local log_tbl = vgui.Create("bVGUI.Table", logs_tab_content)
			log_tbl:Dock(FILL)
			log_tbl:AddColumn(L"log", bVGUI.TABLE_COLUMN_GROW)
			log_tbl:AddColumn(L"instigator_abbr", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
			log_tbl:AddColumn(L"victim_abbr", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
			log_tbl:AddColumn(L"time", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
			for i,log in ipairs(this.data[GAS.Logging.PvP_EVENT_LOGS]) do
				if (type(log[1]) == "table") then
					local row = log_tbl:AddRow(GAS.Logging:FormatMarkupLog(log, nil, nil, this.data[GAS.Logging.PvP_VICTIM], this.data[GAS.Logging.PvP_INSTIGATOR]), "-", "-", "+" .. math.Round(this.data[GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY][i], 2) .. "s")
					local icon = GetModuleIcon(log[2])
					row:SetMaterial(icon)
				else
					local instigator_dmg = "-"
					local victim_dmg = "-"
					if (log[3] == this.data[GAS.Logging.PvP_VICTIM]) then
						victim_dmg = "<color=0,255,0>" .. math.Round(log[6], 2) .. "</color>"
					elseif (log[3] == this.data[GAS.Logging.PvP_INSTIGATOR]) then
						instigator_dmg = "<color=255,0,0>" .. math.Round(log[6], 2) .. "</color>"
					end
					log_tbl:AddRow(GAS.Logging:FormatMarkupLogCustom(GAS:Phrase(log[2], "logging", "Logs"), log[5], nil, nil, this.data[GAS.Logging.PvP_VICTIM], this.data[GAS.Logging.PvP_INSTIGATOR]), instigator_dmg, victim_dmg, "+" .. math.Round(log[1], 2) .. "s")
				end
			end

		local weapons_tab_content, weapons_tab = tabs:AddTab(L"weapons", Color(76,76,216))

			local weapons_grid = vgui.Create("bVGUI.Grid", weapons_tab_content)
			weapons_grid:Dock(FILL)
			weapons_grid:SetPadding(10,10)

			local merged_weps = {}
			for weapon_class, dmg in pairs(pvp_event_report.data[GAS.Logging.PvP_INSTIGATOR_WEPS]) do
				merged_weps[weapon_class] = merged_weps[weapon_class] or {0,0}
				merged_weps[weapon_class][1] = merged_weps[weapon_class][1] + dmg
			end
			for weapon_class, dmg in pairs(pvp_event_report.data[GAS.Logging.PvP_VICTIM_WEPS]) do
				merged_weps[weapon_class] = merged_weps[weapon_class] or {0,0}
				merged_weps[weapon_class][2] = merged_weps[weapon_class][2] + dmg
			end

			for weapon_class, dmgs in pairs(merged_weps) do
				local ent_display = vgui.Create("GAS.Logging.EntityDisplay", weapons_grid)
				ent_display:SetWeapon(weapon_class)
				ent_display:SetDrawOnTop(false)
				ent_display.Think = nil
				weapons_grid:AddToGrid(ent_display)
			end

		local linked_events_tab_content, linked_events_tab = tabs:AddTab(L"linked_events", Color(216,76,76))



		local log_tbl_highlights = {}
		local timeline_hover_last_prev_frame
		local timeline_hover_exact_prev_frame
		function timeline:Paint(w,h)
			local x,y = self:ScreenToLocal(gui.MousePos())
			local target_time_point = (x / (w * (total_time / self.Scale))) * total_time
			local target_time_point_rnd = math.Round(target_time_point, 2)

			if (x ~= self.StoreX) then
				self.StoreX = x
				timeline:RefreshDelayMarkup()
			end

			surface.SetDrawColor(26,26,26)
			surface.DrawRect(0,0,w,h)

			surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT_LARGE)
			surface.DrawTexturedRect(0,0,w,h)

			surface.SetDrawColor(50, 50, 50)
			local spacing = w / self.Scale
			for i=1,self.Scale do
				surface.DrawLine((i - 1) * spacing,0,(i - 1) * spacing,h)
			end
			if (self.Scale < 5) then
				local spacing = w / math.floor(self.Scale / .25)
				for i=1,math.floor(self.Scale / .25) do
					if ((i - 1) % 4 == 0) then continue end
					if ((i - 1) % 2 == 0) then
						surface.SetDrawColor(37, 37, 37)
					else
						surface.SetDrawColor(30, 30, 30)
					end
					surface.DrawLine((i - 1) * spacing,0,(i - 1) * spacing,h)
				end
			end

			surface.SetDrawColor(181,39,39)
			surface.DrawRect(0,0,w,14)

			surface.SetDrawColor(181,39,39)
			surface.DrawRect(0,0,w * (total_time / self.Scale),14)

			if (self.DelayMarkupW ~= nil and x >= 0 and x <= w) then
				surface.SetDrawColor(0,0,0,200)
				surface.DrawRect(x - ((self.DelayMarkupW + 15) / 2),0,self.DelayMarkupW + 15,14)
			end

			local timeline_hover_exact
			local timeline_hover_last = target_time_point > total_time
			if (timeline_hover_last) then
				for k,v in pairs(log_tbl_highlights) do
					if (k ~= #pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS]) then
						log_tbl_highlights = {}
						break
					end
				end
				log_tbl_highlights[#pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS]] = true
			elseif (timeline_hover_last_prev_frame ~= timeline_hover_last) then
				log_tbl_highlights[#pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS]] = nil
			end
			timeline_hover_last_prev_frame = timeline_hover_last

			for i,log in ipairs(pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS]) do
				local time_point
				if (type(log[1]) == "table") then
					-- event log
					time_point = pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY][i]

					local icon = GetModuleIcon(log[2])
					surface.SetDrawColor(255,255,255)
					surface.SetMaterial(icon)
					surface.DrawTexturedRect((time_point / total_time) * (w * (total_time / self.Scale)) - (16 / 2) - timeline.BlipOffset, h - 16 - 10, 16, 16)
				else
					-- damage log
					local poly = timeline.DmgEventBlips[i]
					draw.NoTexture()
					if (poly[1] == true) then
						surface.SetDrawColor(215,50,50,200)
					elseif (poly[1] == false) then
						surface.SetDrawColor(50,215,50,200)
					else
						surface.SetDrawColor(50,50,215,200)
					end
					surface.DrawPoly(poly[2])

					time_point = log[1]
				end

				if (not timeline_hover_last) then
					local time_point_rnd = math.Round(time_point, 2)
					if (timeline_hover_exact ~= nil) then
						log_tbl_highlights[i] = (time_point_rnd == timeline_hover_exact) or nil
					elseif (time_point_rnd == target_time_point_rnd) then
						timeline_hover_exact = target_time_point_rnd
						log_tbl_highlights[i] = true
					else
						if (i ~= 1 and target_time_point < time_point) then
							local prev = pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS][i - 1]
							local prev_time_point = prev[1]
							if (type(prev[1]) == "table") then
								prev_time_point = pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY][i - 1]
							end
							if (target_time_point > prev_time_point) then
								local median = (prev_time_point + time_point) / 2
								if (target_time_point > median) then
									log_tbl_highlights[i] = true
									log_tbl_highlights[i - 1] = nil
								else
									log_tbl_highlights[i] = nil
									log_tbl_highlights[i - 1] = true
								end
							else
								log_tbl_highlights[i] = nil
							end
						elseif (i ~= #pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS] and target_time_point > time_point) then
							local next = pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS][i + 1]
							local next_time_point = next[1]
							if (type(next[1]) == "table") then
								next_time_point = pvp_event_report.data[GAS.Logging.PvP_EVENT_LOGS_CHRONOLOGY][i + 1]
							end
							if (target_time_point < next_time_point) then
								local median = (next_time_point + time_point) / 2
								if (target_time_point > median) then
									log_tbl_highlights[i] = nil
									log_tbl_highlights[i + 1] = true
								else
									log_tbl_highlights[i] = true
									log_tbl_highlights[i + 1] = nil
								end
							else
								log_tbl_highlights[i] = nil
							end
						end
					end
				end
			end

			if (x >= 0 and x <= w) then
				surface.SetDrawColor(100,100,100)
				surface.DrawLine(x,14,x,h)

				if (self.DelayMarkup) then
					self.DelayMarkup:Draw(x, 7, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					self.DelayMarkupW = self.DelayMarkup:GetWidth()
				end
			elseif (next(log_tbl_highlights) ~= nil) then
				log_tbl_highlights = {}
			end

			for i,row in ipairs(log_tbl.Rows) do
				row.Highlight = log_tbl_highlights[i] == true
				if (row.Highlight and pvp_event_report:HasFocus() and (not IsValid(vgui.GetHoveredPanel()) or not log_tbl:IsOurChild(vgui.GetHoveredPanel()))) then
					if (self.ScrollToChild_Prev ~= row) then
						self.ScrollToChild_Prev = row
						log_tbl.RowContainer:ScrollToChild(row)
					end
				end
			end
		end

		pvp_event_report:EnableUserResize()
	end
end
function PANEL:OnMousePressed(m)
	self._pressed = m
end
function PANEL:OnMouseReleased(m)
	if (self._pressed == m) then
		if (m == MOUSE_LEFT and self.DoClick) then
			self:DoClick()
		end
		self._pressed = nil
	end
end

function PANEL:Init()
	self:SetMouseInputEnabled(true)

	self:SetTall(95)

	self.InstigatorAvatar = vgui.Create("AvatarImage", self)
	self.InstigatorAvatar:SetSize(48,48)
	self.InstigatorAvatar:SetCursor("hand")
	self.InstigatorAvatar:SetMouseInputEnabled(true)
	function self.InstigatorAvatar:OnMouseReleased(m) if m ~= MOUSE_LEFT then return else bVGUI.PlayerTooltip.Focus() end end

	self.InstigatorDead = vgui.Create("DLabel", self)
	self.InstigatorDead:SetTextColor(Color(255,0,0))
	self.InstigatorDead:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.InstigatorDead:SetContentAlignment(4)
	self.InstigatorDead:SetText("")
	self.InstigatorDead:SetWide(0)

	self.InstigatorTag = vgui.Create("DLabel", self)
	self.InstigatorTag:SetTextColor(Color(255,0,0))
	self.InstigatorTag:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.InstigatorTag:SetText("[" .. string.upper(L"instigator") .. "]")
	self.InstigatorTag:SetContentAlignment(4)
	self.InstigatorTag:SizeToContents()
	bVGUI.AttachTooltip(self.InstigatorTag, {
		Text = L"instigator_tag_tip",
	})

	self.InstigatorName = vgui.Create("DLabel", self)
	self.InstigatorName:SetTextColor(bVGUI.COLOR_WHITE)
	self.InstigatorName:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.InstigatorName:SetText("")
	self.InstigatorName:SetContentAlignment(4)
	self.InstigatorName:SetCursor("hand")
	self.InstigatorName:SetMouseInputEnabled(true)
	function self.InstigatorName:DoClick() bVGUI.PlayerTooltip.Focus() end

	self.InstigatorPrimaryWep = vgui.Create("DLabel", self)
	self.InstigatorPrimaryWep:SetTextColor(GAS.Logging.LogFormattingSettings.Colors.Weapon)
	self.InstigatorPrimaryWep:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.InstigatorPrimaryWep:SetText("")
	self.InstigatorPrimaryWep:SetContentAlignment(4)
	self.InstigatorPrimaryWep:SetMouseInputEnabled(true)

	self.VictimAvatar = vgui.Create("AvatarImage", self)
	self.VictimAvatar:SetSize(48,48)
	self.VictimAvatar:SetCursor("hand")
	self.VictimAvatar:SetMouseInputEnabled(true)
	function self.VictimAvatar:OnMouseReleased(m) if m ~= MOUSE_LEFT then return else bVGUI.PlayerTooltip.Focus() end end

	self.VictimDead = vgui.Create("DLabel", self)
	self.VictimDead:SetTextColor(Color(255,0,0))
	self.VictimDead:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.VictimDead:SetContentAlignment(4)
	self.VictimDead:SetText("")
	self.VictimDead:SetWide(0)

	self.VictimTag = vgui.Create("DLabel", self)
	self.VictimTag:SetTextColor(Color(0,255,0))
	self.VictimTag:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.VictimTag:SetText("[" .. string.upper(L"victim") .. "]")
	self.VictimTag:SetContentAlignment(6)
	self.VictimTag:SizeToContents()
	bVGUI.AttachTooltip(self.VictimTag, {
		Text = L"victim_tag_tip",
	})

	self.VictimName = vgui.Create("DLabel", self)
	self.VictimName:SetTextColor(bVGUI.COLOR_WHITE)
	self.VictimName:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.VictimName:SetText("")
	self.VictimName:SetContentAlignment(6)
	self.VictimName:SetCursor("hand")
	self.VictimName:SetMouseInputEnabled(true)
	function self.VictimName:DoClick() bVGUI.PlayerTooltip.Focus() end

	self.VictimPrimaryWep = vgui.Create("DLabel", self)
	self.VictimPrimaryWep:SetTextColor(GAS.Logging.LogFormattingSettings.Colors.Weapon)
	self.VictimPrimaryWep:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.VictimPrimaryWep:SetText("")
	self.VictimPrimaryWep:SetContentAlignment(6)
	self.VictimPrimaryWep:SetMouseInputEnabled(true)

	self.FlagMetadata = {
		{GAS.Logging.PvP_FLAG_ONGOING, L"flag_ongoing", "icon16/lightbulb.png"},
		{GAS.Logging.PvP_FLAG_FINISHED, L"flag_finished", "icon16/lightbulb_off.png"},
		{GAS.Logging.PvP_FLAG_SUPERADMIN, L"flag_superadmin", "icon16/shield_add.png"},
		{GAS.Logging.PvP_FLAG_ADMIN, L"flag_admin", "icon16/shield.png"},
		{GAS.Logging.PvP_FLAG_FRIENDLYFIRE, L"flag_friendly_fire", "icon16/emoticon_unhappy.png"},
		{GAS.Logging.PvP_FLAG_LAWENFORCEMENT, L"flag_law_enforcement", "icon16/bell.png"},
		{GAS.Logging.PvP_FLAG_INSTIGATOR_DEATH, L"flag_instigator_death", "icon16/status_busy.png"},
		{GAS.Logging.PvP_FLAG_VICTIM_DEATH, L"flag_victim_death", "icon16/status_offline.png"},
		{GAS.Logging.PvP_FLAG_VEHICLE, L"flag_vehicle", "icon16/car.png"},
		{GAS.Logging.PvP_FLAG_WORLD, L"flag_world", "icon16/world.png"},
		{GAS.Logging.PvP_FLAG_PROPS, L"flag_props", "icon16/bricks.png"},
		{GAS.Logging.PvP_FLAG_TEAM_SWITCHED, L"flag_team_switched", "icon16/arrow_refresh.png"},
		{GAS.Logging.PvP_FLAG_DISCONNECT, L"flag_disconnect", "icon16/disconnect.png"},
		{GAS.Logging.PvP_FLAG_LINKED, L"flag_linked", "icon16/link.png"},
	}

	self.LogTypeMetadata = {
		[GAS.Logging.PvP_LOG_TYPE_CHAT] = {L"log_type_chat", "icon16/user_comment.png"},
		[GAS.Logging.PvP_LOG_TYPE_CHAT_TEAM] = {L"log_type_team_chat", "icon16/group.png"},
		[GAS.Logging.PvP_LOG_TYPE_WEAPON_PICKUP] = {L"log_type_weapon_pickup", "icon16/bomb.png"},
		[GAS.Logging.PvP_LOG_TYPE_WEAPON_DROPPED] = {L"log_type_weapon_drop", "icon16/arrow_down.png"},
		[GAS.Logging.PvP_LOG_TYPE_ITEM_PICKUP] = {L"log_type_item_pickup", "icon16/coins.png"},
		[GAS.Logging.PvP_LOG_TYPE_SPAWNMENU] = {L"log_type_spawnmenu", "icon16/bricks.png"},
		[GAS.Logging.PvP_LOG_TYPE_DARKRP_PURCHASE] = {L"log_type_darkrp_purchase", "icon16/money_add.png"},
		[GAS.Logging.PvP_LOG_TYPE_DISCONNECT] = {L"log_type_disconnect", "icon16/disconnect.png"},
		[GAS.Logging.PvP_LOG_TYPE_WEAPON_SWITCHED] = {L"log_type_weapon_switched", "icon16/arrow_switch.png"},
		[GAS.Logging.PvP_LOG_TYPE_TEAM_SWITCH] = {L"log_type_team_switched", "icon16/arrow_refresh.png"},
		[GAS.Logging.PVP_LOG_TYPE_SILENT_DEATH] = {L"log_type_silent_death", "icon16/status_offline.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH_WORLD] = {L"log_type_death_world", "icon16/world.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH_PLAYER_WEP] = {L"log_type_death_player_wep", "icon16/wand.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH_PLAYER] = {L"log_type_death_player", "icon16/status_offline.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH_ENT] = {L"log_type_death_ent", "icon16/status_offline.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH] = {L"log_type_death", "icon16/status_offline.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH_PROPKILL_SELF] = {L"log_type_propkill_self", "icon16/box.png"},
		[GAS.Logging.PvP_LOG_TYPE_DEATH_PROPKILL] = {L"log_type_propkill", "icon16/brick_go.png"},
	}

	self.FlagContainer = vgui.Create("bVGUI.BlankPanel", self)
	self.FlagContainer:Dock(RIGHT)
	self.FlagContainer:DockMargin(0,10,10 + 6,10 + 14)
	self.FlagContainer:SetWide(16)
	function self.FlagContainer:PerformLayout(w)
		self.Content:SetWide(w)
		self.Content:AlignRight(0)
		self.Content:CenterVertical()
	end

	self.FlagContainer.Content = vgui.Create("bVGUI.BlankPanel", self.FlagContainer)
	self.FlagContainer.Content:SetTall((3 * (16 + 5)) - 5)

	self.Timestamp = vgui.Create("DLabel", self)
	self.Timestamp:SetTextColor(bVGUI.COLOR_WHITE)
	self.Timestamp:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.Timestamp:SetText("")
	self.Timestamp:SetContentAlignment(4)
	self.Timestamp:SetMouseInputEnabled(true)
end

function PANEL:Setup(data, allow_click)
	if (allow_click == false) then
		self.DoClick = nil
	else
		self:SetCursor("hand")
	end

	self.data = data

	if (self.data[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_INSTIGATOR_DEATH]) then
		self.InstigatorDead:SetText(L"dead_tag")
		self.InstigatorDead:SizeToContents()
	end
	if (self.data[GAS.Logging.PvP_FLAGS][GAS.Logging.PvP_FLAG_VICTIM_DEATH]) then
		self.VictimDead:SetText(L"dead_tag")
		self.VictimDead:SizeToContents()
	end

	self.Timestamp:SetText(GAS:SimplifyTimestamp(self.data[GAS.Logging.PvP_CREATION_TIMESTAMP]))
	self.Timestamp:SizeToContents()
	bVGUI.AttachTooltip(self.Timestamp, {
		Text = GAS:FormatFullTimestamp(self.data[GAS.Logging.PvP_CREATION_TIMESTAMP])
	})

	self.InstigatorAvatar:SetSteamID(GAS:AccountIDToSteamID64(data[GAS.Logging.PvP_INSTIGATOR]), 48)
	self.VictimAvatar:SetSteamID(GAS:AccountIDToSteamID64(data[GAS.Logging.PvP_VICTIM]), 48)

	local instigator = player.GetByAccountID(data[GAS.Logging.PvP_INSTIGATOR])
	if (IsValid(instigator)) then
		self.InstigatorName:SetText(instigator:Nick())
	else
		self.InstigatorName:SetText(data[GAS.Logging.PvP_INSTIGATOR_NICK])
	end
	self.InstigatorName:SizeToContents()

	bVGUI.PlayerTooltip.Attach(self.InstigatorAvatar, {
		account_id = data[GAS.Logging.PvP_INSTIGATOR],
		focustip = L"click_to_focus",
	})

	bVGUI.PlayerTooltip.Attach(self.InstigatorName, {
		account_id = data[GAS.Logging.PvP_INSTIGATOR],
		focustip = L"click_to_focus",
	})

	local instigator_primary_wep = table.GetWinningKey(data[GAS.Logging.PvP_INSTIGATOR_WEPS])
	if (instigator_primary_wep ~= nil) then
		self.InstigatorPrimaryWep:SetText(instigator_primary_wep)
		self.InstigatorPrimaryWep:SizeToContents()

		GAS_Logging_DisplayEntity(function(pnl)
			pnl:SetWeapon(instigator_primary_wep)
		end, self.InstigatorPrimaryWep, true)
	end

	local victim = player.GetByAccountID(data[GAS.Logging.PvP_VICTIM])
	if (IsValid(victim)) then
		self.VictimName:SetText(victim:Nick())
	else
		self.VictimName:SetText(data[GAS.Logging.PvP_VICTIM_NICK])
	end
	self.VictimName:SizeToContents()

	bVGUI.PlayerTooltip.Attach(self.VictimAvatar, {
		account_id = data[GAS.Logging.PvP_VICTIM],
		focustip = L"click_to_focus",
	})

	bVGUI.PlayerTooltip.Attach(self.VictimName, {
		account_id = data[GAS.Logging.PvP_VICTIM],
		focustip = L"click_to_focus",
	})

	local victim_primary_wep = table.GetWinningKey(data[GAS.Logging.PvP_VICTIM_WEPS])
	if (victim_primary_wep ~= nil) then
		self.VictimPrimaryWep:SetText(victim_primary_wep)
		self.VictimPrimaryWep:SizeToContents()

		GAS_Logging_DisplayEntity(function(pnl)
			pnl:SetWeapon(victim_primary_wep)
		end, self.VictimPrimaryWep, true)
	end

	local column = 1
	local count = 0
	for i,v in ipairs(self.FlagMetadata) do
		if (data[GAS.Logging.PvP_FLAGS][v[1]] == true) then
			count = count + 1
			if (count % 3 == 0) then
				column = column + 1
			end
		end
	end
	if (count % 3 == 0) then column = column - 1 end
	self.FlagContainer:SetWide((column * (16 + 5)) - 5)
	if (column == 1) then
		self.FlagContainer.Content:SetTall((count * (16 + 5)) - 5)
	else
		self.FlagContainer.Content:SetTall((3 * (16 + 5)) - 5)
	end
	self.FlagContainer.Content:SetWide((column * (16 + 5)) - 5)
	self.FlagContainer.Content:AlignRight(0)
	self.FlagContainer.Content:CenterVertical()

	local column = 1
	local count = 0
	for i,v in ipairs(self.FlagMetadata) do
		if (data[GAS.Logging.PvP_FLAGS][v[1]] == true) then
			local flag_icon = vgui.Create("DImage", self.FlagContainer.Content)
			flag_icon:SetSize(16,16)
			flag_icon:AlignTop((count % 3) * (16 + 5))
			flag_icon:AlignRight((column - 1) * (16 + 5))
			flag_icon:SetImage(v[3])
			bVGUI.AttachTooltip(flag_icon, {
				Text = v[2]
			})
			count = count + 1
			if (count % 3 == 0) then
				column = column + 1
			end
		end
	end

	self:InvalidateLayout(true)
end

function PANEL:PerformLayout(w,h)
	self.InstigatorAvatar:AlignLeft(10)
	self.InstigatorAvatar:AlignBottom(10 + 14)

	self.VictimAvatar:AlignRight(10 + self.FlagContainer:GetWide() + 10 + 6)
	self.VictimAvatar:AlignBottom(10 + 14)

	self.InstigatorDead:AlignTop(5)
	self.InstigatorDead:AlignLeft(10)

	local instigator_death_margin, victim_death_margin = 0,0
	if (self.InstigatorDead:GetWide() > 0) then
		instigator_death_margin = self.InstigatorDead:GetWide() + 5
	end
	if (self.VictimDead:GetWide() > 0) then
		victim_death_margin = self.VictimDead:GetWide() + 5
	end

	self.InstigatorTag:AlignTop(5)
	self.InstigatorTag:AlignLeft(10 + instigator_death_margin)

	self.InstigatorName:AlignTop(5)
	self.InstigatorName:AlignLeft(10 + instigator_death_margin + self.InstigatorTag:GetWide() + 5)

	self.InstigatorPrimaryWep:AlignTop(5)
	self.InstigatorPrimaryWep:AlignLeft(10 + instigator_death_margin + self.InstigatorTag:GetWide() + 5 + self.InstigatorName:GetWide() + 5)

	self.VictimDead:AlignTop(5)
	self.VictimDead:AlignRight(10 + self.FlagContainer:GetWide() + 10 + 6)

	self.VictimTag:AlignTop(5)
	self.VictimTag:AlignRight(10 + self.FlagContainer:GetWide() + 10 + victim_death_margin + 6)

	self.VictimName:AlignTop(5)
	self.VictimName:AlignRight(10 + self.FlagContainer:GetWide() + 10 + victim_death_margin + self.VictimTag:GetWide() + 5 + 6)

	self.VictimPrimaryWep:AlignTop(5)
	self.VictimPrimaryWep:AlignRight(10 + self.FlagContainer:GetWide() + 10 + self.VictimTag:GetWide() + 5 + self.VictimName:GetWide() + 5 + victim_death_margin + 6)

	self.Timestamp:AlignLeft(10)
	self.Timestamp:AlignBottom(5)

	self.vgui_InstigatorFrac = self.data[GAS.Logging.PvP_INSTIGATOR_DMG_GVN] / self.data[GAS.Logging.PvP_TOTAL_DMG]
	self.vgui_VictimFrac     = self.data[GAS.Logging.PvP_VICTIM_DMG_GVN] / self.data[GAS.Logging.PvP_TOTAL_DMG]
	self.vgui_OtherFrac      = (self.data[GAS.Logging.PvP_TOTAL_DMG] - self.data[GAS.Logging.PvP_INSTIGATOR_DMG_GVN] - self.data[GAS.Logging.PvP_VICTIM_DMG_GVN]) / self.data[GAS.Logging.PvP_TOTAL_DMG]
	if (self.data[GAS.Logging.PvP_TOTAL_DMG] == 0) then self.vgui_OtherFrac = 1 self.vgui_VictimFrac = 0 self.vgui_InstigatorFrac = 0 end

	self.vgui_InstigatorWidth = (w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10 - 10 - 48 - 10) * self.vgui_InstigatorFrac
	self.vgui_VictimWidth     = (w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10 - 10 - 48 - 10) * self.vgui_VictimFrac
	self.vgui_OtherWidth      = (w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10 - 10 - 48 - 10) * self.vgui_OtherFrac
end

function PANEL:OnCursorMoved(x,y)
	local w,h = self:GetSize()
	if (y >= (h - 10 - 48) and y <= h - 10 and x >= 10 + 48 + 10 and x <= w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10) then
		local relative_x = x - 10 - 48 - 10
		local DmgTooltip = self.DmgTooltip
		if (relative_x <= self.vgui_InstigatorWidth) then
			self.DmgTooltip = 1
		elseif (relative_x <= self.vgui_InstigatorWidth + self.vgui_OtherWidth) then
			self.DmgTooltip = 2
		else
			self.DmgTooltip = 3
		end
		if (DmgTooltip ~= self.DmgTooltip) then
			bVGUI.DestroyTooltip()
			local tt = {
				VGUI_Element = self,
			}
			if (self.DmgTooltip == 1) then
				tt.Text = math.Round(self.vgui_InstigatorFrac * 100, 2) .. L"DmgTooltip_Instigator"
				tt.TextColor = Color(216,76,76)
			elseif (self.DmgTooltip == 2) then
				tt.Text = math.Round(self.vgui_OtherFrac * 100, 2) .. L"DmgTooltip_Other"
				tt.TextColor = Color(74,126,214)
			else
				tt.Text = math.Round(self.vgui_VictimFrac * 100, 2) .. L"DmgTooltip_Victim"
				tt.TextColor = Color(76,216,76)
			end
			bVGUI.CreateTooltip(tt)
		end
	else
		self.DmgTooltip = nil
		bVGUI.DestroyTooltip()
	end
end

local stripes = Material("gmodadminsuite/stripes4.png")
function PANEL:Paint(w,h)
	if (self.RowIndex ~= nil and self.RowIndex % 2 ~= 0) then
		surface.SetDrawColor(255,255,255,75)
	else
		surface.SetDrawColor(255,255,255,200)
	end
	surface.SetMaterial(stripes)
	surface.DrawTexturedRect(0,0,w,h)

	surface.SetDrawColor(198,19,19)
	surface.DrawRect(48 + 10 + 10, h - 10 - 48 - 14, self.vgui_InstigatorWidth, 48)

	surface.SetDrawColor(19,198,19)
	surface.DrawRect(w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10 - self.vgui_VictimWidth, h - 10 - 48 - 14, self.vgui_VictimWidth, 48)

	surface.SetDrawColor(32,32,173)
	surface.DrawRect(48 + 10 + 10 + self.vgui_InstigatorWidth, h - 10 - 48 - 14, self.vgui_OtherWidth, 48)

	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial(bVGUI.MATERIAL_GRADIENT)
	surface.DrawTexturedRect(10 + 48 + 10,h - 10 - 48 - 14,w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10 - 48 - 10 - 10,48)

	if (self.vgui_InstigatorWidth >= 50) then
		draw.SimpleText(math.Round(self.vgui_InstigatorFrac * 100) .. "%", "gas_logging_damagelog_pct", 10 + 48 + 10 + (self.vgui_InstigatorWidth / 2), h - 10 - (48 / 2) - 14, bVGUI.COLOR_WHITE,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	if (self.vgui_VictimWidth >= 50) then
		draw.SimpleText(math.Round(self.vgui_VictimFrac * 100) .. "%", "gas_logging_damagelog_pct", w - 6 - 10 - self.FlagContainer:GetWide() - 10 - 48 - 10 - (self.vgui_VictimWidth / 2), h - 10 - (48 / 2) - 14, bVGUI.COLOR_WHITE,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	if (self.vgui_OtherWidth >= 50) then
		draw.SimpleText(math.Round(self.vgui_OtherFrac * 100) .. "%", "gas_logging_damagelog_pct", 10 + 48 + 10 + self.vgui_InstigatorWidth + (self.vgui_OtherWidth / 2), h - 10 - (48 / 2) - 14, bVGUI.COLOR_WHITE,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

derma.DefineControl("GAS.Logging.DamageLog", nil, PANEL, "bVGUI.BlankPanel")