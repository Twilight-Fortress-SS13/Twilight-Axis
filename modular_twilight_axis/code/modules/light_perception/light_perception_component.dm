#define LIGHT_PERCEPTION_MIN 0
#define LIGHT_PERCEPTION_MAX 1

#define LP_CLIENT_COLOUR_PRIORITY 1.5
#define LP_VISUAL_UPDATE_EPSILON 0.01

#define LP_NORMAL_DARK_START 0.52
#define LP_DARKVISION_DARK_START 0.60
#define LP_ZIZOSIGHT_DARK_START 0.68

#define LP_NORMAL_ADAPT_TO_DARK 0.03
#define LP_NORMAL_ADAPT_TO_LIGHT 0.08

#define LP_DARKVISION_ADAPT_TO_DARK 0.06
#define LP_DARKVISION_ADAPT_TO_LIGHT 0.07

#define LP_ZIZOSIGHT_ADAPT_TO_DARK 0.08
#define LP_ZIZOSIGHT_ADAPT_TO_LIGHT 0.06

#define LP_NORMAL_TARGET_SEE_IN_DARK 3
#define LP_DARKVISION_TARGET_SEE_IN_DARK 6
#define LP_ZIZOSIGHT_TARGET_SEE_IN_DARK 15

#define LP_NORMAL_TARGET_LIGHTING_ALPHA 210
#define LP_DARKVISION_TARGET_LIGHTING_ALPHA 180
#define LP_ZIZOSIGHT_TARGET_LIGHTING_ALPHA 150

#define LP_DARK_VEIL_STRENGTH 1.10
#define LP_GLARE_STRENGTH 1.25

#define LP_LIGHTING_ANIM_TIME 2


/datum/client_colour/light_perception
	priority = LP_CLIENT_COLOUR_PRIORITY
	colour = ""

/datum/client_colour/light_perception/proc/set_from_transition(dark_veil, glare)
	dark_veil = clamp(dark_veil, 0, 1)
	glare = clamp(glare, 0, 1)

	var/list/base = get_identity_matrix()

	if(dark_veil > 0)
		base = lerp_matrix(base, get_dark_veil_matrix(), dark_veil)

	if(glare > 0)
		base = lerp_matrix(base, get_glare_matrix(), glare)

	colour = base

/datum/client_colour/light_perception/proc/lerp_matrix(list/a, list/b, t)
	t = clamp(t, 0, 1)

	var/list/out = list()
	out.len = 20

	for(var/i in 1 to 20)
		out[i] = a[i] + ((b[i] - a[i]) * t)

	return out

/datum/client_colour/light_perception/proc/get_identity_matrix()
	return list(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1,
		0, 0, 0, 0
	)

/datum/client_colour/light_perception/proc/get_dark_veil_matrix()
	return list(
		0.42, 0.00, 0.00, 0,
		0.00, 0.42, 0.00, 0,
		0.00, 0.00, 0.42, 0,
		0.00, 0.00, 0.00, 1,
		0.00, 0.00, 0.00, 0
	)

/datum/client_colour/light_perception/proc/get_glare_matrix()
	return list(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1,
		0.30, 0.30, 0.30, 0
	)


/datum/component/light_perception
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/owner

	var/current_perception = 1
	var/target_perception = 1

	var/last_visual_perception = 1
	var/last_visual_veil = 0

	var/darkvision_mode = 0

	var/obj/item/organ/eyes/cached_eyes
	var/cached_eye_base_see_in_dark = LP_NORMAL_TARGET_SEE_IN_DARK
	var/cached_eye_base_lighting_alpha = null

	var/last_applied_see_in_dark = null
	var/last_applied_lighting_alpha = null

/datum/component/light_perception/Initialize(starting_perception = 1)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	current_perception = clamp(starting_perception, LIGHT_PERCEPTION_MIN, LIGHT_PERCEPTION_MAX)
	target_perception = current_perception
	last_visual_perception = current_perception

	RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_qdel))

	owner.lp_animated_lighting = TRUE
	owner.lp_lighting_anim_time = LP_LIGHTING_ANIM_TIME

	ensure_colour_holder()
	update_darkvision_mode()
	refresh_eye_cache()
	refresh_target()
	apply_state(TRUE)
	START_PROCESSING(SSfastprocess, src)

/datum/component/light_perception/Destroy()
	STOP_PROCESSING(SSfastprocess, src)

	restore_cached_eyes()

	if(owner)
		owner.lp_animated_lighting = FALSE
		owner.remove_client_colour(/datum/client_colour/light_perception)
		owner.update_client_colour()
		owner.update_sight()

	cached_eyes = null
	owner = null
	return ..()

/datum/component/light_perception/proc/on_parent_qdel()
	SIGNAL_HANDLER
	STOP_PROCESSING(SSfastprocess, src)
	qdel(src)

