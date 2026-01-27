/datum/intent/proc/is_attack_swing()
	if(no_attack)
		return FALSE
	if(unarmed && istype(src, /datum/intent/unarmed/help))
		return FALSE
	return TRUE
