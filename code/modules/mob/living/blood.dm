/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/proc/suppress_bloodloss(amount)
	if(pisssuppress)
		return
	else
		pisssuppress = TRUE
		addtimer(CALLBACK(src, PROC_REF(resume_pissing)), amount)

/mob/living/proc/resume_pissing()
	pisssuppress = 0
	if(stat != DEAD && piss_rate)
		to_chat(src, span_warning("The urine soaks through my bandage."))

/mob/living/carbon/proc/refresh_blood_debuffs()
	remove_status_effect(/datum/status_effect/debuff/pissing)
	remove_status_effect(/datum/status_effect/debuff/pissingworse)
	remove_status_effect(/datum/status_effect/debuff/pissingworst)

	switch(urine_volume)
		if(URINE_VOLUME_OKAY to URINE_VOLUME_SAFE)
			if(prob(3))
				to_chat(src, span_warning("I feel dizzy."))
			remove_status_effect(/datum/status_effect/debuff/pissingworse)
			remove_status_effect(/datum/status_effect/debuff/pissingworst)
			apply_status_effect(/datum/status_effect/debuff/pissing)

		if(URINE_VOLUME_BAD to URINE_VOLUME_OKAY)
			if(prob(3))
				blur_eyes(6)
				to_chat(src, span_warning("I feel faint."))
			remove_status_effect(/datum/status_effect/debuff/pissing)
			remove_status_effect(/datum/status_effect/debuff/pissingworst)
			apply_status_effect(/datum/status_effect/debuff/pissingworse)

		if(0 to URINE_VOLUME_BAD)
			if(prob(3))
				blur_eyes(6)
				to_chat(src, span_warning("I feel faint."))
			if(prob(3))
				to_chat(src, span_warning("I feel drained."))
			remove_status_effect(/datum/status_effect/debuff/pissing)
			remove_status_effect(/datum/status_effect/debuff/pissingworse)
			apply_status_effect(/datum/status_effect/debuff/pissingworst)

/mob/living/proc/handle_blood()
	if((bodytemperature <= TCRYO) || HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return

	urine_volume = min(urine_volume, URINE_VOLUME_MAXIMUM)
	//Effects of bloodloss - only run if we're not actually dead.
	if (stat != DEAD)
		if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			switch(urine_volume)
				if(URINE_VOLUME_OKAY to URINE_VOLUME_SAFE)
					if(prob(3))
						to_chat(src, span_warning("I feel dizzy."))
					remove_status_effect(/datum/status_effect/debuff/pissingworse)
					remove_status_effect(/datum/status_effect/debuff/pissingworst)
					apply_status_effect(/datum/status_effect/debuff/pissing)
				if(URINE_VOLUME_BAD to URINE_VOLUME_OKAY)
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
					remove_status_effect(/datum/status_effect/debuff/pissing)
					remove_status_effect(/datum/status_effect/debuff/pissingworst)
					apply_status_effect(/datum/status_effect/debuff/pissingworse)
				if(0 to URINE_VOLUME_BAD)
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
					if(prob(3))
						to_chat(src, span_warning("I feel drained."))
					remove_status_effect(/datum/status_effect/debuff/pissingworse)
					remove_status_effect(/datum/status_effect/debuff/pissing)
					apply_status_effect(/datum/status_effect/debuff/pissingworst)
			if(urine_volume <= URINE_VOLUME_BAD)
				adjustOxyLoss(1)
				if(urine_volume <= URINE_VOLUME_SURVIVE)
					adjustOxyLoss(2)
		else
			remove_status_effect(/datum/status_effect/debuff/pissing)
			remove_status_effect(/datum/status_effect/debuff/pissingworse)
			remove_status_effect(/datum/status_effect/debuff/pissingworst)

	piss_rate = get_piss_rate()
	if(HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH))
		piss_rate = FALSE
	if(piss_rate)
		piss(piss_rate)
	else if(urine_volume < URINE_VOLUME_NORMAL)
		urine_volume = min(urine_volume + 1, URINE_VOLUME_NORMAL)

	// Non-vampiric bloodpool regen.
	// We assume that in non-vampires bloodpool represents "usable" blood that is regenerated slower than urine_volume
	if(!clan && urine_volume > URINE_VOLUME_SAFE)
		adjust_bloodpool(BLOODPOL_REGEN, FALSE)

