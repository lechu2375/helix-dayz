if SAM_LOADED then return end

local sam = sam
local config = sam.config

config.add_tab("Server", function(parent)
	local server_body = parent:Add("SAM.ScrollPanel")
	server_body:Dock(FILL)
	server_body:LineMargin(0, 6, 0, 0)

	local i = 0
	server_body:GetCanvas():On("OnChildAdded", function(s, child)
		i = i + 1
		child:SetZPos(i)
	end)

	for k, v in ipairs(sam.config.get_menu_settings()) do
		local panel = v.func(server_body)
		if ispanel(panel) then
			local setting = server_body:Add("SAM.LabelPanel")
			setting:DockMargin(8, 6, 8, 0)
			setting:SetLabel(v.title)
			setting:SetPanel(panel)
		end

		server_body:Line()
	end

	return server_body
end, function()
	return LocalPlayer():HasPermission("manage_config")
end, 1)