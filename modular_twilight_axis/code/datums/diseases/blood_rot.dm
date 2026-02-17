// BLOOD ROT DISEASE - Progressive blood corruption with three stages

/datum/disease/blood_rot
	name = "Blood Rot"
	desc = "A horrific blood disease that progressively corrupts the body."
	max_stages = 3
	stage_prob = 0
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_BLOOD
	disease_flags = CAN_CARRY | CAN_RESIST  // NO CURABLE - специальное лечение
	severity = DISEASE_SEVERITY_DANGEROUS
	viable_mobtypes = list(/mob/living/carbon/human)
	
	var/infected_time = 0
	var/initial_blood_volume = 0
	var/blood_lost_since_infection = 0
	
	var/vomit_timer = null
	var/cough_timer = null
	var/bleed_timer = null
	var/stage_tick_timer = null
	var/stage_tick_scheduled = FALSE
	
	var/list/stat_mod_keys = null

/datum/disease/blood_rot/after_add()
	. = ..()
	infected_time = world.time
	var/mob/living/carbon/human/H = affected_mob
	if(istype(H))
		initial_blood_volume = H.blood_volume
		RegisterSignal(H, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	stage = 1
	apply_stage_effects(1)
	schedule_vomit()
	schedule_stage_tick()

/datum/disease/blood_rot/stage_act(delta_time, times_fired)
	if(!affected_mob || QDELETED(src))
		return ..()
	
	var/mob/living/carbon/human/H = affected_mob
	if(!istype(H))
		return ..()
	
	// Check cure conditions: no blood + leech attached
	if(H.blood_volume <= 50)  // Почти нет крови
		var/has_leech = FALSE
		var/list/embedded = H.get_embedded_objects()
		for(var/obj/item/natural/worms/leech/L in embedded)
			has_leech = TRUE
			break
		
		if(has_leech)
			to_chat(H, span_notice("Пиявка высосала испорченную кровь. Я чувствую облегчение."))
			H.visible_message(span_notice("[H] выглядит лучше!"))
			cure(TRUE)  // Даёт 10 минут иммунитета
			return FALSE
	
	// Track blood loss from initial infection
	var/current_blood = H.blood_volume
	blood_lost_since_infection = max(initial_blood_volume - current_blood, 0)
	
	// Stage progression based on blood loss
	if(blood_lost_since_infection >= 300 && stage < 3)
		stage = 3
		H.visible_message(span_danger("[H] выглядит ужасно больным!"))
		apply_stage_effects(3)
	else if(blood_lost_since_infection >= 100 && stage < 2)
		stage = 2
		H.visible_message(span_warning("[H] выглядит хуже."))
		apply_stage_effects(2)
	
	return ..()

/datum/disease/blood_rot/proc/schedule_stage_tick()
	if(stage_tick_scheduled)
		return
	stage_tick_scheduled = TRUE
	stage_tick_timer = addtimer(CALLBACK(src, PROC_REF(stage_tick)), 10 SECONDS, TIMER_STOPPABLE)

/datum/disease/blood_rot/proc/stage_tick()
	stage_tick_scheduled = FALSE
	if(QDELETED(src) || !affected_mob)
		return
	// Call stage_act manually since stage_prob = 0
	stage_act(10, 0)
	schedule_stage_tick()

/datum/disease/blood_rot/proc/apply_stage_effects(new_stage)
	var/mob/living/L = affected_mob
	if(!istype(L))
		return
	
	// Clear old stat mods
	if(stat_mod_keys)
		for(var/stat in stat_mod_keys)
			L.change_stat(stat, 0, stat_mod_keys[stat])
	
	stat_mod_keys = list()
	
	// Apply new stat mods based on stage
	var/list/stats = list(
		STATKEY_STR = 0,
		STATKEY_PER = 0,
		STATKEY_INT = 0,
		STATKEY_SPD = 0,
		STATKEY_CON = 0,
		STATKEY_END = 0,
		STATKEY_WIL = 0,
		STATKEY_LCK = 0
	)
	
	switch(new_stage)
		if(1)
			for(var/stat in stats)
				stats[stat] = -1
		if(2)
			for(var/stat in stats)
				stats[stat] = -2
			stats[STATKEY_SPD] = -4
			schedule_cough()
			schedule_bleed()
		if(3)
			for(var/stat in stats)
				stats[stat] = -5
	
	for(var/stat in stats)
		var/key = "blood_rot_[stat]_\ref[src]"
		stat_mod_keys[stat] = key
		L.change_stat(stat, stats[stat], key)

	if(new_stage >= 2)
		schedule_cough()
		schedule_bleed()

/datum/disease/blood_rot/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	
	if(stage >= 2)
		examine_list += span_warning("Тело покрыто выступающими пульсирующими темными венами.")
	if(stage >= 3)
		examine_list += span_danger("Из глаз сочится кровь.")

/datum/disease/blood_rot/proc/schedule_vomit()
	if(vomit_timer)
		return
	
	var/vomit_delay = 60 SECONDS
	if(stage == 1)
		vomit_delay = rand(40, 80) SECONDS
	else if(stage == 2)
		vomit_delay = rand(15, 30) SECONDS
	else if(stage == 3)
		vomit_delay = rand(15, 30) SECONDS
	
	vomit_timer = addtimer(CALLBACK(src, PROC_REF(do_vomit)), vomit_delay, TIMER_STOPPABLE)

/datum/disease/blood_rot/proc/do_vomit()
	vomit_timer = null
	
	if(QDELETED(src) || !affected_mob)
		return
	
	var/mob/living/carbon/human/H = affected_mob
	if(!istype(H))
		schedule_vomit()
		return
	
	if(stage == 1)
		// Regular vomit
		H.vomit(lost_nutrition = 20, blood = FALSE, stun = TRUE, distance = 1, message = FALSE)
		to_chat(H, span_warning("Меня рвет."))
		spread_on_vomit(1, 30)
	else if(stage == 2)
		// Blood vomit
		H.vomit(lost_nutrition = 30, blood = TRUE, stun = TRUE, distance = 2, message = FALSE)
		H.blood_volume = max(0, H.blood_volume - 50)
		H.visible_message(span_danger("[H] вырвало кровью!"), span_danger("Меня рвет кровью!"))
		spread_on_vomit(1, 30)
	else if(stage == 3)
		// Fountaining blood vomit
		H.vomit(lost_nutrition = 50, blood = TRUE, stun = TRUE, distance = 3, message = FALSE)
		H.Knockdown(50)
		H.blood_volume = max(0, H.blood_volume - 150)
		playsound(H, 'sound/foley/water_land2.ogg', 100, TRUE)
		H.visible_message(span_danger("Из [H] фонтаном бьет кровавая рвота!"), span_userdanger("Из меня фонтаном бьет кровавая рвота!"))
		// Create blood puddles around the character
		for(var/turf/T in orange(1, H))
			new /obj/effect/decal/cleanable/blood/puddle(T)
		spread_on_vomit(1, 30)
	
	schedule_vomit()

/datum/disease/blood_rot/proc/schedule_cough()
	if(cough_timer || stage < 2)
		return
	
	var/cough_delay = rand(40, 80) SECONDS
	if(stage == 2)
		cough_delay = rand(25, 50) SECONDS
	else if(stage == 3)
		cough_delay = rand(30, 60) SECONDS
	cough_timer = addtimer(CALLBACK(src, PROC_REF(do_cough)), cough_delay, TIMER_STOPPABLE)

/datum/disease/blood_rot/proc/do_cough()
	cough_timer = null
	
	if(QDELETED(src) || !affected_mob || stage < 2)
		return
	
	var/mob/living/carbon/human/H = affected_mob
	if(!istype(H))
		if(stage >= 2)
			schedule_cough()
		return
	
	H.emote("cough")
	H.blood_volume = max(0, H.blood_volume - 30)
	H.visible_message(
		span_danger("[H] кашляет кровью!"),
		span_danger("Я кашляю кровью!")
	)
	
	// Spread to nearby targets
	spread_on_vomit(1, 30)
	
	schedule_cough()

/datum/disease/blood_rot/proc/schedule_bleed()
	if(bleed_timer || stage < 2)
		return
	
	var/bleed_delay = rand(60, 120) SECONDS
	bleed_timer = addtimer(CALLBACK(src, PROC_REF(do_random_bleed)), bleed_delay, TIMER_STOPPABLE)

/datum/disease/blood_rot/proc/do_random_bleed()
	bleed_timer = null
	
	if(QDELETED(src) || !affected_mob || stage < 2)
		return
	
	var/mob/living/carbon/human/H = affected_mob
	if(!istype(H))
		if(stage >= 2)
			schedule_bleed()
		return
	
	// Pick random body part
	var/list/parts = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/picked_zone = pick(parts)
	var/obj/item/bodypart/BP = H.get_bodypart(picked_zone)
	
	if(BP && prob(70))
		BP.add_wound(/datum/wound/slash/small)
		H.visible_message(
			span_warning("Из тела [H] начинает сочиться кровь!"),
			span_danger("Из моего тела начинает сочиться кровь!")
		)
	
	schedule_bleed()

/datum/disease/blood_rot/proc/spread_on_vomit(range = 1, chance = 30)
	if(!affected_mob)
		return
	
	for(var/mob/living/carbon/target in oview(range, affected_mob))
		if(target == affected_mob)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		if(prob(chance))
			target.ForceContractDisease(src, TRUE, FALSE)

/datum/disease/blood_rot/remove_disease()
	// Clear timers
	if(vomit_timer)
		deltimer(vomit_timer)
		vomit_timer = null
	if(cough_timer)
		deltimer(cough_timer)
		cough_timer = null
	if(bleed_timer)
		deltimer(bleed_timer)
		bleed_timer = null
	if(stage_tick_timer)
		deltimer(stage_tick_timer)
		stage_tick_timer = null
	stage_tick_scheduled = FALSE
	
	// Clear stat mods
	if(stat_mod_keys && affected_mob)
		for(var/stat in stat_mod_keys)
			affected_mob.change_stat(stat, 0, stat_mod_keys[stat])
		stat_mod_keys = null
	
	// Unregister signals
	if(affected_mob)
		UnregisterSignal(affected_mob, COMSIG_PARENT_EXAMINE)
	
	return ..()
