/datum/sex_panel_action/other/breasts/breast_feed
	abstract_type = FALSE
	name = "Насильное кормление"
	required_target = SEX_ORGAN_MOUTH
	stamina_cost = 0.05
	affects_self_arousal = 1.0
	affects_arousal = 0.75
	affects_self_pain = 0.01
	affects_pain = 0.005

	require_grab = TRUE
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	target_suck_sound = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} прижимает лицо {dullahan?отделенной головы :}{partner} к своей груди."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит {dullahan?отделенной :}головой {partner} по своей груди."
	message_on_finish  = "{actor} убирает {dullahan?отделенную :}голову {partner} от своей груди."
	message_on_climax_actor  = "{actor} кончает на лицо {dullahan?отделенной головы :}{partner}."
	climax_liquid_mode_active = "onto"

/datum/sex_panel_action/other/breasts/breast_feed/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/datum/sex_session_tgui/SS = get_or_create_sex_session_tgui(user, target)
	if(SS)
		var/datum/sex_organ/O = SS.resolve_organ_datum(user, SEX_ORGAN_FILTER_BREASTS)
		if(O)
			return TRUE

	return FALSE

/datum/sex_panel_action/other/breasts/breast_feed/handle_injection_feedback(mob/living/carbon/human/user, mob/living/carbon/human/target, moved)
	to_chat(user, "Я чувствую, как мои соски выплескивают молоко.")
	to_chat(target, "Я чувствую, как грудь [user] попадает мне в рот!")

/datum/sex_panel_action/other/breasts/breast_feed/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()

	if(prob(MILKING_BREAST_PROBABILITY))
		do_liquid_injection(user, target)
