
/datum/verbs/menu/Admin/Generate_list(client/C)
	if (C.holder)
		. = ..()

/datum/verbs/menu/Admin/verb/playerpanel()
	set name = "Player Panel New"
	set desc = ""
	set category = "-Admin-"
	if(usr.client.holder)
		usr.client.holder.player_panel_new()
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel New") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/verbs/menu/admin/verb/purge_invalid_timers()
	set name = "Purge Invalid Timers"
	set category = "Debug"
	set desc = "Deletes timers with QDELETED objects or invalid callbacks"

	if(!SStimer)
		to_chat(usr, "Timer subsystem not found.")
		return

	var/removed = 0

	// clienttime timers
	for(var/datum/timedevent/T in SStimer.clienttime_timers.Copy())
		if(QDELETED(T) || !T.callBack || QDELETED(T.callBack.object))
			SStimer.clienttime_timers -= T
			if(!QDELETED(T))
				qdel(T)
			removed++

	// second queue
	for(var/datum/timedevent/T in SStimer.second_queue.Copy())
		if(QDELETED(T) || !T.callBack || QDELETED(T.callBack.object))
			SStimer.second_queue -= T
			if(!QDELETED(T))
				qdel(T)
			removed++

	to_chat(usr, "<span class='notice'>Purged [removed] invalid timers.</span>")
	log_admin("[key_name(usr)] purged [removed] invalid timers.")
