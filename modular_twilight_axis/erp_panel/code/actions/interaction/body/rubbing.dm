/datum/sex_panel_action/other/body/rubbing
	abstract_type = FALSE
	name = "Тереться телом"
	required_target = null
	stamina_cost = 0.05
	affects_self_arousal	= 0.25
	affects_arousal			= 0.25
	affects_self_pain		= 0.005
	affects_pain			= 0.005

	message_on_start = "{actor} {pose} трётся телом об {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трётся телом об {partner}."
	message_on_finish = "{actor} отступает от {partner}."

	actor_make_fingering_sound = TRUE
