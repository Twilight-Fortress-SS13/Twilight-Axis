
/datum/sex_panel_action/other/hands/milking_breasts
	abstract_type = FALSE
	name = "Доить грудь"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_target = BODY_ZONE_CHEST
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 0.5
	affects_self_pain = 0
	affects_pain = 0.02

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} кладет руки на грудь {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит руками по сиськам {partner}."
	message_on_finish  = "{actor} {pose} убирает руки от груди {partner}."

/datum/sex_panel_action/other/hands/milking_breasts/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/datum/sex_session_tgui/session_object = get_or_create_sex_session_tgui(user, target)
	if(!session_object)
		return FALSE

	var/datum/sex_organ/organ_object = session_object.resolve_organ_datum(target, SEX_ORGAN_FILTER_BREASTS)
	if(!organ_object)
		return FALSE

	var/obj/item/container = find_best_container(user, target, organ_object)
	if(container)
		return TRUE

	return FALSE

/datum/sex_panel_action/other/hands/milking_breasts/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(prob(MILKING_BREAST_PROBABILITY))
		var/list/orgs = get_action_organs(user, target, FALSE, FALSE)
		if(orgs)
			var/datum/sex_organ/boobs = orgs["target"]
			if(boobs)
				var/obj/item/container = find_best_container(user, target, boobs)
				var/moved = boobs.inject_liquid(container, user)
				if(moved > 0)
					handle_injection_feedback(user, target, moved)

/datum/sex_panel_action/other/hands/milking_breasts/handle_injection_feedback(mob/living/carbon/human/user, mob/living/carbon/human/target, moved)
	to_chat(user, "Я чувствую, как соски [target] выплескивают молоко.")
	to_chat(target, "Я чувствую, как молоко покидает мою грудь.")
