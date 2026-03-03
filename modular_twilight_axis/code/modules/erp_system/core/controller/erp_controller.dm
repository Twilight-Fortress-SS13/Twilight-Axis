/datum/erp_controller
	var/datum/erp_actor/owner
	var/client/owner_client
	var/datum/erp_actor/active_actor
	var/list/datum/erp_actor/actors = list()
	var/list/datum/erp_sex_link/links = list()
	var/datum/erp_sex_ui/ui
	var/datum/erp_actor/active_partner

	var/default_link_speed = SEX_SPEED_MID
	var/default_link_force = SEX_FORCE_MID

	var/hidden_mode = FALSE
	var/yield_to_partner = FALSE
	var/do_until_finished = TRUE
	var/allow_user_moan = TRUE
	var/arousal_frozen = FALSE
	var/do_knot_action = FALSE

	var/last_scene_tick = 0
	var/next_scene_tick = 0
	var/scene_active = FALSE
	var/scene_started_at = 0
	var/last_scene_message_link_ref = null

	var/next_ui_update = 0
	var/ui_update_scheduled = FALSE

	var/datum/erp_controller_partners/partners_d
	var/datum/erp_controller_ui/ui_d
	var/datum/erp_controller_links/links_d
	var/datum/erp_controller_actions/actions_d
	var/datum/erp_controller_organs/organs_d
	var/datum/erp_controller_kinks/kinks_d

	var/datum/erp_scene_runtime/scene_runtime_d
	var/datum/erp_scene_effects/scene_effects_d
	var/datum/erp_scene_messaging/scene_msg_d
	var/datum/erp_vfx_service/vfx_d

	var/datum/erp_injection_service/inject_d
	var/datum/erp_climax_service/climax_d
	var/datum/erp_knot_service/knot_d

/// Creates controller, owner actor and UI host.
/datum/erp_controller/New(atom/initial_owner, client/C = null, mob/living/effect_mob = null)
	. = ..()
	if(!initial_owner || QDELETED(initial_owner))
		qdel(src)
		return

	owner_client = C
	owner = SSerp.create_actor(initial_owner, owner_client, effect_mob)
	if(!owner)
		qdel(src)
		return

	if(owner_client)
		owner.attach_client(owner_client)

	actors += owner

	var/mob/ui_host = owner.get_control_mob(owner_client)
	if(!ui_host || !ui_host.client)
		ui_host = owner_client?.mob

	if(!ui_host || !ui_host.client)
		ui = null
	else
		ui = new(ui_host, src)

	scene_msg_d = new(src)
	inject_d = new(src)
	knot_d = new(src)
	climax_d = new(src)

	vfx_d = new(src)
	scene_effects_d = new(src)
	scene_runtime_d = new(src)

	partners_d = new(src)
	ui_d = new(src)
	links_d = new(src)
	actions_d = new(src)
	organs_d = new(src)
	kinks_d = new(src)

	SSerp.register_controller(src)
	if(owner.can_register_signals())
		register_actor_signals(owner)

/// Destroys controller, links, actors and UI.
/datum/erp_controller/Destroy()
	links_d?.cleanup()

	if(actors)
		for(var/datum/erp_actor/A in actors)
			if(A?.can_register_signals())
				unregister_actor_signals(A)

	SSerp.unregister_controller(src)

	if(ui)
		qdel(ui)
		ui = null

	var/datum/erp_actor/old_owner = owner
	owner = null

	if(actors)
		for(var/datum/erp_actor/A2 in actors)
			if(A2 && A2 != old_owner)
				qdel(A2)
		actors = null

	if(old_owner)
		qdel(old_owner)

	active_partner = null
	owner_client = null

	if(partners_d) qdel(partners_d)
	if(ui_d) qdel(ui_d)
	if(links_d) qdel(links_d)
	if(actions_d) qdel(actions_d)
	if(organs_d) qdel(organs_d)
	if(kinks_d) qdel(kinks_d)

	if(scene_runtime_d) qdel(scene_runtime_d)
	if(scene_effects_d) qdel(scene_effects_d)
	if(scene_msg_d) qdel(scene_msg_d)
	if(vfx_d) qdel(vfx_d)

	if(inject_d) qdel(inject_d)
	if(climax_d) qdel(climax_d)
	if(knot_d) qdel(knot_d)

	return ..()

