#define BALL_WEAK_KICK_RANGE 2
#define BALL_DEFAULT_KICK_RANGE 3
#define BALL_STRONG_KICK_RANGE 5
#define BALL_FEINT_KICK_RANGE 3
#define BALL_DEFEND_KICK_RANGE 1

#define BALL_WEAK_KICK_SPEED 0.35
#define BALL_DEFAULT_KICK_SPEED 0.5
#define BALL_STRONG_KICK_SPEED 0.75
#define BALL_FEINT_KICK_SPEED 0.5
#define BALL_DEFEND_KICK_SPEED 0.35

#define BALL_WEAK_KICK_COOLDOWN 1 SECONDS
#define BALL_DEFAULT_KICK_COOLDOWN 1.5 SECONDS
#define BALL_STRONG_KICK_COOLDOWN 3 SECONDS
#define BALL_FEINT_KICK_COOLDOWN 1.5 SECONDS
#define BALL_DEFEND_KICK_COOLDOWN 0.5 SECONDS

#define BALL_ROLL_ANIMATION_LENGTH 4
#define BALL_HAND_THROW_PIXEL_Y 8


/atom/proc/get_kick_cooldown(mob/living/user)
	return null

/atom/proc/uses_ball_kick_recovery()
	return FALSE

/obj/item/ball
	name = "leather ball"
	desc = "Сшитый кожаный мяч. Его можно бросать руками или пинать ногой."
	icon = 'modular_twilight_axis/icons/obj/ball.dmi'
	icon_state = "ball"

	w_class = WEIGHT_CLASS_SMALL
	force = 0
	throwforce = 1
	throw_range = 7
	throw_speed = 0.85

	var/tmp/rolling = FALSE
	var/tmp/roll_token = 0
	var/tmp/next_throw_bounce_power = null
	var/tmp/current_throw_bounce_power = null
	var/tmp/current_throw_dir = null
	var/tmp/hand_throw_visual = FALSE

/obj/item/ball/uses_ball_kick_recovery()
	return TRUE

/obj/item/ball/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("При включении разных интентов мяч может вести себя по разному. Будет отличаться дальность полета, скорость и время восстановления после пинка.")
	. += span_info("Пинок по мячу с включенными интентами Aimed и Swift делает обычный пинок на 3 тайла с восстановлением в 1.5 секунды.")
	. += span_info("Strong Kick бьет мяч сильнее всего: он летит на 5 тайлов и дает 3 секунды восстановления.")
	. += span_info("Weak Kick делает короткий слабый пинок на 2 тайла и дает 1 секунду восстановления.")
	. += span_info("Feint Kick пинает мяч по диагонали вперед в сторону выбранной руки на 3 тайла и дает 1.5 секунды восстановления.")
	. += span_info("Defend Kick переводит мяч по кругу вокруг персонажа в сторону выбранной руки и дает 0.5 секунды восстановления.")

/obj/item/ball/onkick(mob/user)
	if(!isliving(user))
		return FALSE

	var/mob/living/living_user = user
	return kick_act(living_user)

/obj/item/ball/get_kick_cooldown(mob/living/user)
	var/list/kick_data = get_kick_data(user)
	return kick_data["cooldown"] || BALL_DEFAULT_KICK_COOLDOWN

