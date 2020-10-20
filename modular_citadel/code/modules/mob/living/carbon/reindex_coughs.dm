/mob/living //why does this exist
	var/list/alternate_coughs

/mob/living/carbon/proc/reindex_coughs()
	clear_coughs()
	if(head)
		add_coughs(head.alternate_coughs)
	if(wear_mask)
		add_coughs(wear_mask.alternate_coughs)
	if(back)
		add_coughs(back.alternate_coughs)

/mob/living/carbon/human/reindex_coughs()
	..()
	//More slots in humans.
	if(ears)
		add_coughs(ears.alternate_coughs)
	if(wear_suit)
		add_coughs(wear_suit.alternate_coughs)
	if(w_uniform)
		add_coughs(w_uniform.alternate_coughs)
	if(glasses)
		add_coughs(glasses.alternate_coughs)
	if(gloves)
		add_coughs(gloves.alternate_coughs)
	if(shoes)
		add_coughs(shoes.alternate_coughs)
	if(belt)
		add_coughs(belt.alternate_coughs)
	if(s_store)
		add_coughs(s_store.alternate_coughs)
	if(wear_id)
		add_coughs(wear_id.alternate_coughs)

//Note that the following two are for /mob/living, while the above two are for /carbon and /human
/mob/living/proc/add_coughs(var/list/coughs)
	LAZYINITLIST(alternate_coughs)
	if(!coughs || coughs.len == 0)
		return
	for(var/S in coughs)
		LAZYADD(alternate_coughs, S)

/mob/living/proc/clear_coughs()
	LAZYINITLIST(alternate_coughs)
	LAZYCLEARLIST(alternate_coughs)