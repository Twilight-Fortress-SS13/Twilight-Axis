/datum/preferences
	var/list/erp_custom_actions = list()
	var/list/erp_kink_prefs = list()

/datum/preferences/proc/apply_erp_kinks_to_mob(mob/living/carbon/human/H)
	if(!H || !islist(erp_kink_prefs) || !erp_kink_prefs.len)
		return

	var/datum/component/kinks/K = H.GetComponent(/datum/component/kinks)
	if(!K)
		K = H.AddComponent(/datum/component/kinks)

	if(!islist(K.prefs_by_type))
		K.prefs_by_type = list()

	for(var/key in erp_kink_prefs)
		var/path = text2path(key)
		if(!ispath(path, /datum/kink))
			continue
		K.prefs_by_type[path] = clamp(round(erp_kink_prefs[key]), -1, 1)

/datum/preferences/proc/capture_erp_kinks_from_mob(mob/living/carbon/human/H)
	if(!H)
		return

	var/datum/component/kinks/K = H.GetComponent(/datum/component/kinks)
	if(!K || !islist(K.prefs_by_type))
		return

	if(!islist(erp_kink_prefs))
		erp_kink_prefs = list()
	else
		erp_kink_prefs.Cut()

	for(var/typepath in K.prefs_by_type)
		if(!ispath(typepath, /datum/kink))
			continue
		erp_kink_prefs["[typepath]"] = clamp(round(K.prefs_by_type[typepath]), -1, 1)

/datum/preferences/proc/sanitize_erp_kink_prefs()
	if(!islist(erp_kink_prefs))
		erp_kink_prefs = list()
		return

	for(var/key in erp_kink_prefs)
		if(!istext(key))
			erp_kink_prefs -= key
			continue

		var/path = text2path(key)
		if(!ispath(path, /datum/kink))
			erp_kink_prefs -= key
			continue

		var/v = erp_kink_prefs[key]
		if(!isnum(v))
			erp_kink_prefs[key] = 0
			continue

		erp_kink_prefs[key] = clamp(round(v), -1, 1)

/proc/erp_export_custom_action(datum/sex_panel_action/A)
	if(!A) return null
	if(!A.ckey || !A.custom_key) return null

	return list(
		"custom_key" = A.custom_key,
		"base_type" = A.type,
		"name" = A.name,

		"stamina_cost" = A.stamina_cost,
		"affects_self_arousal" = A.affects_self_arousal,
		"affects_arousal" = A.affects_arousal,
		"affects_self_pain" = A.affects_self_pain,
		"affects_pain" = A.affects_pain,

		"required_init" = A.required_init,
		"required_target" = A.required_target,

		"reserve_target_for_session" = A.reserve_target_for_session,
		"can_knot" = A.can_knot,
		"check_same_tile" = A.check_same_tile,
		"break_on_move" = A.break_on_move,

		"actor_sex_hearts" = A.actor_sex_hearts,
		"target_sex_hearts" = A.target_sex_hearts,

		"actor_suck_sound" = A.actor_suck_sound,
		"target_suck_sound" = A.target_suck_sound,
		"actor_make_sound" = A.actor_make_sound,
		"target_make_sound" = A.target_make_sound,
		"actor_make_fingering_sound" = A.actor_make_fingering_sound,
		"target_make_fingering_sound" = A.target_make_fingering_sound,
		"actor_do_onomatopoeia" = A.actor_do_onomatopoeia,
		"target_do_onomatopoeia" = A.target_do_onomatopoeia,
		"actor_do_thrust" = A.actor_do_thrust,
		"target_do_thrust" = A.target_do_thrust,

		"message_on_start" = A.message_on_start,
		"message_on_perform" = A.message_on_perform,
		"message_on_finish" = A.message_on_finish,
		"message_on_climax_actor" = A.message_on_climax_actor,
		"message_on_climax_target" = A.message_on_climax_target,
	)