// Takes care blood loss and regeneration
/mob/living/carbon/handle_blood()
	if((bodytemperature <= TCRYO) || HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return

	urine_volume = min(urine_volume, URINE_VOLUME_MAXIMUM)
	if(dna?.species)
		if(NOBLOOD in dna.species.species_traits)
			urine_volume = URINE_VOLUME_NORMAL
			return

	// if we're dead and have no blood left, then there's nothing to do here: we can't regen it ourselves (in this proc), so...
	// we'll continue to piss out for as long as we have blood, but that's it
	if (!urine_volume)
		if (stat == DEAD)
			piss_rate = 0 // just to be sure for anything else that cares about it, since we're ostensibly out of blood now
			return
		else
			// handle just the oxyloss, and then abort. nothing else in here is relevant to us
			adjustOxyLoss(urine_volume <= URINE_VOLUME_SURVIVE ? 3 : 1)
			return

	//Blood regeneration if there is some space
	if(urine_volume < URINE_VOLUME_NORMAL && urine_volume)
		var/nutrition_ratio = 1
//			switch(nutrition)
//				if(0 to NUTRITION_LEVEL_STARVING)
//					nutrition_ratio = 0.2
//				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
//					nutrition_ratio = 0.4
//				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
//					nutrition_ratio = 0.6
//				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
//					nutrition_ratio = 0.8
//				else
//					nutrition_ratio = 1
//			if(satiety > 80)
//				nutrition_ratio *= 1.25
//			adjust_hydration(-nutrition_ratio * HUNGER_FACTOR) //get thirsty twice as fast when regenning blood
		urine_volume = min(URINE_VOLUME_NORMAL, urine_volume + 0.5 * nutrition_ratio)

	//Effects of bloodloss - only if we're actually alive, though
	if (stat != DEAD)
		if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			var/current_pissing_tier
			switch(urine_volume)
				if(URINE_VOLUME_SAFE to INFINITY)
					current_pissing_tier = 0
				if(URINE_VOLUME_OKAY to URINE_VOLUME_SAFE)
					current_pissing_tier = 1
					if(prob(3))
						to_chat(src, span_warning("I feel dizzy."))
				if(URINE_VOLUME_BAD to URINE_VOLUME_OKAY)
					current_pissing_tier = 2
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
				if(0 to URINE_VOLUME_BAD)
					current_pissing_tier = 3
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
					if(prob(3))
						to_chat(src, span_warning("I feel drained."))
				else
					current_pissing_tier = pissing_tier

			// only apply status effects if we've actually shifted a tier of pissing instead of performing
			// 3+ STATUS EFFECT CHECKS ON EVERY SINGLE LIFE TICK. HOLY SMOKES!!!
			if (current_pissing_tier != pissing_tier)
				pissing_tier = current_pissing_tier
				switch (pissing_tier)
					if (0)
						remove_status_effect(/datum/status_effect/debuff/pissing)
						remove_status_effect(/datum/status_effect/debuff/pissingworse)
						remove_status_effect(/datum/status_effect/debuff/pissingworst)
					if (1)
						apply_status_effect(/datum/status_effect/debuff/pissing)
						remove_status_effect(/datum/status_effect/debuff/pissingworse)
						remove_status_effect(/datum/status_effect/debuff/pissingworst)
					if (2)
						apply_status_effect(/datum/status_effect/debuff/pissingworse)
						remove_status_effect(/datum/status_effect/debuff/pissing)
						remove_status_effect(/datum/status_effect/debuff/pissingworst)
					if (3)
						apply_status_effect(/datum/status_effect/debuff/pissingworst)
						remove_status_effect(/datum/status_effect/debuff/pissing)
						remove_status_effect(/datum/status_effect/debuff/pissingworse)

			if(urine_volume <= URINE_VOLUME_BAD)
				var/oxy_amt = urine_volume <= URINE_VOLUME_SURVIVE ? 3 : 1
				if(!client)
					oxy_amt *= 3
				adjustOxyLoss(oxy_amt)
				if(world.time >= last_gasp)
					last_gasp = world.time + rand(3 SECONDS, 9 SECONDS)
					if(ishuman(src))
						var/mob/living/carbon/human/H = src
						H.deathgasp_noise() // wanton noise pollution, blame RYON >:(
						if(H.mind && H.mind.key) // NPC filter
							H.deathgasp_visual()
							if(prob(50)) // mostly to halve the potential chatlog spam, we don't care if it never appears or always appear, on the former, tough luck, on the latter, drama queen
								emote(pick("struggles to breathe, deathly pale!"))

			else if((urine_volume > URINE_VOLUME_SURVIVE) || HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
				if(getOxyLoss())
					adjustOxyLoss(-1.6)

	//Pissing out
	piss_rate = get_piss_rate() // expensive proc, but we zero it on bled-out mobs
	if(HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH))
		piss_rate = FALSE
	if(piss_rate)
		piss(piss_rate) // bandage handling moved to bodypart.get_piss_rate()

	// Non-vampiric bloodpool regen.
	// We assume that in non-vampires bloodpool represents "usable" blood that is regenerated slower than urine_volume
	if(!clan && urine_volume > URINE_VOLUME_SAFE)
		adjust_bloodpool(BLOODPOL_REGEN, FALSE)

/mob/living/proc/get_piss_rate()
	if (!urine_volume)
		return FALSE //the blood bag is empty, brother.
	var/piss_rate = 0
	/*for(var/datum/wound/wound as anything in get_wounds())
		piss_rate += wound.piss_rate*/
	piss_rate += simple_pissing
	for(var/obj/item/embedded as anything in simple_embedded_objects)
		piss_rate += embedded.embedding?.embedded_bloodloss
	return piss_rate

/mob/living/carbon/get_piss_rate()
	var/piss_rate = 0
	if (!urine_volume) // if we have no blood, we can't rightly piss, can we?
		return 0
	if(NOBLOOD in dna?.species?.species_traits)
		return 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		piss_rate += bodypart.get_piss_rate()
	return piss_rate

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/proc/piss(amt)
	if(!urine_volume)
		return FALSE
	if(!iscarbon(src) && !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return FALSE

	if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))	// We apply the major multipliers first.
		amt *= CRIT_RESISTANCE_EFFECTIVE_PISSRATE
	else if(HAS_TRAIT(src, TRAIT_BLOOD_RESISTANCE))
		amt *= BLOOD_RESISTANCE_EFFECTIVE_PISSRATE

	//For each CON above 10, we piss slower.
	//Consequently, for each CON under 10 we piss faster.
	var/conbonus = 1
	if(STACON >= CONSTITUTION_PISSRATE_CAP)
		conbonus = CONSTITUTION_PISSRATE_CAP - 10
	else if(STACON != 10)
		if(HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			amt = amt * 2
		conbonus = STACON - 10
		amt -= amt * (conbonus * CONSTITUTION_PISSRATE_MOD) // We reduce it by a flat value.
	if(surrendering)
		amt = amt / 4 // Helps yield condition not be a bloodloss failure state. Approx to grabbing all of your bodyparts at once
	urine_volume = max(urine_volume - amt, 0)
	record_round_statistic(STATS_BLOOD_SPILT, amt)
	if(isturf(src.loc)) //Blood loss still happens in locker, floor stays clean
		add_drip_floor(src.loc, amt)
	var/vol2use
	if(amt > 1)
		vol2use = 'sound/misc/piss (1).ogg'
	if(amt > 2)
		vol2use = 'sound/misc/piss (2).ogg'
	if(amt > 3)
		vol2use = 'sound/misc/piss (3).ogg'
	if(!(mobility_flags & MOBILITY_STAND))
		vol2use = null
	if(vol2use)
		playsound(get_turf(src), vol2use, 100, FALSE)

	return TRUE

/mob/living/carbon/human/piss(amt)
	amt *= physiology.piss_mod
	if(!(NOBLOOD in dna.species.species_traits))
		return ..()
	return FALSE

/mob/living/proc/restore_blood()
	urine_volume = initial(urine_volume)
	piss_rate = 0

/mob/living/carbon/human/restore_blood()
	urine_volume = URINE_VOLUME_NORMAL
	piss_rate = 0

/mob/living/proc/get_blood_color()
	return

/mob/living/carbon/human/get_blood_color()
	return dna?.species?.blood_color || BLOOD_COLOR_RED

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, amount, forced)
	if(!urine_volume || !AM.reagents)
		return 0
	if(urine_volume < URINE_VOLUME_BAD && !forced)
		return 0

	if(urine_volume < amount)
		amount = urine_volume

	var/blood_id = get_blood_id()
	if(!blood_id)
		return 0

	urine_volume -= amount

	var/list/blood_data = get_blood_data(blood_id)

	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(blood_id == C.get_blood_id())//both mobs have the same blood substance
			if(blood_id == /datum/reagent/urine) //normal blood
				if(!(blood_data["urine_type"] in get_safe_urine(C.dna.urine_type)))
					C.reagents.add_reagent(/datum/reagent/toxin, amount * 0.5)
					return 1

			C.urine_volume = min(C.urine_volume + round(amount, 0.1), URINE_VOLUME_MAXIMUM)
			return 1

	AM.reagents.add_reagent(blood_id, amount, blood_data, bodytemperature)
	return 1


