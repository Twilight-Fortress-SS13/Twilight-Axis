/datum/sex_panel_action/self/tail/anal_tail
	abstract_type = FALSE

	name = "Анальные игры хвостом"
	required_init = SEX_ORGAN_TAIL
	required_target = SEX_ORGAN_ANUS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.5
	affects_self_pain		= 0.03

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} изгибает свой хвост, кончик поводя к своей попке."
	message_on_perform = "{actor} {pose}, {force} и {speed} двигает хвостом в своей заднице."
	message_on_finish  = "{actor} прекращает движение хвостом."
