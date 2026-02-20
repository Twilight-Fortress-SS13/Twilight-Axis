// THE GRIME-FLU DISEASE - Airborne illness with coughing and stat penalties

/datum/disease/grime_flu
	name = "The Grime-Flu"
	desc = "A common illness that weakens the body."
	max_stages = 4
	stage_prob = 2
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	infectivity = 10
	severity = DISEASE_SEVERITY_MINOR
	viable_mobtypes = list(/mob/living)
	var/list/stat_mod_keys = null
	var/cough_range = 3
	var/last_stage = 0
	var/colorblind_active = FALSE
	var/colorblind_timer = null
	var/stage_tick_scheduled = FALSE
	var/infected_time = 0
	var/stage2_time = 0
	var/stage3_time = 0
	var/cough_scheduled = FALSE
	var/stage_tick_timer = null
	var/cough_timer = null
	var/last_weakness_time = 0

/datum/disease/grime_flu/after_add()
	. = ..()
	var/mob/living/L = affected_mob
	if(!istype(L))
		return
	infected_time = world.time
	apply_stage_effects(L, stage)
	schedule_stage_tick()

/datum/disease/grime_flu/stage_act(delta_time, times_fired)
	var/old_stage_prob = stage_prob
	if(stage == 1)
		stage_prob = 0
		if(world.time - infected_time >= 2 MINUTES)
			update_stage(2)
	else if(stage == 2)
		stage_prob = 0
		if(stage2_time && world.time - stage2_time >= 10 MINUTES)
			update_stage(3)
	else if(stage == 3)
		stage_prob = 0
		if(stage3_time && world.time - stage3_time >= 15 MINUTES)
			stage_prob = 0.5
	else
		stage_prob = 1
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
	if(affected_mob.stat == DEAD)
		return .
	var/mob/living/carbon/human/H = affected_mob

	// Stage 2+ symptoms
	if(DT_PROB(15, delta_time))
		H.adjust_hydration(-5)
	if(DT_PROB(3, delta_time))
		H.blur_eyes(5)
		to_chat(H, span_warning("Голова пульсирует болью, зрение мутнеет."))
	// Hand weakness - drops item every 2-3 minutes
	if(world.time - last_weakness_time >= rand(2 MINUTES, 3 MINUTES))
		last_weakness_time = world.time
		var/obj/item/held_item = H.get_active_held_item()
		if(held_item)
			to_chat(H, span_warning("Руки ослабевают от болезни, и я роняю [held_item]!"))
			H.dropItemToGround(held_item)
		else
			to_chat(H, span_warning("Руки внезапно дрожат и ослабевают."))

	// Stage 3 additional symptoms
	if(stage >= 3)
		if(DT_PROB(6, delta_time))
			H.adjustBruteLoss(rand(1, 2))
			to_chat(H, span_danger("Тело ломит, и меня пробивает сильная слабость."))
		if(DT_PROB(5, delta_time))
			H.Knockdown(rand(10, 20))
			to_chat(H, span_warning("Ноги подкашиваются, и я падаю."))
		if(DT_PROB(4, delta_time) && !colorblind_active)
			colorblind_active = TRUE
			H.add_client_colour(/datum/client_colour/monochrome)
			if(colorblind_timer)
				deltimer(colorblind_timer)
			colorblind_timer = addtimer(CALLBACK(src, PROC_REF(clear_colorblind)), 20 SECONDS, TIMER_STOPPABLE)

	// Stage 4 additional symptoms
	if(stage >= 4)
		if(DT_PROB(3, delta_time))
			H.adjustBruteLoss(rand(1, 3))
			to_chat(H, span_danger("Меня ломит, и кажется, что тело вот-вот сдастся."))

	return .

/datum/disease/grime_flu/proc/schedule_stage_tick()
	if(stage_tick_scheduled)
		return
	stage_tick_scheduled = TRUE
	stage_tick_timer = addtimer(CALLBACK(src, PROC_REF(stage_tick)), 5 SECONDS, TIMER_STOPPABLE)

/datum/disease/grime_flu/proc/stage_tick()
	stage_tick_scheduled = FALSE
	if(QDELETED(src) || !affected_mob)
		return
	if(!infected_time)
		infected_time = world.time
	if(stage == 1 && world.time - infected_time >= 2 MINUTES)
		update_stage(2)
		apply_stage_effects(affected_mob, stage)
	else
		stage_act(5, 0)
	schedule_stage_tick()

/datum/disease/grime_flu/proc/schedule_cough()
	if(cough_scheduled)
		return
	cough_scheduled = TRUE
	cough_timer = addtimer(CALLBACK(src, PROC_REF(cough_tick)), rand(10, 30) SECONDS, TIMER_STOPPABLE)

/datum/disease/grime_flu/proc/cough_tick()
	cough_scheduled = FALSE
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	if(stage < 2)
		schedule_cough()
		return
	H.emote("cough", intentional = TRUE)
	if(stage >= 4 && prob(70))
		H.vomit(1, blood = TRUE, stun = FALSE)
		H.bleed(9)
		H.adjustOxyLoss(2)
	for(var/mob/living/carbon/human/target in oview(2, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		var/disease_chance = 10
		if(HAS_TRAIT(target, TRAIT_RAG_MASK_WORN))
			disease_chance = 5
		if(prob(disease_chance))
			target.ForceContractDisease(src, TRUE, FALSE)
	schedule_cough()


/datum/disease/grime_flu/proc/apply_stage_effects(mob/living/L, new_stage)
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
			infected_time = world.time
			stage2_time = 0
			stage3_time = 0
		if(2)
			stats[STATKEY_PER] = -2
			stats[STATKEY_SPD] = -3
			stats[STATKEY_CON] = -2
			stats[STATKEY_WIL] = -4
			stage2_time = world.time
			stage3_time = 0
		if(3)
			stats[STATKEY_STR] = -3
			stats[STATKEY_SPD] = -8
			stage3_time = world.time
		if(4)
			stats[STATKEY_STR] = -7
			stats[STATKEY_PER] = -7
			stats[STATKEY_SPD] = -10
			stats[STATKEY_CON] = -7
			stats[STATKEY_WIL] = -7
	for(var/stat in stats)
		var/key = "grime_flu_[stat]_\ref[src]"
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

/datum/disease/grime_flu/proc/clear_colorblind()
	if(!colorblind_active)
		return
	colorblind_active = FALSE
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		H.remove_client_colour(/datum/client_colour/monochrome)
	if(colorblind_timer)
		deltimer(colorblind_timer)
		colorblind_timer = null

/datum/disease/grime_flu/remove_disease()
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
		if(colorblind_timer)
			deltimer(colorblind_timer)
			colorblind_timer = null
		REMOVE_TRAIT(L, TRAIT_NORUN, src)
		if(colorblind_active && ishuman(L))
			var/mob/living/carbon/human/H = L
			H.remove_client_colour(/datum/client_colour/monochrome)
			colorblind_active = FALSE
		if(stat_mod_keys)
			for(var/stat in stat_mod_keys)
				L.change_stat(stat, 0, stat_mod_keys[stat])
	return ..()
