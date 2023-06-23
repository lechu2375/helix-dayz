BLOOD_COLOR_SYNTH = BLOOD_COLOR_SYNTH or BLOOD_COLOR_ANTLION_WORKER + 2

LiteGibs.WeaponBlood = LiteGibs.WeaponBlood or {}

LiteGibs.WeaponBlood.Decals = {
	[BLOOD_COLOR_RED] = {
		["litegibs/decals/blood1"] = false,
		["litegibs/decals/blood2"] = false,
		["litegibs/decals/blood3"] = false,
		["litegibs/decals/blood4"] = false,
		["litegibs/decals/blood5"] = false,
		["litegibs/decals/blood6"] = false,
		["litegibs/decals/blood7"] = false,
		["litegibs/decals/blood8"] = false
	},
	[BLOOD_COLOR_GREEN] = {
		["litegibs/decals/g/blood1"] = false,
		["litegibs/decals/g/blood2"] = false,
		["litegibs/decals/g/blood3"] = false,
		["litegibs/decals/g/blood4"] = false,
		["litegibs/decals/g/blood5"] = false,
		["litegibs/decals/g/blood6"] = false,
		["litegibs/decals/g/blood7"] = false,
		["litegibs/decals/g/blood8"] = false
	},
	[BLOOD_COLOR_YELLOW] = {
		["litegibs/decals/g/blood1"] = false,
		["litegibs/decals/g/blood2"] = false,
		["litegibs/decals/g/blood3"] = false,
		["litegibs/decals/g/blood4"] = false,
		["litegibs/decals/g/blood5"] = false,
		["litegibs/decals/g/blood6"] = false,
		["litegibs/decals/g/blood7"] = false,
		["litegibs/decals/g/blood8"] = false
	},
	[BLOOD_COLOR_ANTLION] = {
		["litegibs/decals/g/blood1"] = false,
		["litegibs/decals/g/blood2"] = false,
		["litegibs/decals/g/blood3"] = false,
		["litegibs/decals/g/blood4"] = false,
		["litegibs/decals/g/blood5"] = false,
		["litegibs/decals/g/blood6"] = false,
		["litegibs/decals/g/blood7"] = false,
		["litegibs/decals/g/blood8"] = false
	},
	[BLOOD_COLOR_ZOMBIE] = {
		["litegibs/decals/blood1"] = false,
		["litegibs/decals/blood2"] = false,
		["litegibs/decals/blood3"] = false,
		["litegibs/decals/blood4"] = false,
		["litegibs/decals/blood5"] = false,
		["litegibs/decals/blood6"] = false,
		["litegibs/decals/blood7"] = false,
		["litegibs/decals/blood8"] = false,
		["litegibs/decals/g/blood1"] = false,
		["litegibs/decals/g/blood2"] = false,
		["litegibs/decals/g/blood3"] = false,
		["litegibs/decals/g/blood4"] = false,
		["litegibs/decals/g/blood5"] = false,
		["litegibs/decals/g/blood6"] = false,
		["litegibs/decals/g/blood7"] = false,
		["litegibs/decals/g/blood8"] = false
	},
	[BLOOD_COLOR_SYNTH] = {
		["litegibs/decals/w/blood1"] = false,
		["litegibs/decals/w/blood2"] = false,
		["litegibs/decals/w/blood3"] = false,
		["litegibs/decals/w/blood4"] = false,
		["litegibs/decals/w/blood5"] = false,
		["litegibs/decals/w/blood6"] = false,
		["litegibs/decals/w/blood7"] = false,
		["litegibs/decals/w/blood8"] = false
	},
	[DONT_BLEED] = {
		["litegibs/decals/c/blood1"] = false,
		["litegibs/decals/c/blood2"] = false,
		["litegibs/decals/c/blood3"] = false,
		["litegibs/decals/c/blood4"] = false,
		["litegibs/decals/c/blood5"] = false,
		["litegibs/decals/c/blood6"] = false,
		["litegibs/decals/c/blood7"] = false,
		["litegibs/decals/c/blood8"] = false
	}
}

LiteGibs.HUDBlood = LiteGibs.HUDBlood or {}
LiteGibs.HUDBlood.TYPE_GENERIC = 1
LiteGibs.HUDBlood.TYPE_SLASH = 2
LiteGibs.HUDBlood.TYPE_CLUB = 3
LiteGibs.HUDBlood.TYPE_CLAW = 4

LiteGibs.HUDBlood.DamageTypes = LiteGibs.HUDBlood.DamageTypes or {
	["npc_headcrab"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_headcrab_fast"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_headcrab_black"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_fastzombie"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_fastzombie_torso"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_zombie"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_poisonzombie"] = LiteGibs.HUDBlood.TYPE_CLAW,
	["npc_zombie_torso"] = LiteGibs.HUDBlood.TYPE_CLAW
}

LiteGibs.HUDBlood.Colors = LiteGibs.HUDBlood.Colors or {
	[BLOOD_COLOR_RED] = {
		["r"] = 165,
		["g"] = 0,
		["b"] = 0
	},
	[BLOOD_COLOR_YELLOW] = {
		["r"] = 225,
		["g"] = 255,
		["b"] = 45
	},
	[BLOOD_COLOR_GREEN] = {
		["r"] = 125,
		["g"] = 164,
		["b"] = 25
	},
	[BLOOD_COLOR_ANTLION] = {
		["r"] = 225,
		["g"] = 255,
		["b"] = 45
	},
	[BLOOD_COLOR_ANTLION_WORKER] = {
		["r"] = 225,
		["g"] = 255,
		["b"] = 45
	},
	[BLOOD_COLOR_ZOMBIE] = {
		["r_min"] = 45,
		["r_max"] = 255,
		["g_min"] = 45,
		["g_max"] = 165,
		["b"] = 45
	},
	[BLOOD_COLOR_SYNTH] = {
		["r"] = 255,
		["g"] = 225,
		["b"] = 225
	}
}

LiteGibs.HUDBlood.Sprites = {
	[LiteGibs.HUDBlood.TYPE_GENERIC] = {
		path = "litegibs/hud/shot",
		random = true,
		random_min = 1,
		random_max = 9,
		scale_min = 0.8,
		scale_max = 1.2,
		angle_min = -180,
		angle_max = 180
	},
	[LiteGibs.HUDBlood.TYPE_CLUB] = {
		path = "litegibs/hud/shot",
		random = true,
		random_min = 1,
		random_max = 9,
		scale_min = 0.8,
		scale_max = 1.2,
		angle_min = -180,
		angle_max = 180
	},
	[LiteGibs.HUDBlood.TYPE_SLASH] = {
		path = "litegibs/hud/dmg_slash",
		random = true,
		random_min = 1,
		random_max = 6,
		scale_min = 0.8,
		scale_max = 1.2,
		angle_min = 60,
		angle_max = 120
	},
	[LiteGibs.HUDBlood.TYPE_CLAW] = {
		path = "litegibs/hud/dmg_claw",
		random = true,
		random_min = 1,
		random_max = 6,
		scale_min = 0.8,
		scale_max = 1.2,
		angle_min = 20,
		angle_max = 80
	}
}