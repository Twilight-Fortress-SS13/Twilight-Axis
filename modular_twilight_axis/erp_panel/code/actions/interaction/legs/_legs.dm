/datum/sex_panel_action/other/legs
	abstract_type = TRUE
	name = "Корневое действие ногами"
	required_init = SEX_ORGAN_LEGS

	stamina_cost = 0.3
	check_same_tile = TRUE

	actor_sex_hearts = TRUE
	target_sex_hearts = TRUE
	actor_make_sound = TRUE
	target_make_sound = TRUE
	actor_suck_sound = TRUE
	target_suck_sound = TRUE
	actor_make_fingering_sound = TRUE
	target_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	target_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	target_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_climax_actor  = "{actor} кончает под себя."
	message_on_climax_target = "{partner} кончает под себя."
