GLOBAL_DATUM(the_gateway, /obj/machinery/gateway/centerstation)
<<<<<<< HEAD
=======
/// List of possible gateway destinations.
GLOBAL_LIST_EMPTY(gateway_destinations)

/**
  * Corresponds to single entry in gateway control.
  *
  * Will NOT be added automatically to GLOB.gateway_destinations list.
  */
/datum/gateway_destination
	var/name = "Unknown Destination"
	var/wait = 0 /// How long after roundstart this destination becomes active
	var/enabled = TRUE /// If disabled, the destination won't be available
	var/hidden = FALSE /// Will not show on gateway controls at all.

/* Can a gateway link to this destination right now. */
/datum/gateway_destination/proc/is_available()
	return enabled && (world.time - SSticker.round_start_time >= wait)

/* Returns user-friendly description why you can't connect to this destination, displayed in UI */
/datum/gateway_destination/proc/get_available_reason()
	. = "Unreachable"
	if(world.time - SSticker.round_start_time < wait)
		. = "Connection desynchronized. Recalibration in progress."

/* Check if the movable is allowed to arrive at this destination (exile implants mostly) */
/datum/gateway_destination/proc/incoming_pass_check(atom/movable/AM)
	return TRUE

/* Get the actual turf we'll arrive at */
/datum/gateway_destination/proc/get_target_turf()
	CRASH("get target turf not implemented for this destination type")

/* Called after moving the movable to target turf */
/datum/gateway_destination/proc/post_transfer(atom/movable/AM)
	if (ismob(AM))
		var/mob/M = AM
		if (M.client)
			M.client.move_delay = max(world.time + 5, M.client.move_delay)

/* Called when gateway activates with this destination. */
/datum/gateway_destination/proc/activate(obj/machinery/gateway/activated)
	return

/* Called when gateway targeting this destination deactivates. */
/datum/gateway_destination/proc/deactivate(obj/machinery/gateway/deactivated)
	return

/* Returns data used by gateway controller ui */
/datum/gateway_destination/proc/get_ui_data()
	. = list()
	.["ref"] = REF(src)
	.["name"] = name
	.["available"] = is_available()
	.["reason"] = get_available_reason()
	if(wait)
		.["timeout"] = max(1 - (wait - (world.time - SSticker.round_start_time)) / wait, 0)

/* Destination is another gateway */
/datum/gateway_destination/gateway
	/// The gateway this destination points at
	var/obj/machinery/gateway/target_gateway

/* We set the target gateway target to activator gateway */
/datum/gateway_destination/gateway/activate(obj/machinery/gateway/activated)
	if(!target_gateway.target)
		target_gateway.activate(activated)

/* We turn off the target gateway if it's linked with us */
/datum/gateway_destination/gateway/deactivate(obj/machinery/gateway/deactivated)
	if(target_gateway.target == deactivated.destination)
		target_gateway.deactivate()

/datum/gateway_destination/gateway/is_available()
	return ..() && target_gateway.calibrated && !target_gateway.target && target_gateway.powered()

/datum/gateway_destination/gateway/get_available_reason()
	. = ..()
	if(!target_gateway.calibrated)
		. = "Exit gateway malfunction. Manual recalibration required."
	if(target_gateway.target)
		. = "Exit gateway in use."
	if(!target_gateway.powered())
		. = "Exit gateway unpowered."

/datum/gateway_destination/gateway/get_target_turf()
	return get_step(target_gateway.portal,SOUTH)

/datum/gateway_destination/gateway/post_transfer(atom/movable/AM)
	. = ..()
	addtimer(CALLBACK(AM,/atom/movable.proc/setDir,SOUTH),0)

/* Special home destination, so we can check exile implants */
/datum/gateway_destination/gateway/home

/datum/gateway_destination/gateway/home/incoming_pass_check(atom/movable/AM)
	if(isliving(AM))
		if(check_exile_implant(AM))
			return FALSE
	else
		for(var/mob/living/L in AM.contents)
			if(check_exile_implant(L))
				target_gateway.say("Rejecting [AM]: Exile implant detected in contained lifeform.")
				return FALSE
	if(AM.has_buckled_mobs())
		for(var/mob/living/L in AM.buckled_mobs)
			if(check_exile_implant(L))
				target_gateway.say("Rejecting [AM]: Exile implant detected in close proximity lifeform.")
				return FALSE
	return TRUE

