/*
 * Paper
 * also scraps of paper
 *
 * lipstick wiping is in code/game/objects/items/weapons/cosmetics.dm!
 */
<<<<<<< HEAD

=======
#define MAX_PAPER_LENGTH 5000
#define MAX_PAPER_STAMPS 30		// Too low?
#define MAX_PAPER_STAMPS_OVERLAYS 4
#define MODE_READING 0
#define MODE_WRITING 1
#define MODE_STAMPING 2


/**
 * Paper is now using markdown (like in github pull notes) for ALL rendering
 * so we do loose a bit of functionality but we gain in easy of use of
 * paper and getting rid of that crashing bug
 */
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
/obj/item/paper
	name = "paper"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	// inhand_icon_state = "paper"
	// worn_icon_state = "paper"
	// custom_fire_overlay = "paper_onfire_overlay"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	pressure_resistance = 0
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = HEAD
	resistance_flags = FLAMMABLE
	max_integrity = 50
	dog_fashion = /datum/dog_fashion/head
<<<<<<< HEAD

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields = 0	//Amount of user created fields
	var/list/stamped
	var/rigged = 0
	var/spam_flag = 0
=======
	// drop_sound = 'sound/items/handling/paper_drop.ogg'
	// pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	grind_results = list(/datum/reagent/cellulose = 3)
	color = "white"
	/// What's actually written on the paper.
	var/info = ""
	var/show_written_words = TRUE

	/// The (text for the) stamps on the paper.
	var/list/stamps			/// Positioning for the stamp in tgui
	var/list/stamped		/// Overlay info

>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
	var/contact_poison // Reagent ID to transfer on contact
	var/contact_poison_volume = 0
	var/datum/oracle_ui/ui = null
	var/force_stars = FALSE // If we should force the text to get obfuscated with asterisks

<<<<<<< HEAD
=======
	/// When the sheet can be "filled out"
	/// This is an associated list
	var/list/form_fields = list()
	var/field_counter = 1

/obj/item/paper/Destroy()
	stamps = null
	stamped = null
	form_fields = null
	stamped = null
	. = ..()

/**
 * This proc copies this sheet of paper to a new
 * sheet,  Makes it nice and easy for carbon and
 * the copyer machine
 */
/obj/item/paper/proc/copy()
	var/obj/item/paper/N = new(arglist(args))
	N.info = info
	N.color = color
	N.update_icon_state()
	N.stamps = stamps
	N.stamped = stamped.Copy()
	N.form_fields = form_fields.Copy()
	N.field_counter = field_counter
	copy_overlays(N, TRUE)
	return N

/**
 * This proc sets the text of the paper and updates the
 * icons.  You can modify the pen_color after if need
 * be.
 */
/obj/item/paper/proc/setText(text)
	info = text
	form_fields = null
	field_counter = 0
	update_icon_state()
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

/obj/item/paper/pickup(user)
	if(contact_poison && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(!istype(G) || G.transfer_prints)
			H.reagents.add_reagent(contact_poison,contact_poison_volume)
			contact_poison = null
	ui.check_view_all()
	..()

/obj/item/paper/dropped(mob/user)
	ui.check_view(user)
	return ..()


/obj/item/paper/Initialize()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	ui = new /datum/oracle_ui(src, 420, 600, get_asset_datum(/datum/asset/spritesheet/simple/paper))
	ui.can_resize = FALSE
	update_icon()
	updateinfolinks()

/obj/item/paper/oui_getcontent(mob/target)
	if(!target.is_literate() || force_stars)
		force_stars = FALSE
		return "<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>[name]</TITLE></HEAD><BODY>[stars(info)]<HR>[stamps]</BODY></HTML>"
	else if(istype(target.get_active_held_item(), /obj/item/pen) | istype(target.get_active_held_item(), /obj/item/toy/crayon))
		return "<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>[name]</TITLE></HEAD><BODY>[info_links]<HR>[stamps]</BODY><div align='right'style='position:fixed;bottom:0;font-style:bold;'><A href='?src=[REF(src)];help=1'>\[?\]</A></div></HTML>"
	else
		return "<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>[name]</TITLE></HEAD><BODY>[info]<HR>[stamps]</BODY></HTML>"

/obj/item/paper/oui_canview(mob/target)
	if(check_rights_for(target.client, R_FUN)) //Allows admins to view faxes
		return TRUE
	if(isAI(target))
		force_stars = TRUE
		return TRUE
	if(iscyborg(target))
		return get_dist(src, target) < 2
	return ..()

/obj/item/paper/update_icon_state()
	if(resistance_flags & ON_FIRE)
		icon_state = "paper_onfire"
		return
	if(info)
		icon_state = "paper_words"
		return
	icon_state = "paper"


/obj/item/paper/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to fold it.</span>"
	if(oui_canview(user))
		ui.render(user)
	else
		. += "<span class='warning'>You're too far away to read it!</span>"

/obj/item/paper/proc/show_content(mob/user)
	user.examinate(src)

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	if(!usr.can_read(src) || usr.incapacitated(TRUE, TRUE) || (isobserver(usr) && !IsAdminGhost(usr)))
		return
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(HAS_TRAIT(H, TRAIT_CLUMSY) && prob(25))
			to_chat(H, "<span class='warning'>You cut yourself on the paper! Ahhhh! Ahhhhh!</span>")
			H.damageoverlaytemp = 9001
			H.update_damage_hud()
			return
	var/n_name = stripped_input(usr, "What would you like to label the paper?", "Paper Labelling", null, MAX_NAME_LEN)
	if((loc == usr && usr.stat == CONSCIOUS))
		name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(usr)
	ui.render_all()

/obj/item/paper/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] scratches a grid on [user.p_their()] wrist with the paper! It looks like [user.p_theyre()] trying to commit sudoku...</span>")
	return (BRUTELOSS)