/obj/item/ball/proc/kick_act(mob/living/user)
	if(!user || QDELETED(user))
		return FALSE

	if(!isturf(loc))
		return FALSE

	if(!user.Adjacent(src))
		return FALSE

	if(user.incapacitated())
		return FALSE

	var/list/kick_data = get_kick_data(user)
	if(!kick_data)
		return FALSE

	var/kick_range = kick_data["range"] || BALL_DEFAULT_KICK_RANGE
	var/kick_speed = kick_data["speed"] || BALL_DEFAULT_KICK_SPEED
	var/kick_cooldown = kick_data["cooldown"] || BALL_DEFAULT_KICK_COOLDOWN
	var/kick_dir = kick_data["dir"]

	var/turf/start_turf = get_turf(src)
	if(!start_turf)
		return FALSE

	if(!kick_dir)
		kick_dir = get_dir(user, src)
	if(!kick_dir)
		kick_dir = user.dir

	var/turf/target_turf = kick_data["target_turf"]
	if(!target_turf)
		target_turf = get_ranged_target_turf(start_turf, kick_dir, kick_range)

	if(!target_turf)
		return FALSE

	user.face_atom(src)
	dir = kick_dir

	user.visible_message(
		span_notice("[user] kicks \the [src]!"),
		span_notice("I kick \the [src]!")
	)

	var/current_roll_token = start_roll_animation()
	var/roll_stop_delay = max(BALL_ROLL_ANIMATION_LENGTH, CEILING(1 / kick_speed, 1))
	var/successfully_kicked = FALSE

	var/list/object_blocker_data = get_kick_object_blocker_data(start_turf, kick_dir, kick_range)
	if(object_blocker_data)
		var/turf/pre_block_turf = object_blocker_data["previous_turf"]
		var/distance_to_blocker = object_blocker_data["distance"] || 1
		var/forward_range = max(distance_to_blocker - 1, 0)

		if(forward_range <= 0 || pre_block_turf == start_turf)
			successfully_kicked = bounce_from_direction(kick_range, kick_speed, kick_dir, user)
			if(!successfully_kicked)
				stop_roll_animation(current_roll_token)
		else
			next_throw_bounce_power = kick_range
			current_throw_dir = kick_dir
			successfully_kicked = throw_at(pre_block_turf, forward_range, kick_speed, user, spin = FALSE, callback = CALLBACK(src, PROC_REF(kick_bounce_after_object_block), current_roll_token, roll_stop_delay, kick_range, kick_speed, kick_dir, user))
			if(!successfully_kicked)
				next_throw_bounce_power = null
				current_throw_bounce_power = null
				stop_roll_animation(current_roll_token)
	else
		next_throw_bounce_power = kick_range
		current_throw_dir = kick_dir
		successfully_kicked = throw_at(target_turf, kick_range, kick_speed, user, spin = FALSE, callback = CALLBACK(src, PROC_REF(queue_stop_roll_animation), current_roll_token, roll_stop_delay))
		if(!successfully_kicked)
			next_throw_bounce_power = null
			current_throw_bounce_power = null
			stop_roll_animation(current_roll_token)

	if(!successfully_kicked)
		return FALSE

	return kick_cooldown

/obj/item/ball/proc/get_kick_data(mob/living/user)
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		return list(
			"range" = BALL_STRONG_KICK_RANGE,
			"speed" = BALL_STRONG_KICK_SPEED,
			"cooldown" = BALL_STRONG_KICK_COOLDOWN,
		)

	if(istype(user.rmb_intent, /datum/rmb_intent/weak))
		return list(
			"range" = BALL_WEAK_KICK_RANGE,
			"speed" = BALL_WEAK_KICK_SPEED,
			"cooldown" = BALL_WEAK_KICK_COOLDOWN,
		)

	if(istype(user.rmb_intent, /datum/rmb_intent/feint))
		var/feint_dir = get_hand_forward_diagonal_dir(user)
		return list(
			"range" = BALL_FEINT_KICK_RANGE,
			"speed" = BALL_FEINT_KICK_SPEED,
			"cooldown" = BALL_FEINT_KICK_COOLDOWN,
			"dir" = feint_dir,
		)

	if(istype(user.rmb_intent, /datum/rmb_intent/riposte))
		var/defend_side_dir = get_hand_side_dir(user)
		var/turf/defend_target_turf = get_defend_target_turf(user, defend_side_dir)
		return list(
			"range" = BALL_DEFEND_KICK_RANGE,
			"speed" = BALL_DEFEND_KICK_SPEED,
			"cooldown" = BALL_DEFEND_KICK_COOLDOWN,
			"dir" = get_dir(src, defend_target_turf),
			"target_turf" = defend_target_turf,
		)

	return list(
		"range" = BALL_DEFAULT_KICK_RANGE,
		"speed" = BALL_DEFAULT_KICK_SPEED,
		"cooldown" = BALL_DEFAULT_KICK_COOLDOWN,
	)

/obj/item/ball/proc/get_hand_side_dir(mob/living/user)
	var/base_dir = user.dir
	if(!base_dir)
		base_dir = get_dir(user, src)
	if(!base_dir)
		return null

	var/right_hand = (user.active_hand_index != 1)

	switch(base_dir)
		if(NORTH)
			return right_hand ? EAST : WEST
		if(SOUTH)
			return right_hand ? WEST : EAST
		if(EAST)
			return right_hand ? SOUTH : NORTH
		if(WEST)
			return right_hand ? NORTH : SOUTH

	return turn(base_dir, right_hand ? -90 : 90)

/obj/item/ball/proc/get_hand_forward_diagonal_dir(mob/living/user)
	var/front_dir = user.dir
	if(!front_dir)
		front_dir = get_dir(user, src)
	if(!front_dir)
		return null

	var/side_dir = get_hand_side_dir(user)
	if(!side_dir)
		return front_dir

	return front_dir | side_dir

