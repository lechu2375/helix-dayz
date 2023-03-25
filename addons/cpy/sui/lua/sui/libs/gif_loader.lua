local byte = string.byte
local sub = string.sub
local lshift = bit.lshift
local rshift = bit.rshift
local bor = bit.bor
local band = bit.band

local GIFDecoder = {}
local GIFDecoderMethods = {}
local GIFDecoder_meta = {__index = GIFDecoderMethods}

function GIFDecoder.new(buf)
	local buf_n = #buf
	local this = setmetatable({
		p = 1,
		buf = buf
	}, GIFDecoder_meta)

	local version = this:read(6)
	assert(version == "GIF89a" or version == "GIF87a", "wrong file format")

	this.width = this:word()
	this.height = this:word()

	local pf0 = this:byte()
	local global_palette_flag = rshift(pf0, 7)
	local num_global_colors_pow2 = band(pf0, 0x7)
	local num_global_colors = lshift(1, num_global_colors_pow2 + 1)
	this:skip(2)

	local global_palette_offset = nil
	local global_palette_size = nil

	if global_palette_flag > 0 then
		global_palette_offset = this.p
		this.global_palette_offset = global_palette_offset
		global_palette_size = num_global_colors
		this:skip(num_global_colors * 3)
	end

	local no_eof = true

	local frames = {}

	local delay = 0
	local transparent_index = nil
	local disposal = 1

	while no_eof and this.p <= buf_n do
		local b = this:byte()
		if b == 0x3b then
			no_eof = false
		elseif b == 0x2c then
			local x, y, w, h = this:word(), this:word(), this:word(), this:word()
			local pf2 = this:byte()
			local local_palette_flag = rshift(pf2, 7)
			local interlace_flag = band(rshift(pf2, 6), 1)
			local num_local_colors_pow2 = band(pf2, 0x7)
			local num_local_colors = lshift(1, num_local_colors_pow2 + 1)
			local palette_offset = global_palette_offset
			local palette_size = global_palette_size
			local has_local_palette = false
			if local_palette_flag ~= 0 then
				has_local_palette = true
				palette_offset = this.p
				palette_size = num_local_colors
				this:skip(num_local_colors * 3)
			end

			local data_offset = this.p

			this:skip(1)
			this:skip_eob()

			table.insert(frames, {
				x = x,
				y = y,
				width = w,
				height = h,
				has_local_palette = has_local_palette,
				palette_offset = palette_offset,
				palette_size = palette_size,
				data_offset = data_offset,
				data_length = this.p - data_offset,
				transparent_index = transparent_index,
				interlaced = interlace_flag > 0,
				delay = delay,
				disposal = disposal
			})
		elseif b == 0x21 then
			local b2 = this:byte()
			if b2 == 0xf9 then
				local len, flags = this:bytes(2)
				delay = this:word()
				local transparent, terminator = this:bytes(2)

				assert(len == 4 and terminator == 0, "Invalid graphics extension block.")

				if flags % 2 == 1 then
					transparent_index = transparent
				else
					transparent_index = nil
				end

				disposal = math.floor(flags / 4) % 8
			elseif b2 == 0xff then
				this:read(this:byte())
				this:skip_eob()
			else
				this:skip_eob()
			end
		end
	end

	this.frames = frames

	return this
end

function GIFDecoderMethods:skip(offset)
	self.p = self.p + offset
end

-- skip to end of block
function GIFDecoderMethods:skip_eob()
	repeat
		local size = self:byte()
		self:skip(size)
	until size == 0
end

function GIFDecoderMethods:byte()
	local b = byte(self.buf, self.p)
	self:skip(1)
	return b
end

function GIFDecoderMethods:bytes(len)
	local _p = self.p
	self:skip(len)
	return byte(self.buf, _p, len + _p - 1)
end

function GIFDecoderMethods:read(len)
	local _p = self.p
	self:skip(len)
	return sub(self.buf, _p, len + _p - 1)
end

function GIFDecoderMethods:word()
	return bor(self:byte(), lshift(self:byte(), 8))
end

local GifReaderLZWOutputIndexStream = function(this, output, output_length)
	local min_code_size = this:byte()
	local clear_code = lshift(1, min_code_size)
	local eoi_code = clear_code + 1
	local next_code = eoi_code + 1
	local cur_code_size = min_code_size + 1

	local code_mask = lshift(1, cur_code_size) - 1
	local cur_shift = 0
	local cur = 0
	local op = 0

	local subblock_size = this:byte()

	local code_table = {}

	local prev_code = nil

	while true do
		while cur_shift < 16 do
			if subblock_size == 0 then break end

			cur = bor(cur, lshift(this:byte(), cur_shift))
			cur_shift = cur_shift + 8

			if subblock_size == 1 then
				subblock_size = this:byte()
			else
				subblock_size = subblock_size - 1
			end
		end

		if cur_shift < cur_code_size then break end

		local code = band(cur, code_mask)
		cur = rshift(cur, cur_code_size)
		cur_shift = cur_shift - cur_code_size

		if code == clear_code then
			next_code = eoi_code + 1
			cur_code_size = min_code_size + 1
			code_mask = lshift(1, cur_code_size) - 1

			prev_code = null
			continue
		elseif code == eoi_code then
			break
		end

		local chase_code = code < next_code and code or prev_code
		local chase_length = 0
		local chase = chase_code
		while chase > clear_code do
			chase = rshift(code_table[chase], 8)
			chase_length = chase_length + 1
		end

		local k = chase
		local op_end = op + chase_length + (chase_code ~= code and 1 or 0)
		if op_end > output_length then
			Error("Warning, gif stream longer than expected.")
			return
		end

		output[op] = k; op = op + 1
		op = op + chase_length

		local b = op

		if chase_code ~= code then
			output[op] = k; op = op + 1
		end
		chase = chase_code

		while chase_length > 0 do
			chase_length = chase_length - 1
			chase = code_table[chase]
			b = b - 1
			output[b] = band(chase, 0xff)

			chase = rshift(chase, 8)
		end

		if prev_code ~= nil and next_code < 4096 then
			code_table[next_code] = bor(lshift(prev_code, 8), k)
			next_code = next_code + 1

			if next_code >= code_mask + 1 and cur_code_size < 12 then
				cur_code_size = cur_code_size + 1
				code_mask = bor(lshift(code_mask, 1), 1)
			end
		end

		prev_code = code
	end

	if op ~= output_length then
		Error("Warning, gif stream shorter than expected.")
	end

	return output
