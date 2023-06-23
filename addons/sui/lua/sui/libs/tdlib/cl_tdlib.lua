--[[
	Three's Derma Lib
	Made by Threebow

	You are free to use this anywhere you like, or sell any addons
	made using this, as long as I am properly accredited.
]]

local pairs = pairs
local ipairs = ipairs
local Color = Color
local render = render
local SysTime = SysTime
local Lerp, RealFrameTime = Lerp, RealFrameTime
local RoundedBox, RoundedBoxEx, NoTexture = draw.RoundedBox, draw.RoundedBoxEx, draw.NoTexture
local SetDrawColor, DrawRect = surface.SetDrawColor, surface.DrawRect
local DrawPoly = surface.DrawPoly
local sui = sui

local Panel = FindMetaTable("Panel")

--[[
	Constants
]]
local BLUR = CreateMaterial("SUI.TDLib.Blur", "gmodscreenspace", {
	["$basetexture"] = "_rt_fullframefb",
	["$blur"] = (1 / 3) * 7,
})

local COL_WHITE_1 = Color(255, 255, 255)
local COL_WHITE_2 = Color(255, 255, 255, 30)

--[[
	credits to http://slabode.exofire.net/circle_draw.shtml
]]
local calculate_circle do
	local cos = math.cos
	local sin = math.sin
	local round = math.Round
	local sqrt = math.sqrt
	local pi = math.pi
	calculate_circle = function(circle, x_centre, y_centre, r)
		if circle.x == x_centre and circle.y == y_centre and circle.r == r then return end

		local step = (2 * pi) / round(6 * sqrt(r))

		local i = 0
		for theta = 2 * pi, 0, -step do
			local x = x_centre + r * cos(theta)
			local y = y_centre - r * sin(theta)
			i = i + 1
			circle[i] = {
				x = x,
				y = y
			}
		end

		for i = i + 1, #circle do
			circle[i] = nil
		end

		circle.x = x_centre
		circle.y = y_centre
		circle.r = r
	end
end

--[[
void DrawArc(float cx, float cy, float r, float start_angle, float arc_angle, int num_segments)
{
	float theta = arc_angle / float(num_segments - 1);//theta is now calculated from the arc angle instead, the - 1 bit comes from the fact that the arc is open

	float tangetial_factor = tanf(theta);

	float radial_factor = cosf(theta);


	float x = r * cosf(start_angle);//we now start at the start angle
	float y = r * sinf(start_angle);

	glBegin(GL_LINE_STRIP);//since the arc is not a closed curve, this is a strip now
	for(int ii = 0; ii < num_segments; ii++)
	{
		glVertex2f(x + cx, y + cy);

		float tx = -y;
		float ty = x;

		x += tx * tangetial_factor;
		y += ty * tangetial_factor;

		x *= radial_factor;
		y *= radial_factor;
	}
	glEnd();
}
]]

local copy_color = function(color)
	return Color(color.r, color.g, color.b, color.a)
end

local color_alpha = function(color, a)
	color.a = a
	return color
end

--[[
	Collection of various utilities
]]

local TDLibUtil = {}

function TDLibUtil.DrawCircle(circle, x, y, r, color)
	calculate_circle(circle, x, y, r)

	SetDrawColor(color)
	NoTexture()
	DrawPoly(circle)
end
local DrawCircle = TDLibUtil.DrawCircle

do
	local SetMaterial = surface.SetMaterial
	local UpdateScreenEffectTexture, DrawTexturedRect, SetScissorRect = render.UpdateScreenEffectTexture, surface.DrawTexturedRect, render.SetScissorRect

	local scrW, scrH = ScrW(), ScrH()
	hook.Add("OnScreenSizeChanged", "SUI.TDLib", function()
		scrW, scrH = ScrW(), ScrH()
	end)

	function TDLibUtil.BlurPanel(s)
		local x, y = s:LocalToScreen(0, 0)

		SetDrawColor(255, 255, 255)
		SetMaterial(BLUR)

		for i = 1, 2 do
			UpdateScreenEffectTexture()
			DrawTexturedRect(x * -1, y * -1, scrW, scrH)
		end
	end

	function TDLibUtil.DrawBlur(x, y, w, h)
		SetDrawColor(255, 255, 255)
		SetMaterial(BLUR)

		SetScissorRect(x, y, x + w, y + h, true)
			for i = 1, 2 do
				UpdateScreenEffectTexture()
				DrawTexturedRect(-1, -1, scrW, scrH)
			end
		SetScissorRect(0, 0, 0, 0, false)
	end
