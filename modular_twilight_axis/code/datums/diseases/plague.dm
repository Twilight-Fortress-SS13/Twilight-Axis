// THE PLAGUE - Devastating 4-stage pandemic disease combining ash blight and grime flu
// Stage 1: Incubation (3-4 min) - Mild symptoms
// Stage 2: Early Plague (5-6 min) - CRITICAL_WEAKNESS & LEPROSY traits, moderate symptoms
// Stage 3: Advanced Plague (8-10 min) - Severe symptoms, blackening skin, heavy bleeding
// Stage 4: Terminal Stage (15-20 min from stage 3!) - LETHAL, septic shock, organ failure

/datum/disease/plague
	name = "The Plague"
	desc = "Чума - смертельная пандемия, сочетающая симптомы пепельной язвы и грязной лихорадки. Жертвы страдают от бубонов, кровавого кашля, почернения кожи и медленной мучительной смерти."
	max_stages = 4
	stage_prob = 0 // Manual progression via timers
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_BLOOD
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_DANGEROUS
	viable_mobtypes = list(/mob/living/carbon/human)
	
	// Tracking variables
	var/list/stat_mod_keys = null
	var/last_stage = 0
	var/infected_time = 0
	var/stage2_time = 0
	var/stage3_time = 0
	var/stage4_time = 0
	
	// Symptom scheduling
	var/stage_tick_scheduled = FALSE
	var/stage_tick_timer = null
	var/cough_scheduled = FALSE
	var/cough_timer = null
	var/scratch_scheduled = FALSE
	var/scratch_timer = null
	var/septic_scheduled = FALSE
	var/septic_timer = null
	var/vomit_scheduled = FALSE
	var/vomit_timer = null
	
	// Visual effects
	var/colorblind_active = FALSE
	var/colorblind_timer = null
	var/skin_blackening = 0 // Tracks progression of necrosis

/datum/disease/plague/after_add()
	. = ..()
	var/mob/living/carbon/human/H = affected_mob
	if(!ishuman(H))
		return
	infected_time = world.time
	apply_stage_effects(H, stage)
	schedule_stage_tick()
	RegisterSignal(H, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/disease/plague/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!ishuman(affected_mob))
		return
	switch(stage)
		if(1)
			examine_list += span_warning("[affected_mob.p_their(TRUE)] кожа покрыта бледными пятнами, и выглядит нездорово.")
		if(2)
			examine_list += span_warning("[affected_mob.p_their(TRUE)] кожа покрыта болезненными бубонами и сочащимися язвами.")
		if(3)
			examine_list += span_danger("[affected_mob.p_their(TRUE)] кожа чернеет и отмирает, покрытая гниющими ранами и зловонными нарывами!")
		if(4)
			examine_list += span_userdanger("[affected_mob.p_their(TRUE)] тело почернело от некроза, источая запах смерти! [affected_mob.p_theyre(TRUE)] явно при смерти!")

/datum/disease/plague/proc/schedule_stage_tick()
	if(stage_tick_scheduled)
		return
	stage_tick_scheduled = TRUE
	stage_tick_timer = addtimer(CALLBACK(src, PROC_REF(stage_tick)), 10 SECONDS, TIMER_STOPPABLE)

/datum/disease/plague/proc/stage_tick()
	stage_tick_scheduled = FALSE
	if(QDELETED(src) || !affected_mob)
		return
	if(!infected_time)
		infected_time = world.time
	
	var/mob/living/carbon/human/H = affected_mob
	
	// Stage progression based on time
	if(stage == 1 && world.time - infected_time >= rand(3 MINUTES, 4 MINUTES))
		update_stage(2)
		apply_stage_effects(H, 2)
	else if(stage == 2 && stage2_time && world.time - stage2_time >= rand(5 MINUTES, 6 MINUTES))
		update_stage(3)
		apply_stage_effects(H, 3)
	else if(stage == 3 && stage3_time && world.time - stage3_time >= rand(15 MINUTES, 20 MINUTES))
		update_stage(4)
		apply_stage_effects(H, 4)
	
	schedule_stage_tick()

