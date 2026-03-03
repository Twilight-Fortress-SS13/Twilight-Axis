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
