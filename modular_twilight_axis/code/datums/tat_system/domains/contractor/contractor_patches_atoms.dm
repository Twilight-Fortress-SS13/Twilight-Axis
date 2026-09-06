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

/obj/item/equipped(mob/living/user, slot)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CONTRACTOR_ITEM_EQUIPPED, user, slot)
	return .

/obj/item/dropped(mob/living/user, silent)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CONTRACTOR_ITEM_DROPPED, user)
	return .

/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(proximity_flag && ishuman(user) && isliving(target))
		SEND_SIGNAL(user, COMSIG_ATTACK_TRY_CONSUME, target, user?.zone_selected, src)
	return .

/obj/item/melee_attack_chain(mob/user, atom/target, params)
	. = ..()
	if(ishuman(user) && isliving(target))
		SEND_SIGNAL(user, COMSIG_ATTACK_TRY_CONSUME, target, user?.zone_selected, src)
	return .