<<<<<<< HEAD
/obj/item/paper/proc/reset_spamflag()
	spam_flag = FALSE

/obj/item/paper/attack_self(mob/user)
	show_content(user)
	if(rigged && (SSevents.holidays && SSevents.holidays[APRIL_FOOLS]))
		if(!spam_flag)
			spam_flag = TRUE
			playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
			addtimer(CALLBACK(src, .proc/reset_spamflag), 20)

/obj/item/paper/attack_ai(mob/living/silicon/ai/user)
	show_content(user)

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid < 15)	//hey whoever decided a while(1) was a good idea here, i hate you
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return	//No field found with matching id

		if(links)
			laststart = istart + length(info_links[istart])
		else
			laststart = istart + length(info[istart])
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)
=======
/obj/item/paper/proc/clearpaper()
	info = ""
	stamps = null
	LAZYCLEARLIST(stamped)
	cut_overlays()
	update_icon_state()

/obj/item/paper/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !isobserver(user))
		. += "<span class='warning'>You're too far away to read it!</span>"
		return
	if(user.can_read(src))
		ui_interact(user)
		return
	. += "<span class='warning'>You cannot read it!</span>"

/obj/item/paper/ui_status(mob/user,/datum/ui_state/state)
		// Are we on fire?  Hard ot read if so
	if(resistance_flags & ON_FIRE)
		return UI_CLOSE
	if(!in_range(user,src))
		return UI_CLOSE
	if(user.incapacitated(TRUE, TRUE) || (isobserver(user) && !IsAdminGhost(user)))
		return UI_UPDATE
	// Even harder to read if your blind...braile? humm
	// .. or if you cannot read
	if(!user.can_read(src))
		return UI_CLOSE
	if(in_contents_of(/obj/machinery/door/airlock))
		return UI_INTERACTIVE
	return ..()



/obj/item/paper/can_interact(mob/user)
	if(in_contents_of(/obj/machinery/door/airlock))
		return TRUE
	return ..()

>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()

<<<<<<< HEAD

