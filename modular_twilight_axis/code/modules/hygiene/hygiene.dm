#define HYGIENE_DIRT_MAX 100
#define HYGIENE_STINK_THRESHOLD 100
#define HYGIENE_STINK_RADIUS 2
#define HYGIENE_DIRTY_WATER_GAIN 2
#define HYGIENE_BUSH_GAIN 1
#define HYGIENE_CLEAN_WATER_LOSS 25
#define HYGIENE_DRY_LOSS 1
#define HYGIENE_DRY_TICK_DELAY (30 SECONDS)
#define HYGIENE_WATER_TICK_DELAY (5 SECONDS)
#define HYGIENE_STINK_TICK_DELAY (4 SECONDS)
#define HYGIENE_PERFUME_DURATION (10 MINUTES)
#define HYGIENE_DIRT_COLOR "#6f6658"

/mob/living/carbon/human
	var/hygiene_dirt = 0
	var/hygiene_lifetime_dirt = 0
	var/hygiene_next_clothing_threshold = 25
	var/hygiene_next_environment_tick = 0
	var/hygiene_was_stinking = FALSE
	var/hygiene_perfumed_until = 0
	var/hygiene_next_stink_tick = 0

/mob/living/carbon/human/proc/hygiene_clean_act(datum/source, strength)
	SIGNAL_HANDLER
	if(strength >= CLEAN_STRENGTH_BLOOD)
		hygiene_adjust_dirt(-HYGIENE_DIRT_MAX, FALSE)

/mob/living/carbon/human/proc/hygiene_get_dirt()
	if(HAS_TRAIT(src, TRAIT_DEADITE))
		return HYGIENE_STINK_THRESHOLD
	return hygiene_dirt

/mob/living/carbon/human/proc/hygiene_is_perfumed()
	return hygiene_perfumed_until > world.time

/mob/living/carbon/human/proc/hygiene_apply_perfume()
	hygiene_perfumed_until = max(hygiene_perfumed_until, world.time + HYGIENE_PERFUME_DURATION)
	remove_status_effect(/datum/status_effect/debuff/hygiene_stench)
	hygiene_clear_emitted_stench()

/mob/living/carbon/human/proc/hygiene_adjust_dirt(amount, dirty_equipment = TRUE)
	if(!amount)
		return
	var/old_dirt = hygiene_dirt
	hygiene_dirt = CLAMP(hygiene_dirt + amount, 0, HYGIENE_DIRT_MAX)
	if(amount > 0)
		hygiene_lifetime_dirt += amount
		if(dirty_equipment)
			hygiene_dirty_equipment_for_gain()
	if(old_dirt != hygiene_dirt)
		hygiene_update_stink_state()

/mob/living/carbon/human/proc/hygiene_update_stink_state()
	var/is_stinking = hygiene_get_dirt() >= HYGIENE_STINK_THRESHOLD
	if(!is_stinking && hygiene_was_stinking)
		hygiene_clear_emitted_stench()
	hygiene_was_stinking = is_stinking

/mob/living/carbon/human/proc/hygiene_process()
	if(stat == DEAD)
		return
	var/turf/current_turf = get_turf(src)
	if(istype(current_turf, /turf/open/water))
		if(world.time < hygiene_next_environment_tick)
			if(hygiene_get_dirt() >= HYGIENE_STINK_THRESHOLD)
				hygiene_emit_stench()
			return
		hygiene_next_environment_tick = world.time + HYGIENE_WATER_TICK_DELAY
		var/turf/open/water/W = current_turf
		if(W.hygiene_is_dirty_water())
			hygiene_adjust_dirt(HYGIENE_DIRTY_WATER_GAIN)
		else if(W.hygiene_is_clean_water())
			hygiene_adjust_dirt(-HYGIENE_CLEAN_WATER_LOSS, FALSE)
	else if(hygiene_dirt > 0 && world.time >= hygiene_next_environment_tick)
		hygiene_next_environment_tick = world.time + HYGIENE_DRY_TICK_DELAY
		hygiene_adjust_dirt(-HYGIENE_DRY_LOSS, FALSE)

	if(hygiene_get_dirt() >= HYGIENE_STINK_THRESHOLD)
		hygiene_emit_stench()