end

local LibClasses = {}

do
	local on_funcs = {}

	function LibClasses:On(name, func)
		local old_func = self[name]

		if not old_func then
			self[name] = func
			return self
		end

		local name_2 = name .. "_funcs"

		-- we gotta avoid creating 13535035 closures
		if not on_funcs[name] then
			on_funcs[name] = function(s, a1, a2, a3, a4)
				local funcs = s[name_2]
				local i, n = 0, #funcs
				::loop::
				i = i + 1
				if i <= n then
					funcs[i](s, a1, a2, a3, a4)
					goto loop
				end
			end
		end

		if not self[name_2] then
			self[name] = on_funcs[name]
			self[name_2] = {
				old_func,
				func
			}
		else
			table.insert(self[name_2], func)
		end

		return self
	end
end

do
	local UnPredictedCurTime = UnPredictedCurTime

	local transition_func = function(s)
		local transitions = s.transitions
		local i, n = 0, #transitions
		::loop::
		i = i + 1

		if i <= n then
			local v = transitions[i]
			local name = v.name
			local v2 = s[name]
			if v.func(s) then
				if v.start_0 then
					v.start_1, v.start_0 = UnPredictedCurTime(), nil
				end

				if v2 ~= 1 then
					s[name] = Lerp((UnPredictedCurTime() - v.start_1) / v.time, v2, 1)
				end
			else
				if v.start_1 then
					v.start_0, v.start_1 = UnPredictedCurTime(), nil
				end

				if v2 ~= 0 then
					s[name] = Lerp((UnPredictedCurTime() - v.start_0) / v.time, v2, 0)
				end
			end

			goto loop
		end
	end

	function LibClasses:SetupTransition(name, time, func)
		self[name] = 0

		local transition = {
			name = name,
			time = time,
			func = func,
			start_0 = 0,
			start_1 = 0,
		}

		if self.transitions then
			for k, v in ipairs(self.transitions) do
				if v.name == name then
					self.transitions[k] = transition
					return self
				end
			end
			table.insert(self.transitions, transition)
		else
			self.transitions = {transition}
			self:On("Think", transition_func)
		end

		return self
	end
end

function LibClasses:ClearPaint()
	self.Paint = nil
	self.Paint_funcs = nil
	local SetPaintBackgroundEnabled = self.SetPaintBackgroundEnabled
	if SetPaintBackgroundEnabled then
		SetPaintBackgroundEnabled(self, false)
	end
	return self
end

function LibClasses:RoundedBox(id, r, x, y, w, h, c)
	self.colors = self.colors or {}
	local colors = self.colors

	local id_c = colors[id]
	if not id_c then
		id_c = Color(c:Unpack())
		colors[id] = id_c
	end

	sui.lerp_color(id_c, c)
	RoundedBox(r, x, y, w, h, id_c)
end

do
	local SetFGColor = Panel.SetFGColor

	local set_color = function(s, col)
		s.m_colText = col
		SetFGColor(s, col.r, col.g, col.b, col.a)
	end

	local paint = function(s)
		local col = s.sui_textcolor
		sui.lerp_color(col, s.new_col)
		set_color(s, col)
	end

	function LibClasses:TextColor(c, use_paint)
		local col = self.sui_textcolor
		if not col then
			col = Color(c:Unpack())
			self.sui_textcolor = col

			if use_paint then
				self:On("Paint", paint)
			end
		end

		if use_paint then
			self.new_col = c
		else
			sui.lerp_color(col, c)
			self:SetTextColor(col)
		end
	end
end

