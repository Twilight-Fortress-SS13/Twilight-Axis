
/obj/effect/proc_holder/spell/invoked/cold_glare
	name = "Cold Glare"
	desc = "Вы излучаете лучи мороза."
	cost = 4
	range = 3
	releasedrain = SPELLCOST_SINGLE_CC
	chargetime = 5
	recharge_time = 15 SECONDS
	spell_tier = 2
	invocations = list("Stare In Glacie!")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_ICE
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "cold_glare"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/cold_glare/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FROST, src)
	damage_mult = src.damage_mult

	var/turf/user_turf = get_turf(user)
	var/dir_to_target = get_dir(user_turf, targets[1])
	user.setDir(dir_to_target)
	
	var/user_angle = dir2angle(user.dir)

	playsound(user_turf, 'sound/magic/abyssor_splash.ogg', 100, TRUE)

	for(var/turf/T in orange(range, user))
		if(T == user_turf) 
			continue
		
		if(T.density)
			continue

		var/target_angle = Get_Angle(user_turf, T)
		var/angle_diff = abs(closer_angle_difference(user_angle, target_angle))

		if(angle_diff <= 30)
			new /obj/effect/temp_visual/ice_block(T)
			for(var/mob/living/L in T.contents)
				if(L == user || L.stat == DEAD) 
					continue
				if(L.anti_magic_check() || spell_guard_check(L))
					continue
				
				L.Immobilize(3 SECONDS)
				L.apply_status_effect(/datum/status_effect/buff/frostbite)
				
				to_chat(L, span_userdanger("Ваш взор застилает магический иней!"))
				arcyne_strike(user, L, null, round(15 * damage_mult), BODY_ZONE_CHEST, BCLASS_BURN, damage_type = BURN, spell_name = "Cold Glare", skip_animation = TRUE)

	warlock_spell_post_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FROST, TRUE, context)
	return TRUE

/obj/effect/temp_visual/ice_block
	icon = 'modular_twilight_axis/icons/effects/freeze.dmi'
	icon_state = "ice"
	duration = 3 SECONDS
