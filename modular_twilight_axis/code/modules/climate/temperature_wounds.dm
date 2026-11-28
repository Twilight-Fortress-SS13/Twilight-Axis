/datum/wound/proc/ta_climate_safe_temperature_gain(mob/living/affected, fullscreen_key, fullscreen_type)
	if(QDELETED(src) || !affected || QDELETED(affected) || owner != affected || !bodypart_owner || bodypart_owner.owner != affected)
		return FALSE
	if(affected.stat != DEAD)
		affected.overlay_fullscreen(fullscreen_key, fullscreen_type)
	return TRUE

/datum/wound/proc/ta_climate_restore_temperature_overlay(fullscreen_key, fullscreen_type)
	if(!QDELETED(src) && owner && !QDELETED(owner) && owner.stat != DEAD)
		owner.overlay_fullscreen(fullscreen_key, fullscreen_type)

/datum/wound/heatexhaustion
	name = "Heat Exhaustion"
	check_name = span_warning("ТЕПЛОВОЕ ИСТОЩЕНИЕ")
	severity = 0
	crit_message = ""
	whp = null
	woundpain = 0
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE

	var/start_time
	var/duration = 2 MINUTES

/datum/wound/heatexhaustion/on_mob_gain(mob/living/affected)
	if(QDELETED(src) || !affected || QDELETED(affected) || owner != affected || !bodypart_owner || bodypart_owner.owner != affected)
		return
	. = ..()
	if(isnull(start_time))
		start_time = world.time
	ta_climate_safe_temperature_gain(affected, "heatexhaust", /atom/movable/screen/fullscreen/heatexhaust)
	if(!owner.stat)
		to_chat(owner, span_warning("A wave of heat washes over me... I feel faint."))

/datum/wound/heatexhaustion/on_life()
	. = ..()
	if(isnull(start_time))
		start_time = world.time
	if(owner && owner.stat != DEAD)
		ta_climate_restore_temperature_overlay("heatexhaust", /atom/movable/screen/fullscreen/heatexhaust)

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	if(C.stat == DEAD)
		return

	// If cooled off, remove heat exhaustion
	if(C.bodytemperature <= BODYTEMP_NORMAL_MAX)
		to_chat(C, span_notice("Cool air steadies me. The worst of the heat passes."))
		remove_from_bodypart()
		return

	// Occasional discomfort message
	if(!C.stat && prob(5))
		to_chat(C, span_warning("My vision swims from the heat..."))

	// After 2 minute, convert to heatstroke
	if(world.time >= start_time + duration)
		var/obj/item/bodypart/BP = bodypart_owner
		if(BP)
			to_chat(C, span_userdanger("The heat overwhelms me!"))
			BP.add_wound(/datum/wound/heatstroke)
		remove_from_bodypart()

/datum/wound/heatstroke
	name = "Heatstroke"
	check_name = span_warning("ТЕПЛОВОЙ УДАР")
	severity = 0
	crit_message = ""
	whp = null
	woundpain = 0
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE
	var/cure_timer

/datum/wound/heatstroke/on_mob_gain(mob/living/affected)
	if(QDELETED(src) || !affected || QDELETED(affected) || owner != affected || !bodypart_owner || bodypart_owner.owner != affected)
		return
	. = ..()
	ta_climate_safe_temperature_gain(affected, "heatstroke", /atom/movable/screen/fullscreen/heatstroke)

/datum/wound/heatstroke/on_life()
	. = ..()
	if(owner && owner.stat != DEAD)
		ta_climate_restore_temperature_overlay("heatstroke", /atom/movable/screen/fullscreen/heatstroke)

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	if(C.stat == DEAD)
		return

	if(!C.stat && prob(5))
		if(prob(5))
			C.vomit(1, blood = FALSE, stun = TRUE)
		to_chat(owner, span_warning("The world is spinning!"))
		C.Dizzy(10)

	// If temperature is normal, start cure timer
	if(C.bodytemperature <= BODYTEMP_NORMAL_MAX)
		if(!cure_timer)
			to_chat(C, span_notice("The heat begins to slowly fade from my body..."))
			cure_timer = addtimer(CALLBACK(src, PROC_REF(cure_heatstroke)), 2 MINUTES, TIMER_STOPPABLE)

	// If overheating again, cancel cure timer
	else
		if(cure_timer)
			deltimer(cure_timer)
			cure_timer = null

/datum/wound/heatstroke/on_mob_loss(mob/living/affected)
	. = ..()
	if(cure_timer)
		deltimer(cure_timer)
		cure_timer = null
	if(!affected)
		return
	if(ishuman(affected))
		var/mob/living/carbon/human/H = affected
		if(H.ta_climate_has_temperature_wound(/datum/wound/heatstroke, src))
			return
	affected.clear_fullscreen("heatstroke")
	if(iscarbon(affected))
		var/mob/living/carbon/C = affected
		to_chat(C, span_warning("The world has stopped spinning."))
		C.set_dizziness(0)

/datum/wound/heatstroke/proc/cure_heatstroke()
	cure_timer = null
	if(!iscarbon(owner) || owner.stat == DEAD || owner.bodytemperature > BODYTEMP_NORMAL_MAX)
		return

	to_chat(owner, span_notice("The world finally stops spinning as the heat leaves me."))
	remove_from_bodypart()

/datum/wound/frostbite
	name = "Frostbite"
	check_name = span_blue("ОБМОРОЖЕНИЕ")
	severity = 0
	crit_message = ""
	whp = null
	woundpain = 0
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE
	var/stage = 1
	var/last_stage_tick
	var/stage_interval = 2 MINUTES

