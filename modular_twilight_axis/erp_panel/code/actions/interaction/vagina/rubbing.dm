/datum/sex_panel_action/other/vagina/rubbing
	abstract_type = FALSE
	name = "Тереться вагиной"
	required_target = null
	stamina_cost = 0.06
	affects_self_arousal	= 1.5
	affects_arousal			= 0.5
	affects_self_pain		= 0.01
	affects_pain			= 0.01
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} прижимается вагиной к {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трется вагиной об {zone} {partner}." 
	message_on_finish  = "{actor} уводит таз от {partner}."
