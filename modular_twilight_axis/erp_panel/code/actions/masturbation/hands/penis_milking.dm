/datum/sex_panel_action/self/hands/penis_milking
	abstract_type = FALSE

	name = "Доение члена"
	required_target = SEX_ORGAN_PENIS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal 	= 1.5
	affects_self_pain 		= 0.01

	actor_sex_hearts = TRUE
	actor_do_onomatopoeia = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} берёт свой член в руку."
	message_on_perform = "{actor} {pose} мастурбирует рукой свой член."
	message_on_finish  = "{actor} ослабляет хватку и останавливается."

/datum/sex_panel_action/self/hands/penis_milking/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/datum/sex_session_tgui/session_object = get_or_create_sex_session_tgui(user, target)
	if(session_object)
		var/datum/sex_organ/organ_object = session_object.resolve_organ_datum(user, SEX_ORGAN_FILTER_PENIS)
		if(organ_object)
			var/obj/item/container = organ_object.find_liquid_container()
			if(container)
				return TRUE

	return FALSE

/datum/sex_panel_action/self/hands/penis_milking/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target, is_active = TRUE)
	var/datum/sex_session_tgui/session_object = get_or_create_sex_session_tgui(user, target)
	if(session_object)
		var/datum/sex_organ/organ_object = session_object.resolve_organ_datum(user, SEX_ORGAN_FILTER_PENIS)
		if(organ_object)
			var/obj/item/container = find_best_container(user, target, organ_object)
			organ_object.inject_liquid(container, user)
			to_chat(user, "Я чувствую, как семя выплескивается наружу!")
	. = ..()