do
	local fade_hover_Paint = function(s, w, h)
		if s.FadeHovers ~= 0 then
			color_alpha(s.fadehover_color, s.fadehover_old_alpha * s.FadeHovers)
			if s.fadehover_radius > 0 then
				RoundedBox(s.fadehover_radius, 0, 0, w, h, s.fadehover_color)
			else
				SetDrawColor(s.fadehover_color)
				DrawRect(0, 0, w, h)
			end
		end
	end

	function LibClasses:FadeHover(color, time, radius, func)
		color = copy_color(color or COL_WHITE_2)
		self.fadehover_color = color
		self.fadehover_radius = radius or 0
		self.fadehover_old_alpha = color.a
		self:SetupTransition("FadeHovers", time or 0.8, func or TDLibUtil.HoverFunc)
		self:On("Paint", fade_hover_Paint)
		return self
	end
end

function LibClasses:BarHover(color, height, time)
	color = color or COL_WHITE_1
	height = height or 2
	time = time or 1.6
	self:SetupTransition("BarHovers", time, TDLibUtil.HoverFunc)
	self:On("Paint", function(s, w, h)
		if s.BarHovers ~= 0 then
			local bar = Round(w * s.BarHovers)
			SetDrawColor(color)
			DrawRect((w / 2) - (bar / 2), h - height, bar, height)
		end
	end)
	return self
end

do
	local paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, s.SUI_GetColor("line"))
	end

	function LibClasses:Line(dock, m1, m2, m3, m4)
		self.making_line = true

		local line = self:Add("SAM.Panel")
		line:Dock(dock or TOP)

		if self.line_margin then
			line:DockMargin(unpack(self.line_margin))
		else
			line:DockMargin(m1 or 0, m2 or 0, m3 or 0, m4 or 10)
		end

		line.no_scale = true
		line:SetTall(1)
		line.Paint = paint

		self.making_line = false
		return line
	end

	function LibClasses:LineMargin(m1, m2, m3, m4)
		self.line_margin = {m1 or 0, m2 or 0, m3 or 0, m4 or 0}
		return self
	end
end

do
	local background_Paint_1 = function(s)
		s:SetBGColor(s.background_color)
	end

	local background_Paint_2 = function(s, w, h)
		RoundedBoxEx(s.background_radius, 0, 0, w, h, s.background_color, true, true, true, true)
	end

	local background_Paint_3 = function(s, w, h)
		RoundedBoxEx(s.background_radius, 0, 0, w, h, s.background_color, s.background_r_tl, s.background_r_tr, s.background_r_bl, s.background_r_br)
	end

	function LibClasses:Background(color, radius, r_tl, r_tr, r_bl, r_br)
		self.background_color = color
		if isnumber(radius) and radius ~= 0 then
			self.background_radius = radius
			if isbool(r_tl) or isbool(r_tr) or isbool(r_bl) or isbool(r_br) then
				self.background_r_tl = r_tl
				self.background_r_tr = r_tr
				self.background_r_bl = r_bl
				self.background_r_br = r_br
				self:On("Paint", background_Paint_3)
			else
				self:On("Paint", background_Paint_2)
			end
		else
			self:SetPaintBackgroundEnabled(true)
			self:On("ApplySchemeSettings", background_Paint_1)
			self:On("PerformLayout", background_Paint_1)
		end
		return self
	end
end

function LibClasses:CircleClick(color, speed, target_radius)
	self.circle_click_color = color or COL_WHITE_2

	speed = speed or 5
	target_radius = isnumber(target_radius) and target_radius or false

	local radius, alpha, click_x, click_y = 0, -1, 0, 0
	local circle = {}
	self:On("Paint", function(s, w)
		if alpha >= 0 then
			DrawCircle(circle, click_x, click_y, radius, ColorAlpha(self.circle_click_color, alpha))
			local frame_time = RealFrameTime()
			radius, alpha = Lerp(frame_time * speed, radius, target_radius or w), Lerp(frame_time * speed, alpha, -1)
		end
	end)
	self:On("DoClick", function()
		click_x, click_y = self:CursorPos()
		radius, alpha = 0, self.circle_click_color.a
	end)
	return self
end

