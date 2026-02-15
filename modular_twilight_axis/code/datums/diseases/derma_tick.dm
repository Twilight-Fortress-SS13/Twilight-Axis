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

/datum/disease/derma_tick/after_add()
	. = ..()
	infected_time = world.time
	if(ishuman(affected_mob))
		schedule_itch()

/datum/disease/derma_tick/stage_act(delta_time, times_fired)
	if(infected_time && world.time - infected_time >= 10 MINUTES)
		cure(FALSE)
		return
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
