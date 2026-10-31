GLOBAL_LIST_EMPTY(ta_climate_damp_clothing)
GLOBAL_LIST_EMPTY(ta_climate_all_clothing)

/obj/item/clothing
    var/ta_climate_metal_heat = 0
    var/ta_climate_mixed_material = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine
    ta_climate_mixed_material = TRUE

/obj/item/clothing/proc/ta_climate_has_metal()
    if(material_category == ARMOR_MAT_PLATE || material_category == ARMOR_MAT_CHAINMAIL)
        return TRUE
    return ispath(smeltresult, /obj/item/ingot)

/obj/item/clothing/proc/ta_climate_is_mixed_material()
    return ta_climate_mixed_material || (sewrepair && ta_climate_has_metal())

/obj/item/clothing/proc/ta_climate_is_metal()
    return ta_climate_has_metal() && !ta_climate_is_mixed_material()

/obj/item/clothing/proc/ta_climate_rain_gain(amount)
    if(ta_climate_is_metal())
        return 0
    if(ta_climate_is_mixed_material())
        return max(1, round(amount * 0.6))
    return amount

/obj/item/clothing/proc/ta_climate_update_metal_heat()
    if(!ta_climate_has_metal())
        ta_climate_metal_heat = 0
        return
    var/turf/T = get_turf(src)
    if(!T)
        return
    var/ambient = T.temperature
    if(ishuman(loc))
        var/mob/living/carbon/human/H = loc
        ambient += H.ta_climate_ambient_temperature_offset(T)
    if(ambient >= 303.15)
        var/heat_gain = clamp(2 + (ambient - 303.15) / 6, 2, 8)
        ta_climate_metal_heat = min(100, ta_climate_metal_heat + heat_gain)
    else
        ta_climate_metal_heat = max(0, ta_climate_metal_heat - 8)

SUBSYSTEM_DEF(ta_clothing_wetness)
    name = "Clothing Wetness"
    flags = SS_BACKGROUND
    wait = 10 SECONDS
    runlevels = RUNLEVEL_GAME
    var/phase = 0
    var/list/check_queue = list()
    var/list/process_queue = list()

/datum/controller/subsystem/ta_clothing_wetness/fire(resumed = FALSE)
    if(phase == 0)
        check_queue = GLOB.ta_climate_all_clothing.Copy()
        phase = 1
    if(phase == 1)
        var/datum/particle_weather/weather = SSParticleWeather?.runningWeather
        var/rain_amount = 0
        if(weather?.running && weather.severity > 0 && !weather.ta_climate_winding_down)
            if(istype(weather, /datum/particle_weather/hurricane))
                rain_amount = 10
            else if(istype(weather, /datum/particle_weather/rain_storm) || istype(weather, /datum/particle_weather/blood_rain_storm))
                rain_amount = 7
            else if(istype(weather, /datum/particle_weather/rain_gentle) || istype(weather, /datum/particle_weather/blood_rain_gentle))
                rain_amount = 3
        while(length(check_queue))
            var/obj/item/clothing/C = check_queue[length(check_queue)]
            check_queue.len--
            if(!C || QDELETED(C))
                GLOB.ta_climate_all_clothing -= C
                GLOB.ta_climate_damp_clothing -= C
                continue
            if(C.ta_climate_is_metal())
                C.ta_climate_set_wetness(0)
                C.ta_climate_update_metal_heat()
                if(MC_TICK_CHECK)
                    return
                continue
            if(C.ta_climate_has_metal())
                C.ta_climate_update_metal_heat()
            if(C.wetness > 0 || C.wetness < 0)
                C.ta_climate_set_wetness(C.wetness)
            if(isturf(C.loc))
                if(!C.ta_climate_soak_from_turf() && rain_amount && ta_climate_valid_outdoors(C.loc))
                    C.ta_climate_set_wetness(C.wetness + C.ta_climate_rain_gain(rain_amount))
            if(MC_TICK_CHECK)
                return
        process_queue = GLOB.ta_climate_damp_clothing.Copy()
        phase = 2
    if(phase == 2)
        while(length(process_queue))
            var/obj/item/clothing/C = process_queue[length(process_queue)]
            process_queue.len--
            if(!C || QDELETED(C))
                GLOB.ta_climate_damp_clothing -= C
                continue
            if(C.wetness <= 0)
                GLOB.ta_climate_damp_clothing -= C
                continue
            if(C.ta_climate_soak_from_turf())
                continue
            var/turf/T = get_turf(C)
            if(!T)
                continue
            var/drying = 1
            if(isfloorturf(T))
                var/turf/open/floor/F = T
                drying += F.heat * 2
            var/ambient = T.temperature
            if(ishuman(C.loc))
                var/mob/living/carbon/human/H = C.loc
                ambient += H.ta_climate_ambient_temperature_offset(T)
                if(H.on_fire)
                    drying += 20
            if(ambient >= 303.15)
                drying += clamp(1 + round((ambient - 303.15) / 10), 1, 4)
            var/datum/particle_weather/W = SSParticleWeather?.runningWeather
            if(W?.running && W.severity > 0 && istype(W, /datum/particle_weather/heatwave) && ta_climate_valid_outdoors(T))
                drying += 3
            C.ta_climate_set_wetness(C.wetness - drying)
            if(MC_TICK_CHECK)
                return
        phase = 0

