/datum/sex_panel_action/other/hands/finger_anal
	abstract_type = FALSE
	name = "Фингеринг ануса"
	required_target = SEX_ORGAN_ANUS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 0.5
	affects_self_pain = 0
	affects_pain = 0.01

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} касается пальцами анального кольца {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} проникает пальцем в анус {partner}."
	message_on_finish  = "{actor} убирает пальцы от ануса {partner}."
	message_on_climax_target = "{partner} кончает, сжимая попкой палец {actor}."
	climax_liquid_mode_passive = "onto"
