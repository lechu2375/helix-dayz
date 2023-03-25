local PANEL = {}

sui.scaling_functions(PANEL)

function PANEL:Init()
	self:ScaleInit()
end

sui.register("Panel", PANEL, "Panel")