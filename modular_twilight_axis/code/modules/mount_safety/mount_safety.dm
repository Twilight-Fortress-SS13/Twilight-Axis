/mob/living/simple_animal
	var/mount_fear_enabled = FALSE
	var/mount_initialized = FALSE
	var/mount_fear_until = 0
	var/mount_slow_until = 0
	var/mount_next_noise = 0
	var/mount_fear_tick_active = FALSE
	var/mount_maneater_resist_active = FALSE
	var/mount_maneater_resist_started = 0
	var/datum/progressbar/mount_maneater_resist_progress
	var/mount_next_hit_fear = 0
	var/mount_confusion_notice_until = 0
	var/mount_health_slow_stage = -1
	var/atom/mount_fear_source

/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	mount_fear_enabled = TRUE
	anatomy_type = /datum/anatomy/quadruped/mount

/mob/living/simple_animal/hostile/retaliate/rogue/fogbeast
	mount_fear_enabled = TRUE
	anatomy_type = /datum/anatomy/quadruped/mount

/mob/living/simple_animal/hostile/retaliate/rogue/goat
	mount_fear_enabled = TRUE
	anatomy_type = /datum/anatomy/quadruped/mount

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale
	mount_fear_enabled = TRUE
	anatomy_type = /datum/anatomy/quadruped/mount

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog
	mount_fear_enabled = TRUE
	anatomy_type = /datum/anatomy/quadruped/mount

/mob/living/simple_animal/hostile/retaliate/rogue/camel
	mount_fear_enabled = TRUE
	anatomy_type = /datum/anatomy/quadruped/mount

/datum/anatomy/quadruped/mount/build_zones()
	add_zone(BODY_ZONE_HEAD, part_health_fraction = 0.26, part_health_minimum = 40, break_wound = /datum/wound/cripple/maw, hint = "head")
	add_zone(BODY_ZONE_L_ARM, part_health_fraction = 0.23, part_health_minimum = 35, break_wound = /datum/wound/cripple/arm/foreleg, hint = "forelegs")
	add_zone(BODY_ZONE_R_ARM, part_health_fraction = 0.23, part_health_minimum = 35, break_wound = /datum/wound/cripple/arm/foreleg, hint = "forelegs")
	add_zone(BODY_ZONE_L_LEG, part_health_fraction = 0.22, part_health_minimum = 35, break_wound = /datum/wound/cripple/limb, hint = "hind legs")
	add_zone(BODY_ZONE_R_LEG, part_health_fraction = 0.22, part_health_minimum = 35, break_wound = /datum/wound/cripple/limb, hint = "hind legs")

/mob/living/simple_animal/proc/mount_health_stage()
	if(!can_buckle || maxHealth <= 0 || stat == DEAD)
		return 0
	var/percentage = 100 * health / maxHealth
	if(percentage > 70)
		return 0
	if(percentage > 55)
		return 1
	if(percentage > 40)
		return 2
	if(percentage > 25)
		return 3
	if(percentage > 10)
		return 4
	return 5

/mob/living/simple_animal/proc/mount_health_movement_penalty()
	return mount_health_stage() * 0.8

/mob/living/simple_animal/proc/mount_update_health_movement()
	if(!can_buckle)
		return
	var/stage = mount_health_stage()
	if(stage == mount_health_slow_stage)
		return
	mount_health_slow_stage = stage
	update_move_intent_slowdown()

/mob/living/simple_animal/proc/mount_limb_movement_penalty()
	if(!mount_initialized || !length(broken_parts))
		return 0
	var/penalty = 0
	if(BODY_ZONE_L_ARM in broken_parts)
		penalty += 2
	if(BODY_ZONE_R_ARM in broken_parts)
		penalty += 2
	if(BODY_ZONE_L_LEG in broken_parts)
		penalty += 3
	if(BODY_ZONE_R_LEG in broken_parts)
		penalty += 3
	return penalty

