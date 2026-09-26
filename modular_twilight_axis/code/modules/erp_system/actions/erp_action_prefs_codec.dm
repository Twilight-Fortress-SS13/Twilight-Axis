/datum/erp_action_prefs_codec

/// Applies an editor/prefs field to the action with type coercion and validation.
/datum/erp_action_prefs_codec/proc/set_field(datum/erp_action/A, field_id, value)
	switch(field_id)
		if("name", "display_name", "title")
			A.name = isnull(value) ? null : "[value]"
			return TRUE

		if("required_init_organ")
			A.required_init_organ = value
			return TRUE
		if("required_target_organ")
			A.required_target_organ = value
			return TRUE
		if("reserve_target_organ")
			A.reserve_target_organ = !!value
			return TRUE

		if("active_arousal_coeff")
			A.active_arousal_coeff = text2num("[value]")
			return TRUE
		if("passive_arousal_coeff")
			A.passive_arousal_coeff = text2num("[value]")
			return TRUE
		if("active_pain_coeff")
			A.active_pain_coeff = text2num("[value]")
			return TRUE
		if("passive_pain_coeff")
			A.passive_pain_coeff = text2num("[value]")
			return TRUE

		if("inject_timing")
			A.inject_timing = isnum(value) ? value : text2num("[value]")
			return TRUE
		if("inject_source")
			A.inject_source = isnull(value) ? INJECT_FROM_ACTIVE : "[value]"
			return TRUE
		if("inject_target_mode")
			A.inject_target_mode = isnull(value) ? INJECT_ORGAN : "[value]"
			return TRUE

		if("require_same_tile")
			A.require_same_tile = !!value
			return TRUE
		if("allow_when_restrained")
			A.allow_when_restrained = !!value
			return TRUE
		if("allow_sex_on_move")
			A.allow_sex_on_move = !!value
			return TRUE

		if("required_item_tags")
			A.required_item_tags = _coerce_string_list(value)
			return TRUE
		if("action_tags")
			A.action_tags = _coerce_string_list(value)
			return TRUE

		if("message_start")
			A.message_start = _coerce_text_or_null(value)
			return TRUE
		if("message_tick")
			A.message_tick = _coerce_text_or_null(value)
			return TRUE
		if("message_finish")
			A.message_finish = _coerce_text_or_null(value)
			return TRUE
		if("message_climax_active")
			A.message_climax_active = _coerce_text_or_null(value)
			return TRUE
		if("message_climax_passive")
			A.message_climax_passive = _coerce_text_or_null(value)
			return TRUE

		if("action_scope")
			var/n = isnum(value) ? value : text2num("[value]")
			if(n != ERP_SCOPE_SELF && n != ERP_SCOPE_OTHER)
				return FALSE
			A.action_scope = n
			return TRUE

	return FALSE

/// Coerces an arbitrary value into a text string or null (empty becomes null).
/datum/erp_action_prefs_codec/proc/_coerce_text_or_null(v)
	if(isnull(v))
		return null

	var/t = "[v]"
	if(!length(t))
		return null

	return t

/// Coerces a list-like value into a trimmed list of non-empty strings.
/datum/erp_action_prefs_codec/proc/_coerce_string_list(v)
	var/list/out = list()

	if(islist(v))
		for(var/it in v)
			if(isnull(it))
				continue
			var/t = "[it]"
			t = trim(t)
			if(length(t))
				out += t

	return out

/// Exports the action's preference fields into a serializable list.
/datum/erp_action_prefs_codec/proc/export_for_prefs(datum/erp_action/A)
	var/list/out = list()

	for(var/field in ERP_ACTION_PREF_FIELDS)
		if(!hasvar(A, field))
			continue

		var/v = A.vars[field]
		if(islist(v))
			var/list/L = v
			var/list/copy = list()
			if(L.len)
				copy += L
			out[field] = copy
		else
			out[field] = v

	return out

/// Imports preference fields from a serialized list into this action.
/datum/erp_action_prefs_codec/proc/import_from_prefs(datum/erp_action/A, list/data)
	if(!islist(data))
		return FALSE

	for(var/field in ERP_ACTION_PREF_FIELDS)
		if(!(field in data) || !hasvar(A, field))
			continue

		var/v = data[field]
		if(islist(v))
			var/list/L = v
			var/list/copy = list()
			if(L.len)
				copy += L
			A.vars[field] = copy
		else
			A.vars[field] = v

	return TRUE

/// Converts seconds to ticks (prefs/editor convenience).
/datum/erp_action_prefs_codec/proc/_seconds_to_ticks(sec)
	if(!isnum(sec))
		return 0
	return max(0, round(sec * 10))
