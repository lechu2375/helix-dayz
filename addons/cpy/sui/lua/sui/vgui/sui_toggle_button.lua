local Lerp = Lerp
local FrameTime = FrameTime

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name
local TDLib = sui.TDLib

local Panel = {}

sui.scaling_functions(Panel)

function Panel:Init()
	self:ScaleInit()

	local rounded_box = {}
	local switch_circle = {}
	function self:Paint(w, h)
		local is_checked = self:GetChecked()

		local _h = SUI.Scale(14)
		TDLib.RoundedBox(rounded_box, _h, 0, h / 2 - _h / 2, w, _h, is_checked and SUI.GetColor("toggle_button_active") or SUI.GetColor("toggle_button"))

		local size = h - 2
		do
			local pos = is_checked and (w - (size / 2)) or (h / 2 - 1)
			if self.pos then
				self.pos = Lerp(FrameTime() * 12, self.pos, pos)
			else
				self.pos = pos
			end
		end

		TDLib.DrawCircle(switch_circle, self.pos, h / 2, size / 2, is_checked and SUI.GetColor("toggle_button_switch_active") or SUI.GetColor("toggle_button_switch"))
	end

	self:SetSize(34, 20)
end

sui.register("ToggleButton", Panel, "DCheckBox")