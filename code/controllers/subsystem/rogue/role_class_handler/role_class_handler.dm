/*
	Basically we got a subsystem for the shitty subjob handling and new menu as of 4/30/2024 that goes with it
*/

/*
	REMINDER TO RETEST THE OVERFILL HELPER
*/
SUBSYSTEM_DEF(role_class_handler)
	name = "Role Class Handler"
	wait = 10
	init_order = INIT_ORDER_ROLE_CLASS_HANDLER
	priority = FIRE_PRIORITY_ROLE_CLASS_HANDLER
	runlevels = RUNLEVEL_LOBBY|RUNLEVEL_GAME|RUNLEVEL_SETUP
	flags = SS_NO_FIRE

/*
	a list of datums dedicated to helping handle a class selection session
	ex: class_select_handlers[ckey] = /datum/class_select_handler
	contents: class_select_handlers = list("ckey" = /datum/class_select_handler, "ckey2" = /datum/class_select_handler,... etc)
*/
	var/list/class_select_handlers = list()
	var/list/roundstart_subclass_reservations = list() // TA EDIT START
	var/list/roundstart_subclass_reservation_jobs = list()
	var/list/roundstart_subclass_reservation_strict = list()
	var/list/roundstart_subclass_reservation_counts = list()
	var/list/roundstart_subclass_fallback_exclusions = list() // TA EDIT END

/*
	This ones basically a list for if you want to give a specific ckey a specific isolated datum
	ex: special_session_queue[ckey] += /datum/advclass/BIGMAN
	contents: special_session_queue = list("ckey" = list("funID" = /datum/advclass/class), "ckey2" = list("funID" = /datum/advclass/class)... etc)
*/
	var/list/list/special_session_queue = list()


/*
	This is basically a big assc list of lists attached to tags which contain /datum/advclass datums
	ex: sorted_class_categories[CTAG_GAPEMASTERS] += /datum/advclass/GAPER
	contents: sorted_class_categories = list("CTAG_GAPEMASTERS" = list(/datum/advclass/GAPER, /datum/advclass/GAPER2)... etc)
	Snowflake lists:
		CTAG_ALLCLASS = list(every single class datum that exists outside of the parent)
*/
	var/list/sorted_class_categories = list()


	/// Whether bandits have been injected in the game
	var/bandits_in_round = FALSE

	// Whether assassins have been injected in the game
	var/assassins_in_round = FALSE

	/// Assoc list of class registers to keep track of what townies and migrant parties are and message listeners
	var/list/class_registers = list()

/*
	We init and build the ass lists
*/
/datum/controller/subsystem/role_class_handler/Initialize(mapload)
	build_category_lists()

	initialized = TRUE

	return ..()


// This covers both class datums and drifter waves
/datum/controller/subsystem/role_class_handler/proc/build_category_lists()
	var/list/all_classes = list()
	init_subtypes(/datum/advclass, all_classes) // Init all the classes
	sorted_class_categories[CTAG_ALLCLASS] = all_classes

	//Time to sort these classes, and sort them we shall.
	for(var/datum/advclass/class in all_classes)
		for(var/ctag in class.category_tags)
			if(!sorted_class_categories[ctag]) // New cat
				sorted_class_categories[ctag] = list()
			sorted_class_categories[ctag] += class

	//Well that about covers it really.

/datum/controller/subsystem/role_class_handler/proc/get_job_subclass_by_name(datum/job/job, subclass_name) // TA EDIT START
	if(!job || !subclass_name || !length(job.job_subclasses))
		return null
	for(var/subclass_path in job.job_subclasses)
		var/datum/advclass/subclass_type = subclass_path
		if(initial(subclass_type.name) != subclass_name)
			continue
		return get_advclass_by_name(subclass_name)
	return null

/datum/controller/subsystem/role_class_handler/proc/class_has_available_slot(datum/advclass/target_datum, ckey)
	if(!target_datum)
		return FALSE
	if(target_datum.maximum_possible_slots == -1)
		return TRUE
	var/reserved_slots = roundstart_subclass_reservation_counts[target_datum.type] || 0
	var/datum/advclass/owned_reservation = roundstart_subclass_reservations[ckey]
	if(owned_reservation?.type == target_datum.type)
		reserved_slots = max(reserved_slots - 1, 0)
	return target_datum.total_slots_occupied + reserved_slots < target_datum.maximum_possible_slots

