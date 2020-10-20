/datum/species/human
	name = "Human"
	id = SPECIES_HUMAN
	default_color = "FFFFFF"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS_PARTSONLY,WINGCOLOR)
	mutant_bodyparts = list("mcolor" = "FFF", "mcolor2" = "FFF","mcolor3" = "FFF","tail_human" = "None", "ears" = "None", "taur" = "None", "deco_wings" = "None")
	use_skintones = USE_SKINTONES_GRAYSCALE_CUSTOM
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED

<<<<<<< HEAD
/datum/species/human/qualifies_for_rank(rank, list/features)
	return TRUE	//Pure humans are always allowed in all roles.
=======
	tail_type = "tail_human"
	wagging_type = "waggingtail_human"
	species_category = SPECIES_CATEGORY_BASIC
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

/datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/human/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/human/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["tail_human"] || mutant_bodyparts["waggingtail_human"]

/datum/species/human/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["waggingtail_human"]

/datum/species/human/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["tail_human"])
		mutant_bodyparts["waggingtail_human"] = mutant_bodyparts["tail_human"]
		mutant_bodyparts -= "tail_human"
	H.update_body()

/datum/species/human/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["waggingtail_human"])
		mutant_bodyparts["tail_human"] = mutant_bodyparts["waggingtail_human"]
		mutant_bodyparts -= "waggingtail_human"
	H.update_body()