end

function GIFDecoderMethods:decode_and_blit_frame_RGBA(frame_num, pixels)
	local frame = self.frames[frame_num]
	local num_pixels = frame.width * frame.height
	local index_stream = {}

	self.p = frame.data_offset
	GifReaderLZWOutputIndexStream(self, index_stream, num_pixels)
	local palette_offset = frame.palette_offset

	local trans = frame.transparent_index
	if trans == nil then
		trans = 256
	end

	local width = self.width
	local framewidth = frame.width
	local framestride = width - framewidth
	local xleft = framewidth

	local opbeg = (frame.y * width + frame.x) * 4

	local opend = ((frame.y + frame.height) * width + frame.x) * 4
	local op = opbeg
	local scanstride = framestride * 4

	if frame.interlaced == true then
		scanstride = scanstride + (width * 4 * 7)
	end

	local interlaceskip = 8

	local i = 0
	local buf = self.buf
	while i < num_pixels do
		local index = index_stream[i]

		if xleft == 0 then
			op = op + scanstride
			xleft = framewidth

			if op >= opend then
				scanstride =
					framestride * 4 + width * 4 * (interlaceskip - 1)

				op =
					opbeg +
					(framewidth + framestride) * lshift(interlaceskip, 1)
				interlaceskip = rshift(interlaceskip, 1)
			end
		end

		if index ~= trans then
			index = palette_offset + index * 3
			pixels[op + 0] = byte(buf, index)
			pixels[op + 1] = byte(buf, index + 1)
			pixels[op + 2] = byte(buf, index + 2)
			pixels[op + 3] = 255
		end

		op = op + 4

		xleft = xleft - 1
		i = i + 1
	end
end

function GIFDecoderMethods:clear_frame(frame_num, pixels)
	local frame = self.frames[frame_num]

	self.p = frame.data_offset

	local width = self.width
	local framewidth = frame.width
	local framestride = width - framewidth
	local xleft = framewidth

	local opbeg = (frame.y * width + frame.x) * 4

	local opend = ((frame.y + frame.height) * width + frame.x) * 4
	local op = opbeg
	local scanstride = framestride * 4

	if frame.interlaced == true then
		scanstride = scanstride + (width * 4 * 7)
	end

	local interlaceskip = 8

	local i = 0
	local num_pixels = frame.width * frame.height
	while i < num_pixels do
		if xleft == 0 then
			op = op + scanstride
			xleft = framewidth

			if op >= opend then
				scanstride =
					framestride * 4 + width * 4 * (interlaceskip - 1)

				op =
					opbeg +
					(framewidth + framestride) * lshift(interlaceskip, 1)
				interlaceskip = rshift(interlaceskip, 1)
			end
		end

		pixels[op + 0] = 0
		pixels[op + 1] = 0
		pixels[op + 2] = 0
		pixels[op + 3] = 0
		op = op + 4

		xleft = xleft - 1
		i = i + 1
	end
end

function GIFDecoderMethods:get_frames()
	local num_pixels = self.width * self.height * 4 + 4
	local frames = {}
	local numFrames = #self.frames
	local last_frame
	local restore_from
	for i = 1, numFrames do
		local frame = self.frames[i]

		local data = {}

		if last_frame then
			local _data = last_frame.data
			for k = 0, num_pixels do
				data[k] = _data[k]
			end
		end

		if i > 1 then
			local last_disposal = last_frame.disposal
			if last_disposal == 3 then
				if restore_from then
					for k = 0, num_pixels do
						data[k] = restore_from[k]
					end
				else
					self:clear_frame(i - 1, data)
				end
			end

			if last_disposal == 2 then
				self:clear_frame(i - 1, data)
			end
		end

		self:decode_and_blit_frame_RGBA(i, data)

		local delay = frame.delay
		if delay < 2 then
			delay = 10
		end

		local disposal = frame.disposal
		last_frame = {
			data = data,
			delay = delay,
			disposal = disposal
		}
		frames[i] = last_frame

		if disposal ~= 3 then
			restore_from = data
		end
	end

	return frames
end

return GIFDecoder.new