/datum/controller/subsystem/role_class_handler/proc/release_roundstart_subclass_reservation(ckey)
	if(!ckey)
		return
	var/datum/advclass/reserved_class = roundstart_subclass_reservations[ckey]
	if(reserved_class)
		var/reserved_class_type = reserved_class.type
		var/remaining_reservations = max((roundstart_subclass_reservation_counts[reserved_class_type] || 0) - 1, 0)
		if(remaining_reservations)
			roundstart_subclass_reservation_counts[reserved_class_type] = remaining_reservations
		else
			roundstart_subclass_reservation_counts.Remove(reserved_class_type)
	roundstart_subclass_reservations.Remove(ckey)
	roundstart_subclass_reservation_jobs.Remove(ckey)
	roundstart_subclass_reservation_strict.Remove(ckey)

/datum/controller/subsystem/role_class_handler/proc/clear_roundstart_subclass_state(ckey)
	release_roundstart_subclass_reservation(ckey)
	roundstart_subclass_fallback_exclusions.Remove(ckey)

/datum/controller/subsystem/role_class_handler/proc/clear_roundstart_subclass_states()
	for(var/ckey in roundstart_subclass_reservations.Copy())
		release_roundstart_subclass_reservation(ckey)
	roundstart_subclass_reservations.Cut()
	roundstart_subclass_reservation_jobs.Cut()
	roundstart_subclass_reservation_strict.Cut()
	roundstart_subclass_reservation_counts.Cut()
	roundstart_subclass_fallback_exclusions.Cut()

/datum/controller/subsystem/role_class_handler/proc/try_reserve_roundstart_subclass(client/player, datum/preferences/character_prefs, datum/job/job, subclass_name, strict_mode)
	if(!player || !character_prefs || !job || !subclass_name)
		return !strict_mode

	clear_roundstart_subclass_state(player.ckey)
	var/datum/advclass/preferred_subclass = get_job_subclass_by_name(job, subclass_name)
	if(!preferred_subclass || !preferred_subclass.check_preferences_requirements(character_prefs, player, TRUE, TRUE))
		if(!strict_mode && preferred_subclass)
			roundstart_subclass_fallback_exclusions[player.ckey] = preferred_subclass
			to_chat(player, span_warning("Your preferred subclass, [subclass_name], was unavailable. You will choose another subclass after spawning."))
		return !strict_mode

	roundstart_subclass_reservations[player.ckey] = preferred_subclass
	roundstart_subclass_reservation_jobs[player.ckey] = job.title
	roundstart_subclass_reservation_strict[player.ckey] = strict_mode ? TRUE : FALSE
	roundstart_subclass_reservation_counts[preferred_subclass.type] = (roundstart_subclass_reservation_counts[preferred_subclass.type] || 0) + 1
	return TRUE

/datum/controller/subsystem/role_class_handler/proc/consume_roundstart_subclass_reservation(ckey, job_title)
	if(!ckey)
		return null
	if(roundstart_subclass_reservation_jobs[ckey] != job_title)
		release_roundstart_subclass_reservation(ckey)
		return null
	var/datum/advclass/reserved_class = roundstart_subclass_reservations[ckey]
	if(!reserved_class)
		return null
	var/list/reservation = list(
		"class" = reserved_class,
		"strict" = roundstart_subclass_reservation_strict[ckey] ? TRUE : FALSE
	)
	release_roundstart_subclass_reservation(ckey)
	return reservation

/datum/controller/subsystem/role_class_handler/proc/consume_roundstart_subclass_exclusions(ckey)
	var/datum/advclass/excluded_class = roundstart_subclass_fallback_exclusions[ckey]
	roundstart_subclass_fallback_exclusions.Remove(ckey)
	if(excluded_class)
		return list(excluded_class)
	return list() // TA EDIT END


