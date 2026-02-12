// ASH BLIGHT DISEASE - Moderate contact disease with stat penalties and scratching

/datum/disease/ash_blight
	name = "Ash Blight"
	desc = "A gritty rash that saps focus and speed."
	max_stages = 1
	stage_prob = 0
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_MEDIUM
	viable_mobtypes = list(/mob/living)
	var/list/stat_mod_keys = null

/datum/disease/ash_blight/after_add()
	. = ..()
	var/mob/living/L = affected_mob
	if(!istype(L))
		return
	apply_stat_mods(L)
	RegisterSignal(L, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	if(ishuman(L))
		schedule_scratch()

/datum/disease/ash_blight/proc/apply_stat_mods(mob/living/L)
	if(!stat_mod_keys)
		stat_mod_keys = list()
	var/list/stats = list(
		STATKEY_PER = -4,
		STATKEY_SPD = -2
	)
	for(var/stat in stats)
		var/key = "ash_blight_[stat]_\ref[src]"
		stat_mod_keys[stat] = key
		L.change_stat(stat, stats[stat], key)

/datum/disease/ash_blight/remove_disease()
	var/mob/living/L = affected_mob
	if(istype(L))
		UnregisterSignal(L, COMSIG_PARENT_EXAMINE)
		if(stat_mod_keys)
			for(var/stat in stat_mod_keys)
				L.change_stat(stat, 0, stat_mod_keys[stat])
	return ..()

/datum/disease/ash_blight/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_warning("Кожа изуродована пепельными пятнами и сочащейся язвой, образующей отвратительную корку.")

/datum/disease/ash_blight/proc/schedule_scratch()
	addtimer(CALLBACK(src, PROC_REF(scratch_tick)), rand(5, 15) SECONDS)

/datum/disease/ash_blight/proc/scratch_tick()
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	H.emote("scratch", intentional = FALSE)
	
	// Damage and message to player
	H.adjustBruteLoss(2)
	var/list/scratch_messages = list(
		span_warning("Кожа нестерпимо зудит, и я сдираю струпья своими ногтями."),
		span_warning("Язвы на коже разрываются под моими пальцами, выделяя мерзкую жидкость."),
		span_warning("Я раздираю кожу ногтями, но зуд не проходит."),
		span_warning("Пепельные наросты крошатся под ногтями, оставляя кровоточащие следы."),
		span_warning("Чешу кожу до крови, но облегчения не наступает.")
	)
	to_chat(H, pick(scratch_messages))
	
	// 20% chance to cause bleeding wound from scratching
	if(prob(20) && length(H.bodyparts))
		var/obj/item/bodypart/BP = pick(H.bodyparts)
		if(BP)
			BP.add_wound(/datum/wound/slash/small)
			to_chat(H, span_danger("Мои царапины открыли кровоточащую рану!"))
	
	// Spread to nearby mobs in 1 tile radius
	for(var/mob/living/carbon/human/target in oview(1, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		if(prob(50))
			target.ForceContractDisease(src, TRUE, FALSE)
	schedule_scratch()