do
	local min = math.min
	function LibClasses:CircleClick2(color, speed, target_radius, start_radius)
		color = color or COL_WHITE_2
		local _color = Color(color:Unpack())

		speed = speed or 5
		target_radius = isnumber(target_radius) and target_radius or false

		local radius, alpha = 0, -1
		local circle = {}
		self:On("Paint", function(s, w, h)
			if alpha >= 0 then
				_color.a = alpha
				DrawCircle(circle, w / 2, h / 2, radius, _color)

				local frame_time = RealFrameTime()
				radius, alpha = Lerp(frame_time * speed, radius, target_radius or min(w, h) / 2), Lerp(frame_time * speed, alpha, -1)
			end
		end)

		self:On("DoClick", function()
			radius, alpha = start_radius or 0, color.a
		end)

		return self
	end
end

-- https://github.com/Facepunch/garrysmod/pull/1520#issuecomment-410458090
function LibClasses:Outline(color, width)
	color = color or COL_WHITE_1
	width = width or 1
	self:On("Paint", function(s, w, h)
		SetDrawColor(color)
		DrawRect(0, 0, w, width)
		DrawRect(0, h - width, w, width)
		DrawRect(0, width, width, h - (width * 2))
		DrawRect(w - width, width, width, h - (width * 2))
	end)
	return self
end

function LibClasses:LinedCorners(color, len)
	color = color or COL_WHITE_1
	len = len or 15
	self:On("Paint", function(s, w, h)
		SetDrawColor(color)
		DrawRect(0, 0, len, 1)
		DrawRect(0, 1, 1, len - 1)
		DrawRect(w - len, h - 1, len, 1)
		DrawRect(w - 1, h - len, 1, len - 1)
	end)
	return self
end

function LibClasses:SideBlock(color, size, side)
	color = color or COL_WHITE_1
	size = size or 3
	side = side or LEFT
	self:On("Paint", function(s, w, h)
		SetDrawColor(color)
		if side == LEFT then
			DrawRect(0, 0, size, h)
		elseif side == TOP then
			DrawRect(0, 0, w, size)
		elseif size == RIGHT then
			DrawRect(w - size, 0, size, h)
		elseif side == BOTTOM then
			DrawRect(0, h - size, w, size)
		end
	end)
	return self
end

function LibClasses:Blur()
	self:On("Paint", TDLibUtil.BlurPanel)
	return self
end

do
	local STENCILOPERATION_REPLACE = STENCILOPERATION_REPLACE
	local STENCILOPERATION_ZERO = STENCILOPERATION_ZERO
	local STENCILCOMPARISONFUNCTION_NEVER = STENCILCOMPARISONFUNCTION_NEVER
	local STENCILCOMPARISONFUNCTION_EQUAL = STENCILCOMPARISONFUNCTION_EQUAL

	local ClearStencil = render.ClearStencil
	local SetStencilEnable = render.SetStencilEnable
	local SetStencilWriteMask = render.SetStencilWriteMask
	local SetStencilTestMask = render.SetStencilTestMask
	local SetStencilFailOperation = render.SetStencilFailOperation
	local SetStencilPassOperation = render.SetStencilPassOperation
	local SetStencilZFailOperation = render.SetStencilZFailOperation
	local SetStencilCompareFunction = render.SetStencilCompareFunction
	local SetStencilReferenceValue = render.SetStencilReferenceValue

	local color_white = color_white

	local avatar_setplayer = function(s, ply, size)
		s.avatar:SetPlayer(ply, size)
	end

	local avatar_setsteamid = function(s, steamid, size)
		s.avatar:SetSteamID(steamid, size)
	end

	function LibClasses:CircleAvatar()
		local avatar = self:Add("AvatarImage")
		avatar:Dock(FILL)
		avatar:SetPaintedManually(true)
		self.avatar = avatar
		self.SetSteamID = avatar_setsteamid
		self.SetPlayer = avatar_setplayer

		local circle = {}
		local PaintManual = avatar.PaintManual
		self.Paint = function(s, w, h)
			ClearStencil()
			SetStencilEnable(true)

			SetStencilWriteMask(1)
			SetStencilTestMask(1)

			SetStencilFailOperation(STENCILOPERATION_REPLACE)
			SetStencilPassOperation(STENCILOPERATION_ZERO)
			SetStencilZFailOperation(STENCILOPERATION_ZERO)
			SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
			SetStencilReferenceValue(1)

			local a = w / 2
			DrawCircle(circle, a, a, a, color_white)

			SetStencilFailOperation(STENCILOPERATION_ZERO)
			SetStencilPassOperation(STENCILOPERATION_REPLACE)
			SetStencilZFailOperation(STENCILOPERATION_ZERO)
			SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			SetStencilReferenceValue(1)

			PaintManual(avatar)

			SetStencilEnable(false)
		end
		return self
	end