/datum/wound/frostbite/on_mob_gain(mob/living/affected)
	if(QDELETED(src) || !affected || QDELETED(affected) || owner != affected || !bodypart_owner || bodypart_owner.owner != affected)
		return
	. = ..()
	if(isnull(last_stage_tick))
		last_stage_tick = world.time
	update_stage_name()
	ta_climate_safe_temperature_gain(affected, "frostbite", /atom/movable/screen/fullscreen/frostbite)

/datum/wound/frostbite/on_life()
	. = ..()
	if(isnull(last_stage_tick))
		last_stage_tick = world.time
	if(owner && owner.stat != DEAD)
		ta_climate_restore_temperature_overlay("frostbite", /atom/movable/screen/fullscreen/frostbite)

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	if(C.stat == DEAD)
		return
	var/obj/item/bodypart/BP = bodypart_owner

	// Warmth degrades frostbite
	if(C.bodytemperature >= BODYTEMP_NORMAL_MIN)
		if(world.time >= last_stage_tick + (1 MINUTES))
			stage--
			last_stage_tick = world.time

			if(stage >= 1)
				to_chat(C, span_notice("The feeling slowly returns to my [BP]..."))
				disabling = FALSE
				update_stage_name()
			else
				to_chat(C, span_notice("Warmth returns to my [BP]. The frostbite has healed."))
				remove_from_bodypart()
				return

	// Stage progression
	if(stage < 3 && world.time >= last_stage_tick + stage_interval && C.bodytemperature < BODYTEMP_NORMAL_MIN)
		stage++
		last_stage_tick = world.time
		update_stage_name()

		switch(stage)
			if(2)
				to_chat(C, span_userdanger("My [BP] is completely numb..."))
			if(3)
				to_chat(C, span_userdanger("My [BP] feels dead and brittle!"))
				disabling = TRUE

	// Damage scaling per stage
	if(!C.stat && prob(30))
		var/damage = 0
		switch(stage)
			if(1)
				damage = 2
			if(2)
				damage = 5
			if(3)
				damage = 10
		if(BP.bandage)
			damage = damage *0.25

		C.apply_damage(damage, BURN)

/datum/wound/frostbite/proc/update_stage_name()
	var/stage_text

	switch(stage)
		if(1)
			stage_text = "I"
		if(2)
			stage_text = "II"
		if(3)
			stage_text = "III"

	check_name = span_blue("FROSTBITE ([stage_text])")


/datum/wound/hypothermia
	name = "Hypothermia"
	check_name = span_blue("ПЕРЕОХЛАЖДЕНИЕ")
	severity = 0
	crit_message = ""
	whp = 40
	woundpain = 0
	mob_overlay = null
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE

	var/start_time
	var/duration = 2 MINUTES

/datum/wound/hypothermia/on_mob_gain(mob/living/affected)
	if(QDELETED(src) || !affected || QDELETED(affected) || owner != affected || !bodypart_owner || bodypart_owner.owner != affected)
		return
	. = ..()
	start_time = world.time
	ta_climate_safe_temperature_gain(affected, "hypothermia", /atom/movable/screen/fullscreen/hypothermia)


// If warmed up, remove hypothermia, check once every minute for 50% removing wound if normal temp
/datum/wound/hypothermia
	var/next_removal_check = 0

/datum/wound/hypothermia/on_life()
	. = ..()
	if(owner && owner.stat != DEAD)
		ta_climate_restore_temperature_overlay("hypothermia", /atom/movable/screen/fullscreen/hypothermia)

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	if(C.stat == DEAD)
		return

	if(C.bodytemperature >= BODYTEMP_NORMAL_MIN && world.time >= next_removal_check)
		next_removal_check = world.time + 1 MINUTES

		if(prob(50))
			to_chat(C, span_notice("Feeling returns to my body as I warm up."))
			remove_from_bodypart()
			return

	if(C.bodytemperature >= BODYTEMP_COLD_LEVEL_ONE_MAX || HAS_TRAIT(C, TRAIT_RESISTCOLD))
		start_time = world.time
	else if(world.time >= start_time + duration)
		var/obj/item/bodypart/BP = bodypart_owner
		if(BP && BP.owner == C)
			for(var/datum/wound/frostbite/F in BP.wounds)
				remove_from_bodypart()
				return
			to_chat(C, span_userdanger("My [BP] is completely numb from the cold!"))
			remove_from_bodypart()
			BP.add_wound(/datum/wound/frostbite)
			return

	// Occasional discomfort message
	if(!C.stat && prob(5))
		to_chat(C, span_warning("I can't stop shivering..."))


/mob/living/carbon/human/proc/ta_climate_has_temperature_wound(wound_path, datum/wound/excluded)
	for(var/obj/item/bodypart/BP in bodyparts)
		for(var/datum/wound/W in BP.wounds)
			if(W != excluded && istype(W, wound_path))
				return TRUE
	return FALSE

/datum/wound/heatexhaustion/on_mob_loss(mob/living/affected)
	. = ..()
	if(!affected)
		return
	if(ishuman(affected))
		var/mob/living/carbon/human/H = affected
		if(H.ta_climate_has_temperature_wound(/datum/wound/heatexhaustion, src))
			return
	affected.clear_fullscreen("heatexhaust")

/datum/wound/hypothermia/on_mob_loss(mob/living/affected)
	. = ..()
	if(!affected)
		return
	if(ishuman(affected))
		var/mob/living/carbon/human/H = affected
		if(H.ta_climate_has_temperature_wound(/datum/wound/hypothermia, src))
			return
	affected.clear_fullscreen("hypothermia")

/datum/wound/frostbite/on_mob_loss(mob/living/affected)
	. = ..()
	if(!affected)
		return
	if(ishuman(affected))
		var/mob/living/carbon/human/H = affected
		if(H.ta_climate_has_temperature_wound(/datum/wound/frostbite, src))
			return
	affected.clear_fullscreen("frostbite")
