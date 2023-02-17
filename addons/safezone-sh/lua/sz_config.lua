/**
* General configuration
**/

hook.Add("InitPostEntity", "SH_SZ.InitPostEntity", function()
	CAMI.RegisterPrivilege({
		Name = "Safezone - edit",
		MinAccess = "superadmin"
	})
end)

-- Use Steam Workshop for the content instead of FastDL?
SH_SZ.UseWorkshop = true

-- Controls for the Editor camera.
-- See a full list here: http://wiki.garrysmod.com/page/Enums/KEY
SH_SZ.CameraControls = {
	forward = KEY_W,
	left = KEY_A,
	back = KEY_S,
	right = KEY_D,
}

/**
* HUD configuration
**/

-- Where to display the Safe Zone Indicator on the screen.
-- Possible options: topleft, top, topright, left, center, right, bottomleft, bottom, bottomright
SH_SZ.HUDAlign = "top"

-- Offset of the Indicator relative to its base position.
-- Use this if you want to move the indicator by a few pixels.
SH_SZ.HUDOffset = {
	x = 0,
	y = 0,
	scale = false, -- Set to false/true to enable offset scaling depending on screen resolution.
}

/**
* Advanced configuration
* Edit at your own risk!
**/

SH_SZ.WindowSize = {w = 800, h = 300}

SH_SZ.DefaultOptions = {
	name = "Safezone",
	namecolor = "52,152,219",
	hud = true,
	noatk = true,
	nonpc = true,
	noprop = true,
	ptime = 5,
	entermsg = "",
	leavemsg = "",
}

SH_SZ.MaximumSize = 2048

SH_SZ.DataDirName = "sh_safezones"

SH_SZ.ZoneHitboxesDeveloper = false

SH_SZ.TeleportIdealDistance = 512

/**
* Theme configuration
**/

-- Font to use for normal text throughout the interface.
SH_SZ.Font = "Circular Std Medium"

-- Font to use for bold text throughout the interface.
SH_SZ.FontBold = "Circular Std Bold"

-- Color sheet. Only modify if you know what you're doing
SH_SZ.Style = {
	header = Color(52, 152, 219, 255),
	bg = Color(52, 73, 94, 255),
	inbg = Color(44, 62, 80, 255),

	close_hover = Color(231, 76, 60, 255),
	hover = Color(255, 255, 255, 10, 255),
	hover2 = Color(255, 255, 255, 5, 255),

	text = Color(255, 255, 255, 255),
	text_down = Color(0, 0, 0),
	textentry = Color(236, 240, 241),
	menu = Color(127, 140, 141),

	success = Color(46, 204, 113),
	failure = Color(231, 76, 60),
}

/**
* Language configuration
**/

-- Various strings used throughout the chatbox. Change them to your language here.
-- %s and %d are special strings replaced with relevant info, keep them in the string!

SH_SZ.Language = {
	safezone = "Bezpieczna strefa",
	safezone_type = "Typ bezpiecznej strefy",
	cube = "Sześcian",
	sphere = "Kula",

	select_a_safezone = "Wybierz bezpieczną strefę",

	options = "Ustawienia",
	name = "Nazwa",
	name_color = "Kolor",
	enable_hud_indicator = "Włącz wskaźnik na hudzie",
	delete_non_admin_props = "Usuń propy ludzi bez uprawnień administratora",
	prevent_attacking_with_weapons = "Zakaz atakowania broniami",
	automatically_remove_npcs = "Automatycznie usuń NPC",
	time_until_protection_enables = "Czas po, którym włącza się ochrona",
	enter_message = "Wiadomość na wejściu",
	leave_message = "Wiadomość na wyjściu",

	will_be_protected_in_x = "Będziesz chroniony za %s sekund",
	safe_from_damage = "Jesteś bezpieczny od obrażeń.",

	place_point_x = "Postaw punkt. %d za pomocą myszki.",
	size = "Rozmiar",
	finalize_placement = "Wybierz lokalizację i wciśnij \"Potwierdź\"",

	add = "Dodaj",
	edit = "Edytuj",
	fill_vertically = "Zapełnij pionowo",
	reset = "Resetuj",
	confirm = "Potwierdź",
	teleport_there = "Teleportuj się tu",
	save = "Zapisz",
	delete = "Usuń",
	cancel = "Anuluj",
	move_camera = "Poruszaj kamerą",
	rotate_camera = "Obróć kamerę",

	an_error_has_occured = "Wystąpił błąd, zrestartuj serwer lub spróbuj ponownie.",
	not_allowed = "Nie możesz tego zrobić!",
	safe_zone_created = "Pomyślnie stworzono bezpieczną strefę!",
	safe_zone_edited = "Edytowano strefę!",
	safe_zone_deleted = "Usunięto strefę!",
}