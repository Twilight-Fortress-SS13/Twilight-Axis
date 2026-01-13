/datum/sex_panel_action/other/vagina/masturbation
	abstract_type = FALSE

	name = "Мастурбировать на партнера"
	required_target = null
	armor_slot_init = BODY_ZONE_PRECISE_GROIN
	check_same_tile = FALSE

	affects_self_arousal	= 1.0
	affects_arousal			= 0
	affects_self_pain		= 0.03
	affects_pain			= 0

	actor_sex_hearts = TRUE
	actor_do_onomatopoeia = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} трёт свою промежность, смотря на {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит рукой по своему клитору, направляя пах на {partner}."
	message_on_finish  = "{actor} убирает руки от своего лона."
	message_on_climax_actor  = "{actor} кончает на {partner}."
