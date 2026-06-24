/obj/effect/proc_holder/spell/self/heavy_stomp
	name = "Heavy Stomp"
	desc = "Channel your patrons fury into a powerful ground-stomp that will knock back anyone in your path and apply various debuffs based on your Miracle skill, as well as deal damage."
	action_icon = 'modular_twilight_axis/icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "stomp"
	glow_color = GLOW_COLOR_GRAGGAR
	glow_intensity = GLOW_INTENSITY_LOW
	xp_gain = TRUE
	releasedrain = 30
	range = 0
	recharge_time = 1 MINUTES
	warnie = "spellwarning"
	associated_skill = /datum/skill/magic/holy
	invocations = list("GHAAAAa-a!!",
						"GRRAAAAAGg-g!!",
						"AAAAAGHHh-h-hr!!")
	invocation_type = "shout"
	gesture_required = TRUE
	human_req = TRUE
	devotion_cost = 30
	miracle = TRUE
	var/maxthrow = 3
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/showsparkles = TRUE
	var/push_range = 1

/obj/effect/proc_holder/spell/self/heavy_stomp/cast(list/targets, mob/living/carbon/human/user, stun_amt = 5)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	var/strength = ((user.STASTR - 10)*10)
	var/skill_level = user.get_skill_level(associated_skill)
	playsound(user, 'sound/magic/repulse.ogg', 80, TRUE)
	if(!do_after(user, 1 SECONDS, user))
		to_chat(user, "<span class='danger'>You're concentration breaks!</span>")
		return
	for(var/turf/T in get_hear(push_range, user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		var/guard_deflected = FALSE
		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue
			if(isliving(M) && spell_guard_check(M, TRUE))
				M.visible_message(span_warning("[M] braces against the wave of force!"))
				guard_deflected = TRUE

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(guard_deflected)
			AM.safe_throw_at(throwtarget, 2, 1, user, force = repulse_force)
		else if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(strength)
				to_chat(M, "<span class='danger'>You're slammed into the floor by [user]!</span>")
		else
			if(showsparkles)
				new sparkle_path(get_turf(AM), get_dir(user, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				for(var/mob/living/simple_animal/animal in range(push_range, user))
					animal.Paralyze(5 SECONDS, updating = TRUE, ignore_canstun = TRUE)
					animal.adjustBruteLoss(strength*2)
				for(var/mob/living/L in range(push_range, user))
					var/mob/living/M = AM
					M.adjustBruteLoss(strength/2)
					M.Immobilize(3 SECONDS)
					M.OffBalance(3 SECONDS)
					to_chat(M, "<span class='danger'>You're thrown back by [user]!</span>")
					if(skill_level >= 3)
						M.apply_status_effect(/datum/status_effect/debuff/heavy_stomp)
					if(skill_level >= 4)
						M.apply_status_effect(/datum/status_effect/debuff/heavy_stomp/i)
						var/effect_to_apply = (M.mind ? /datum/status_effect/debuff/vulnerable : /datum/status_effect/debuff/exposed)
						M.apply_status_effect(effect_to_apply, 3 SECONDS)
						M.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + 2, 2.5 SECONDS))
						M.Immobilize(0.5 SECONDS)
						M.stamina_add(M.stamina * 0.1)
						M.Slowdown(2)
					if(skill_level >= 5)
						M.apply_status_effect(/datum/status_effect/debuff/heavy_stomp/ii)
					if(skill_level >= 6)
						M.apply_status_effect(/datum/status_effect/debuff/heavy_stomp/iii)
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)//So stuff gets tossed around at the same time.
	return TRUE

/obj/effect/proc_holder/spell/invoked/blood_call
	name = "Blood Call"
	desc = "Let out a powerful howl to pass a STR contest with your opponent. Depending on the results, apply various negative effects and confuse them. In any case, it disrupts your balance and prevents you from parrying. The duration of the negative effects depends on your Miracle skill."
	action_icon = 'modular_twilight_axis/icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "call"
	glow_color = GLOW_COLOR_GRAGGAR
	glow_intensity = GLOW_INTENSITY_LOW
	miracle = TRUE
	devotion_cost = 40
	releasedrain = 30
	chargedrain = 2
	chargetime = 3 SECONDS
	chargedloop = /datum/looping_sound/invokeascendant
	range = 4
	recharge_time = 2 MINUTES //This lasts 25 SECONDS at max holy rank so for purposes of it not being chainable solo.
	associated_skill = /datum/skill/magic/holy
	invocation_type = "shout"
	sound = 'sound/magic/graggar_silence.ogg'
	invocations = list("GRRRAAAA!!", "GGGGAAA!!", "AAAAAARRRR!!")
	zizo_spell = FALSE // Graggar wants his car back.

/obj/effect/proc_holder/spell/invoked/blood_call/cast(list/targets, mob/living/carbon/user = usr)//This one does actually work on mages, fully.
	if(iscarbon(targets[1]))
		var/mob/living/carbon/target = targets[1]
		var/skill_level = user.get_skill_level(associated_skill)*4
		if(user == target) //self target
			to_chat(user, "<span class='warning'>I may not call myself.</span>")
			revert_cast()
			return
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>The spell fizzles, it won't work on them!</span>")
			revert_cast()
			return
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] resists the my magic!"))
			return TRUE
		user.emote("warcry")
		var/perc = (user.STASTR - target.STASTR)
		var/effect_to_apply = (user.mind ? /datum/status_effect/debuff/vulnerable : /datum/status_effect/debuff/exposed)
		user.apply_status_effect(effect_to_apply, 3 SECONDS)
		user.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + 2, 2.5 SECONDS))
		user.Immobilize(0.5 SECONDS)
		user.stamina_add(user.stamina * 0.1)
		user.Slowdown(2)
		if(HAS_TRAIT(target, TRAIT_STEELHEARTED)) //all combat roles
			perc -= 1
		if(perc < 0)
			return
		if(perc >= 0)
			if(perc == 1)
				target.apply_status_effect(effect_to_apply, 3 SECONDS)
				target.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + 2, 2.5 SECONDS))
				target.Immobilize(0.5 SECONDS)
				target.stamina_add(user.stamina * 0.1)
				target.Slowdown(2)
			if(perc == 2)
				target.apply_status_effect(/datum/status_effect/debuff/blood_call, skill_level)
			if(perc == 3)
				target.apply_status_effect(/datum/status_effect/debuff/blood_call/i, skill_level)
			if(perc >= 4)
				target.apply_status_effect(/datum/status_effect/debuff/blood_call/ii, skill_level)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("FUCK!!"))
		return TRUE
	else //misfire
		to_chat(user, "<span class='warning'>I must attempt to call thinking being.</span>")
		revert_cast()
		return

