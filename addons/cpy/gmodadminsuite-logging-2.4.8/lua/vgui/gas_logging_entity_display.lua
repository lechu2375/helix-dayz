GAS_Logging_EntityDisplay_Networking = {}
GAS_Logging_EntityDisplay_Cache = {}

if (IsValid(GAS_Logging_EntityDisplay)) then
	GAS_Logging_EntityDisplay:Close()
end

local PANEL = {}

function PANEL:InfoInit()
	self.Shruggie = vgui.Create("DLabel", self)
	self.Shruggie:SetText("¯\\_(ツ)_/¯")
	self.Shruggie:SetFont("DermaLarge")
	self.Shruggie:SetTextColor(bVGUI.COLOR_WHITE)
	self.Shruggie:SizeToContents()
	self.Shruggie:SetVisible(false)

	self.LoadingPanel = vgui.Create("bVGUI.LoadingPanel", self)
	self.LoadingPanel:Dock(FILL)
	self.LoadingPanel:SetLoading(true)

	self.ModelPanel = vgui.Create("DModelPanel", self.LoadingPanel)
	self.ModelPanel:Dock(FILL)

	self.InfoContainer = vgui.Create("bVGUI.BlankPanel", self)

	self.LabelContainer = vgui.Create("bVGUI.BlankPanel", self.InfoContainer)
	self.LabelContainer:Dock(FILL)

	self.SpawnCategory = vgui.Create("DLabel", self.LabelContainer)
	self.SpawnCategory:Dock(BOTTOM)
	self.SpawnCategory:SetContentAlignment(3)
	self.SpawnCategory:SetTextColor(Color(160,160,160))
	self.SpawnCategory:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.SpawnCategory:SetText("")
	self.SpawnCategory:SetVisible(false)

	self.PrintName = vgui.Create("DLabel", self.LabelContainer)
	self.PrintName:SetText("")
	self.PrintName:SetTextColor(bVGUI.COLOR_WHITE)
	self.PrintName:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.PrintName:Dock(FILL)
	self.PrintName:SetContentAlignment(3)

	self.SpawnIcon = vgui.Create("DImage", self.InfoContainer)
	self.SpawnIcon:Dock(LEFT)
	self.SpawnIcon:DockMargin(0,0,10,0)
	self.SpawnIcon:SetSize(64,64)
	self.SpawnIcon:SetVisible(false)

	self.OldPerformLayout = self.PerformLayout
	function self:PerformLayout(w,h)
		self:OldPerformLayout(w,h)

		self.InfoContainer:SetSize(w - 20, 64)
		self.InfoContainer:AlignBottom(10)
		self.InfoContainer:AlignLeft(10)

		self.Shruggie:Center()
	end
end

function PANEL:FixCamera(scale)
	if (IsValid(self.ModelPanel.Entity)) then
		local PrevMins, PrevMaxs = self.ModelPanel.Entity:GetRenderBounds()
		self.ModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(scale or 0.75, scale or 0.75,scale or 0.75))
		self.ModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
	end
end

function PANEL:SetWeapon(weapon_class)
	self:SetTitle(weapon_class)

	local weapon_tbl = weapons.Get(weapon_class)
	if (weapon_tbl ~= nil and weapon_tbl.WorldModel ~= nil) then
		self.ModelPanel:SetModel(weapon_tbl.WorldModel)
		self:SetVisible(true)
		if (weapon_tbl.PrintName ~= nil and type(weapon_tbl.PrintName) == "string") then
			self.PrintName:SetText(weapon_tbl.PrintName)
		end
		if (weapon_tbl.Category ~= nil and type(weapon_tbl.Category)) then
			self.SpawnCategory:SetText(weapon_tbl.Category)
			self.SpawnCategory:SetVisible(true)
		end
	elseif (file.Exists("scripts/" .. weapon_class .. ".txt", "GAME")) then
		local weapon_script = file.Read("scripts/" .. weapon_class .. ".txt", "GAME")
		if (weapon_script) then
			local world_model = weapon_script:match('"playermodel"%s*"(.-)"')
			if (world_model ~= nil) then
				self.ModelPanel:SetModel(world_model)
				self:SetVisible(true)
			end
		end
		local weapon_info = list.Get("Weapon")[weapon_class]
		if (weapon_info) then
			if (weapon_info.PrintName ~= nil and type(weapon_info.PrintName) == "string") then
				self.PrintName:SetText(weapon_info.PrintName)
				self.PrintName:SizeToContents()
			end
			if (weapon_info.Category ~= nil and type(weapon_info.Category)) then
				self.SpawnCategory:SetText(weapon_info.Category)
				self.SpawnCategory:SetVisible(true)
			end
		end
	end

	if (file.Exists("materials/entities/" .. weapon_class .. ".png", "GAME")) then
		self.SpawnIcon:SetImage("entities/" .. weapon_class .. ".png")
		self.SpawnIcon:SetVisible(true)
	end

	self:FixCamera()
	self.LoadingPanel:SetLoading(false)
