/datum/erp_action_message_renderer
	var/static/regex/ERP_REGEX_CONDITIONAL = regex(@"\{(\w+)\?([^:}]*):([^}]*)\}")

/// Builds a final message from a template by applying conditionals and keyword replacements.
/datum/erp_action_message_renderer/proc/build_message(template, datum/erp_sex_link/L)
	if(!template || !L || !L.action)
		return null

	var/text = "[template]"
	text = apply_conditionals(text, L)
	text = replace_keywords(text, L)
	return text

/// Applies conditional segments like {key?YES:NO} to a text using resolve_condition().
/datum/erp_action_message_renderer/proc/apply_conditionals(text, datum/erp_sex_link/L)
	var/result = text
	var/guard = 0
	while(guard++ < 50)
		var/pos = ERP_REGEX_CONDITIONAL.Find(result)
		if(!pos)
			break

		var/key = ERP_REGEX_CONDITIONAL.group[1]
		var/yes = ERP_REGEX_CONDITIONAL.group[2]
		var/no  = ERP_REGEX_CONDITIONAL.group[3]
		var/repl = resolve_condition(key, L) ? yes : no
		var/match = ERP_REGEX_CONDITIONAL.match
		var/match_len = length(match)
		result = copytext(result, 1, pos) + repl + copytext(result, pos + match_len)

	return result

/// Resolves a conditional key for message templates against the current link.
/datum/erp_action_message_renderer/proc/resolve_condition(key, datum/erp_sex_link/L)
	switch(key)
		if("aggr")
			return L.is_aggressive()
		if("big")
			return L.has_big_breasts()
		if("dullahan")
			return L.is_dullahan_scene()
	return FALSE

/// Replaces message keywords (actor/partner/force/speed/zone/pose) with runtime values from the link.
/datum/erp_action_message_renderer/proc/replace_keywords(text, datum/erp_sex_link/L)
	var/t = text
	t = replacetext(t, "{actor}", "[L.actor_active?.physical]")
	t = replacetext(t, "{partner}", "[L.actor_passive?.physical]")
	t = replacetext(t, "{force}", "[L.get_force_text()]")
	t = replacetext(t, "{speed}", "[L.get_speed_text()]")
	t = replacetext(t, "{zone}",  "[L.get_target_zone_text()]")
	t = replacetext(t, "{pose}",  "[L.get_pose_text()]")
	return t