/obj/effect/proc_holder/spell/self/graggar_regenerate
	name = "Berserk Body"
	desc = "Grants you a temporary health regeneration... for a price of your STR and WIL."
	action_icon = 'modular_twilight_axis/icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "regenerate"
	glow_color = GLOW_COLOR_GRAGGAR
	glow_intensity = GLOW_INTENSITY_LOW
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/foley/gross.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocation_type = "none"
	recharge_time = 1 MINUTES
	devotion_cost = 0
	miracle = TRUE

/obj/effect/proc_holder/spell/self/graggar_regenerate/cast(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	recharge_time = 1 MINUTES
	if(user.has_status_effect(/datum/status_effect/buff/graggar_regenerate))
		user.remove_status_effect(/datum/status_effect/buff/graggar_regenerate)
		return TRUE
	else
		user.emote("warcry")
		user.visible_message("[user] mutters an incantation and their skin begin regenerate.")
		user.apply_status_effect(/datum/status_effect/buff/graggar_regenerate)
		recharge_time = 0
	return TRUE

/atom/movable/screen/alert/status_effect/buff/graggar_regenerate
	name = "REGENERATE"
	desc = "My flesh regrow, my bone rebreak, my muscules resprite!!"
	icon_state = "fire"

/datum/status_effect/buff/graggar_regenerate
	id = "graggar_regenerate"
	examine_text = "<font color='red'>SUBJECTPRONOUN flesh regrows!</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_regenerate
	effectedstats = list(STATKEY_WIL = -3, STATKEY_STR = -3) //Target body loosing CON, but getting fireresist.
	duration = 6 SECONDS
	var/last_water = 0

/datum/status_effect/buff/graggar_regenerate/on_apply()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(continue_p)), wait = (5 SECONDS))

/datum/status_effect/buff/graggar_regenerate/proc/continue_p()
	if(QDELETED(src) || QDELING(src) || !owner || QDELETED(owner))
		return
	var/mob/living/carbon/human/user = owner
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	var/cost = 50 //Novice
	switch(skill)
		if(6)
			cost = 45
		if(5)
			cost = 40
		if(4)
			cost = 35
		if(3)
			cost = 30
		if(2)
			cost = 25
	if(user.has_status_effect(/datum/status_effect/buff/graggar_regenerate))
		if((user.devotion?.devotion - cost) < 0)
			to_chat(user, span_warning("I do not have enough devotion!"))
			return
		if(cost != 0)
			user.devotion?.update_devotion(-cost)
			to_chat(user, "<font color='purple'>I lose [cost] devotion!</font>")
			user.adjustBruteLoss(-5*skill)
			user.adjustFireLoss(-5*skill)
			user.heal_wounds(-3*skill)
			if(last_water + 10 SECONDS <= world.time)
				last_water = world.time
				if(skill >= 3)
					user.reagents.add_reagent(/datum/reagent/water, 3*skill) 
			for(var/i in 1 to 3)
				var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_blood(get_turf(owner))
				H.color = "#bc0909"
		user.apply_status_effect(/datum/status_effect/buff/graggar_regenerate)
		addtimer(CALLBACK(src, PROC_REF(continue_p)), wait = (5 SECONDS))
	else
		return
