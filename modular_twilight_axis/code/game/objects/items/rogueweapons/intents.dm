/datum/intent/proc/is_attack_swing()
	if(no_attack)
		return FALSE
	if(unarmed && istype(src, /datum/intent/unarmed/help))
		return FALSE
	return TRUE

/mob/living/try_kick(atom/A)

	if(ismob(A) && HAS_TRAIT(A, "ethereal"))//TA EDIT
		to_chat(src, span_warning("My foot passes right through the mist!"))
		return FALSE

	if(!can_kick(A))
		return FALSE
	changeNext_move(mmb_intent.clickcd)
	face_atom(A)
	SEND_SIGNAL(src, COMSIG_MOB_ON_KICK)
	playsound(src, pick(PUNCHWOOSH), 100, FALSE, -1)
	// play the attack animation even when kicking non-mobs
	if(mmb_intent) // why this would be null and not INTENT_KICK i have no clue, but the check already existed
		do_attack_animation_simple(A, visual_effect_icon = mmb_intent.animname)

	var/atom/target = A
	if(isturf(A))
		for(var/mob/living/M in A)
			target = M
			break

	var/kick_success = FALSE

	// but the rest of the logic is pretty much mob-only
	if(ismob(target) && mmb_intent)
		var/mob/living/M = target
		sleep(mmb_intent.swingdelay)
		if(QDELETED(src) || QDELETED(M))
			return FALSE
		if(!M.Adjacent(src))
			return FALSE
		if(incapacitated(ignore_restraints = TRUE))
			return FALSE
		if(M.checkmiss(src))
			return FALSE
		SEND_SIGNAL(M, COMSIG_MOB_KICKED)
		if(M.checkdefense(mmb_intent, src))
			return FALSE
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.dna.species.kicked(src, H)
		else
			M.onkick(src)

		kick_success = TRUE
	else
		target.onkick(src)
		kick_success = TRUE

	if(kick_success)
		SEND_SIGNAL(src, COMSIG_SOUNDBREAKER_KICK_SUCCESS, target)

	OffBalance(soundbreaker_get_kick_offbalance_duration(src, 3 SECONDS))
	return TRUE
