/datum/sex_panel_action/self/hands/milking_breasts
	abstract_type = FALSE

	name = "Доение груди"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_init = BODY_ZONE_CHEST

	affects_self_arousal	= 0.5
	affects_self_pain		= 0.01

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} хватает свою грудь и начинает вести к соскам."
	message_on_perform = "{actor} {pose}, {force} и {speed} выжимает свою грудь."
	message_on_finish  = "{actor} прекращает касаться груди."

/datum/sex_panel_action/self/hands/milking_breasts/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/datum/sex_session_tgui/session_object = get_or_create_sex_session_tgui(user, target)
	if(session_object)
		var/datum/sex_organ/organ_object = session_object.resolve_organ_datum(user, SEX_ORGAN_FILTER_BREASTS)
		if(organ_object)
			var/obj/item/container = organ_object.find_liquid_container()
			if(container)
				active_container = container
				return TRUE

	return FALSE

/datum/sex_panel_action/self/hands/milking_breasts/get_perform_message(mob/living/carbon/human/user,mob/living/carbon/human/target)
	var/pose_state = get_pose_key(user, target)
	var/message = "[user] [get_pose_text(pose_state)], [get_force_text()] и [get_speed_text()] выжимает свою грудь."
	show_sex_effects(user)
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)
	return spanify_force(message)

/datum/sex_panel_action/self/hands/milking_breasts/handle_injection_feedback(mob/living/carbon/human/user, mob/living/carbon/human/target, moved)
	to_chat(user, "Я чувствую, как молоко стекает из груди.")

/datum/sex_panel_action/self/hands/milking_breasts/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(QDELETED(src) || QDELETED(user) || QDELETED(target))
		return

	if(!prob(MILKING_BREAST_PROBABILITY))
		return

	var/datum/sex_organ/organ_object = user.get_sex_organ_by_type(SEX_ORGAN_BREASTS)
	if(!organ_object)
		return

	var/obj/item/container = active_container
	if(!container || QDELETED(container))
		container = organ_object.find_liquid_container()
		active_container = container

	if(!container)
		return

	do_liquid_injection(user, target)

