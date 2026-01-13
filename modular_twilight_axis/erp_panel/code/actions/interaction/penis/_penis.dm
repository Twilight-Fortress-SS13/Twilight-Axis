/datum/sex_panel_action/other/penis
	abstract_type = TRUE

	name = "Корневое действие членом"
	can_knot = TRUE
	required_init = SEX_ORGAN_PENIS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.3
	check_same_tile = TRUE
	var/active_knot = FALSE
	climax_liquid_mode_active = "onto"
	message_on_climax_actor		= "{actor} кончает под себя!"
	message_on_climax_target	= "{partner} кончает под себя!"

/datum/sex_panel_action/other/penis/get_pose_text(pose_state)
	switch(pose_state)
		if(SEX_POSE_BOTH_STANDING)
			return "нависая"
		if(SEX_POSE_USER_LYING)
			return "снизу"
		if(SEX_POSE_TARGET_LYING)
			return "нависая"
		if(SEX_POSE_BOTH_LYING)
			return "лежа"
