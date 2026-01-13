/datum/sex_panel_action/other/penis/tit_job
	abstract_type = FALSE

	name = "Использовать грудь"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_target = BODY_ZONE_CHEST
	can_knot = FALSE
	
	affects_self_arousal	= 0.75
	affects_arousal			= 0.25
	affects_self_pain		= 0.01
	affects_pain			= 0.03

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} приставляет свой член между грудей {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит членом между грудей {partner}."
	message_on_finish  = "{actor} убирает член от груди {partner}."
	message_on_climax_actor  = "{actor} кончает на грудь {partner}."
	climax_liquid_mode_active = "onto"