/obj/item/ball/proc/get_defend_target_turf(mob/living/user, side_dir)
	var/turf/user_turf = get_turf(user)
	if(!user_turf || !side_dir)
		return null

	var/front_dir = user.dir
	if(!front_dir)
		front_dir = get_dir(user, src)
	if(!front_dir)
		return get_step(user_turf, side_dir)

	var/ball_dir = get_dir(user, src)
	var/selected_front_diagonal = front_dir | side_dir
	var/opposite_side_dir = turn(side_dir, 180)
	var/opposite_front_diagonal = front_dir | opposite_side_dir

	if(ball_dir == front_dir)
		var/turf/front_turf = get_step(user_turf, front_dir)
		if(front_turf)
			return get_step(front_turf, side_dir)
		return null

	if(ball_dir == selected_front_diagonal || ball_dir == opposite_front_diagonal)
		return get_step(user_turf, side_dir)

	return get_step(user_turf, side_dir)

/obj/item/ball/proc/get_kick_object_blocker_data(turf/start_turf, kick_dir, kick_range)
	if(!start_turf || !kick_dir || kick_range <= 0)
		return null

	var/turf/current_turf = start_turf
	for(var/i in 1 to kick_range)
		var/turf/next_turf = get_step(current_turf, kick_dir)
		if(!next_turf)
			return null

		var/atom/movable/blocker = get_kick_object_blocker_on_turf(next_turf)
		if(blocker)
			return list(
				"blocker" = blocker,
				"previous_turf" = current_turf,
				"distance" = i,
			)

		current_turf = next_turf

	return null

/obj/item/ball/proc/get_kick_object_blocker_on_turf(turf/check_turf)
	if(!check_turf)
		return null

	for(var/atom/movable/blocker as anything in check_turf)
		if(blocker == src)
			continue
		if(!istype(blocker, /obj/structure) && !istype(blocker, /obj/machinery))
			continue
		if(should_ignore_kick_object_blocker(blocker))
			continue
		return blocker

	return null

/obj/item/ball/proc/should_ignore_kick_object_blocker(atom/movable/blocker)
	if(!blocker)
		return TRUE

	var/static/list/ignored_blocker_types = typecacheof(list(
		/obj/structure/flora/roguegrass,
		/obj/structure/far_travel,
		/obj/structure/flora/newbranch,
	))

	return is_type_in_typecache(blocker, ignored_blocker_types)

/obj/item/ball/proc/kick_bounce_after_object_block(expected_roll_token, stop_delay, bounce_power, bounce_speed, bounce_dir, mob/living/thrower)
	if(QDELETED(src))
		return
	if(expected_roll_token != roll_token)
		return
	if(!bounce_from_direction(bounce_power, bounce_speed, bounce_dir, thrower))
		queue_stop_roll_animation(expected_roll_token, stop_delay)

/obj/item/ball/proc/bounce_from_direction(bounce_power, bounce_speed, bounce_dir, mob/living/thrower)
	var/turf/start_turf = get_turf(src)
	if(!start_turf || bounce_power <= 0 || !bounce_dir)
		return FALSE

	var/bounce_range = CEILING(bounce_power / 2, 1)
	if(bounce_range <= 0)
		return FALSE

	var/reverse_dir = turn(bounce_dir, 180)
	var/turf/target_turf = get_ranged_target_turf(start_turf, reverse_dir, bounce_range)
	if(!target_turf)
		return FALSE

	dir = reverse_dir

	var/current_roll_token = start_roll_animation()
	var/roll_stop_delay = max(BALL_ROLL_ANIMATION_LENGTH, CEILING(1 / bounce_speed, 1))

	next_throw_bounce_power = bounce_range
	current_throw_dir = reverse_dir

	if(!throw_at(target_turf, bounce_range, bounce_speed, thrower, spin = FALSE, callback = CALLBACK(src, PROC_REF(queue_stop_roll_animation), current_roll_token, roll_stop_delay)))
		next_throw_bounce_power = null
		current_throw_bounce_power = null
		stop_roll_animation(current_roll_token)
		return FALSE

	return TRUE