/mob/living/carbon/human/proc/hygiene_dirty_equipment_for_gain()
	var/list/slots = list(shoes, wear_pants, wear_armor, wear_shirt, gloves, head)
	while(hygiene_lifetime_dirt >= hygiene_next_clothing_threshold)
		var/slot_index = round(hygiene_next_clothing_threshold / 25)
		if(slot_index > length(slots))
			return
		var/obj/item/I = slots[slot_index]
		if(I)
			I.add_dirt_decal()
		hygiene_next_clothing_threshold += 25

/mob/living/carbon/human/proc/hygiene_emit_stench()
	if(world.time < hygiene_next_stink_tick)
		return
	if(hygiene_is_perfumed())
		return
	var/turf/T = get_turf(src)
	if(!T)
		return
	hygiene_next_stink_tick = world.time + HYGIENE_STINK_TICK_DELAY
	for(var/mob/living/carbon/human/H in view(HYGIENE_STINK_RADIUS, src))
		if(H == src)
			continue
		if(!hygiene_can_affect(H))
			if(H.hygiene_stench_source_is(src))
				H.remove_status_effect(/datum/status_effect/debuff/hygiene_stench)
			continue
		var/per_penalty = -1
		var/int_penalty = HAS_TRAIT(src, TRAIT_UNSEEMLY) ? -1 : 0
		if(HAS_TRAIT(H, TRAIT_NOBLE) && !HAS_TRAIT(H, TRAIT_STEELHEARTED))
			per_penalty *= 2
			int_penalty *= 2
		H.hygiene_apply_stench_from(src, per_penalty, int_penalty)

/mob/living/carbon/human/proc/hygiene_can_affect(mob/living/carbon/human/target)
	if(!target || target.stat == DEAD)
		return FALSE
	if(target.hygiene_is_perfumed())
		return FALSE
	if(HAS_TRAIT(target, TRAIT_NOSTINK) || HAS_TRAIT(target, TRAIT_NOBREATH) || HAS_TRAIT(target, TRAIT_NOMETABOLISM))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/hygiene_apply_stench_from(mob/living/carbon/human/source, per_penalty, int_penalty)
	var/datum/status_effect/debuff/hygiene_stench/current = has_status_effect(/datum/status_effect/debuff/hygiene_stench)
	var/new_strength = abs(per_penalty) + abs(int_penalty)
	if(current)
		var/mob/living/carbon/human/current_source = current.source_ref?.resolve()
		if(current_source == source || new_strength >= current.strength)
			remove_status_effect(/datum/status_effect/debuff/hygiene_stench)
		else
			return
	apply_status_effect(/datum/status_effect/debuff/hygiene_stench, source, per_penalty, int_penalty)

/mob/living/carbon/human/proc/hygiene_stench_source_is(mob/living/carbon/human/source)
	var/datum/status_effect/debuff/hygiene_stench/current = has_status_effect(/datum/status_effect/debuff/hygiene_stench)
	return current?.source_ref?.resolve() == source

/mob/living/carbon/human/proc/hygiene_clear_emitted_stench()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.hygiene_stench_source_is(src))
			H.remove_status_effect(/datum/status_effect/debuff/hygiene_stench)

/mob/living/carbon/human/proc/hygiene_examine_line(mob/user)
	if(hygiene_get_dirt() < HYGIENE_STINK_THRESHOLD || hygiene_is_perfumed())
		return null
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_NOBLE))
			return span_warning("От него воняет как из выгребной ямы!")
	if(HAS_TRAIT(src, TRAIT_UNSEEMLY))
		return span_warning("Он источает невыносимую вонь.")
	return span_warning("От него смердит.")

/datum/status_effect/debuff/hygiene_stench
	id = "hygiene_stench"
	status_type = STATUS_EFFECT_REPLACE
	duration = 15 SECONDS
	tick_interval = -1
	alert_type = null
	examine_text = "SUBJECTPRONOUN smell sickening."
	var/datum/weakref/source_ref
	var/strength = 0