/mob/living/simple_animal/proc/mount_initialize()
	if(!mount_fear_enabled || mount_initialized || !can_buckle)
		return
	mount_initialized = TRUE
	maxHealth = round(maxHealth * 1.25)
	health = min(maxHealth, round(health * 1.25))
	ADD_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)
	AddElement(/datum/element/relay_attackers)
	RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(mount_on_attacked))
	if(ai_controller)
		var/list/allowed_plans = list()
		for(var/subtree in ai_controller.planning_subtrees)
			if(istype(subtree, /datum/ai_planning_subtree/aggro_find_target) || ispath(subtree, /datum/ai_planning_subtree/aggro_find_target))
				continue
			if(istype(subtree, /datum/ai_planning_subtree/target_retaliate) || ispath(subtree, /datum/ai_planning_subtree/target_retaliate))
				continue
			if(istype(subtree, /datum/ai_planning_subtree/basic_melee_attack_subtree) || ispath(subtree, /datum/ai_planning_subtree/basic_melee_attack_subtree))
				continue
			if(istype(subtree, /datum/ai_planning_subtree/flee_target) || ispath(subtree, /datum/ai_planning_subtree/flee_target))
				continue
			if(istype(subtree, /datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee) || ispath(subtree, /datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee))
				continue
			allowed_plans += subtree
		ai_controller.planning_subtrees = allowed_plans
		ai_controller.clear_aggro()
		ai_controller.halt_movement()

/mob/living/simple_animal/proc/mount_on_attacked(datum/source, atom/attacker, damage)
	SIGNAL_HANDLER
	if(!mount_initialized || !attacker || attacker == src || damage < 10 || world.time < mount_fear_until || world.time < mount_next_hit_fear)
		return
	var/chance = 5
	if(damage >= 20)
		chance = 12
	if(damage >= 35)
		chance = 22
	if(damage >= 50)
		chance = 30
	if(mount_startle(attacker, 4 SECONDS, chance))
		mount_next_hit_fear = world.time + 12 SECONDS

/mob/living/simple_animal/proc/mount_has_broken_leg()
	if(!mount_initialized || !length(broken_parts))
		return FALSE
	if(BODY_ZONE_L_ARM in broken_parts)
		return TRUE
	if(BODY_ZONE_R_ARM in broken_parts)
		return TRUE
	if(BODY_ZONE_L_LEG in broken_parts)
		return TRUE
	return (BODY_ZONE_R_LEG in broken_parts)

/mob/living/simple_animal/proc/mount_startle(atom/source, duration = 5 SECONDS, chance = 100, loud_noise = FALSE)
	if(!mount_initialized || stat != CONSCIOUS || !isturf(loc) || world.time < mount_fear_until)
		return FALSE
	if(loud_noise && world.time < mount_next_noise)
		return FALSE
	if(mount_has_broken_leg())
		chance = min(100, chance + 20)
	if(!prob(chance))
		return FALSE
	if(loud_noise)
		mount_next_noise = world.time + 5 SECONDS
	var/was_afraid = world.time < mount_fear_until
	mount_fear_until = max(mount_fear_until, world.time + duration)
	mount_fear_source = source
	if(ai_controller)
		ai_controller.clear_aggro()
		ai_controller.set_ai_status(AI_STATUS_OFF)
	if(!was_afraid)
		visible_message(span_warning("[src] panics and tries to flee!"))
	if(!mount_fear_tick_active)
		mount_fear_tick_active = TRUE
		addtimer(CALLBACK(src, PROC_REF(mount_fear_tick)), 2)
	return TRUE

/mob/living/simple_animal/proc/mount_fear_tick()
	if(QDELETED(src) || stat != CONSCIOUS || world.time >= mount_fear_until || !isturf(loc))
		mount_fear_tick_active = FALSE
		mount_fear_source = null
		if(!QDELETED(src))
			ai_controller?.reset_ai_status()
		return
	if(ai_controller)
		ai_controller.set_ai_status(AI_STATUS_OFF)
	if(mobility_flags & MOBILITY_MOVE)
		var/direction = 0
		if(mount_fear_source && !QDELETED(mount_fear_source) && mount_fear_source.z == z)
			direction = get_dir(mount_fear_source, src)
		if(!direction)
			direction = pick(NORTH, SOUTH, EAST, WEST)
		var/turf/destination = get_step(src, direction)
		var/datum/component/riding/riding_datum = get_riding_datum()
		if(destination && (!riding_datum || riding_datum.turf_check(destination, get_turf(src))))
			step(src, direction)
	addtimer(CALLBACK(src, PROC_REF(mount_fear_tick)), max(4, round(initial(ride_move_delay) + mount_movement_penalty() + mount_health_movement_penalty())))

