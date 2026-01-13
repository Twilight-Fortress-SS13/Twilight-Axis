/datum/sex_panel_action/other/mouth/blowjob
	abstract_type = FALSE
	name = "Минет"
	required_target = SEX_ORGAN_PENIS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.03
	affects_self_arousal = 0.25
	affects_arousal = 1.0
	affects_self_pain = 0.005
	affects_pain = 0.04

	actor_sex_hearts = TRUE
	actor_suck_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} касается губами члена {partner} и помещает его себе в рот."
	message_on_perform = "{actor} {pose}, {force} и {speed} сосёт член {partner}."
	message_on_finish  = "{actor} вытаскивает из рта член {partner}."
	message_on_climax_target = "{partner} кончает в рот {actor}."
	climax_liquid_mode_passive = "into"
