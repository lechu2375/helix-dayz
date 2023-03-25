local domain = CreateConVar("xeon_dev", 0, bit.bor(FCVAR_REPLICATED, FCVAR_UNREGISTERED, FCVAR_UNLOGGED, FCVAR_DONTRECORD), nil, 0, 1):GetInt() == 1 and "http://gmod.sneed" or "https://xeon.network"

local XEON_AUTH
net.Receive("XEON.Auth", function(len)
	if net.ReadBool() then
		if IsValid(XEON_AUTH) then
			XEON_AUTH:Linked()
		end
		return
	end

	net.Start("XEON.Auth")
	net.SendToServer()

	if IsValid(XEON_AUTH) then return end

	XEON_AUTH = vgui.Create("DFrame")
	XEON_AUTH:SetSize(ScrW() * .8, ScrH() * .8)
	XEON_AUTH:SetTitle("XEON DRM by Billy - Server Linking")
	XEON_AUTH:Center()
	XEON_AUTH:MakePopup()
	XEON_AUTH:SetRenderInScreenshots(false)

	local html = vgui.Create("DHTML", XEON_AUTH)
	html:Dock(FILL)
	html:OpenURL(domain .. "/link/" .. (LocalPlayer():IsSuperAdmin() and "1" or "0"))
	html:AddFunction("XEON", "Auth", function(token_bytes)
		local token_bytes = string.Explode(", ", token_bytes:sub(2, -2), false)
		local token = {}
		for i = 1, 32 do
			token[i] = string.char(token_bytes[i])
		end
		token = table.concat(token)

		net.Start("XEON.Auth")
			net.WriteData(token, 32)
		net.SendToServer()
	end)
	html:AddFunction("XEON", "ReloadMap", function()
		net.Start("XEON.ReloadMap")
		net.SendToServer()

		if IsValid(XEON_AUTH) then
			XEON_AUTH:Close()
			XEON_AUTH = nil
		end
	end)
	local RunJS = html.RunJavascript
	function XEON_AUTH:Linked()
		RunJS(html, "LINKED()")
	end
	html.QueueJavascript = nil
	html.RunJavascript = nil
end)

local function openErrors(errors)
	if IsValid(XEON_ERRORS) then
		XEON_ERRORS:Update(errors)
		return
	end

	XEON_ERRORS = vgui.Create("DFrame")
	XEON_ERRORS:SetSize(ScrW() * .8, ScrH() * .8)
	XEON_ERRORS:SetTitle("XEON DRM by Billy - Error!")
	XEON_ERRORS:Center()
	XEON_ERRORS:MakePopup()

	local html = vgui.Create("DHTML", XEON_ERRORS)
	html:Dock(FILL)
	html:OpenURL(domain .. "/errors")
	html:AddFunction("XEON", "ScriptSupport", function()
		gui.OpenURL("https://support.billy.enterprises")
	end)

	function XEON_ERRORS:Update(errors)
		print("XEON Errors: " .. #errors)
		PrintTable(errors)

		html:QueueJavascript("ShowNetworkedErrors(" .. util.TableToJSON(errors) .. ")")
	end
	function html:OnDocumentReady()
		XEON_ERRORS:Update(errors)
		self.OnDocumentReady = nil
	end
	XEON_ERRORS:Update(errors)

	sound.PlayURL("https://xeon.network/static/media/oof.mp3", "", function() end)
end

net.Receive("XEON.Error", function()
	local errors = {}
	for i = 1, net.ReadUInt(16) do
		errors[i] = net.ReadString()
	end
	openErrors(errors)
end)

hook.Add("InitPostEntity", "XEON.Error", function()
	timer.Simple(2, function()
		net.Start("XEON.Error")
		net.SendToServer()
	end)
end)