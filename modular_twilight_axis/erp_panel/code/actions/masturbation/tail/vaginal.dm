/datum/sex_panel_action/self/tail/vag_tail
	abstract_type = FALSE

	name = "Вагинальные игры хвостом"
	required_init = SEX_ORGAN_TAIL
	required_target = SEX_ORGAN_VAGINA
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.5
	affects_self_pain		= 0.02

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} подводит кончик хвоста к своему лону."
	message_on_perform = "{actor} {pose}, {force} и {speed} двигает хвостом внутри себя {partner}."
	message_on_finish  = "{actor} отводит хвост."
