/datum/sex_panel_action/other/body/grinding
	abstract_type = FALSE
	name = "Уткнуться лицом"
	required_target = null
	stamina_cost = 0.06
	affects_self_arousal	= 0.5
	affects_arousal			= 0.5
	affects_self_pain		= 0.005
	affects_pain			= 0.005

	message_on_start  = "{actor} {pose} прижимается лицом к {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трётся лицом об {zone} {partner}."
	message_on_finish = "{actor} отстраняется лицом от {partner}."

	actor_make_fingering_sound = TRUE