/obj/item/clothing/proc/ta_climate_register_wetness()
    GLOB.ta_climate_all_clothing |= src
    RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(ta_climate_wetness_on_moved))
    ta_climate_soak_from_turf()

/obj/item/clothing/proc/ta_climate_unregister_wetness()
    GLOB.ta_climate_all_clothing -= src
    GLOB.ta_climate_damp_clothing -= src
    UnregisterSignal(src, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/proc/ta_climate_wetness_on_moved(datum/source)
    SIGNAL_HANDLER
    ta_climate_soak_from_turf()

/obj/item/clothing/proc/ta_climate_soak_from_turf()
    if(ta_climate_is_metal())
        ta_climate_set_wetness(0)
        return FALSE
    if(!istype(loc, /turf/open/water))
        return FALSE
    var/turf/open/water/W = loc
    if(W.water_level <= 1 || W.platform_atom_count)
        return FALSE
    ta_climate_set_wetness(100)
    return TRUE

/obj/item/clothing/proc/ta_climate_dry_over_fire(obj/machinery/light/rogue/F, mob/living/user)
    if(!user || QDELETED(src) || QDELETED(F) || !F.on || F.heat_level <= 0 || loc != user || !user.CanReach(F))
        return FALSE
    if(wetness <= 0)
        to_chat(user, span_notice("[src] is already dry."))
        return TRUE
    user.visible_message(span_notice("[user] holds [src] over [F] to dry it."), span_notice("You hold [src] over [F] to dry it."))
    if(!do_after(user, 10 SECONDS, target = F))
        return TRUE
    if(QDELETED(src) || QDELETED(F) || !F.on || F.heat_level <= 0 || loc != user || !user.CanReach(F))
        return TRUE
    ta_climate_set_wetness(0)
    user.visible_message(span_notice("[user] finishes drying [src] over [F]."), span_notice("You finish drying [src] over [F]."))
    return TRUE

/obj/item/clothing/proc/ta_climate_set_wetness(amount)
    wetness = ta_climate_is_metal() ? 0 : clamp(round(amount), 0, 100)
    if(wetness > 0)
        GLOB.ta_climate_damp_clothing |= src
    else
        GLOB.ta_climate_damp_clothing -= src

/proc/ta_climate_effective_thermal_flags(obj/item/I, flags)
    if(!I)
        return 0
    if(istype(I, /obj/item/clothing))
        var/obj/item/clothing/C = I
        if(C.wetness >= 50)
            return 0
    return flags & ~ta_climate_removed_body_coverage(I)

/mob/living/carbon/human/proc/ta_climate_worn_clothing()
    var/list/items = list(head, wear_mask, wear_armor, wear_shirt, wear_pants, shoes, gloves, cloak, wear_neck, wear_wrists)
    var/list/result = list()
    for(var/obj/item/clothing/C as anything in items)
        if(istype(C, /obj/item/clothing))
            result |= C
    return result

/mob/living/carbon/human/proc/ta_climate_soak_clothing()
    for(var/obj/item/clothing/C as anything in ta_climate_worn_clothing())
        C.ta_climate_set_wetness(100)

/mob/living/carbon/human/proc/ta_climate_wetness_moved(datum/source)
    if(stat == DEAD || !istype(loc, /turf/open/water))
        return
    var/turf/open/water/W = loc
    if(W.water_level > 1 && !W.platform_atom_count)
        ta_climate_soak_clothing()

/mob/living/carbon/human
    var/ta_climate_next_rain_wetting = 0

/mob/living/carbon/human/proc/ta_climate_update_clothing_wetness(turf/T)
    if(!T || stat == DEAD)
        return
    if(istype(loc, /turf/open/water))
        var/turf/open/water/W = loc
        if(W.water_level > 1 && !W.platform_atom_count)
            ta_climate_soak_clothing()
        return
    if(world.time < ta_climate_next_rain_wetting)
        return
    ta_climate_next_rain_wetting = world.time + 10 SECONDS
    if(!isturf(loc) || !ta_climate_valid_outdoors(T) || HAS_TRAIT(src, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(src, TRAIT_WEATHER_IMMUNE))
        return
    var/datum/particle_weather/W = SSParticleWeather?.runningWeather
    if(!W?.running || W.severity <= 0 || W.ta_climate_winding_down)
        return
    var/rain_amount = 0
    if(istype(W, /datum/particle_weather/hurricane))
        rain_amount = 10
    else if(istype(W, /datum/particle_weather/rain_storm) || istype(W, /datum/particle_weather/blood_rain_storm))
        rain_amount = 7
    else if(istype(W, /datum/particle_weather/rain_gentle) || istype(W, /datum/particle_weather/blood_rain_gentle))
        rain_amount = 3
    if(!rain_amount || !W.can_weather(src))
        return
    for(var/obj/item/clothing/C as anything in ta_climate_worn_clothing())
        var/exposure = rain_amount
        var/covered = ta_climate_wet_body_coverage(C)
        if(C != cloak && istype(cloak, /obj/item/clothing))
            var/obj/item/clothing/outer_cloak = cloak
            if(covered & ta_climate_wet_body_coverage(outer_cloak))
                exposure = max(1, round(exposure * 0.5))
        if(C == wear_shirt && istype(wear_armor, /obj/item/clothing))
            var/obj/item/clothing/outer_armor = wear_armor
            if(covered & ta_climate_wet_body_coverage(outer_armor))
                exposure = max(1, round(exposure * (outer_armor.ta_climate_is_metal() ? 0.25 : 0.5)))
        C.ta_climate_set_wetness(C.wetness + C.ta_climate_rain_gain(exposure))

/mob/living/carbon/human/proc/ta_climate_metal_heating_load()
    var/list/items = ta_climate_worn_clothing()
    var/list/parts = list(HEAD, CHEST, GROIN, LEG_LEFT, LEG_RIGHT, FOOT_LEFT, FOOT_RIGHT, ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)
    var/list/weights = list(0.30, 0.15, 0.15, 0.075, 0.075, 0.025, 0.025, 0.075, 0.075, 0.025, 0.025)
    var/obj/item/clothing/cloak/tabard/outer_tabard
    if(istype(cloak, /obj/item/clothing/cloak/tabard) && !cloak.obj_broken)
        outer_tabard = cloak
    var/obj/item/clothing/suit/roguetown/armor/gambeson/under_gambeson
    if(istype(wear_shirt, /obj/item/clothing/suit/roguetown/armor/gambeson) && !wear_shirt.obj_broken && wear_shirt.wetness < 50)
        under_gambeson = wear_shirt
    var/total = 0
    for(var/index in 1 to length(parts))
        var/part_flag = parts[index]
        var/max_heat = 0
        for(var/obj/item/clothing/C as anything in items)
            if(!C.ta_climate_has_metal())
                continue
            var/part_heat = C.ta_climate_metal_heat * (C.ta_climate_is_mixed_material() ? 0.7 : 1)
            if(part_heat > max_heat && (ta_climate_wet_body_coverage(C) & part_flag))
                max_heat = part_heat
        if(!max_heat)
            continue
        var/insulation = 1
        if(outer_tabard?.overarmor && (ta_climate_wet_body_coverage(outer_tabard) & part_flag))
            insulation *= 0.45
        if(under_gambeson && (ta_climate_wet_body_coverage(under_gambeson) & part_flag))
            insulation *= 0.55
        total += weights[index] * max_heat * insulation / 100
    return clamp(total, 0, 1)

/proc/ta_climate_wet_body_coverage(obj/item/clothing/C)
    if(!C)
        return 0
    var/covered = C.body_parts_covered & C.body_parts_covered_dynamic
    if(covered & FACE)
        covered |= HEAD
    if(!initial(C.body_parts_covered))
        covered |= C.cold_protection | C.heat_protection
    return covered & (HEAD | CHEST | GROIN | LEG_LEFT | LEG_RIGHT | FOOT_LEFT | FOOT_RIGHT | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT)

/mob/living/carbon/human/proc/ta_climate_wet_clothing_load()
    var/list/items = ta_climate_worn_clothing()
    var/list/parts = list(HEAD, CHEST, GROIN, LEG_LEFT, LEG_RIGHT, FOOT_LEFT, FOOT_RIGHT, ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)
    var/list/weights = list(0.30, 0.15, 0.15, 0.075, 0.075, 0.025, 0.025, 0.075, 0.075, 0.025, 0.025)
    var/total = 0
    for(var/index in 1 to length(parts))
        var/part_flag = parts[index]
        var/maximum = 0
        for(var/obj/item/clothing/C as anything in items)
            if(C.wetness <= maximum)
                continue
            if(ta_climate_wet_body_coverage(C) & part_flag)
                maximum = C.wetness
        total += weights[index] * maximum / 100
    return clamp(total, 0, 1)

/proc/ta_climate_clothing_examine(obj/item/clothing/C)
    var/list/lines = list()
    if(C.ta_climate_has_metal())
        if(C.ta_climate_metal_heat >= 65)
            lines += span_warning("The metal is hot to the touch. A tabard and padded underarmor reduce heat transfer.")
        else if(C.ta_climate_metal_heat >= 25)
            lines += span_notice("The metal feels warm to the touch.")
    if(C.obj_broken)
        lines += span_warning("Its damaged condition compromises its insulation.")
    else if(C.wetness >= 50 && (C.cold_protection || C.heat_protection))
        lines += span_warning("Its soaked fabric no longer provides normal temperature protection.")
    else
        if(C.cold_protection && C.min_cold_protection_temperature)
            var/cold_grade = C.min_cold_protection_temperature <= 50 ? "excellent" : (C.min_cold_protection_temperature <= BODYTEMP_COLD_LEVEL_ONE_MAX ? "moderate" : "light")
            lines += span_info("Provides [cold_grade] protection against cold.")
        if(C.heat_protection && C.max_heat_protection_temperature)
            var/heat_grade = C.max_heat_protection_temperature >= 600 ? "excellent" : "moderate"
            lines += span_info("Provides [heat_grade] protection against heat.")
    if(C.wetness >= 100)
        lines += span_warning("The fabric is completely soaked (100% wet). It dangerously increases heat loss in cold weather.")
    else if(C.wetness >= 50)
        lines += span_warning("The fabric is heavily soaked ([C.wetness]% wet). It makes the cold much worse.")
    else if(C.wetness > 0)
        lines += span_notice("The fabric is slightly damp ([C.wetness]% wet).")
    return lines
