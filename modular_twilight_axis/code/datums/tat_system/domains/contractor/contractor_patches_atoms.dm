/proc/contractor_mover_is_incorporeal(atom/movable/mover)
	if(!isliving(mover))
		return FALSE
	var/mob/living/L = mover
	var/datum/component/contractor/S = L.GetComponent(/datum/component/contractor)
	return S?.is_incorporeal_active()

/proc/contractor_refresh_invisibility_for(atom/movable/mover)
	if(!isliving(mover))
		return FALSE
	var/mob/living/L = mover
	var/datum/component/contractor/S = L.GetComponent(/datum/component/contractor)
	return S?.refresh_invisibility()

/turf/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return TRUE
	if(contractor_mover_is_incorporeal(mover))
		return TRUE
	return FALSE

/atom/movable/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return TRUE
	if(contractor_mover_is_incorporeal(mover))
		return TRUE
	return FALSE

/turf/Cross(atom/movable/mover)
	. = ..()
	if(.)
		return TRUE
	if(contractor_mover_is_incorporeal(mover))
		return TRUE
	return FALSE

/atom/movable/Cross(atom/movable/mover)
	. = ..()
	if(.)
		return TRUE
	if(contractor_mover_is_incorporeal(mover))
		return TRUE
	return FALSE

/turf/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	if(.)
		return TRUE
	if(contractor_mover_is_incorporeal(mover))
		return TRUE
	return FALSE

/mob/living/Moved(atom/old_loc, movement_dir, forced = FALSE)
	. = ..()
	contractor_refresh_invisibility_for(src)
	var/datum/component/contractor/S = src.GetComponent(/datum/component/contractor)
	S?.update_true_form_visuals()
	return .
