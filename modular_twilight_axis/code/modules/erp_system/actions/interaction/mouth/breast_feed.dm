/datum/erp_action/other/mouth/breast_feed
	abstract = FALSE
	name = "Облизать грудь"
	required_target_organ = SEX_ORGAN_BREASTS
	require_same_tile = FALSE
	active_arousal_coeff  = 0.3
	passive_arousal_coeff = 0.8
	inject_timing = INJECT_CONTINUOUS
	inject_source = INJECT_FROM_PASSIVE
	inject_target_mode = INJECT_ORGAN

	message_start  = "{actor} {pose} касается губами груди {partner} и облизывает их языком."
	message_tick   = "{actor} {pose}, {force} и {speed} облизывает соски {partner}."
	message_finish = "{actor} убирает губы от груди {partner}."

	message_climax_active  = "Грудь {partner} в руках {actor} пульсирует."
	message_climax_passive = "{partner} чувствует, как грудь в руках {actor} пульсирует."
