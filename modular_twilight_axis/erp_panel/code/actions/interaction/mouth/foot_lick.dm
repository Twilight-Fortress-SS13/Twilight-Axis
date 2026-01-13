/datum/sex_panel_action/other/mouth/foot_lick
	abstract_type = FALSE
	name = "Облизать ножки"
	required_target = SEX_ORGAN_LEGS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.01
	affects_self_arousal	= 0.25
	affects_arousal			= 1.0
	affects_self_pain		= 0.01
	affects_pain			= 0.03
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_suck_sound = TRUE

	message_on_start   = "{actor} {pose} припадает губами к ногам {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} лижет ножки {partner}."
	message_on_finish  = "{actor} убирает лицо с ножек {partner}."
