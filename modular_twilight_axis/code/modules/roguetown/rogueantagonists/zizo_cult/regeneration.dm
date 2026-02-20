/obj/effect/proc_holder/spell/self/zizo_regenerate
	name = "Regenerate"
	desc = "Your wounds painfully mend back together."
	overlay_state = "bloodrage"
	recharge_time = 1 MINUTES
	invocations = list("AHH, SO HURT!!"
	)
	invocation_type = "shout"
	sound = 'sound/misc/vampirespell.ogg'
	releasedrain = 30
	antimagic_allowed = FALSE
	ignore_cockblock = TRUE
	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown,)

/obj/effect/proc_holder/spell/self/zizo_regenerate/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	H.adjustBruteLoss(-100)
	H.adjustFireLoss(-100)
	H.adjustToxLoss(-100)
	if(H.resting)
		H.set_resting(FALSE, FALSE)
	H.emote("warcry")
	for(var/effect in purged_effects)
		H.remove_status_effect(effect)
	return TRUE
