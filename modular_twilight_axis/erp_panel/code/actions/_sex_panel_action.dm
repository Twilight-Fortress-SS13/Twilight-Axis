/*
Общий шаблон действий

/datum/sex_panel_action/ВСТАВИТЬ_НАЗВАНИЕ_ДЕЙСТВИЯ
	abstract_type = FALSE
	name = "ВСТАВИТЬ_НАЗВАНИЕ_ДЕЙСТВИЯ"

	stamina_cost = 0.ВСТАВИТЬ_ЧИСЛО
	affects_self_arousal = 0.ВСТАВИТЬ_ЧИСЛО
	affects_arousal = 0.ВСТАВИТЬ_ЧИСЛО
	affects_self_pain = 0.ВСТАВИТЬ_ЧИСЛО
	affects_pain = 0.ВСТАВИТЬ_ЧИСЛО

	actor_sex_hearts = TRUE
	target_sex_hearts = TRUE
	actor_make_sound = TRUE
	target_make_sound = TRUE
	actor_suck_sound = TRUE
	target_suck_sound = TRUE
	actor_make_fingering_sound = TRUE
	target_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	target_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	target_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose}, {force} и {speed} {aggr?задницей:ягодицами} {dullahan?отделенной головы :}{partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} {aggr?задницей:ягодицами} {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor} {pose}, {force} и {speed} {aggr?задницей:ягодицами} {dullahan?отделенной головы :}{partner}."
	message_on_climax_actor  = "{actor} {pose}, {force} и {speed} {aggr?задницей:ягодицами} {dullahan?отделенной головы :}{partner}."
	message_on_climax_target = "{partner} {pose} {force} {speed} {aggr?задницей:ягодицами} {dullahan?отделенной головы :}{actor}."

	climax_liquid_mode_active = "self"
	climax_liquid_mode_passive = "self"

	. = ..()
*/

/datum/sex_panel_action
	/// Action name
	var/name = "Generic Action"
	/// Can be action present in panel
	abstract_type = TRUE
	/// Can action use penis knot
	var/can_knot = FALSE
	/// Sex organ requred to init action
	var/required_init
	/// Sex organ required to target
	var/required_target
	/// Armor slot that prevent action
	var/armor_slot_init
	var/armor_slot_target
	/// How long each iteration takes
	var/interaction_timer = 3 SECONDS
	/// How much stamina each iteration takes
	var/stamina_cost = 0.5
	/// Whether to check if user is incapacitated
	var/check_incapacitated = TRUE
	/// need to be on same tile
	var/check_same_tile = FALSE
	/// Whether this requires a grab
	var/require_grab = FALSE
	/// Minimum grab state required
	var/required_grab_state = GRAB_PASSIVE
	/// Can action affects self arousal?
	var/affects_self_arousal = 0
	/// Can action affects self pain?
	var/affects_self_pain = 0
	/// Can action affects target arousal?
	var/affects_arousal = 0
	/// Can action affects target pain?
	var/affects_pain = 0
	/// Get pose of partners
	var/pose_key = SEX_POSE_BOTH_STANDING
	/// Link to session data
	var/datum/sex_action_session/session
	/// Is taregt organ reserverd for action
	var/reserve_target_for_session = FALSE
	/// Active for action container
	var/obj/item/active_container = null
	/// Should action break on move
	var/break_on_move = TRUE
	/// Ckey of creator to use for
	var/ckey = null
	var/custom_key = null
	/// Variable texts for action
	var/message_on_start = null
	var/message_on_perform = null
	var/message_on_finish = null
	var/message_on_climax_actor = null
	var/message_on_climax_target = null
	/// Effect list
	var/actor_sex_hearts = FALSE
	var/target_sex_hearts = FALSE	
	var/actor_suck_sound = FALSE
	var/target_suck_sound = FALSE
	var/actor_make_sound = FALSE
	var/target_make_sound = FALSE
	var/actor_make_fingering_sound = FALSE
	var/target_make_fingering_sound = FALSE
	var/actor_do_onomatopoeia = FALSE
	var/target_do_onomatopoeia = FALSE
	var/actor_do_thrust = FALSE
	var/target_do_thrust = FALSE
	/// Available for custom
	var/can_be_custom = TRUE
	var/list/compiled_messages = null
	var/climax_liquid_mode_active = "self"
	var/climax_liquid_mode_passive = "self"

