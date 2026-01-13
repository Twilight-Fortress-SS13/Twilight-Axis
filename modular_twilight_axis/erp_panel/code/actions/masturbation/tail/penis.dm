/datum/sex_panel_action/self/tail/penis_tail
	abstract_type = FALSE

	name = "Мастурбация пениса хвостом"
	required_init = SEX_ORGAN_TAIL
	required_target = SEX_ORGAN_PENIS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 2.0
	affects_self_pain		= 0.01

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} оборачивает хвост вокруг своего члена."
	message_on_perform = "{actor} {pose}, {force} и {speed} двигает хвостом по своему члену."
	message_on_finish  = "{actor} ослабляет хватку хвостом."
