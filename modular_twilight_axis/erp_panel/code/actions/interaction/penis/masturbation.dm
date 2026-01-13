/datum/sex_panel_action/other/penis/masturbation
	abstract_type = FALSE

	name = "Мастурбировать на партнера"
	required_target = null
	can_knot = FALSE
	check_same_tile = FALSE

	affects_self_arousal	= 1.0
	affects_arousal			= 0
	affects_self_pain		= 0.03
	affects_pain			= 0

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} хватает свой член, смотря на {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит рукой по своему члена, направляя его на {partner}."
	message_on_finish  = "{actor} убирает руки от своего члена."
	message_on_climax_actor  = "{actor} кончает на {partner}."
	climax_liquid_mode_active = "onto"