/proc/erp_import_custom_action(list/data, ckey)
	if(!islist(data) || !ckey) 
		return null

	var/base_type = data["base_type"]
	var/custom_key = data["custom_key"]
	if(!base_type || !custom_key)
		return null

	var/base_path = base_type
	if(istext(base_type))
		base_path = text2path(base_type)

	var/datum/sex_panel_action/base = null
	base = GLOB.sex_panel_actions[base_path]
	if(!base)
		base = GLOB.sex_panel_actions["[base_path]"]
	if(!base)
		base = GLOB.sex_panel_actions["[base_type]"]

	if(!istype(base, /datum/sex_panel_action) || base.abstract_type || !base.can_be_custom)
		return null

	var/datum/sex_panel_action/custom = new base.type
	custom.abstract_type = FALSE
	custom.ckey = ckey
	custom.custom_key = custom_key
	custom.required_init = base.required_init
	custom.required_target = base.required_target
	custom.armor_slot_init = null
	custom.armor_slot_target = null
	custom.can_knot = base.can_knot
	custom.reserve_target_for_session = base.reserve_target_for_session
	custom.name = data["name"] || base.name

	custom.stamina_cost = text2num("[data["stamina_cost"]]")
	custom.affects_self_arousal = text2num("[data["affects_self_arousal"]]")
	custom.affects_arousal = text2num("[data["affects_arousal"]]")
	custom.affects_self_pain = text2num("[data["affects_self_pain"]]")
	custom.affects_pain = text2num("[data["affects_pain"]]")

	custom.required_init = data["required_init"]
	custom.required_target = data["required_target"]

	custom.reserve_target_for_session = !!data["reserve_target_for_session"]
	custom.can_knot = !!data["can_knot"]
	custom.check_same_tile = !!data["check_same_tile"]
	custom.break_on_move = !!data["break_on_move"]

	custom.actor_sex_hearts = !!data["actor_sex_hearts"]
	custom.target_sex_hearts = !!data["target_sex_hearts"]

	custom.actor_suck_sound = data["actor_suck_sound"]
	custom.target_suck_sound = data["target_suck_sound"]
	custom.actor_make_sound = data["actor_make_sound"]
	custom.target_make_sound = data["target_make_sound"]
	custom.actor_make_fingering_sound = data["actor_make_fingering_sound"]
	custom.target_make_fingering_sound = data["target_make_fingering_sound"]
	custom.actor_do_onomatopoeia = !!data["actor_do_onomatopoeia"]
	custom.target_do_onomatopoeia = !!data["target_do_onomatopoeia"]
	custom.actor_do_thrust = !!data["actor_do_thrust"]
	custom.target_do_thrust = !!data["target_do_thrust"]

	custom.message_on_start = data["message_on_start"]
	custom.message_on_perform = data["message_on_perform"]
	custom.message_on_finish = data["message_on_finish"]
	custom.message_on_climax_actor = data["message_on_climax_actor"]
	custom.message_on_climax_target = data["message_on_climax_target"]

	return custom

/datum/preferences/proc/erp_sync_from_globals(ckey)
	if(!ckey) 
		return
	erp_custom_actions = list()

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A || A.ckey != ckey) 
			continue
		erp_custom_actions += list(erp_export_custom_action(A))

/proc/erp_unregister_all_custom_for(ckey)
	if(!ckey) return
	var/list/to_remove = list()

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(A && A.ckey == ckey)
			to_remove += A

	for(var/datum/sex_panel_action/A2 in to_remove)
		unregister_custom_sex_action(A2)
		qdel(A2)

/datum/preferences/proc/erp_apply_custom_actions_to_globals(ckey)
	if(!ckey) 
		return
	erp_unregister_all_custom_for(ckey)

	if(!islist(erp_custom_actions) || !erp_custom_actions.len)
		return

	for(var/list/data in erp_custom_actions)
		var/datum/sex_panel_action/A = erp_import_custom_action(data, ckey)
		if(!A) 
			continue
		register_custom_sex_action(A)