/// Registers signals from actor's signal mob.
/datum/erp_controller/proc/register_actor_signals(datum/erp_actor/A)
	if(!A || !A.can_register_signals())
		return

	var/mob/M = A.get_signal_mob()
	if(!M)
		return

	RegisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(on_pair_moved))
	RegisterSignal(M, COMSIG_ERP_GET_LINKS, PROC_REF(on_get_links))
	RegisterSignal(M, COMSIG_SEX_CLIMAX, PROC_REF(on_arousal_climax))
	RegisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed))
	RegisterSignal(M, COMSIG_ERP_ANATOMY_CHANGED, PROC_REF(on_anatomy_changed))

/// Unregisters signals from actor's signal mob.
/datum/erp_controller/proc/unregister_actor_signals(datum/erp_actor/A)
	if(!A)
		return

	var/mob/M = A.get_signal_mob()
	if(!M)
		return

	UnregisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(on_pair_moved))
	UnregisterSignal(M, COMSIG_ERP_GET_LINKS, PROC_REF(on_get_links))
	UnregisterSignal(M, COMSIG_SEX_CLIMAX, PROC_REF(on_arousal_climax))
	UnregisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed))
	UnregisterSignal(M, COMSIG_ERP_ANATOMY_CHANGED, PROC_REF(on_anatomy_changed))

/// Handles anatomy changes and marks organs dirty.
/datum/erp_controller/proc/on_anatomy_changed(datum/source)
	SIGNAL_HANDLER
	partners_d?.on_anatomy_changed(source)

