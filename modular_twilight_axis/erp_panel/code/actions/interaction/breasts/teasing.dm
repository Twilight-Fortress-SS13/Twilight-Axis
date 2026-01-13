/datum/sex_panel_action/other/breasts/teasing
	abstract_type = FALSE
	name = "Тереться грудью"
	required_target = null
	stamina_cost = 0.05
	affects_self_arousal = 1.0
	affects_arousal = 0
	affects_self_pain = 0.02
	affects_pain = 0.005

	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} припадает к {partner} грудью."
	message_on_perform = "{actor} {pose}, {force} и {speed} трется грудью об {zone} {partner}." 
	message_on_finish  = "{actor} остраняется грудью от {partner}."
