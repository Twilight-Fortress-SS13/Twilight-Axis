/datum/erp_link_math

/// Maps speed enum to multiplier.
/datum/erp_link_math/proc/get_speed_mult(speed)
	switch(speed)
		if(SEX_SPEED_LOW)     return 0.60
		if(SEX_SPEED_MID)     return 1.00
		if(SEX_SPEED_HIGH)    return 1.40
		if(SEX_SPEED_EXTREME) return 1.90
	return 1.00

/// Maps force enum to multiplier.
/datum/erp_link_math/proc/get_force_mult(force)
	switch(force)
		if(SEX_FORCE_LOW)     return 0.50
		if(SEX_FORCE_MID)     return 1.00
		if(SEX_FORCE_HIGH)    return 1.50
		if(SEX_FORCE_EXTREME) return 2.00
	return 1.00

/// Computes effective tick interval from tick_interval and speed.
/datum/erp_link_math/proc/get_effective_interval(datum/erp_sex_link/L)
	if(!L)
		return 0

	var/base = L.tick_interval
	var/m = get_speed_mult(L.speed)
	return base / m

/// Computes weight used to bias message selection.
/datum/erp_link_math/proc/get_message_weight(datum/erp_sex_link/L)
	if(!L)
		return 0
	return get_speed_mult(L.speed) + get_force_mult(L.force)
