/datum/round_event_control/untied_shoes
	name = "Untied Shoes"
	typepath = /datum/round_event/untied_shoes
	weight = 100
	max_occurrences = 20
	alert_observers = FALSE

/datum/round_event/untied_shoes
	fakeable = FALSE

/datum/round_event/untied_shoes/start()
	var/iterations = 1
	for(var/mob/living/carbon/C in shuffle(GLOB.alive_mob_list))
		if(!C.client)
			continue
		if(C.stat == DEAD)
			continue
		if (HAS_TRAIT(C,TRAIT_EXEMPT_HEALTH_EVENTS))
			continue
		if(!C.shoes || !C.shoes.can_be_tied || C.shoes.tied != SHOES_TIED)
			continue
		if(prob(5))
			C.shoes.adjust_laces(SHOES_KNOTTED)
		else
			C.shoes.adjust_laces(SHOES_UNTIED)
		iterations++
		if(prob(100/iterations))
			return
