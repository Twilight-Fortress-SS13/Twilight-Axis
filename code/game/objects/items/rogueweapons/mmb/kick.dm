/datum/intent/kick
	name = "kick"
	candodge = TRUE
	canparry = TRUE
	chargetime = 0
	chargedrain = 0
	noaa = FALSE
	swingdelay = 5
	misscost = 20
	unarmed = TRUE
	animname = "kick"
	pointer = 'icons/effects/mousemice/human_kick.dmi'

/datum/intent/kick/on_mmb(atom/target, mob/living/user, params)
	user.try_kick(target)

/atom/proc/onkick(mob/user)
	return

/obj/item/onkick(mob/user)
	if(!ontable())
		if(w_class < WEIGHT_CLASS_HUGE)
			throw_at(get_ranged_target_turf(src, get_dir(user,src), 2), 2, 2, user, FALSE)

/// Performs a kick. Used by the kick MMB intent. Returns TRUE if a kick was performed.
/mob/living/proc/try_kick(atom/A)

	if(ismob(A) && HAS_TRAIT(A, "ethereal"))//TA EDIT
		to_chat(src, span_warning("My foot passes right through the mist!"))
		return FALSE

	var/atom/target = get_kick_target(A) // TA EDIT START
	var/uses_ball_recovery = target?.uses_ball_kick_recovery()
	if(uses_ball_recovery && has_status_effect(STATUS_EFFECT_BALL_KICK_RECOVERY))
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE // TA EDIT END

	if(!can_kick(A))
		return FALSE

	if(uses_ball_recovery) // TA EDIT START
		var/ball_kick_cooldown = target.get_kick_cooldown(src)
		if(isnum(ball_kick_cooldown) && ball_kick_cooldown > 0)
			SetBallKickRecovery(ball_kick_cooldown)
			changeNext_move(ball_kick_cooldown, override = TRUE)
	else
		changeNext_move(mmb_intent.clickcd) // TA EDIT END

	face_atom(A)
	SEND_SIGNAL(src, COMSIG_MOB_ON_KICK)
	playsound(src, pick(PUNCHWOOSH), 100, FALSE, -1)
	// play the attack animation even when kicking non-mobs
	if(mmb_intent) // why this would be null and not INTENT_KICK i have no clue, but the check already existed
		do_attack_animation_simple(A, visual_effect_icon = mmb_intent.animname)

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
		SEND_SIGNAL(M, COMSIG_MOB_KICKED_SUCCESSFUL, src)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.dna.species.kicked(src, H)
		else
			M.onkick(src)
	else
		var/kick_result = target.onkick(src) // TA EDIT START
		if(uses_ball_recovery)
			if(!kick_result)
				remove_status_effect(STATUS_EFFECT_BALL_KICK_RECOVERY)
				return FALSE
			if(isnum(kick_result) && kick_result > 0)
				SetBallKickRecovery(kick_result)
				changeNext_move(kick_result, override = TRUE)
			return TRUE
		if(isnum(kick_result))
			changeNext_move(kick_result, override = TRUE)
			return TRUE
		else if(islist(kick_result))
			var/list/kick_result_data = kick_result
			var/custom_kick_cooldown = kick_result_data["cooldown"]
			if(isnum(custom_kick_cooldown))
				changeNext_move(custom_kick_cooldown, override = TRUE)
				return TRUE // TA EDIT END
	OffBalance(3 SECONDS)
	return TRUE

/mob/living/proc/can_kick(atom/A, do_message = TRUE)
	if(get_num_legs() < 2)
		return FALSE
	if(!A.Adjacent(src))
		return FALSE
	if(A == src)
		return FALSE
	if(IsOffBalanced())
		if(do_message)
			to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE
	if(QDELETED(src) || QDELETED(A))
		return FALSE
	return TRUE
