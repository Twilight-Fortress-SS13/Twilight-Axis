/datum/erp_action/self/hands/milking_breasts
	abstract = FALSE

	name = "Доение груди"
	required_target_organ = SEX_ORGAN_BREASTS

	inject_timing      = INJECT_CONTINUOUS
	inject_source      = INJECT_FROM_PASSIVE
	inject_target_mode = INJECT_CONTAINER

	message_start = "{actor} берёт свою грудь в ладони и начинает медленно сжимать соски."
	message_tick = "{actor} {force} и {speed} выжимает грудь, ощущая, как она наполняется."
	message_finish = "{actor} перестаёт сжимать грудь, позволяя соскам расслабиться."
	message_climax_active =	"{actor} вздрагивает, чувствуя, как молоко обильно вырывается из груди."