/datum/disease/plague/proc/apply_stage_effects(mob/living/carbon/human/H, new_stage)
	if(!stat_mod_keys)
		stat_mod_keys = list()
	
	// Clear old stat mods
	for(var/stat in stat_mod_keys)
		H.change_stat(stat, 0, stat_mod_keys[stat])
	stat_mod_keys = list()
	
	// Apply new stat mods based on stage
	var/list/stats = list(
		STATKEY_STR = 0,
		STATKEY_PER = 0,
		STATKEY_INT = 0,
		STATKEY_CON = 0,
		STATKEY_SPD = 0,
		STATKEY_WIL = 0
	)
	
	switch(new_stage)
		if(1) // Incubation - Mild debuffs
			stats[STATKEY_PER] = -2
			stats[STATKEY_SPD] = -2
			stats[STATKEY_CON] = -2
			to_chat(H, span_warning("Чувствую себя нездорово... Тело ломит, и кожа начинает зудеть."))
			// Stage 1 symptoms: кашель
			schedule_cough()
			
		if(2) // Early Plague - Moderate debuffs + TRAITS
			stats[STATKEY_STR] = -3
			stats[STATKEY_PER] = -4
			stats[STATKEY_INT] = -2
			stats[STATKEY_CON] = -6
			stats[STATKEY_SPD] = -4
			stats[STATKEY_WIL] = -3
			stage2_time = world.time
			
			// Add terrifying traits
			ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, "plague_disease")
			ADD_TRAIT(H, TRAIT_LEPROSY, "plague_disease")
			
			to_chat(H, span_userdanger("Чума прогрессирует! Моё тело становится слабым, кости хрупкими... Но что-то странное происходит с моими ногами!"))
			H.visible_message(
				span_danger("[H] покрывается болезненными бубонами и начинает странно подёргиваться!"),
				ignored_mobs = list(H)
			)
			// Stage 2 symptoms: кашель + чесание
			schedule_cough()
			schedule_scratch()
			schedule_vomit()
			
		if(3) // Advanced Plague - Severe debuffs
			stats[STATKEY_STR] = -6
			stats[STATKEY_PER] = -7
			stats[STATKEY_INT] = -4
			stats[STATKEY_CON] = -12
			stats[STATKEY_SPD] = -8
			stats[STATKEY_WIL] = -6
			stage3_time = world.time
			skin_blackening = 1
			
			// Keep stage 2 traits and add new one
			ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, "plague_disease")
			ADD_TRAIT(H, TRAIT_LEPROSY, "plague_disease")
			ADD_TRAIT(H, TRAIT_NORUN, "plague_disease")
			
			to_chat(H, span_userdanger("ЧУМА ПОЖИРАЕТ МЕНЯ! Кожа чернеет, язвы гноятся, я едва держусь на ногах!"))
			H.visible_message(
				span_userdanger("[H] кожа чернеет и гниёт! Зловоние ужасно!"),
				ignored_mobs = list(H)
			)
			// Stage 3 symptoms: кашель + чесание (более частые и тяжёлые)
			schedule_cough()
			schedule_scratch()
			schedule_vomit()
			
		if(4) // Terminal Stage - LETHAL, critical debuffs
			stats[STATKEY_STR] = -10
			stats[STATKEY_PER] = -10
			stats[STATKEY_INT] = -8
			stats[STATKEY_CON] = -20
			stats[STATKEY_SPD] = -12
			stats[STATKEY_WIL] = -10
			stage4_time = world.time
			skin_blackening = 2
			
			// Keep all previous traits
			ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, "plague_disease")
			ADD_TRAIT(H, TRAIT_LEPROSY, "plague_disease")
			ADD_TRAIT(H, TRAIT_NORUN, "plague_disease")
			
			to_chat(H, span_userdanger("МОЁ ТЕЛО УМИРАЕТ! Органы отказывают, кровь превращается в яд! Я УМИРАЮ!!!"))
			H.visible_message(
				span_userdanger("[H] впадает в септический шок! [H.p_theyre(TRUE)] умирает от чумы!"),
				ignored_mobs = list(H)
			)
			// Stage 4 symptoms: кашель + чесание + септический шок
			schedule_cough()
			schedule_scratch()
			schedule_vomit()
			schedule_septic_shock()
	
	// Apply stat mods
	for(var/stat in stats)
		if(stats[stat] != 0)
			var/key = "plague_[stat]_\ref[src]"
			stat_mod_keys[stat] = key
			H.change_stat(stat, stats[stat], key)
	
	last_stage = new_stage

