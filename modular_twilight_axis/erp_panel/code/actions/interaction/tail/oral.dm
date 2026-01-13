/datum/sex_panel_action/other/tail/oral
	abstract_type = FALSE
	name = "Трахнуть рот хвостом"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH
	stamina_cost = 0.06
	affects_self_arousal	= 0.25
	affects_arousal			= 1.0
	affects_self_pain		= 0.005
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	target_suck_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose}, {force} и {speed} проникает хвостом в рот {dullahan?отделенной головы :}{partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} сношает хвостом рот {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor} {pose}, {force} и {speed} выводит хвост из рта {dullahan?отделенной головы :}{partner}."
