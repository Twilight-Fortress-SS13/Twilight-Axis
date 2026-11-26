/datum/erp_actor/mob
	parent_type = /datum/erp_actor

/datum/erp_actor/mob/New(atom/A)
	var/mob/M = A
	if(!istype(M))
		qdel(src)
		return

	. = ..(A)

	client = M.client
	post_init()

/// Returns physical as a mob if possible.
/datum/erp_actor/mob/get_mob()
	var/mob/M = physical
	return istype(M) ? M : null

/// Mob-backed actors can register signals.
/datum/erp_actor/mob/can_register_signals()
	return TRUE
