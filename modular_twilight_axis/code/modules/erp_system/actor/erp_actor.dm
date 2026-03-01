/datum/erp_actor
	var/atom/active_actor
	var/atom/physical
	var/client/client
	var/list/datum/erp_sex_organ/organs = list()
	var/list/organs_by_type = list()
	var/list/action_slots = list()
	var/organs_dirty = TRUE
	var/datum/weakref/surrender_ref
	var/list/datum/erp_action/custom_actions = list()
	var/datum/weakref/effect_mob_ref

/datum/erp_actor/New(atom/A)
	. = ..()
	if(!A)
		qdel(src)
		return

	active_actor = A
	physical = A
	client = null

/// Performs initial setup after the actor is created and has its client/effect context wired.
/datum/erp_actor/proc/post_init()
	rebuild_organs()
	load_custom_actions_from_prefs()

/// Rebuilds organ caches and action slot maps for this actor.
/datum/erp_actor/proc/rebuild_organs()
	organs.Cut()
	organs_by_type.Cut()
	action_slots.Cut()

	if(!active_actor || !physical)
		organs_dirty = FALSE
		return

	collect_organs()
	collect_species_overrides()
	sort_organs_by_ui_order()

	for(var/datum/erp_sex_organ/O in organs)
		var/type = O.erp_organ_type
		if(!type)
			continue

		if(!organs_by_type[type])
			organs_by_type[type] = list()
		organs_by_type[type] += O

	build_action_slots()
	organs_dirty = FALSE

/// Hook: Collects organs from the underlying entity (implemented in subtypes).
/datum/erp_actor/proc/collect_organs()
	return

/// Hook: Ensures baseline "species" organs exist (body/hands/legs).
/datum/erp_actor/proc/collect_species_overrides()
	if(!physical)
		return

	var/datum/erp_sex_organ/body/B = get_or_create_body_organ()
	if(!(B in organs))
		add_organ(B)

	var/datum/erp_sex_organ/hand/H = get_or_create_hands_organ()
	if(!(H in organs))
		add_organ(H)

	var/datum/erp_sex_organ/legs/L = get_or_create_legs_organ()
	if(!(L in organs))
		add_organ(L)

/// Returns an existing BODY organ or creates a new one.
/datum/erp_actor/proc/get_or_create_body_organ()
	for(var/datum/erp_sex_organ/O in organs)
		if(O.erp_organ_type == SEX_ORGAN_BODY)
			return O

	var/datum/erp_sex_organ/body/B = new(physical)
	B.erp_organ_type = SEX_ORGAN_BODY
	return B

/// Returns an existing HANDS organ or creates a new one.
/datum/erp_actor/proc/get_or_create_hands_organ()
	for(var/datum/erp_sex_organ/O in organs)
		if(O.erp_organ_type == SEX_ORGAN_HANDS)
			return O

	var/datum/erp_sex_organ/hand/H = new(physical)
	H.erp_organ_type = SEX_ORGAN_HANDS
	return H

/// Returns an existing LEGS organ or creates a new one.
/datum/erp_actor/proc/get_or_create_legs_organ()
	for(var/datum/erp_sex_organ/O in organs)
		if(O.erp_organ_type == SEX_ORGAN_LEGS)
			return O

	var/datum/erp_sex_organ/legs/L = new(physical)
	L.erp_organ_type = SEX_ORGAN_LEGS
	return L

/// Adds an organ to this actor (applies prefs when possible).
/datum/erp_actor/proc/add_organ(datum/erp_sex_organ/O)
	if(!O || QDELETED(O))
		return
	if(O in organs)
		return

	organs += O
	if(client && client.prefs)
		O.apply_prefs_if_possible()

/// Builds the organ-slot map used to reserve "action slots" per organ type.
/datum/erp_actor/proc/build_action_slots()
	for(var/datum/erp_sex_organ/O in organs)
		var/t = O.erp_organ_type
		if(!t)
			continue
		if(!action_slots[t])
			action_slots[t] = list()

		var/count = max(1, O.count_to_action)
		for(var/i = 1 to count)
			action_slots[t] += O

/// Returns the raw action slots list for a given organ type (rebuilds if dirty).
/datum/erp_actor/proc/get_action_slots_ref(erp_organ_type)
	if(organs_dirty)
		rebuild_organs()
	return action_slots[erp_organ_type] || list()

/// Returns unique organs of a type that have at least one free slot.
/datum/erp_actor/proc/get_free_action_organs(erp_organ_type)
	var/list/out = list()
	var/list/slots = get_action_slots_ref(erp_organ_type)
	if(!islist(slots) || !slots.len)
		return out

	var/list/seen = list()
	for(var/datum/erp_sex_organ/O in slots)
		if(!O || QDELETED(O) || seen[O])
			continue
		seen[O] = TRUE
		if(O.get_free_slots() > 0)
			out += O

	return out