/datum/component/light_perception/process(seconds_per_tick)
	if(!owner || QDELETED(owner))
		return

	if(!owner.client)
		return

	update_darkvision_mode()
	refresh_eye_cache()

	var/turf/current_turf = get_turf(owner)
	if(!current_turf)
		return

	var/current_luma = get_normalized_turf_luma(current_turf)
	target_perception = get_target_perception_from_luma(current_luma)

	var/speed = get_adaptation_speed()
	current_perception = approach(current_perception, target_perception, speed)
	current_perception = clamp(current_perception, LIGHT_PERCEPTION_MIN, LIGHT_PERCEPTION_MAX)

	var/current_visual_veil = max(get_current_dark_veil(), get_current_glare())
	if(abs(current_perception - last_visual_perception) >= LP_VISUAL_UPDATE_EPSILON || abs(current_visual_veil - last_visual_veil) >= LP_VISUAL_UPDATE_EPSILON)
		apply_state()

/datum/component/light_perception/proc/approach(current, target, delta)
	if(current < target)
		return min(current + delta, target)
	return max(current - delta, target)

/datum/component/light_perception/proc/update_darkvision_mode()
	if(HAS_TRAIT(owner, TRAIT_ZIZOSIGHT))
		darkvision_mode = 2
		return

	if(HAS_TRAIT(owner, TRAIT_DARKVISION))
		darkvision_mode = 1
		return

	darkvision_mode = 0

/datum/component/light_perception/proc/get_adaptation_speed()
	if(target_perception < current_perception)
		switch(darkvision_mode)
			if(2)
				return LP_ZIZOSIGHT_ADAPT_TO_DARK
			if(1)
				return LP_DARKVISION_ADAPT_TO_DARK
			else
				return LP_NORMAL_ADAPT_TO_DARK

	switch(darkvision_mode)
		if(2)
			return LP_ZIZOSIGHT_ADAPT_TO_LIGHT
		if(1)
			return LP_DARKVISION_ADAPT_TO_LIGHT
		else
			return LP_NORMAL_ADAPT_TO_LIGHT

/datum/component/light_perception/proc/get_target_perception()
	if(!owner)
		return 1

	var/turf/current_turf = get_turf(owner)
	if(!current_turf)
		return 1

	return get_target_perception_from_luma(get_normalized_turf_luma(current_turf))

/datum/component/light_perception/proc/get_target_perception_from_luma(luma)
	var/threshold
	switch(darkvision_mode)
		if(2)
			threshold = LP_ZIZOSIGHT_DARK_START
		if(1)
			threshold = LP_DARKVISION_DARK_START
		else
			threshold = LP_NORMAL_DARK_START

	threshold = max(threshold, 0.001)
	return clamp(luma / threshold, LIGHT_PERCEPTION_MIN, LIGHT_PERCEPTION_MAX)

/datum/component/light_perception/proc/get_dark_adaptation_progress()
	return 1 - current_perception

/datum/component/light_perception/proc/get_current_dark_veil()
	return clamp((current_perception - target_perception) * LP_DARK_VEIL_STRENGTH, 0, 1)

/datum/component/light_perception/proc/get_current_glare()
	return clamp((target_perception - current_perception) * LP_GLARE_STRENGTH, 0, 1)

/datum/component/light_perception/proc/get_normalized_turf_luma(turf/T)
	if(!T)
		return 1
	var/result = T.get_lumcount()
	return clamp(result, 0, 1)

/datum/component/light_perception/proc/ensure_colour_holder()
	if(!owner?.client)
		return null
	return owner.add_client_colour(/datum/client_colour/light_perception)

/datum/component/light_perception/proc/get_target_see_in_dark()
	switch(darkvision_mode)
		if(2)
			return LP_ZIZOSIGHT_TARGET_SEE_IN_DARK
		if(1)
			return LP_DARKVISION_TARGET_SEE_IN_DARK
		else
			return LP_NORMAL_TARGET_SEE_IN_DARK

/datum/component/light_perception/proc/get_target_lighting_alpha()
	switch(darkvision_mode)
		if(2)
			return LP_ZIZOSIGHT_TARGET_LIGHTING_ALPHA
		if(1)
			return LP_DARKVISION_TARGET_LIGHTING_ALPHA
		else
			return LP_NORMAL_TARGET_LIGHTING_ALPHA

/datum/component/light_perception/proc/restore_cached_eyes()
	if(!cached_eyes || QDELETED(cached_eyes))
		return

	cached_eyes.see_in_dark = cached_eye_base_see_in_dark
	cached_eyes.lighting_alpha = cached_eye_base_lighting_alpha

	last_applied_see_in_dark = null
	last_applied_lighting_alpha = null

	if(owner && owner.client)
		owner.update_sight()

/datum/component/light_perception/proc/refresh_eye_cache()
	var/obj/item/organ/eyes/E = owner?.getorganslot(ORGAN_SLOT_EYES)

	if(E == cached_eyes)
		return

	if(cached_eyes)
		restore_cached_eyes()

	cached_eyes = E
	if(!cached_eyes)
		cached_eye_base_see_in_dark = 3
		cached_eye_base_lighting_alpha = null
		return

	cached_eye_base_see_in_dark = cached_eyes.see_in_dark
	cached_eye_base_lighting_alpha = cached_eyes.lighting_alpha
	last_applied_see_in_dark = cached_eyes.see_in_dark
	last_applied_lighting_alpha = cached_eyes.lighting_alpha

