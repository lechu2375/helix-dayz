if SAM_LOADED then return end
-- not real promises, just really simple one

local isfunction = sam and sam.isfunction or isfunction

local null = {}

local Promise = {}

local PromiseMethods = {}
local Promise_meta = {__index = PromiseMethods}

function Promise.new()
	return setmetatable({
		value = null,
		null = null
	}, Promise_meta)
end

function Promise.IsPromise(v)
	return getmetatable(v) == Promise_meta
end

function PromiseMethods:resolve(v)
	if self.value ~= null then return end
	if self.done_callback then
		self.done_callback(v)
	else
		self.value = v
		self.callback = 0
	end
end

function PromiseMethods:reject(v)
	if self.value ~= null then return end
	if self.catch_callback then
		self.catch_callback(v)
	else
		self.value = v
		self.callback = 1
	end
end

function PromiseMethods:done(func)
	if isfunction(func) then
		if self.value ~= null and self.callback == 0 then
			func(self.value)
		else
			self.done_callback = func
		end
	end
	return self
end

function PromiseMethods:catch(func)
	if isfunction(func) then
		if self.value ~= null and self.callback == 1 then
			func(self.value)
		else
			self.catch_callback = func
		end
	end
	return self
end

return Promise