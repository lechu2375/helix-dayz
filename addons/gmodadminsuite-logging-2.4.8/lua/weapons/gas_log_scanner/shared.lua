local function L(phrase, discriminator)
	return GAS:Phrase(phrase, "logging", discriminator)
end

local COLOR_RED = Color(255, 0, 0)
local SCANNER_HUD

SWEP.PrintName    = "bLogs Scanner"
SWEP.Category     = "GmodAdminSuite"
SWEP.Author       = "GmodAdminSuite"
SWEP.Purpose      = "This scanner allows you to view logs related to entities in the world"
SWEP.Instructions = "Look at an entity"
SWEP.Contact      = "www.gmodadminsuite.com"

SWEP.Slot           = 5
SWEP.SlotPos        = 2
SWEP.DrawAmmo       = false
SWEP.DrawCrosshair  = true
SWEP.Weight         = 5
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.ViewModel  = "models/weapons/v_emptool.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Spawnable  = true
SWEP.AdminOnly  = true

SWEP.ShowViewModel  = true
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.HolsterSound       = Sound("npc/turret_floor/retract.wav")
SWEP.DeploySound        = Sound("npc/turret_floor/deploy.wav")
SWEP.ErrorSound         = Sound("npc/roller/code2.wav")
SWEP.ViewLogsSound      = Sound("AlyxEMP.Discharge")
SWEP.ShowInterfaceSound = Sound("gmodadminsuite/btn_light.ogg")
SWEP.HideInterfaceSound = Sound("gmodadminsuite/btn_heavy.ogg")

