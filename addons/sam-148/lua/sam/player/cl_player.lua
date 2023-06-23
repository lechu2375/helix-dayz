if SAM_LOADED then return end

local sam = sam
local netstream = sam.netstream

netstream.Hook("PlaySound", function(sound)
	surface.PlaySound(sound)
end)