/datum/sex_panel_action/other/mouth/rimming
	abstract_type = FALSE
	name = "Римминг"
	required_target = SEX_ORGAN_ANUS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.01
	affects_self_arousal = 0.25
	affects_arousal = 1.0
	affects_self_pain = 0.01
	affects_pain = 0.04

	actor_sex_hearts = TRUE
	actor_suck_sound = TRUE

	message_on_start   = "{actor} {pose} припадает к крупу {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} вылизывает языком анус {partner}."
	message_on_finish  = "{actor} убирает лицо от попки {partner}."
