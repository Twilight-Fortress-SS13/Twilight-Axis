/datum/sex_panel_action/other/mouth/breast_feed
	abstract_type = FALSE
	name = "Облизать грудь"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_target = BODY_ZONE_CHEST
	stamina_cost = 0.02
	affects_self_arousal = 0
	affects_arousal = 1.0
	affects_self_pain = 0.005
	affects_pain = 0.02
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_suck_sound = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} касается губами груди {partner} и облизывает их языком."
	message_on_perform = "{actor} {pose}, {force} и {speed} облизывает соски {partner}."
	message_on_finish  = "{actor} убирает губы от груди {partner}."

/datum/sex_panel_action/other/mouth/breast_feed/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()

	if(prob(MILKING_BREAST_PROBABILITY))
		do_liquid_injection(user, target)

/datum/sex_panel_action/other/mouth/breast_feed/handle_injection_feedback(mob/living/carbon/human/user, mob/living/carbon/human/target, moved)
	to_chat(user, "Я чувствую, как молоко [target] попадает мне в рот!")
	to_chat(target, "Я чувствую, как мои соски выпускает молоко!")
