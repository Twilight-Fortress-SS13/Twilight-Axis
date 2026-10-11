/proc/ataman_flank_angle_of(turf/origin, turf/point)
	if(!origin || !point)
		return null
	var/dx = point.x - origin.x
	var/dy = point.y - origin.y
	if(!dx && !dy)
		return null
	return (arctan(dx, dy) + 360) % 360

/proc/ataman_flank_angle_delta(first_angle, second_angle)
	if(isnull(first_angle) || isnull(second_angle))
		return null
	var/delta = abs(first_angle - second_angle) % 360
	return delta > 180 ? 360 - delta : delta

/proc/ataman_flank_widest_gap(list/angles)
	if(!length(angles))
		return null
	var/list/sorted = sortTim(angles.Copy(), cmp = /proc/cmp_numeric_asc)
	if(length(sorted) < 2)
		return list(sorted[1], 360)
	var/largest_gap = 0
	var/gap_start = sorted[1]
	for(var/i in 1 to length(sorted))
		var/next_index = (i % length(sorted)) + 1
		var/gap = (sorted[next_index] - sorted[i] + 360) % 360
		if(gap > largest_gap)
			largest_gap = gap
			gap_start = sorted[i]
	if(!largest_gap)
		return list(sorted[1], 360)
	return list(gap_start, largest_gap)

/proc/ataman_flank_pick_angle(list/angles)
	var/list/gap = ataman_flank_widest_gap(angles)
	if(!gap || gap[2] < ATAMAN_FLANK_MIN_SEPARATION)
		return null
	return (gap[1] + round(gap[2] / 2)) % 360

/proc/ataman_flank_turf_for(turf/target_turf, angle, mob/living/pawn, list/rejections)
	if(!target_turf || isnull(angle))
		return null
	var/turf/best_turf
	var/best_delta = 361
	for(var/turf/candidate as anything in RANGE_TURFS(ATAMAN_FLANK_RADIUS, target_turf))
		if(candidate == target_turf)
			continue
		if(candidate.density)
			if(rejections)
				rejections += "[candidate.x],[candidate.y] dense"
			continue
		if(pawn && !candidate.can_traverse_safely(pawn))
			if(rejections)
				rejections += "[candidate.x],[candidate.y] unsafe"
			continue
		var/candidate_angle = ataman_flank_angle_of(target_turf, candidate)
		if(isnull(candidate_angle))
			continue
		var/delta = ataman_flank_angle_delta(candidate_angle, angle)
		if(delta < best_delta)
			best_delta = delta
			best_turf = candidate
	return best_turf

/proc/ataman_flank_clear(datum/ai_controller/controller)
	if(!controller)
		return
	controller.clear_blackboard_key(BB_ATAMAN_FLANK_ANGLE)
	controller.clear_blackboard_key(BB_ATAMAN_FLANK_TURF)

/datum/ai_planning_subtree/ataman_squad_flank

/datum/ai_planning_subtree/ataman_squad_flank/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/npc/ataman_bandit/pawn = controller.pawn
	if(!istype(pawn))
		return

	var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
	var/mob/living/target = controller.blackboard[BB_ATAMAN_TARGET]
	if(!squad)
		ataman_ai_trace(pawn, "FLANK: skip - no squad on my blackboard, nobody to coordinate with")
		ataman_flank_clear(controller)
		return
	if(!istype(target))
		ataman_ai_trace(pawn, "FLANK: skip - no target on my blackboard")
		ataman_flank_clear(controller)
		return
	if(target.stat == DEAD)
		ataman_ai_trace(pawn, "FLANK: skip - [target] is dead")
		ataman_flank_clear(controller)
		return
	if(ataman_target_is_secured(target))
		ataman_ai_trace(pawn, "FLANK: skip - [target] is already cuffed, no need to circle")
		ataman_flank_clear(controller)
		return
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		ataman_ai_trace(pawn, "FLANK: skip - [target] has no turf to circle around")
		ataman_flank_clear(controller)
		return

	var/list/ally_angles = squad.get_flank_angles(pawn, target_turf)
	if(!length(ally_angles))
		ataman_ai_trace(pawn, "FLANK: skip - no squadmate holds a side on [target] within [ATAMAN_FLANK_SCAN_RANGE] tiles, nothing to flank around")
		ataman_flank_clear(controller)
		return

	var/list/gap = ataman_flank_widest_gap(ally_angles)
	var/angle_summary = "allies at [jointext(ally_angles, "/")] deg, widest gap [gap[2]] deg starting [gap[1]] deg"
	if(gap[2] < ATAMAN_FLANK_MIN_SEPARATION)
		ataman_ai_trace(pawn, "FLANK: skip - [target] is already ringed ([angle_summary], need [ATAMAN_FLANK_MIN_SEPARATION])")
		ataman_flank_clear(controller)
		return
	var/chosen_angle = (gap[1] + round(gap[2] / 2)) % 360

	var/cached_angle = controller.blackboard[BB_ATAMAN_FLANK_ANGLE]
	var/turf/flank_turf = controller.blackboard[BB_ATAMAN_FLANK_TURF]
	var/recalc_reason
	if(isnull(cached_angle))
		recalc_reason = "no cached angle yet"
	else if(!flank_turf)
		recalc_reason = "no cached tile yet"
	else if(get_dist(flank_turf, target_turf) > ATAMAN_FLANK_RADIUS)
		recalc_reason = "[target] moved, cached tile is [get_dist(flank_turf, target_turf)] tiles off"
	else
		var/drift = ataman_flank_angle_delta(cached_angle, chosen_angle)
		if(drift > ATAMAN_FLANK_ANGLE_DRIFT)
			recalc_reason = "my side drifted [drift] deg (cached [cached_angle], want [chosen_angle])"

	if(recalc_reason)
		var/list/rejections = list()
		flank_turf = ataman_flank_turf_for(target_turf, chosen_angle, pawn, rejections)
		if(!flank_turf)
			ataman_ai_trace(pawn, "FLANK: give up - no passable tile around [target] for [chosen_angle] deg ([angle_summary]); rejected [length(rejections) ? jointext(rejections, " | ") : "nothing"]")
			ataman_flank_clear(controller)
			return
		ataman_ai_log(pawn, "FLANK: taking [chosen_angle] deg on [target] at [flank_turf.x],[flank_turf.y] - [recalc_reason] ([angle_summary])")
		if(length(rejections))
			ataman_ai_trace(pawn, "FLANK: tiles I could not use: [jointext(rejections, " | ")]")
		controller.set_blackboard_key(BB_ATAMAN_FLANK_ANGLE, chosen_angle)
		controller.set_blackboard_key(BB_ATAMAN_FLANK_TURF, flank_turf)

	var/gap_to_spot = get_dist(pawn, flank_turf)
	if(gap_to_spot <= ATAMAN_FLANK_ENGAGE_DIST)
		ataman_ai_trace(pawn, "FLANK: in position at [chosen_angle] deg on [target], handing the tick to melee")
		return

	ataman_ai_trace(pawn, "FLANK: walking [gap_to_spot] tiles to [flank_turf.x],[flank_turf.y] for [chosen_angle] deg on [target]")
	controller.queue_behavior(/datum/ai_behavior/travel_towards, BB_ATAMAN_FLANK_TURF)
	return SUBTREE_RETURN_FINISH_PLANNING
