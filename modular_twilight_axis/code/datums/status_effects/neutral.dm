/datum/status_effect/ball_kick_recovery
	id = "ball_kick_recovery"
	duration = 1 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/cooldown = 1 SECONDS

/datum/status_effect/ball_kick_recovery/on_creation(mob/living/new_owner, set_cooldown)
	if(isnum(set_cooldown) && set_cooldown > 0)
		cooldown = set_cooldown
		duration = cooldown
	return ..()

/mob/living/proc/SetBallKickRecovery(amount)
	if(!isnum(amount) || amount <= 0)
		return null

	var/datum/status_effect/ball_kick_recovery/recovery = has_status_effect(STATUS_EFFECT_BALL_KICK_RECOVERY)
	if(recovery)
		recovery.cooldown = amount
		recovery.duration = world.time + amount
		return recovery

	return apply_status_effect(STATUS_EFFECT_BALL_KICK_RECOVERY, amount)
