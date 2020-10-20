/datum/species/insect
	name = "Anthromorphic Insect"
<<<<<<< HEAD
	id = "insect"
=======
	id = SPECIES_INSECT
	say_mod = "chitters"
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
	default_color = "00FF00"
	species_traits = list(LIPS,EYECOLOR,HAIR,FACEHAIR,MUTCOLORS,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_tail" = "None", "mam_ears" = "None",
							"insect_wings" = "None", "insect_fluff" = "None", "mam_snouts" = "None", "taur" = "None", "insect_markings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/insect
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC
	icon_limbs = DEFAULT_BODYPART_ICON_CITADEL

<<<<<<< HEAD
/datum/species/insect/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/insect/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/insect/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["mam_tail"] || mutant_bodyparts["mam_waggingtail"]

/datum/species/insect/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["mam_waggingtail"]

/datum/species/insect/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["mam_tail"])
		mutant_bodyparts["mam_waggingtail"] = mutant_bodyparts["mam_tail"]
		mutant_bodyparts -= "mam_tail"
	H.update_body()

/datum/species/insect/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["mam_waggingtail"])
		mutant_bodyparts["mam_tail"] = mutant_bodyparts["mam_waggingtail"]
		mutant_bodyparts -= "mam_waggingtail"
	H.update_body()

/datum/species/insect/qualifies_for_rank(rank, list/features)
	return TRUE
=======
	tail_type = "mam_tail"
	wagging_type = "mam_waggingtail"
	species_category = SPECIES_CATEGORY_INSECT

	allowed_limb_ids = list("insect","apid","moth","moth_not_greyscale")

	eye_type = "insect"
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
