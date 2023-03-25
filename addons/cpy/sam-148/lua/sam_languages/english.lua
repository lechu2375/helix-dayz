return {
	You = "You",
	Yourself = "Yourself",
	Themself = "Themself",
	Everyone = "Everyone",

	cant_use_as_console = "You need to be a player to use {S Red} command!",
	no_permission = "You don't have permission to use '{S Red}'!",

	cant_target_multi_players = "You can't target multiple players using this command!",
	invalid_id = "Invalid id ({S Red})!",
	cant_target_player = "You can't target {S Red}!",
	cant_target_self = "You can't target your self using {S Red} command!",
	player_id_not_found = "Player with id {S Red} is not found!",
	found_multi_players = "Found multiple players: {T}!",
	cant_find_target = "Can't find a player to target ({S Red})!",

	invalid = "Invalid {S} ({S_2 Red})",
	default_reason = "none",

	menu_help = "Open admin mod menu.",

	-- Chat Commands
	pm_to = "PM to {T}: {V}",
	pm_from = "PM from {A}: {V}",
	pm_help = "Send a personal message (PM) to a player.",

	to_admins = "{A} to admins: {V}",
	asay_help = "Send a message to admins.",

	mute = "{A} muted {T} for {V}. ({V_2})",
	mute_help = "Stop player(s) from sending messages in chat.",

	unmute = "{A} unmuted {T}.",
	unmute_help = "Unmute player(s).",

	you_muted = "You are muted.",

	gag = "{A} gagged {T} for {V}. ({V_2})",
	gag_help = "Stop player(s) from speaking.",

	ungag = "{A} ungagged {T}.",
	ungag_help = "Ungag player(s).",

	-- Fun Commands
	slap = "{A} slapped {T}.",
	slap_damage = "{A} slapped {T} with {V} damage.",
	slap_help = "Slap asses.",

	slay = "{A} slayed {T}.",
	slay_help = "Slay player(s).",

	set_hp = "{A} set the hp for {T} to {V}.",
	hp_help = "Set health for player(s).",

	set_armor = "{A} set the armor for {T} to {V}.",
	armor_help = "Set armor for player(s).",

	ignite = "{A} ignited {T} for {V}.",
	ignite_help = "Ignite player(s).",

	unignite = "{A} extinguished {T}.",
	unignite_help = "Extinguish player(s).",

	god = "{A} enabled god mode for {T}.",
	god_help = "Enable god mode for player(s).",

	ungod = "{A} disabled god mode for {T}.",
	ungod_help = "Disable god mode for player(s).",

	freeze = "{A} froze {T}.",
	freeze_help = "Freeze player(s).",

	unfreeze = "{A} unfroze {T}.",
	unfreeze_help = "Unfreeze player(s).",

	cloak = "{A} cloaked {T}.",
	cloak_help = "Cloak player(s).",

	uncloak = "{A} uncloaked {T}.",
	uncloak_help = "Uncloak player(s).",

	jail = "{A} jailed {T} for {V}. ({V_2})",
	jail_help = "Jail player(s).",

	unjail = "{A} unjailed {T}.",
	unjail_help = "Unjail player(s).",

	strip = "{A} stripped weapons from {T}.",
	strip_help = "Strip weapons from player(s).",

	respawn = "{A} respawned {T}.",
	respawn_help = "Respawn player(s).",

	setmodel = "{A} set the model for {T} to {V}.",
	setmodel_help = "Change player(s)'s model.",

	giveammo = "{A} gave {T} {V} ammo.",
	giveammo_help = "Give player(s) ammo.",

	scale = "{A} set model scale for {T} to {V}.",
	scale_help = "Scale player(s).",

	freezeprops = "{A} froze all props.",
	freezeprops_help = "Freezes all props on the map.",

	-- Teleport Commands
	dead = "You are dead!",
	leave_car = "Leave the vehicle first!",

	bring = "{A} teleported {T}.",
	bring_help = "Bring a player.",

	goto = "{A} teleported to {T}.",
	goto_help = "Goto a player.",

	no_location = "No previous location to return {T} to.",
	returned = "{A} returned {T}.",
	return_help = "Return a player to where he was.",

	-- User Management Commands
	setrank = "{A} set the rank for {T} to {V} for {V_2}.",
	setrank_help = "Set a player's rank.",
	setrankid_help = "Set a player's rank by his steamid/steamid64.",

	addrank = "{A} created a new rank {V}.",
	addrank_help = "Create a new rank.",

	removerank = "{A} removed rank {V}.",
	removerank_help = "Remove a rank.",

	super_admin_access = "superadmin has access to everything!",

	giveaccess = "{A} granted access {V} to {T}.",
	givepermission_help = "Give permission to rank.",

	takeaccess = "{A} taken access {V} from {T}.",
	takepermission_help = "Take permission from rank.",

	renamerank = "{A} renamed rank {T} to {V}.",
	renamerank_help = "Rename rank.",

	changeinherit = "{A} changed the rank to inherit from for {T} to {V}.",
	changeinherit_help = "Change the rank to inherit from.",

	rank_immunity = "{A} changed rank {T}'s immunity to {V}.",
	changerankimmunity_help = "Change rank immunity.",

	rank_ban_limit = "{A} changed rank {T}'s ban limit to {V}.",
	changerankbanlimit_help = "Change rank ban limit.",

	changeranklimit = "{A} changed {V} limit for {T} to {V_2}.",
	changeranklimit_help = "Change rank limits.",

	-- Utility Commands
	map_change = "{A} changing the map to {V} in 10 seconds.",
	map_change2 = "{A} changing the map to {V} with gamemode {V_2} in 10 seconds.",
	map_help = "Change current map and gamemode.",

	map_restart = "{A} restarting the map in 10 seconds.",
	map_restart_help = "Restart current map.",

	mapreset = "{A} reset the map.",
	mapreset_help = "Reset the map.",

	kick = "{A} kicked {T} Reason: {V}.",
	kick_help = "Kick a player.",

	ban = "{A} banned {T} for {V} ({V_2}).",
	ban_help = "Ban a player.",

	banid = "{A} banned ${T} for {V} ({V_2}).",
	banid_help = "Ban a player using his steamid.",

	-- ban message when admin name doesn't exists
	ban_message = [[


		You are banned by: {S}

		Reason: {S_2}

		You will be unbanned in: {S_3}]],

	-- ban message when admin name exists
	ban_message_2 = [[


		You are banned by: {S} ({S_2})

		Reason: {S_3}

		You will be unbanned in: {S_4}]],

	unban = "{A} unbanned {T}.",
	unban_help = "Unban a player using his steamid.",

	noclip = "{A} has toggled noclip for {T}.",
	noclip_help = "Toggle noclip on player(s).",

	cleardecals = "{A} cleared ragdolls and decals for all players.",
	cleardecals_help = "Clear ragdolls and decals for all players.",

	stopsound = "{A} stopped all sounds.",
	stopsound_help = "Stop all sounds for all players.",

	not_in_vehicle = "You are not in a vehicle!",
	not_in_vehicle2 = "{S Blue} is not in a vehicle!",
	exit_vehicle = "{A} forced {T} to get out from a vehicle.",
	exit_vehicle_help = "Force a player out of a vehicle.",

	time_your = "Your total time is {V}.",
	time_player = "{T} total time is {V}.",
	time_help = "Check a player's time.",

	admin_help = "Activate admin mode.",
	unadmin_help = "Deactivate admin mode.",

	buddha = "{A} enabled buddha mode for {T}.",
	buddha_help = "Make player(s) godmoded when their health is 1.",

	unbuddha = "{A} disabled buddha mode for {T}.",
	unbuddha_help = "Disable buddha mode for player(s).",

	give = "{A} gave {T} {V}.",
	give_help = "Give player(s) weapon/entity",

	-- DarkRP Commands
	arrest = "{A} arrested {T} forever.",
	arrest2 = "{A} arrested {T} for {V} seconds.",
	arrest_help = "Arrest player(s).",

	unarrest = "{A} unarrested {T}.",
	unarrest_help = "Unarrest player(s).",

	setmoney = "{A} set money for {T} to {V}.",
	setmoney_help = "Set money for a player.",

	addmoney = "{A} added {V} for {T}.",
	addmoney_help = "Add money for a player.",

	door_invalid = "invalid door to sell.",
	door_no_owner = "no one owns this door.",

	selldoor = "{A} sold a door/vehicle for {T}.",
	selldoor_help = "Unown the door/vehicle you are looking at.",

	sellall = "{A} sold every door/vehicle for {T}.",
	sellall_help = "Sell every door/vehicle owned for a player.",

	s_jail_pos = "{A} set a new jail position.",
	setjailpos_help = "Resets all jail positions and sets a new one at your location.",

	a_jail_pos = "{A} added a new jail position.",
	addjailpos_help = "Adds a jail position at your current location.",

	setjob = "{A} set {T}'s job to {V}.",
	setjob_help = "Change a player's job.",

	shipment = "{A} spawned {V} shipment.",
	shipment_help = "Spawn a shipment.",

	forcename = "{A} set the name for {T} to {V}.",
	forcename_taken = "Name already taken. ({V})",
	forcename_help = "Force name for a player.",

	report_claimed = "{A} claimed a report submitted by {T}.",
	report_closed = "{A} closed a report submitted by {T}.",
	report_aclosed = "Your report is closed. (Time expired)",

	rank_expired = "{V} rank for {T} expired.",

	-- TTT Commands
	setslays = "{A} set amount of auto-slays for {T} to {V}.",
	setslays_help = "Set amount of rounds to auto-slay a player for.",

	setslays_slayed = "{T} got auto-slayed, slays left: {V}.",

	removeslays = "{A} removed auto-slays for {T}.",
	removeslays_help = "Remove auto-slays for a player."
}