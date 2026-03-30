/datum/intent/proc/is_attack_swing()
	if(no_attack)
		return FALSE
	if(unarmed && istype(src, /datum/intent/unarmed/help))
		return FALSE
	return TRUE

/mob/living/try_kick(atom/A)
	if(ismob(A) && HAS_TRAIT(A, "ethereal"))
		to_chat(src, span_warning("My foot passes right through the mist!"))
		return FALSE

	if(!can_kick(A))
		return FALSE

	changeNext_move(mmb_intent.clickcd)
	face_atom(A)
	SEND_SIGNAL(src, COMSIG_MOB_ON_KICK)
	playsound(src, pick(PUNCHWOOSH), 100, FALSE, -1)

	if(mmb_intent)
		do_attack_animation_simple(A, visual_effect_icon = mmb_intent.animname)

	var/atom/target = A
	if(isturf(A))
		for(var/mob/living/M in A)
			target = M
			break

	var/mob/living/living_target = null
	if(isliving(target))
		living_target = target

	var/kick_success = FALSE

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
		SEND_SIGNAL(src, COMSIG_ATTACK_TRY_CONSUME, living_target || target, zone_selected, null, 2)

	OffBalance(get_special_kick_offbalance_duration(src, 3 SECONDS))
	return TRUE

/proc/get_special_kick_offbalance_duration(mob/living/user, base_duration = 3 SECONDS)
	if(!isliving(user))
		return base_duration

	var/datum/component/combo_core/wanderer/W = wanderer_get_component_safe(user)
	if(W)
		return W.GetKickOffbalanceDuration(base_duration / 4)

	var/datum/component/combo_core/soundbreaker/S = soundbreaker_get_component_safe(user)
	if(S)
		return S.GetKickOffbalanceDuration(base_duration)

	return base_duration
