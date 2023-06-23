local hook = hook
local bit = bit
local math = math

local Color = Color
local ipairs = ipairs
local RealFrameTime = RealFrameTime

local color_white = color_white
local color_black = color_black

local sui = sui

local isfunction = sui.isfunction
local isstring = sui.isstring

local floor = math.floor

function sui.scale(v)
	return ScrH() * (v / 900)
end

function sui.hex_rgb(hex)
	hex = tonumber(hex:gsub("^([%w])([%w])([%w])$", "%1%1%2%2%3%3", 1), 16)

	return Color(
		bit.band(bit.rshift(hex, 16), 0xFF),
		bit.band(bit.rshift(hex, 8), 0xFF),
		bit.band(hex, 0xFF)
	)
end

function sui.rgb_hex(c)
	return bit.tohex((c.r * 0x10000) + (c.g * 0x100) + c.b, 6)
end
local rgb_hex = sui.rgb_hex

function sui.lerp_color(from, to)
	local frac = RealFrameTime() * 10
	from.r = Lerp(frac, from.r, to.r)
	from.g = Lerp(frac, from.g, to.g)
	from.b = Lerp(frac, from.b, to.b)
	from.a = Lerp(frac, from.a, to.a)
end

do
	local colors = {
		["41b9ff"] = Color(44, 62, 80),
		["00c853"] = Color(44, 62, 80),
		["181818"] = Color(242, 241, 239),
		["212121"] = Color(242, 241, 239),
	}

	function sui.contrast_color(color)
		local c = colors[rgb_hex(color)]
		if c then return c end

		local luminance = (0.299 * color.r + 0.587 * color.g + 0.114 * color.b) / 255
		return luminance > 0.5 and color_black or color_white
	end
end

do
	local SetDrawColor = surface.SetDrawColor
	local SetMaterial = surface.SetMaterial
	local DrawTexturedRectRotated = surface.DrawTexturedRectRotated
	function sui.draw_material(mat, x, y, size, col, rot)
		SetDrawColor(col)

		if x == -1 then
			x = size / 2
		end

		if y == -1 then
			y = size / 2
		end

		if mat then
			SetMaterial(mat)
		end

		DrawTexturedRectRotated(x, y, size, size, rot or 0)
	end
end

do
	local hsv_t = {
		[0] = function(v, p, q, t)
			return v, t, p
		end,
		[1] = function(v, p, q, t)
			return q, v, p
		end,
		[2] = function(v, p, q, t)
			return p, v, t
		end,
		[3] = function(v, p, q, t)
			return p, q, v
		end,
		[4] = function(v, p, q, t)
			return t, p, v
		end,
		[5] = function(v, p, q, t)
			return v, p, q
		end
	}

	function sui.hsv_to_rgb(h, s, v)
		local i = floor(h * 6)
		local f = h * 6 - i

		return hsv_t[i % 6](
			v * 255, -- v
			(v * (1 - s)) * 255, -- p
			(v * (1 - f * s)) * 255, -- q
			(v * (1 - (1 - f) * s)) * 255 -- t
		)
	end
end

