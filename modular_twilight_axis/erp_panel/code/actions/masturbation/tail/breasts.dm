/datum/sex_panel_action/self/tail/squeeze_breasts
	abstract_type = FALSE

	name = "Сжать грудь хвостом"
	required_init = SEX_ORGAN_TAIL
	required_target = SEX_ORGAN_BREASTS

	affects_self_arousal	= 0.75
	affects_self_pain		= 0.0

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} обвивает хвост вокруг груди."
	message_on_perform = "{actor} {pose}, {force} и {speed} сжимает хвостом грудь."
	message_on_finish  = "{actor} отпускает грудь."
