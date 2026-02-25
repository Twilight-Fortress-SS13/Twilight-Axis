/datum/class_select_handler
	var/skip_slot_accounting = FALSE

/datum/controller/subsystem/role_class_handler/proc/setup_class_handler(mob/living/carbon/human/H, advclass_rolls_override = null, register_id = null, bypass_reqs = FALSE, skip_slot_accounting = FALSE)
	if(!register_id)
		if(H.job == "Towner")
			register_id = "towner"
	// insure they somehow aren't closing the datum they got and opening a new one w rolls
	var/datum/class_select_handler/GOT_IT = class_select_handlers[H.client.ckey]
	if(GOT_IT)
		if(!GOT_IT.linked_client) // this ref will disappear if they disconnect neways probably, as its a client
			GOT_IT.linked_client = H.client // Thus we just give it back to them
		GOT_IT.class_cat_alloc_bypass_reqs = bypass_reqs
		GOT_IT.forced_class_bypass_reqs = bypass_reqs
		GOT_IT.skip_slot_accounting = skip_slot_accounting
		GOT_IT.second_step() // And give them a second dose of something they already dosed on
		return

	var/datum/class_select_handler/XTRA_MEATY = new()
	XTRA_MEATY.linked_client = H.client
	XTRA_MEATY.skip_slot_accounting = skip_slot_accounting
	XTRA_MEATY.class_cat_alloc_bypass_reqs = bypass_reqs
	XTRA_MEATY.forced_class_bypass_reqs = bypass_reqs

		// Hack for Migrants
	if(advclass_rolls_override)
		XTRA_MEATY.class_cat_alloc_attempts = advclass_rolls_override
		//XTRA_MEATY.PQ_boost_divider = 10
	else
		var/datum/job/roguetown/RT_JOB = SSjob.GetJob(H.job)
		if(RT_JOB.advclass_cat_rolls.len)
			XTRA_MEATY.class_cat_alloc_attempts = RT_JOB.advclass_cat_rolls

		//if(RT_JOB.PQ_boost_divider)
			//XTRA_MEATY.PQ_boost_divider = RT_JOB.PQ_boost_divider

	if(H.client.ckey in special_session_queue)
		XTRA_MEATY.special_session_queue = list()
		for(var/funny_key in special_session_queue[H.client.ckey])
			var/datum/advclass/XTRA_SPECIAL = special_session_queue[H.client.ckey][funny_key]
			if(XTRA_SPECIAL.maximum_possible_slots > XTRA_SPECIAL.total_slots_occupied)
				XTRA_MEATY.special_session_queue += XTRA_SPECIAL

	XTRA_MEATY.register_id = register_id
	if(!XTRA_MEATY.initial_setup())
		return // There was just one advclass that got automatically selected
	class_select_handlers[H.client.ckey] = XTRA_MEATY

/datum/controller/subsystem/role_class_handler/proc/finish_class_handler(mob/living/carbon/human/H, datum/advclass/picked_class, datum/class_select_handler/related_handler, plus_factor, special_session_queue)
	if(!picked_class || !related_handler || !H) // ????????? This is realistically only going to happen when someones doubling up or trying to href exploit
		return FALSE
	if(!related_handler.skip_slot_accounting)
		if(!(picked_class.maximum_possible_slots == -1)) // Is the class not set to infinite?
			if(picked_class.total_slots_occupied >= picked_class.maximum_possible_slots) // are the occupied slots greater than or equal to the current maximum possible slots on the datum?
				related_handler.rolled_class_is_full(picked_class) //If so we inform the datum in the off-chance some desyncing is occurring so we don't have a deadslot in their options.
				return FALSE // Along with stop here as they didn't get it.


	H.advsetup = FALSE // This is actually on a lot of shit, so its a ghetto selector protector if u need one
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

	if(!related_handler.skip_slot_accounting)
		adjust_class_amount(picked_class, 1) // adjust the amount here, we are handling one guy right now.