local Panel = FindMetaTable("Panel")
local SetSize = Panel.SetSize
local GetWide = Panel.GetWide
local GetTall = Panel.GetTall
function sui.scaling_functions(panel)
	local scale_changed
	local SUI = CURRENT_SUI

	local dock_top = function(s, h)
		if not h then return end

		if not scale_changed then
			s.real_h = h
		end

		if not s.no_scale then
			h = SUI.Scale(h)
		end

		if GetTall(s) == h then return end

		SetSize(s, GetWide(s), h)
	end

	local dock_right = function(s, w)
		if not w then return end

		if not scale_changed then
			s.real_w = w
		end

		if not s.no_scale then
			w = SUI.Scale(w)
		end

		if GetWide(s) == w then return end

		SetSize(s, w, GetTall(s))
	end

	local size_changed = function(s, w, h)
		if s.using_scale then return end

		s.using_scale = true

		local dock = s:GetDock()

		if dock ~= FILL then
			if dock == NODOCK then
				dock_top(s, h)
				dock_right(s, w)
			elseif dock == TOP or dock == BOTTOM then
				dock_top(s, h)
			else
				dock_right(s, w)
			end
		end

		s.using_scale = nil
	end

	local wide_changed = function(s, w)
		size_changed(s, w)
	end

	local tall_changed = function(s, h)
		size_changed(s, nil, h)
	end

	function panel:ScaleChanged()
		scale_changed = true
		size_changed(self, self.real_w, self.real_h)
		scale_changed = nil
		if self.OnScaleChange then
			self:OnScaleChange()
		end
	end

	local on_remove = function(s)
		SUI.RemoveScaleHook(s)
	end

	function panel:ScaleInit()
		self.SetSize = size_changed
		self.SetWide = wide_changed
		self.SetTall = tall_changed
		SUI.OnScaleChanged(self, self.ScaleChanged)
		self:On("OnRemove", on_remove)
	end
end

do
	local utf8 = {}

	local str_rel_to_abs = function(str, v, str_n)
		return v > 0 and v or math.max(str_n + v + 1, 1)
	end

	local utf8_decode = function(str, start_pos, str_n)
		start_pos = str_rel_to_abs(str, start_pos or 1, str_n)

		local b1 = str:byte(start_pos, start_pos)
		if not b1 then return nil end
		if b1 < 0x80 then return start_pos, start_pos, b1 end
		if b1 > 0xF4 or b1 < 0xC2 then return nil end

		local cont_byte_count = b1 >= 0xF0 and 3 or b1 >= 0xE0 and 2 or b1 >= 0xC0 and 1
		local end_pos = start_pos + cont_byte_count
		local code_point = 0

		if str_n < end_pos then return nil end

		local bytes = {str:byte(start_pos + 1, end_pos)}
		for i = 1, #bytes do
			local b_x = bytes[i]
			if bit.band(b_x, 0xC0) ~= 0x80 then return nil end
			code_point = bit.bor(bit.lshift(code_point, 6), bit.band(b_x, 0x3F))
			b1 = bit.lshift(b1, 1)
		end

		code_point = bit.bor(code_point, bit.lshift(bit.band(b1, 0x7F), cont_byte_count * 5))

		return start_pos, end_pos, code_point
	end

	local replacement = string.char(239, 191, 189)

	function utf8.force(str)
		local end_pos = #str
		if end_pos == 0 then return str, end_pos end

		local ret = ""
		local cur_pos = 1

		repeat
			local seq_start_pos, seq_end_pos = utf8_decode(str, cur_pos, end_pos)

			if not seq_start_pos then
				ret = ret .. replacement
				cur_pos = cur_pos + 1
			else
				ret = ret .. str:sub(seq_start_pos, seq_end_pos)
				cur_pos = seq_end_pos + 1
			end
		until cur_pos > end_pos

		return ret, #ret
	end

	-- https://gist.github.com/gdeglin/4128882

	local utf8_char_bytes = function(c)
		if c > 0 and c <= 127 then
			return 1
		elseif c >= 194 and c <= 223 then
			return 2
		elseif c >= 224 and c <= 239 then
			return 3
		elseif c >= 240 and c <= 244 then
			return 4
		end
	end
	utf8.char_bytes = utf8_char_bytes

	function utf8.len(str)
		local length = #str

		local len = 0

		local pos = 1
		while pos <= length do
			len = len + 1
			pos = pos + utf8_char_bytes(str:byte(pos))
		end

		return len
	end

	function utf8.sub(str, i, j)
		j = j or -1

		if i == nil then return "" end

		local l = (i >= 0 and j >= 0) or utf8.len(str)
		local start_char = (i >= 0) and i or l + i + 1
		local end_char = (j >= 0) and j or l + j + 1

		if start_char > end_char then return "" end

		local pos = 1
		local length = #str
		local len = 0

		local start_byte, end_byte = 1, length

		while pos <= length do
			len = len + 1

			if len == start_char then
				start_byte = pos
			end

			pos = pos + utf8_char_bytes(str:byte(pos))

			if len == end_char then
				end_byte = pos - 1
				break
			end
		end

		return str:sub(start_byte, end_byte)
	end

	sui.utf8 = utf8
