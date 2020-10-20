SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 //SS_TICKER means this runs every tick
	init_order = INIT_ORDER_INPUT
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/macro_sets
	var/list/movement_keys

/datum/controller/subsystem/input/Initialize()
	setup_default_macro_sets()

	setup_default_movement_keys()

	initialized = TRUE

	refresh_client_macro_sets()

	return ..()

// This is for when macro sets are eventualy datumized
/datum/controller/subsystem/input/proc/setup_default_macro_sets()
	var/list/static/default_macro_sets

	if(default_macro_sets)
		macro_sets = default_macro_sets
		return

	default_macro_sets = list(
		"default" = list(
			"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
			"O" = "ooc",
			"Ctrl+O" = "looc",
			"T" = "say",
			"Ctrl+T" = "say_indicator",
			"Y" = "whisper",
			"M" = "me",
			"Ctrl+M" = "me_indicator",
			"5" = "subtle",
			"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"", // This makes it so backspace can remove default inputs
			"Any" = "\"KeyDown \[\[*\]\]\"",
			"Any+UP" = "\"KeyUp \[\[*\]\]\"",
			),
		"old_default" = list(
			"Tab" = "\".winset \\\"mainwindow.macro=old_hotkeys map.focus=true input.background-color=[COLOR_INPUT_DISABLED]\\\"\"",
			"Ctrl+T" = "say",
			"Ctrl+O" = "ooc",
			),
		"old_hotkeys" = list(
			"Tab" = "\".winset \\\"mainwindow.macro=old_default input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
			"O" = "ooc",
			"L" = "looc",
			"T" = "say",
			"Ctrl+T" = "say_indicator",
			"M" = "me",
			"Ctrl+M" = "me_indicator",
			"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"", // This makes it so backspace can remove default inputs
			"Any" = "\"KeyDown \[\[*\]\]\"",
			"Any+UP" = "\"KeyUp \[\[*\]\]\"",
			),
		)

	// Because i'm lazy and don't want to type all these out twice
	var/list/old_default = default_macro_sets["old_default"]

	var/list/static/oldmode_keys = list(
		"North", "East", "South", "West",
		"Northeast", "Southeast", "Northwest", "Southwest",
		"Insert", "Delete", "Ctrl", "Alt",
		"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
		)

	for(var/i in 1 to oldmode_keys.len)
		var/key = oldmode_keys[i]
		old_default[key] = "\"KeyDown [key]\""
		old_default["[key]+UP"] = "\"KeyUp [key]\""

	var/list/static/oldmode_ctrl_override_keys = list(
		"W" = "W", "A" = "A", "S" = "S", "D" = "D", // movement
		"1" = "1", "2" = "2", "3" = "3", "4" = "4", // intent
		"B" = "B", // resist
		"E" = "E", // quick equip
		"F" = "F", // intent left
		"G" = "G", // intent right
		"H" = "H", // stop pulling
		"Q" = "Q", // drop
		"R" = "R", // throw
		"X" = "X", // switch hands
		"Y" = "Y", // activate item
		"Z" = "Z", // activate item
		)

	for(var/i in 1 to oldmode_ctrl_override_keys.len)
		var/key = oldmode_ctrl_override_keys[i]
		var/override = oldmode_ctrl_override_keys[key]
		old_default["Ctrl+[key]"] = "\"KeyDown [override]\""
		old_default["Ctrl+[key]+UP"] = "\"KeyUp [override]\""

	macro_sets = default_macro_sets