/// Handles moved actors and stops invalid links.
/datum/erp_controller/proc/on_pair_moved(atom/movable/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER
	links_d?.on_pair_moved(source, oldloc, dir, forced)

/// Collects links relevant to source mob.
/datum/erp_controller/proc/on_get_links(datum/source, list/out_links)
	SIGNAL_HANDLER
	links_d?.on_get_links(source, out_links)

/// Updates UI on arousal change.
/datum/erp_controller/proc/on_arousal_changed(datum/source)
	SIGNAL_HANDLER
	ui_d?.on_arousal_changed(source)

/// Handles climax signal and schedules effects.
/datum/erp_controller/proc/on_arousal_climax(datum/source)
	SIGNAL_HANDLER
	climax_d?.on_arousal_climax(source)

/// Runs delayed climax effects (async).
/datum/erp_controller/proc/handle_arousal_climax_effects(mob/living/carbon/human/who, list/active_links)
	climax_d?.handle_arousal_climax_effects(who, active_links)

/// Opens UI for owner client.
/datum/erp_controller/proc/open_ui(mob/user = null)
	ui_d?.open_ui(user)

/// Builds full UI payload.
/datum/erp_controller/proc/build_ui_payload()
	return ui_d ? ui_d.build_ui_payload() : null

/// Returns partners list for UI.
/datum/erp_controller/proc/get_partners_ui()
	return partners_d ? partners_d.get_partners_ui() : list()

/// Adds partner atom and optionally sets active.
/datum/erp_controller/proc/add_partner_atom(atom/target_atom, set_active = TRUE)
	partners_d?.add_partner_atom(target_atom, set_active)

/// Adds partner convenience wrapper.
/datum/erp_controller/proc/add_partner(atom/target)
	partners_d?.add_partner(target)

/// Stops link by id (UI).
/datum/erp_controller/proc/handle_stop_link(link_id)
	return links_d ? links_d.handle_stop_link(link_id) : FALSE

/// Processes all links and ticks scene.
/datum/erp_controller/proc/process_links()
	links_d?.process_links()

/// Finds action by id or path.
/datum/erp_controller/proc/get_action_by_id_or_path(action_type)
	return actions_d ? actions_d.get_action_by_id_or_path(action_type) : null

/// Returns active links list for UI.
/datum/erp_controller/proc/get_active_links_ui(mob/living/carbon/human/H)
	return links_d ? links_d.get_active_links_ui(H) : list()

/// Stops link (owner only).
/datum/erp_controller/proc/stop_link(mob/user, link_id)
	return links_d ? links_d.stop_link(user, link_id) : FALSE

/// Stops link runtime (internal).
/datum/erp_controller/proc/stop_link_runtime(datum/erp_sex_link/L)
	links_d?.stop_link_runtime(L)

/// Finds link by id.
/datum/erp_controller/proc/find_link(link_id)
	return links_d ? links_d.find_link(link_id) : null

/// Sets link speed (owner only).
/datum/erp_controller/proc/set_link_speed(mob/user, link_id, value)
	return links_d ? links_d.set_link_speed(user, link_id, value) : FALSE

/// Sets link force (owner only).
/datum/erp_controller/proc/set_link_force(mob/user, link_id, value)
	return links_d ? links_d.set_link_force(user, link_id, value) : FALSE

/// Sets link finish mode (owner only).
/datum/erp_controller/proc/set_link_finish_mode(mob/user, link_id, mode)
	return links_d ? links_d.set_link_finish_mode(user, link_id, mode) : FALSE

/// Sets penis climax mode in prefs.
/datum/erp_controller/proc/set_penis_climax_mode(mob/living/carbon/human/H, mode)
	return organs_d ? organs_d.set_penis_climax_mode(H, mode) : FALSE

/// Gets owner's penis organ datum.
/datum/erp_controller/proc/get_owner_penis_organ()
	return organs_d ? organs_d.get_owner_penis_organ() : null

/// Returns organ status list for UI.
/datum/erp_controller/proc/get_organs_status_ui(mob/living/carbon/human/H)
	return organs_d ? organs_d.get_organs_status_ui(H) : list()

/// Builds single organ status entry.
/datum/erp_controller/proc/build_organ_status_entry(datum/erp_sex_organ/O)
	return organs_d ? organs_d.build_organ_status_entry(O) : list()

/// Returns localized organ name.
/datum/erp_controller/proc/get_organ_ui_name(datum/erp_sex_organ/O)
	return organs_d ? organs_d.get_organ_ui_name(O) : "[O?.erp_organ_type]"

/// Gets penis erect mode for UI.
/datum/erp_controller/proc/get_penis_erect_mode(datum/erp_sex_organ/penis/P)
	return organs_d ? organs_d.get_penis_erect_mode(P) : "auto"

/// Builds liquids UI block.
/datum/erp_controller/proc/build_liquid_block(datum/erp_liquid_storage/L)
	return organs_d ? organs_d.build_liquid_block(L) : list("has" = FALSE, "pct" = 0)

/// Builds kinks UI block.
/datum/erp_controller/proc/get_kinks_ui(mob/living/M, datum/erp_actor/partner)
	return kinks_d ? kinks_d.get_kinks_ui(M, partner) : null

/// Returns active partner reference.
/datum/erp_controller/proc/get_active_partner(mob/living/carbon/human/H)
	return active_partner

/// Sets organ sensitivity and saves prefs.
/datum/erp_controller/proc/set_organ_sensitivity(mob/living/carbon/human/H, organ_id, value)
	return organs_d ? organs_d.set_organ_sensitivity(H, organ_id, value) : FALSE

/// Toggles organ overflow and saves prefs.
/datum/erp_controller/proc/toggle_organ_overflow(mob/living/carbon/human/H, organ_id)
	return organs_d ? organs_d.toggle_organ_overflow(H, organ_id) : FALSE

/// Sets penis erect mode and syncs source organ state.
/datum/erp_controller/proc/set_organ_erect_mode(mob/living/carbon/human/H, organ_id, mode)
	return organs_d ? organs_d.set_organ_erect_mode(H, organ_id, mode) : FALSE

/// Sets kink preference and saves prefs.
/datum/erp_controller/proc/set_kink_pref(mob/living/M, kink_type, value)
	return kinks_d ? kinks_d.set_kink_pref(M, kink_type, value) : FALSE

/// Returns action templates editor UI.
/datum/erp_controller/proc/get_action_templates_editor_ui(mob/living/carbon/human/H)
	return list()

/// Returns custom actions UI.
/datum/erp_controller/proc/get_custom_actions_ui(mob/living/carbon/human/H)
	return list()

/// Creates custom action and saves.
/datum/erp_controller/proc/create_custom_action(mob/living/H, list/params)
	if(!H || H.client != owner.client)
		return FALSE

	var/path_txt = params["type"] || params["template"]
	if(!path_txt)
		return FALSE

	var/path = text2path(path_txt)
	if(!ispath(path,/datum/erp_action))
		return FALSE

	var/datum/erp_action/A = new path
	A.id = "custom_[world.time]_[rand(1000,9999)]"
	A.ckey = owner.client?.ckey
	A.abstract = FALSE

	var/n = params["name"] || params["display_name"] || params["title"]
	if(!isnull(n))
		SSerp.action_prefs_codec.set_field(A, "name", n)

	var/list/fields = params["fields"]
	if(islist(fields))
		for(var/list/F in fields)
			var/fid = F["id"]
			if(fid)
				SSerp.action_prefs_codec.set_field(A, fid, F["value"])

	owner.custom_actions += A
	owner.save_custom_actions_to_prefs()
	ui?.request_update()
	return TRUE

/// Updates custom action and saves.
/datum/erp_controller/proc/update_custom_action(mob/living/H, list/params)
	if(!H || H.client != owner.client)
		return FALSE

	var/action_id = params["id"]
	if(!action_id)
		return FALSE

	var/changed = FALSE

	if(params["field"])
		var/f = params["field"]
		var/v = params["value"]
		if(owner.update_custom_action(action_id, f, v))
			changed = TRUE

	var/list/fields = params["fields"]
	if(islist(fields))
		for(var/list/F in fields)
			var/fid = F["id"]
			if(fid && owner.update_custom_action(action_id, fid, F["value"]))
				changed = TRUE

	var/n = params["name"] || params["display_name"] || params["title"]
	if(!isnull(n))
		if(owner.update_custom_action(action_id, "name", n))
			changed = TRUE

	if(!changed)
		return FALSE

	owner.save_custom_actions_to_prefs()
	ui?.request_update()
	return TRUE

/// Deletes custom action and saves.
/datum/erp_controller/proc/delete_custom_action(mob/living/H, id)
	if(!H || H.client != owner.client)
		return FALSE

	if(owner.delete_custom_action(id))
		owner.save_custom_actions_to_prefs()
		ui?.request_update()
		return TRUE

	return FALSE

/// Returns all actions (core+custom) filtered by scope.
/datum/erp_controller/proc/get_all_actions_for_ui(datum/erp_actor/actor, datum/erp_actor/partner)
	return actions_d ? actions_d.get_all_actions_for_ui(actor, partner) : list()

/// Returns action list UI entries by organ filters.
/datum/erp_controller/proc/get_action_list_ui(actor_type, partner_type)
	return actions_d ? actions_d.get_action_list_ui(actor_type, partner_type) : list()

/// Checks whether action can start.
/datum/erp_controller/proc/can_start_action(datum/erp_action/A, datum/erp_sex_organ/init, datum/erp_sex_organ/target)
	return actions_d ? actions_d.can_start_action(A, init, target) : FALSE

/// Returns action block reason string or null.
/datum/erp_controller/proc/get_action_block_reason(datum/erp_action/A, datum/erp_sex_organ/init, datum/erp_sex_organ/target)
	return actions_d ? actions_d.get_action_block_reason(A, init, target) : "Нет делегата."

/// Toggles hidden mode.
/datum/erp_controller/proc/change_hidden_mode()
	hidden_mode = !hidden_mode

/// Toggles surrender state.
/datum/erp_controller/proc/change_yield_state()
	var/mob/living/carbon/human/user = owner?.get_mob()
	if(!istype(user))
		return

	yield_to_partner = !yield_to_partner

	var/mob/living/carbon/human/partner = _get_partner_effect_mob()
	if(!istype(partner))
		return

	if(yield_to_partner)
		user.set_sex_surrender_to(partner)
	else
		user.set_sex_surrender_to(null)

/// Toggles arousal freeze flag.
/datum/erp_controller/proc/change_freeze_arousal()
	var/mob/living/actor_object = _get_owner_effect_mob()
	if(!istype(actor_object))
		return

	SEND_SIGNAL(actor_object, COMSIG_SEX_FREEZE_AROUSAL)
	var/list/ad = list()
	SEND_SIGNAL(actor_object, COMSIG_SEX_GET_AROUSAL, ad)
	arousal_frozen = !!ad["frozen"]

/// Toggles moaning.
/datum/erp_controller/proc/change_moaning()
	allow_user_moan = !allow_user_moan

/// Flips lying direction with cooldown.
/datum/erp_controller/proc/change_direction()
	var/mob/living/carbon/human/user = _get_owner_effect_mob()
	if(!istype(user))
		return

	if(!islist(user.mob_timers))
		user.mob_timers = list()

	var/last = user.mob_timers["sexpanel_flip"] || 0
	if(world.time < last + 1 SECONDS)
		return FALSE

	user.mob_timers["sexpanel_flip"] = world.time
	if(user.lying)
		if(user.lying == 270)
			user.lying = 90
		else
			user.lying = 270
		user.update_transform()
		user.lying_prev = user.lying

/// Stops all links.
/datum/erp_controller/proc/full_stop()
	return links_d ? links_d.full_stop() : 0

/// Returns owner arousal UI value.
/datum/erp_controller/proc/get_actor_arousal_ui(mob/user)
	return ui_d ? ui_d.get_actor_arousal_ui(user) : 0

/// Returns partner arousal UI value (or null if hidden).
/datum/erp_controller/proc/get_partner_arousal_ui(mob/user)
	return ui_d ? ui_d.get_partner_arousal_ui(user) : 0

/// Sets active partner by ref string.
/datum/erp_controller/proc/set_active_partner_by_ref(ref)
	return partners_d ? partners_d.set_active_partner_by_ref(ref) : FALSE

/// Returns whether partner arousal is hidden.
/datum/erp_controller/proc/is_partner_arousal_hidden(actor)
	return partners_d ? partners_d.is_partner_arousal_hidden(actor) : TRUE

/// Sets owner arousal value directly.
/datum/erp_controller/proc/set_actor_arousal(actor, value = 0)
	return ui_d ? ui_d.set_actor_arousal(actor, value) : FALSE

/// Sends visible/hidden-mode message.
/datum/erp_controller/proc/send_message(msg, datum/erp_sex_link/L = null)
	scene_msg_d?.send_message(msg, L)

/// Finds nearby container used for inject.
/datum/erp_controller/proc/_find_nearby_container(mob/living/carbon/human/H, turf/center)
	return inject_d ? inject_d.find_nearby_container(H, center) : null

/// Routes reagents according to inject target mode.
/datum/erp_controller/proc/handle_inject(datum/erp_sex_link/link, datum/erp_sex_organ/source, target_mode, mob/living/carbon/human/who = null)
	inject_d?.handle_inject(link, source, target_mode, who)

/// Localized organ type display name.
/datum/erp_controller/proc/get_organ_type_ui_name(type)
	return organs_d ? organs_d.get_organ_type_ui_name(type) : "[type]"

/// Returns actor organ-type filter UI list.
/datum/erp_controller/proc/get_actor_type_filters_ui()
	return organs_d ? organs_d.get_actor_type_filters_ui() : list()

/// Returns partner organ-type filter UI list.
/datum/erp_controller/proc/get_partner_type_filters_ui()
	return organs_d ? organs_d.get_partner_type_filters_ui() : list()

/// Returns actor nodes for selected filter.
/datum/erp_controller/proc/get_actor_nodes_by_filter_ui(type_filter)
	return organs_d ? organs_d.get_actor_nodes_by_filter_ui(type_filter) : list()

/// Returns partner nodes for selected filter.
/datum/erp_controller/proc/get_partner_nodes_by_filter_ui(type_filter)
	return organs_d ? organs_d.get_partner_nodes_by_filter_ui(type_filter) : list()

/// Starts action by action_id using first free organs by type.
/datum/erp_controller/proc/start_action_by_types(mob/living/carbon/human/H, action_id)
	return links_d ? links_d.start_action_by_types(H, action_id) : FALSE

/// Processes scene tick (scheduler).
/datum/erp_controller/proc/process_scene_tick()
	scene_runtime_d?.process_scene_tick()

/// Computes scene interval by active links.
/datum/erp_controller/proc/calc_scene_interval(list/active_links)
	return scene_runtime_d ? scene_runtime_d.calc_scene_interval(active_links) : 3 SECONDS

/// Picks best link for scene message.
/datum/erp_controller/proc/pick_best_message_link(list/active_links)
	return scene_runtime_d ? scene_runtime_d.pick_best_message_link(active_links) : null

/// Applies scene effects to actors.
/datum/erp_controller/proc/apply_scene_effects(list/active_links, datum/erp_sex_link/best, dt)
	scene_effects_d?.apply_scene_effects(active_links, best, dt)

/// Wraps text with intensity span.
/datum/erp_controller/proc/spanify_scene_text(text, force, speed, intensity = null)
	return scene_msg_d ? scene_msg_d.spanify_scene_text(text, force, speed, intensity) : text

/// Returns average force/speed for links.
/datum/erp_controller/proc/get_scene_force_speed_avg(list/active_links)
	return scene_effects_d ? scene_effects_d.get_scene_force_speed_avg(active_links) : list("force" = SEX_FORCE_MID, "speed" = SEX_SPEED_MID)

/// Marks scene as started.
/datum/erp_controller/proc/on_scene_started(list/active_links, datum/erp_sex_link/best)
	scene_runtime_d?.on_scene_started(active_links, best)

/// Marks scene as ended.
/datum/erp_controller/proc/on_scene_ended(datum/erp_sex_link/last_best)
	scene_runtime_d?.on_scene_ended(last_best)

/// Spanify scene start/end message.
/datum/erp_controller/proc/spanify_scene_start_end(text)
	return scene_msg_d ? scene_msg_d.spanify_scene_start_end(text) : text

/// Spanify climax message.
/datum/erp_controller/proc/spanify_scene_climax(text)
	return scene_msg_d ? scene_msg_d.spanify_scene_climax(text) : text

/// Finds actor datum by mob.
/datum/erp_controller/proc/get_actor_by_mob(mob/living/M)
	return partners_d ? partners_d.get_actor_by_mob(M) : null

/// Picks best link for climax context.
/datum/erp_controller/proc/pick_best_climax_link(mob/living/carbon/human/who, list/active_links)
	return climax_d ? climax_d.pick_best_climax_link(who, active_links) : null

/// Computes orgasm context for who+link.
/datum/erp_controller/proc/get_orgasm_context(mob/living/carbon/human/who, datum/erp_sex_link/best)
	return climax_d ? climax_d.get_orgasm_context(who, best) : null

/// Applies coating status effect.
/datum/erp_controller/proc/apply_coating(mob/living/carbon/human/target, zone, datum/reagents/R, capacity = 30)
	return climax_d ? climax_d.apply_coating(target, zone, R, capacity) : FALSE

/// Applies coating and creates puddle.
/datum/erp_controller/proc/apply_coating_and_puddle(datum/erp_sex_organ/source_organ, mob/living/carbon/human/coat_mob, zone, mob/living/carbon/human/feet_mob, amount, capacity = 30)
	return climax_d ? climax_d.apply_coating_and_puddle(source_organ, coat_mob, zone, feet_mob, amount, capacity) : FALSE

/// Executes climax effects for who+best.
/datum/erp_controller/proc/do_climax_effects(mob/living/carbon/human/who, datum/erp_sex_link/best)
	return climax_d ? climax_d.do_climax_effects(who, best) : FALSE

/// Gets knotting component for human.
/datum/erp_controller/proc/_get_knotting_component(mob/living/carbon/human/H)
	return knot_d ? knot_d.get_knotting_component(H) : null

/// Returns penis unit id for link (multi-knot support hook).
/datum/erp_controller/proc/_get_penis_unit_id_for_link(datum/erp_sex_link/L)
	return knot_d ? knot_d.get_penis_unit_id_for_link(L) : 0

/// Checks if link is knot pair and should ignore move break.
/datum/erp_controller/proc/_is_knot_pair_link(datum/erp_sex_link/L)
	return knot_d ? knot_d.is_knot_pair_link(L) : FALSE

/// Notes knot activity for link pair.
/datum/erp_controller/proc/_note_knot_activity_from_link(datum/erp_sex_link/L)
	knot_d?.note_knot_activity_from_link(L)

/// Toggles do_knot_action.
/datum/erp_controller/proc/set_do_knot_action(mob/living/carbon/human/H, value)
	return knot_d ? knot_d.set_do_knot_action(H, value) : FALSE

/// Returns penis knot panel state for UI.
/datum/erp_controller/proc/get_penis_knot_ui_state(mob/living/carbon/human/H)
	return knot_d ? knot_d.get_penis_knot_ui_state(H) : list("has_knotted_penis" = FALSE, "can_knot_now" = FALSE)

/// Checks whether penis panel should be visible.
/datum/erp_controller/proc/should_show_penis_panel(mob/living/carbon/human/H, actor_type_filter)
	return knot_d ? knot_d.should_show_penis_panel(H, actor_type_filter) : FALSE

/// Sends link start message.
/datum/erp_controller/proc/_send_link_start_message(datum/erp_sex_link/L)
	scene_msg_d?.send_link_start_message(L)

/// Sends link finish message.
/datum/erp_controller/proc/_send_link_finish_message(datum/erp_sex_link/link, datum/erp_sex_organ/source, datum/reagents/R)
	scene_msg_d?.send_link_finish_message(link, source, R)

#define ERP_AROUSAL_HEARTS_THRESHOLD 20
#define ERP_TICK_EFFECT_COOLDOWN 2

/// Builds tick effects bundle.
/datum/erp_controller/proc/build_tick_effect_bundle(list/active_links, datum/erp_sex_link/best, dt)
	return vfx_d ? vfx_d.build_tick_effect_bundle(active_links, best, dt) : list()

/// Plays tick visuals and sounds.
/datum/erp_controller/proc/play_tick_effects(list/active_links, datum/erp_sex_link/best, dt)
	vfx_d?.play_tick_effects(active_links, best, dt)

/// Performs thrust bump animation.
/datum/erp_controller/proc/erp_do_thrust_bump(datum/erp_sex_link/best)
	vfx_d?.do_thrust_bump(best)

/// Picks best thrust target.
/datum/erp_controller/proc/_get_best_thrust_target(datum/erp_sex_link/best)
	return vfx_d ? vfx_d.get_best_thrust_target(best) : null

/// Spawns onomatopoeia balloon.
/datum/erp_controller/proc/erp_do_onomatopoeia(mob/living/carbon/human/user, datum/erp_sex_link/best)
	vfx_d?.do_onomatopoeia(user, best)

/// Plays slap sound.
/datum/erp_controller/proc/erp_play_slap(mob/living/carbon/human/user)
	vfx_d?.play_slap(user)

/// Checks if link is sucking.
/datum/erp_controller/proc/_link_is_sucking(datum/erp_sex_link/L)
	return vfx_d ? vfx_d.link_is_sucking(L) : FALSE

/// Plays suck sound.
/datum/erp_controller/proc/erp_play_suck(mob/living/carbon/human/user, datum/erp_sex_link/best)
	vfx_d?.play_suck(user, best)

/// Plays thrust sound.
/datum/erp_controller/proc/erp_play_thrust_sound(mob/living/carbon/human/user, datum/erp_sex_link/best)
	vfx_d?.play_thrust_sound(user, best)

/// Spawns hearts visuals.
/datum/erp_controller/proc/erp_spawn_hearts(mob/living/carbon/human/user)
	vfx_d?.spawn_hearts(user)

/// Converts zone key to bodyzone const.
/datum/erp_controller/proc/_zone_key_to_bodyzone(zone)
	return vfx_d ? vfx_d.zone_key_to_bodyzone(zone) : null

/// Tries to break bed on strong thrust.
/datum/erp_controller/proc/_erp_try_bed_break(datum/erp_sex_link/L, mob/living/user, atom/movable/target, time)
	vfx_d?.try_bed_break(L, user, target, time)

/// Finds bed near thrust.
/datum/erp_controller/proc/_erp_find_bed_for_thrust(datum/erp_sex_link/L, mob/living/user, atom/movable/target)
	return vfx_d ? vfx_d.find_bed_for_thrust(L, user, target) : null

/// Finds bed on turf.
/datum/erp_controller/proc/_erp_find_bed_on_turf(turf/T)
	return vfx_d ? vfx_d.find_bed_on_turf(T) : null

#undef ERP_AROUSAL_HEARTS_THRESHOLD
#undef ERP_TICK_EFFECT_COOLDOWN

/// Checks owner requester by client.
/datum/erp_controller/proc/_is_owner_requester(mob/user)
	return user?.client && owner_client && user.client == owner_client

/// Picks correct UI user mob for owner client.
/datum/erp_controller/proc/_get_ui_user(mob/user = null)
	if(user && _is_owner_requester(user))
		return user

	var/mob/cm = owner?.get_control_mob(owner_client)
	if(!owner_client)
		return cm

	if(cm && cm.client == owner_client)
		return cm

	var/mob/M = owner_client?.mob
	if(M && M.client == owner_client)
		return M

	return null

/datum/erp_controller/proc/has_active_actions()
	if(!links || !links.len)
		return FALSE

	for(var/datum/erp_sex_link/L in links)
		if(!L || QDELETED(L))
			continue
		if(!L.is_valid())
			continue
		// если у тебя есть state, можно ужесточить:
		if(L.state && L.state != LINK_STATE_ACTIVE)
			continue
		return TRUE

	return FALSE

/// Returns owner effect mob.
/datum/erp_controller/proc/_get_owner_effect_mob()
	return owner?.get_effect_mob()

/// Returns partner effect mob.
/datum/erp_controller/proc/_get_partner_effect_mob()
	return active_partner?.get_effect_mob()

/// Checks nearby container for actions requiring container inject.
/datum/erp_controller/proc/_has_nearby_container_for_action()
	return inject_d ? inject_d.has_nearby_container_for_action() : FALSE

/// Requests throttled UI update.
/datum/erp_controller/proc/request_ui_update()
	ui_d?.request_ui_update()

/// Performs throttled UI update now.
/datum/erp_controller/proc/_do_ui_update()
	ui_d?._do_ui_update()

/datum/erp_controller/proc/set_default_link_speed(mob/user, value)
	if(!user || user.client != owner?.get_client())
		return FALSE
	var/v = clamp(round(text2num("[value]")), 1, 4)
	default_link_speed = v
	ui?.request_update()
	return TRUE

/datum/erp_controller/proc/set_default_link_force(mob/user, value)
	if(!user || user.client != owner?.get_client())
		return FALSE
	var/v = clamp(round(text2num("[value]")), 1, 4)
	default_link_force = v
	ui?.request_update()
	return TRUE

/datum/erp_controller/proc/rebind_owner(atom/new_owner, client/C, mob/living/effect_mob = null)
	if(C && C != owner_client)
		owner_client = C
		owner?.attach_client(owner_client)

	if(new_owner && !QDELETED(new_owner))
		if(owner && owner.active_actor != new_owner)
			if(owner.can_register_signals())
				unregister_actor_signals(owner)

			var/datum/erp_actor/old_owner = owner
			actors -= old_owner
			owner = SSerp.create_actor(new_owner, owner_client, effect_mob)
			if(old_owner)
				qdel(old_owner)

			if(owner)
				actors += owner
				if(owner_client)
					owner.attach_client(owner_client)
				if(owner.can_register_signals())
					register_actor_signals(owner)

	var/mob/ui_host = owner?.get_control_mob(owner_client)
	if(!ui_host || !ui_host.client)
		ui_host = owner_client?.mob

	if(ui)
		qdel(ui)
		ui = null

	if(ui_host && ui_host.client)
		ui = new(ui_host, src)

	request_ui_update()
