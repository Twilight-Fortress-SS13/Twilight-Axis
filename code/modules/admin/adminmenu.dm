
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

	if(!SStimer)
		to_chat(usr, "Timer subsystem not found.")
		return

	var/removed = 0

	for(var/datum/timedevent/T in SStimer.clienttime_timers.Copy())
		if(QDELETED(T))
			continue

		var/datum/callback/CB = T.callBack
		if(!CB)
			qdel(T)
			removed++
			continue

		var/obj = CB.object
		if(!isdatum(obj) || QDELETED(obj))
			qdel(T)
			removed++

	for(var/datum/timedevent/T in SStimer.second_queue.Copy())
		if(QDELETED(T))
			continue

		var/datum/callback/CB = T.callBack
		if(!CB)
			qdel(T)
			removed++
			continue

		var/obj = CB.object
		if(!isdatum(obj) || QDELETED(obj))
			qdel(T)
			removed++

	to_chat(usr, "Purged [removed] invalid timers.")
