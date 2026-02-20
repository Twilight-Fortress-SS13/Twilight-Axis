// VISION ROT - Degenerative disease causing progressive vision loss
// Symptoms: blur, colorblindness, full blindness (5-8s, every 20-30s)
// Auto-cures after 8 minutes

/datum/disease/vision_rot
	name = "Vision Rot"
	desc = "A degenerative disease that slowly rots away the patient's sight. Victims suffer from periodic blurring, color loss, and complete blindness."
	max_stages = 1
	stage_prob = 0
	spread_flags = 0
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_MEDIUM
	viable_mobtypes = list(/mob/living/carbon/human)

	var/blur_timer = null
	var/colorblind_timer = null
	var/colorblind_clear_timer = null
	var/blind_timer = null
	var/infected_time = 0

/datum/disease/vision_rot/after_add()
	. = ..()
	var/mob/living/carbon/human/H = affected_mob
	if(!ishuman(H))
		return
	infected_time = world.time
	schedule_blur()
	schedule_colorblind()
	schedule_blind()

/datum/disease/vision_rot/proc/schedule_blur()
	if(blur_timer)
		deltimer(blur_timer)
	blur_timer = addtimer(CALLBACK(src, PROC_REF(blur_tick)), rand(25, 35) SECONDS, TIMER_STOPPABLE)

/datum/disease/vision_rot/proc/blur_tick()
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	if(affected_mob.stat == DEAD)
		schedule_blur()
		return
	// Check for natural cure after 8 minutes
	if(infected_time && world.time - infected_time >= 8 MINUTES)
		cure(FALSE) // No immunity after natural cure
		to_chat(affected_mob, span_notice("Моё зрение начинает восстанавливаться..."))
		return
	var/mob/living/carbon/human/H = affected_mob
	H.blur_eyes(rand(15, 25))
	to_chat(H, span_warning("Моё зрение мутнеет..."))
	schedule_blur()

/datum/disease/vision_rot/proc/schedule_colorblind()
	if(colorblind_timer)
		deltimer(colorblind_timer)
	colorblind_timer = addtimer(CALLBACK(src, PROC_REF(colorblind_tick)), rand(30, 45) SECONDS, TIMER_STOPPABLE)

/datum/disease/vision_rot/proc/colorblind_tick()
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	if(affected_mob.stat == DEAD)
		schedule_colorblind()
		return
	var/mob/living/carbon/human/H = affected_mob
	H.add_client_colour(/datum/client_colour/monochrome)
	to_chat(H, span_warning("Мир теряет краски, всё становится серым..."))
	if(colorblind_clear_timer)
		deltimer(colorblind_clear_timer)
	colorblind_clear_timer = addtimer(CALLBACK(src, PROC_REF(clear_colorblind)), rand(6, 10) SECONDS, TIMER_STOPPABLE)
	schedule_colorblind()

/datum/disease/vision_rot/proc/clear_colorblind()
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	H.remove_client_colour(/datum/client_colour/monochrome)

/datum/disease/vision_rot/proc/schedule_blind()
	if(blind_timer)
		deltimer(blind_timer)
	blind_timer = addtimer(CALLBACK(src, PROC_REF(blind_tick)), rand(35, 50) SECONDS, TIMER_STOPPABLE)

/datum/disease/vision_rot/proc/blind_tick()
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	if(affected_mob.stat == DEAD)
		schedule_blind()
		return
	var/mob/living/carbon/human/H = affected_mob
	H.adjust_blindness(rand(8, 12))
	to_chat(H, span_danger("Я ничего не вижу!"))
	schedule_blind()

/datum/disease/vision_rot/remove_disease()
	var/mob/living/carbon/human/H = affected_mob
	if(ishuman(H))
		if(blur_timer)
			deltimer(blur_timer)
			blur_timer = null
		if(colorblind_timer)
			deltimer(colorblind_timer)
			colorblind_timer = null
		if(colorblind_clear_timer)
			deltimer(colorblind_clear_timer)
			colorblind_clear_timer = null
		if(blind_timer)
			deltimer(blind_timer)
			blind_timer = null
		H.remove_client_colour(/datum/client_colour/monochrome)
		H.adjust_blindness(-H.eye_blind)
	return ..()

// Override cure to never give immunity
/datum/disease/vision_rot/cure(add_resistance = TRUE)
	return ..(FALSE) // Never add resistance for vision rot
