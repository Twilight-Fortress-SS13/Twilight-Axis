GLOBAL_VAR_INIT(ta_climate_cold_breath_overlay, mutable_appearance(
	icon = 'icons/roguetown/mob/coldbreath.dmi',
	icon_state = "breath_m",
	layer = MOB_LAYER + 0.1
))

/turf/open/floor
	var/heat = 0

/mob/living/carbon/human
	var/ta_climate_wet_until = 0

/mob/living/proc/ta_climate_warm_from_source(amount, limit = BODYTEMP_NORMAL_MAX)
    limit = min(limit, BODYTEMP_NORMAL_MAX)
    if(stat == DEAD || bodytemperature >= limit || amount <= 0)
        return
    adjust_bodytemperature(min(amount, limit - bodytemperature))

/mob/living/carbon/human/proc/ta_climate_handle_environment_temperature(turf/cur_turf, loc_temp)
	if(!cur_turf || on_fire || stat == DEAD)
		if(on_fire || stat == DEAD)
			ta_climate_wet_until = 0
		if(GLOB.ta_climate_cold_breath_overlay in overlays)
			cut_overlay(GLOB.ta_climate_cold_breath_overlay)
		return
	ta_climate_update_clothing_wetness(cur_turf)
	var/wet_load = ta_climate_wet_clothing_load()
	var/env_adjust = 0
	var/protection = 0
	if(loc_temp > bodytemperature)
		if(bodytemperature < BODYTEMP_NORMAL_MIN)
			protection = 0.25 * get_cold_protection(loc_temp)
		else
			protection = -0.1 * get_heat_protection(loc_temp)
		env_adjust = 0.25 + protection
	else if(loc_temp < bodytemperature)
		if(bodytemperature > BODYTEMP_NORMAL_MAX)
			protection = 0.25 * get_heat_protection(loc_temp)
		else
			protection = -0.1 * get_cold_protection(loc_temp)
		env_adjust = -(0.25 + protection)
	if(loc_temp <= BODYTEMP_NORMAL_MIN && !istype(cur_turf, /turf/open/water))
		if(!(GLOB.ta_climate_cold_breath_overlay in overlays))
			add_overlay(GLOB.ta_climate_cold_breath_overlay)
	else if(GLOB.ta_climate_cold_breath_overlay in overlays)
		cut_overlay(GLOB.ta_climate_cold_breath_overlay)
	if(isturf(loc) && (env_adjust > 0 || bodytemperature > BODYTEMP_NORMAL_MAX))
		var/datum/particle_weather/W = SSParticleWeather?.runningWeather
		var/extreme_weather = W?.running && W.severity > 0 && istype(W, /datum/particle_weather/heatwave) && ta_climate_valid_outdoors(cur_turf)
		if(!extreme_weather)
			var/ordinary_heat = SSseason?.current_season == SEASON_WINTER && !ta_climate_is_desert_climate()
			if(!ordinary_heat && isfloorturf(cur_turf))
				var/turf/open/floor/heated_floor = cur_turf
				ordinary_heat = heated_floor.heat > 0
			if(!ordinary_heat && bodytemperature >= BODYTEMP_NORMAL_MAX - 1)
				for(var/obj/machinery/light/rogue/heat_source in range(6, cur_turf))
					if(heat_source.on && heat_source.heat_level > 0 && get_dist(heat_source, cur_turf) <= min(6, heat_source.heat_level))
						ordinary_heat = TRUE
						break
			if(ordinary_heat)
				if(bodytemperature > BODYTEMP_NORMAL_MAX)
					env_adjust = -min(2, bodytemperature - BODYTEMP_NORMAL_MAX)
				else if(env_adjust > 0)
					env_adjust = min(env_adjust, BODYTEMP_NORMAL_MAX - bodytemperature)
	if(env_adjust)
		adjust_bodytemperature(env_adjust)
	if(istype(cur_turf, /turf/open/water) && isturf(loc))
		var/turf/open/water/water_turf = cur_turf
		if(!water_turf.platform_atom_count && water_turf.water_level > 1 && ta_climate_valid_outdoors(cur_turf))
			ta_climate_wet_until = world.time + 60 SECONDS
			if(loc_temp < BODYTEMP_NORMAL_MIN && bodytemperature > loc_temp && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
				var/cold_protection = clamp(get_cold_protection(loc_temp), 0, 1)
				var/immersion = water_turf.water_level >= 3 ? 1.4 : 1
				var/extra_cooling = min(3.2, max(0.6, (bodytemperature - loc_temp) / 45)) * immersion * (1 - 0.4 * cold_protection)
				adjust_bodytemperature(-min(extra_cooling, bodytemperature - loc_temp))
	else if(ta_climate_wet_until > world.time && wet_load <= 0 && ta_climate_valid_outdoors(cur_turf) && loc_temp < BODYTEMP_NORMAL_MIN && bodytemperature > loc_temp && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		var/wet_cooling = 0.6 * ((ta_climate_wet_until - world.time) / (60 SECONDS)) * (1 - 0.5 * clamp(get_cold_protection(loc_temp), 0, 1))
		adjust_bodytemperature(-min(wet_cooling, bodytemperature - loc_temp))
	if(wet_load > 0 && loc_temp < BODYTEMP_NORMAL_MIN && bodytemperature > loc_temp && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		var/extra_wet_cooling = 1.8 * wet_load * wet_load
		adjust_bodytemperature(-min(extra_wet_cooling, bodytemperature - loc_temp))
	else if(wet_load > 0 && loc_temp >= 303.15 && bodytemperature > BODYTEMP_NORMAL_MIN)
		var/evaporative_cooling = 1.2 * wet_load
		adjust_bodytemperature(-min(evaporative_cooling, bodytemperature - BODYTEMP_NORMAL_MIN))
	if(isturf(loc) && istype(cur_turf, /turf/open/floor) && bodytemperature < BODYTEMP_NORMAL_MAX)
		var/turf/open/floor/F = cur_turf
		if(F.heat > 0)
			ta_climate_warm_from_source(F.heat * 4)
	if(loc_temp >= 303.15 && bodytemperature < BODYTEMP_NORMAL_MAX)
		var/metal_load = ta_climate_metal_heating_load()
		if(metal_load > 0)
			ta_climate_warm_from_source(0.40 * metal_load)
	if(isturf(loc))
		for(var/obj/structure/hotspring/S in cur_turf)
			if(!S.edge)
				ta_climate_warm_from_source(5)
				break

/mob/living/carbon/human
	var/heatstroke_timer_id
	var/hypothermia_timer_id
	var/ta_climate_temperature_death_signal_registered = FALSE
	var/ta_climate_last_hot_warning = 0
	var/ta_climate_last_cold_warning = 0
	var/ta_climate_independent_heat_floor = BODYTEMP_NORMAL_MAX

/proc/ta_climate_is_desert_climate()
	return SSmapping?.config?.map_name == "Desert Town"

/mob/living/carbon/human/proc/ta_climate_extreme_temperature_immune()
	if(istype(src, /mob/living/carbon/human/species/gnoll) || istype(src, /mob/living/carbon/human/species/werewolf) || istype(src, /mob/living/carbon/human/species/skeleton))
		return TRUE
	if(istype(dna?.species, /datum/species/gnoll) || istype(dna?.species, /datum/species/werewolf))
		return TRUE
	if(!length(bodyparts))
		return FALSE
	for(var/obj/item/bodypart/BP in bodyparts)
		if(!BP.skeletonized)
			return FALSE
	return TRUE

/mob/living/carbon/human/proc/ta_climate_temperature_offset()
	var/season = SSseason?.current_season
	var/map_name = SSmapping?.config?.map_name
	var/temperature_offset = 0
	switch(map_name)
		if("Desert Town")
			temperature_offset = 55
		if("Dun World")
			temperature_offset = -25
		if("Build Your Own Settlement")
			temperature_offset = 25
		else
			temperature_offset = 0
	switch(season)
		if(SEASON_SPRING)
			temperature_offset += ta_climate_is_desert_climate() ? -8 : 0
		if(SEASON_SUMMER)
			temperature_offset += ta_climate_is_desert_climate() ? 30 : 30
		if(SEASON_AUTUMN)
			temperature_offset += ta_climate_is_desert_climate() ? -10 : -22
		if(SEASON_WINTER)
			temperature_offset += ta_climate_is_desert_climate() ? -45 : -90
	var/period = SSoutdoor_effects?.current_step_datum?.name
	switch(period)
		if("Daytime")
			temperature_offset += ta_climate_is_desert_climate() ? 35 : 15
		if("Midnight", "Dusk")
			temperature_offset -= ta_climate_is_desert_climate() ? 40 : 20
		if("Dawn", "Sunrise")
			temperature_offset -= ta_climate_is_desert_climate() ? 20 : 5
	return temperature_offset

/mob/living/carbon/human/proc/get_temp_modifier()
	return ta_climate_temperature_offset()

/mob/living/carbon/human/proc/apply_weather_temperature(base_delta, exposure_temp = null)
	if(!base_delta)
		return 0
	if(isnull(exposure_temp))
		exposure_temp = bodytemperature + base_delta
	var/protection = 0
	if(base_delta > 0 && bodytemperature >= BODYTEMP_NORMAL_MIN)
		protection = get_heat_protection(exposure_temp)
	else if(base_delta < 0 && bodytemperature <= BODYTEMP_NORMAL_MAX)
		protection = get_cold_protection(exposure_temp)
	var/final_delta = base_delta * (1 - 0.75 * clamp(protection, 0, 1))
	var/previous_temperature = bodytemperature
	adjust_bodytemperature(final_delta)
	if(bodytemperature > previous_temperature)
		ta_climate_independent_heat_floor = max(BODYTEMP_NORMAL_MAX, min(bodytemperature, ta_climate_independent_heat_floor + bodytemperature - previous_temperature))
	return final_delta

/proc/ta_climate_apply_spell_temperature(mob/living/target, base_delta)
	if(!ishuman(target) || !base_delta)
		return 0
	var/mob/living/carbon/human/H = target
	return H.apply_weather_temperature(base_delta)

/mob/living/carbon/human/proc/ta_climate_temperature_warning()
	if(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX && world.time >= ta_climate_last_cold_warning)
		ta_climate_last_cold_warning = world.time + 20 SECONDS
		to_chat(src, span_danger("Холод сковывает тело. Пальцы немеют, а дрожь становится сильнее."))
	else if(bodytemperature < BODYTEMP_NORMAL_MIN && world.time >= ta_climate_last_cold_warning)
		ta_climate_last_cold_warning = world.time + 45 SECONDS
		to_chat(src, span_warning("Вы начинаете замерзать."))
	else if(bodytemperature > BODYTEMP_HEAT_LEVEL_ONE_MAX && world.time >= ta_climate_last_hot_warning)
		ta_climate_last_hot_warning = world.time + 20 SECONDS
		to_chat(src, span_danger("Жара становится невыносимой. Вас одолевает слабость."))
	else if(bodytemperature > BODYTEMP_NORMAL_MAX && world.time >= ta_climate_last_hot_warning)
		ta_climate_last_hot_warning = world.time + 45 SECONDS
		to_chat(src, span_warning("Вы перегреваетесь и обильно потеете."))

/mob/living/carbon/human/proc/apply_hypothermia()
	hypothermia_timer_id = null
	if(stat == DEAD || ta_climate_extreme_temperature_immune() || HAS_TRAIT(src, TRAIT_RESISTCOLD) || bodytemperature >= BODYTEMP_COLD_LEVEL_ONE_MAX)
		return
	var/list/possible = list()
	for(var/obj/item/bodypart/BP in bodyparts)
		var/already_affected = FALSE
		for(var/datum/wound/W in BP.wounds)
			if(istype(W, /datum/wound/hypothermia) || istype(W, /datum/wound/frostbite))
				already_affected = TRUE
				break
		if(!already_affected)
			possible += BP
	if(!length(possible))
		return
	var/obj/item/bodypart/target = pick(possible)
	target.add_wound(/datum/wound/hypothermia)

/mob/living/carbon/human/proc/apply_heatexhaust()
	heatstroke_timer_id = null
	if(stat == DEAD || ta_climate_extreme_temperature_immune() || HAS_TRAIT(src, TRAIT_RESISTHEAT) || bodytemperature <= BODYTEMP_HEAT_LEVEL_ONE_MAX)
		return
	var/obj/item/bodypart/head_part = get_bodypart(BODY_ZONE_HEAD)
	if(!head_part)
		return
	for(var/datum/wound/W in head_part.wounds)
		if(istype(W, /datum/wound/heatexhaustion) || istype(W, /datum/wound/heatstroke))
			return
	head_part.add_wound(/datum/wound/heatexhaustion)

/mob/living/carbon/human/proc/relieve_heatstroke_from_cold()
	for(var/obj/item/bodypart/BP in bodyparts)
		for(var/datum/wound/W in BP.wounds.Copy())
			if(istype(W, /datum/wound/heatstroke) || istype(W, /datum/wound/heatexhaustion))
				W.remove_from_bodypart()

/mob/living/carbon/human/proc/ta_climate_ambient_temperature_offset(turf/T)
	if(!isturf(loc) || !ta_climate_valid_outdoors(T))
		return 0
	return ta_climate_temperature_offset()

/mob/living/carbon/human/proc/ta_climate_clear_temperature_transient_effects()
	if(GLOB.ta_climate_cold_breath_overlay in overlays)
		cut_overlay(GLOB.ta_climate_cold_breath_overlay)
	if(heatstroke_timer_id)
		deltimer(heatstroke_timer_id)
		heatstroke_timer_id = null
	if(hypothermia_timer_id)
		deltimer(hypothermia_timer_id)
		hypothermia_timer_id = null
	remove_movespeed_modifier(MOVESPEED_ID_COLD)
	remove_status_effect(/datum/status_effect/debuff/ta_climate_freezing)
	remove_status_effect(/datum/status_effect/debuff/ta_climate_brittle)
	remove_status_effect(/datum/status_effect/debuff/ta_climate_overheat)

/mob/living/carbon/human/proc/ta_climate_temperature_death_signal(datum/source, gibbed)
	SIGNAL_HANDLER
	ta_climate_temperature_death_cleanup()

/mob/living/carbon/human/proc/ta_climate_temperature_death_cleanup()
	ta_climate_wet_until = 0
	ta_climate_independent_heat_floor = BODYTEMP_NORMAL_MAX
	ta_climate_clear_temperature_transient_effects()
	ta_climate_set_sandstorm_exposure(FALSE)
	clear_fullscreen("heatexhaust", FALSE)
	clear_fullscreen("heatstroke", FALSE)
	clear_fullscreen("hypothermia", FALSE)
	clear_fullscreen("frostbite", FALSE)
	if(hud_used?.temperature)
		var/atom/movable/screen/temperature/T = hud_used.temperature
		if(T.ta_climate_heated_tile)
			T.ta_climate_heated_tile = FALSE
			T.cut_overlay(GLOB.ta_climate_heated_floor_hud_overlay)
	for(var/obj/item/bodypart/BP in bodyparts)
		for(var/datum/wound/heatstroke/W in BP.wounds)
			if(W.cure_timer)
				deltimer(W.cure_timer)
				W.cure_timer = null

/mob/living/carbon/human/proc/ta_climate_limit_ordinary_heat_overflow()
	if(stat == DEAD || !isturf(loc))
		return
	if(on_fire)
		ta_climate_independent_heat_floor = max(BODYTEMP_NORMAL_MAX, bodytemperature)
		return
	var/turf/standing_turf = get_turf(src)
	if(!standing_turf)
		return
	var/datum/particle_weather/W = SSParticleWeather?.runningWeather
	if(W?.running && W.severity > 0 && istype(W, /datum/particle_weather/heatwave) && ta_climate_valid_outdoors(standing_turf))
		ta_climate_independent_heat_floor = max(BODYTEMP_NORMAL_MAX, bodytemperature)
		return
	var/near_ordinary_heat = FALSE
	if(isfloorturf(standing_turf))
		var/turf/open/floor/heated_floor = standing_turf
		near_ordinary_heat = heated_floor.heat > 0
	if(!near_ordinary_heat && bodytemperature > BODYTEMP_NORMAL_MAX)
		for(var/obj/machinery/light/rogue/F in range(6, standing_turf))
			if(F.on && F.heat_level > 0 && get_dist(F, standing_turf) <= min(6, F.heat_level))
				near_ordinary_heat = TRUE
				break
	if(!near_ordinary_heat)
		ta_climate_independent_heat_floor = max(BODYTEMP_NORMAL_MAX, bodytemperature)
		return
	var/allowed_temperature = max(BODYTEMP_NORMAL_MAX, ta_climate_independent_heat_floor)
	if(bodytemperature > allowed_temperature)
		adjust_bodytemperature(allowed_temperature - bodytemperature)
	ta_climate_independent_heat_floor = max(BODYTEMP_NORMAL_MAX, min(ta_climate_independent_heat_floor, bodytemperature))

/mob/living/carbon/human/proc/ta_climate_temperature_tick()
	if(!ta_climate_temperature_death_signal_registered)
		RegisterSignal(src, COMSIG_LIVING_DEATH, PROC_REF(ta_climate_temperature_death_signal))
		RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(ta_climate_wetness_moved))
		ta_climate_temperature_death_signal_registered = TRUE
	ta_climate_limit_ordinary_heat_overflow()
	ta_climate_update_temperature_hud()
	if(stat == DEAD || (ta_climate_extreme_temperature_immune() && !istype(dna?.species, /datum/species/construct/metal)))
		ta_climate_clear_temperature_transient_effects()
		if(stat == DEAD)
			ta_climate_temperature_death_cleanup()
			return
		for(var/obj/item/bodypart/BP in bodyparts)
			if(!BP || !BP.wounds)
				continue
			for(var/datum/wound/W in BP.wounds.Copy())
				if(istype(W, /datum/wound/hypothermia) || istype(W, /datum/wound/frostbite) || istype(W, /datum/wound/heatexhaustion) || istype(W, /datum/wound/heatstroke))
					W.remove_from_bodypart()
		return
	if(istype(dna?.species, /datum/species/construct/metal))
		if(heatstroke_timer_id)
			deltimer(heatstroke_timer_id)
			heatstroke_timer_id = null
		if(hypothermia_timer_id)
			deltimer(hypothermia_timer_id)
			hypothermia_timer_id = null
		remove_movespeed_modifier(MOVESPEED_ID_COLD)
		remove_status_effect(/datum/status_effect/debuff/ta_climate_freezing)
		if(bodytemperature >= BODYTEMP_HEAT_LEVEL_ONE_MAX && !HAS_TRAIT(src, TRAIT_RESISTHEAT))
			remove_status_effect(/datum/status_effect/debuff/ta_climate_brittle)
			apply_status_effect(/datum/status_effect/debuff/ta_climate_overheat)
			update_health_hud()
		else if(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
			remove_status_effect(/datum/status_effect/debuff/ta_climate_overheat)
			apply_status_effect(/datum/status_effect/debuff/ta_climate_brittle)
			update_health_hud()
		else
			remove_status_effect(/datum/status_effect/debuff/ta_climate_brittle)
			remove_status_effect(/datum/status_effect/debuff/ta_climate_overheat)
		return
	remove_status_effect(/datum/status_effect/debuff/ta_climate_brittle)
	remove_status_effect(/datum/status_effect/debuff/ta_climate_overheat)
	ta_climate_temperature_warning()
	if(bodytemperature < BODYTEMP_NORMAL_MIN && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		relieve_heatstroke_from_cold()
		if(!(m_intent == MOVE_INTENT_SNEAK || alpha <= 120) && prob(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX ? 15 : 5))
			addtimer(CALLBACK(src, PROC_REF(emote), "shiver"), rand(2, 6) * (1 SECONDS), TIMER_UNIQUE | TIMER_STOPPABLE)
	if(HAS_TRAIT(src, TRAIT_RESISTHEAT) && heatstroke_timer_id)
		deltimer(heatstroke_timer_id)
		heatstroke_timer_id = null
	if(HAS_TRAIT(src, TRAIT_RESISTCOLD) && hypothermia_timer_id)
		deltimer(hypothermia_timer_id)
		hypothermia_timer_id = null
	if(bodytemperature > BODYTEMP_HEAT_LEVEL_ONE_MAX && !HAS_TRAIT(src, TRAIT_RESISTHEAT) && !heatstroke_timer_id)
		heatstroke_timer_id = addtimer(CALLBACK(src, PROC_REF(apply_heatexhaust)), 2 MINUTES, TIMER_STOPPABLE)
	else if(bodytemperature <= BODYTEMP_HEAT_LEVEL_ONE_MAX && heatstroke_timer_id)
		deltimer(heatstroke_timer_id)
		heatstroke_timer_id = null
	if(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		apply_status_effect(/datum/status_effect/debuff/ta_climate_freezing)
		add_movespeed_modifier(MOVESPEED_ID_COLD, override = TRUE, multiplicative_slowdown = max(0, (BODYTEMP_COLD_LEVEL_ONE_MAX - bodytemperature) / 35), blacklisted_movetypes = FLOATING)
	else
		remove_movespeed_modifier(MOVESPEED_ID_COLD)
		remove_status_effect(/datum/status_effect/debuff/ta_climate_freezing)
	if(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX && !HAS_TRAIT(src, TRAIT_RESISTCOLD) && !hypothermia_timer_id)
		hypothermia_timer_id = addtimer(CALLBACK(src, PROC_REF(apply_hypothermia)), 2 MINUTES, TIMER_STOPPABLE)
	else if(bodytemperature >= BODYTEMP_COLD_LEVEL_ONE_MAX && hypothermia_timer_id)
		deltimer(hypothermia_timer_id)
		hypothermia_timer_id = null

/mob/living/carbon/human/proc/get_temperature_state()
	if(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX)
		return "Очень холодно"
	if(bodytemperature < BODYTEMP_NORMAL_MIN)
		return "Холодно"
	if(bodytemperature > BODYTEMP_HEAT_LEVEL_ONE_MAX)
		return "Очень жарко"
	if(bodytemperature > BODYTEMP_NORMAL_MAX)
		return "Жарко"
	return "Нормальная температура"

/mob/living/carbon/human/verb/check_temperature_state()
	set name = "Ощутить температуру"
	set category = "IC"
	var/temperature_state = get_temperature_state()
	var/list/description = list(span_notice("Температура тела: [temperature_state]."))
	switch(temperature_state)
		if("Очень холодно")
			description += span_warning("Сильная дрожь, замедление движений и риск обморожения.")
		if("Холодно")
			description += span_warning("На холоде организм быстрее расходует питательные вещества.")
		if("Жарко")
			description += span_warning("В жару сильнее мучает жажда.")
		if("Очень жарко")
			description += span_warning("Утомление, тяжёлое восстановление выносливости и риск теплового удара.")
	to_chat(src, description.Join("\n"))

/obj/effect/frozen_mist
	var/list/ta_climate_cooled_targets

/obj/effect/frozen_mist/proc/ta_climate_apply_single_exposure_cooling(mob/living/target)
	if(!ishuman(target) || QDELETED(target))
		return
	if(!ta_climate_cooled_targets)
		ta_climate_cooled_targets = list()
	if(ta_climate_cooled_targets[target])
		return
	ta_climate_cooled_targets[target] = TRUE
	ta_climate_apply_spell_temperature(target, -23)

/obj/structure/forcefield_weak/ice/proc/ta_climate_icewall_cooling(mob/living/target)
	if(!ishuman(target) || QDELETED(target) || target.anti_magic_check())
		return
	var/next_cooling = target.mob_timers["ta_climate_icewall_cooling"]
	if(next_cooling && next_cooling > world.time)
		return
	target.mob_timers["ta_climate_icewall_cooling"] = world.time + 1 SECONDS
	ta_climate_apply_spell_temperature(target, -23)