/obj/item/ball/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force)
	var/is_kick_or_bounce_throw = !isnull(next_throw_bounce_power)
	current_throw_bounce_power = next_throw_bounce_power
	current_throw_dir = get_dir(src, target)
	next_throw_bounce_power = null

	var/current_roll_token = null
	if(!is_kick_or_bounce_throw)
		start_hand_throw_visual()
		current_roll_token = start_roll_animation()
		var/roll_stop_delay = max(BALL_ROLL_ANIMATION_LENGTH, CEILING(1 / (speed || throw_speed || 1), 1))
		callback = CALLBACK(src, PROC_REF(finish_hand_throw), callback, current_roll_token, roll_stop_delay)

	. = ..(target, range, speed, thrower, spin, diagonals_first, callback, force)
	if(!.)
		current_throw_bounce_power = null
		current_throw_dir = null
		if(!is_kick_or_bounce_throw)
			stop_hand_throw_visual()
		if(!isnull(current_roll_token))
			stop_roll_animation(current_roll_token)

/obj/item/ball/proc/finish_hand_throw(datum/callback/original_callback, expected_roll_token, stop_delay)
	if(original_callback)
		original_callback.Invoke()
	queue_stop_roll_animation(expected_roll_token, stop_delay)

/obj/item/ball/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(should_bounce_from_wall(hit_atom, throwingdatum))
		if(bounce_from_wall(throwingdatum))
			return
	return ..()

/obj/item/ball/proc/should_bounce_from_wall(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!hit_atom || QDELETED(hit_atom) || !throwingdatum)
		return FALSE
	if(ismob(hit_atom))
		return FALSE
	if(get_bounce_power(throwingdatum) <= 0)
		return FALSE
	if(isturf(hit_atom))
		return hit_atom.density

	if(istype(hit_atom, /atom/movable))
		var/atom/movable/blocker = hit_atom
		return blocker.density && blocker.anchored
	return FALSE

/obj/item/ball/proc/get_bounce_power(datum/thrownthing/throwingdatum)
	if(!throwingdatum)
		return 0

	if(!isnull(current_throw_bounce_power))
		return current_throw_bounce_power

	return throwingdatum.dist_travelled

/obj/item/ball/proc/bounce_from_wall(datum/thrownthing/throwingdatum)
	var/bounce_dir = current_throw_dir || throwingdatum.init_dir || dir
	if(!bounce_dir)
		return FALSE

	return bounce_from_direction(get_bounce_power(throwingdatum), throwingdatum.speed || BALL_DEFAULT_KICK_SPEED, bounce_dir, throwingdatum.thrower)

/obj/item/ball/proc/start_hand_throw_visual()
	hand_throw_visual = TRUE
	pixel_y = initial(pixel_y) + BALL_HAND_THROW_PIXEL_Y

/obj/item/ball/proc/stop_hand_throw_visual()
	if(!hand_throw_visual)
		return
	hand_throw_visual = FALSE
	pixel_y = initial(pixel_y)

/obj/item/ball/proc/start_roll_animation()
	rolling = TRUE
	roll_token++
	var/current_roll_token = roll_token
	run_roll_animation(current_roll_token)
	return current_roll_token

/obj/item/ball/proc/run_roll_animation(expected_roll_token)
	set waitfor = FALSE

	while(rolling && !QDELETED(src) && expected_roll_token == roll_token)
		flick("ball_roll", src)
		sleep(BALL_ROLL_ANIMATION_LENGTH)

/obj/item/ball/proc/queue_stop_roll_animation(expected_roll_token, stop_delay)
	if(QDELETED(src))
		return
	if(expected_roll_token != roll_token)
		return
	addtimer(CALLBACK(src, PROC_REF(stop_roll_animation), expected_roll_token), stop_delay)

/obj/item/ball/proc/stop_roll_animation(expected_roll_token)
	if(QDELETED(src))
		return
	if(!isnull(expected_roll_token) && expected_roll_token != roll_token)
		return
	rolling = FALSE
	current_throw_bounce_power = null
	current_throw_dir = null
	stop_hand_throw_visual()
	icon_state = initial(icon_state)

#undef BALL_WEAK_KICK_RANGE
#undef BALL_DEFAULT_KICK_RANGE
#undef BALL_STRONG_KICK_RANGE
#undef BALL_FEINT_KICK_RANGE
#undef BALL_DEFEND_KICK_RANGE

#undef BALL_WEAK_KICK_SPEED
#undef BALL_DEFAULT_KICK_SPEED
#undef BALL_STRONG_KICK_SPEED
#undef BALL_FEINT_KICK_SPEED
#undef BALL_DEFEND_KICK_SPEED

#undef BALL_WEAK_KICK_COOLDOWN
#undef BALL_DEFAULT_KICK_COOLDOWN
#undef BALL_STRONG_KICK_COOLDOWN
#undef BALL_FEINT_KICK_COOLDOWN
#undef BALL_DEFEND_KICK_COOLDOWN

#undef BALL_ROLL_ANIMATION_LENGTH
#undef BALL_HAND_THROW_PIXEL_Y
