// FLU DISEASE - Airborne illness with coughing and stat penalties

/datum/disease/flu
	name = "Flu"
	desc = "A common illness that weakens the body."
	max_stages = 3
	stage_prob = 2
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_MINOR
	viable_mobtypes = list(/mob/living)
	var/list/stat_mod_keys = null
	var/cough_range = 3
	var/last_stage = 0
	var/colorblind_active = FALSE
	var/colorblind_timer = null
	var/stage_tick_scheduled = FALSE
	var/infected_time = 0

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
		if(world.time - infected_time >= 10 SECONDS)
			update_stage(2)
	else
		stage_prob = 2
	. = ..()
	stage_prob = old_stage_prob
	if(!affected_mob || QDELETED(src))
		return .
	if(stage != last_stage)
		apply_stage_effects(affected_mob, stage)
	if(stage < 2)
		return .
	if(!ishuman(affected_mob))
		return .
	var/mob/living/carbon/human/H = affected_mob

	// Stage 2+ symptoms
	if(DT_PROB(15, delta_time))
		H.adjust_hydration(-5)
	if(DT_PROB(8, delta_time))
		H.blur_eyes(5)
		to_chat(H, span_warning("Голова пульсирует болью, зрение мутнеет."))

	// Stage 3 additional symptoms
	if(stage >= 3)
		if(DT_PROB(6, delta_time))
			H.adjustBruteLoss(rand(10, 15))
			to_chat(H, span_danger("Тело ломит, и меня пробивает сильная слабость."))
		if(DT_PROB(5, delta_time))
			H.Knockdown(rand(10, 20))
			to_chat(H, span_warning("Ноги подкашиваются, и я падаю."))
		if(DT_PROB(4, delta_time) && !colorblind_active)
			colorblind_active = TRUE
			H.add_client_colour(/datum/client_colour/monochrome)
			colorblind_timer = addtimer(CALLBACK(src, PROC_REF(clear_colorblind)), 20 SECONDS)

	return .

/datum/disease/flu/proc/schedule_stage_tick()
	if(stage_tick_scheduled)
		return
	stage_tick_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(stage_tick)), 1 SECONDS)

/datum/disease/flu/proc/stage_tick()
	stage_tick_scheduled = FALSE
	if(QDELETED(src) || !affected_mob)
		return
	if(!infected_time)
		infected_time = world.time
	if(stage == 1 && world.time - infected_time >= 10 SECONDS)
		update_stage(2)
		apply_stage_effects(affected_mob, stage)
	else
		stage_act(1, 0)
	schedule_stage_tick()

/datum/disease/flu/proc/schedule_cough()
	addtimer(CALLBACK(src, PROC_REF(cough_tick)), rand(5, 15) SECONDS)

/datum/disease/flu/proc/cough_tick()
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	if(stage < 2)
		schedule_cough()
		return
	H.emote("cough", intentional = TRUE)
	for(var/mob/living/carbon/human/target in oview(cough_range, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		if(prob(40))
			target.ForceContractDisease(src, TRUE, FALSE)
	schedule_cough()


/datum/disease/flu/proc/apply_stage_effects(mob/living/L, new_stage)
	if(!stat_mod_keys)
		stat_mod_keys = list()
	var/list/stats = list(
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
		if(2, 3)
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
	if(new_stage >= 3)
		ADD_TRAIT(L, TRAIT_NORUN, src)
	else
		REMOVE_TRAIT(L, TRAIT_NORUN, src)
		if(colorblind_active && ishuman(L))
			var/mob/living/carbon/human/H = L
			H.remove_client_colour(/datum/client_colour/monochrome)
			colorblind_active = FALSE
	last_stage = new_stage

/datum/disease/flu/proc/clear_colorblind()
	if(!colorblind_active)
		return
	colorblind_active = FALSE
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		H.remove_client_colour(/datum/client_colour/monochrome)

/datum/disease/flu/remove_disease()
	var/mob/living/L = affected_mob
	if(istype(L))
		REMOVE_TRAIT(L, TRAIT_NORUN, src)
		if(colorblind_active && ishuman(L))
			var/mob/living/carbon/human/H = L
			H.remove_client_colour(/datum/client_colour/monochrome)
			colorblind_active = FALSE
		if(stat_mod_keys)
			for(var/stat in stat_mod_keys)
				L.change_stat(stat, 0, stat_mod_keys[stat])
	return ..()