end

function PANEL:SetProp(model)
	self.ModelPanel:SetModel(model)
	self:SetTitle(model)
	self:SetVisible(true)

	self:FixCamera()
	self.LoadingPanel:SetLoading(false)
end

function PANEL:SetAmmo(ammo_type)
	local spawnmenu_item = list.Get("SpawnableEntities")[ammo_type]
	if (spawnmenu_item ~= nil and spawnmenu_item.PrintName ~= nil and type(spawnmenu_item) == "string") then
		self.PrintName:SetText(spawnmenu_item.PrintName)
	end
	if (file.Exists("materials/entities/" .. ammo_type .. ".png", "GAME")) then
		self.SpawnIcon:SetImage("entities/" .. ammo_type .. ".png")
		self.SpawnIcon:SetVisible(true)
	end

	self:SetVisible(true)

	if (GAS_Logging_EntityDisplay_Cache[ammo_type]) then
		self.ModelPanel:SetModel(GAS_Logging_EntityDisplay_Cache[ammo_type])
		self:SetVisible(true)
		self:FixCamera()
		self.LoadingPanel:SetLoading(false)
	else
		local net_msg_fire = GAS_Logging_EntityDisplay_Networking[ammo_type] == nil
		GAS_Logging_EntityDisplay_Networking[ammo_type] = GAS_Logging_EntityDisplay_Networking[ammo_type] or {}
		GAS_Logging_EntityDisplay_Networking[ammo_type][self] = true
		if (net_msg_fire) then
			GAS:netStart("logging:EntityDisplay:AmmoModel")
				net.WriteString(ammo_type)
			net.SendToServer()
		end
	end
end

function PANEL:SetVehicle(vehicle_class, mdl_str)
	self:SetTitle(vehicle_class)

	if (mdl_str ~= nil and not IsUselessModel(mdl_str)) then
		self.ModelPanel:SetModel(mdl_str)
		self:SetVisible(true)
		self:FixCamera()
		self.LoadingPanel:SetLoading(false)

		for _,spawnmenu_item in pairs(list.Get("Vehicles")) do
			if (spawnmenu_item.Class == vehicle_class and spawnmenu_item.Model == mdl_str) then
				if (spawnmenu_item.Name ~= nil and type(spawnmenu_item.Name) == "string") then
					self.PrintName:SetText(spawnmenu_item.Name)
					if (file.Exists("materials/entities/" .. spawnmenu_item.Name .. ".png", "GAME")) then
						self.SpawnIcon:SetImage("entities/" .. spawnmenu_item.Name .. ".png")
						self.SpawnIcon:SetVisible(true)
					end
				end
				return
			end
		end
		for _,spawnmenu_item in pairs(list.Get("Vehicles")) do
			if (spawnmenu_item.Model == mdl_str) then
				if (spawnmenu_item.Name ~= nil and type(spawnmenu_item.Name) == "string") then
					self.PrintName:SetText(spawnmenu_item.Name)
					if (file.Exists("materials/entities/" .. spawnmenu_item.Name .. ".png", "GAME")) then
						self.SpawnIcon:SetImage("entities/" .. spawnmenu_item.Name .. ".png")
						self.SpawnIcon:SetVisible(true)
					end
				end
				break
			end
		end
	else
		for _,spawnmenu_item in pairs(list.Get("Vehicles")) do
			if (spawnmenu_item.Class ~= vehicle_class) then continue end
			if (spawnmenu_item.Name ~= nil and type(spawnmenu_item.Name) == "string") then
				self.PrintName:SetText(spawnmenu_item.Name)
				if (file.Exists("materials/entities/" .. spawnmenu_item.Name .. ".png", "GAME")) then
					self.SpawnIcon:SetImage("entities/" .. spawnmenu_item.Name .. ".png")
					self.SpawnIcon:SetVisible(true)
				end
			end
			if (mdl_str == nil or IsUselessModel(mdl_str)) then
				if (spawnmenu_item.Model ~= nil and type(spawnmenu_item.Model) == "string") then
					self.ModelPanel:SetModel(spawnmenu_item.Model)
					self:SetVisible(true)
					self:FixCamera()
					self.LoadingPanel:SetLoading(false)
				end
			end
			break
		end
	end
