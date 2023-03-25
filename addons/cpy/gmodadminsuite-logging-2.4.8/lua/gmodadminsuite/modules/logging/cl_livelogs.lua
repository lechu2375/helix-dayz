local function L(phrase, discriminator)
	return GAS:Phrase(phrase, "logging", discriminator)
end

if (IsValid(GAS_Logging_LiveLogs)) then
	GAS_Logging_LiveLogs:Remove()
end

surface.CreateFont("gas_logging_livelogs", {
	font = "Rubik",
	size = 14
})

GAS.Logging.LiveLogs_DefaultConfig = {width = 500, rows = 15, color = true, x = 10, y = 10, padding = 5, show_logs_for = 8, enabled = false, bgcolor = Color(0,0,0,225), print_to_console = true}
GAS.Logging.LiveLogs_Config = GAS:GetLocalConfig("logging_livelogs", GAS.Logging.LiveLogs_DefaultConfig)

function GAS.Logging:OpenLiveLogs()
	if (IsValid(GAS_Logging_LiveLogs)) then
		GAS_Logging_LiveLogs:Remove()
	end

	GAS:netStart("logging:LiveLogs")
		net.WriteBool(true)
	net.SendToServer()

	GAS_Logging_LiveLogs = vgui.Create("DPanel")
	GAS_Logging_LiveLogs:SetSize(GAS.Logging.LiveLogs_Config.width, ScrH())
	GAS_Logging_LiveLogs:AlignLeft(GAS.Logging.LiveLogs_Config.x)
	GAS_Logging_LiveLogs:AlignTop(GAS.Logging.LiveLogs_Config.y)
	GAS_Logging_LiveLogs:DockPadding(GAS.Logging.LiveLogs_Config.padding, GAS.Logging.LiveLogs_Config.padding, GAS.Logging.LiveLogs_Config.padding, GAS.Logging.LiveLogs_Config.padding)
	GAS_Logging_LiveLogs.Logs = {}

	function GAS_Logging_LiveLogs:AddLog(logtbl)
		local max_width = self:GetWide() - (GAS.Logging.LiveLogs_Config.padding * 2)
		
		local markupObj = markup.Parse("<font=gas_logging_livelogs>" .. GAS.Logging:FormatMarkupLog(logtbl, GAS.Logging.LiveLogs_Config.color) .. "</font>", max_width)

		local created_livelog = table.insert(GAS_Logging_LiveLogs.Logs, markupObj)
		GAS_Logging_LiveLogs.Logs[created_livelog].CreatedAt = CurTime()

		local MsgC_Args = {}
		for i, blk in ipairs(markupObj.blocks) do
			table.insert(MsgC_Args, Color(blk.colour.r, blk.colour.g, blk.colour.b, blk.colour.a))
			table.insert(MsgC_Args, blk.text)
		end
		table.insert(MsgC_Args, "\n")
		MsgC(unpack(MsgC_Args))
	end

	function GAS_Logging_LiveLogs:Antispam()
		local max_width = self:GetWide() - (GAS.Logging.LiveLogs_Config.padding * 2)
		GAS_Logging_LiveLogs.Logs[table.insert(GAS_Logging_LiveLogs.Logs, markup.Parse("<font=gas_logging_livelogs>" .. GAS:EscapeMarkup(L"live_log_antispam") .. "</font>", max_width))].CreatedAt = CurTime()
	end

	local markup_h = 0
	local y_align = GAS.Logging.LiveLogs_Config.padding
	function GAS_Logging_LiveLogs:Paint(w,h)
		if (not GAS) then return end
		if (not GAS.Logging) then return end
		if (not GAS_Logging_LiveLogs) then return end
		if (not GAS_Logging_LiveLogs.Logs) then return end
		local logs_len = #GAS_Logging_LiveLogs.Logs
		if (logs_len > 0) then
			if (GAS.Logging.LiveLogs_Config.bgcolor.a > 0) then
				surface.SetDrawColor(GAS.Logging.LiveLogs_Config.bgcolor)
				surface.DrawRect(0,0,w,y_align - 2 + GAS.Logging.LiveLogs_Config.padding)
			end
			markup_h = 0
			y_align = GAS.Logging.LiveLogs_Config.padding
			for i=logs_len, 1, -1 do
				local v = GAS_Logging_LiveLogs.Logs[i]
				if (v.CreatedAt < CurTime() - GAS.Logging.LiveLogs_Config.show_logs_for or (logs_len > GAS.Logging.LiveLogs_Config.rows and logs_len - (i - 1) > GAS.Logging.LiveLogs_Config.rows)) then
					if (not v.LerpAlpha) then
						v.LerpAlpha = 255
						v.LerpStarted = CurTime()
					end
					v.LerpAlpha = Lerp(math.TimeFraction(v.LerpStarted, v.LerpStarted + 5, CurTime()), v.LerpAlpha, 0)
				end
				if (v.LerpAlpha and math.floor(v.LerpAlpha) == 0) then
					table.remove(GAS_Logging_LiveLogs.Logs, i)
				else
					v:Draw(GAS.Logging.LiveLogs_Config.padding,y_align,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,v.LerpAlpha or 255)
					markup_h = markup_h + v:GetHeight()
					y_align = y_align + v:GetHeight() + 2
				end
			end
		end
	end
end

GAS:netReceive("logging:LiveLog", function(len)
	local data = GAS:DeserializeTable(util.Decompress(net.ReadData(len)))
	if (not GAS.Logging.Config) then return end
	if (IsValid(GAS_Logging_LiveLogs)) then
		GAS_Logging_LiveLogs:AddLog(data)
	else
		GAS:netStart("logging:LiveLogs")
			net.WriteBool(false)
		net.SendToServer()
	end
end)

GAS:netReceive("logging:LiveLogAntispam", function()
	if (IsValid(GAS_Logging_LiveLogs)) then
		GAS_Logging_LiveLogs:Antispam()
	end
end)

if (GAS.Logging.LiveLogs_Config.enabled == true) then
	GAS:InitPostEntity(function()
		timer.Simple(10, function()
			GAS.Logging:OpenLiveLogs()
		end)
	end)
end