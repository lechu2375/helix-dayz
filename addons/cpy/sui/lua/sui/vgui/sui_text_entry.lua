local sui = sui

local surface = surface
local utf8 = sui.utf8
local draw = draw
local math = math

local IsValid = IsValid
local tostring = tostring
local tonumber = tonumber

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local GetColor = SUI.GetColor
local TEXT_ENTRY_FONT = SUI.CreateFont("TextEntry", "Roboto Regular", 16)

local Panel = {}

sui.scaling_functions(Panel)

AccessorFunc(Panel, "m_FontName", "Font", FORCE_STRING)
AccessorFunc(Panel, "m_Editable", "Editable", FORCE_BOOL)
AccessorFunc(Panel, "m_Placeholder", "Placeholder", FORCE_STRING)
AccessorFunc(Panel, "m_MaxChars", "MaxChars", FORCE_NUMBER)
AccessorFunc(Panel, "m_Numeric", "Numeric", FORCE_BOOL)
AccessorFunc(Panel, "m_NoBar", "NoBar", FORCE_BOOL)
AccessorFunc(Panel, "m_BarColor", "BarColor")
AccessorFunc(Panel, "m_Background", "Background")
AccessorFunc(Panel, "m_Radius", "Radius")
AccessorFunc(Panel, "m_NoEnter", "NoEnter")

Panel:SetRadius(3)

function Panel:Init()
	self:ScaleInit()

	self:SetupTransition("TextEntryReady", 0.9, function()
		return self:IsEditing() or self:GetBarColor() ~= nil
	end)

	self:SetUpdateOnType(true)
	self:SetCursor("beam")
	self:SetFont(TEXT_ENTRY_FONT)
	self:SetPlaceholder("Placeholder text")

	self:SetSize(200, 22)

	self.allowed_numeric_characters = "1234567890.-"

	self.history = {}
	self.history_pos = 1
	self.can_use_history = true

	self:OnScaleChange()
end

function Panel:SetCaretPos(pos)
	DTextEntry.SetCaretPos(self, math.Clamp(pos, 0, utf8.len(self:GetText())))
end

function Panel:SetValue(value)
	self:SetText(value)
	self:OnValueChange(value)
end

function Panel:AllowInput(ch)
	if self:CheckNumeric(ch) then return true end

	if sui.wspace_chs[ch] or sui.cntrl_chs[ch] then
		return true
	end

	local max_chars = self:GetMaxChars()
	if max_chars and #self:GetText() >= max_chars then
		surface.PlaySound("resource/warning.wav")
		return true
	end
end

function Panel:AddValue(v, i, j)
	local original_text = self:GetText()

	local start
	if i then
		start = original_text:sub(1, i)
	else
		start = utf8.sub(original_text, 1, self:GetCaretPos())
	end

	local text = start .. v
	local caret_pos = utf8.len(text)

	local _end
	if j then
		_end = original_text:sub(j)
	else
		_end = utf8.sub(original_text, utf8.len(start) + 1)
	end
	text = text .. _end

	local max_chars = self:GetMaxChars()
	if max_chars then
		text = text:sub(1, max_chars)
	end

	self:SetValue(text)
	self:SetCaretPos(caret_pos)
end

function Panel:OnKeyCodeTyped(code)
	if self.no_down then
		self.no_down = nil
		return
	end

	if code == KEY_UP or code == KEY_DOWN then
		if not self:UpdateFromHistory(code) then
			return true
		end

		local lines, caret_line = self:GetNumLines()

		if lines == 1 then
			return true
		end

		--
		-- this fixes a weird issue
		-- make the text entry has at least 2 lines, go up then go down, you won't be able to go up again
		--
		if code == KEY_DOWN and lines == caret_line + 1 then
			self.no_down = true
			gui.InternalKeyCodeTyped(KEY_DOWN)
		end
	end

	self:OnKeyCode(code)

	if code == KEY_ENTER then
		if IsValid(self.Menu) then
			self.Menu:Remove()
		end

		if not self:GetNoEnter() then
			self:FocusNext()
			self:OnEnter()
		end
	end
end

function Panel:DisallowFloats(disallow)
	if not isbool(disallow) then
		disallow = true
	end

	if disallow then
		self.allowed_numeric_characters = self.allowed_numeric_characters:gsub("%.", "", 1)
	elseif not self.allowed_numeric_characters:find(".", 1, true) then
		self.allowed_numeric_characters = self.allowed_numeric_characters .. "."
	end
end

function Panel:DisallowNegative(disallow)
	if not isbool(disallow) then
		disallow = true
	end

	if disallow then
		self.allowed_numeric_characters = self.allowed_numeric_characters:gsub("%-", "", 1)
	elseif not self.allowed_numeric_characters:find("-", 1, true) then
		self.allowed_numeric_characters = self.allowed_numeric_characters .. "-"
	end
end

