/datum/erp_link_presenter

/// Human-readable force text for templates/UI.
/datum/erp_link_presenter/proc/get_force_text(force)
	switch(force)
		if(SEX_FORCE_LOW)     return pick(list("нежно", "заботливо", "ласково", "мягко", "осторожно"))
		if(SEX_FORCE_MID)     return pick(list("решительно", "энергично", "страстно", "уверенно", "увлеченно"))
		if(SEX_FORCE_HIGH)    return pick(list("грубо", "небрежно", "жестко", "пылко", "свирепо"))
		if(SEX_FORCE_EXTREME) return pick(list("жестоко", "неистово", "неумолимо", "свирепо", "безжалостно"))
	return "уверенно"

/// Human-readable speed text for templates/UI.
/datum/erp_link_presenter/proc/get_speed_text(speed)
	switch(speed)
		if(SEX_SPEED_LOW)     return pick(list("медленно", "неторопливо", "бережно", "тягуче", "размеренно"))
		if(SEX_SPEED_MID)     return pick(list("ритмично", "уверенно", "плавно", "напористо", "спокойно"))
		if(SEX_SPEED_HIGH)    return pick(list("быстро", "часто", "торопливо", "резко", "интенсивно"))
		if(SEX_SPEED_EXTREME) return pick(list("агрессивно", "стремительно", "бурно", "яростно", "взахлеб"))

	return "ритмично"

/// Human-readable pose text for templates/UI.
/datum/erp_link_presenter/proc/get_pose_text(pose_state)
	switch(pose_state)
		if(SEX_POSE_BOTH_STANDING)	return "стоя"
		if(SEX_POSE_USER_LYING)		return "снизу"
		if(SEX_POSE_TARGET_LYING)	return "нависая"
		if(SEX_POSE_BOTH_LYING)		return "лежа"
	return "стоя"

/// Zone text routed via actor API (single source of truth for zone normalization).
/datum/erp_link_presenter/proc/get_target_zone_text(datum/erp_sex_link/L)
	return L?.actor_active?.get_target_zone_text_for(L?.actor_passive) || "тело"

/// Minimal UI snapshot (kept fields match existing UI expectations).
/datum/erp_link_presenter/proc/get_ui_state(datum/erp_sex_link/L)
	if(!L)
		return list()

	return list(
		"active" = (L.state == LINK_STATE_ACTIVE),
		"force" = L.force,
		"speed" = L.speed,
		"pose" = L.pose_state,
		"action" = L.action?.name,
		"actor_active" = L.actor_active?.get_display_name(),
		"actor_passive" = L.actor_passive?.get_display_name()
	)

/// Message color based on force/speed (same algorithm as before).
/datum/erp_link_presenter/proc/get_message_color(datum/erp_sex_link/L)
	if(!L)
		return rgb(234, 200, 222)

	var/low_r = 234
	var/low_g = 200
	var/low_b = 222

	var/ext_r = 209
	var/ext_g = 70
	var/ext_b = 245

	var/fn = _norm_1_4(L.force)
	var/sn = _norm_1_4(L.speed)
	var/t = clamp((fn + sn) * 0.5, 0, 1)

	var/boost = 1.15
	t *= boost

	var/r = round(low_r + (ext_r - low_r) * t)
	var/g = round(low_g + (ext_g - low_g) * t)
	var/b = round(low_b + (ext_b - low_b) * t)

	r = clamp(r, 0, 255)
	g = clamp(g, 0, 255)
	b = clamp(b, 0, 255)

	return rgb(r, g, b)

/// Normalizes enum 1..4 to 0..1.
/datum/erp_link_presenter/proc/_norm_1_4(v)
	return clamp(((v || 1) - 1) / 3, 0, 1)

/// Wraps message text in a colored span (controller uses this).
/datum/erp_link_presenter/proc/spanify_sex(datum/erp_sex_link/L, text)
	if(!text)
		return null
	var/c = get_message_color(L)
	return "<span style='color:[c]; font-weight:500; font-size:75%; text-shadow: 0 1px 0 rgba(0,0,0,0.35);'>[text]</span>"