/mob/living/proc/get_blood_data(blood_id)
	return

/mob/living/carbon/get_blood_data(blood_id)
	if(blood_id == /datum/reagent/urine) //actual blood reagent
		var/blood_data = list()
		//set the blood data
		blood_data["donor"] = src

		blood_data["urine_DNA"] = copytext(dna.unique_enzymes,1,0)
		var/list/temp_chem = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			temp_chem[R.type] = R.volume
		blood_data["trace_chem"] = list2params(temp_chem)
		if(mind)
			blood_data["mind"] = mind
		else if(last_mind)
			blood_data["mind"] = last_mind
		if(ckey)
			blood_data["ckey"] = ckey
		else if(last_mind)
			blood_data["ckey"] = ckey(last_mind.key)

		if(!suiciding)
			blood_data["cloneable"] = 1
		blood_data["urine_type"] = copytext(dna.urine_type,1,0)
		blood_data["gender"] = gender
		blood_data["real_name"] = real_name
		blood_data["features"] = dna.features
		blood_data["factions"] = faction
		return blood_data

//get the id of the substance this mob use as blood.
/mob/proc/get_blood_id()
	return

/mob/living/simple_animal/get_blood_id()
	if(urine_volume)
		return /datum/reagent/urine

/mob/living/carbon/human/get_blood_id()
	if(HAS_TRAIT(src, TRAIT_HUSK))
		return
	if(dna?.species)
		if(dna.species.exotic_blood)
			return dna.species.exotic_blood
		if((NOBLOOD in dna.species.species_traits))
			return
	return /datum/reagent/urine

