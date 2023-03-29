ix.npctemplates = {}
ix.npctemplates.templates = {}
ix.npctemplates.soundtemplates = {}
ix.npctemplates.animtemplates = {}
ix.npctemplates.animtemplatestranslation = {}

local SELLANDBUY 	= 1
local SELLONLY 	= 2
local BUYONLY 	= 3

ix.npctemplates.animtemplatestranslation[1] = "TestAnimations"
ix.npctemplates.animtemplatestranslation[2] = "Bartrader"
ix.npctemplates.animtemplatestranslation[3] = "Guard"
ix.npctemplates.animtemplatestranslation[4] = "sitchair"
ix.npctemplates.animtemplatestranslation[5] = "banditidle"
ix.npctemplates.animtemplatestranslation[6] = "monolithidle"
ix.npctemplates.animtemplatestranslation[7] = "idle_idle"





ix.npctemplates.templates["tutorialnpc"] = {
	name 		= "Diego",
	description = "Nie możesz określić jego wieku ponieważ, jego lico jest skrywane przez kominiarkę.",
	model 		= "models/bloocobalt/rebel_elite2.mdl",
	skin 		= 0,
	bubble 		= 0,
	scale 		= 0.4,
	dialogueid 	= "tutorialnpc",
	soundgroup 	= "TutorialNpc",
	idleanim 	= "idle",
	items = {
	-- ["uniqueid"] = { 1: Special set price, 2: Starting stock, 3: Mode [1:B/S, 2:S, 3:B], 4: Maximum stock, 5: Restock interval in hours, 6: Restock amount }
		["flashlight"] 	= { nil, 8, SELLANDBUY, 8, 0.10, 2 },
		["bandage"] 	= { nil, 10, SELLANDBUY, 10, 1, 2 },
		["eat_bread"] 	= { nil, 10, SELLANDBUY, 10, 1, 2 },
		["drink_water"] 	= { nil, 8, SELLANDBUY, 8, 1, 2 },
		
	},
}





ix.npctemplates.templates["computernpc"] = {
	name 		= "'Computer'",
	description = "The computer buzzes and beeps intermittently.",
	model 		= "models/props_lab/servers.mdl",
	skin 		= 0,
	bubble 		= 0,
	scale 		= 0.4,
	dialogueid 	= "computernpc",
	soundgroup 	= "computer_beep",
	idleanim 	= "idle",
	animgroup 	= 7,
	items = {
	},
}

-- No sounds emitted
ix.npctemplates.soundtemplates["nosound"] = {
	"stalkersound/inv_nosound.mp3",
}

ix.npctemplates.soundtemplates["GenericHello"] = {
	"npc/beta/stalker_talk_1.ogg",
	"npc/beta/stalker_talk_2.ogg",
	"npc/beta/stalker_talk_3.ogg",
	"npc/beta/stalker_talk_4.ogg",
}

ix.npctemplates.soundtemplates["GenericIdle"] = {
	"npc/hunter/idle_12.ogg",
	"npc/hunter/idle_19.ogg",
	"npc/hunter/idle_17.ogg",
	"npc/hunter/idle_16.ogg",
}

ix.npctemplates.soundtemplates["GenericGuard"] = {
	"npc/bandit/meet_comander_start_1.ogg",
	"npc/bandit/meet_comander_start_2.ogg",
	"npc/bandit/meet_comander_start_3.ogg",
}

ix.npctemplates.soundtemplates["TraderHello"] = {
	"npc/barman/bar_barman_hello_1.ogg",
	"npc/barman/bar_barman_hello_2.ogg",
	"npc/barman/bar_barman_hello_3.ogg",
	"npc/barman/bar_barman_hello_4.ogg",
	"npc/barman/bar_barman_hello_5.ogg"
}

ix.npctemplates.soundtemplates["TutorialNpc"] = {
	"npc/shram/idle_16.ogg",
	"npc/shram/search_13.ogg",
	"npc/shram/idle_18.ogg",
	"npc/shram/idle_20.ogg",
	"npc/shram/idle_4.ogg"
}

ix.npctemplates.soundtemplates["CookNpc"] = {
	"npc/lesnik/red_forester_meet_hello_0.ogg",
	"npc/lesnik/red_forester_meet_hello_1.ogg",
	"npc/lesnik/red_forester_meet_hello_2.ogg",
	"npc/lesnik/red_forester_greet_1.ogg",
    "npc/lesnik/red_forester_hello_bye_0.ogg",
    "npc/lesnik/red_forester_hello_bye_1.ogg",
}

ix.npctemplates.soundtemplates["ecologistnpc"] = {
	"npc/doctor/idle_12.ogg",
	"npc/doctor/idle_13.ogg",
	"npc/doctor/idle_14.ogg",
	"npc/doctor/idle_15.ogg",
	"npc/doctor/idle_16.ogg",
	"npc/doctor/idle_17.ogg",
	"npc/doctor/idle_18.ogg",
	"npc/doctor/idle_19.ogg",
}

ix.npctemplates.soundtemplates["bodyguardnpc"] = {
	"npc/garyk/bar_guard_prohodi_1.ogg",
	"npc/garyk/bar_guard_stop_1.ogg",
	"npc/garyk/bar_guard_stop_3.ogg",
}

ix.npctemplates.soundtemplates["computer_beep"] = {
	"ambient/levels/labs/equipment_beep_loop1.wav",
	"ambient/levels/canals/generator_ambience_loop1.wav",
}

ix.npctemplates.animtemplates["TestAnimations"] = {
	"bandit2_idle1",
	"bandit2_idle3",
}

ix.npctemplates.animtemplates["Bartrader"] = {
	"trader_idle2",
}

ix.npctemplates.animtemplates["ecotrader"] = {
	"bandit_idle2",
}

ix.npctemplates.animtemplates["Guard"] = {
	"hello_idle",
}

ix.npctemplates.animtemplates["sitchair"] = {
	"sidit2",
}

ix.npctemplates.animtemplates["banditidle"] = {
	"bandit2_idle1",
	"bandit2_idle3"
}

ix.npctemplates.animtemplates["monolithidle"] = {
	"trans_idle3",
}

ix.npctemplates.animtemplates["idle_idle"] = {
	"idle",
}
