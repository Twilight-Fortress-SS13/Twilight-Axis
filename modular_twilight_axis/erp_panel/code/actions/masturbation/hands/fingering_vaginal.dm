/datum/sex_panel_action/self/hands/fingering_vaginal
	abstract_type = FALSE

	name = "Фингеринг вагинальный"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.25
	affects_self_pain		= 0.02

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} кладет руку себе на вагину, проникая пальцем."
	message_on_perform = "{actor} {pose}, {force} и {speed} двигает пальцем в вагине."
	message_on_finish  = "{actor} убирает руку от своей промежности."