/// Returns organs list (all or by type), rebuilding caches if dirty.
/datum/erp_actor/proc/get_organs_ref(erp_organ_type = null)
	if(organs_dirty)
		rebuild_organs()

	if(!erp_organ_type)
		return organs
	return organs_by_type[erp_organ_type] || list()

/// Marks organ caches as dirty to be rebuilt on next access.
/datum/erp_actor/proc/mark_organs_dirty()
	organs_dirty = TRUE

/// Resolves an organ by UI id (\ref string) or direct reference.
/datum/erp_actor/proc/get_organ_by_id(id)
	if(!id)
		return null

	for(var/datum/erp_sex_organ/O in get_organs_ref())
		if("\ref[O]" == id || O == id)
			return O

	return null

/// Checks whether this actor is surrendering to another actor.
/datum/erp_actor/proc/is_surrendering_to(datum/erp_actor/other)
	var/datum/erp_actor/A = surrender_ref?.resolve()
	if(!A || QDELETED(A))
		surrender_ref = null
		return FALSE
	return A == other

/// Hook: Returns restraint status (implemented in subtypes).
/datum/erp_actor/proc/is_restrained(organ_flags = null)
	return FALSE

/// Hook: Returns whether the actor has a kink tag (implemented in subtypes).
/datum/erp_actor/proc/has_kink_tag(kink_typepath)
	return FALSE

/// Sends ERP effect into the world through the effects bridge (headless-safe).
/datum/erp_actor/proc/apply_erp_effect(arousal_amt, pain_amt, giving, applied_force = SEX_FORCE_MID, applied_speed = SEX_SPEED_MID, organ_id = null)
	var/mob/living/M = get_effect_mob()
	if(!M)
		return

	SEND_SIGNAL(M, COMSIG_SEX_RECEIVE_ACTION, arousal_amt, pain_amt, giving, applied_force, applied_speed, organ_id)

/// Creates a new custom action owned by this actor (prefs-aware, but headless-safe).
/datum/erp_actor/proc/create_custom_action()
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	return S ? S.create_custom_action(src) : null

/// Returns all available actions for this actor (global + custom).
/datum/erp_actor/proc/get_all_actions()
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	return S ? S.get_all_actions(src) : list()

/// Returns custom actions list copy.
/datum/erp_actor/proc/get_custom_actions()
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	return S ? S.get_custom_actions(src) : list()

/// Updates a custom action field by id.
/datum/erp_actor/proc/update_custom_action(action_id, field, value)
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	return S ? S.update_custom_action(src, action_id, field, value) : FALSE

/// Deletes a custom action by id.
/datum/erp_actor/proc/delete_custom_action(action_id)
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	return S ? S.delete_custom_action(src, action_id) : FALSE

/// Loads custom actions from prefs if a client exists.
/datum/erp_actor/proc/load_custom_actions_from_prefs()
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	if(S)
		S.load_custom_actions_from_prefs(src)

/// Saves custom actions to prefs if a client exists.
/datum/erp_actor/proc/save_custom_actions_to_prefs()
	var/datum/erp_actor_custom_actions_service/S = SSerp.actor_custom_actions
	if(S)
		S.save_custom_actions_to_prefs(src)

/// Builds organ type filters payload for UI (headless-safe if UI layer isn't used).
/datum/erp_actor/proc/get_organ_type_filters_ui()
	var/datum/erp_actor_ui_helpers/U = SSerp.actor_ui_helpers
	return U ? U.get_organ_type_filters_ui(src) : list()

/// Hook: Returns whether actor has big breasts (implemented in subtypes).
/datum/erp_actor/proc/has_big_breasts()
	return FALSE

/// Hook: Returns whether current scene is dullahan-specific (implemented in subtypes).
/datum/erp_actor/proc/is_dullahan_scene()
	return FALSE

/// Returns currently selected zone from the underlying mob (UI helper).
/datum/erp_actor/proc/get_selected_zone()
	var/datum/erp_actor_ui_helpers/U = SSerp.actor_ui_helpers
	return U ? U.get_selected_zone(src) : null

/// Returns translated zone text (UI helper).
/datum/erp_actor/proc/get_zone_text(zone)
	var/datum/erp_actor_ui_helpers/U = SSerp.actor_ui_helpers
	return U ? U.get_zone_text(src, zone) : "тело"

/// Hook: Allows target actor to normalize an incoming zone selection.
/datum/erp_actor/proc/normalize_target_zone(zone, datum/erp_actor/other_actor)
	return zone

/// Returns translated target-zone text for UI/messages (UI helper).
/datum/erp_actor/proc/get_target_zone_text_for(datum/erp_actor/target_actor)
	var/datum/erp_actor_ui_helpers/U = SSerp.actor_ui_helpers
	return U ? U.get_target_zone_text_for(src, target_actor) : "тело"

