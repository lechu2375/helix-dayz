LiteGibs = LiteGibs or {}
LiteGibs.Sounds = LiteGibs.Sounds or {}
LiteGibs.Sounds.TotalGib = "LG.TotalGib"
LiteGibs.Sounds.Tear = "LG.Tear"
LiteGibs.Sounds.BloodDrop = "LG.BloodDrop"
LiteGibs.Sounds.BloodBurst = "LG.BloodBurst"
LiteGibs.Sounds.GibSplat = "LG.GibSplat"

LiteGibs.BoneGibSounds = {
	["default"] = LiteGibs.Sounds.Tear,
	["valvebiped.bip01_pelvis"] = LiteGibs.Sounds.TotalGib,
	["valvebiped.bip01_spine"] = LiteGibs.Sounds.TotalGib,
	["valvebiped.bip01_spine1"] = LiteGibs.Sounds.TotalGib,
	["valvebiped.bip01_spine2"] = LiteGibs.Sounds.TotalGib,
	["valvebiped.bip01_spine3"] = LiteGibs.Sounds.TotalGib,
	["valvebiped.bip01_spine4"] = LiteGibs.Sounds.TotalGib
}

local function propogatePreSuf(prefix, min, max, suffix)
	local tbl = {}

	for i = min, max do
		tbl[#tbl + 1] = prefix .. tostring(i) .. suffix
	end

	return tbl
end

CHAN_LG = (CHAN_BODY and CHAN_BODY or 4) + 16

sound.Add({
	name = "LG.TotalGib",
	channel = CHAN_AUTO,
	volume = 1,
	level = 90,
	pitch = {95, 110},
	sound = "LG/kf2_totalgib.wav"
})

sound.Add({
	name = "LG.Tear",
	channel = CHAN_AUTO,
	volume = 1,
	level = 80,
	pitch = {95, 105},
	sound = propogatePreSuf("LG/kf2_tear", 1, 8, ".wav")
})

sound.Add({
	name = "LG.BloodDrop",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = {95, 110},
	sound = propogatePreSuf("LG/blooddrop", 1, 3, ".wav")
})

sound.Add({
	name = "LG.BloodBurst",
	channel = CHAN_AUTO,
	volume = 1,
	level = 70,
	pitch = {95, 110},
	sound = propogatePreSuf("LG/blood_burst", 1, 12, ".wav")
})

sound.Add({
	name = "LG.GibSplat",
	channel = CHAN_AUTO,
	volume = 1,
	level = 70,
	pitch = {90, 110},
	sound = propogatePreSuf("LG/flesh_squishy_impact_hard", 1, 4, ".wav")
})