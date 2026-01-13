/datum/sex_panel_action/self/hands/fingering_oral
	abstract_type = FALSE

	name = "Фингеринг оральный"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_init = BODY_ZONE_PRECISE_MOUTH

	affects_self_arousal = 0.5
	affects_self_pain = 0.005

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} касается своих губ {dullahan?отделенной головы :}пальцем."
	message_on_perform = "{actor} {pose}, {force} и {speed} посасывает свой палец."
	message_on_finish  = "{actor} вытаскивает палец из рта {dullahan?своей отделенной головы :}."
