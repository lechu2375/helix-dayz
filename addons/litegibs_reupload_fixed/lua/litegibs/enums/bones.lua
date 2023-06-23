LiteGibs.Bones = LiteGibs.Bones or {}
--stop us from using physbones for these ent, instead using closest bones
LiteGibs.PhysBoneBlacklistClass = {
	["npc_seagull"] = true,
	["npc_pigeon"] = true,
	["npc_crow"] = true,
	["npc_antlion"] = true,
	["npc_antlionguard"] = true
}
--blacklist
LiteGibs.Bones.Blacklist = {
	["valvebiped.bip01_forward"] = true,
	["valvebiped.forward"] = true,
}
--used for getclosestbone
LiteGibs.Bones.HitGroupSearch = {
	[HITGROUP_HEAD] = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Head", "ValveBiped.head"},
	[HITGROUP_CHEST] = {"ValveBiped.Bip01_Spine2","ValveBiped.Bip01_Spine4", "ValveBiped.spine2", "ValveBiped.spine3"},
	[HITGROUP_STOMACH] = {"ValveBiped.Bip01_Spine2","ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine", "ValveBiped.Bip01_Spine0", "ValveBiped.hips", "ValveBiped.spine1"},
	[HITGROUP_LEFTARM] = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Upperarm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Lowerarm", "ValveBiped.Bip01_L_Hand", "ValveBiped.arm1_R", "ValveBiped.arm1_L"},
	[HITGROUP_RIGHTARM] = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Upperarm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Lowerarm", "ValveBiped.Bip01_R_Hand", "ValveBiped.arm2_R", "ValveBiped.arm2_L"},
	[HITGROUP_LEFTLEG] = {"ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"},
	[HITGROUP_RIGHTLEG] = {"ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0"}
}
--what we attempt to gib
LiteGibs.Bones.HitGroupGibs = {
	[HITGROUP_HEAD] = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Head", "ValveBiped.head"},
	[HITGROUP_CHEST] = {"ValveBiped.Bip01_Spine2", "ValveBiped.spine2"},
	[HITGROUP_STOMACH] = {"ValveBiped.Bip01_Spine", "ValveBiped.Bip01_Spine0", "ValveBiped.spine1"},
	[HITGROUP_LEFTARM] = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Upperarm", "ValveBiped.arm1_L"},
	[HITGROUP_RIGHTARM] = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Upperarm", "ValveBiped.arm1_R"},
	[HITGROUP_LEFTLEG] = {"ValveBiped.Bip01_L_Thigh", "ValveBiped.leg_bone1_L"},
	[HITGROUP_RIGHTLEG] = {"ValveBiped.Bip01_R_Thigh", "ValveBiped.leg_bone1_R"}
}
--string.find substrings used to pick a hitgroup
LiteGibs.BoneHitGroups = {
	["head"] = HITGROUP_HEAD,
	["neck"] = HITGROUP_HEAD,
	["spine"] = HITGROUP_CHEST,
	["pelvis"] = HITGROUP_STOMACH,
	["hips"] = HITGROUP_STOMACH,
	["clavical"] = HITGROUP_LEFTARM,
	["arm"] = HITGROUP_LEFTARM,
	["hand"] = HITGROUP_LEFTARM,
	["hip"] = HITGROUP_LEFTLEG,
	["thigh"] = HITGROUP_LEFTLEG,
	["calf"] = HITGROUP_LEFTLEG,
	["foot"] = HITGROUP_LEFTLEG,
	["leg"] = HITGROUP_LEFTLEG,
	["femur"] = HITGROUP_LEFTLEG
}
--what we attempt to gib
LiteGibs.Bones.BloodStream = {
	["valvebiped.bip01_pelvis"] = true,
	["valvebiped.bip01_spine"] = true,
	["valvebiped.bip01_spine1"] = true,
	["valvebiped.bip01_spine2"] = true,
	["valvebiped.bip01_spine3"] = true,
	["valvebiped.bip01_spine4"] = true,
	["valvebiped.bip01_neck1"] = true,
	["valvebiped.bip01_head1"] = true,
	["valvebiped.head"] = true,
	["valvebiped.spine4"] = true,
	["valvebiped.spine3"] = true,
	["valvebiped.spine2"] = true,
	["valvebiped.spine1"] = true,
	["valvebiped.spine0"] = true,
	["valvebiped.spine"] = true
}
--related, kinda, used as "attachment" param for lg_blood_pool
LiteGibs.Bones.NoTarget = 2