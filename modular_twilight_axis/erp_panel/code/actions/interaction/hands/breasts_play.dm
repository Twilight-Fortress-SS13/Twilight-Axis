/datum/sex_panel_action/other/hands/breasts_play
	abstract_type = FALSE

	name = "Лапать грудь"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_target = BODY_ZONE_CHEST

	affects_self_arousal = 0.5
	affects_arousal = 1.0
	affects_self_pain = 0
	affects_pain = 0.01

	actor_sex_hearts = TRUE

	message_on_start   = "{actor} располагает руки на груди {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} лапает грудь {partner}."
	message_on_finish  = "{actor} убирает руки с груди {partner}."