/*
	We setup the class handler here, aka the menu
	We will cache it per server session via an assc list with a ckey leading to the datum.
*/
/datum/controller/subsystem/role_class_handler/proc/setup_class_handler(mob/living/carbon/human/H, advclass_rolls_override = null, register_id = null)
	if(!H?.client)
		return
	var/job_title = H.job
	var/datum/job/roguetown/RT_JOB
	if(job_title)
		RT_JOB = SSjob.GetJob(job_title)
	if(!RT_JOB && H.mind?.assigned_role)
		job_title = H.mind.assigned_role
		RT_JOB = SSjob.GetJob(job_title)
	if(!register_id)
		if(job_title == "Towner")
			register_id = "towner"

	var/list/roundstart_excluded_classes = consume_roundstart_subclass_exclusions(H.client.ckey) // TA EDIT START
	var/list/roundstart_reservation = consume_roundstart_subclass_reservation(H.client.ckey, job_title)
	if(roundstart_reservation)
		var/datum/advclass/reserved_class = roundstart_reservation["class"]
		if(class_has_available_slot(reserved_class))
			var/datum/class_select_handler/reserved_handler = new()
			reserved_handler.linked_client = H.client
			reserved_handler.register_id = register_id
			if(register_id)
				add_class_register_listener(register_id, H)
			if(finish_class_handler(H, reserved_class, reserved_handler, 0, FALSE))
				return
			qdel(reserved_handler)
		if(roundstart_reservation["strict"])
			var/strict_subclass_name = reserved_class?.name
			log_game("ROLE CLASS HANDLER: [H.ckey] ([H.real_name]) returned to lobby because strict reserved subclass [strict_subclass_name] became unavailable for job [job_title].")
			message_admins("ROLE CLASS HANDLER: [H.ckey] ([H.real_name]) returned to lobby because strict reserved subclass [strict_subclass_name] became unavailable for job [job_title].")
			to_chat(H, span_warning("Your reserved subclass became unavailable, so you were returned to the lobby."))
			H.returntolobby()
			return
		roundstart_excluded_classes |= reserved_class // TA EDIT END

	// insure they somehow aren't closing the datum they got and opening a new one w rolls
	var/datum/class_select_handler/GOT_IT = class_select_handlers[H.client.ckey]
	if(GOT_IT)
		if(!GOT_IT.linked_client) // this ref will disappear if they disconnect neways probably, as its a client
			GOT_IT.linked_client = H.client // Thus we just give it back to them
		GOT_IT.second_step() // And give them a second dose of something they already dosed on
		return

	var/datum/class_select_handler/XTRA_MEATY = new()
	XTRA_MEATY.linked_client = H.client
	XTRA_MEATY.excluded_classes = roundstart_excluded_classes // TA EDIT

		// Hack for Migrants
	if(advclass_rolls_override)
		XTRA_MEATY.class_cat_alloc_attempts = advclass_rolls_override
		//XTRA_MEATY.PQ_boost_divider = 10
	else
		if(!RT_JOB)
			var/assigned_role = H.mind?.assigned_role
			log_game("ROLE CLASS HANDLER: Could not resolve job for [H.ckey] ([H.real_name]); H.job=[H.job], assigned_role=[assigned_role]. Skipping subclass setup.")
			message_admins("ROLE CLASS HANDLER: Could not resolve job for [H.ckey] ([H.real_name]); H.job=[H.job], assigned_role=[assigned_role]. Skipping subclass setup.")
			qdel(XTRA_MEATY)
			return
		if(length(RT_JOB.advclass_cat_rolls))
			XTRA_MEATY.class_cat_alloc_attempts = RT_JOB.advclass_cat_rolls

		//if(RT_JOB.PQ_boost_divider)
			//XTRA_MEATY.PQ_boost_divider = RT_JOB.PQ_boost_divider

	if(H.client.ckey in special_session_queue)
		XTRA_MEATY.special_session_queue = list()
		for(var/funny_key in special_session_queue[H.client.ckey])
			var/datum/advclass/XTRA_SPECIAL = special_session_queue[H.client.ckey][funny_key]
			if(XTRA_MEATY.is_class_excluded(XTRA_SPECIAL)) // TA EDIT START
				continue
			if(XTRA_SPECIAL.maximum_possible_slots > -1 && class_has_available_slot(XTRA_SPECIAL, H.client.ckey))
				XTRA_MEATY.special_session_queue += XTRA_SPECIAL // TA EDIT END

	XTRA_MEATY.register_id = register_id
	if(!XTRA_MEATY.initial_setup())
		return // There was just one advclass that got automatically selected
	class_select_handlers[H.client.ckey] = XTRA_MEATY


