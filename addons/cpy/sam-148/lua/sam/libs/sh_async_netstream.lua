if SAM_LOADED then return end

local netstream = sam.netstream
netstream.async = {}

if SERVER then
	local IsValid = IsValid
	function netstream.async.Hook(name, fn, check)
		netstream.Hook(name, function(ply, i, ...)
			if not sam.isnumber(i) then return end
			local res = function(...)
				if IsValid(ply) then
					netstream.Start(ply, name, i, ...)
				end
			end
			fn(res, ply, ...)
		end, check)
	end
else
	local count = 0
	local receivers = {}

	local hook_fn = function(i, ...)
		local receiver = receivers[i]
		if receiver[2] then
			receiver[2]()
		end
		receiver[1]:resolve(...)
		receivers[i] = nil
	end

	function netstream.async.Start(name, func_to_call, ...)
		local promise = sam.Promise.new()
		count = count + 1
		receivers[count] = {promise, func_to_call}
		netstream.Hook(name, hook_fn)
		if func_to_call then
			func_to_call()
		end
		netstream.Start(name, count, ...)
		return promise
	end
end