end

function PANEL:SetEntity(class_name, mdl_str)
	if (class_name == "worldspawn") then return end

	self:SetTitle(class_name)

	local sent_tbl = scripted_ents.Get(class_name)
	if (sent_tbl ~= nil and sent_tbl.PrintName ~= nil and type(sent_tbl.PrintName) == "string") then
		self.PrintName:SetText(sent_tbl.PrintName)
	else
		local spawnmenu_item = list.Get("SpawnableEntities")[class_name]
		if (spawnmenu_item ~= nil and spawnmenu_item.PrintName ~= nil and type(spawnmenu_item.PrintName) == "string") then
			self.PrintName:SetText(spawnmenu_item.PrintName)
		end
	end
	if (file.Exists("materials/entities/" .. class_name .. ".png", "GAME")) then
		self.SpawnIcon:SetImage("entities/" .. class_name .. ".png")
		self.SpawnIcon:SetVisible(true)
	end

	if (mdl_str ~= nil and type(mdl_str) == "string") then
		if (not IsUselessModel(mdl_str)) then
			self.ModelPanel:SetModel(mdl_str)
			self:SetVisible(true)
			self:FixCamera()
			self.LoadingPanel:SetLoading(false)
		end
	elseif (GAS_Logging_EntityDisplay_Cache[class_name]) then
		self.ModelPanel:SetModel(GAS_Logging_EntityDisplay_Cache[class_name])
		self:SetVisible(true)
		self:FixCamera()
		self.LoadingPanel:SetLoading(false)
	else
		local found = false
		for _,ent in ipairs(ents.GetAll()) do
			if (not ent:IsWorld() and ent:GetClass() == class_name) then
				GAS_Logging_EntityDisplay_Cache[class_name] = ent:GetModel()
				self.ModelPanel:SetModel(ent:GetModel())
				self:SetVisible(true)
				self:FixCamera()
				self.LoadingPanel:SetLoading(false)
				found = true
				break
			end
		end
		if (not found) then
			local predefined_model = sent_tbl.model or sent_tbl.Model or sent_tbl.WorldModel
			if (predefined_model ~= nil and not IsUselessModel(predefined_model)) then
				GAS_Logging_EntityDisplay_Cache[class_name] = predefined_model
				self.ModelPanel:SetModel(predefined_model)
				self:SetVisible(true)
				self:FixCamera()
				self.LoadingPanel:SetLoading(false)
				return
			elseif (sent_tbl.Initialize ~= nil and type(sent_tbl.Initialize) == "function") then
				local debug_info = debug.getinfo(sent_tbl.Initialize)
				if (debug_info ~= nil and debug_info.short_src ~= nil) then
					local code
					if (file.Exists(debug_info.short_src, "LUA")) then
						code = file.Read(debug_info.short_src, "LUA")
					elseif (file.Exists(debug_info.short_src, "GAME")) then
						code = file.Read(debug_info.short_src, "GAME")
					end
					if (code ~= nil) then
						local mdl_str = code:match('function ENT:Initialize%(.-%)\n.-self:SetModel%("(.-)"%)[%s%S]-end')
						if (mdl_str ~= nil) then
							if (not IsUselessModel(mdl_str)) then
								GAS_Logging_EntityDisplay_Cache[class_name] = mdl_str
								self.ModelPanel:SetModel(mdl_str)
								self:SetVisible(true)
								self:FixCamera()
								self.LoadingPanel:SetLoading(false)
								return
							end
						end
						local relative_path = string.GetPathFromFilename(debug_info.short_src)
						for file_name in code:gmatch('include%("(.-%.lua)"%)') do
							local relative_file = relative_path .. file_name
							local code
							if (file.Exists(relative_file, "LUA")) then
								code = file.Read(relative_file, "LUA")
							elseif (file.Exists(relative_file, "GAME")) then
								code = file.Read(relative_file, "GAME")
							end
							if (code ~= nil) then
								for mdl_str in code:gmatch('self:SetModel%("(.-)"%)') do
									if (not IsUselessModel(mdl_str)) then
										GAS_Logging_EntityDisplay_Cache[class_name] = mdl_str
										self.ModelPanel:SetModel(mdl_str)
										self:SetVisible(true)
										self:FixCamera()
										self.LoadingPanel:SetLoading(false)
										return
									end
								end
								local mdl_str = code:match('"([^\n]-%.mdl)"')
								if (mdl_str ~= nil and not IsUselessModel(mdl_str)) then
									GAS_Logging_EntityDisplay_Cache[class_name] = mdl_str
									self.ModelPanel:SetModel(mdl_str)
									self:SetVisible(true)
									self:FixCamera()
									self.LoadingPanel:SetLoading(false)
									return
								end
							end
						end
					end
				end
			end

			self:SetVisible(true)
			local net_msg_fire = GAS_Logging_EntityDisplay_Networking[class_name] == nil
			GAS_Logging_EntityDisplay_Networking[class_name] = GAS_Logging_EntityDisplay_Networking[class_name] or {}
			GAS_Logging_EntityDisplay_Networking[class_name][self] = true
			if (net_msg_fire) then
				GAS:netStart("logging:EntityDisplay:SENTModel")
					net.WriteString(class_name)
				net.SendToServer()
			end
		end
	end
