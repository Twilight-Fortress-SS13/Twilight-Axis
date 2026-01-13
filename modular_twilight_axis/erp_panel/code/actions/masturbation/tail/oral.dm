/datum/sex_panel_action/self/tail/suck_tail
	abstract_type = FALSE

	name = "Обсосать хвост"
	required_init = SEX_ORGAN_TAIL
	required_target = SEX_ORGAN_MOUTH

	affects_self_arousal	= 0.5

	actor_sex_hearts = TRUE
	actor_suck_sound = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} подводит хвост ближе к лицу."
	message_on_perform = "{actor} {pose}, {force} и {speed} обсасывает хвост в своем рту."
	message_on_finish  = "{actor} уводит хвост от лица."
