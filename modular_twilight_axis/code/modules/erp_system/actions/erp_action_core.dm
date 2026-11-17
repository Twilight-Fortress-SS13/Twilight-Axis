/datum/erp_action
	var/id = null
	var/name = "Unnamed action"
	var/ckey = null
	var/abstract = FALSE

	var/required_init_organ = null
	var/required_target_organ = null
	var/reserve_target_organ = FALSE

	var/active_arousal_coeff  = 1.0
	var/passive_arousal_coeff = 1.0
	var/active_pain_coeff     = 1.0
	var/passive_pain_coeff    = 1.0

	var/inject_timing = INJECT_NONE
	var/inject_source = INJECT_FROM_ACTIVE
	var/inject_target_mode = INJECT_ORGAN

	var/require_same_tile = TRUE
	var/require_grab = FALSE
	var/allow_when_restrained = FALSE
	var/list/required_item_tags = list()
	var/list/action_tags = list()
	var/allow_sex_on_move = FALSE

	var/message_start = null
	var/message_tick = null
	var/message_finish = null
	var/message_climax_active = null
	var/message_climax_passive = null

	var/action_scope = ERP_SCOPE_OTHER

/// Calculates per-tick effect numbers for the current link based on organs, coefficients and sensitivity.
/datum/erp_action/proc/calc_effect(datum/erp_sex_link/L)
	if(!L || !L.init_organ || !L.target_organ)
		return null

	var/datum/erp_sex_organ/I = L.init_organ
	var/datum/erp_sex_organ/T = L.target_organ
	var/a_arousal = (I.active_arousal * active_arousal_coeff)
	var/a_pain    = (I.active_pain    * active_pain_coeff)
	var/p_arousal = (T.passive_arousal * passive_arousal_coeff)
	var/p_pain    = (T.passive_pain    * passive_pain_coeff)
	a_arousal *= I.sensitivity
	a_pain    *= I.sensitivity
	p_arousal *= T.sensitivity
	p_pain    *= T.sensitivity
	var/ar_legacy = (a_arousal + p_arousal) * 0.5
	var/pa_legacy = (a_pain + p_pain) * 0.5
	var/list/out = list(
		ERP_ACTION_ACTIVE_AROUSAL = a_arousal,
		ERP_ACTION_ACTIVE_PAIN = a_pain,
		ERP_ACTION_PASSIVE_AROUSAL = p_arousal,
		ERP_ACTION_PASSIVE_PAIN	= p_pain,
		ERP_ACTION_LEGACY_AROUSAL = ar_legacy,
		ERP_ACTION_LEGACY_PAIN	= pa_legacy
	)

	apply_race_body_bonus(L, out)
	return out

/// Requests an injection through the link using the action's inject settings.
/datum/erp_action/proc/handle_inject(datum/erp_sex_link/L, datum/erp_actor/who = null)
	if(!L)
		return

	var/datum/erp_sex_organ/source = null
	switch(inject_source)
		if(INJECT_FROM_ACTIVE)
			source = L.init_organ
		if(INJECT_FROM_PASSIVE)
			source = L.target_organ

	if(source)
		L.request_inject(source, inject_target_mode, who)

/datum/erp_action/proc/has_action_tag(tag)
	if(!tag || !islist(action_tags) || !action_tags.len)
		return FALSE

	return (tag in action_tags)

/datum/erp_action/proc/get_runtime_target_zone(datum/erp_sex_link/L)
	if(!L)
		return null

	var/zone = L.actor_active?.get_selected_zone()
	if(!zone)
		return null

	return L.actor_passive?.normalize_target_zone(zone, L.actor_active) || zone

/datum/erp_action/proc/get_species_zone_bonus(datum/erp_sex_link/L, zone)
	if(!L || !zone)
		return null

	var/mob/living/carbon/human/H = L.actor_passive?.get_mob()
	if(!istype(H))
		return null

	var/datum/species/S = H.dna?.species
	if(!S)
		return null

	var/list/exact_defs = GLOB.erp_race_body_zone_bonus?[S.type]
	if(islist(exact_defs) && exact_defs[zone])
		return exact_defs[zone]

	for(var/path in GLOB.erp_race_body_zone_bonus)
		if(path == S.type)
			continue
		if(istype(S, path))
			var/list/defs = GLOB.erp_race_body_zone_bonus[path]
			if(islist(defs) && defs[zone])
				return defs[zone]

	return null

/datum/erp_action/proc/apply_race_body_bonus(datum/erp_sex_link/L, list/effects)
	if(!L || !islist(effects))
		return

	if(!has_action_tag("race_body"))
		return

	var/zone = get_runtime_target_zone(L)
	if(!zone)
		return

	var/list/bonus = get_species_zone_bonus(L, zone)
	if(!islist(bonus))
		return

	var/a_ar = effects[ERP_ACTION_ACTIVE_AROUSAL] || 0
	var/p_ar = effects[ERP_ACTION_PASSIVE_AROUSAL] || 0
	var/a_pa = effects[ERP_ACTION_ACTIVE_PAIN] || 0
	var/p_pa = effects[ERP_ACTION_PASSIVE_PAIN] || 0

	p_ar += bonus["passive_arousal_add"] || 0
	p_pa += bonus["passive_pain_add"] || 0

	effects[ERP_ACTION_ACTIVE_AROUSAL] = a_ar
	effects[ERP_ACTION_PASSIVE_AROUSAL] = p_ar
	effects[ERP_ACTION_ACTIVE_PAIN] = a_pa
	effects[ERP_ACTION_PASSIVE_PAIN] = p_pa
	effects[ERP_ACTION_LEGACY_AROUSAL] = (a_ar + p_ar) * 0.5
	effects[ERP_ACTION_LEGACY_PAIN] = (a_pa + p_pa) * 0.5
