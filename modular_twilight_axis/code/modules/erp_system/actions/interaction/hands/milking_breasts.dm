/datum/erp_action/other/hands/milking_breasts
	name = "Доить грудь"
	required_target_organ = SEX_ORGAN_BREASTS
	active_arousal_coeff  = 0.4
	passive_arousal_coeff = 0.9
	inject_timing = INJECT_CONTINUOUS
	inject_source = INJECT_FROM_PASSIVE
	inject_target_mode = INJECT_CONTAINER
	message_start  = "{actor} {pose} кладет руки на грудь {partner}."
	message_tick   = "{actor} {pose}, {force} и {speed} водит руками по груди {partner}."
	message_finish = "{actor} убирает руки от груди {partner}."
	message_climax_passive = "{partner} чувствует, как грудь отдает молоко."
