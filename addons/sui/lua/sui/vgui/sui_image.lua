local table = table
local file = file
local coroutine = coroutine
local surface = surface

local UnPredictedCurTime = UnPredictedCurTime
local pairs = pairs

local color_white = color_white

local sui = sui
local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local read_gif = include("sui/libs/gif_loader.lua")
local generate_png = include("sui/libs/png_encoder.lua")

local images_path = (NAME .. "/images/"):lower()
file.CreateDir(images_path)

local get_image_path = function(url)
	return images_path .. (url:gsub("%W", "_") .. ".png")
end

local Write = file.Write
local gif_to_png; do
	local internal_gif_to_png = function(file_path, chunk)
		local gif = read_gif(chunk)
		local frames = gif:get_frames()
		local w, h = gif.width, gif.height

		local path = file_path .. "/"
		file.CreateDir(path)

		for frame_id = 1, #frames do
			local frame = frames[frame_id]
			local data = frame.data
			local png = generate_png(w, h, data)
			Write(("%s%d_%d.png"):format(path, frame_id, frame.delay), png)
			coroutine.yield()
		end
	end

	local delay = 0.01
	local next_run = 0

	local coroutines = {}
	local callbacks = {}
	gif_to_png = function(file_path, data, callback)
		local co = coroutine.create(internal_gif_to_png)
		local i = table.insert(coroutines, co)
		callbacks[i] = callback
		coroutine.resume(co, file_path, data)
		next_run = UnPredictedCurTime()
	end

	hook.Add("Think", NAME .. "ProcessGIFs", function()
		local co = coroutines[1]
		if not co then return end
		if UnPredictedCurTime() < next_run then return end

		if coroutine.status(co) == "suspended" then
			coroutine.resume(co)
		else
			callbacks[1]()
			table.remove(coroutines, 1)
			table.remove(callbacks, 1)
		end

		next_run = UnPredictedCurTime() + delay
	end)

	hook.Add(NAME .. "ImagesCleared", "ClearCoroutines", function()
		table.Empty(coroutines)
		table.Empty(callbacks)
	end)
end

local download_image, is_downloading_image; do
	-- https://stackoverflow.com/questions/25959386/how-to-check-if-a-file-is-a-valid-image
	local valid_images = {
		["\xff\xd8\xff"] = "jpeg",
		["\x89PNG\r\n\x1a\n"] = "png",
		["GIF87a"] = "gif",
		["GIF89a"] = "gif",
	}

	local get_image_type = function(data)
		for k, v in pairs(valid_images) do
			if data:StartWith(k) then
				return v
			end
		end
		return false
	end

	local downloading_images = {}

	local process_callbacks = function(url)
		local callbacks = downloading_images[url] or {}
		downloading_images[url] = nil

		for _, func in ipairs(callbacks) do
			func()
		end
	end

	download_image = function(url, callback)
		if downloading_images[url] then
			table.insert(downloading_images[url], callback)
			return
		end

		downloading_images[url] = {callback}

		http.Fetch(url, function(data)
			local image_type = get_image_type(data)
			if not image_type then
				downloading_images[url] = nil
				return
			end

			local image_path = get_image_path(url)

			if image_type == "gif" then
				gif_to_png(image_path, data, function()
					process_callbacks(url)
				end)
			else
				file.Write(image_path, data)
				process_callbacks(url)
			end
		end, function(err)
			print("(SUI) Failed to download an image, error: " .. err)
			downloading_images[url] = nil
		end)
	end

	is_downloading_image = function(url)
		return downloading_images[url] ~= nil
	end

	hook.Add(NAME .. "ImagesCleared", "ClearDownloadingImages", function()
		table.Empty(downloading_images)
	end)
end

local images_panels = {}

local PANEL = {}

local err_mat = SUI.Material("error")

function PANEL:Init()
	self:SetMouseInputEnabled(false)

	self.minus = 0
	self.rotation = 0
	self.image = err_mat
	self.image_col = color_white

	table.insert(images_panels, self)
end

function PANEL:OnRemove()
	for k, v in ipairs(images_panels) do
		if v == self then
			table.remove(images_panels, k)
			return
		end
	end
end

function PANEL:SetMinus(minus)
	self.minus = minus
end

function PANEL:SetRotation(rotation)
	self.rotation = rotation
end

function PANEL:SetImageColor(col)
	self.image_col = col
end

local cached_files = {}
local get_files = function(image_path)
	local f = cached_files[image_path]
	if f then return f end

	cached_files[image_path] = file.Find(image_path .. "/*", "DATA")

	return cached_files[image_path]
end

function PANEL:SetImage(url)
	self.image = err_mat

	self.pos = nil
	self.delay = nil

	self.images = nil
	self.delays = nil
	self.url = url

	if url:sub(1, 4) ~= "http" then
		self.image = SUI.Material(url)
		return
	end

	local image_path = get_image_path(url)
	if not file.Exists(image_path, "DATA") or is_downloading_image(url) then
		download_image(url, function()
			if self:IsValid() then
				self:SetImage(url)
			end
		end)
		return
	end

	local is_gif = file.IsDir(image_path, "DATA")
	if is_gif then
		local images = {}
		local delays = {}

		local files = get_files(image_path)
		for i = 1, #files do
			local v = files[i]
			local id, delay = v:match("(.*)_(.*)%.png")
			id = tonumber(id)
			local img_path = "../data/" .. image_path .. "/" .. v
			images[id] = img_path
			delays[id] = delay
		end

		self.frame = 1
		self.delay = (UnPredictedCurTime() * 100) + delays[1]

		self.images = images
		self.delays = delays

		self.max_images = #files
	else
		self.image = SUI.Material("../data/" .. image_path)
	end
end

local SetMaterial = surface.SetMaterial
function PANEL:PaintGIF(w, h, images)
	local frame = self.frame

	-- SUI.Material() caches materials by default
	local mat = SUI.Material(images[frame], true)
	if not mat then
		if frame > 1 then
			mat = SUI.Material(images[frame - 1])
		else
			mat = err_mat
		end

		SetMaterial(mat)

		return
	end

	SetMaterial(mat)

	local curtime = UnPredictedCurTime() * 100
	if curtime < self.delay then return end
	frame = frame + 1
	if frame > self.max_images then
		frame = 1
	end

	self.frame = frame
	self.delay = curtime + self.delays[frame]
end

local PaintGIF = PANEL.PaintGIF
local SetDrawColor = surface.SetDrawColor
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated
function PANEL:Paint(w, h)
	SetDrawColor(self.image_col)

	local images = self.images
	if images then
		PaintGIF(self, w, h, images)
	else
		SetMaterial(self.image)
	end

	if self.Draw then
		self:Draw(w, h, true)
	else
		local minus = self.minus
		DrawTexturedRectRotated(w * 0.5, h * 0.5, w - minus, h - minus, self.rotation)
	end
end

sui.register("Image", PANEL, "PANEL")

function SUI.ClearImages()
	local files, dirs = file.Find(images_path .. "/*", "DATA")
	for _, f in ipairs(files) do
		file.Delete(images_path .. f)
	end

	for _, d in ipairs(dirs) do
		for _, f in ipairs(file.Find(images_path .. d .. "/*", "DATA")) do
			file.Delete(images_path .. (d .. "/" .. f))
		end
		file.Delete(images_path .. d)
	end

	table.Empty(SUI.materials)
	table.Empty(cached_files)

	hook.Call(NAME .. "ImagesCleared")

	for k, v in ipairs(images_panels) do
		if v.url then
			v:SetImage(v.url)
		end
	end
end