// FLU DISEASE - Airborne illness with coughing and stat penalties

/datum/disease/flu
	name = "Flu"
	desc = "A common illness that weakens the body."
	max_stages = 1
	stage_prob = 0
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_MINOR
	viable_mobtypes = list(/mob/living)
	var/list/stat_mod_keys = null
	var/cough_range = 3

/datum/disease/flu/after_add()
	. = ..()
	var/mob/living/L = affected_mob
	if(!istype(L))
		return
	ADD_TRAIT(L, TRAIT_CRITICAL_WEAKNESS, src)
	apply_stat_mods(L, -2)
	if(ishuman(L))
		schedule_cough()

/datum/disease/flu/proc/schedule_cough()
	addtimer(CALLBACK(src, PROC_REF(cough_tick)), rand(5, 15) SECONDS)

/datum/disease/flu/proc/cough_tick()
	if(QDELETED(src) || !affected_mob || !ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	H.emote("cough", intentional = TRUE)
	for(var/mob/living/carbon/human/target in oview(cough_range, H))
		if(target == H)
			continue
		if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
			continue
		if(prob(40))
			target.ForceContractDisease(src, TRUE, FALSE)
	schedule_cough()

/datum/disease/flu/proc/apply_stat_mods(mob/living/L, amt)
	if(!stat_mod_keys)
		stat_mod_keys = list()
	var/list/stats = list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON, STATKEY_WIL, STATKEY_SPD, STATKEY_LCK)
	for(var/stat in stats)
		var/key = "flu_[stat]_\ref[src]"
		stat_mod_keys[stat] = key
		L.change_stat(stat, amt, key)

/datum/disease/flu/remove_disease()
	var/mob/living/L = affected_mob
	if(istype(L))
		REMOVE_TRAIT(L, TRAIT_CRITICAL_WEAKNESS, src)
		if(stat_mod_keys)
			for(var/stat in stat_mod_keys)
				L.change_stat(stat, 0, stat_mod_keys[stat])
	return ..()