/datum/gateway_destination/gateway/home/proc/check_exile_implant(mob/living/L)
	for(var/obj/item/implant/exile/E in L.implants)//Checking that there is an exile implant
		to_chat(L, "<span class='userdanger'>The station gate has detected your exile implant and is blocking your entry.</span>")
		return TRUE
	return FALSE


/* Destination is one ore more turfs - created by landmarks */
/datum/gateway_destination/point
	var/list/target_turfs = list()
	/// Used by away landmarks
	var/id

/datum/gateway_destination/point/get_target_turf()
	return pick(target_turfs)

/* Dense invisible object starting the teleportation. Created by gateways on activation. */
/obj/effect/gateway_portal_bumper
	var/obj/machinery/gateway/gateway
	density = TRUE
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/gateway_portal_bumper/Bumped(atom/movable/AM)
	if(get_dir(src,AM) == SOUTH)
		gateway.Transfer(AM)

/obj/effect/gateway_portal_bumper/Destroy(force)
	. = ..()
	gateway = null
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands, it allows for faster than light travel to far-flung locations."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/active = 0
	var/checkparts = TRUE
	var/list/obj/effect/landmark/randomspawns = list()
	var/calibrated = TRUE
	var/list/linked = list()
	var/can_link = FALSE	//Is this the centerpiece?

/obj/machinery/gateway/Initialize()
	randomspawns = GLOB.awaydestinations
	update_icon()
	if(!istype(src, /obj/machinery/gateway/centerstation) && !istype(src, /obj/machinery/gateway/centeraway))
		switch(dir)
			if(SOUTH,SOUTHEAST,SOUTHWEST)
				density = FALSE
	return ..()

/obj/machinery/gateway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()

/obj/machinery/gateway/proc/detect()
	if(!can_link)
		return FALSE
	linked = list()	//clear the list
	var/turf/T = loc
	var/ready = FALSE

	for(var/i in GLOB.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = FALSE
		toggleoff()
		break

	if((linked.len == 8) || !checkparts)
		ready = TRUE
	return ready

/obj/machinery/gateway/update_icon_state()
	icon_state = active ? "on" : "off"

/obj/machinery/gateway/attack_hand(mob/user)
	. = ..()
	if(.)
		return
<<<<<<< HEAD
	if(!detect())
		return
	if(!active)
		toggleon(user)
=======
	target = D
	target.activate(destination)
	generate_bumper()
	use_power = ACTIVE_POWER_USE
	update_icon()

/obj/machinery/gateway/proc/Transfer(atom/movable/AM)
	if(!target || !target.incoming_pass_check(AM))
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
		return
	toggleoff()

/obj/machinery/gateway/proc/toggleon(mob/user)
	return FALSE

/obj/machinery/gateway/safe_throw_at()
	return

/obj/machinery/gateway/centerstation/Initialize()
	. = ..()
	if(!GLOB.the_gateway)
		GLOB.the_gateway = src
	update_icon()
	wait = world.time + CONFIG_GET(number/gateway_delay)	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)

/obj/machinery/gateway/centerstation/Destroy()
	if(GLOB.the_gateway == src)
		GLOB.the_gateway = null
	return ..()

//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = TRUE
	icon_state = "offcenter"
	use_power = IDLE_POWER_USE

	//warping vars
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null
	can_link = TRUE

/obj/machinery/gateway/centerstation/update_icon_state()
	icon_state = active ? "oncenter" : "offcenter"

/obj/machinery/gateway/centerstation/process()
	if((stat & (NOPOWER)) && use_power)
		if(active)
			toggleoff()
		return

	if(active)
		use_power(5000)

/obj/machinery/gateway/centerstation/toggleon(mob/user)
	if(!detect())
		return
	if(!powered())
		return
	if(!awaygate)
		to_chat(user, "<span class='notice'>Error: No destination found.</span>")
		return
	if(world.time < wait)
		to_chat(user, "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [DisplayTimeText(wait - world.time)].</span>")
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()

