GLOBAL_LIST_EMPTY(mindlinks)

/datum/mindlink
	var/mob/living/owner
	var/mob/living/target
	var/active = TRUE

/datum/mindlink/New(mob/living/owner, mob/living/target)
	src.owner = owner
	src.target = target

	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(target, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mindlink/Destroy()
	if(owner) // TA EDIT START
		UnregisterSignal(owner, COMSIG_MOB_SAY)
	if(target)
		UnregisterSignal(target, COMSIG_MOB_SAY) // TA EDIT END
	owner = null
	target = null
	return ..()

/datum/mindlink/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER

	if(!active)
		return

	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return

	if(findtext(message, ",mst", 1, 5) == 1) // TA EDIT START
		var/mob/living/recipient = (speaker == owner ? target : owner)
		speech_args[SPEECH_MESSAGE] = null
		speaker.playsound_local(speaker, 'sound/magic/message.ogg', 75, TRUE)
		if(recipient && !QDELETED(recipient))
			recipient.playsound_local(recipient, 'sound/magic/message.ogg', 75, TRUE)
			to_chat(recipient, span_notice("The bond is broken by one of the parties."))
		to_chat(speaker, span_notice("The bond is broken by one of the parties."))
		active = FALSE
		GLOB.mindlinks -= src
		qdel(src)
		return // TA EDIT END

	// Check for the ,m prefix
	if(findtext(message, ",m", 1, 3) == 1) // TA EDIT START
		// if mindlink ever breaks ensure some dingus didnt set ,m to a language key
		speech_args[SPEECH_MESSAGE] = null
		message = trim(copytext(message, 3))
		if(!length(message))
			return
		var/mob/living/recipient = (speaker == owner ? target : owner)
		if(!recipient || QDELETED(recipient))
			to_chat(speaker, span_warning("There is no mind on the other end of the link."))
			active = FALSE
			GLOB.mindlinks -= src
			qdel(src)
			return

		var/formatted_message = span_centcomradio("The voice of [speaker] echoes, \"<i>[capitalize(message)]</i>\".")
		to_chat(recipient, formatted_message)
		to_chat(speaker, formatted_message)
		recipient.playsound_local(recipient, 'sound/magic/mindlink.ogg', 100, TRUE)
		speaker.playsound_local(speaker, 'sound/magic/mindlink.ogg', 100, TRUE)
		speaker.log_talk(message, LOG_SAY, tag="mindlink (to [recipient])") // TA EDIT END
