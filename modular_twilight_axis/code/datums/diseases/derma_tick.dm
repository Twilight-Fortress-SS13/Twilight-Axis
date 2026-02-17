// DERMA-TICK DISEASE - Mild itching contact disease

/datum/disease/derma_tick
	name = "Derma-Tick"
	desc = "A persistent, unpleasant itch."
	max_stages = 1
	stage_prob = 0
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_MINOR
	viable_mobtypes = list(/mob/living)
	var/itch_timer = null
	var/infected_time = 0
	var/sleep_start_time = 0

/datum/disease/derma_tick/after_add()
	. = ..()
	infected_time = world.time
	sleep_start_time = 0
	if(ishuman(affected_mob))
		schedule_itch()

/datum/disease/derma_tick/stage_act(delta_time, times_fired)
	var/mob/living/L = affected_mob
	if(!istype(L))
		return ..()
	// Natural cure after 10 minutes
	if(infected_time && world.time - infected_time >= 10 MINUTES)
		cure(FALSE)
		return
	// Sleep-based cure (25 seconds)
	if(L.IsSleeping())
		if(!sleep_start_time)
			sleep_start_time = world.time
		else if(world.time - sleep_start_time >= 25 SECONDS)
			cure(FALSE)
			return
	else
		sleep_start_time = 0
	return ..()

/datum/disease/derma_tick/proc/schedule_itch()
	if(itch_timer)
		return
	itch_timer = addtimer(CALLBACK(src, PROC_REF(itch_tick)), rand(12, 25) SECONDS, TIMER_STOPPABLE)

/datum/disease/derma_tick/proc/itch_tick()
	itch_timer = null
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	H.emote("scratch", intentional = FALSE)
	H.adjustBruteLoss(1)
	var/list/itch_messages = list(
		span_warning("Кожа мерзко чешется, и я расчесываю ее."),
		span_warning("Зуд под кожей не дает мне покоя."),
		span_warning("Я чешу кожу, но зуд не проходит."),
		span_warning("Кожа зудит, и я нервно почесываюсь.")
	)
	to_chat(H, pick(itch_messages))

	for(var/mob/living/carbon/human/target in oview(1, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		if(prob(50))
			target.ForceContractDisease(src, TRUE, FALSE)
	schedule_itch()

/datum/disease/derma_tick/remove_disease()
	if(itch_timer)
		deltimer(itch_timer)
		itch_timer = null
	return ..()
