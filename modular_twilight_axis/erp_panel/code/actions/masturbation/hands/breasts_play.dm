/datum/sex_panel_action/self/hands/breasts_play
	abstract_type = FALSE

	name = "Лапать грудь"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_init = BODY_ZONE_CHEST

	affects_self_arousal	= 0.25
	affects_self_pain		= 0.01

	actor_sex_hearts = TRUE

	message_on_start   = "{actor} располагает руки на своей груди."
	message_on_perform = "{actor} {pose}, {force} и {speed} лапает свою грудь."
	message_on_finish  = "{actor} убирает руки со своей груди."