/// Builds a climax result payload (UI helper).
/datum/erp_actor/proc/build_climax_result(datum/erp_sex_link/L)
	if(!L)
		return null

	var/is_active = (L.actor_active == src)

	var/datum/erp_actor/partner_actor = is_active ? L.actor_passive : L.actor_active
	var/partner_mob = partner_actor?.get_mob()
	if(is_active)
		var/mode = "outside"
		if(L.session)
			var/datum/erp_sex_organ/penis/P = L.session.get_owner_penis_organ()
			if(P && P.climax_mode)
				mode = "[P.climax_mode]"

		if(mode == "inside")
			return list("type" = "inside", "partner" = partner_mob, "intimate" = TRUE)

		return list("type" = "outside", "partner" = partner_mob, "intimate" = FALSE)

	return list("type" = "self", "partner" = partner_mob, "intimate" = FALSE)

/// Returns a stable ref id for UI payloads.
/datum/erp_actor/proc/get_ref()
	return "\ref[src]"

/// Returns physical as movable if possible.
/datum/erp_actor/proc/get_movable()
	return istype(physical, /atom/movable) ? physical : null

/// Returns physical as mob if possible.
/datum/erp_actor/proc/get_mob()
	return ismob(physical) ? physical : null

/// Checks whether requester is the owner client for this actor.
/datum/erp_actor/proc/is_owner_client(mob/requester)
	if(!requester)
		return FALSE
	return requester.client && requester.client == get_client()

/// Returns the turf this actor is currently on.
/datum/erp_actor/proc/get_actor_turf()
	var/atom/A = physical
	return A ? get_turf(A) : null

/// Sends a visible message through the effects bridge.
/datum/erp_actor/proc/send_visible_message(text)
	if(!text)
		return FALSE

	var/mob/living/M = get_effect_mob()
	if(!M || QDELETED(M))
		return FALSE

	M.visible_message(text)
	return TRUE

/// Sends a private message through the effects bridge.
/datum/erp_actor/proc/send_private_message(text)
	if(!text)
		return FALSE

	var/mob/living/M = get_effect_mob()
	if(!M || QDELETED(M))
		return FALSE

	to_chat(M, text)
	return TRUE

/// Hook: Adds stamina (implemented in subtypes).
/datum/erp_actor/proc/stamina_add(delta)
	return

/// Hook: Returns highest grab state on another actor (implemented in subtypes).
/datum/erp_actor/proc/get_highest_grab_state_on(datum/erp_actor/other)
	return 0

/// Hook: Whether this actor can register signals with mob systems (implemented in subtypes).
/datum/erp_actor/proc/can_register_signals()
	return FALSE

/// Hook: Checks if an organ type is accessible to another actor (implemented in subtypes).
/datum/erp_actor/proc/is_organ_accessible_for(datum/erp_actor/by_actor, organ_type, allow_force = FALSE)
	return TRUE

/// Hook: Whether actor has testicles (implemented in subtypes).
/datum/erp_actor/proc/has_testicles()
	return FALSE

/// Sets an alternate effect mob target for signals/messages.
/datum/erp_actor/proc/set_effect_mob(mob/living/M)
	if(M && !QDELETED(M))
		effect_mob_ref = WEAKREF(M)
	else
		effect_mob_ref = null

/// Returns effect mob if present, otherwise physical mob.
/datum/erp_actor/proc/get_effect_mob()
	var/mob/living/M = effect_mob_ref?.resolve()
	if(M && !QDELETED(M))
		return M
	return get_mob()

/// Returns mob used for signaling (defaults to effect mob).
/datum/erp_actor/proc/get_signal_mob()
	return get_effect_mob()

/// Returns best mob for control context (physical mob, effect mob, or client mob).
/datum/erp_actor/proc/get_control_mob(client/C = null)
	var/mob/living/M = get_mob()
	if(M)
		return M

	M = get_effect_mob()
	if(M)
		return M

	return C?.mob

/// Attaches a client to this actor (optional, can be null in headless scenarios).
/datum/erp_actor/proc/attach_client(client/C)
	client = C

/// Returns a display name for UI/logging.
/datum/erp_actor/proc/get_display_name()
	var/atom/A = physical || active_actor
	if(A)
		return "[A]"
	return "unknown"

/// Returns TRUE if this actor is backed by a mob.
/datum/erp_actor/proc/is_mob()
	return ismob(physical)

/// Returns client explicitly attached, otherwise client of physical mob.
/datum/erp_actor/proc/get_client()
	if(client)
		return client
	return (ismob(physical) ? (physical:client) : null)

/// Sorts organs by UI order, keeping unknown types at the end.
/datum/erp_actor/proc/sort_organs_by_ui_order()
	if(!islist(organs) || !organs.len)
		return

	var/list/ordered = list()
	var/list/used = list()

	for(var/t in ERP_ORGAN_ORDER)
		for(var/datum/erp_sex_organ/O in organs)
			if(!O || QDELETED(O) || used[O])
				continue
			if(O.erp_organ_type == t)
				ordered += O
				used[O] = TRUE

	for(var/datum/erp_sex_organ/O2 in organs)
		if(!O2 || QDELETED(O2) || used[O2])
			continue
		ordered += O2
		used[O2] = TRUE

	organs = ordered
