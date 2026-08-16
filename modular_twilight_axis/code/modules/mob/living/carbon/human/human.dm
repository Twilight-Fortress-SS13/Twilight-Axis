/mob/living/carbon/human
	var/trophy_rage_duration_bonus = 0
	var/trophy_rage_cooldown_mult = 1

/mob/living/carbon/human/proc/get_trophy_rage_duration_bonus()
	return trophy_rage_duration_bonus

/mob/living/carbon/human/proc/get_trophy_rage_cooldown_mult()
	return trophy_rage_cooldown_mult

/mob/living/carbon/human/proc/get_trophy_armor_bonus_for_zone(def_zone, d_type)
	var/datum/component/trophy_hunter/trophy_hunter = GetComponent(/datum/component/trophy_hunter)
	if(!trophy_hunter)
		return 0

	return trophy_hunter.get_armor_bonus_for_zone(def_zone, d_type)

/mob/living/carbon/human/proc/has_axedance()
	if(!mind)
		return FALSE

	for(var/obj/effect/proc_holder/spell/S in mind.spell_list)
		if(istype(S, /obj/effect/proc_holder/spell/self/axedance))
			return TRUE

	return FALSE

/mob/living/carbon/human/proc/apply_sleep_deprivation()
	if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA) || HAS_TRAIT(src, TRAIT_INFINITE_ENERGY))
		return

	remove_stress(/datum/stressevent/sleepytime)
	remove_stress(/datum/stressevent/sleep_deprivation_2)
	remove_stress(/datum/stressevent/sleep_deprivation_3)
	remove_stress(/datum/stressevent/sleep_deprivation_4)

	var/capped = is_sleep_capped()

	if(has_status_effect(/datum/status_effect/debuff/sleepytime))
		if(capped)
			days_without_sleep = 1
		else
			days_without_sleep = min(days_without_sleep + 1, 4)
	else
		days_without_sleep = 1
		apply_status_effect(/datum/status_effect/debuff/sleepytime)

	switch(days_without_sleep)
		if(1)
			add_stress(/datum/stressevent/sleepytime)
		if(2)
			to_chat(src, span_danger("Я не спал уже двое суток... Голова раскалывается, а веки тяжелеют."))
			add_stress(/datum/stressevent/sleep_deprivation_2)
		if(3)
			to_chat(src, span_boldred("Я не спал трое суток! Мир вокруг начинает плыть..."))
			add_stress(/datum/stressevent/sleep_deprivation_3)

			// if(!has_flaw(/datum/charflaw/mind_broken))
			// 	hallucination = max(hallucination, 150)

		if(4)
			to_chat(src, span_suicide("ЧЕТЫРЕ ДНЯ БЕЗ СНА! МОЙ РАЗУМ УГАСАЕТ, Я В ЛЮБОЙ МОМЕНТ МОГУ ОТКЛЮЧИТЬСЯ!"))
			add_stress(/datum/stressevent/sleep_deprivation_4)

			if(!has_flaw(/datum/charflaw/mind_broken))
				hallucination = max(hallucination, 300)
				ADD_TRAIT(src, TRAIT_PSYCHOSIS, "sleep_deprivation")

/mob/living/carbon/human/update_tod(todd)
	if(client)
		var/area/areal = get_area(src)
		if(!cmode)
			SSdroning.play_area_sound(areal, src.client)
		SSdroning.play_loop(areal, src.client)
	if(ai_controller)
		return
	switch(todd)
		if("day")
			if(HAS_TRAIT(src, TRAIT_VAMP_DREAMS))
				apply_status_effect(/datum/status_effect/debuff/vamp_dreams)
			if(HAS_TRAIT(src, TRAIT_NIGHT_OWL))
				apply_sleep_deprivation()
		if("night")
			SEND_SIGNAL(src, COMSIG_SLEEPY_TIME)
			handle_sleep_triumphs()

			if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA))
				return

			if(HAS_TRAIT(src, TRAIT_NIGHT_OWL))
				add_stress(/datum/stressevent/night_owl)
			else
				apply_sleep_deprivation()

	if(todd != "day")
		if(HAS_TRAIT(src, TRAIT_NOC_LIGHT_BLESSING))
			apply_status_effect(/datum/status_effect/buff/noc_light_blessing)
	else
		remove_status_effect(/datum/status_effect/buff/noc_light_blessing)

/mob/living/carbon/human/proc/is_sleep_capped()
	if((mob_biotypes & MOB_UNDEAD) || HAS_TRAIT(src, TRAIT_NOSLEEP))
		return TRUE

	if(mind)
		var/role = mind.special_role
		if(role in list(ROLE_LICH, ROLE_VAMPIRE, ROLE_NBEAST, ROLE_VAMPIRE_SUMMON, ROLE_NECRO_SKELETON, ROLE_SIEGE_SKELETON, ROLE_LICH_SKELETON, ROLE_UNBOUND_DEATHKNIGHT, ROLE_REVENANT, ROLE_DREAMWALKER))
			return TRUE

	return FALSE
