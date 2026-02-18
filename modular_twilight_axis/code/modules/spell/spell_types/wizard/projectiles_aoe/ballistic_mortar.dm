#define BALLISTIC_GRAVITY 9.81
#ifndef PI
#define PI 3.14159
#endif

/obj/effect/proc_holder/spell/invoked/ballistic_mortar
	name = "Arcane Mortar"
	desc = "Launches a fireball upwards at high speed."
	overlay_state = "fireball"
	releasedrain = 20
	chargetime = 0 
	cost = 10
	var/prepare_time = 200 
	recharge_time = 60 SECONDS
	range = 35 
	selection_type = "range"
	warnie = "spellwarning"
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	movement_interrupt = TRUE
	xp_gain = TRUE

/obj/effect/proc_holder/spell/invoked/ballistic_mortar/cast(list/targets, mob/living/carbon/human/user = usr)
	var/turf/T = get_turf(targets[1])
	if(!T) return FALSE

	var/azimuth = Get_Angle(user, T)
	var/in_dist = input(user, "Enter Target Distance (0-50 tiles):", "Ballistics", 0) as num|null
	if(isnull(in_dist) || user.stat != CONSCIOUS)
		revert_cast()
		return FALSE
	var/user_distance = clamp(in_dist, 0, 50)


	var/obj/item/starting_item = user.get_active_held_item()
	var/starting_next_move = user.next_move
	var/turf/starting_loc = user.loc

	user.visible_message("<span class='userdanger'><font size=4><b>[user]</b> begins a deep chant! The ritual circle begins to pulse!</font></span>")
	
	var/obj/effect/mortar_ritual_aura/AUR = new(user.loc)
	var/matrix/MA = matrix()
	MA.Scale(0.1, 0.1)
	AUR.transform = MA
	

	animate(AUR, transform = matrix().Scale(2.25, 2.25), time = prepare_time, easing = LINEAR_EASING)

	var/datum/progressbar/prog_bar = new(user, prepare_time, user)
	var/datum/looping_sound/invokegen/SND = new(user)
	SND.start()

	var/success = TRUE
	var/failure_msg = ""

	for(var/i in 1 to prepare_time)

		if(user.stat != CONSCIOUS || QDELETED(user))
			success = FALSE
			break
		if(user.loc != starting_loc)
			success = FALSE
			failure_msg = "Preparation failed!"
			break
		if(user.incapacitated() || user.IsKnockdown())
			success = FALSE
			failure_msg = "Preparation failed!"
			break
		if(user.get_active_held_item() != starting_item)
			success = FALSE
			failure_msg = "Preparation failed!"
			break
		if(user.next_move > starting_next_move && user.next_move > world.time)
			success = FALSE
			failure_msg = "Preparation failed!"
			break


		var/frequency = 5 + ((i / prepare_time) * 45) 
		var/pulse_val = abs(sin(i * frequency)) 
		
		AUR.color = BlendRGB("#FFFFFF", "#FF0000", pulse_val)
		AUR.alpha = 150 + (pulse_val * 105) 

		if(i % 40 == 0) do_sparks(2, FALSE, user)

		prog_bar.update(i)
		sleep(1)

	SND.stop()
	qdel(SND)
	qdel(prog_bar)

	if(!success)
		if(failure_msg) to_chat(user, span_warning(failure_msg))
		user.visible_message(span_danger("<b>[user]'s ritual collapses!</b>"))
		do_sparks(5, TRUE, user)
		qdel(AUR)
		revert_cast()
		return FALSE

	qdel(AUR)

	var/turf/ceiling = get_step_multiz(user, UP)
	if(ceiling && !istransparentturf(ceiling))
		user.visible_message("<span class='userdanger'><font size=4>THE FIREBALL EXPLODES AGAINST THE CEILING!</font></span>")
		playsound(user.loc, 'sound/magic/fireball.ogg', 100, TRUE)
		explosion(user.loc, 0, 1, 2, 3)
		if(isturf(ceiling)) ceiling.take_damage(60, BURN, "effect", TRUE)
		return TRUE

	user.visible_message("<span class='userdanger'><font size=5><b>[user] RELEASES THE ARCANE CHARGE!</b></font></span>")
	perform_ballistic_launch(user, azimuth, user_distance)
	return TRUE

