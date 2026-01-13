/datum/sex_panel_action/self/hands/fingering_anal
	abstract_type = FALSE

	name = "Фингеринг анальный"
	required_target = SEX_ORGAN_ANUS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.0
	affects_self_pain		= 0.03

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} подводит палец к анальному кольцу и вводит его."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит пальцем в своей заднице."
	message_on_finish  = "{actor} вытаскивает палец из своей попки."
