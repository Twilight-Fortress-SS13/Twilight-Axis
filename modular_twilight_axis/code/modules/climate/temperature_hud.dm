GLOBAL_VAR_INIT(ta_climate_heated_floor_hud_overlay, mutable_appearance(
	icon = 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature.dmi',
	icon_state = "tempheated"
))

/datum/hud
	var/atom/movable/screen/temperature/temperature
	var/atom/movable/screen/tempbase/tempover

/atom/movable/screen/tempbase
	name = ""
	mouse_opacity = 0
	icon = 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature.dmi'
	icon_state = "tempbase"
	screen_loc = "WEST-1:0,CENTER+5:17"

/atom/movable/screen/temperature
	name = "Body Temperature"
	icon = 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature.dmi'
	icon_state = "tempnormal"
	screen_loc = "WEST-1:0,CENTER+5:17"
	layer = HUD_LAYER + 0.1

/atom/movable/screen/temperature
	var/ta_climate_heated_tile = FALSE

/atom/movable/screen/temperature/Click(location, control, params)
	if(!usr?.client || !ishuman(usr))
		return FALSE
	var/mob/living/carbon/human/H = usr
	if(hud?.mymob != H)
		return FALSE
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["left"])
		return ..()
	H.check_temperature_state()
	return TRUE

/mob/living/carbon/human/proc/ta_climate_update_temperature_hud()
	if(stat == DEAD || !hud_used?.temperature)
		return
	var/atom/movable/screen/temperature/T = hud_used.temperature
	if(bodytemperature < BODYTEMP_COLD_LEVEL_ONE_MAX)
		T.icon_state = "tempverycold"
	else if(bodytemperature < BODYTEMP_NORMAL_MIN)
		T.icon_state = "tempcold"
	else if(bodytemperature <= BODYTEMP_NORMAL_MAX)
		T.icon_state = "tempnormal"
	else if(bodytemperature <= BODYTEMP_HEAT_LEVEL_ONE_MAX)
		T.icon_state = "temphot"
	else
		T.icon_state = "tempveryhot"
	var/turf/open/floor/F = get_turf(src)
	var/heated = isturf(loc) && isfloorturf(F) && F.heat > 0
	if(T.ta_climate_heated_tile != heated)
		T.ta_climate_heated_tile = heated
		if(heated)
			T.add_overlay(GLOB.ta_climate_heated_floor_hud_overlay)
		else
			T.cut_overlay(GLOB.ta_climate_heated_floor_hud_overlay)

/atom/movable/screen/fullscreen/heatexhaust
	icon_state = "heat"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE + 1
	icon = 'modular_twilight_axis/icons/mob/temperature/temperature_fullscreen.dmi'

/atom/movable/screen/fullscreen/heatstroke
	icon_state = "heatstroke"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE + 1
	icon = 'modular_twilight_axis/icons/mob/temperature/temperature_fullscreen.dmi'

/atom/movable/screen/fullscreen/hypothermia
	icon_state = "hypothermia"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE + 1
	icon = 'modular_twilight_axis/icons/mob/temperature/temperature_fullscreen.dmi'

/atom/movable/screen/fullscreen/frostbite
	icon_state = "frostbite"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE + 1
	icon = 'modular_twilight_axis/icons/mob/temperature/temperature_fullscreen.dmi'

/datum/status_effect/debuff/ta_climate_freezing
	id = "ta_climate_freezing"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_climate_freezing
	effectedstats = list(STATKEY_CON = -1)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/ta_climate_freezing
	name = "Freezing"
	desc = "Сильный холод снижает выносливость организма."
	icon_state = "chilled"

/datum/status_effect/debuff/ta_climate_brittle
	id = "ta_climate_brittle_cold"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_climate_brittle
	duration = 10 SECONDS

/datum/status_effect/debuff/ta_climate_brittle/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	if(!C)
		return
	to_chat(C, span_warning("My joints stiffen as the cold hardens my frame."))
	ADD_TRAIT(C, TRAIT_CRITICAL_WEAKNESS, "ta_climate_brittle_cold")

/datum/status_effect/debuff/ta_climate_brittle/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	if(!C)
		return
	to_chat(C, span_notice("My frame loosens as warmth returns."))
	REMOVE_TRAIT(C, TRAIT_CRITICAL_WEAKNESS, "ta_climate_brittle_cold")

/atom/movable/screen/alert/status_effect/debuff/ta_climate_brittle
	name = "Brittle cold"
	desc = "My frame is so cold it's brittle!"
	icon_state = "chilled"

/datum/status_effect/debuff/ta_climate_overheat
	id = "ta_climate_overheating"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_climate_overheat
	duration = 10 SECONDS
	effectedstats = list(STATKEY_SPD = 2, STATKEY_WIL = -4)

/datum/status_effect/debuff/ta_climate_overheat/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	if(C)
		to_chat(C, span_userdanger("My core temperature rises, overheating my frame."))

/datum/status_effect/debuff/ta_climate_overheat/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	if(C)
		to_chat(C, span_userdanger("My core temperature returns to normal."))

/atom/movable/screen/alert/status_effect/debuff/ta_climate_overheat
	name = "Overheating"
	desc = "My frame is overheating!"
	icon_state = "fire"

/datum/preferences
	var/ta_climate_temperature_palette = "none"

/proc/ta_climate_temperature_icon_for_palette(palette)
	switch(palette)
		if("deuten")
			return 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature_deuten.dmi'
		if("protan")
			return 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature_protan.dmi'
		if("tritan")
			return 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature_tritan.dmi'
	return 'modular_twilight_axis/icons/mob/temperature/rogueheat_temperature.dmi'

/datum/hud/proc/ta_climate_apply_temperature_palette(datum/preferences/prefs)
	if(!temperature || !tempover)
		return
	var/selected_icon = ta_climate_temperature_icon_for_palette(prefs?.ta_climate_temperature_palette)
	temperature.icon = selected_icon
	tempover.icon = selected_icon

/client/verb/ta_climate_change_temperature_palette()
	set name = "Палитра температурного HUD"
	set category = "Preferences.Options"
	if(!prefs)
		return
	var/list/options = list("Обычная" = "none", "Дейтеранопия" = "deuten", "Протанопия" = "protan", "Тританопия" = "tritan")
	var/selection = input(src, "Выберите цветовую палитру термометра", "Температурный HUD") as null|anything in options
	if(!selection)
		return
	prefs.ta_climate_temperature_palette = options[selection]
	prefs.save_preferences()
	if(mob?.hud_used)
		mob.hud_used.ta_climate_apply_temperature_palette(prefs)