end

--
-- thanks falco!
-- https://github.com/FPtje/DarkRP/blob/4fd2c3c315427e79bb7624702cfaefe9ad26ac7e/gamemode/modules/base/cl_util.lua#L42
--
do
	local utf8 = utf8
	local surface = surface

	local max_width, original_width, can_fix

	local fix_width = function()
		if can_fix then
			can_fix = false
			max_width = original_width
		end
	end

	local char_wrap = function(text, remaining_width)
		local total_width  = 0

		local new_text = ""
		for char in text:gmatch(utf8.charpattern) do
			total_width  = total_width  + surface.GetTextSize(char)
			if total_width >= remaining_width then
				total_width = surface.GetTextSize(char)
				fix_width()
				remaining_width = max_width

				new_text = new_text .. ("\n" .. char)
			else
				new_text = new_text .. char
			end
		end

		return new_text, total_width
	end

	function sui.wrap_text(text, font, width, first_width)
		text = sui.utf8.force(text)

		local total_width = 0
		can_fix = first_width and true or false
		max_width, original_width = first_width or width, width

		surface.SetFont(font)

		local space_width = surface.GetTextSize(" ")

		text = text:gsub("(%s?[%S]*)", function(word)
			local char = word:sub(1, 1)
			if char == "\n" then
				total_width = 0
				fix_width()
			end

			local wordlen = surface.GetTextSize(word)
			total_width = total_width + wordlen

			if wordlen >= max_width then
				local split_word
				split_word, total_width = char_wrap(word, max_width - (total_width - wordlen))
				return split_word
			elseif total_width < max_width then
				return word
			end

			fix_width()

			total_width = wordlen

			if char == " " then
				total_width = total_width - space_width
				return "\n" .. word:sub(2)
			end

			return "\n" .. word
		end)

		return text
	end
end

function sui.register(classname, panel_table, parent_class)
	sui.TDLib.Install(panel_table)

	if not panel_table.Add then
		function panel_table:Add(pnl)
			return vgui.Create(pnl, self)
		end
	end

	if not panel_table.NoOverrideClear and not panel_table.Clear then
		function panel_table:Clear()
			local children = self:GetChildren()
			for i = 1, #children do
				children[i]:Remove()
			end
		end
	end

	local SUI = CURRENT_SUI

	for k, v in pairs(SUI.panels_funcs) do
		panel_table[k] = v
	end

	panel_table.SUI_GetColor = function(name)
		return SUI.GetColor(name)
	end

	SUI.panels[classname] = panel_table

	return vgui.Register(SUI.name .. "." .. classname, panel_table, parent_class)
end

local Material; do
	local C_Material, material_str = select(2, debug.getupvalue(_G.Material, 1)), "0001010" -- [["mips smooth"]]
	Material = function(name)
		return C_Material(name, material_str)
	end
end
sui.Material = Material

local function prepare_theme(theme)
	for k, v in pairs(theme) do
		if IsColor(v) then continue end

		if istable(v) then
			prepare_theme(v)
		elseif isstring(v) and v:sub(1, 1) == "#" then
			theme[k] = sui.hex_rgb(v:sub(2))
		end
	end
end

