/datum/sex_panel_action/other/penis/hemi/vaginal_double
	abstract_type = FALSE

	name = "Геми-вагинальный секс"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 2.0
	affects_arousal			= 1.5
	affects_self_pain		= 0.04
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} прижимает оба ствола к вагине {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} сношает в лоно {partner} двумя стволами{knot}."
	message_on_finish  = "{actor}  вытаскивает члены из влагалища {partner}."
	message_on_climax_actor  = "{actor} кончает в лоно {partner}."
	message_on_climax_target = "{partner} кончает сжимая киску вокруг члена {actor}."
	climax_liquid_mode_active = "into"
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/penis/hemi/vaginal_double/get_knot_count()
	return 1