/mob/living/simple_animal/proc/mount_movement_penalty()
	if(!mount_initialized)
		return 0
	return (world.time < mount_slow_until ? 4 : 0) + mount_limb_movement_penalty()

/mob/living/simple_animal/proc/mount_stumble()
	if(!mount_initialized || stat != CONSCIOUS)
		return
	if(world.time >= mount_slow_until)
		visible_message(span_warning("[src] stumbles over a boulder and slows down!"))
	mount_slow_until = max(mount_slow_until, world.time + 4 SECONDS)

/mob/living/simple_animal/proc/mount_on_crippled(zone, mob/living/attacker)
	if(!mount_initialized)
		return
	update_move_intent_slowdown()
	if(zone == BODY_ZONE_HEAD)
		visible_message(span_warning("[src] staggers, unable to keep its bearings!"))
		mount_startle(attacker, 4 SECONDS, 75)
	else if(zone == BODY_ZONE_L_ARM || zone == BODY_ZONE_R_ARM || zone == BODY_ZONE_L_LEG || zone == BODY_ZONE_R_LEG)
		visible_message(span_warning("[src] can no longer gallop with its injured legs!"))
		mount_startle(attacker, 6 SECONDS, 90)

/mob/living/simple_animal/proc/mount_end_maneater_resist()
	if(mount_maneater_resist_progress)
		qdel(mount_maneater_resist_progress)
		mount_maneater_resist_progress = null
	mount_maneater_resist_active = FALSE
	mount_maneater_resist_started = 0
	UnregisterSignal(src, COMSIG_QDELETING)

/mob/living/simple_animal/proc/mount_begin_maneater_resist_progress()
	mount_maneater_resist_started = world.time
	mount_maneater_resist_progress = new /datum/progressbar(src, 2 SECONDS, src)
	addtimer(CALLBACK(src, PROC_REF(mount_maneater_resist_tick)), 4)

/mob/living/simple_animal/proc/mount_schedule_maneater_resist()
	if(!can_buckle || mount_maneater_resist_active || !istype(buckled, /obj/structure/flora/roguegrass/maneater/real))
		return
	mount_maneater_resist_active = TRUE
	RegisterSignal(src, COMSIG_QDELETING, PROC_REF(mount_end_maneater_resist))
	mount_begin_maneater_resist_progress()

/mob/living/simple_animal/proc/mount_maneater_resist_tick()
	if(QDELETED(src) || stat != CONSCIOUS || !istype(buckled, /obj/structure/flora/roguegrass/maneater/real))
		mount_end_maneater_resist()
		return
	var/obj/structure/flora/roguegrass/maneater/real/maneater = buckled
	if(QDELETED(maneater) || maneater.obj_broken)
		mount_end_maneater_resist()
		return
	var/elapsed = min(world.time - mount_maneater_resist_started, 2 SECONDS)
	mount_maneater_resist_progress.update(elapsed)
	if(elapsed < 2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(mount_maneater_resist_tick)), min(4, 2 SECONDS - elapsed))
		return
	qdel(mount_maneater_resist_progress)
	mount_maneater_resist_progress = null
	var/chance = clamp(STASTR * 2, 5, 70)
	if(istype(maneater, /obj/structure/flora/roguegrass/maneater/real/juvenile))
		chance = min(100, chance * 2)
	if(prob(chance) && maneater.unbuckle_mob(src, TRUE))
		visible_message(span_warning("[src] tears free of [maneater]'s jaws!"))
	if(buckled == maneater)
		mount_begin_maneater_resist_progress()
	else
		mount_end_maneater_resist()

/proc/mount_notify_loud_noise(atom/origin, radius, chance, duration = 5 SECONDS)
	var/turf/noise_turf = get_turf(origin)
	if(!noise_turf)
		return
	for(var/mob/living/simple_animal/mount in range(radius, noise_turf))
		if(mount.mount_initialized)
			mount.mount_startle(noise_turf, duration, chance, TRUE)
