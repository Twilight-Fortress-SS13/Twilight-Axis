/datum/intent/axe/chop/heavy
	pen_guarded = PEN_MEDIUM

/datum/intent/axe/chop/heavy/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	apply_breach_pen(H)
	return ..()
