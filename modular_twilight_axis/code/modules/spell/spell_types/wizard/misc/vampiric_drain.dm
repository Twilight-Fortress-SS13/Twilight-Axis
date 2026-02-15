/obj/effect/proc_holder/spell/invoked/vampiric_drain
	name = "Vampiric Drain"
	desc = "Channels a dark link to steal life from a target over 10 seconds. Higher arcane skill increases the potency."
	overlay_state = "bloodlightning"
	releasedrain = 40
	chargedrain = 1
	chargetime = 30
	range = 2
	cost = 6
	spell_tier = 3
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	invocations = list("Sakra!")
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	ignore_los = FALSE
	zizo_spell = TRUE

	var/drain_duration = 18 SECONDS 
	var/tick_delay = 10 
	var/base_damage = 2 
	var/ramp_multiplier = 2.5 
	var/heal_ratio = 1.5 

/obj/effect/proc_holder/spell/invoked/vampiric_drain/cast(list/targets, mob/living/user = usr)
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	
	if(HAS_TRAIT(target, TRAIT_PSYDONITE))
		user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return FALSE

	if(istype(target, /mob/living/simple_animal/hostile/rogue/skeleton))
		to_chat(user, span_warning("There is no life essence to absorb!"))
		user.playsound_local(user, 'sound/gore/flesh_eat_02.ogg', 50, FALSE)
		revert_cast()
		return FALSE
	
	if(target == user)
		revert_cast()
		return FALSE


	user.apply_status_effect(/datum/status_effect/debuff/vampiric_slowdown, drain_duration)
	var/datum/beam/vamp_beam = user.Beam(target, icon_state="blood", time=drain_duration)
	user.visible_message(span_danger("[user] pierces [target] with a dark link, siphoning their life!"))

	
	INVOKE_ASYNC(src, .proc/handle_drain_logic, user, target, vamp_beam)

	
	return TRUE


/obj/effect/proc_holder/spell/invoked/vampiric_drain/proc/handle_drain_logic(mob/living/user, mob/living/target, datum/beam/vamp_beam)
	var/skill_mod = user.get_skill_level(associated_skill)
	var/end_time = world.time + drain_duration
	var/tick_count = 0

	while(world.time < end_time)
		if(QDELETED(user) || QDELETED(target) || user.stat || target.stat)
			break
		
		if(get_dist(user, target) > range + 1)
			to_chat(user, span_warning("The distance is too great! The link snaps!"))
			break

		tick_count++
		
		var/current_damage = (base_damage + (tick_count * ramp_multiplier)) + (skill_mod * 2)
		var/current_heal = current_damage * heal_ratio

		playsound(target, 'sound/magic/bloodheal.ogg', 40 + (tick_count * 5), TRUE)
		if(tick_count > 6)
			do_sparks(2, FALSE, target)

		target.apply_damage(current_damage, BRUTE)
		
		user.adjustBruteLoss(-(current_heal / 2))
		user.adjustFireLoss(-(current_heal / 2))
		user.heal_wounds(1.5 + (skill_mod * 0.5))

		if(iscarbon(target) && iscarbon(user))
			var/mob/living/carbon/C_target = target
			var/mob/living/carbon/C_user = user
			if(!(NOBLOOD in C_target.dna?.species?.species_traits))
				var/drain = 5 + (tick_count * 2)
				C_target.blood_volume -= drain
				C_user.blood_volume = min(C_user.blood_volume + drain, BLOOD_VOLUME_NORMAL)

		stoplag(tick_delay)

	
	if(vamp_beam)
		vamp_beam.End()
	
	if(user && !QDELETED(user))
		user.remove_status_effect(/datum/status_effect/debuff/vampiric_slowdown)
