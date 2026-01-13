/datum/sex_panel_action/other/penis/rubbing
	abstract_type = FALSE

	name = "Тереться членом"
	required_target = SEX_ORGAN_ANUS
	armor_slot_target = null
	can_knot = FALSE
	check_same_tile = FALSE

	affects_self_arousal	= 0.75
	affects_arousal			= 0.25
	affects_self_pain		= 0.01
	affects_pain			= 0.03

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} приставляет свой член к коже {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трётся об {zone} {partner}."
	message_on_finish  = "{actor} убирает член от кожи {partner}."
	message_on_climax_actor  = "{actor} кончает на {partner}."