/datum/sex_panel_action/proc/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(abstract_type)
		return FALSE
	return TRUE

/datum/sex_panel_action/proc/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	SHOULD_CALL_PARENT(TRUE)

	if(!user || !target)
		return FALSE

	var/list/orgs = get_action_organs(user, target, FALSE, FALSE)
	if(!orgs || !orgs.len)
		return FALSE

	var/datum/sex_organ/init_organ   = orgs["init"]
	var/datum/sex_organ/target_organ = orgs["target"]

	var/list/to_check = list()
	if(init_organ)
		to_check += init_organ
	if(target_organ)
		to_check += target_organ

	for(var/datum/sex_organ/organ_object in to_check)
		if(!organ_object)
			continue

		var/node_id = organ_object.organ_type
		if(!node_id)
			continue

		var/mob/living/carbon/human/owner = null

		if(istype(organ_object.organ_link, /obj/item/bodypart))
			var/obj/item/bodypart/bodypart_object = organ_object.organ_link
			owner = bodypart_object.owner
		else if(istype(organ_object.organ_link, /obj/item/organ))
			var/obj/item/organ/organ_item = organ_object.organ_link
			owner = organ_item.owner

		if(!owner)
			continue

		if(owner.is_sex_node_restrained(node_id))
			return FALSE

	if(!passes_armor_check(user, target))
		return FALSE

	return TRUE

/datum/sex_panel_action/proc/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_action_context/C)
	SHOULD_CALL_PARENT(TRUE)

	if(!C || !C.link)
		return FALSE

	ensure_compiled(user, target, C)

	var/message = span_warning(get_start_message(user, target, C))
	if(message)
		C.link.send_sex_message(user, target, message)

	var/list/orgs = connect_organs(user, target)
	if((required_init || required_target) && !orgs)
		return FALSE

	return TRUE

/datum/sex_panel_action/proc/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_action_context/C)
	ensure_compiled(user, target, C)

	var/message = get_perform_message(user, target, C)
	if(message)
		C.link.send_sex_message(user, target, message)
	return

/datum/sex_panel_action/proc/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_action_context/C)
	SHOULD_CALL_PARENT(TRUE)

	if(C)
		C.compiled_messages = null
		C.compile_key = null
		C.active_container = null

	var/message = span_warning(get_finish_message(user, target, C))
	if(message)
		C?.link?.send_sex_message(user, target, message)
	else if(user)
		user.visible_message(message)

	return TRUE

/datum/sex_panel_action/proc/get_start_message(user, target, datum/sex_action_context/C)
	var/msg = C?.compiled_messages?["start"]
	if(!msg) return null
	return finalize_message(msg, user, target, C)

/datum/sex_panel_action/proc/get_perform_message(user, target, datum/sex_action_context/C)
	var/msg = C?.compiled_messages?["perform"]
	if(!msg) return null
	apply_effects(user, target, C)
	return spanify_force(finalize_message(msg, user, target, C), C)

/datum/sex_panel_action/proc/get_finish_message(user, target, datum/sex_action_context/C)
	var/msg = C?.compiled_messages?["finish"]
	if(!msg) return null
	return finalize_message(msg, user, target, C)

/datum/sex_panel_action/proc/handle_climax_message(mob/living/carbon/human/user, target, is_active = TRUE, datum/sex_action_context/C)
	var/key = is_active ? "climax_a" : "climax_t"
	var/result_mode = is_active ? climax_liquid_mode_active : climax_liquid_mode_passive

	ensure_compiled(user, target, C)

	var/msg_template = C?.compiled_messages?[key]
	if(!msg_template)
		return result_mode

	var/msg = finalize_message(msg_template, user, target, C)
	if(msg)
		user.visible_message(span_love(msg))

	return result_mode

/datum/sex_panel_action/proc/get_knot_count()
	return 0

