/datum/erp_actor_custom_actions_service

/// Creates a new custom action owned by this actor (client may be null).
/datum/erp_actor_custom_actions_service/proc/create_custom_action(datum/erp_actor/A)
	var/datum/erp_action/N = new
	N.id = "custom_[world.time]_[rand(1000,9999)]"
	N.name = "Новое действие"
	N.ckey = A.client?.ckey
	N.abstract = FALSE
	A.custom_actions += N
	return N

/// Returns all available actions (global + custom), excluding abstract.
/datum/erp_actor_custom_actions_service/proc/get_all_actions(datum/erp_actor/A)
	var/list/out = list()

	for(var/k in SSerp.actions)
		var/datum/erp_action/Act = SSerp.actions[k]
		if(Act.abstract)
			continue
		out += Act

	for(var/datum/erp_action/CA in A.custom_actions)
		out += CA

	return out

/// Returns a copy of custom actions list.
/datum/erp_actor_custom_actions_service/proc/get_custom_actions(datum/erp_actor/A)
	var/list/out = list()
	if(A.custom_actions && A.custom_actions.len)
		out += A.custom_actions
	return out

/// Updates a custom action field by id.
/datum/erp_actor_custom_actions_service/proc/update_custom_action(datum/erp_actor/A, action_id, field, value)
	for(var/datum/erp_action/CA in A.custom_actions)
		if(CA.id == action_id)
			return SSerp.action_prefs_codec.set_field(CA, field, value)
	return FALSE

/// Deletes a custom action by id.
/datum/erp_actor_custom_actions_service/proc/delete_custom_action(datum/erp_actor/A, action_id)
	for(var/datum/erp_action/CA in A.custom_actions)
		if(CA.id == action_id)
			A.custom_actions -= CA
			qdel(CA)
			return TRUE
	return FALSE

/// Loads custom actions from client prefs (no-op if no client/prefs).
/datum/erp_actor_custom_actions_service/proc/load_custom_actions_from_prefs(datum/erp_actor/A)
	A.custom_actions.Cut()

	var/client/C = A.client
	if(!C || !C.prefs)
		return

	var/list/data = C.prefs.erp_custom_actions
	if(!islist(data))
		return

	for(var/id in data)
		var/list/action_data = data[id]
		if(!islist(action_data))
			continue

		var/datum/erp_action/CA = new
		SSerp.action_prefs_codec.import_from_prefs(CA, action_data)
		CA.id = id
		CA.ckey = C.ckey
		CA.abstract = FALSE
		A.custom_actions += CA

/// Saves custom actions to client prefs (no-op if no client/prefs).
/datum/erp_actor_custom_actions_service/proc/save_custom_actions_to_prefs(datum/erp_actor/A)
	var/client/C = A.client
	if(!C || !C.prefs)
		return

	var/list/out = list()
	for(var/datum/erp_action/CA in A.custom_actions)
		out[CA.id] = SSerp.action_prefs_codec.export_for_prefs(CA)

	C.prefs.erp_custom_actions = out
	C.prefs.save_preferences()
