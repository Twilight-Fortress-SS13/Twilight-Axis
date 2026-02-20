// FLU DISEASE - A mild two-stage illness

/datum/disease/flu
	name = "Flu"
	desc = "A mild illness that weakens the body."
	max_stages = 2
	stage_prob = 2
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	infectivity = 10
	severity = DISEASE_SEVERITY_MINOR
	viable_mobtypes = list(/mob/living)
	var/list/stat_mod_keys = null
	var/cough_range = 3
	var/last_stage = 0
	var/stage_tick_scheduled = FALSE
	var/infected_time = 0
	var/cough_scheduled = FALSE
	var/stage_tick_timer = null
	var/cough_timer = null
	var/sleep_start_time = 0

/datum/disease/flu/after_add()
	. = ..()
	var/mob/living/L = affected_mob
	if(!istype(L))
		return
	infected_time = world.time
	apply_stage_effects(L, stage)
	schedule_stage_tick()

/datum/disease/flu/stage_act(delta_time, times_fired)
	var/old_stage_prob = stage_prob
	if(stage == 1)
		stage_prob = 0
		if(world.time - infected_time >= 1 MINUTES)
			update_stage(2)
	else
		stage_prob = 0
	. = ..()
	stage_prob = old_stage_prob
	if(!affected_mob || QDELETED(src))
		return .

	if(stage != last_stage)
		apply_stage_effects(affected_mob, stage)

	var/mob/living/L = affected_mob
	if(!istype(L))
		return .
	if(world.time - infected_time >= 10 MINUTES)
		cure()
		return .
	// Natural cure after 10 minutes
	if(world.time - infected_time >= 10 MINUTES)
		cure()
		return .
	// Sleep-based cure (25 seconds sleep + no thirst)
	if(L.IsSleeping())
		if(L.hydration < HYDRATION_LEVEL_SMALLTHIRST)
			sleep_start_time = 0
		else
			if(!sleep_start_time)
				sleep_start_time = world.time
			else if(world.time - sleep_start_time >= 25 SECONDS)
				cure()
				return .
	else
		sleep_start_time = 0

	if(stage < 2)
		return .
	if(!ishuman(affected_mob))
		return .
	if(affected_mob.stat == DEAD)
		return .
	var/mob/living/carbon/human/H = affected_mob

	// Stage 2 symptoms
	if(DT_PROB(15, delta_time))
		H.adjust_hydration(-5)
	if(DT_PROB(1, delta_time))
		H.blur_eyes(5)
		to_chat(H, span_warning("My head throbs and vision blurs."))

	return .

/datum/disease/flu/proc/schedule_stage_tick()
	if(stage_tick_scheduled)
		return
	stage_tick_scheduled = TRUE
	stage_tick_timer = addtimer(CALLBACK(src, PROC_REF(stage_tick)), 5 SECONDS, TIMER_STOPPABLE)

/datum/disease/flu/proc/stage_tick()
	stage_tick_scheduled = FALSE
	if(QDELETED(src) || !affected_mob)
		return
	if(!infected_time)
		infected_time = world.time
	if(world.time - infected_time >= 10 MINUTES)
		cure()
		return
	if(stage == 1 && world.time - infected_time >= 1 MINUTES)
		update_stage(2)
		apply_stage_effects(affected_mob, stage)
	else
		stage_act(5, 0)
	schedule_stage_tick()

/datum/disease/flu/proc/schedule_cough()
	if(cough_scheduled)
		return
	cough_scheduled = TRUE
	cough_timer = addtimer(CALLBACK(src, PROC_REF(cough_tick)), rand(15, 45) SECONDS, TIMER_STOPPABLE)

/datum/disease/flu/proc/cough_tick()
	cough_scheduled = FALSE
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	if(affected_mob.stat == DEAD)
		schedule_cough()
		return
	var/mob/living/carbon/human/H = affected_mob
	if(stage < 2)
		schedule_cough()
		return
	H.emote("cough", intentional = TRUE)
	for(var/mob/living/carbon/human/target in oview(cough_range, H))
		if(target == H)
			continue
		if(!inLineOfTravel(H, target))
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		var/disease_chance = 10
		if(target.get_item_by_slot(SLOT_WEAR_MASK))
			disease_chance = max(1, round(disease_chance * 0.7))
		if(prob(disease_chance))
			target.ForceContractDisease(src, TRUE, FALSE)
	schedule_cough()

/datum/disease/flu/proc/apply_stage_effects(mob/living/L, new_stage)
	if(!stat_mod_keys)
		stat_mod_keys = list()
	var/list/stats = list(
		STATKEY_STR = 0,
		STATKEY_PER = 0,
		STATKEY_SPD = 0,
		STATKEY_CON = 0,
		STATKEY_WIL = 0
	)
	switch(new_stage)
		if(1)
			stats[STATKEY_PER] = -1
			stats[STATKEY_SPD] = -1
			stats[STATKEY_CON] = -1
			stats[STATKEY_WIL] = -2
		if(2)
			stats[STATKEY_PER] = -2
			stats[STATKEY_SPD] = -3
			stats[STATKEY_CON] = -2
			stats[STATKEY_WIL] = -4
	for(var/stat in stats)
		var/key = "flu_[stat]_\ref[src]"
		stat_mod_keys[stat] = key
		L.change_stat(stat, stats[stat], key)
	if(new_stage >= 2 && ishuman(L))
		schedule_cough()
	last_stage = new_stage

/datum/disease/flu/remove_disease()
	var/mob/living/L = affected_mob
	if(istype(L))
		if(stage_tick_timer)
			deltimer(stage_tick_timer)
			stage_tick_timer = null
		stage_tick_scheduled = FALSE
		if(cough_timer)
			deltimer(cough_timer)
			cough_timer = null
		cough_scheduled = FALSE
		if(stat_mod_keys)
			for(var/stat in stat_mod_keys)
				L.change_stat(stat, 0, stat_mod_keys[stat])
	return ..()
