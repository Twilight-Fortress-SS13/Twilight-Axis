
/obj/effect/proc_holder/spell/invoked/dragon_breath
	name = "Dragon Breath"
	desc = "Изрыгает поток пламени в конусе."
	cost = 4
	range = 3
	releasedrain = SPELLCOST_MAJOR_AOE
	chargetime = 10
	recharge_time = 15 SECONDS
	spell_tier = 3
	invocations = list("Ignis Fatuus!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	charging_slowdown = 2
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "dragon_breath"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/dragon_breath/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FIRE, src)
	damage_mult = src.damage_mult

	spawn(0)
		var/duration = 3 SECONDS
		var/interval = 2 
		var/max_ticks = duration / interval
		
		for(var/i in 1 to max_ticks)
			if(!user || user.stat || user.incapacitated())
				break
			
			var/current_dir = user.dir
			var/turf/user_turf = get_turf(user)
			var/user_angle = dir2angle(current_dir)

			for(var/p in 1 to 6)
				new /obj/effect/temp_visual/dragon_fire_particle(user_turf, current_dir)

			playsound(user_turf, 'sound/items/firelight.ogg', 40, TRUE)

			for(var/turf/T in view(range, user_turf))
				var/dist = get_dist(user_turf, T)
				if(dist == 0)
					continue

				var/target_angle = Get_Angle(user_turf, T)
				var/angle_diff = abs(closer_angle_difference(user_angle, target_angle))

				if(angle_diff <= 30)
					for(var/mob/living/L in T.contents)
						if(L == user)
							continue
						if(L.anti_magic_check() || (L.has_status_effect(/datum/status_effect/buff/clash)))
							continue
						
						L.adjust_fire_stacks(1)
						L.ignite_mob()
						arcyne_strike(user, L, null, round(7 * damage_mult), BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Dragon Breath", skip_animation = TRUE, skip_message = (i > 1))
			
			sleep(interval)

	warlock_spell_post_cast(user, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FIRE, TRUE, context)
	return TRUE

/obj/effect/temp_visual/dragon_fire_particle
	name = "fire breath"
	icon = 'icons/effects/effects.dmi'
	icon_state = "mech_fire"
	duration = 8
	layer = ABOVE_MOB_LAYER
	appearance_flags = RESET_TRANSFORM | PIXEL_SCALE

/obj/effect/temp_visual/dragon_fire_particle/Initialize(mapload, direction)
	. = ..()
	var/dist = 3
	var/p_x = 0
	var/p_y = 0
	var/side_variance = rand(-48, 48) 
	var/forward_dist = 32 * dist

	switch(direction)
		if(NORTH)
			p_y = forward_dist
			p_x = side_variance
		if(SOUTH)
			p_y = -forward_dist
			p_x = side_variance
		if(EAST)
			p_x = forward_dist
			p_y = side_variance
		if(WEST)
			p_x = -forward_dist
			p_y = side_variance

	animate(src, pixel_x = p_x, pixel_y = p_y, alpha = 0, time = duration, easing = SINE_EASING)
