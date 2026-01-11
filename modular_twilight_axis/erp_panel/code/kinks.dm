#define KINK_PREF_DISLIKE -1
#define KINK_PREF_NEUTRAL 0
#define KINK_PREF_LIKE    1

/datum/kink
	abstract_type = /datum/kink
	var/name = "Unknown Kink"
	var/description = "No description available."
	var/category = "Общее"
	var/intensity = 1

/datum/kink/proc/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	return FALSE

/datum/kink/proc/get_effect_weight(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	return clamp(intensity, 1, 5)

#define KINK_FORCE_GENTLE_MAX SEX_FORCE_LOW
#define KINK_FORCE_ROUGH_MIN  SEX_FORCE_HIGH

/datum/kink/bondage
	name = "Связывание"
	description = "Отношение к связыванию во время интимных сцен."
	intensity = 3
	category = "Доминирование"

/datum/kink/bondage/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(!owner || !partner)
		return FALSE
	if(owner.is_kink_restrained() || partner.is_kink_restrained())
		return TRUE
	if(owner.has_kink_tag(/datum/kink/bondage) || partner.has_kink_tag(/datum/kink/bondage))
		return TRUE
	return FALSE

/datum/kink/domination
	name = "Доминирование"
	description = "Отношению к принятию решений во время интимных сцен."
	intensity = 3
	category = "Доминирование"

/datum/kink/domination/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(!owner || !partner)
		return FALSE
	if(!giving)
		return FALSE
	if(partner.is_kink_restrained())
		return TRUE
	if(partner.is_surrendering_to(owner))
		return TRUE
	if(owner.has_kink_tag(/datum/kink/domination))
		return TRUE
	return FALSE

/datum/kink/submissive
	name = "Подчинение"
	description = "Отношение к подчинению во время интимных сцен."
	intensity = 3
	category ="Подчинение"

/datum/kink/submissive/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(!owner || !partner)
		return FALSE
	if(giving)
		return FALSE
	if(owner.is_kink_restrained())
		return TRUE
	if(owner.is_surrendering_to(partner))
		return TRUE
	if(owner.has_kink_tag(/datum/kink/submissive))
		return TRUE
	return FALSE

/datum/kink/gentle
	name = "Нежность"
	description = "Отношение к нежности во время интимных сцен."
	intensity = 1
	category = "Общее"

/datum/kink/gentle/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(applied_force <= KINK_FORCE_GENTLE_MAX && applied_speed <= SEX_SPEED_LOW)
		return TRUE
	return FALSE

/datum/kink/rough
	name = "Грубость"
	description = "Отношение к грубости во время интимных сцен."
	intensity = 4
	category = "Общее"

/datum/kink/rough/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(applied_force >= KINK_FORCE_ROUGH_MIN || applied_speed >= SEX_SPEED_HIGH)
		return TRUE
	return FALSE

/datum/kink/public
	name = "Публичность"
	description = "Отношению к сексу на глазах других."
	intensity = 4
	category = "Фетиши"

/datum/kink/public/is_active_for(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(!owner)
		return FALSE
	var/turf/T = get_turf(owner)
	if(!T)
		return FALSE
	var/outside = T.outdoor_effect?.weatherproof
	if(outside)
		return TRUE
	var/list/participants = list(owner, partner)
	for(var/mob/living/carbon/human/H in view(5, owner))
		if(H in participants)
			continue
		return TRUE
	return FALSE

#undef KINK_FORCE_GENTLE_MAX
#undef KINK_FORCE_ROUGH_MIN

/obj/item/clothing/proc/get_propagade_kinks()
	if(islist(propagade_kink) && propagade_kink.len)
		return propagade_kink
	return null

/datum/component/kinks
	var/list/prefs_by_type = null

/datum/component/kinks/Initialize()
	. = ..()
	if(!islist(prefs_by_type))
		prefs_by_type = list()

/datum/component/kinks/proc/get_pref(kink_typepath)
	if(!kink_typepath)
		return 0
	if(!islist(prefs_by_type))
		prefs_by_type = list()
	var/v = prefs_by_type[kink_typepath]
	if(!isnum(v))
		return 0
	return clamp(round(v), -1, 1)

/datum/component/kinks/proc/set_pref(kink_typepath, value)
	if(!kink_typepath)
		return
	if(!islist(prefs_by_type))
		prefs_by_type = list()
	if(!isnum(value))
		value = 0
	prefs_by_type[kink_typepath] = clamp(round(value), -1, 1)

/datum/component/kinks/proc/pref_to_mult(pref)
	switch(pref)
		if(-1) return 0.5
		if(1)  return 2
	return 1

/datum/component/kinks/proc/get_arousal_multiplier(mob/living/carbon/human/owner, mob/living/carbon/human/partner, giving, applied_force, applied_speed, organ_id)
	if(!owner)
		return 1
	if(!partner || !istype(partner))
		return 1

	var/best_weight = 0
	var/best_pref = 0

	for(var/kink_type in GLOB.available_kinks)
		var/datum/kink/K = GLOB.available_kinks[kink_type]
		if(!K)
			continue
		var/pref = get_pref(K.type)
		if(!pref)
			continue
		if(!K.is_active_for(owner, partner, giving, applied_force, applied_speed, organ_id))
			continue
		var/w = K.get_effect_weight(owner, partner, giving, applied_force, applied_speed, organ_id)
		if(w > best_weight)
			best_weight = w
			best_pref = pref

	return pref_to_mult(best_pref)

/datum/sex_session_tgui/ui_data(mob/user)
	. = ..()
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		.["kinks"] = get_kink_ui_payload(H)

/datum/sex_session_tgui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return .
	if(!ui || !ui.user)
		return
	if(action != "set_kink_pref")
		return
	if(!istype(ui.user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = ui.user
	var/kink_type_txt = params["type"]
	var/value = text2num(params["value"])
	if(!kink_type_txt)
		return
	var/kink_type = text2path(kink_type_txt)
	if(!ispath(kink_type, /datum/kink))
		return
	var/datum/component/kinks/K = H.ensure_kinks_component()
	if(!K)
		return
	K.set_pref(kink_type, value)
	return TRUE

#undef KINK_PREF_DISLIKE
#undef KINK_PREF_NEUTRAL
#undef KINK_PREF_LIKE