//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/AM)
	if(!active)
		return
	if(!detect())
		return
	if(!awaygate || QDELETED(awaygate))
		return

	if(awaygate.calibrated)
		AM.forceMove(get_step(awaygate.loc, SOUTH))
		AM.setDir(SOUTH)
		if (ismob(AM))
			var/mob/M = AM
			if (M.client)
				M.client.move_delay = max(world.time + 5, M.client.move_delay)
		return
	else
		var/obj/effect/landmark/dest = pick(randomspawns)
		if(dest)
			AM.forceMove(get_turf(dest))
			AM.setDir(SOUTH)
			use_power(5000)
		return

/obj/machinery/gateway/centeraway/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/multitool))
		if(calibrated)
			to_chat(user, "\black The gate is already calibrated, there is no work for you to do here.")
			return
		else
			to_chat(user, "<span class='boldnotice'>Recalibration successful!</span>: \black This gate's systems have been fine tuned.  Travel to this gate will now be on target.")
			calibrated = TRUE
			return

/////////////////////////////////////Away////////////////////////


/obj/machinery/gateway/centeraway
	density = TRUE
	icon_state = "offcenter"
	use_power = NO_POWER_USE
	var/obj/machinery/gateway/centerstation/stationgate = null
	can_link = TRUE


/obj/machinery/gateway/centeraway/Initialize()
	. = ..()
<<<<<<< HEAD
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)
=======
	if(!target)
		if(!GLOB.the_gateway)
			to_chat(user,"<span class='warning'>Home gateway is not responding!</span>")
		if(GLOB.the_gateway.target)
			GLOB.the_gateway.deactivate() //this will turn the home gateway off so that it's free for us to connect to
		activate(GLOB.the_gateway.destination)
	else
		deactivate()
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d


/obj/machinery/gateway/centeraway/update_icon_state()
	icon_state = active ? "oncenter" : "offcenter"

/obj/machinery/gateway/centeraway/toggleon(mob/user)
	if(!detect())
		return
	if(!stationgate)
		to_chat(user, "<span class='notice'>Error: No destination found.</span>")
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()

/obj/machinery/gateway/centeraway/proc/check_exile_implant(mob/living/L)
	for(var/obj/item/implant/exile/E in L.implants)//Checking that there is an exile implant
		to_chat(L, "\black The station gate has detected your exile implant and is blocking your entry.")
		return TRUE
	return FALSE

/obj/machinery/gateway/centeraway/Bumped(atom/movable/AM)
	if(!detect())
		return
	if(!active)
		return
<<<<<<< HEAD
	if(!stationgate || QDELETED(stationgate))
=======
	if(!D.is_available() || G.target)
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
		return
	if(isliving(AM))
		if(check_exile_implant(AM))
			return
	else
		for(var/mob/living/L in AM.contents)
			if(check_exile_implant(L))
				say("Rejecting [AM]: Exile implant detected in contained lifeform.")
				return
	if(AM.has_buckled_mobs())
		for(var/mob/living/L in AM.buckled_mobs)
			if(check_exile_implant(L))
				say("Rejecting [AM]: Exile implant detected in close proximity lifeform.")
				return
	AM.forceMove(get_step(stationgate.loc, SOUTH))
	AM.setDir(SOUTH)
	if (ismob(AM))
		var/mob/M = AM
		if (M.client)
			M.client.move_delay = max(world.time + 5, M.client.move_delay)


/obj/machinery/gateway/centeraway/admin
	desc = "A mysterious gateway built by unknown hands, this one seems more compact."

/obj/machinery/gateway/centeraway/admin/Initialize()
	. = ..()
	if(stationgate && !stationgate.awaygate)
		stationgate.awaygate = src

/obj/machinery/gateway/centeraway/admin/detect()
	return TRUE


/obj/item/paper/fluff/gateway
	info = "Congratulations,<br><br>Your station has been selected to carry out the Gateway Project.<br><br>The equipment will be shipped to you at the start of the next quarter.<br> You are to prepare a secure location to house the equipment as outlined in the attached documents.<br><br>--Nanotrasen Blue Space Research"
	name = "Confidential Correspondence, Pg 1"
