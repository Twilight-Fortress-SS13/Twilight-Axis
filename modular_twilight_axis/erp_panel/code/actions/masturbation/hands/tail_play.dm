/datum/sex_panel_action/self/hands/tail_pet
	abstract_type = FALSE

	name = "Ласкать хвост"
	required_target = SEX_ORGAN_TAIL

	affects_self_arousal	= 0.2
	affects_self_pain = 0.005

	actor_sex_hearts = TRUE

	message_on_start   = "{actor} {pose} проводит рукой по хвосту."
	message_on_perform = "{actor} {pose}, {force} и {speed} ласкает свой хвост."
	message_on_finish  = "{actor} отпускает хвост."
