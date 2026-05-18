/mob/living/stamina_add(added as num, emote_override, force_emote = TRUE)
	if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA))
		return TRUE

	var/true_added = added
	if(HAS_TRAIT(src, TRAIT_FORTITUDE))
		added = added * 0.5

	if(added < 0 && HAS_TRAIT(src, TRAIT_FROZEN_STAMINA))
		added = 0

	if(mind && true_added > 0)
		mind.add_sleep_experience(/datum/skill/misc/athletics, (STACON / 10) * ((true_added / max_stamina) * 10), show_xp = m_intent == MOVE_INTENT_RUN)

	stamina = CLAMP(stamina+added, 0, max_stamina)
	if(added > 0)
		energy_add(added * -0.6)
		adjust_nutrition(-stamina_nutrition_mod(added) * 0.5)
		if(added >= 5)
			if(energy <= 0)
				if(iscarbon(src))
					var/mob/living/carbon/C = src
					if(!HAS_TRAIT(C, TRAIT_NOHUNGER))
						if(C.nutrition <= 0)
							if(C.hydration <= 0)
								C.heart_attack()
								return FALSE

	if(ishuman(src) && mind && added > 0)
		var/mob/living/carbon/human/H = src
		var/text
		var/x_offset = 20
		var/y_offset
		var/stamratio = stamina / max_stamina
		if(stamratio >= 0.25 && ((stamina - added) / max_stamina) < 0.25)
			text = "<font color = '#a8af9b'>Winded</font>"
			y_offset = BALLOON_Y_OFFSET_TIER1
		if(stamratio >= 0.5 && ((stamina - added) / max_stamina) < 0.5)
			text = "<font color = '#d4d36c'>Drained</font>"
			y_offset = BALLOON_Y_OFFSET_TIER2
		if(stamratio >= 0.75 && ((stamina - added) / max_stamina) < 0.75)
			text = "<font color = '#a8665a'>Fatigued</font>"
			y_offset = BALLOON_Y_OFFSET_TIER3
		if(text)
			if(!HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS))
				H.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, x_offset, y_offset)
			else
				if(prob(10))
					text = "<i>Tired...?</i>"
					H.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, x_offset, y_offset)

	if(stamina >= max_stamina)
		stamina = max_stamina
		update_health_hud()
		if(m_intent == MOVE_INTENT_RUN)
			toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
		if(!emote_override)
			emote("fatigue", forced = force_emote)
		else
			emote(emote_override, forced = force_emote)

		var/turf/T = get_turf(src)
		if(istype(T, /turf/open/water/transparent))
			var/turf/below = GET_TURF_BELOW(T)
			if(below && istype(below, /turf/open/water/transparent))
				visible_message(span_danger("[src] loses all stamina and sinks into the depths!"))
				forceMove(below)
				set_resting(TRUE)
		else

			set_resting(TRUE)

		blur_eyes(2)
		last_fatigued = world.time + 3 SECONDS
		stop_attack()
		changeNext_move(CLICK_CD_EXHAUSTED)
		flash_fullscreen("blackflash")

		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			var/balloon_text = "<font color = '#bb2b2b'>Exhausted... </font>"
			H.balloon_alert_to_viewers(balloon_text, balloon_text, DEFAULT_MESSAGE_RANGE)

		if(energy <= 0)
			addtimer(CALLBACK(src, PROC_REF(Knockdown), 30), 1 SECONDS)
			var/area/rogue/our_area = get_area(src)
			if(our_area && our_area.necra_area)
				src.extract_from_deaths_edge()
			addtimer(CALLBACK(src, PROC_REF(Immobilize), 30), 1 SECONDS)
			if(iscarbon(src))
				var/mob/living/carbon/C = src
				if(C.get_stress_amount() >= 30)
					C.heart_attack()
				if(!HAS_TRAIT(C, TRAIT_NOHUNGER))
					if(C.nutrition <= 0)
						if(C.hydration <= 0)
							C.heart_attack()
							return FALSE
	else
		last_fatigued = world.time
		update_health_hud()
		return TRUE
