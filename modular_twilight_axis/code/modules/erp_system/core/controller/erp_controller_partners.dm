/datum/erp_controller_partners
	var/datum/erp_controller/controller

/datum/erp_controller_partners/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Marks actor organs dirty and requests UI update.
/datum/erp_controller_partners/proc/on_anatomy_changed(datum/source)
	var/mob/living/M = source
	if(!istype(M))
		return

	var/datum/erp_actor/A = get_actor_by_mob(M)
	if(!A)
		return

	A.mark_organs_dirty()
	controller.ui?.request_update()

/// Builds partners list for UI.
/datum/erp_controller_partners/proc/get_partners_ui()
	var/list/L = list()

	if(controller.owner)
		L += list(list(
			"ref" = controller.owner.get_ref(),
			"name" = controller.owner.get_display_name(),
			"is_self" = TRUE
		))

	for(var/datum/erp_actor/A in controller.actors)
		if(!A || A == controller.owner)
			continue
		L += list(list(
			"ref" = A.get_ref(),
			"name" = A.get_display_name(),
			"is_self" = FALSE
		))

	return L

/// Adds partner atom to controller actors.
/datum/erp_controller_partners/proc/add_partner_atom(atom/target_atom, set_active = TRUE)
	if(!target_atom || QDELETED(target_atom))
		return

	for(var/datum/erp_actor/A in controller.actors)
		if(A && (A.physical == target_atom || A.active_actor == target_atom))
			if(set_active)
				controller.active_partner = A
				controller.ui?.request_update()
			return

	var/datum/erp_actor/NA = SSerp.create_actor(target_atom)
	if(!NA)
		return

	controller.actors += NA
	if(NA.can_register_signals())
		controller.register_actor_signals(NA)

	if(ismob(target_atom) && controller.owner?.get_client())
		var/mob/M = target_atom
		if(M?.client && M.client == controller.owner.get_client())
			NA.attach_client(M.client)

	if(set_active)
		controller.active_partner = NA
		controller.ui?.request_update()

/// Adds partner convenience wrapper.
/datum/erp_controller_partners/proc/add_partner(atom/target)
	if(!istype(target))
		return
	add_partner_atom(target)

/// Finds actor by physical or signal mob.
/datum/erp_controller_partners/proc/get_actor_by_mob(mob/living/M)
	if(!M)
		return null

	for(var/datum/erp_actor/A in controller.actors)
		if(A?.physical == M)
			return A

	for(var/datum/erp_actor/A2 in controller.actors)
		if(A2 && A2.get_signal_mob() == M)
			return A2

	return null

/// Sets active partner by ref.
/datum/erp_controller_partners/proc/set_active_partner_by_ref(ref)
	if(!ref)
		return FALSE

	if(controller.owner && controller.owner.get_ref() == ref)
		controller.active_partner = controller.owner
		controller.ui?.request_update()
		return TRUE

	for(var/datum/erp_actor/A in controller.actors)
		if(!A || A == controller.owner)
			continue
		if(A.get_ref() == ref)
			controller.active_partner = A
			controller.ui?.request_update()
			return TRUE

	return FALSE

/// Returns whether partner arousal is hidden.
/datum/erp_controller_partners/proc/is_partner_arousal_hidden(actor)
	if(!controller.active_partner)
		return TRUE
	if(controller.owner == controller.active_partner)
		return TRUE

	var/mob/living/owner_object = controller.owner.get_mob()
	if(!owner_object)
		return TRUE

	return !HAS_TRAIT(owner_object, TRAIT_EMPATH)
