/datum/sex_panel_action/self
	abstract_type = TRUE
	name = "Корневое действие на себя"
	can_knot = FALSE
	interaction_timer = 2 SECONDS
	stamina_cost = 0.2

	check_incapacitated = TRUE
	check_same_tile = FALSE
	require_grab = FALSE
	required_grab_state = null
	actor_make_sound = TRUE
	message_on_climax_actor  = "{actor} оставляет под собой беспорядок."

/datum/sex_panel_action/self/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	if(user != target)
		return FALSE

	return TRUE