SWEP.WElements = {
	["scanner"] = {
		type = "Model",
		model = "models/weapons/w_emptool.mdl",
		bone = "ValveBiped.Anim_Attachment_LH",
		rel = "",
		pos = Vector(0.518, -3.636, 6.752),
		angle = Angle(38.57, -180, 12.857),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

if (CLIENT) then
	function SWEP:Initialize()
		self:CreateModels(self.WElements)
	end
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim(ACT_VM_FIDGET)

	if (CLIENT) then
		if (IsValid(self.HUD) and self.HUD:IsVisible()) then
			self.LastInspectedEnt = self.HUD.InspectingEnt
			self.LastInspectedEntHUD = self.HUD

			self.HUD:ShowCloseButton(true)
			self.HUD:ShowFullscreenButton(true)
			self.HUD:ShowPinButton(true)
			self.HUD:MakePopup()

			GAS:PlaySound("popup")
			self.HUD = nil
			self:CreateInterface()

			local tr = self.Owner:GetEyeTrace()
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(8)
			effectdata:SetScale(1)
			effectdata:SetRadius(16)
			util.Effect("cball_bounce", effectdata)

			self:EmitSound(self.ViewLogsSound)
		else
			self:EmitSound(self.ErrorSound)
		end
	end

	return true
end

function SWEP:SecondaryAttack()
	return false
end

if (SERVER) then
	util.AddNetworkString("gmodadminsuite:gas_log_scanner:Init")
	function SWEP:Deploy()
		if (not IsFirstTimePredicted()) then return end
		self:SetHoldType("duel")
		self:EmitSound(self.DeploySound)
		self:SendWeaponAnim(ACT_VM_DRAW)
		
		GAS:netStart("gas_log_scanner:Init")
		net.Send(self.Owner)
	end
else
	function SWEP:NetworkedDeploy()
		hook.Add("PreDrawHalos", "gas_log_scanner:Halo", function()
			if (not IsValid(self)) then
				timer.Remove("gas_log_scanner:UncacheData")
				timer.Remove("gas_log_scanner:LoadLogs")
				hook.Remove("PreDrawHalos", "gas_log_scanner:Halo")
				if (IsValid(SCANNER_HUD)) then
					SCANNER_HUD:Close()
				end
			else
				self:DrawHalo()
			end
		end)
		self:CreateInterface()
	end
	net.Receive("gmodadminsuite:gas_log_scanner:Init", function()
		timer.Create("gas_log_scanner:Init", 0, 0, function()
			if (IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gas_log_scanner" and LocalPlayer():GetActiveWeapon().NetworkedDeploy ~= nil) then
				LocalPlayer():GetActiveWeapon():NetworkedDeploy()
				timer.Remove("gas_log_scanner:Init")
			end
		end)
	end)
end

function SWEP:Holster()
	if (not IsFirstTimePredicted()) then
		return
	end
	self:EmitSound(self.HolsterSound)
	if (CLIENT) then
		timer.Remove("gas_log_scanner:UncacheData")
		timer.Remove("gas_log_scanner:LoadLogs")
		hook.Remove("PreDrawHalos", "gas_log_scanner:Halo")
		if (IsValid(self.HUD)) then
			self.HUD:Close()
		end
	end
	return true
end

if (SERVER) then
	function SWEP:Think()
		if (not IsValid(self.Owner)) then return end
		local tr = self.Owner:GetEyeTrace()
		if (IsValid(tr.Entity) and not tr.Entity:IsWorld()) then
			self:SetHoldType("magic")
		else
			self:SetHoldType("duel")
		end
	end
end

if (CLIENT) then
	hook.Add("PlayerSwitchWeapon", "gas_log_scanner:RemoveMenuOnSwitch", function(ply, oldWeapon, newWeapon)
		if (ply ~= LocalPlayer()) then return end
		if (IsValid(oldWeapon) and oldWeapon:GetClass() == "gas_log_scanner") then
			if (IsValid(newWeapon) and newWeapon:GetClass() == "gas_log_scanner") then
				return
			else
				timer.Remove("gas_log_scanner:UncacheData")
				timer.Remove("gas_log_scanner:LoadLogs")
				hook.Remove("PreDrawHalos", "gas_log_scanner:Halo")
				if (IsValid(oldWeapon.HUD)) then
					oldWeapon.HUD:Close()
				end
			end
		end
	end)

	function SWEP:CreateInterface()
		timer.Remove("gas_log_scanner:LoadLogs")
		if (IsValid(self.HUD)) then
			self.HUD:Close()
		end
		if (IsValid(SCANNER_HUD)) then
			SCANNER_HUD:Close()
		end

		self.HUD = vgui.Create("bVGUI.Frame")
		local HUD = self.HUD
		SCANNER_HUD = HUD

		HUD.FirstLoad = true
		HUD:SetTitle("bLogs Scanner")
		HUD:SetSize(425,400)
		HUD:SetPos(1050,300)
		HUD:ShowCloseButton(false)
		HUD:ShowFullscreenButton(false)
		HUD:ShowPinButton(false)
		HUD:SetVisible(false)

		HUD.Pagination = vgui.Create("bVGUI.Pagination", HUD)
		HUD.Pagination:SetTall(30)
		HUD.Pagination:Dock(TOP)
		HUD.Pagination:SetPages(1)
		function HUD.Pagination:OnPageSelected(page)
			HUD.Logs:Clear()
			HUD.Logs:SetLoading(true)
			local function LoadLogs()
				if (not IsValid(HUD) or not IsValid(self)) then return end
				HUD.FirstLoad = nil
				if (not IsValid(HUD.InspectingEnt)) then
					HUD.Logs:SetLoading(false)
				else
					local function LoadScannerLogs()
						GAS:StartNetworkTransaction("logging:LoadScannerLogs", function()
							net.WriteUInt(page, 16)
							net.WriteEntity(HUD.InspectingEnt)
						end, function(data_present, l)
							if (not IsValid(HUD)) then return end
							HUD.Logs:SetLoading(false)
							if (data_present) then
								local ent = net.ReadEntity()
								local pages = net.ReadUInt(16)
								local logs = GAS:DeserializeTable(util.Decompress(net.ReadData(l - 16 - 16)))

								HUD.Pagination:SetPages(pages)
								for _,log in ipairs(logs) do
									local module_data = GAS.Logging.IndexedModules[log[2]]
									local formatted_log = GAS.Logging:FormatMarkupLog(log, GAS.Logging.Config.ColoredLogs or true)
									local log_row = HUD.Logs:AddRow("<color=" .. GAS:Unvectorize(module_data.Colour or bVGUI.COLOR_WHITE) .. ">" .. GAS:EscapeMarkup(module_data.Name) .. "</color>", GAS:SimplifyTimestamp(log[3]), formatted_log)
									log_row.Data = log
									log_row.IsColored = GAS.Logging.Config.ColoredLogs or true
								end
							end
						end)
					end
					if (GAS.Logging.IndexedModules == nil) then
						GAS:StartNetworkTransaction("logging:GetModules", nil, function()
							net.ReadBool()
							local data_len = net.ReadUInt(16)

							GAS.Logging.Modules = {}
							GAS.Logging.IndexedModules = GAS:DeserializeTable(util.Decompress(net.ReadData(data_len)))
							for module_id, module_data in pairs(GAS.Logging.IndexedModules) do
								if (module_data.Offline) then continue end
								GAS.Logging.Modules[module_data.Category] = GAS.Logging.Modules[module_data.Category] or {}
								GAS.Logging.Modules[module_data.Category][module_data.Name] = module_data
							end

							LoadScannerLogs()
						end)
					else
						LoadScannerLogs()
					end
				end
			end
			if (HUD.FirstLoad) then
				timer.Create("gas_log_scanner:LoadLogs", .5, 1, LoadLogs)
			else
				LoadLogs()
			end
		end

		HUD.Logs = vgui.Create("bVGUI.Table", HUD)
		HUD.Logs:Dock(FILL)
		HUD.Logs:AddColumn(L"module", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
		HUD.Logs:AddColumn(L"when", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
		HUD.Logs:AddColumn(L"log", bVGUI.TABLE_COLUMN_GROW)
		HUD.Logs:SetRowCursor("hand")
		HUD.Logs:SetLoading(true)

		function HUD.Logs:OnRowRightClicked(row)
			self:OnRowClicked(row)
		end
		function HUD.Logs:OnRowClicked(row)
			GAS.Logging:OpenLogsContextMenu(row)
		end
	end

	SWEP.HaloTable = {}
	function SWEP:DrawHalo()
		if (not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self) then
			return hook.Remove("PreDrawHalos", "gas_log_scanner:Halo")
		end
		local tr = self.Owner:GetEyeTrace()
		if (IsValid(tr.Entity) and not tr.Entity:IsWorld()) then
			if (tr.Entity == self.LastInspectedEnt and IsValid(self.LastInspectedEntHUD)) then
				self.HaloTable[1] = nil
				return
			end
			if (self.HaloTable[1] == nil) then
				self:EmitSound(self.ShowInterfaceSound)
			end
			self.HaloTable[1] = tr.Entity

			halo.Add(self.HaloTable, COLOR_RED, 2, 2, 5, true, true)

			if (IsValid(self.HUD)) then
				self.HUD:SetVisible(true)
				self.HUD:SetTitle(tr.Entity:GetClass() .. " (" .. tr.Entity:EntIndex() .. ")")
				self.HUD.InspectingEnt = tr.Entity
				if (self.HUD.LastInspectedEnt ~= tr.Entity) then
					self.HUD.LastInspectedEnt = tr.Entity
					self.HUD.FirstLoad = true
					self.HUD.Pagination:SetPages(1)
					self.HUD.Pagination:SetPage(1)
					self.HUD.Pagination:OnPageSelected(1)
				end
				if (self.HUD.UncacheData) then
					self.HUD.UncacheData = nil
					self.HUD.Pagination:SetPage(1)
					self.HUD.Pagination:OnPageSelected(1)
				end
			end

			timer.Remove("gas_log_scanner:UncacheData")
		else
			self.LastInspectedEntHUD = nil
			self.LastInspectedEnt = nil

			if (self.HaloTable[1] ~= nil) then
				self:EmitSound(self.HideInterfaceSound)
			end
			self.HaloTable[1] = nil

			if (IsValid(self.HUD)) then
				self.HUD:SetVisible(false)
				self.HUD.InspectingEnt = nil
				if (not timer.Exists("gas_log_scanner:UncacheData") and not self.HUD.UncacheData) then
					timer.Create("gas_log_scanner:UncacheData", 3, 1, function()
						self.HUD.UncacheData = true
					end)
				end
			end
		end
	end

	-- Credit for this goes to the SWEP Construction Kit
	-- https://github.com/Clavus/SWEP_Construction_Kit

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		if (self.GetBoneOrientation == nil) then return end
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end

		if (not self.wRenderOrder) then
			self.wRenderOrder = {}
			for k, v in pairs(self.WElements) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]
			if (not v) then
				self.wRenderOrder = nil
				break
			end
			if (v.hide) then continue end

			local pos, ang

			if (v.bone) then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end

			if (not pos) then continue end

			local model = v.modelEnt

			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			model:SetAngles(ang)
			local matrix = Matrix()
			matrix:Scale(v.size)
			model:EnableMatrix("RenderMultiply", matrix)

			if (v.material == "") then
				model:SetMaterial("")
			elseif (model:GetMaterial() ~= v.material) then
				model:SetMaterial(v.material)
			end

			if (v.skin and v.skin ~= model:GetSkin()) then
				model:SetSkin(v.skin)
			end

			if (v.bodygroup) then
				for k, v in pairs(v.bodygroup) do
					if (model:GetBodygroup(k) ~= v) then
						model:SetBodygroup(k, v)
					end
				end
			end

			if (v.surpresslightning) then
				render.SuppressEngineLighting(true)
			end

			render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
			render.SetBlend(v.color.a / 255)
			model:DrawModel()
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)

			if (v.surpresslightning) then
				render.SuppressEngineLighting(false)
			end
		end
	end

	function SWEP:CreateModels(tab)
		for k, v in pairs(tab) do
			if
				(v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and
					string.find(v.model, ".mdl") and
					file.Exists(v.model, "GAME"))
			 then
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			elseif
				(v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and
					file.Exists("materials/" .. v.sprite .. ".vmt", "GAME"))
			 then
				local name = v.sprite .. "-"
				local params = {["$basetexture"] = v.sprite}
				local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}
				for i, j in pairs(tocheck) do
					if (v[j]) then
						params["$" .. j] = 1
						name = name .. "1"
					else
						name = name .. "0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
			end
		end
	end
end