// For initially setting up or resetting to default the movement keys
/datum/controller/subsystem/input/proc/setup_default_movement_keys()
	var/static/list/default_movement_keys = list(
		"W" = NORTH, "A" = WEST, "S" = SOUTH, "D" = EAST,				// WASD
		"North" = NORTH, "West" = WEST, "South" = SOUTH, "East" = EAST,	// Arrow keys & Numpad
		)

	movement_keys = default_movement_keys.Copy()
	for(var/key in classic_mode_keys)
		macroset_classic_input[key] = "\"KeyDown [key]\""
		macroset_classic_input["[key]+UP"] = "\"KeyUp [key]\""
	// LET'S PLAY THE BIND EVERY KEY GAME!
	// oh except for Backspace and Enter; if you want to use those you shouldn't have used oldmode!
	var/list/classic_ctrl_override_keys = list(
	"\[", "\]", "\\\\", ";", "'", ",", ".", "/", "-", "=", "`"
	)
	// i'm lazy let's play the list iteration game of numbers
	for(var/i in 0 to 9)
		classic_ctrl_override_keys += "[i]"
	// let's play the ascii game of A to Z (UPPERCASE)
	for(var/i in 65 to 90)
		classic_ctrl_override_keys += ascii2text(i)
	// let's play the game of clientside bind overrides!
	classic_ctrl_override_keys -= list("T", "O", "M", "L")
	macroset_classic_input["Ctrl+T"] = "say"
	macroset_classic_input["Ctrl+O"] = "ooc"
	macroset_classic_input["Ctrl+L"] = "looc"
	// let's play the list iteration game x2
	for(var/key in classic_ctrl_override_keys)
		// make sure to double double quote to ensure things are treated as a key combo instead of addition/semicolon logic.
		macroset_classic_input["\"Ctrl+[key]\""] = "\"KeyDown [istext(classic_ctrl_override_keys[key])? classic_ctrl_override_keys[key] : key]\""
		macroset_classic_input["\"Ctrl+[key]+UP\""] = "\"KeyUp [istext(classic_ctrl_override_keys[key])? classic_ctrl_override_keys[key] : key]\""
	// Misc
	macroset_classic_input["Tab"] = "\".winset \\\"mainwindow.macro=[SKIN_MACROSET_CLASSIC_HOTKEYS] map.focus=true input.background-color=[COLOR_INPUT_DISABLED]\\\"\""
	macroset_classic_input["Escape"] = "\".winset \\\"input.text=\\\"\\\"\\\"\""

	// FINALLY, WE CAN DO SOMETHING MORE NORMAL FOR THE SNOWFLAKE-BUT-LESS KEYSET.

	// HAHA - SIKE. Because of BYOND weirdness (tl;dr not specifically binding this way results in potentially duplicate chatboxes when
	//  conflicts occur with something like say indicator vs say), we're going to snowflake this anyways
	var/list/hard_binds = list(
		"O" = "ooc",
		"T" = "say",
		"L" = "looc",
		"M" = "me"
		)
	var/list/hard_bind_anti_collision = list()
	var/list/anti_collision_modifiers = list("Ctrl", "Alt", "Shift", "Ctrl+Alt", "Ctrl+Shift", "Alt+Shift", "Ctrl+Alt+Shift")
	for(var/key in hard_binds)
		for(var/modifier in anti_collision_modifiers)
			hard_bind_anti_collision["[modifier]+[key]"] = ".NONSENSICAL_VERB_THAT_DOES_NOTHING"

	macroset_classic_hotkey = list(
	"Any" = "\"KeyDown \[\[*\]\]\"",
	"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	"Tab" = "\".winset \\\"mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT] input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
	"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	)

	macroset_classic_hotkey |= hard_binds
	macroset_classic_hotkey |= hard_bind_anti_collision

	// And finally, the modern set.
	macroset_hotkey = list(
	"Any" = "\"KeyDown \[\[*\]\]\"",
	"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
	"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	)

	macroset_hotkey |= hard_binds
	macroset_hotkey |= hard_bind_anti_collision

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	var/list/clients = GLOB.clients
	for(var/i in 1 to clients.len)
		var/client/user = clients[i]
		user.set_macros()

/datum/controller/subsystem/input/fire()
	var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to length(clients))
		var/client/C = clients[i]
		C.keyLoop()