/datum/component/light_perception/proc/apply_eye_state()
	if(!owner || !cached_eyes)
		return

	var/progress = get_dark_adaptation_progress()

	var/base_see = cached_eye_base_see_in_dark
	var/base_alpha = isnull(cached_eye_base_lighting_alpha) ? initial(owner.lighting_alpha) : cached_eye_base_lighting_alpha

	var/target_see = get_target_see_in_dark()
	var/target_alpha = get_target_lighting_alpha()

	var/new_see = round(base_see + ((target_see - base_see) * progress))
	var/new_alpha = round(base_alpha + ((target_alpha - base_alpha) * progress))

	var/changed = FALSE

	if(isnull(last_applied_see_in_dark) || new_see != last_applied_see_in_dark)
		if(cached_eyes.see_in_dark != new_see)
			cached_eyes.see_in_dark = new_see
			changed = TRUE
		last_applied_see_in_dark = new_see

	if(isnull(last_applied_lighting_alpha) || new_alpha != last_applied_lighting_alpha)
		if(cached_eyes.lighting_alpha != new_alpha)
			cached_eyes.lighting_alpha = new_alpha
			changed = TRUE
		last_applied_lighting_alpha = new_alpha

	if(changed)
		owner.update_sight()
		
/datum/component/light_perception/proc/apply_visuals()
	if(!owner || !owner.client)
		return

	var/current_dark_veil = get_current_dark_veil()
	var/current_glare = get_current_glare()
	var/current_visual_veil = max(current_dark_veil, current_glare)

	last_visual_perception = current_perception
	last_visual_veil = current_visual_veil

	var/datum/client_colour/light_perception/cc = ensure_colour_holder()
	if(!cc)
		return

	cc.set_from_transition(current_dark_veil, current_glare)
	owner.update_client_colour()

/datum/component/light_perception/proc/apply_state(force = FALSE)
	apply_eye_state()
	apply_visuals()

/datum/component/light_perception/proc/refresh_target()
	if(!owner)
		return

	update_darkvision_mode()
	target_perception = get_target_perception()

/datum/component/light_perception/proc/set_perception(value, update_now = TRUE)
	current_perception = clamp(value, LIGHT_PERCEPTION_MIN, LIGHT_PERCEPTION_MAX)
	target_perception = current_perception

	if(update_now)
		apply_state(TRUE)


/mob/living
	var/datum/component/light_perception/light_perception_component
	var/lp_animated_lighting = FALSE
	var/lp_lighting_anim_time = LP_LIGHTING_ANIM_TIME

/mob/living/Initialize()
	. = ..()
	AddComponent(/datum/component/light_perception)
	light_perception_component = GetComponent(/datum/component/light_perception)

/mob/living/Destroy()
	light_perception_component = null
	return ..()

/mob/sync_lighting_plane_alpha()
	if(hud_used)
		var/atom/movable/screen/plane_master/lighting/L = hud_used.plane_masters["[LIGHTING_PLANE]"]
		if(L)
			if(isliving(src))
				var/mob/living/LM = src
				if(LM.lp_animated_lighting)
					animate(L)
					animate(L, alpha = lighting_alpha, time = LM.lp_lighting_anim_time)
					return
			L.alpha = lighting_alpha


#undef LIGHT_PERCEPTION_MIN
#undef LIGHT_PERCEPTION_MAX

#undef LP_CLIENT_COLOUR_PRIORITY
#undef LP_VISUAL_UPDATE_EPSILON

#undef LP_NORMAL_DARK_START
#undef LP_DARKVISION_DARK_START
#undef LP_ZIZOSIGHT_DARK_START

#undef LP_NORMAL_ADAPT_TO_DARK
#undef LP_NORMAL_ADAPT_TO_LIGHT

#undef LP_DARKVISION_ADAPT_TO_DARK
#undef LP_DARKVISION_ADAPT_TO_LIGHT

#undef LP_ZIZOSIGHT_ADAPT_TO_DARK
#undef LP_ZIZOSIGHT_ADAPT_TO_LIGHT

#undef LP_NORMAL_TARGET_SEE_IN_DARK
#undef LP_DARKVISION_TARGET_SEE_IN_DARK
#undef LP_ZIZOSIGHT_TARGET_SEE_IN_DARK

#undef LP_NORMAL_TARGET_LIGHTING_ALPHA
#undef LP_DARKVISION_TARGET_LIGHTING_ALPHA
#undef LP_ZIZOSIGHT_TARGET_LIGHTING_ALPHA

#undef LP_DARK_VEIL_STRENGTH
#undef LP_GLARE_STRENGTH
#undef LP_LIGHTING_ANIM_TIME