end

do
	function LibClasses:AnimationThinkInternal()
		local systime = SysTime()

		if self.Term and self.Term <= systime then
			self:Remove()

			return
		end

		local m_AnimList = self.m_AnimList
		if not m_AnimList then return end

		for i = #m_AnimList, 1, -1 do
			local anim = m_AnimList[i]
			if systime >= anim.StartTime then
				local frac = math.TimeFraction(anim.StartTime, anim.EndTime, systime)
				frac = math.Clamp(frac, 0, 1)

				local Think = anim.Think
				if Think then
					Think(anim, self, frac ^ (1.0 - (frac - 0.5)))
				end

				if frac == 1 then
					local OnEnd = anim.OnEnd
					if OnEnd then
						OnEnd(anim, self)
					end

					m_AnimList[i] = nil
				end
			end
		end
	end

	local sort = function(a, b)
		return a.EndTime > b.EndTime
	end

	function LibClasses:NewAnimation(length, delay, ease, callback)
		delay = delay or 0
		ease = ease or -1

		if self.m_AnimQueue then
			delay = delay + self:AnimTail()
			self.m_AnimQueue = false
		else
			delay = delay + SysTime()
		end

		local anim = {
			StartTime = delay,
			EndTime = delay + length,
			Ease = ease,
			OnEnd = callback
		}

		self:SetAnimationEnabled(true)

		if self.m_AnimList == nil then
			self.m_AnimList = {}
		end

		table.insert(self.m_AnimList, anim)
		table.sort(self.m_AnimList, sort)

		self.AnimationThink = self.AnimationThinkInternal

		return anim
	end

	local MoveThink = function(anim, panel, frac)
		if not anim.startx then
			anim.startx = panel.x
			anim.starty = panel.y
		end

		local x = Lerp(frac, anim.startx, anim.x)
		local y = Lerp(frac, anim.starty, anim.y)
		panel:SetPos(x, y)
	end

	function LibClasses:MoveTo(x, y, length, delay, ease, callback)
		if self.x == x and self.y == y then return end

		local anim = self:NewAnimation(length, delay, ease, callback)
		anim.x = x
		anim.y = y
		anim.Think = MoveThink
	end

	local SetSize = Panel.SetSize
	local SizeThink = function(anim, panel, frac)
		if not anim.startw then
			anim.startw, anim.starth = panel:GetSize()
		end

		local w, h
		if anim.sizew and anim.sizeh then
			w = Lerp(frac, anim.startw, anim.w)
			h = Lerp(frac, anim.starth, anim.h)
			SetSize(panel, w, h)
		elseif anim.sizew then
			w = Lerp(frac, anim.startw, anim.w)
			SetSize(panel, w, panel.starth)
		else
			h = Lerp(frac, anim.starth, anim.h)
			SetSize(panel, panel.startw, h)
		end

		if panel:GetDock() > 0 then
			panel:InvalidateParent()
		end
	end

	function LibClasses:SizeTo(w, h, length, delay, ease, callback)
		local anim = self:NewAnimation(length, delay, ease, callback)

		if w ~= -1 then
			anim.sizew = true
		end

		if h ~= -1 then
			anim.sizeh = true
		end

		anim.w, anim.h = w, h
		anim.Think = SizeThink

		return anim
	end

	local SetVisible = Panel.SetVisible
	local IsVisible = Panel.IsVisible

	local is_visible = function(s)
		local state = s.visible_state
		if state ~= nil then
			return state
		else
			return IsVisible(s)
		end
	end

	function LibClasses:AnimatedSetVisible(visible, cb)
		if visible == is_visible(self) then
			if cb then
				cb()
			end
			return
		end

		if visible then
			SetVisible(self, true)
		end

		self.visible_state = visible
		self:Stop()

		self:AlphaTo(visible and 255 or 0, 0.2, 0, function()
			SetVisible(self, visible)
			self:InvalidateParent(true)
			if cb then
				cb()
			end
		end)

		self:InvalidateParent(true)
	end

	function LibClasses:AnimatedToggleVisible()
		self:AnimatedSetVisible(not is_visible(self))
	end

	function LibClasses:AnimatedIsVisible()
		return is_visible(self)
	end