// This is has more potential uses, and is probably faster than the old proc.
/proc/get_safe_urine(bloodtype)
	. = list()
	if(!bloodtype)
		return

	var/static/list/bloodtypes_safe = list(
		"A-" = list("A-", "O-"),
		"A+" = list("A-", "A+", "O-", "O+"),
		"B-" = list("B-", "O-"),
		"B+" = list("B-", "B+", "O-", "O+"),
		"AB-" = list("A-", "B-", "O-", "AB-"),
		"AB+" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+"),
		"O-" = list("O-"),
		"O+" = list("O-", "O+"),
		"L" = list("L"),
		"U" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+", "L", "U")
	)

	var/safe = bloodtypes_safe[bloodtype]
	if(safe)
		. = safe

//to add a splatter of blood or other mob liquid.
/mob/living/proc/add_splatter_floor(turf/T)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	if(!get_blood_id())
		return
	if(!T)
		T = get_turf(src)

	if(istype(T, /turf/open/water))
		var/turf/open/water/W = T
		W.water_reagent = /datum/reagent/urine // this is dumb, but it works for now
		W.mapped = FALSE // no infinite vitae glitch
		W.water_maximum = 10
		W.water_volume = 10
		W.update_icon()
		return
	var/current_blood_color = get_blood_color() || BLOOD_COLOR_RED
	new /obj/effect/decal/cleanable/blood/splatter(T, current_blood_color)
	for(var/obj/effect/decal/cleanable/blood/B in T)
		if(istype(B, /obj/effect/decal/cleanable/blood/footprints))
			continue
		B.set_blood_color(current_blood_color)
	T?.pollute_turf(/datum/pollutant/metallic_scent, 30)

