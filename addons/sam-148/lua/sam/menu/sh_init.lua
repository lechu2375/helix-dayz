if SAM_LOADED then return end

require("sui")

sam.command.new("menu")
	:Help("Open admin mod menu")
	:MenuHide()
	:DisableNotify()
	:OnExecute(function(ply)
		sam.netstream.Start(ply, "OpenMenu")
	end)
:End()

if CLIENT then
	sam.netstream.Hook("OpenMenu", function()
		sam.menu.open_menu()
	end)
end

if SERVER then
	for _, f in ipairs(file.Find("sam/menu/tabs/*.lua", "LUA")) do
		sam.load_file("sam/menu/tabs/" .. f)
	end
end