/datum/disease/plague/stage_act(delta_time, times_fired)
	. = ..()
	if(!affected_mob || QDELETED(src))
		return
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	
	// Stage 1 symptoms - Mild
	if(stage >= 1)
		if(DT_PROB(5, delta_time))
			H.adjust_hydration(-3)
		if(DT_PROB(3, delta_time))
			H.adjustBruteLoss(rand(1, 2))
			to_chat(H, span_warning("Суставы ломит от непонятной боли."))
	
	// Stage 2 symptoms - Moderate
	if(stage >= 2)
		if(DT_PROB(8, delta_time))
			H.adjust_hydration(-8)
		if(DT_PROB(5, delta_time))
			H.blur_eyes(8)
			to_chat(H, span_warning("Голова кружится, зрение плывёт."))
		if(DT_PROB(4, delta_time))
			H.adjustBruteLoss(rand(2, 4))
			to_chat(H, span_warning("Бубоны на теле пульсируют болью!"))
	
	// Stage 3 symptoms - Severe
	if(stage >= 3)
		if(DT_PROB(10, delta_time))
			H.adjustBruteLoss(rand(2, 4))
			H.bleed(rand(10, 20))
			to_chat(H, span_danger("Язвы разрываются, истекая кровью и гноем!"))
		if(DT_PROB(6, delta_time))
			H.Knockdown(rand(20, 40))
			to_chat(H, span_danger("Ноги отказывают, и я падаю!"))
		if(DT_PROB(4, delta_time) && !colorblind_active)
			colorblind_active = TRUE
			H.add_client_colour(/datum/client_colour/monochrome)
			to_chat(H, span_danger("Мир теряет краски, всё становится серым..."))
			if(colorblind_timer)
				deltimer(colorblind_timer)
			colorblind_timer = addtimer(CALLBACK(src, PROC_REF(clear_colorblind)), 30 SECONDS, TIMER_STOPPABLE)
		if(DT_PROB(5, delta_time))
			H.adjustToxLoss(rand(2, 5))
			to_chat(H, span_danger("Кровь отравлена инфекцией!"))
	
	// Stage 4 symptoms - LETHAL
	if(stage >= 4)
		if(DT_PROB(15, delta_time)) // Frequent damage ticks
			H.adjustBruteLoss(rand(2, 4))
			H.adjustToxLoss(rand(2, 4))
		if(DT_PROB(8, delta_time))
			H.adjustOxyLoss(rand(10, 20))
			to_chat(H, span_userdanger("Лёгкие заполняются жидкостью! Не могу дышать!"))
		if(DT_PROB(6, delta_time))
			H.vomit(rand(30, 50), blood = TRUE, stun = TRUE)
			H.bleed(rand(30, 50))
			to_chat(H, span_userdanger("Изрыгаю сгустки крови и чёрной желчи!"))

// ============== COUGH SYMPTOM ==============
/datum/disease/plague/proc/schedule_cough()
	if(cough_scheduled)
		return
	cough_scheduled = TRUE
	// Make cough slightly less frequent than before
	var/delay = rand(12, 25) SECONDS
	if(stage >= 3)
		delay = rand(6, 12) SECONDS
	if(stage >= 4)
		delay = rand(4, 8) SECONDS
	cough_timer = addtimer(CALLBACK(src, PROC_REF(cough_tick)), delay, TIMER_STOPPABLE)

