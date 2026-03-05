SUBSYSTEM_DEF(erp)
	name = "ERP System"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_DEFAULT

	var/list/datum/erp_action/actions = list()
	var/list/datum/erp_sex_organ/organs = list()
	var/list/datum/erp_controller/controllers = list()
	var/list/decaying_knotting = list()

	// Services (created once in Initialize)
	var/datum/erp_actor_custom_actions_service/actor_custom_actions
	var/datum/erp_actor_ui_helpers/actor_ui_helpers
	var/datum/erp_actor_effects_bridge/actor_effects_bridge
	var/datum/erp_organ_prefs_service/organ_prefs_service
	var/datum/erp_organ_spill_policy/organ_spill_policy
	var/datum/erp_organ_inject_router/organ_inject_router
	var/datum/erp_actor_factory/actor_factory
	var/datum/erp_consent_resolver/consent_resolver
	var/datum/erp_ui_catalog/ui_catalog
	var/datum/erp_link_rules/link_rules
	var/datum/erp_link_math/link_math
	var/datum/erp_link_presenter/link_presenter
	var/datum/erp_action_prefs_codec/action_prefs_codec
	var/datum/erp_action_editor_schema/action_editor_schema
	var/datum/erp_action_message_renderer/action_message_renderer
	var/datum/erp_knot_effects/knot_effects
	var/datum/erp_knot_rules/knot_rules
	var/datum/erp_knot_movement_policy/knot_movement_policy

/datum/controller/subsystem/erp/Initialize(timeofday)
	. = ..()

	actions = list()

	// Services init
	actor_custom_actions = new
	actor_ui_helpers = new
	organ_prefs_service = new
	organ_spill_policy = new
	organ_inject_router = new
	actor_factory = new
	consent_resolver = new
	ui_catalog = new
	link_rules = new
	link_math = new
	link_presenter = new
	action_prefs_codec = new
	action_editor_schema = new
	action_message_renderer = new
	knot_effects = new
	knot_rules = new
	knot_movement_policy = new

	for(var/path in subtypesof(/datum/erp_action))
		var/datum/erp_action/A = new path
		if(A.abstract)
			qdel(A)
			continue

		if(!A.id)
			A.id = "[path]"

		actions[path] = A

/// Registers an organ for subsystem ticking.
/datum/controller/subsystem/erp/proc/register_organ(datum/erp_sex_organ/O)
	if(O && !(O in organs))
		organs += O

/// Unregisters an organ from ticking.
/datum/controller/subsystem/erp/proc/unregister_organ(datum/erp_sex_organ/O)
	organs -= O

/datum/controller/subsystem/erp/fire(resumed)
	for(var/i = organs.len; i >= 1; i--)
		var/datum/erp_sex_organ/O = organs[i]
		if(!O || QDELETED(O))
			organs.Cut(i, i + 1)
			continue
		O.process()

	for(var/i = controllers.len; i >= 1; i--)
		var/datum/erp_controller/C = controllers[i]
		if(!C || QDELETED(C))
			controllers.Cut(i, i + 1)
			continue
		C.process_links()

	for(var/i = decaying_knotting.len; i >= 1; i--)
		var/datum/component/erp_knotting/K = decaying_knotting[i]
		if(!K || QDELETED(K) || !K.next_decay_at)
			decaying_knotting.Cut(i, i + 1)
			continue

		if(world.time >= K.next_decay_at)
			K.process_decay()
			if(K && !QDELETED(K) && K.next_decay_at) // если не stop_decay()
				K.next_decay_at = world.time + ERP_KNOT_DECAY_TICK

/// Registers a controller into subsystem list.
/datum/controller/subsystem/erp/proc/register_controller(datum/erp_controller/C)
	if(C && !(C in controllers))
		controllers += C

/// Unregisters a controller.
/datum/controller/subsystem/erp/proc/unregister_controller(datum/erp_controller/C)
	controllers -= C

/// Returns the action datum by typepath or text typepath.
/datum/controller/subsystem/erp/proc/get_action(action_type)
	if(!action_type)
		return null

	var/path = action_type
	if(istext(path))
		path = text2path(path)

	return actions[path]

/// Finds controller for initiator atom if any.
/datum/controller/subsystem/erp/proc/get_controller_for(atom/initiator_atom)
	if(!initiator_atom)
		return null

	for(var/datum/erp_controller/EC in controllers)
		if(!EC || QDELETED(EC))
			continue
		if(EC.owner?.active_actor == initiator_atom)
			return EC

	return null

/// Creates a controller (client optional: allow headless scenes).
/datum/controller/subsystem/erp/proc/create_controller(atom/initiator_atom, client/C = null, mob/living/effect_mob = null)
	if(!initiator_atom || QDELETED(initiator_atom))
		return null

	var/datum/erp_controller/EC = new(initiator_atom, C, effect_mob)
	return EC

/// Gets existing controller or creates a new one.
/datum/controller/subsystem/erp/proc/get_or_create_controller(atom/initiator_atom, client/C = null, mob/living/effect_mob = null)
	var/datum/erp_controller/EC = null
	if(C)
		EC = get_controller_for_client(C)

	if(!EC)
		EC = get_controller_for(initiator_atom)

	if(!EC)
		EC = create_controller(initiator_atom, C, effect_mob)
	else
		EC.rebind_owner(initiator_atom, C, effect_mob)

	return EC

/// Returns organ-type options list for UI via catalog service.
/datum/controller/subsystem/erp/proc/get_organ_type_options_ui()
	return ui_catalog ? ui_catalog.get_organ_type_options_ui() : list()

/// Applies organ prefs for a specific mob via prefs service (no-op if no prefs).
/datum/controller/subsystem/erp/proc/apply_prefs_for_mob(mob/living/M)
	if(!M || !M.client?.prefs)
		return

	for(var/datum/erp_sex_organ/O in organs)
		if(!O || QDELETED(O))
			continue
		if(O.get_owner() == M)
			organ_prefs_service.apply_prefs_if_possible(O)

/// Creates an ERP actor for the given atom via actor factory.
/datum/controller/subsystem/erp/proc/create_actor(atom/A, client/C = null, mob/living/effect_mob = null)
	return actor_factory ? actor_factory.create_actor(A, C, effect_mob) : null

/// Resolves the mob that should provide consent for a target atom (policy).
/datum/controller/subsystem/erp/proc/get_consent_mob_for_target(atom/target_atom)
	return consent_resolver ? consent_resolver.get_consent_mob_for_target(target_atom) : null

/datum/controller/subsystem/erp/proc/register_knotting_decay(datum/component/erp_knotting/K)
	if(K && !(K in decaying_knotting))
		decaying_knotting += K

/datum/controller/subsystem/erp/proc/unregister_knotting_decay(datum/component/erp_knotting/K)
	if(K)
		decaying_knotting -= K

/datum/controller/subsystem/erp/proc/get_controller_for_client(client/C)
	if(!C)
		return null
	for(var/datum/erp_controller/EC in controllers)
		if(!EC || QDELETED(EC))
			continue
		if(EC.owner_client == C)
			return EC
	return null
