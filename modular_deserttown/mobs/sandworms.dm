#define WORM_BURROWABLE(type) (istype(type, /turf/open/floor/rogue/dunes) || \
							   istype(type, /turf/open/floor/rogue/AzureSand))

/obj/effect/temp_visual/paw_swipe
	name = "sand slam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "dust"
	duration = 0.5 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm
	name = "sandworm"
	desc = "A monstrous worm that swims effortlessly through the desert."

	icon = 'modular_deserttown/icons/mob/monster/sandworm.dmi'
	icon_state = "worm"
	icon_living = "worm"
	icon_dead = "worm_dead"

	see_in_dark = 8
	base_intents = list(/datum/intent/simple/bite, /datum/intent/simple/claw)
	move_base_delay = MOVEMENT_DELAY_SPD_3

	environment_smash = ENVIRONMENT_SMASH_NONE

	footstep_type = null
	pooptype = null

	faction = list("sandworm")

	mob_biotypes = MOB_ORGANIC|MOB_BEAST

	aggressive = TRUE

	food = 0

	ai_controller = /datum/ai_controller/mole
	var/burrow_anim_time = 12
	var/burrow_travel_time = 15
	var/burrowed = FALSE
	var/next_burrow = 0
	var/burrow_cooldown = 8 SECONDS
	var/burrow_ambush_chance = 20
	var/burrow_retry_delay = 3 SECONDS
	var/burrow_fx_state = "leave-hatchling"
	var/emerge_fx_state = "invade-hatchling"

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/Initialize(mapload)
	. = ..()
	if(ai_controller)
		AddComponent(/datum/component/ai_aggro_system)
	AddComponent(/datum/component/deaggro_despawn, 120 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/can_burrow(turf/Turf)
	if(!Turf)
		Turf = get_turf(src)
	if(!isturf(Turf))
		return FALSE
	if(!WORM_BURROWABLE(Turf))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/burrow()
	if(burrowed)
		return
	if(!can_burrow())
		return
	burrowed = TRUE
	next_burrow = world.time + burrow_cooldown
	walk(src, 0)
	if(ai_controller)
		ai_controller.PauseAi(burrow_anim_time + burrow_travel_time + 1 SECONDS)
	visible_message(span_warning("[src] dives beneath the sand!"))
	play_burrow_fx(burrow_fx_state)
	addtimer(CALLBACK(src, PROC_REF(go_underground)), burrow_anim_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/go_underground()
	if(!burrowed)
		return
	status_flags |= GODMODE
	invisibility = INVISIBILITY_MAXIMUM
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	addtimer(CALLBACK(src, PROC_REF(travel_and_emerge)), burrow_travel_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/emerge()
	if(!burrowed)
		return
	burrowed = FALSE
	status_flags &= ~GODMODE
	invisibility = 0
	density = TRUE
	mouse_opacity = initial(mouse_opacity)
	if(ai_controller)
		ai_controller.paused_until = 0
	visible_message(span_danger("[src] erupts from beneath the sand!"))
	play_burrow_fx(emerge_fx_state)
	var/atom/current_target = ai_controller ? ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] : target
	if(current_target)
		target = current_target
		AttackingTarget()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/travel_and_emerge()
	if(!burrowed)
		return
	var/atom/current_target = ai_controller ? ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] : target
	var/turf/dest = current_target ? get_flank_turf(current_target) : get_turf(src)
	if(!dest || !can_burrow(dest))
		dest = get_turf(src)
	forceMove(dest)
	emerge()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/play_burrow_fx(state)
	var/image/fx = image(icon, loc = src, icon_state = state)
	fx.layer = FLY_LAYER
	fx.plane = plane

	var/list/client/show_to = list()
	for(var/mob/M as anything in viewers(src))
		if(M.client)
			show_to += M.client

	flick_overlay(fx, show_to, burrow_anim_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/proc/get_flank_turf(atom/A)
	if(!isliving(A))
		return get_turf(A)
	var/mob/living/Living = A
	var/behind_dir = turn(Living.dir, 180)
	var/turf/behind = get_step(Living, behind_dir)
	if(behind && can_burrow(behind))
		return behind
	return get_turf(Living)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/Life()
	. = ..()
	if(!.)
		return
	if(burrowed)
		return
	if(world.time >= next_burrow && can_burrow())
		var/atom/current_target = ai_controller ? ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] : target
		if(!current_target)
			burrow()
		else if(prob(burrow_ambush_chance))
			burrow()
		else
			next_burrow = world.time + burrow_retry_delay

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling
	name = "sand wormling"
	threat_point = THREAT_LOW
	icon_state = "hatchling"
	icon_living = "hatchling"
	icon_dead = "hatchling-dead"
	health = 65
	maxHealth = 65
	melee_damage_lower = 8
	melee_damage_upper = 14
	move_base_delay = MOVEMENT_DELAY_SPD_17
	STASPD = 11
	STASTR = 6
	STACON = 5
	burrow_anim_time = 8
	burrow_cooldown = 5 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling/AttackingTarget()
	if(burrowed)
		emerge()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/stalker
	name = "sand stalker"
	threat_point = THREAT_HIGH
	icon_living = "juvenile"
	icon_state = "juvenile"
	icon_dead = "juvenile-dead"
	health = 400
	maxHealth = 400
	melee_damage_lower = 22
	melee_damage_upper = 32
	move_base_delay = MOVEMENT_DELAY_SPD_10
	STASTR = 12
	STACON = 11
	STASPD = 10
	burrow_anim_time = 12
	burrow_cooldown = 4 SECONDS
	burrow_fx_state = "leave-juvenile"
	emerge_fx_state = "invade-juvenile"

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/stalker/AttackingTarget()
	. = ..()
	if(prob(40))
		addtimer(CALLBACK(src, PROC_REF(burrow)), 1 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder
	name = "elder sandworm"
	threat_point = THREAT_DEADLY
	icon_living = "adult"
	icon_state = "adult"
	icon_dead = "adult-dead"
	icon = 'modular_deserttown/icons/mob/monster/adultsandworm.dmi'
	health = 620
	maxHealth = 620
	melee_damage_lower = 35
	melee_damage_upper = 55
	move_base_delay = MOVEMENT_DELAY_SLOW
	STASTR = 15
	STACON = 12
	STASPD = 8
	burrow_anim_time = 12
	burrow_cooldown = 12 SECONDS
	var/charge_ready = TRUE
	var/charge_cooldown = 14 SECONDS
	var/charge_windup = 8
	var/charge_range_min = 2
	var/charge_range_max = 6
	var/charge_damage = 30
	var/charge_knockdown_time = 25
	var/charging = FALSE
	burrow_fx_state = "leave-adult"
	emerge_fx_state = "invade-adult"
	var/slam_ready = TRUE
	var/slam_cooldown = 12 SECONDS
	var/slam_cast_time = 1 SECONDS
	var/slam_range = 2
	var/slam_damage = 25
	var/slam_knockdown_time = 30

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/Life()
	. = ..()
	if(!. || burrowed || charging)
		return
	if(charge_ready)
		var/atom/current_target = ai_controller ? ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] : target
		if(current_target && isliving(current_target))
			var/mob/living/L = current_target
			if(L.stat != DEAD)
				var/dist = get_dist(src, L)
				if(dist >= charge_range_min && dist <= charge_range_max && can_see(src, L, charge_range_max))
					try_charge(L)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/AttackingTarget()
	var/atom/current_target = ai_controller ? ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] : target
	if(current_target)
		target = current_target
	if(slam_ready && isliving(target))
		slam_ready = FALSE
		addtimer(VARSET_CALLBACK(src, slam_ready, TRUE), slam_cooldown)
		try_slam(target)
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/try_charge(mob/living/victim)
	if(!charge_ready || charging || burrowed || stat != CONSCIOUS)
		return
	charge_ready = FALSE
	charging = TRUE
	addtimer(VARSET_CALLBACK(src, charge_ready, TRUE), charge_cooldown)
	if(ai_controller)
		ai_controller.PauseAi(charge_windup + 2 SECONDS)
	walk(src, 0)
	visible_message(span_boldwarning("[src] coils back tightly, preparing to charge at [victim]!"))
	playsound(loc, 'sound/combat/shieldraise.ogg', 80, TRUE)
	var/turf/warn_turf = get_turf(src)
	new /obj/effect/temp_visual/paw_swipe(warn_turf)
	addtimer(CALLBACK(src, PROC_REF(do_charge), victim, get_turf(victim)), charge_windup)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/do_charge(mob/living/victim, turf/target_turf)
	if(stat != CONSCIOUS || burrowed || !target_turf)
		charging = FALSE
		if(ai_controller)
			ai_controller.paused_until = 0
		return
	set waitfor = FALSE
	visible_message(span_danger("[src] charges across the sand!"))
	playsound(loc, 'sound/combat/wooshes/punch/punch (1).ogg', 100, TRUE)

	var/dir_to_target = get_dir(src, target_turf)
	if(dir_to_target)
		setDir(dir_to_target)
	var/steps = clamp(get_dist(src, target_turf), 1, charge_range_max)
	var/hit_someone = FALSE

	for(var/i in 1 to steps)
		if(stat != CONSCIOUS || burrowed)
			break
		var/step_dir = get_dir(src, target_turf)
		if(!step_dir)
			break
		var/turf/next_turf = get_step(src, step_dir)
		if(!next_turf || !next_turf.Enter(src))
			break
		step(src, step_dir)
		new /obj/effect/temp_visual/paw_swipe(get_turf(src))

		// Check collision with any living enemy
		for(var/mob/living/L in get_turf(src))
			if(L == src || (L.faction && (L.faction & faction).len))
				continue
			hit_charge(L)
			hit_someone = TRUE
			break
		if(hit_someone)
			break
		if(victim && get_dist(src, victim) <= 1)
			hit_charge(victim)
			hit_someone = TRUE
			break
		sleep(1)

	charging = FALSE
	if(ai_controller)
		ai_controller.paused_until = 0
	if(hit_someone && victim)
		target = victim
		AttackingTarget()

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/hit_charge(mob/living/victim)
	if(!isliving(victim) || victim.stat == DEAD)
		return

	// 1. Put victim off-balance first
	victim.OffBalance(3 SECONDS)

	// 2. Perform kick / shove
	var/shove_dir = get_dir(src, victim) || dir
	var/turf/shove_turf = get_step(victim, shove_dir)
	var/shove_blocked = FALSE
	if(shove_turf)
		if(!victim.Move(shove_turf, shove_dir))
			shove_blocked = TRUE
	else
		shove_blocked = TRUE

	// 3. Since target is off-balanced, kick guarantees knockdown and drops held items
	var/knockdown_dur = shove_blocked ? SHOVE_KNOCKDOWN_SOLID : charge_knockdown_time
	victim.Knockdown(knockdown_dur)
	victim.drop_all_held_items()

	// 4. Apply damage with armor reduction
	var/def_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/blocked = victim.run_armor_check(def_zone, "blunt", damage = charge_damage)
	victim.apply_damage(charge_damage, BRUTE, def_zone, blocked)

	playsound(victim, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)
	playsound(victim, 'sound/combat/hits/blunt/metalblunt (1).ogg', 100, TRUE)

	to_chat(victim, span_userdanger("[src] barrels directly into you, kicking you off your feet!"))
	visible_message(span_danger("[src] slams full force into [victim], kicking [victim.p_them()] down!"))
	new /obj/effect/temp_visual/paw_swipe(get_turf(victim))

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/try_slam(atom/target_atom)
	var/dist = get_dist(src, target_atom)
	if(!can_see(src, target_atom, slam_range) || dist >= slam_range || dist > 1)
		return
	visible_message(span_boldwarning("[src] rears up, sand cascading off its coils!"))
	var/turf/warn_turf = get_turf(target_atom)
	new /obj/effect/temp_visual/paw_swipe(warn_turf)
	addtimer(CALLBACK(src, PROC_REF(do_slam), target_atom), slam_cast_time)

/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/elder/proc/do_slam(atom/target_atom)
	var/dist = get_dist(src, target_atom)
	if(!can_see(src, target_atom, slam_range) || dist >= slam_range || dist > 1)
		visible_message(span_alert("[src] slams into empty sand as [target_atom.p_they()] dodge clear!"))
		return
	playsound(loc, 'sound/combat/shieldraise.ogg', 100)
	if(isliving(target_atom))
		var/mob/living/victim = target_atom
		victim.OffBalance(3 SECONDS)
		var/def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST)
		var/blocked = victim.run_armor_check(def_zone, "stab", damage = slam_damage)
		victim.apply_damage(slam_damage, BRUTE, def_zone, blocked)
		victim.Knockdown(slam_knockdown_time)
		victim.drop_all_held_items()
		var/turf/target_turf = get_turf(target_atom)
		new /obj/effect/temp_visual/paw_swipe(target_turf)
		to_chat(victim, span_userdanger("[src] slams down on top of you!"))
		playsound(victim, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
