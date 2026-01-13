/datum/sex_panel_action/other/legs/teasing
	abstract_type = FALSE
	name = "Тереться ногой"
	required_target = null
	stamina_cost = 0.05
	affects_self_arousal	= 0
	affects_arousal			= 1.25
	affects_self_pain		= 0
	affects_pain			= 0.01
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} укладывает свою ногу на {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трётся ногой об {zone} {partner}."
	message_on_finish  = "{actor} убирает ногу от {partner}."
