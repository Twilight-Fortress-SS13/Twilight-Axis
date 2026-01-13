/datum/sex_panel_action/other/tail/vaginal
	abstract_type = FALSE
	name = "Трахнуть вагину хвостом"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.06
	affects_self_arousal	= 0.75
	affects_arousal			= 1.0
	affects_self_pain		= 0.005
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} вводит хвостом в вагину {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} {aggr?сношает хвостом киску:играется хвостом в киске} {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor} выводит хвост из вагины {partner}."
	message_on_climax_target = "{partner} кончает, сжимая киской хвост {actor}."
	climax_liquid_mode_passive = "onto"