end

function Panel:SUI_TDLib()
	for k, v in pairs(LibClasses) do
		self[k] = v
	end
	return self
end

TDLibUtil.Install = Panel.SUI_TDLib

local count = 0
TDLibUtil.Start = function()
	count = count + 1
	for k, v in pairs(LibClasses) do
		if not Panel["SUI_OLD" .. k] then
			local old = Panel[k]
			if old == nil then
				old = v
			end
			Panel[k], Panel["SUI_OLD" .. k] = v, old
		end
	end
end

TDLibUtil.End = function()
	count = count - 1
	if count > 0 then return end
	for k, v in pairs(LibClasses) do
		local old = Panel["SUI_OLD" .. k]
		if old == v then
			Panel[k] = nil
		else
			Panel[k] = old
		end
		Panel["SUI_OLD" .. k] = nil
	end
end

TDLibUtil.HoverFunc = function(p)
	return p:IsHovered() and not p:GetDisabled()
end

TDLibUtil.DrawOutlinedBox = function(radius, x, y, w, h, bg, outline, thickness)
	thickness = thickness or 2
	draw.RoundedBox(radius, x, y, w, h, outline)
	draw.RoundedBox(radius, x + thickness, y + thickness, w - (thickness * 2), h - (thickness * 2), bg)
end

do
	local cos, sin, sqrt = math.cos, math.sin, math.sqrt
	local clamp, floor = math.Clamp, math.floor
	local min, max = math.min, math.max

	local calc_ellipse_points = function(rx, ry)
		local points = sqrt(((rx * ry) / 2) * 6)
		return max(points, 8)
	end

	local M_PI = 3.14159265358979323846
	calc_rect = function(c, r, x, y, w, h)
		if
			(c.r == r) and
			(c.x == x and c.y == y) and
			(c.w == w and c.h == h)
		then return end

		r = clamp(r, 0, min(w, h) / 2)

		local rx, ry = r, r
		if w >= 0.02 then
			rx = min(rx, w / 2.0 - 0.01)
		end
		if h >= 0.02 then
			ry = min(ry, h / 2.0 - 0.01)
		end

		local points = max(calc_ellipse_points(rx, ry) / 4, 1)
		points = floor(points)

		local half_pi = M_PI / 2
		local angle_shift = half_pi / (points + 1)

		local phi = 0
		for i = 1, points + 2 do
			c[i] = {
				x = x + rx * (1 - cos(phi)),
				y = y + ry * (1 - sin(phi))
			}
			phi = phi + angle_shift
		end

		phi = half_pi
		for i = points + 3, 2 * (points + 2) do
			c[i] = {
				x = x + w - rx * (1 + cos(phi)),
				y = y +     ry * (1 - sin(phi))
			}
			phi = phi + angle_shift
		end

		phi = 2 * half_pi
		for i = (2 * (points + 2)) + 1, 3 * (points + 2) do
			c[i] = {
				x = x + w - rx * (1 + cos(phi)),
				y = y + h - ry * (1 + sin(phi))
			}
			phi = phi + angle_shift
		end

		phi = 3 * half_pi
		for i = (3 * (points + 2)) + 1, 4 * (points + 2) do
			c[i] = {
				x = x +     rx * (1 - cos(phi)),
				y = y + h - ry * (1 + sin(phi))
			}
			phi = phi + angle_shift
		end

		local last = (points + 2) * 4 + 1
		c[last] = c[1]

		for i = last + 1, #c do
			c[i] = nil
		end

		c.r = r
		c.x, c.y = x, y
		c.w, c.h = w, h
	end

	TDLibUtil.RoundedBox = function(c, r, x, y, w, h, color)
		calc_rect(c, r, x, y, w, h)

		SetDrawColor(color)
		NoTexture()
		DrawPoly(c)
	end
end

TDLibUtil.LibClasses = LibClasses

sui.TDLib = TDLibUtil