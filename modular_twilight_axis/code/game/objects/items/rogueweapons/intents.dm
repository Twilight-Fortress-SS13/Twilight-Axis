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

	var/atom/target = get_kick_target(A)
	var/uses_ball_recovery = target?.uses_ball_kick_recovery()
	if(uses_ball_recovery && has_status_effect(STATUS_EFFECT_BALL_KICK_RECOVERY))
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE

	if(!can_kick(A))
		return FALSE

	var/mob/living/living_target = null
	if(isliving(target))
		living_target = target

	var/ball_kick_cooldown = null
	if(uses_ball_recovery)
		ball_kick_cooldown = target.get_kick_cooldown(src)
		if(isnum(ball_kick_cooldown) && ball_kick_cooldown > 0)
			SetBallKickRecovery(ball_kick_cooldown)
			changeNext_move(ball_kick_cooldown, override = TRUE)
	else
		changeNext_move(mmb_intent?.clickcd || 3 SECONDS)

	face_atom(A)
	SEND_SIGNAL(src, COMSIG_MOB_ON_KICK)
	playsound(src, pick(PUNCHWOOSH), 100, FALSE, -1)

	if(mmb_intent)
		do_attack_animation_simple(A, visual_effect_icon = mmb_intent.animname)

	var/kick_success = FALSE
	var/kick_result = null

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
			kick_result = M.onkick(src)

		kick_success = TRUE
	else
		kick_result = target.onkick(src)
		if(uses_ball_recovery)
			if(!kick_result)
				remove_status_effect(STATUS_EFFECT_BALL_KICK_RECOVERY)
				return FALSE

			if(isnum(kick_result) && kick_result > 0 && kick_result != ball_kick_cooldown)
				ball_kick_cooldown = kick_result
				SetBallKickRecovery(ball_kick_cooldown)
				changeNext_move(ball_kick_cooldown, override = TRUE)
			else if(islist(kick_result))
				var/list/kick_result_data = kick_result
				var/result_cooldown = kick_result_data["cooldown"]
				if(isnum(result_cooldown) && result_cooldown > 0 && result_cooldown != ball_kick_cooldown)
					ball_kick_cooldown = result_cooldown
					SetBallKickRecovery(ball_kick_cooldown)
					changeNext_move(ball_kick_cooldown, override = TRUE)

			SEND_SIGNAL(src, COMSIG_SOUNDBREAKER_KICK_SUCCESS, target)
			SEND_SIGNAL(src, COMSIG_ATTACK_TRY_CONSUME, living_target || target, zone_selected, null, 2)
			return TRUE

		kick_success = TRUE

	if(kick_success)
		SEND_SIGNAL(src, COMSIG_SOUNDBREAKER_KICK_SUCCESS, target)
		SEND_SIGNAL(src, COMSIG_ATTACK_TRY_CONSUME, living_target || target, zone_selected, null, 2)

	OffBalance(get_special_kick_offbalance_duration(src, 3 SECONDS))
	return TRUE

/mob/living/proc/get_kick_target(atom/A)
	var/atom/target = A
	if(isturf(A))
		for(var/mob/living/M in A)
			target = M
			break
		if(target == A)
			for(var/atom/movable/AM as anything in A)
				if(AM.uses_ball_kick_recovery() || !isnull(AM.get_kick_cooldown(src)))
					target = AM
					break
	return target

/proc/get_special_kick_offbalance_duration(mob/living/user, base_duration = 3 SECONDS)
	if(!isliving(user))
		return base_duration

	var/datum/component/combo_core/martial_master/W = martial_master_get_component_safe(user)
	if(W)
		return W.GetKickOffbalanceDuration(base_duration / 4)

	var/datum/component/combo_core/soundbreaker/S = soundbreaker_get_component_safe(user)
	if(S)
		return S.GetKickOffbalanceDuration(base_duration)

	return base_duration
