/datum/erp_link_rules

/// Ensures the link is safe to use (no deleted actors/organs/hosts).
/datum/erp_link_rules/proc/is_valid(datum/erp_sex_link/L)
	if(!L)
		return FALSE

	if(!L.actor_active || !L.actor_passive)
		return FALSE
	if(QDELETED(L.actor_active) || QDELETED(L.actor_passive))
		return FALSE

	if(!L.actor_active.physical || !L.actor_passive.physical)
		return FALSE

	var/mob/living/active_mob = L.actor_active.get_effect_mob()
	if(istype(active_mob) && active_mob.stat != CONSCIOUS)
		return FALSE

	if(!L.init_organ || QDELETED(L.init_organ))
		return FALSE
	if(!L.target_organ || QDELETED(L.target_organ))
		return FALSE

	if(!L.init_organ.host || QDELETED(L.init_organ.host))
		return FALSE
	if(!L.target_organ.host || QDELETED(L.target_organ.host))
		return FALSE

	return TRUE

/// Aggression flag used by templates (aggr).
/datum/erp_link_rules/proc/is_aggressive(datum/erp_sex_link/L)
	return (L && (L.force >= SEX_FORCE_HIGH))

/// Template conditional (big).
/datum/erp_link_rules/proc/has_big_breasts(datum/erp_sex_link/L)
	return L?.actor_passive?.has_big_breasts() || FALSE

/// Template conditional (dullahan).
/datum/erp_link_rules/proc/is_dullahan_scene(datum/erp_sex_link/L)
	return L?.actor_passive?.is_dullahan_scene() || FALSE

/// Template conditional (knot).
/datum/erp_link_rules/proc/is_knot_scene(datum/erp_sex_link/L)
	if(!L)
		return FALSE

	var/datum/erp_controller/C = L.session
	if(!C || QDELETED(C))
		return FALSE

	if(!C.do_knot_action)
		return FALSE

	if(!L.action)
		return FALSE

	if(L.action.has_action_tag("testicles"))
		return FALSE

	if(L.action.has_action_tag("inject_outside_only"))
		return FALSE

	if(!istype(L.init_organ, /datum/erp_sex_organ/penis))
		return FALSE

	var/datum/erp_sex_organ/penis/P = L.init_organ
	if(!P || !P.have_knot)
		return FALSE

	if(!L.target_organ || QDELETED(L.target_organ))
		return FALSE

	if(!(L.target_organ.erp_organ_type in list(
		SEX_ORGAN_VAGINA,
		SEX_ORGAN_ANUS,
		SEX_ORGAN_MOUTH
	)))
		return FALSE

	return TRUE
