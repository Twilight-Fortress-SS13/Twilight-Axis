
/obj/effect/proc_holder/spell/invoked/immolate
	name = "Immolate"
	desc = "Вы превращаете свое тело в живой костер. Аура испепеляет врагов и замедляет их термическим шоком."
	cost = 6
	range = 0
	releasedrain = SPELLCOST_ULTIMATE
	chargetime = 15
	recharge_time = 30 SECONDS
	spell_tier = 4
	invocations = list("CONSUMERE!")
	invocation_type = "shout"
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "immolate"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/immolate/cast(list/targets, mob/user)
	var/turf/center = get_turf(user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FIREFROST, src)
	damage_mult = src.damage_mult
	
	new /obj/effect/temp_visual/explosion(center)
	playsound(center, 'sound/magic/fireball.ogg', 100, TRUE)

	user.add_filter("immolate_glow", 2, list("type" = "outline", "color" = "#ff4500", "size" = 2))

	spawn(0)
		var/duration = 10 SECONDS
		var/tick_interval = 5 
		var/total_ticks = duration / tick_interval

		for(var/i in 1 to total_ticks)
			if(!user || user.stat >= UNCONSCIOUS)
				break
			
			var/turf/U_turf = get_turf(user)
			
			user.set_light(3, rand(2, 4), "#ff4500")

			if(prob(50))
				new /obj/effect/temp_visual/fire(U_turf)

			for(var/mob/living/L in orange(1, U_turf))
				if(L == user || L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				
				L.adjust_fire_stacks(3)
				L.ignite_mob()
				L.apply_status_effect(/datum/status_effect/buff/frostbite)
				
				arcyne_strike(user, L, null, round(12 * damage_mult), BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Immolate Aura", skip_animation = TRUE, skip_message = (i > 1))

			sleep(tick_interval)
		
		if(user)
			user.remove_filter("immolate_glow")
			user.set_light(0)
			to_chat(user, span_notice("Ваше пламя угасает."))

	warlock_spell_post_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FIREFROST, TRUE, context)
	return TRUE