end

function PANEL:Init()
	self:InfoInit()
end

local DFRAME_PANEL = table.Copy(PANEL)

function PANEL:SetTitle() end

function DFRAME_PANEL:Init()
	self:SetDrawOnTop(true)

	self:ShowFullscreenButton(false)
	self:ShowPinButton(false)
	self:ShowCloseButton(false)

	self:SetVisible(false)

	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self:SetSize(250,250)

	self:SetTitle("Entity")

	self:InfoInit()
end

function DFRAME_PANEL:Think()
	if (not system.HasFocus() or not IsValid(self.Creator) or vgui.GetHoveredPanel() ~= self.Creator) then
		self:Close()
		return
	end
	local x,y = gui.MousePos()
	self:SetPos(x + 20, y + 20)
end

function DFRAME_PANEL:SetCreator(creator_pnl)
	self.Creator = creator_pnl
end

function GAS_Logging_DisplayEntity(setup_func, creator, on_hover)
	if (not IsValid(creator)) then return end

	local function display()
		if (IsValid(GAS_Logging_EntityDisplay)) then
			GAS_Logging_EntityDisplay:Close()
		end

		GAS_Logging_EntityDisplay = vgui.Create("GAS.Logging.EntityDisplay")
		GAS_Logging_EntityDisplay:SetCreator(creator)
		setup_func(GAS_Logging_EntityDisplay)

		return GAS_Logging_EntityDisplay
	end

	if (on_hover == true) then
		creator.GAS_Logging_DisplayEntity_OnCursorEntered = creator.GAS_Logging_DisplayEntity_OnCursorEntered or creator.OnCursorEntered
		creator.GAS_Logging_DisplayEntity_OnCursorExited  = creator.GAS_Logging_DisplayEntity_OnCursorExited or creator.OnCursorExited
		function creator:OnCursorEntered(...)
			if (self.GAS_Logging_DisplayEntity_OnCursorEntered) then
				self:GAS_Logging_DisplayEntity_OnCursorEntered(...)
			end

			self.GAS_Logging_EntityDisplay = display()
		end
		function creator:OnCursorExited(...)
			if (self.GAS_Logging_DisplayEntity_OnCursorExited) then
				self:GAS_Logging_DisplayEntity_OnCursorExited(...)
			end

			if (IsValid(self.GAS_Logging_EntityDisplay)) then
				self.GAS_Logging_EntityDisplay:Close()
			end
		end
	else
		return display()
	end
end

GAS:netReceive("logging:EntityDisplay:SENTModel", function()
	local class_name = net.ReadString()
	local success = net.ReadBool()
	if (success) then
		local model = net.ReadString()
		if (GAS_Logging_EntityDisplay_Networking[class_name] ~= nil) then
			for pnl in pairs(GAS_Logging_EntityDisplay_Networking[class_name]) do
				if (not IsValid(pnl)) then continue end
				GAS_Logging_EntityDisplay_Cache[class_name] = model
				pnl.LoadingPanel:SetLoading(false)
				pnl.ModelPanel:SetModel(model)
				pnl:FixCamera()
			end
			GAS_Logging_EntityDisplay_Networking[class_name] = nil
		end
	else
		GAS:PlaySound("error")
		if (GAS_Logging_EntityDisplay_Networking[class_name] ~= nil) then
			for pnl in pairs(GAS_Logging_EntityDisplay_Networking[class_name]) do
				if (not IsValid(pnl)) then continue end
				pnl.LoadingPanel:SetLoading(false)
				pnl.Shruggie:SetVisible(true)
			end
			GAS_Logging_EntityDisplay_Networking[class_name] = nil
		end
	end
end)

derma.DefineControl("GAS.Logging.EntityDisplay", nil, DFRAME_PANEL, "bVGUI.Frame")
derma.DefineControl("GAS.Logging.Entity", nil, PANEL, "bVGUI.BlankPanel")