/datum/status_effect/debuff/hygiene_stench/on_creation(mob/living/new_owner, mob/living/carbon/human/source, per_penalty = -1, int_penalty = 0)
	source_ref = WEAKREF(source)
	strength = abs(per_penalty) + abs(int_penalty)
	effectedstats = list(STATKEY_PER = per_penalty)
	if(int_penalty)
		effectedstats[STATKEY_INT] = int_penalty
	return ..()

/datum/component/decal/dirt
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/decal/dirt/Initialize(_icon, _icon_state, _dir, _cleanable = CLEAN_STRENGTH_BLOOD, _color = HYGIENE_DIRT_COLOR, _layer = ABOVE_OBJ_LAYER)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name))

/datum/component/decal/dirt/generate_appearance(_icon, _icon_state, _dir, _layer, _color)
	var/obj/item/I = parent
	if(!I.icon)
		return FALSE
	if(!_icon)
		_icon = 'icons/effects/blood.dmi'
	if(!_icon_state)
		_icon_state = "splatter[rand(1,6)]"
	_color ||= HYGIENE_DIRT_COLOR
	var/icon/base_icon = icon(I.icon, I.icon_state, , 1)
	base_icon.Blend(_color, ICON_ADD)
	base_icon.ColorTone(_color)
	base_icon.Blend(icon(_icon, _icon_state), ICON_MULTIPLY)
	pic = mutable_appearance(base_icon, initial(I.icon_state), _layer)
	pic.alpha = 120
	return TRUE

/datum/component/decal/dirt/proc/get_examine_name(datum/source, mob/user, list/override)
	var/atom/A = parent
	override[EXAMINE_POSITION_ARTICLE] = A.gender == PLURAL ? "some" : "a"
	if(A.GetComponent(/datum/component/decal/blood))
		override[EXAMINE_POSITION_BEFORE] = " <span class='warning'>dirty</span> <span class='bloody'>bloody</span> "
	else
		override[EXAMINE_POSITION_BEFORE] = " <span class='warning'>dirty</span> "
	return COMPONENT_EXNAME_CHANGED

/obj/item/proc/add_dirt_decal()
	AddComponent(/datum/component/decal/dirt)

/obj/item/proc/hygiene_try_dirty_from_attack(atom/target)
	if(!target)
		return
	if(GetComponent(/datum/component/decal/dirt))
		return
	if(istype(target, /obj/structure/flora/roguegrass))
		var/turf/T = get_turf(target)
		if(!istype(T, /turf/open/water))
			return
		var/turf/open/water/W = T
		if(W.hygiene_is_dirty_water())
			add_dirt_decal()
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.hygiene_get_dirt() > 0)
		add_dirt_decal()
		return
	var/turf/T = get_turf(H)
	if(!istype(T, /turf/open/water))
		return
	var/turf/open/water/W = T
	if(W.hygiene_is_dirty_water())
		add_dirt_decal()

/turf/open/water/proc/hygiene_is_dirty_water()
	return FALSE

/turf/open/water/proc/hygiene_is_clean_water()
	return wash_in && !hygiene_is_dirty_water()

/turf/open/water/proc/hygiene_entered(atom/movable/AM)
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(hygiene_is_dirty_water())
		H.hygiene_adjust_dirt(HYGIENE_DIRTY_WATER_GAIN)
	H.hygiene_next_environment_tick = world.time + HYGIENE_WATER_TICK_DELAY

/turf/open/water/sewer/hygiene_is_dirty_water()
	return TRUE

/turf/open/water/swamp/hygiene_is_dirty_water()
	return TRUE

/turf/open/water/bloody/hygiene_is_dirty_water()
	return TRUE

/turf/open/water/pond/hygiene_is_dirty_water()
	return TRUE

#undef HYGIENE_DIRT_MAX
#undef HYGIENE_STINK_THRESHOLD
#undef HYGIENE_STINK_RADIUS
#undef HYGIENE_DIRTY_WATER_GAIN
#undef HYGIENE_BUSH_GAIN
#undef HYGIENE_CLEAN_WATER_LOSS
#undef HYGIENE_DRY_LOSS
#undef HYGIENE_DRY_TICK_DELAY
#undef HYGIENE_WATER_TICK_DELAY
#undef HYGIENE_STINK_TICK_DELAY
#undef HYGIENE_PERFUME_DURATION
#undef HYGIENE_DIRT_COLOR
