
/obj/effect/proc_holder/spell/invoked/chill_winds
	name = "Chill Winds"
	desc = "Призывает ледяной вихрь."
	cost = 5
	range = 7
	releasedrain = SPELLCOST_MAJOR_AOE
	chargetime = 15
	recharge_time = 20 SECONDS
	spell_tier = 3
	invocations = list("Venti Gelidi!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "chill_winds"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/chill_winds/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	if(!T)
		return FALSE

	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_3, WARLOCK_SCHOOL_FROST, src)
	damage_mult = warlock_get_damage_mult(context)

	playsound(T, 'sound/magic/abyssor_splash.ogg', 80, TRUE)
	new /obj/effect/temp_visual/tornado(T) 

	spawn(0)
		for(var/i in 1 to 20) 
			if(!T)
				break

			for(var/p in 1 to 4)
				new /obj/effect/temp_visual/ice_shard_whirl(T)

			if(i % 2 == 0)
				for(var/mob/living/L in range(1, T))
					if(L.anti_magic_check() || (L.has_status_effect(/datum/status_effect/buff/clash)))
						continue
					
					L.adjustBruteLoss(round(15 * damage_mult))
					L.apply_status_effect(/datum/status_effect/buff/frost)
					if(prob(20))
						L.apply_status_effect(/datum/status_effect/buff/frostbite)
					
					new /obj/effect/temp_visual/ice_shard_whirl(get_turf(L))

			sleep(5)

	warlock_spell_post_cast(user, WARLOCK_SLOT_3, WARLOCK_SCHOOL_FROST, TRUE, context)
	return TRUE


/obj/effect/temp_visual/tornado
	icon = 'icons/effects/clan.dmi'
	icon_state = "tornado"
	dir = NORTH
	name = "rippling arcyne energy"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 10 SECONDS
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/ice_shard_whirl
	name = "ice shard"
	icon = 'icons/effects/effects.dmi' 
	icon_state = "blueshatter2"
	duration = 6
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/ice_shard_whirl/Initialize(mapload)
	. = ..()
	var/target_x = rand(-32, 32)
	var/target_y = rand(-32, 32)
	animate(src, pixel_x = target_x, pixel_y = target_y, alpha = 0, time = duration, easing = EASE_OUT)
