/datum/status_effect/debuff/spell_vampire_block/proc/ta_lockout_exempt(mob/living/target)
	return TRUE

/datum/status_effect/debuff/spell_vampire_block/on_apply()
	if(ta_lockout_exempt(owner))
		return FALSE
	return ..()