/*
	Attempt to finish the class handling ordeal, aka they picked something
	Since this is class handler related, might as well also have the class handler send itself into the params
*/
/datum/controller/subsystem/role_class_handler/proc/finish_class_handler(mob/living/carbon/human/H, datum/advclass/picked_class, datum/class_select_handler/related_handler, plus_factor, special_session_queue)
	if(!picked_class || !related_handler || !H) // ????????? This is realistically only going to happen when someones doubling up or trying to href exploit
		return FALSE
	if(!class_has_available_slot(picked_class, H.client?.ckey)) // TA EDIT START
		related_handler.rolled_class_is_full(picked_class)
		return FALSE // TA EDIT END


	if(H.mind)
		H.mind.picked_advclass = picked_class
	picked_class.equipme(H)
	H.invisibility = 0
	var/atom/movable/screen/advsetup/GET_IT_OUT = locate() in H.hud_used.static_inventory // dis line sux its basically a loop anyways if i remember
	qdel(GET_IT_OUT)
	H.cure_blind("advsetup")

	//If we get any plus factor at all, we run the datums boost proc on the human also.
	if(plus_factor)
		picked_class.boost_by_plus_power(plus_factor, H)

	if(related_handler.register_id)
		add_class_register_msg(related_handler.register_id, "[H.real_name] is the [picked_class.name]", related_handler.linked_client.mob)


	// In retrospect, If I don't just delete these Ill have to actually attempt to keep track of when a byond browser window is actually open lol
	// soooo..... this will be the place where we take it out, as it means they finished class selection, and we can safely delete the handler.
	related_handler.ForceCloseMenus() // force menus closed

	// Remove the key from the list and with it the value too
	class_select_handlers.Remove(related_handler.linked_client.ckey)
	// Call qdel on it
	qdel(related_handler)

	adjust_class_amount(picked_class, 1) // adjust the amount here, we are handling one guy right now.
	return TRUE // TA EDIT


// A dum helper to adjust the class amount, we could do it elsewhere but this will also inform any relevant class handlers open.
/datum/controller/subsystem/role_class_handler/proc/adjust_class_amount(datum/advclass/target_datum, amount)
	target_datum.total_slots_occupied += amount

	if(!(target_datum.maximum_possible_slots == -1)) // Is the class not set to infinite?
		if((target_datum.total_slots_occupied >= target_datum.maximum_possible_slots)) // We just hit a cap, iterate all the class handlers and inform them.
			for(var/HANDLER in class_select_handlers)
				var/datum/class_select_handler/found_menu = class_select_handlers[HANDLER]

				if(target_datum in found_menu.rolled_classes) // We found the target datum in one of the classes they rolled aka in the list of options they got visible,
					found_menu.rolled_class_is_full(target_datum) //	inform the datum of its error.

/datum/controller/subsystem/role_class_handler/proc/get_advclass_by_name(advclass_name)
	for(var/category in sorted_class_categories)
		for(var/datum/advclass/class as anything in sorted_class_categories[category])
			if(class.name != advclass_name)
				continue
			return class
	return null


/datum/controller/subsystem/role_class_handler/proc/get_class_register(register_id)
	if(!class_registers[register_id])
		var/datum/class_register/register = new /datum/class_register()
		register.id = register_id
		class_registers[register_id] = register
	return class_registers[register_id]

/datum/controller/subsystem/role_class_handler/proc/add_class_register_msg(register_id, msg, mob/invoker)
	var/datum/class_register/register = get_class_register(register_id)
	register.add_message(msg, invoker)

/datum/controller/subsystem/role_class_handler/proc/add_class_register_listener(register_id, mob/listener)
	var/datum/class_register/register = get_class_register(register_id)
	register.add_listener(listener)

/datum/controller/subsystem/role_class_handler/proc/remove_class_register_listener(register_id, mob/listener)
	var/datum/class_register/register = get_class_register(register_id)
	register.remove_listener(listener)
