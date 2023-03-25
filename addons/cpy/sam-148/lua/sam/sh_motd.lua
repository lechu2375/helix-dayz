if SAM_LOADED then return end

local sam = sam
local config = sam.config
local command = sam.command

if CLIENT then
	config.add_menu_setting("MOTD URL (Leave empty for no MOTD)", function()
		local entry = vgui.Create("SAM.TextEntry")
		entry:SetPlaceholder("")
		entry:SetNoBar(true)
		entry:SetConfig("MOTDURL", "")

		return entry
	end)
end

local motd
local load_motd = function()
	local url = config.get("MOTDURL", "")
	if url == "" then
		command.remove_command("motd")
		hook.Remove("HUDPaint", "SAM.OpenMOTD")
		return
	end

	if IsValid(motd) then
		motd:Remove()
	end

	command.set_category("Menus")

	command.new("motd")
		:Help("Open MOTD menu")
		:OnExecute(function(ply)
			sam.netstream.Start(ply, "OpenMOTD")
		end)
	:End()

	if CLIENT then
		function sam.menu.open_motd()
			if IsValid(motd) then
				motd:Remove()
			end

			motd = vgui.Create("SAM.Frame")
			motd:Dock(FILL)
			motd:DockMargin(40, 40, 40, 40)
			motd:MakePopup()

			function motd.close.DoClick()
				motd:Remove()
			end

			local html = motd:Add("DHTML")
			html:Dock(FILL)
			html:OpenURL(url)
		end

		sam.netstream.Hook("OpenMOTD", function()
			sam.menu.open_motd()
		end)

		hook.Add("HUDPaint", "SAM.OpenMOTD", function()
			sam.menu.open_motd()
			hook.Remove("HUDPaint", "SAM.OpenMOTD")
		end)
	end
end
config.hook({"MOTDURL"}, load_motd)