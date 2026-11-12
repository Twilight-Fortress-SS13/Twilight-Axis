/datum/erp_actor_ui_helpers
	var/static/list/zone_translations = list(
		BODY_ZONE_HEAD              = "голову",
		BODY_ZONE_CHEST             = "туловище",
		BODY_ZONE_R_ARM             = "правую руку",
		BODY_ZONE_L_ARM             = "левую руку",
		BODY_ZONE_R_LEG             = "правую ногу",
		BODY_ZONE_L_LEG             = "левую ногу",
		BODY_ZONE_PRECISE_R_INHAND  = "правую ладонь",
		BODY_ZONE_PRECISE_L_INHAND  = "левую ладонь",
		BODY_ZONE_PRECISE_R_FOOT    = "правую ступню",
		BODY_ZONE_PRECISE_L_FOOT    = "левую ступню",
		BODY_ZONE_PRECISE_SKULL     = "лоб",
		BODY_ZONE_PRECISE_EARS      = "уши",
		BODY_ZONE_PRECISE_R_EYE     = "правый глаз",
		BODY_ZONE_PRECISE_L_EYE     = "левый глаз",
		BODY_ZONE_PRECISE_NOSE      = "нос",
		BODY_ZONE_PRECISE_MOUTH     = "рот",
		BODY_ZONE_PRECISE_NECK      = "шею",
		BODY_ZONE_PRECISE_STOMACH   = "живот",
		BODY_ZONE_PRECISE_GROIN     = "пах",
	)

/// Builds organ type filter entries for UI based on current action slots and free slots.
/datum/erp_actor_ui_helpers/proc/get_organ_type_filters_ui(datum/erp_actor/A)
	var/list/out = list()

	if(A.organs_dirty)
		A.rebuild_organs()

	for(var/type in A.action_slots)
		var/list/slots = A.action_slots[type]
		if(!islist(slots) || !slots.len)
			continue

		var/total = slots.len
		var/free = 0
		var/list/seen = list()

		for(var/datum/erp_sex_organ/O in slots)
			if(seen[O])
				continue
			seen[O] = TRUE
			free += O.get_free_slots()

		free = clamp(free, 0, total)

		out += list(list(
			"type" = "[type]",
			"name" = "[type]",
			"total" = total,
			"free" = free,
			"busy" = (free <= 0)
		))

	return out

/// Returns currently selected zone from the physical mob (or null if not a mob).
/datum/erp_actor_ui_helpers/proc/get_selected_zone(datum/erp_actor/A)
	var/atom/P = A.physical
	if(!P || !ismob(P))
		return null

	var/mob/M = P
	return M.zone_selected

/// Returns translated zone text for UI/messages.
/datum/erp_actor_ui_helpers/proc/get_zone_text(datum/erp_actor/A, zone)
	return zone_translations[zone] || "тело"

/// Returns target-zone text for current selected zone, normalized for the target actor.
/datum/erp_actor_ui_helpers/proc/get_target_zone_text_for(datum/erp_actor/A, datum/erp_actor/target_actor)
	var/zone = get_selected_zone(A)
	if(!zone)
		return "тело"

	zone = target_actor?.normalize_target_zone(zone, A) || zone
	if(target_actor)
		return get_zone_text(target_actor, zone)

	return get_zone_text(A, zone)
