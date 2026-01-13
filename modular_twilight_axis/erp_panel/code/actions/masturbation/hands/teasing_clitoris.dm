/datum/sex_panel_action/self/hands/teasing_clitoris
	abstract_type = FALSE

	name = "Ласкать клитор"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 2.0
	affects_self_pain		= 0.05

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} кладет руку себе на промежность."
	message_on_perform = "{actor} {pose}, {force} и {speed} ласкает свой клитор."
	message_on_finish  = "{actor} убирает руку от своей промежности."