/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i in 1 to min(fields, 15))
		addtofield(i, "<font face=\"[PEN_FONT]\"><A href='?src=[REF(src)];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[PEN_FONT]\"><A href='?src=[REF(src)];write=end'>write</A></font>"
	ui.render_all()


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	LAZYCLEARLIST(stamped)
	cut_overlays()
	updateinfolinks()
	update_icon()


/obj/item/paper/proc/parsepencode(t, obj/item/pen/P, mob/user, iscrayon = 0)
	if(length(t) < 1)		//No input means nothing needs to be parsed
		return

	t = parsemarkdown(t, user, iscrayon)

	if(!iscrayon)
		t = "<font face=\"[P.font]\" color=[P.colour]>[t]</font>"
	else
		var/obj/item/toy/crayon/C = P
		t = "<font face=\"[CRAYON_FONT]\" color=[C.paint_color]><b>[t]</b></font>"

	// Count the fields
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++

	return t

/obj/item/paper/proc/reload_fields() // Useful if you made the paper programicly and want to include fields. Also runs updateinfolinks() for you.
	fields = 0
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(info, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++
	updateinfolinks()


/obj/item/paper/proc/openhelp(mob/user)
	user << browse({"<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><TITLE>Paper Help</TITLE></HEAD>
	<BODY>
		You can use backslash (\\) to escape special characters.<br>
		<br>
		<b><center>Crayon&Pen commands</center></b><br>
		<br>
		# text : Defines a header.<br>
		|text| : Centers the text.<br>
		**text** : Makes the text <b>bold</b>.<br>
		*text* : Makes the text <i>italic</i>.<br>
		^text^ : Increases the <font size = \"4\">size</font> of the text.<br>
		%s : Inserts a signature of your name in a foolproof way.<br>
		%f : Inserts an invisible field which lets you start type from there. Useful for forms.<br>
		<br>
		<b><center>Pen exclusive commands</center></b><br>
		((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>
		* item : An unordered list item.<br>
		&nbsp;&nbsp;* item: An unordered list child item.<br>
		--- : Adds a horizontal rule.
	</BODY></HTML>"}, "window=paper_help")


/obj/item/paper/Topic(href, href_list)
	..()
	var/literate = usr.is_literate()
	if(!usr.canUseTopic(src, BE_CLOSE, literate))
		return
=======
/obj/item/paper/attackby(obj/item/P, mob/living/user, params)
	if(burn_paper_product_attackby_check(P, user))
		SStgui.close_uis(src)
		return

	if(istype(P, /obj/item/pen) || istype(P, /obj/item/toy/crayon))
		if(length(info) >= MAX_PAPER_LENGTH) // Sheet must have less than 1000 charaters
			to_chat(user, "<span class='warning'>This sheet of paper is full!</span>")
			return
		ui_interact(user)
		return
	else if(istype(P, /obj/item/stamp))
		to_chat(user, "<span class='notice'>You ready your stamp over the paper! </span>")
		ui_interact(user)
		return /// Normaly you just stamp, you don't need to read the thing
	else
		// cut paper?  the sky is the limit!
		ui_interact(user)	// The other ui will be created with just read mode outside of this
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

	if(href_list["help"])
		openhelp(usr)
		return
	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  stripped_multiline_input("Enter what you want to write:", "Write", no_trim=TRUE)
		if(!t || !usr.canUseTopic(src, BE_CLOSE, literate))
			return
		var/obj/item/i = usr.get_active_held_item()	//Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		var/iscrayon = 0
		if(!istype(i, /obj/item/pen))
			if(!istype(i, /obj/item/toy/crayon))
				return
			iscrayon = 1

		if(!in_range(src, usr) && loc != usr && !istype(loc, /obj/item/clipboard) && loc.loc != usr && usr.get_active_held_item() != i)	//Some check to see if he's allowed to write
			return

		t = parsepencode(t, i, usr, iscrayon) // Encode everything from pencode to html

		if(t != null)	//No input from the user means nothing needs to be added
			if(id!="end")
				addtofield(text2num(id), t) // He wants to edit a field, let him.
			else
				info += t // Oh, he wants to edit to the end of the file, let him.
				updateinfolinks()
			show_content(usr)
			update_icon()

<<<<<<< HEAD

/obj/item/paper/attackby(obj/item/P, mob/living/carbon/human/user, params)
	..()

	if(resistance_flags & ON_FIRE)
		return

	if(is_blind(user))
		return

	if(istype(P, /obj/item/pen) || istype(P, /obj/item/toy/crayon))
		if(user.is_literate())
			show_content(user)
			return
		else
			to_chat(user, "<span class='notice'>You don't know how to read or write.</span>")
			return

	else if(istype(P, /obj/item/stamp))

		if(!in_range(src, user))
			return

		var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/simple/paper)
		if (isnull(stamps))
			stamps = sheet.css_tag()
		stamps += sheet.icon_tag(P.icon_state)
		var/mutable_appearance/stampoverlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_[P.icon_state]")
		stampoverlay.pixel_x = rand(-2, 2)
		stampoverlay.pixel_y = rand(-3, 2)

		LAZYADD(stamped, P.icon_state)
		add_overlay(stampoverlay)

		to_chat(user, "<span class='notice'>You stamp the paper with your rubber stamp.</span>")
		ui.render_all()

	if(P.get_temperature())
		if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(10))
			user.visible_message("<span class='warning'>[user] accidentally ignites [user.p_them()]self!</span>", \
								"<span class='userdanger'>You miss the paper and accidentally light yourself on fire!</span>")
			user.dropItemToGround(P)
			user.adjust_fire_stacks(1)
			user.IgniteMob()
			return

		if(!(in_range(user, src))) //to prevent issues as a result of telepathically lighting a paper
			return
=======
/obj/item/paper/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/simple/paper),
	)

/obj/item/paper/ui_interact(mob/user, datum/tgui/ui)
	// Update the UI
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PaperSheet", name)
		ui.open()


/obj/item/paper/ui_static_data(mob/user)
	. = list()
	.["text"] = info
	.["max_length"] = MAX_PAPER_LENGTH
	.["paper_color"] = !color || color == "white" ? "#FFFFFF" : color	// color might not be set
	.["paper_state"] = icon_state	/// TODO: show the sheet will bloodied or crinkling?
	.["stamps"] = stamps



/obj/item/paper/ui_data(mob/user)
	var/list/data = list()
	var/obj/O = user.get_active_held_item()
	if(istype(O, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/PEN = O
		data["pen_font"] = CRAYON_FONT
		data["pen_color"] = PEN.paint_color
		data["edit_mode"] = MODE_WRITING
		data["is_crayon"] = TRUE
		data["stamp_class"] = "FAKE"
		data["stamp_icon_state"] = "FAKE"
	else if(istype(O, /obj/item/pen))
		var/obj/item/pen/PEN = O
		data["pen_font"] = PEN.font
		data["pen_color"] = PEN.colour
		data["edit_mode"] = MODE_WRITING
		data["is_crayon"] = FALSE
		data["stamp_class"] = "FAKE"
		data["stamp_icon_state"] = "FAKE"
	else if(istype(O, /obj/item/stamp))
		var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/simple/paper)
		data["stamp_icon_state"] = O.icon_state
		data["stamp_class"] = sheet.icon_class_name(O.icon_state)
		data["edit_mode"] = MODE_STAMPING
		data["pen_font"] = "FAKE"
		data["pen_color"] = "FAKE"
		data["is_crayon"] = FALSE
	else
		data["edit_mode"] = MODE_READING
		data["pen_font"] = "FAKE"
		data["pen_color"] = "FAKE"
		data["is_crayon"] = FALSE
		data["stamp_icon_state"] = "FAKE"
		data["stamp_class"] = "FAKE"
	data["field_counter"] = field_counter
	data["form_fields"] = form_fields
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

		user.dropItemToGround(src)
		user.visible_message("<span class='danger'>[user] lights [src] ablaze with [P]!</span>", "<span class='danger'>You light [src] on fire!</span>")
		fire_act()

<<<<<<< HEAD

	add_fingerprint(user)

/obj/item/paper/fire_act(exposed_temperature, exposed_volume)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		icon_state = "paper_onfire"
		info = "[stars(info)]"


/obj/item/paper/extinguish()
	..()
	update_icon()
=======
/obj/item/paper/ui_act(action, params,datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("stamp")
			var/stamp_x = text2num(params["x"])
			var/stamp_y = text2num(params["y"])
			var/stamp_r = text2num(params["r"])	// rotation in degrees
			var/stamp_icon_state = params["stamp_icon_state"]
			var/stamp_class = params["stamp_class"]
			if (isnull(stamps))
				stamps = list()
			if(stamps.len < MAX_PAPER_STAMPS)
				// I hate byond when dealing with freaking lists
				stamps[++stamps.len] = list(stamp_class, stamp_x, stamp_y, stamp_r)	/// WHHHHY

				/// This does the overlay stuff
				if (isnull(stamped))
					stamped = list()
				if(stamped.len < MAX_PAPER_STAMPS_OVERLAYS)
					var/mutable_appearance/stampoverlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_[stamp_icon_state]")
					stampoverlay.pixel_x = rand(-2, 2)
					stampoverlay.pixel_y = rand(-3, 2)
					add_overlay(stampoverlay)
					LAZYADD(stamped, stamp_icon_state)

				update_static_data(usr,ui)
				ui.user.visible_message("<span class='notice'>[ui.user] stamps [src] with [stamp_class]!</span>", "<span class='notice'>You stamp [src] with [stamp_class]!</span>")
			else
				to_chat(usr, pick("You try to stamp but you miss!", "There is no where else you can stamp!"))
			. = TRUE

		if("save")
			var/in_paper = params["text"]
			var/paper_len = length(in_paper)
			field_counter = params["field_counter"] ? text2num(params["field_counter"]) : field_counter

			if(paper_len > MAX_PAPER_LENGTH)
				// Side note, the only way we should get here is if
				// the javascript was modified, somehow, outside of
				// byond.  but right now we are logging it as
				// the generated html might get beyond this limit
				log_paper("[key_name(ui.user)] writing to paper [name], and overwrote it by [paper_len-MAX_PAPER_LENGTH]")
			if(paper_len == 0)
				to_chat(ui.user, pick("Writing block strikes again!", "You forgot to write anthing!"))
			else
				log_paper("[key_name(ui.user)] writing to paper [name]")
				if(info != in_paper)
					to_chat(ui.user, "You have added to your paper masterpiece!");
					info = in_paper
					update_static_data(usr,ui)


			update_icon()
			. = TRUE
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

/*
 * Construction paper
 */

/obj/item/paper/construction

/obj/item/paper/construction/Initialize()
	. = ..()
	color = pick("FF0000", "#33cc33", "#ffb366", "#551A8B", "#ff80d5", "#4d94ff")

/*
 * Natural paper
 */

/obj/item/paper/natural/Initialize()
	. = ..()
	color = "#FFF5ED"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"
	slot_flags = null

/obj/item/paper/crumpled/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"