/datum/disease/plague/proc/cough_tick()
	cough_scheduled = FALSE
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	// If not yet at stage 2, just reschedule and do a light cough
	if(stage < 2)
		schedule_cough()
		return

	// Slightly reduce the chances for violent cough events
	if(stage >= 4 && prob(45))
		H.emote("cough", intentional = FALSE)
		H.vomit(rand(10,20), blood = TRUE, stun = TRUE)
		H.bleed(rand(15, 25))
		to_chat(H, span_userdanger("Кашляю кровью! Не могу остановить это!"))
	else if(stage >= 3 && prob(30))
		H.emote("cough", intentional = FALSE)
		H.bleed(rand(8, 15))
		H.vomit(rand(5, 10), blood = TRUE, stun = FALSE)
		to_chat(H, span_danger("Кровавый кашель разрывает горло!"))
	else
		H.emote("cough", intentional = FALSE)
	
	// Spread disease through cough
	var/cough_range = 2
	if(stage >= 3)
		cough_range = 3
	if(stage >= 4)
		cough_range = 4
	
	var/spread_chance = 20
	if(stage >= 2)
		spread_chance = 40
	if(stage >= 3)
		spread_chance = 60
	if(stage >= 4)
		spread_chance = 80
	
	for(var/mob/living/carbon/human/target in oview(cough_range, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		if(prob(spread_chance))
			target.ForceContractDisease(src, TRUE, FALSE)
			to_chat(target, span_warning("Вдыхаю заражённые миазмы от [H]..."))

	schedule_cough()

// ============== SCRATCH SYMPTOM ==============
/datum/disease/plague/proc/schedule_scratch()
	if(scratch_scheduled)
		return
	if(stage < 2)
		return
	scratch_scheduled = TRUE
	// Similar to ash_blight but rarer at stage 2
	var/delay = rand(8, 18) SECONDS
	if(stage >= 3)
		delay = rand(6, 12) SECONDS
	if(stage >= 4)
		delay = rand(4, 8) SECONDS
	scratch_timer = addtimer(CALLBACK(src, PROC_REF(scratch_tick)), delay, TIMER_STOPPABLE)

/datum/disease/plague/proc/scratch_tick()
	scratch_scheduled = FALSE
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	
	H.emote("scratch", intentional = FALSE)
	
	var/damage = rand(2, 4)
	if(stage >= 3)
		damage = rand(4, 8)
	if(stage >= 4)
		damage = rand(6, 12)
	
	H.adjustBruteLoss(damage)
	
	var/list/scratch_messages = list(
		span_warning("Бубоны нестерпимо зудят, и я раздираю их ногтями!"),
		span_warning("Язвы лопаются под пальцами, выделяя мерзкий гной."),
		span_warning("Не могу перестать чесаться! Кожа разрывается!"),
		span_warning("Чёрные наросты крошатся под ногтями, оставляя кровоточащие раны."),
		span_danger("Раздираю кожу до крови, но зуд невыносим!")
	)
	to_chat(H, pick(scratch_messages))
	
	// Chance to cause wound from scratching
	// Make bleeding from scratching rarer than before, especially at stage 2/3
	var/wound_chance = 15
	if(stage >= 3)
		wound_chance = 35
	if(stage >= 4)
		wound_chance = 60
	
	if(prob(wound_chance) && length(H.bodyparts))
		var/obj/item/bodypart/BP = pick(H.bodyparts)
		if(BP)
			if(stage >= 3)
				BP.add_wound(/datum/wound/slash)
			else
				BP.add_wound(/datum/wound/slash/small)
			to_chat(H, span_danger("Царапины открыли кровоточащую рану!"))
	
	// Spread to nearby mobs through scratching/contact
	var/spread_range = 1
	if(stage >= 3)
		spread_range = 2
	
	for(var/mob/living/carbon/human/target in oview(spread_range, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		var/spread_chance = 30
		if(stage >= 3)
			spread_chance = 50
		if(stage >= 4)
			spread_chance = 70
		if(prob(spread_chance))
			target.ForceContractDisease(src, TRUE, FALSE)
	
	schedule_scratch()

// ============== VOMIT SYMPTOM ==============
/datum/disease/plague/proc/schedule_vomit()
	if(vomit_scheduled)
		return
	if(stage < 2)
		return
	vomit_scheduled = TRUE
	// Make stage 3 vomiting with stun and blood rarer
	var/delay = rand(30, 50) SECONDS
	if(stage >= 3)
		delay = rand(25, 45) SECONDS
	vomit_timer = addtimer(CALLBACK(src, PROC_REF(vomit_tick)), delay, TIMER_STOPPABLE)

/datum/disease/plague/proc/vomit_tick()
	vomit_scheduled = FALSE
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	if(stage >= 3)
		H.vomit(rand(10, 20), blood = TRUE, stun = TRUE)
		H.bleed(rand(10, 20))
		to_chat(H, span_danger("Изрыгаю сгустки крови и гноя!"))
	else
		H.vomit(rand(5, 10), blood = FALSE, stun = FALSE)
		to_chat(H, span_warning("Меня тошнит!"))
	schedule_vomit()

// ============== SEPTIC SHOCK (Stage 4 only) ==============
/datum/disease/plague/proc/schedule_septic_shock()
	if(septic_scheduled)
		return
	if(stage < 4)
		return
	septic_scheduled = TRUE
	septic_timer = addtimer(CALLBACK(src, PROC_REF(septic_tick)), 4 SECONDS, TIMER_STOPPABLE)

/datum/disease/plague/proc/septic_tick()
	septic_scheduled = FALSE
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	if(stage < 4)
		return
	
	var/mob/living/carbon/human/H = affected_mob
	
	// Massive damage from organ failure and sepsis
	H.adjustBruteLoss(rand(3, 5))
	H.adjustToxLoss(rand(2, 4))
	H.adjustOxyLoss(rand(2, 4))
	H.bleed(rand(3, 5))
	
	if(prob(30))
		var/list/septic_messages = list(
			span_userdanger("Сердце бьётся неровно! Органы отказывают!"),
			span_userdanger("Кровь превратилась в яд, отравляющий каждую клетку!"),
			span_userdanger("Лёгкие горят, не могу дышать!"),
			span_userdanger("Почки отказывают, боль невыносима!"),
			span_userdanger("Печень разваливается, и я тону в токсинах!")
		)
		to_chat(H, pick(septic_messages))
	
	if(prob(20))
		H.Knockdown(rand(40, 80))
		to_chat(H, span_userdanger("Падаю в конвульсиях!"))
		H.visible_message(
			span_userdanger("[H] корчится в агонии, истекая кровью!"),
			ignored_mobs = list(H)
		)
	
	// Check if victim is near death
	if(H.health <= -50)
		to_chat(H, span_userdanger("Это конец... Чума победила..."))
		H.death()
		return
	
	schedule_septic_shock()

// ============== CLEANUP ==============
/datum/disease/plague/proc/clear_colorblind()
	if(!colorblind_active)
		return
	colorblind_active = FALSE
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		H.remove_client_colour(/datum/client_colour/monochrome)
	if(colorblind_timer)
		deltimer(colorblind_timer)
		colorblind_timer = null

/datum/disease/plague/remove_disease()
	var/mob/living/carbon/human/H = affected_mob
	if(ishuman(H))
		UnregisterSignal(H, COMSIG_PARENT_EXAMINE)
		
		// Clear all timers
		if(stage_tick_timer)
			deltimer(stage_tick_timer)
			stage_tick_timer = null
		if(cough_timer)
			deltimer(cough_timer)
			cough_timer = null
		if(scratch_timer)
			deltimer(scratch_timer)
			scratch_timer = null
		if(vomit_timer)
			deltimer(vomit_timer)
			vomit_timer = null
		if(septic_timer)
			deltimer(septic_timer)
			septic_timer = null
		if(colorblind_timer)
			deltimer(colorblind_timer)
			colorblind_timer = null
		
		stage_tick_scheduled = FALSE
		cough_scheduled = FALSE
		scratch_scheduled = FALSE
		septic_scheduled = FALSE
		
		// Remove traits
		REMOVE_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, "plague_disease")
		REMOVE_TRAIT(H, TRAIT_LEPROSY, "plague_disease")
		REMOVE_TRAIT(H, TRAIT_NORUN, "plague_disease")
		
		// Clear colorblind
		if(colorblind_active)
			H.remove_client_colour(/datum/client_colour/monochrome)
			colorblind_active = FALSE
		
		// Clear stat mods
		if(stat_mod_keys)
			for(var/stat in stat_mod_keys)
				H.change_stat(stat, 0, stat_mod_keys[stat])
	
	return ..()

// Override cure to grant 30 minutes immunity instead of default 10
/datum/disease/plague/cure(add_resistance = TRUE)
	if(affected_mob && add_resistance && (disease_flags & CAN_RESIST))
		affected_mob.add_disease_resistance(GetDiseaseID(), 30 MINUTES)
		to_chat(affected_mob, span_notice("Моё тело выработало временный иммунитет к чуме."))
	return ..(FALSE) // Pass FALSE to parent to prevent double immunity
