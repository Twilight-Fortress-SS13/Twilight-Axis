/datum/sex_panel_action/other
	abstract_type = TRUE
	name = "Корневое действие на другого"
	can_knot = FALSE
	interaction_timer = 2 SECONDS
	stamina_cost = 0.2

	check_incapacitated = TRUE
	check_same_tile = FALSE
	require_grab = FALSE
	required_grab_state = null

/datum/sex_panel_action/other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	if(user == target)
		return FALSE

	return TRUE