function Panel:CheckNumeric(value)
	if not self:GetNumeric() then return false end

	if not self.allowed_numeric_characters:find(value, 1, true) then
		return true
	end

	local new_value = ""
	local current_value = tostring(self:GetText())

	local caret_pos = self:GetCaretPos()
	for i = 0, #current_value do
		new_value = new_value .. current_value:sub(i, i)
		if i == caret_pos then
			new_value = new_value .. value
		end
	end

	if #current_value ~= 0 and not tonumber(new_value) then
		return true
	end

	return false
end

function Panel:AddHistory(txt)
	if not txt or txt == "" then return end
	local history = self.history
	if history[#history] ~= txt then
		table.insert(history, txt)
	end
end

function Panel:UpdateFromHistory(code)
	if not self.can_use_history then return end

	local lines, caret_line = self:GetNumLines()

	if code == KEY_UP then
		if caret_line > 1 then return true end -- enable the caret to move up and down

		if self.history_pos <= 1 then return end

		self.history_pos = self.history_pos - 1
	elseif code == KEY_DOWN then
		if caret_line ~= lines then return true end

		if self.history_pos >= #self.history then
			self:SetValue("")
			self:SetCaretPos(0)
			self.history_pos = #self.history + 1
			return
		end

		self.history_pos = self.history_pos + 1
	end

	local text = self.history[self.history_pos]
	if not text then return end

	self:SetValue(text)
	self:SetCaretPos(utf8.len(text))
end

function Panel:OnTextChanged()
	self.history_pos = #self.history + 1

	local text = self:GetText()

	self.can_use_history = text == "" and true or false

	if self:GetUpdateOnType() then
		self:UpdateConvarValue()
		self:OnValueChange(text)
	end

	self:OnChange()
end

function Panel:OnScaleChange()
	self:InvalidateLayout()
	self:InvalidateLayout(true)
end

function Panel:Paint(w, h)
	self:RoundedBox("Background", self:GetRadius(), 0, 0, w, h, GetColor("text_entry_bg") or self:GetBackground())

	local text_entry_3 = GetColor("text_entry_3")

	if self:GetText() == "" then
		local old_text = self:GetText()
		self:SetText(self:GetPlaceholder())
		self:DrawTextEntryText(GetColor("text_entry_2"), text_entry_3, text_entry_3)
		self:SetText(old_text)
	else
		self:DrawTextEntryText(GetColor("text_entry"), text_entry_3, text_entry_3)
	end

	if not self:GetNoBar() then
		local bar_color = self:GetBarColor()

		self:RoundedBox("Bar1", 0, 0, h - 1, w, 1, GetColor("text_entry_bar_color"))

		local bar = math.Round(w * self.TextEntryReady)
		if bar > 0 then
			self:RoundedBox("Bar2", 0, (w / 2) - (bar / 2), h - 1, bar, 1, bar_color or text_entry_3)
		end
	end
end

-- https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/vgui2/vgui_controls/TextEntry.cpp#L969
function Panel:GetNumLines(wide)
	local num_lines = 1

	wide = wide or self:GetWide() - 2

	local vbar = self:GetChildren()[1]
	if vbar then
		wide = wide - vbar:GetWide()
	end

	local char_width
	local x = 3

	local word_start_index = 1
	local word_start_len
	local word_length = 0
	local has_word = false
	local just_started_new_line = true
	local word_started_on_new_line = true

	local start_char = 1

	surface.SetFont(self:GetFont())

	local i = start_char
	local text, n = utf8.force(self:GetText())
	local caret_line = 0
	local caret_pos = self:GetCaretPos()
	local caret_i = 1
	while i <= n do
		local ch_len = utf8.char_bytes(text:byte(i))
		local ch = text:sub(i, i + ch_len - 1)

		if ch ~= " " then
			if not has_word then
				word_start_index = i
				word_start_len = ch_len
				has_word = true
				word_started_on_new_line = just_started_new_line
				word_length = 0
			end
		else
			has_word = false
		end

		char_width = surface.GetTextSize(ch)
		just_started_new_line = false

		if (x + char_width) >= wide then
			x = 3

			just_started_new_line = true
			has_word = false

			if word_started_on_new_line then
				num_lines = num_lines + 1
			else
				num_lines = num_lines + 1
				i = (word_start_index + word_start_len) - ch_len
			end

			word_length = 0
		end

		x = x + char_width
		word_length = word_length + char_width

		if caret_i == caret_pos then
			caret_line = num_lines
		end

		i = i + ch_len
		caret_i = caret_i + 1
	end

	return num_lines, caret_line
end

function Panel:SetCheck(func, col)
	function self:OnValueChange(text)
		if func(text) == false then
			self.valid = false
			self:SetBarColor(GetColor("close_hover"))
			self:SetNoEnter(true)
		else
			self.valid = true
			self:SetBarColor(col)
			self:SetNoEnter(false)
		end
	end
	self:SetValue(self:GetText())
end

sui.register("TextEntry", Panel, "DTextEntry")