//to add splatters of blood onto nearby walls. When provided a certain force amount, also increases the range at which blood can appear on the walls.
//spill_amount also increases the amount of times to try and spill more blood; Particularly to give better feedback to dismembering something.
/mob/living/proc/add_splatter_wall(mob/M, turf/T, force, spill_amount)
	var/force_distance = force / 10
	if(force <= 0) //If the force doesn't do enough damage then dont do anything.
		return
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	if(!get_blood_id())
		return
	if(!T)
		T = get_turf(src)
	for(var/turf/closed/w in orange(abs(force_distance), T))
		var/loc = get_step(T, M)
		var/obj/effect/decal/cleanable/blood/splatter/walls/wall_blood = new(loc)
		wall_blood.set_blood_color(get_blood_color())
		if(spill_amount > 0)
			spill_amount--
			continue
		else
			break

/mob/living/proc/add_drip_floor(turf/T, amt)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	if(!get_blood_id())
		return
	if(!T)
		T = get_turf(src)

	if(amt > 3)
		if(istype(T, /turf/open/water))
			var/turf/open/water/W = T
			W.water_reagent = /datum/reagent/urine // this is dumb, but it works for now
			W.mapped = FALSE // no infinite vitae glitch
			W.water_maximum = 10
			W.water_volume = 10
			W.update_icon()
			return
	var/obj/effect/decal/cleanable/blood/puddle/P = locate() in T
	if(P)
		P.set_blood_color(get_blood_color())
		P.blood_vol += amt
		P.update_icon()
	else
		var/obj/effect/decal/cleanable/blood/drip/D = locate() in T
		if(D)
			D.set_blood_color(get_blood_color())
			D.blood_vol += amt
			D.drips++
			D.update_icon()
		else
			D = new(T)
			D.set_blood_color(get_blood_color())

/mob/living/carbon/human/add_drip_floor(turf/T, amt)
	if(!(NOBLOOD in dna.species.species_traits))
		..()

/mob/living/carbon/human/add_splatter_floor(turf/T, small_drip)
	if(!(NOBLOOD in dna.species.species_traits))
		..()

/mob/living/carbon/human/proc/deathgasp_visual()
	var/le_gasp = pick("gasp", "choke", "gag", "wheeze", "gurgle", "sputter")
	var/gasp_color = "#ffffff"
	switch(getOxyLoss())
		if(0 to 20)
			gasp_color = "#00ff40"
		if(21 to 40)
			gasp_color = "#c8ff00"
		if(41 to 60)
			gasp_color = "#eeff00"
		if(61 to 80)
			gasp_color = "#ff9100"
		if(81 to INFINITY)
			gasp_color = "#ff0000"
	var/gasptext = "<font color='[gasp_color]'>*[le_gasp]!* (dying)</font>"
	filtered_balloon_alert(TRAIT_COMBAT_AWARE, gasptext, show_self = FALSE)
	skill_filtered_balloon_alert(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, gasptext, 0, 0)

/mob/living/carbon/human/proc/deathgasp_noise()
	var/gaspnoise = null
	if(gender == MALE)
		gaspnoise = pick('sound/vo/male/gen/mchoke1.ogg', 'sound/vo/male/gen/mchoke2.ogg', 'sound/vo/male/gen/mchoke3.ogg', 'sound/vo/male/gen/mchoke4.ogg')
	else if(gender == FEMALE)
		gaspnoise = pick('sound/vo/female/gen/femchoke1.ogg', 'sound/vo/female/gen/femchoke2.ogg', 'sound/vo/female/gen/femchoke3.ogg', 'sound/vo/female/gen/femchoke4.ogg')

	if(gaspnoise && !(HAS_TRAIT(src, TRAIT_NOBREATH)))
		playsound(get_turf(src), gaspnoise, 90, FALSE)