/datum/sex_panel_action/proc/try_knot_on_climax(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_knot || !user || !target)
		return FALSE

	var/datum/component/knotting/K = user.GetComponent(/datum/component/knotting)
	if(K && K.knotted_status == KNOTTED_AS_TOP)
		return FALSE

	var/datum/sex_session_tgui/session = get_or_create_sex_session_tgui(user, target)
	if(!session)
		return FALSE

	var/force_level = session.global_force
	return SEND_SIGNAL(user, COMSIG_SEX_TRY_KNOT, target, force_level, get_knot_count())

/datum/sex_panel_action/proc/do_onomatopoeia(mob/living/carbon/human/user)
	user.balloon_alert_to_viewers("Plap!", x_offset = rand(-15, 15), y_offset = rand(0, 25))

/datum/sex_panel_action/proc/show_sex_effects(mob/living/carbon/human/user)
	for(var/i in 1 to rand(1, 3))
		if(!user.cmode)
			new /obj/effect/temp_visual/heart/sex_effects(get_turf(user))
		else
			new /obj/effect/temp_visual/heart/sex_effects/red_heart(get_turf(user))

/datum/sex_panel_action/proc/do_sound_effect(mob/living/carbon/human/user, datum/sex_action_context/C)
	var/datum/sex_action_session/L = _link(C)
	var/action_force = L ? L.force : SEX_FORCE_MID

	var/sound
	switch(action_force)
		if(SEX_FORCE_LOW, SEX_FORCE_MID)         sound = pick(SEX_SOUNDS_SLOW)
		if(SEX_FORCE_HIGH, SEX_FORCE_EXTREME)    sound = pick(SEX_SOUNDS_HARD)

	playsound(user, sound, 30, TRUE, -2, ignore_walls = FALSE)

/datum/sex_panel_action/proc/get_action_organs(mob/living/carbon/human/user, mob/living/carbon/human/target, only_free_init = TRUE, only_free_target = FALSE)

	var/datum/sex_organ/init_organ
	var/datum/sex_organ/target_organ

	if(required_init)
		init_organ = user.get_sex_organ_by_type(required_init, only_free_init)
		if(!init_organ)
			return null

	if(required_target)
		target_organ = target.get_sex_organ_by_type(required_target, only_free_target)
		if(!target_organ)
			return null

	return list(
		"init" = init_organ,
		"target" = target_organ,
	)

/datum/sex_panel_action/proc/connect_organs(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!required_init && !required_target)
		return null

	var/list/orgs = get_action_organs(user, target)
	if(!orgs)
		return FALSE

	var/datum/sex_organ/init_organ = orgs["init"]
	var/datum/sex_organ/target_organ = orgs["target"]

	if(init_organ && target_organ)
		if(!init_organ.can_start_active())
			return FALSE
		if(!init_organ.start_active(target_organ))
			return FALSE

	return orgs

/datum/sex_panel_action/proc/get_pose_key(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user || !target)
		return SEX_POSE_BOTH_STANDING

	if(user.lying && target.lying)
		return SEX_POSE_BOTH_LYING
	if(user.lying)
		return SEX_POSE_USER_LYING
	if(target.lying)
		return SEX_POSE_TARGET_LYING

	return SEX_POSE_BOTH_STANDING

/datum/sex_panel_action/proc/get_pose_text(pose_state)
	switch(pose_state)
		if(SEX_POSE_BOTH_STANDING)
			return "стоя"
		if(SEX_POSE_USER_LYING)
			return "снизу"
		if(SEX_POSE_TARGET_LYING)
			return "сверху"
		if(SEX_POSE_BOTH_LYING)
			return "лежа"

/datum/sex_panel_action/proc/get_force_text(datum/sex_action_context/C)
	var/datum/sex_action_session/L = _link(C)
	var/action_force = L ? L.force : SEX_FORCE_MID

	switch(action_force)
		if(SEX_FORCE_LOW)     return pick(list("нежно", "заботливо", "ласково", "мягко", "осторожно"))
		if(SEX_FORCE_MID)     return pick(list("решительно", "энергично", "страстно", "уверенно", "увлеченно"))
		if(SEX_FORCE_HIGH)    return pick(list("грубо", "небрежно", "жестко", "пылко", "свирепо"))
		if(SEX_FORCE_EXTREME) return pick(list("жестоко", "неистово", "неумолимо", "свирепо", "безжалостно"))

