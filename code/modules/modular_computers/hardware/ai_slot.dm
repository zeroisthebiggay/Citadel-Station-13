/obj/item/computer_hardware/ai_slot
	name = "intelliCard interface slot"
	desc = "A module allowing this computer to interface with most common intelliCard modules. Necessary for some programs to run properly."
	power_usage = 100 //W
	icon_state = "card_mini"
	w_class = WEIGHT_CLASS_SMALL
	device_type = MC_AI
	expansion_hw = TRUE

	var/obj/item/aicard/stored_card = null
	var/locked = FALSE


/obj/item/computer_hardware/ai_slot/examine(mob/user)
	. = ..()
	if(stored_card)
		. += "There appears to be an intelliCard loaded. There appears to be a pinhole protecting a manual eject button. A screwdriver could probably press it."

/obj/item/computer_hardware/ai_slot/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/aicard))
		return FALSE

	if(stored_card)
		to_chat(user, "<span class='warning'>You try to insert \the [I] into \the [src], but the slot is occupied.</span>")
		return FALSE
	if(user && !user.transferItemToLoc(I, src))
		return FALSE

	stored_card = I
	to_chat(user, "<span class='notice'>You insert \the [I] into \the [src].</span>")

	return TRUE


<<<<<<< HEAD
/obj/item/computer_hardware/ai_slot/try_eject(slot=0,mob/living/user = null,forced = 0)
	if (get_dist(src,user) > 1)
		if (iscarbon(user))
			var/mob/living/carbon/H = user
			if (!(H.dna && H.dna.check_mutation(TK) && tkMaxRangeCheck(src,H)))
				return FALSE
		else
			return FALSE
=======
/obj/item/computer_hardware/ai_slot/try_eject(mob/living/user = null,forced = FALSE)
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
	if(!stored_card)
		to_chat(user, "<span class='warning'>There is no card in \the [src].</span>")
		return FALSE

	if(locked && !forced)
		to_chat(user, "<span class='warning'>Safeties prevent you from removing the card until reconstruction is complete...</span>")
		return FALSE

	if(stored_card)
		stored_card.forceMove(get_turf(src))
		locked = FALSE
		stored_card.verb_pickup()
		stored_card = null

		to_chat(user, "<span class='notice'>You remove the card from \the [src].</span>")
		return TRUE
	return FALSE

/obj/item/computer_hardware/ai_slot/attackby(obj/item/I, mob/living/user)
	if(..())
		return
	if(istype(I, /obj/item/screwdriver))
		to_chat(user, "<span class='notice'>You press down on the manual eject button with \the [I].</span>")
		try_eject(,user,1)
		return