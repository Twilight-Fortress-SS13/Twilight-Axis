/datum/mindlink/coven
	var/list/mob/living/members = list()

/datum/mindlink/coven/New(list/mob/living/new_members)
	src.members = new_members
	for(var/mob/living/M in members)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mindlink/coven/Destroy()
	for(var/mob/living/M in members)
		UnregisterSignal(M, COMSIG_MOB_SAY)
	members.Cut()
	return ..()

/datum/mindlink/coven/handle_speech(mob/living/speaker, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message || !active) return

	// Break logic
	if(findtext(message, ",mst", 1, 5) == 1) // TA EDIT START
		speech_args[SPEECH_MESSAGE] = null
		to_chat(members, span_notice("The coven web is severed by [speaker]."))
		qdel(src)
		return // TA EDIT END

	// Speech logic
	if(findtext(message, ",m", 1, 3) == 1) // TA EDIT START
		speech_args[SPEECH_MESSAGE] = null
		message = trim(copytext(message, 3))
		if(!length(message))
			return
		var/formatted = span_centcomradio("The voice of [speaker] echoes, \"<i>[capitalize(message)]</i>\".")

		for(var/mob/living/M in members)
			if(QDELETED(M))
				continue
			// Slightly more secretive!
			M.playsound_local(M, 'sound/magic/mindlink.ogg', 75, TRUE)
			to_chat(M, formatted)

		speaker.log_talk(message, LOG_SAY, tag="Coven Link") // TA EDIT END