function sui.new(addon_name, default_scaling, panels_funcs)
	local SUI = {
		name = addon_name,
		panels = {},
		panels_funcs = panels_funcs or {}
	}

	CURRENT_SUI = SUI

	do
		local themes = table.Copy(sui.themes)
		local current_theme_table

		function SUI.GetColor(color_name)
			return current_theme_table[color_name]
		end

		function SUI.SetTheme(theme_name)
			SUI.current_theme = theme_name
			current_theme_table = themes[theme_name]
			hook.Call(addon_name .. ".ThemeChanged")
		end

		function SUI.GetThemes()
			return themes
		end

		function SUI.AddToTheme(theme_name, tbl)
			local theme = themes[theme_name]
			for k, v in pairs(tbl) do
				theme[k] = v
			end
			prepare_theme(theme)
		end

		function SUI.RemoveTheme(theme_name)
			themes[theme_name] = nil
			if theme_name == SUI.current_theme then
				SUI.SetTheme(next(themes))
			end
		end

		function SUI.AddTheme(theme_name, tbl)
			prepare_theme(tbl)
			themes[theme_name] = tbl
		end

		SUI.themes = themes
	end

	local Scale
	do
		local scale = 1

		if default_scaling then
			SUI.Scale = sui.scale
		else
			function SUI.Scale(v)
				return floor((v * scale) + 0.5)
			end
		end
		Scale = SUI.Scale

		function SUI.ScaleEven(v)
			v = Scale(v)
			if v % 2 ~= 0 then
				v = v + 1
			end
			return v
		end

		function SUI.SetScale(_scale)
			if _scale == scale then return end

			scale = _scale
			SUI.scale = _scale

			for k, v in pairs(SUI.fonts) do
				SUI.CreateFont(k:sub(#addon_name + 1), v.font, v.size, v.weight)
			end

			SUI.CallScaleChanged()
		end

		local n = 0
		local keys = {}
		local hooks = {}
		_G[addon_name .. "_HOOKS"] = keys
		_G[addon_name .. "_KEYS"] = hooks
		_G[addon_name .. "_N"] = function()
			return n
		end
		function SUI.OnScaleChanged(name, func)
			if not isfunction(func) then
				error("Invalid function?")
			end

			if not name then
				error("Invalid name?")
			end

			if not isstring(name) then
				local _func = func
				func = function()
					local isvalid = name.IsValid
					if isvalid and isvalid(name) then
						_func(name)
					else
						SUI.RemoveScaleHook(name, true)
					end
				end
			end

			local pos = keys[name]
			if pos then
				hooks[pos + 1] = func
			else
				hooks[n + 1] = name
				hooks[n + 2] = func
				keys[name] = n + 1
				n = n + 2
			end
		end

		function SUI.RemoveScaleHook(name, in_hook)
			local pos = keys[name]
			if not pos then return end

			if in_hook then
				hooks[pos] = nil
				hooks[pos + 1] = nil
			else
				local new_name = hooks[n - 1]
				if new_name then
					hooks[pos], hooks[pos + 1] = new_name, hooks[n]
					hooks[n - 1], hooks[n] = nil, nil
					keys[new_name] = pos
				end
				n = n - 2
			end
			keys[name] = nil
		end

		function SUI.CallScaleChanged()
			if n == 0 then return end

			local i, c_n = 2, n
			::loop::
			local func = hooks[i]
			if func then
				func()
				i = i + 2
			else
				local _n, _i = c_n, i
				if n ~= c_n then
					_n = n
					i = i + 2
				else
					c_n = c_n - 2
				end

				local new_name = hooks[_n - 1]
				if new_name then
					hooks[_i - 1], hooks[_i] = new_name, hooks[_n]
					hooks[_n - 1], hooks[_n] = nil, nil
					keys[new_name] = _i - 1
				end

				n = n - 2
			end

			if i <= c_n then
				goto loop
			end
		end

		function SUI.GetScale()
			return scale
		end

		SUI.scale = 1
	end

	do
		local fonts = {}

		function SUI.CreateFont(font_name, font, size, weight)
			font_name = addon_name .. font_name

			fonts[font_name] = fonts[font_name] or {
				font = font,
				size = size,
				weight = weight
			}

			surface.CreateFont(font_name, {
				font = font,
				size = Scale(size),
				weight = weight,
				extended = true
			})

			return font_name
		end

		function SUI.GetFont(font_name)
			return addon_name .. font_name
		end

		function SUI.GetFontHeight(font_name)
			local font = fonts[addon_name .. font_name] or fonts[font_name]
			if not font then return 0 end

			return floor(Scale(font.size or 0))
		end

		SUI.fonts = fonts
	end

	do
		local materials = {}

		local delay = 0.008
		local next_run = UnPredictedCurTime()

		function SUI.Material(mat, allow_delay)
			local _mat = materials[mat]
			if _mat then return _mat end

			if allow_delay then
				if UnPredictedCurTime() < next_run then return end
				next_run = UnPredictedCurTime() + delay
			end

			materials[mat] = Material(mat)

			return materials[mat]
		end

		SUI.materials = materials
	end

	SUI.SetTheme("Dark")

	for _, f in ipairs(file.Find("sui/vgui/sui_*.lua", "LUA")) do
		include("sui/vgui/" .. f)
	end

	for _, f in ipairs(file.Find(string.format("sui/vgui/%s_*.lua", addon_name:lower()), "LUA")) do
		include("sui/vgui/" .. f)
	end

	return SUI
end

sui.themes = sui.themes or {}
function sui.add_theme(name, tbl)
	prepare_theme(tbl)
	sui.themes[name] = tbl
end

function sui.valid_options()
	local objs = {}
	objs.IsValid = function()
		local valid = true
		for i = 1, #objs do
			local obj = objs[i]
			if obj:IsValid() and obj.valid == false then
				valid = false
				break
			end
		end
		return valid
	end
	objs.Add = function(obj)
		table.insert(objs, obj)
	end
	return objs
end

do
	local SURFACE = Color(31, 31, 31)
	local PRIMARY = Color(65, 185, 255)

	local ON_SURFACE = Color(255, 255, 255)
	local ON_SURFACE_HIGH_EMPHASIS = ColorAlpha(ON_SURFACE, 221)
	local ON_SURFACE_MEDIUM_EMPHASIS = ColorAlpha(ON_SURFACE, 122)
	local ON_SURFACE_DISABLED = ColorAlpha(ON_SURFACE, 97)

	local ON_PRIMARY = Color(60, 60, 60)

	sui.add_theme("Dark", {
		frame = Color(18, 18, 18),
		frame_blur = false,

		title = ON_SURFACE,
		header = SURFACE,

		close = ON_SURFACE_MEDIUM_EMPHASIS,
		close_hover = Color(255, 60, 60),
		close_press = Color(255, 255, 255, 30),

		button = PRIMARY,
		button_text = "#050709",
		button_hover = ColorAlpha(ON_PRIMARY, 100),
		button_click = ColorAlpha(ON_PRIMARY, 240),
		button_disabled = Color(100, 100, 100),
		button_disabled_text = "#bdbdbd",

		button2_hover = ColorAlpha(PRIMARY, 5),
		button2_selected = ColorAlpha(PRIMARY, 15),

		scroll = ColorAlpha(PRIMARY, 97),
		scroll_grip = PRIMARY,

		scroll_panel = Color(29, 29, 29),
		scroll_panel_outline = false,

		text_entry_bg = Color(34, 34, 34),
		text_entry_bar_color = Color(0, 0, 0, 0),
		text_entry = ON_SURFACE_HIGH_EMPHASIS,
		text_entry_2 = ON_SURFACE_MEDIUM_EMPHASIS,
		text_entry_3 = PRIMARY,

		property_sheet_bg = Color(39, 39, 39),
		property_sheet_tab = Color(150, 150, 150),
		property_sheet_tab_click = Color(255, 255, 255, 30),
		property_sheet_tab_active = PRIMARY,

		toggle_button = ON_SURFACE_DISABLED,
		toggle_button_switch = ON_SURFACE_HIGH_EMPHASIS,

		toggle_button_active = ColorAlpha(PRIMARY, 65),
		toggle_button_switch_active = PRIMARY,

		slider_knob = PRIMARY,
		slider_track = ColorAlpha(PRIMARY, 65),
		slider_hover = ColorAlpha(PRIMARY, 5),
		slider_pressed = ColorAlpha(PRIMARY, 30),

		on_sheet = Color(43, 43, 43, 200),
		on_sheet_hover = Color(200, 200, 200, 20),

		--=--
		query_box_bg = "#181818",
		query_box_cancel = Color(244, 67, 54, 30),
		query_box_cancel_text = "#f44336",
		--=--

		--=--
		menu = "#212121",

		menu_option = "#212121",
		menu_option_text = "#bdbdbd",
		menu_option_hover = "#3b3b3b",
		menu_option_hover_text = "#fefefe",

		menu_spacer = "#303030",
		--=--

		line = "#303030",

		--=--
		column_sheet = "#263238",
		column_sheet_bar = "#202020",

		column_sheet_tab = "#202020",
		column_sheet_tab_hover = "#2e2e2e",
		column_sheet_tab_active = "#383838",

		column_sheet_tab_icon = "#909090",
		column_sheet_tab_icon_hover = "#f0f0f0",
		column_sheet_tab_icon_active = "#34a1e0",
		--=--

		--=--
		collapse_category_header = "#272727",
		collapse_category_header_hover = "#2a2a2a",
		collapse_category_header_active = "#2e2e2e",

		collapse_category_header_text = "#aaaaaa",
		collapse_category_header_text_hover = "#dcdcdc",
		collapse_category_header_text_active = "#34A1E0",

		collapse_category_item = "#343434",
		collapse_category_item_hover = "#464646",
		collapse_category_item_active = "#535353",

		collapse_category_item_text = "#aaaaaa",
		collapse_category_item_text_hover = "#dcdcdc",
		collapse_category_item_text_active = "#ffffff",
		--=--
	})
end

do
	local PRIMARY = Color(65, 185, 255)

	local ON_PRIMARY = Color(220, 220, 220)

	sui.add_theme("Blur", {
		frame = Color(30, 30, 30, 220),
		frame_blur = true,

		title = Color(255, 255, 255),
		header = Color(60, 60, 60, 200),

		close = Color(200, 200, 200),
		close_hover = Color(255, 60, 60),
		close_press = Color(255, 255, 255, 30),

		button = ColorAlpha(PRIMARY, 130),
		button_text = ON_PRIMARY,
		button_hover = Color(0, 0, 0, 30),
		button_click = PRIMARY,
		button_disabled = Color(100, 100, 100),
		button_disabled_text = "#bdbdbd",

		button2_hover = ColorAlpha(PRIMARY, 5),
		button2_selected = ColorAlpha(PRIMARY, 15),

		scroll = Color(0, 0, 0, 100),
		scroll_grip = PRIMARY,

		scroll_panel = Color(255, 255, 255, 10),
		scroll_panel_outline = false,

		text_entry_bg = Color(0, 0, 0, 0),
		text_entry_bar_color = Color(200, 200, 200, 153),
		text_entry = Color(240, 240, 240, 221),
		text_entry_2 = Color(200, 200, 200, 153),
		text_entry_3 = PRIMARY,

		property_sheet_bg = Color(60, 60, 60, 200),
		property_sheet_tab = Color(150, 150, 150),
		property_sheet_tab_click = Color(255, 255, 255, 40),
		property_sheet_tab_active = PRIMARY,

		toggle_button = Color(244, 67, 54),
		toggle_button_switch = Color(230, 230, 230),

		toggle_button_active = PRIMARY,
		toggle_button_switch_active = Color(230, 230, 230),

		slider_knob = PRIMARY,
		slider_track = ColorAlpha(PRIMARY, 100),
		slider_hover = ColorAlpha(PRIMARY, 40),
		slider_pressed = ColorAlpha(PRIMARY, 70),

		on_sheet = Color(60, 60, 60, 180),
		on_sheet_hover = Color(30, 30, 30, 70),

		--=--
		query_box_bg = Color(0, 0, 0, 100),
		query_box_cancel = Color(244, 67, 54, 30),
		query_box_cancel_text = "#f44336",
		--=--
	})
end