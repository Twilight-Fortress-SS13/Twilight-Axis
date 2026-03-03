/datum/erp_scene_runtime
	var/datum/erp_controller/controller

/datum/erp_scene_runtime/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Processes scene ticking and message emission.
/datum/erp_scene_runtime/proc/process_scene_tick()
	var/list/active = list()

	if(controller.links && controller.links.len)
		for(var/datum/erp_sex_link/L in controller.links)
			if(L && !QDELETED(L) && L.is_valid())
				active += L

	if(controller.scene_active && !active.len)
		var/datum/erp_sex_link/last_best = controller.last_scene_message_link_ref
		controller.on_scene_ended(last_best)
		controller.last_scene_message_link_ref = null
		controller.next_scene_tick = 0
		controller.last_scene_tick = 0
		return

	if(!active.len)
		return

	var/datum/erp_sex_link/best = pick_best_message_link(active)
	controller.last_scene_message_link_ref = best

	if(!controller.scene_active)
		controller.on_scene_started(active, best)
		controller.last_scene_tick = world.time
		controller.next_scene_tick = world.time + calc_scene_interval(active)
		return

	if(!controller.next_scene_tick)
		controller.last_scene_tick = world.time
		controller.next_scene_tick = world.time + calc_scene_interval(active)
		return

	if(world.time < controller.next_scene_tick)
		return

	var/dt = max(1, world.time - controller.last_scene_tick)
	controller.last_scene_tick = world.time
	controller.next_scene_tick = world.time + calc_scene_interval(active)

	controller.apply_scene_effects(active, best, dt)

	var/msg = null
	if(best?.action && SSerp?.action_message_renderer && best.action.message_tick)
		msg = SSerp.action_message_renderer.build_message(best.action.message_tick, best)

	if(msg)
		var/list/fs = controller.get_scene_force_speed_avg(active)
		var/avg_force = fs ? (fs["force"] || SEX_FORCE_MID) : SEX_FORCE_MID
		var/stam_cost = 2 * avg_force
		best?.actor_active?.stamina_add(-stam_cost)

		controller.play_tick_effects(active, best, dt)
		controller.send_message(best.spanify_sex(msg), best)

/// Calculates average scene interval.
/datum/erp_scene_runtime/proc/calc_scene_interval(list/active_links)
	var/total = 0
	var/n = 0

	for(var/datum/erp_sex_link/L in active_links)
		var/t = L.get_effective_interval()
		if(!isnum(t) || t <= 0)
			continue
		total += t
		n++

	if(!n)
		return 3 SECONDS

	return round(total / n)

/// Picks best link for message emission.
/datum/erp_scene_runtime/proc/pick_best_message_link(list/active_links)
	var/datum/erp_sex_link/best = null
	var/best_w = -1

	for(var/datum/erp_sex_link/L in active_links)
		var/w = L.get_message_weight()
		if(!isnum(w))
			w = 0

		if(L.is_aggressive())
			w += 0.25

		if(w > best_w)
			best_w = w
			best = L

	return best

/// Marks scene started.
/datum/erp_scene_runtime/proc/on_scene_started(list/active_links, datum/erp_sex_link/best)
	controller.scene_active = TRUE
	controller.scene_started_at = world.time

/// Marks scene ended.
/datum/erp_scene_runtime/proc/on_scene_ended(datum/erp_sex_link/last_best)
	controller.scene_active = FALSE
	controller.scene_started_at = 0
