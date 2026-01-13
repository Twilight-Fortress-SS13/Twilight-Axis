/datum/sex_panel_action/other/penis/hemi/anal_double
	abstract_type = FALSE

	name = "Геми-анальный секс"
	required_target = SEX_ORGAN_ANUS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal = 2.0
	affects_arousal = 1.25
	affects_self_pain = 0.04
	affects_pain = 0.01
	can_knot = TRUE

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} прижимает оба ствола к анусу {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} сношает в попку {partner} двумя стволами{knot}."
	message_on_finish  = "{actor} вытаскивает члены из влагалища {partner}."
	message_on_climax_actor  = "{actor} кончает в попку {partner}."
	message_on_climax_target = "{partner} кончает сжимая анус вокруг членов {actor}."
	climax_liquid_mode_active = "into"
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/penis/hemi/anal_double/get_knot_count()
	return 1
