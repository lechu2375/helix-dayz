local string = string
local table = table
local bit = bit

local char = string.char
local byte = string.byte

local insert = table.insert
local concat = table.concat

local bor = bit.bor
local bxor = bit.bxor
local band = bit.band
local bnot = bit.bnot
local lshift = bit.lshift
local rshift = bit.rshift

local ceil = math.ceil

local SIGNATURE = char(137, 80, 78, 71, 13, 10, 26, 10)

local crc_table = {}; do
	local n = 0
	while n < 256 do
		local c = n
		local k = 0
		while k < 8 do
			if band(c, 1) ~= 0 then
				c = bxor(0xedb88320, rshift(c, 1))
			else
				c = rshift(c, 1)
			end
			k = k + 1
		end
		crc_table[n + 1] = c
		n = n + 1
	end
end

local crc = function(buf)
	local c = 0xffffffff
	for i = 1, #buf do
		c = bxor(crc_table[band(bxor(c, byte(buf, i)), 0xff) + 1], rshift(c, 8))
	end
	return bxor(c, 0xffffffff)
end

local dword_as_string = function(dword)
	return char(
		rshift(band(dword, 0xff000000), 24),
		rshift(band(dword, 0x00ff0000), 16),
		rshift(band(dword, 0x0000ff00), 8),
		band(dword, 0x000000ff)
	)
end

local create_chunk = function(type, data, length)
	local CRC = crc(type .. data)
	return concat({
		dword_as_string(length or #data),
		type,
		data,
		dword_as_string(CRC)
	}, "", 1, 4)
end

local create_IHDR; do
	local ARGS = (
		-- bit depth
		char(8) ..
		-- color type: 6=truecolor with alpha
		char(6) ..
		-- compression method: 0=deflate, only allowed value
		char(0) ..
		-- filtering: 0=adaptive, only allowed value
		char(0) ..
		-- interlacing: 0=none
		char(0)
	)

	create_IHDR = function(w, h)
		return create_chunk("IHDR", concat({
			dword_as_string(w),
			dword_as_string(h),
			ARGS
		}, "", 1, 3), 13)
	end
end

local deflate_pack; do
	local BASE = 6552
	local NMAX = 5552
	local adler32 = function(str)
		local s1 = 1
		local s2 = 0
		local n = NMAX

		for i = 1, #str do
			s1 = s1 + byte(str, i)
			s2 = s2 + s1

			n = n - 1
			if n == 0 then
				s1 = s1 % BASE
				s2 = s2 % BASE
				n = NMAX
			end
		end

		s1 = s1 % BASE
		s2 = s2 % BASE

		return bor(lshift(s2, 16), s1)
	end

	local splitChunks = function(chunk, chunkSize)
		local len = ceil(#chunk / chunkSize)
		local ret = {}
		for i = 1, len do
			ret[i - 1] = chunk:sub(((i - 1) * chunkSize) + 1, chunkSize)
		end
		return ret
	end

	deflate_pack = function(str)
		local ret = {"\x78\x9c"}

		local chunks = splitChunks(str, 0xFFFF)
		local len = #chunks

		local i = 0
		while i < (len + 1) do
			local chunk = chunks[i]
			local chunk_n = #chunk

			insert(ret, i < len and "\x00" or "\x01")
			insert(ret, char(band(chunk_n, 0xff), band(rshift(chunk_n, 8), 0xff)))
			insert(ret, char(band(bnot(chunk_n), 0xff), band(rshift(bnot(chunk_n), 8), 0xff)))
			insert(ret, chunk)
			i = i + 1
		end

		local t = adler32(str)
		t = char(
			band(rshift(t, 24), 0xff),
			band(rshift(t, 16), 0xff),
			band(rshift(t, 8), 0xff),
			band(t, 0xff)
		)

		insert(ret, t)

		return concat(ret)
	end
end

local create_IDAT; do
	local slice = function(a, s, e)
		local ret, j = {}, 0
		for i = s, e - 1 do
			ret[j] = char(band(a[i] or 0, 0xFF))
			j = j + 1
		end
		return ret
	end

	local array_split_chunks = function(w, h, array, chunkSize)
		local ret = {}
		local i = 0
		local len = ceil((w * h * 4 + 4) / chunkSize)
		while i < len do
			ret[i] = slice(array, i * chunkSize, (i + 1) * chunkSize)
			i = i + 1
		end
		return ret
	end

	create_IDAT = function(w, h, chunk)
		local scanlines = array_split_chunks(w, h, chunk, w * 4)

		local image_bytes = {}
		for i = 0, #scanlines do
			local scanline = scanlines[i]
			insert(image_bytes, char(band(0, 0xFF)))
			insert(image_bytes, concat(scanline, "", 0, #scanline))
		end
		image_bytes = deflate_pack(concat(image_bytes))

		return create_chunk("IDAT", image_bytes)
	end
end

local IEND = create_chunk("IEND", "", 0)
local to_return = {SIGNATURE, nil, nil, IEND}
local generate_png = function(w, h, chunk)
	local IHDR = create_IHDR(w, h)
	local IDAT = create_IDAT(w, h, chunk)

	to_return[2] = IHDR
	to_return[3] = IDAT

	return concat(to_return, "", 1, 4)
end

return generate_png