/datum/sex_panel_action/proc/get_speed_text(datum/sex_action_context/C)
	var/datum/sex_action_session/L = _link(C)
	var/action_speed = L ? L.speed : SEX_SPEED_MID

	switch(action_speed)
		if(SEX_SPEED_LOW)     return pick(list("медленно", "неторопливо", "бережно", "тягуче", "размеренно"))
		if(SEX_SPEED_MID)     return pick(list("ритмично", "уверенно", "плавно", "напористо", "спокойно"))
		if(SEX_SPEED_HIGH)    return pick(list("быстро", "часто", "торопливо", "резко", "интенсивно"))
		if(SEX_SPEED_EXTREME) return pick(list("агрессивно", "стремительно", "бурно", "яростно", "взахлеб"))

/datum/sex_panel_action/proc/spanify_force(string, datum/sex_action_context/C)
	var/datum/sex_action_session/L = _link(C)
	var/action_force = L ? L.force : SEX_FORCE_MID

	switch(action_force)
		if(SEX_FORCE_LOW)     return "<span class='love_low'>[string]</span>"
		if(SEX_FORCE_MID)     return "<span class='love_mid'>[string]</span>"
		if(SEX_FORCE_HIGH)    return "<span class='love_high'>[string]</span>"
		if(SEX_FORCE_EXTREME) return "<span class='love_extreme'>[string]</span>"

	return string

/datum/sex_panel_action/proc/get_target_zone(mob/living/user, mob/living/target)
	var/list/zone_translations = list(
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

	var/zone = user?.zone_selected
	var/ru_zone_selected = zone_translations[zone]

	if(!ru_zone_selected)
		return "тело"

	if(target && ishuman(target))
		var/mob/living/carbon/human/human_object = target

		if(zone in list(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT))
			var/has_legs = human_object.get_bodypart(BODY_ZONE_R_LEG) || human_object.get_bodypart(BODY_ZONE_L_LEG)
			if(!has_legs)
				return "туловище"

		if(zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_R_INHAND, BODY_ZONE_PRECISE_L_INHAND))
			var/has_arms = human_object.get_bodypart(BODY_ZONE_R_ARM) || human_object.get_bodypart(BODY_ZONE_L_ARM)
			if(!has_arms)
				return "туловище"

		if(zone in list(
			BODY_ZONE_HEAD,
			BODY_ZONE_PRECISE_SKULL,
			BODY_ZONE_PRECISE_EARS,
			BODY_ZONE_PRECISE_R_EYE,
			BODY_ZONE_PRECISE_L_EYE,
			BODY_ZONE_PRECISE_NOSE,
			BODY_ZONE_PRECISE_MOUTH,
			BODY_ZONE_PRECISE_NECK,
		))
			var/has_head = human_object.get_bodypart(BODY_ZONE_HEAD)
			if(!has_head)
				return "туловище"

	return ru_zone_selected

