--what their max health should be given their size/composition
LiteGibs.EntityHealth = {
	["npc_metropolice"] = 100,
	["npc_combine_s"] = 100,
	["npc_odessa"] = 100,
	["npc_citizen"] = 100,
	["npc_breen"] = 100,
	["npc_kleiner"] = 100,
	["npc_eli"] = 100,
	["npc_zombie"] = 50,
	["npc_poisonzombie"] = 50,
	["npc_fastzombie"] = 50,
	["nz_zombie_walker"] = 70,
	["nz_zombie_special_dog"] = 50,
	["nz_zombie_boss_panzer"] = 400,
	["nz_zombie_special_burning"] = 100,
	["npc_hunter"] = 150,
	["npc_antlionguard"] = 200
}

--damage ratios of HP required to gib
LiteGibs.EntityHitGroupHealth = {
	[HITGROUP_HEAD] = 0.3,
	[HITGROUP_CHEST] = 1.25,
	[HITGROUP_STOMACH] = 1.5,
	[HITGROUP_LEFTARM] = 0.5,
	[HITGROUP_RIGHTARM] = 0.5,
	[HITGROUP_LEFTLEG] = 0.7,
	[HITGROUP_RIGHTLEG] = 0.7,
	[HITGROUP_GENERIC] = math.huge,
	[HITGROUP_GEAR] = math.huge
}

LiteGibs.BoneHealthMultiplier = { --todo: hardcode individual bone health multipliers
}

LiteGibs.BoneHealthGlobalMultiplier = 2
LiteGibs.BoneHealthPhysicsMultiplier = 2