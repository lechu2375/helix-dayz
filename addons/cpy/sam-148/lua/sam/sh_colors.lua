if SAM_LOADED then return end

local colors = {
	Red   = Color(244, 67, 54),
	Blue  = Color(13, 130, 223),
	Green = Color(0, 230, 64),
	White = Color(236, 240, 241),
	Black = Color(10, 10, 10)
}

function sam.get_color(name)
	return colors[name]
end

function sam.add_color(name, color)
	if isstring(name) and IsColor(color) then
		colors[name] = color
	end
end