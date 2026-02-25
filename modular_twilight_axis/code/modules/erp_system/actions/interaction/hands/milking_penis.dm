/datum/erp_action/other/hands/milking_penis
	name = "Доить член"
	required_target_organ = SEX_ORGAN_PENIS
	active_arousal_coeff  = 0.6
	passive_arousal_coeff = 1.0
	inject_timing = INJECT_ON_FINISH
	inject_source = INJECT_FROM_PASSIVE
	inject_target_mode = INJECT_CONTAINER

	message_start  = "{actor} {pose} кладет руки на член {partner}."
	message_tick   = "{actor} {pose}, {force} и {speed} водит руками по члену {partner}."
	message_finish = "{actor} убирает руки от члена {partner}."
	message_climax_passive = "{partner} кончает в руках {actor}."