/obj/effect/proc_holder/spell/invoked/ballistic_mortar/proc/perform_ballistic_launch(mob/living/carbon/human/user, azimuth, distance)
	var/turf/origin = get_turf(user)
	var/obj/effect/temp_visual/fireball_anim/LA = new(origin)
	animate(LA, pixel_z = 450, alpha = 0, time = 10, easing = SINE_EASING)
	playsound(user, 'modular_twilight_axis/awful_artillery/sound/launch.ogg', 100, TRUE)

	var/dx = round(distance * sin(azimuth))
	var/dy = round(distance * cos(azimuth))
	var/turf/target_turf = locate(origin.x + dx, origin.y + dy, origin.z)
	if(!target_turf)
		target_turf = get_ranged_target_turf(origin, azimuth, distance)

	var/obj/item/artillery_shell/magic_fireball/S = new(target_turf)
	S.safe_z = origin.z
	var/air_time = 10 + round(distance * 0.6)
	addtimer(CALLBACK(S, TYPE_PROC_REF(/obj/item/artillery_shell/magic_fireball, start_impact_sequence)), air_time)



/obj/item/artillery_shell/magic_fireball
	name = "arcane fireball"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "fireball"
	invisibility = 101
	var/safe_z

/obj/item/artillery_shell/magic_fireball/proc/start_impact_sequence()
	var/turf/T = get_turf(src)
	var/obj/effect/temp_visual/fireball_anim/F = new(T, 180)
	F.pixel_z = 450 
	F.set_light(3, 2, "#ffcc00")
	animate(F, pixel_z = 0, time = 10, easing = SINE_EASING)
	playsound(T, 'modular_twilight_axis/awful_artillery/sound/fallingonyou.ogg', 100, FALSE)
	addtimer(CALLBACK(src, PROC_REF(execute_explosion), F), 10)

/obj/item/artillery_shell/magic_fireball/proc/execute_explosion(obj/effect/temp_visual/fireball_anim/F)
	var/turf/T = get_turf(src)
	if(F) qdel(F) 
	var/turf/final_T = T
	var/turf/above = get_step_multiz(final_T, UP)
	while(above)
		final_T = above
		above = get_step_multiz(final_T, UP)
	var/turf/below = get_step_multiz(final_T, DOWN)
	while(below && istransparentturf(final_T))
		final_T = below
		below = get_step_multiz(final_T, DOWN)
	if(!final_T)
		qdel(src)
		return
	for(var/mob/M in GLOB.player_list)
		M.playsound_local(final_T, 'modular_twilight_axis/awful_artillery/sound/far_explosion.ogg', 60, FALSE)
	if(isclosedturf(final_T))
		explosion(final_T, 0, 1, 2, 3) 
	else 
		explosion(final_T, 0, 1, 2, 3, flame_range = 2, smoke = TRUE)
		if(final_T.z != safe_z) 
			if(isopenturf(final_T) && final_T.max_integrity > 0)
				final_T.ChangeTurf(/turf/open/transparent/openspace)
			
			var/turf/t_below = get_step_multiz(final_T, DOWN)
			if(t_below)
				explosion(t_below, 0, 0, 1, 2, flame_range = 1)
		else
			for(var/turf/open/OT in range(1, final_T))
				if(prob(50) && isopenturf(OT))
					new /obj/effect/hotspot(OT)
	qdel(src)

/obj/effect/temp_visual/fireball_anim
	name = "fireball"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "fireball"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER

/obj/effect/temp_visual/fireball_anim/Initialize(mapload, rotation = 0)
	. = ..()
	if(rotation)
		var/matrix/M = matrix()
		M.Turn(rotation)
		transform = M

/obj/effect/mortar_ritual_aura
	name = "arcane circle"
	desc = "arcane symbols pulse upon the ground..."
	icon = 'icons/obj/rune.dmi'
	icon_state = "6"
	color = "#FFFFFF" 
	alpha = 200
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = SIGIL_LAYER 
	plane = GAME_PLANE 
	appearance_flags = PIXEL_SCALE | TILE_BOUND

#undef BALLISTIC_GRAVITY
