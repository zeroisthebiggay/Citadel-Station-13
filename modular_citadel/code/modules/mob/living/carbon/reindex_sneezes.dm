/mob/living //why does this exist
	var/list/alternate_sneezes

/mob/living/carbon/proc/reindex_sneezes()
	clear_sneezes()
	if(head)
		add_sneezes(head.alternate_sneezes)
	if(wear_mask)
		add_sneezes(wear_mask.alternate_sneezes)
	if(back)
		add_sneezes(back.alternate_sneezes)

/mob/living/carbon/human/reindex_sneezes()
	..()
	//More slots in humans.
	if(ears)
		add_sneezes(ears.alternate_sneezes)
	if(wear_suit)
		add_sneezes(wear_suit.alternate_sneezes)
	if(w_uniform)
		add_sneezes(w_uniform.alternate_sneezes)
	if(glasses)
		add_sneezes(glasses.alternate_sneezes)
	if(gloves)
		add_sneezes(gloves.alternate_sneezes)
	if(shoes)
		add_sneezes(shoes.alternate_sneezes)
	if(belt)
		add_sneezes(belt.alternate_sneezes)
	if(s_store)
		add_sneezes(s_store.alternate_sneezes)
	if(wear_id)
		add_sneezes(wear_id.alternate_sneezes)

//Note that the following two are for /mob/living, while the above two are for /carbon and /human
/mob/living/proc/add_sneezes(var/list/sneezes)
	LAZYINITLIST(alternate_sneezes)
	if(!sneezes || sneezes.len == 0)
		return
	for(var/S in sneezes)
		LAZYADD(alternate_sneezes, S)

/mob/living/proc/clear_sneezes()
	LAZYINITLIST(alternate_sneezes)
	LAZYCLEARLIST(alternate_sneezes)