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

	return list(
		ERP_ACTION_ACTIVE_AROUSAL = a_arousal,
		ERP_ACTION_ACTIVE_PAIN = a_pain,
		ERP_ACTION_PASSIVE_AROUSAL = p_arousal,
		ERP_ACTION_PASSIVE_PAIN	= p_pain,
		ERP_ACTION_LEGACY_AROUSAL = ar_legacy,
		ERP_ACTION_LEGACY_PAIN	= pa_legacy
	)

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
