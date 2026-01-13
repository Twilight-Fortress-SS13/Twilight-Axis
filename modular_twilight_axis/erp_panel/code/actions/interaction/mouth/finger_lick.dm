/datum/sex_panel_action/other/mouth/finger_lick
	abstract_type = FALSE
	name = "Облизать пальцы"
	required_target = SEX_ORGAN_HANDS
	stamina_cost = 0.01
	affects_self_arousal	= 0.25
	affects_arousal			= 0.5
	affects_self_pain		= 0.01
	affects_pain			= 0.01
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	target_sex_hearts = TRUE
	actor_make_sound = TRUE
	target_make_sound = TRUE
	actor_suck_sound = TRUE
	target_suck_sound = TRUE
	actor_make_fingering_sound = TRUE
	target_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	target_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	target_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} помещает в рот палец {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} облизывает палец {partner}."
	message_on_finish  = "{actor} вытаскивает из рта палец {partner}."
