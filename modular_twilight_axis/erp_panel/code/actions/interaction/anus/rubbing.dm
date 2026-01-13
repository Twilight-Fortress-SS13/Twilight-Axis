/datum/sex_panel_action/other/anus/rubbing
	abstract_type = FALSE
	name = "Тереться попой"
	required_target = null
	stamina_cost = 0.06
	affects_self_arousal = 0.25
	affects_arousal = 0.5
	affects_self_pain = 0.01
	affects_pain = 0.01
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} прижимается ягодицами к {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трется {aggr?задницей:ягодицами} об {zone} {partner}."
	message_on_finish  = "{actor} уводит круп от {partner}."
	message_on_climax_actor  = "{actor} кончает под себя."
	message_on_climax_target = "{partner} кончает под себя."
