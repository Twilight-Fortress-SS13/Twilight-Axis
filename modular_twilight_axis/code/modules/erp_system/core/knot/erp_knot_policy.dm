/datum/erp_knot_movement_policy

/// Handles movement consequences for a knot link and returns an action result code.
/datum/erp_knot_movement_policy/proc/handle_link_movement(datum/erp_knot_link/L, mob/living/mover)
	if(!L || !L.is_valid())
		return ERP_KNOT_MOVE_KEEP

	L.try_increase_strength_from_movement()

	var/mob/living/top = L.top
	var/mob/living/btm = L.btm

	var/dist = get_dist(top, btm)
	if(dist <= 1)
		L.note_activity()
		btm.face_atom(top)
		top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
		return ERP_KNOT_MOVE_KEEP

	if(dist < 6)
		L.note_activity()
		for(var/i in 1 to 3)
			step_towards(btm, top)
			if(get_dist(top, btm) <= 1)
				break
		btm.face_atom(top)
		top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
		return ERP_KNOT_MOVE_KEEP

	return ERP_KNOT_MOVE_BREAK_FORCE
