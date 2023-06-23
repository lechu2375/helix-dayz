--make sure your model paths are lowercase btw
LiteGibs.GoreModels = {
	["default"] = {
		["default"] = "models/player/skeleton.mdl",--this would be the bone name without valvebiped.bip01_
		["head1"] = "models/player/skeleton.mdl",
		["head"] = "models/player/skeleton.mdl"
	}
}
--handles default case
setmetatable(LiteGibs.GoreModels,{__index = function(t,k)
	local low = string.lower(k)
	if k ~= low and t[low] then
		return t[low]
	else
		return t["default"]
	end
end})
LiteGibs.WoundModels = {
	["default"] = {
		["default"] = { "models/Combine_Helicopter/helicopter_bomb01.mdl", ["scale"] = 0.2, ["clamp"] = 0.3 },
		["head1"] = {["clamp"] = 0.3},
		["neck1"] = {["clamp"] = 0.3},
		["head"] = {["clamp"] = 0.3},
		["neck"] = {["clamp"] = 0.3},
		["spine4"] = {["clamp"] = 0.4},
		["spine3"] = {["clamp"] = 0.4},
		["spine2"] = {["clamp"] = 0.4},
		["spine1"] = {["clamp"] = 0.4},
		["spine0"] = {["clamp"] = 0.4},
		["spine"] = {["clamp"] = 0.4},
		["pelvis"] = {["clamp"] = 0.4},
		["r_thigh"] = {["clamp"] = 0.35},
		["r_calf"] = {["clamp"] = 0.325},
		["r_foot"] = {["clamp"] = 0.3},
		["l_thigh"] = {["clamp"] = 0.35},
		["l_calf"] = {["clamp"] = 0.325},
		["l_foot"] = {["clamp"] = 0.3},
		["r_upperarm"] = {["clamp"] = 0.25},
		["r_forearm"] = {["clamp"] = 0.2},
		["r_hand"] = {["clamp"] = 0.15},
		["l_upperarm"] = {["clamp"] = 0.25},
		["l_forearm"] = {["clamp"] = 0.2},
		["l_hand"] = {["clamp"] = 0.15}
	}
}
--handles default case
setmetatable(LiteGibs.WoundModels,{__index = function(t,k)
	local low = string.lower(k)
	if k ~= low and t[low] then
		return t[low]
	else
		return t["default"]
	end
end})
--radius for the wound models themselves to offset into the mesh
LiteGibs.WoundModelRadius = {
	["models/combine_helicopter/helicopter_bomb01.mdl"] = 16
}
--radius multipliers for each model
LiteGibs.WoundRadius = {
	["default"] = {
		["valvebiped.bip01_spine4"] = 10,
		["valvebiped.bip01_spine3"] = 10,
		["valvebiped.bip01_spine2"] = 10,
		["valvebiped.bip01_spine1"] = 10,
		["valvebiped.bip01_spine0"] = 10,
		["valvebiped.bip01_spine"] = 10,
		["valvebiped.bip01_pelvis"] = 10,
		["valvebiped.bip01_head1"] = 5,
		["default"] = 4
	},
	["models/combine_super_soldier.mdl"] = {
		["valvebiped.bip01_spine4"] = 18,
		["valvebiped.bip01_spine3"] = 18,
		["valvebiped.bip01_spine2"] = 16,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/combine_soldier_prisonguard.mdl"] = {
		["valvebiped.bip01_spine4"] = 18,
		["valvebiped.bip01_spine3"] = 18,
		["valvebiped.bip01_spine2"] = 16,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/combine_soldier.mdl"] = {
		["valvebiped.bip01_spine4"] = 18,
		["valvebiped.bip01_spine3"] = 18,
		["valvebiped.bip01_spine2"] = 16,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/barney.mdl"] = {
		["valvebiped.bip01_spine4"] = 14,
		["valvebiped.bip01_spine3"] = 14,
		["valvebiped.bip01_spine2"] = 14,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/police.mdl"] = {
		["valvebiped.bip01_spine4"] = 14,
		["valvebiped.bip01_spine3"] = 14,
		["valvebiped.bip01_spine2"] = 14,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/player/combine_super_soldier.mdl"] = {
		["valvebiped.bip01_spine4"] = 18,
		["valvebiped.bip01_spine3"] = 18,
		["valvebiped.bip01_spine2"] = 16,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/player/combine_soldier_prisonguard.mdl"] = {
		["valvebiped.bip01_spine4"] = 18,
		["valvebiped.bip01_spine3"] = 18,
		["valvebiped.bip01_spine2"] = 16,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/player/combine_soldier.mdl"] = {
		["valvebiped.bip01_spine4"] = 18,
		["valvebiped.bip01_spine3"] = 18,
		["valvebiped.bip01_spine2"] = 16,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/player/barney.mdl"] = {
		["valvebiped.bip01_spine4"] = 14,
		["valvebiped.bip01_spine3"] = 14,
		["valvebiped.bip01_spine2"] = 14,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/player/police.mdl"] = {
		["valvebiped.bip01_spine4"] = 14,
		["valvebiped.bip01_spine3"] = 14,
		["valvebiped.bip01_spine2"] = 14,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	},
	["models/player/police_fem.mdl"] = {
		["valvebiped.bip01_spine4"] = 14,
		["valvebiped.bip01_spine3"] = 14,
		["valvebiped.bip01_spine2"] = 14,
		["valvebiped.bip01_spine1"] = 14,
		["valvebiped.bip01_spine0"] = 14,
		["valvebiped.bip01_spine"] = 14,
		["valvebiped.bip01_pelvis"] = 8,
		["valvebiped.bip01_head1"] = 6,
		["default"] = 4
	}
}
--handles default case
setmetatable(LiteGibs.WoundRadius,{__index = function(t,k)
	local low = string.lower(k)
	if k ~= low and t[low] then
		return t[low]
	else
		return t["default"]
	end
end})