/datum/sex_panel_action/proc/do_liquid_injection(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/orgs = get_action_organs(user, target, FALSE, FALSE)
	if(!orgs) return 0

	var/datum/sex_organ/target_organ = orgs["target"]
	if(!target_organ) return 0

	var/moved = target_organ.inject_liquid()
	if(moved > 0)
		handle_injection_feedback(user, target, moved)
	return moved

/datum/sex_panel_action/proc/handle_injection_feedback(mob/living/carbon/human/user, mob/living/carbon/human/target, moved)
	return

/datum/sex_panel_action/proc/passes_armor_check(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/init_zone = armor_slot_init
	var/target_zone = armor_slot_target

	if(!init_zone && required_init)
		init_zone = sex_organ_to_zone(required_init)
	if(!target_zone && required_target)
		target_zone = sex_organ_to_zone(required_target)

	if(init_zone && user)
		if(!can_access_erp_zone(user, user, init_zone, FALSE, GRAB_PASSIVE))
			return FALSE

	if(target_zone && target)
		if(!can_access_erp_zone(user, target, target_zone, FALSE, GRAB_PASSIVE))
			return FALSE

	return TRUE

/datum/sex_panel_action/proc/get_reserved_target_organ_types()
	if(!reserve_target_for_session)
		return null

	if(required_target)
		return list(required_target)

	return null

/datum/sex_panel_action/proc/find_best_container(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_organ/organ)
	if(user)
		var/obj/item/I_left = user.get_item_for_held_index(LEFT_HANDS)
		if(istype(I_left, /obj/item/reagent_containers))
			return I_left

		var/obj/item/I_right = user.get_item_for_held_index(RIGHT_HANDS)
		if(istype(I_right, /obj/item/reagent_containers))
			return I_right

	if(organ)
		var/obj/item/final_container = organ.find_liquid_container()
		if(final_container)
			return final_container

	return null

/datum/sex_panel_action/proc/get_filter_init_organ_types()
	if(required_init)
		return list(required_init)
	return null

/datum/sex_panel_action/proc/get_filter_target_organ_types()
	if(required_target)
		return list(required_target)
	return null

/datum/sex_panel_action/proc/is_agressive_tier(datum/sex_action_context/C)
	var/datum/sex_action_session/L = _link(C)
	if(!L)
		return FALSE

	switch(L.force)
		if(SEX_FORCE_LOW, SEX_FORCE_MID) 
			return FALSE
		if(SEX_FORCE_HIGH, SEX_FORCE_EXTREME) 
			return TRUE
	return FALSE

/datum/sex_panel_action/proc/is_big_boobs(mob/living/carbon/human/check_mob)
	if(!check_mob)
		return FALSE

	var/obj/item/organ/breasts/breast_organ = check_mob.getorganslot(ORGAN_SLOT_BREASTS)
	if(!breast_organ)
		return FALSE

	if(!isnum(breast_organ.breast_size))
		return FALSE

	return breast_organ.breast_size >= BREAST_SIZE_LARGE

/datum/sex_panel_action/proc/get_knot_action(datum/sex_action_context/C)
	var/datum/sex_session_tgui/S = _tgui(C)
	if(!S)
		return ""

	if(!S.has_knotted_penis || !S.do_knot_action)
		return ""

	return " по самый узел"

/datum/sex_panel_action/proc/apply_effects(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_action_context/C)
	if(actor_do_onomatopoeia && user)
		do_onomatopoeia(user)

	if(actor_sex_hearts && user)
		show_sex_effects(user)

	if(user && actor_make_sound)
		do_sound_effect(user, C)

	if(actor_suck_sound && user)
		user.make_sucking_noise()

	if(actor_make_fingering_sound && user)
		playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	if(actor_do_thrust && user)
		do_thrust_animate(user, target)

	if(target && target_do_onomatopoeia)
		do_onomatopoeia(target)

	if(target && target_sex_hearts)
		show_sex_effects(target)

	if(target && target_make_sound)
		do_sound_effect(target, C)

	if(target && target_suck_sound)
		target.make_sucking_noise()

	if(target && target_make_fingering_sound)
		playsound(target, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	if(target && target_do_thrust)
		do_thrust_animate(target, user)

/datum/sex_panel_action/proc/apply_conditional_block(text, regex/regex_obj, flag)
	if(!text)
		return text

	var/replacement = flag ? "$1" : "$2"

	return replacetext(text, regex_obj, replacement)

/datum/sex_panel_action/proc/compile_templates(user, target, datum/sex_action_context/C)
	var/list/compiled = list()

	compiled["start"]    = preprocess_template(message_on_start, user, target, C)
	compiled["perform"]  = preprocess_template(message_on_perform, user, target, C)
	compiled["finish"]   = preprocess_template(message_on_finish, user, target, C)
	compiled["climax_a"] = preprocess_template(message_on_climax_actor, user, target, C)
	compiled["climax_t"] = preprocess_template(message_on_climax_target, user, target, C)

	return compiled

/datum/sex_panel_action/proc/preprocess_template(template, user, target, datum/sex_action_context/C)
	if(!template)
		return null

	var/is_dullahan = FALSE
	if(target && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(H.is_dullahan_head_partner())
			is_dullahan = TRUE

	var/is_aggressive = is_agressive_tier(C)
	var/is_bigboobs = is_big_boobs(user)

	var/T = "[template]"
	T = apply_conditional_block(T, SEX_REGEX_DULLAHAN, is_dullahan)
	T = apply_conditional_block(T, SEX_REGEX_AGGR, is_aggressive)
	T = apply_conditional_block(T, SEX_REGEX_BIGBREAST, is_bigboobs)

	return T

/datum/sex_panel_action/proc/finalize_message(template, user, target, datum/sex_action_context/C)
	var/t = "[template]"

	var/pose_state = get_pose_key(user, target)
	var/pose_text  = get_pose_text(pose_state)
	var/force_text = get_force_text(C)
	var/speed_text = get_speed_text(C)
	var/zone_text  = get_target_zone(user, target)
	var/knot_text  = get_knot_action(C)

	t = replacetext(t, "{actor}", "[user]")
	t = replacetext(t, "{partner}", "[target]")
	t = replacetext(t, "{pose}", "[pose_text]")
	t = replacetext(t, "{force}", "[force_text]")
	t = replacetext(t, "{speed}", "[speed_text]")
	t = replacetext(t, "{zone}", "[zone_text]")
	t = replacetext(t, "{knot}", "[knot_text]")

	return t

/datum/sex_panel_action/proc/copy_from(datum/sex_panel_action/A)
	if(!A) return

	var/list/fields = list(
		"name",
		"interaction_timer",
		"stamina_cost",
		"check_incapacitated",
		"check_same_tile",
		"require_grab",
		"required_grab_state",
		"affects_self_arousal",
		"affects_arousal",
		"affects_self_pain",
		"affects_pain",
		"required_init",
		"required_target",
		"armor_slot_init",
		"armor_slot_target",
		"can_knot",
		"reserve_target_for_session",
		"break_on_move",
		"climax_liquid_mode_active",
		"climax_liquid_mode_passive",
		"message_on_start",
		"message_on_perform",
		"message_on_finish",
		"message_on_climax_actor",
		"message_on_climax_target",
		"actor_sex_hearts",
		"target_sex_hearts",
		"actor_suck_sound",
		"target_suck_sound",
		"actor_make_sound",
		"target_make_sound",
		"actor_make_fingering_sound",
		"target_make_fingering_sound",
		"actor_do_onomatopoeia",
		"target_do_onomatopoeia",
		"actor_do_thrust",
		"target_do_thrust"
	)

	for(var/f in fields)
		src.vars[f] = A.vars[f]

/datum/sex_panel_action/proc/_link(datum/sex_action_context/C)
	return C?.link

/datum/sex_panel_action/proc/_tgui(datum/sex_action_context/C)
	var/datum/sex_action_session/L = _link(C)
	return L?.session

/datum/sex_panel_action/proc/get_compile_key(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_action_context/C)
	var/is_dullahan = FALSE
	if(target && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(H.is_dullahan_head_partner())
			is_dullahan = TRUE

	var/is_aggr = is_agressive_tier(C)
	var/is_big  = is_big_boobs(user)

	var/tpl_sig = "[message_on_start]|[message_on_perform]|[message_on_finish]|[message_on_climax_actor]|[message_on_climax_target]"
	return "[tpl_sig]::d=[is_dullahan]::a=[is_aggr]::b=[is_big]"

/datum/sex_panel_action/proc/ensure_compiled(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/sex_action_context/C)
	if(!C)
		return

	var/key = get_compile_key(user, target, C)
	if(C.compiled_messages && C.compile_key == key)
		return

	C.compile_key = key

	if(message_on_start || message_on_perform || message_on_finish || message_on_climax_actor || message_on_climax_target)
		C.compiled_messages = compile_templates(user, target, C)
	else
		C.compiled_messages = null
