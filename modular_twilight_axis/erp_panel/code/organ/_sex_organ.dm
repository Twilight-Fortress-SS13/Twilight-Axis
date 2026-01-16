#define SEX_SENSITIVITY_MAX  	2
#define SEX_PAIN_MAX         	2
#define BREAST_SPENT_PROD_MULT 	1.5
#define PENIS_SPENT_PROD_MULT 	0.25

#define INJECT_MODE_NONE      0
#define INJECT_MODE_ORGAN     1
#define INJECT_MODE_CONTAINER 2
#define INJECT_MODE_GROUND    3

#define NYMPHO_PROD_MULT 1.25
#define BAOTIST_PROD_MULT 1.1

/datum/sex_organ
	// Link to physical organ
	var/atom/movable/organ_link
	// how sensitive organ is - multiplier to pleasure
	var/sensivity = 1
	// how painful organ is - negative multiplier to pleasure
	var/pain = 0
	// max sensitivity
	var/sensivity_max = SEX_SENSITIVITY_MAX
	// max pain
	var/pain_max = SEX_PAIN_MAX
	// object that currently this organ stuffed in
	var/datum/sex_organ/active_target = null
	// list of objects that use this organ
	var/list/datum/sex_organ/stuff_object = list()
	// type of sex organ
	var/organ_type
	// liquids
	var/datum/reagents/stored_liquid
	var/stored_liquid_max = 0
	// "псевдотаймеры" через world.time
	var/next_deflation_time = 0
	var/next_production_time = 0
	var/next_pain_decay_time = 0
	// reagent id that organ produces over time
	var/producing_reagent_id = null
	// production rate per tick
	var/producing_reagent_rate = 0
	var/pending_production = 0
	// amount of reagent that ejects by events
	var/injection_amount = 0
	// intervals
	var/production_interval = 5 SECONDS
	var/drain_interval = 5 MINUTES
	var/block_drain = FALSE
	var/production_blocked_until = 0

/datum/sex_organ/body

/datum/sex_organ/New(atom/movable/organ)
	. = ..()
	organ_link = organ

	if(!stuff_object)
		stuff_object = list()

	if(stored_liquid_max)
		stored_liquid = new(stored_liquid_max)

/datum/sex_organ/Destroy()
	next_deflation_time = 0
	next_production_time = 0
	next_pain_decay_time = 0
	return ..()

/datum/sex_organ/proc/has_storage()
	return stored_liquid && stored_liquid_max > 0

/datum/sex_organ/proc/total_volume()
	if(!stored_liquid)
		return 0
	return stored_liquid.total_volume

/datum/sex_organ/proc/add_reagent(datum/reagent/reagent_object, amount)
	if(!has_storage() || amount <= 0 || !reagent_object)
		return 0
	var/added = stored_liquid.add_reagent(reagent_object.type, amount)
	if(added > 0)
		renew_timer(drain_interval)
	return added

/datum/sex_organ/proc/drain_uniform(amount)
	if(!has_storage() || amount <= 0)
		return 0

	var/total = total_volume()
	if(total <= 0)
		return 0

	var/factor = min(1, amount / total)
	var/removed = 0
	var/list/L = stored_liquid.reagent_list.Copy()

	for(var/datum/reagent/reagent_object in L)
		var/take = reagent_object.volume * factor
		if(take > 0)
			removed += stored_liquid.remove_reagent(reagent_object.type, take)

	return removed

/datum/sex_organ/proc/can_receive_liquid(amount = 1)
	if(!has_storage())
		return FALSE

	if(total_volume() >= stored_liquid_max)
		return FALSE

	if(amount <= 0)
		return TRUE

	return (total_volume() + amount) <= stored_liquid_max

/datum/sex_organ/proc/renew_timer(time)
	if(!has_storage())
		return FALSE

	next_deflation_time = world.time + time
	return TRUE

/datum/sex_organ/proc/start_production_timer()
	if(!has_storage())
		return FALSE
	if(!producing_reagent_id || producing_reagent_rate <= 0)
		return FALSE

	if(world.time < production_blocked_until)
		return FALSE

	if(!next_production_time)
		next_production_time = world.time + production_interval

	return TRUE

/datum/sex_organ/proc/on_production_tick()
	if(world.time < production_blocked_until)
		next_production_time = world.time + production_interval
		return

	if(!has_storage())
		next_production_time = 0
		return

	if(!producing_reagent_id || producing_reagent_rate <= 0)
		next_production_time = 0
		return

	var/produced = 0

	if(total_volume() < stored_liquid_max)
		produced = produce_liquid(null, producing_reagent_rate)

	if(produced > 0)
		var/mob/living/carbon/human/human_object = get_owner()
		if(istype(human_object))
			var/datum/component/arousal/arousal_object = human_object.GetComponent(/datum/component/arousal)
			if(arousal_object)
				arousal_object.on_sex_organ_produced(src, produced)

	next_production_time = world.time + production_interval

/datum/sex_organ/proc/block_production(time)
	production_blocked_until = max(production_blocked_until, world.time + time)

/datum/sex_organ/proc/insert_organ(datum/sex_organ/organ)
	if(!stuff_object)
		stuff_object = list()
	if(!(organ in stuff_object))
		stuff_object += organ

/datum/sex_organ/proc/remove_organ(datum/sex_organ/organ)
	if(stuff_object && (organ in stuff_object))
		stuff_object -= organ

/datum/sex_organ/proc/is_active()
	if(active_target)
		return TRUE
	if(stuff_object && length(stuff_object))
		return TRUE
	return FALSE

/datum/sex_organ/proc/bind_with(datum/sex_organ/other)
	if(active_target == other)
		return
	unbind()
	active_target = other
	if(other)
		if(!other.stuff_object)
			other.stuff_object = list()
		if(!(src in other.stuff_object))
			other.stuff_object += src

/datum/sex_organ/proc/unbind()
	if(active_target)
		if(active_target.stuff_object && (src in active_target.stuff_object))
			active_target.stuff_object -= src
	active_target = null

/datum/sex_organ/proc/can_start_active()
	return active_target == null

/datum/sex_organ/proc/start_active(datum/sex_organ/target)
	if(!can_start_active())
		return FALSE

	active_target = target
	target.insert_organ(src)
	return TRUE

/datum/sex_organ/proc/stop_active()
	if(active_target)
		active_target.remove_organ(src)
		active_target = null

/datum/sex_organ/proc/reset_after_sleep()
	pain = 0

/datum/sex_organ/proc/get_owner()
	if(istype(organ_link, /obj/item/bodypart))
		var/obj/item/bodypart/bodypart_object = organ_link
		return bodypart_object.owner
	if(istype(organ_link, /obj/item/organ))
		var/obj/item/organ/organ_object = organ_link
		return organ_object.owner
	return null

/datum/sex_organ/proc/on_timer_end()
	if(block_drain)
		return
	
	if(!has_storage())
		return

	var/current = total_volume()
	if(current <= 0)
		return

	var/removed = drain_uniform(min(5, current))
	if(removed <= 0)
		return

	if(organ_type == SEX_ORGAN_VAGINA || organ_type == SEX_ORGAN_ANUS)
		var/mob/living/carbon/human/human_object = get_owner()
		if(istype(human_object))
			var/turf/turf_object = get_turf(human_object)
			if(turf_object)
				new /obj/effect/decal/cleanable/coom(turf_object)

	if(total_volume() > 0)
		renew_timer(drain_interval)

/datum/sex_organ/proc/produce_liquid(datum/reagent/reagent_object, amount)
	if(!has_storage() || amount <= 0)
		return 0

	if(!reagent_object && producing_reagent_id)
		reagent_object = GLOB.chemical_reagents_list[producing_reagent_id]
	if(!reagent_object)
		return 0

	var/mult = get_production_multiplier()
	if(mult <= 0)
		return 0

	amount *= mult
	pending_production += amount

	if(pending_production < SEX_MIN_REAGENT_QUANT)
		return 0

	var/to_add = pending_production
	var/added = stored_liquid.add_reagent(reagent_object.type, to_add)

	if(added > 0)
		pending_production = max(0, pending_production - added)
		renew_timer(drain_interval)

	return added

/datum/sex_organ/proc/is_valid_liquid_container(obj/item/item_object)
	if(!item_object)
		return FALSE

	if(istype(item_object, /obj/item/reagent_containers))
		return TRUE

	if(item_object.reagents)
		return TRUE

	return FALSE

/datum/sex_organ/proc/find_liquid_container(mob/living/carbon/human/preferred_holder = null, list/blocked_containers = list())
	if(preferred_holder)
		var/obj/item/item_object = preferred_holder.get_active_held_item()
		if(item_object && is_valid_liquid_container(item_object) && !(item_object in blocked_containers))
			return item_object

		item_object = preferred_holder.get_inactive_held_item()
		if(item_object && is_valid_liquid_container(item_object) && !(item_object in blocked_containers))
			return item_object

		for(var/obj/item/item_object_holder in preferred_holder.contents)
			if(is_valid_liquid_container(item_object_holder) && !(item_object_holder in blocked_containers))
				return item_object_holder

	var/mob/living/carbon/human/human_object = get_owner()
	if(!human_object)
		return null

	if(human_object.held_items)
		for(var/obj/item/container_object in human_object.held_items)
			if(is_valid_liquid_container(container_object) && !(container_object in blocked_containers))
				return container_object

	var/turf/turf_object = get_turf(human_object)
	if(turf_object)
		for(var/obj/item/liquid_container in turf_object)
			if(is_valid_liquid_container(liquid_container) && !(liquid_container in blocked_containers))
				return liquid_container

	if(turf_object)
		for(var/dir in list(NORTH, SOUTH, EAST, WEST))
			var/turf/check_turf = get_step(turf_object, dir)
			if(!check_turf) continue
			for(var/obj/item/result_item in check_turf)
				if(is_valid_liquid_container(result_item) && !(result_item in blocked_containers))
					return result_item

	return null

/datum/sex_organ/proc/inject_liquid(obj/item/container = null, mob/living/carbon/human/preferred_holder = null, list/blocked_containers = list())
	if(block_drain)
		return 0
	
	if(!has_storage() || total_volume() <= 0)
		return 0

	var/amount = injection_amount
	if(!amount || amount <= 0)
		amount = 5

	var/moved = 0
	var/mode = INJECT_MODE_NONE

	if(active_target && active_target.has_storage())
		if(active_target.can_receive_liquid(amount))
			moved = stored_liquid.trans_to(active_target.stored_liquid, amount)
			if(moved > 0)
				block_production(10 SECONDS)
				active_target.renew_timer(drain_interval)
				mode = INJECT_MODE_ORGAN
				on_after_inject(mode, moved, get_owner(), active_target, null, null)
				return moved

	if(container && is_valid_liquid_container(container) && !(container in blocked_containers))
		moved = stored_liquid.trans_to(container.reagents, amount)
		if(moved > 0)
			block_production(10 SECONDS)
			mode = INJECT_MODE_CONTAINER
			on_after_inject(mode, moved, get_owner(), active_target, container, null)
			return moved

	var/obj/item/user_cont = find_liquid_container(preferred_holder, blocked_containers)
	if(user_cont && is_valid_liquid_container(user_cont) && !(user_cont in blocked_containers))
		moved = stored_liquid.trans_to(user_cont.reagents, amount)
		if(moved > 0)
			block_production(10 SECONDS)
			mode = INJECT_MODE_CONTAINER
			on_after_inject(mode, moved, get_owner(), active_target, user_cont, null)
			return moved

	var/mob/living/carbon/human/human_object = get_owner()
	var/turf/turf_object = human_object ? get_turf(human_object) : (organ_link ? get_turf(organ_link) : null)
	if(turf_object)
		if(organ_type == SEX_ORGAN_PENIS)
			new /obj/effect/decal/cleanable/coom(turf_object)
		if(organ_type == SEX_ORGAN_BREASTS)
			new /obj/effect/decal/cleanable/coom/milk(turf_object)
		moved = drain_uniform(amount)
		if(moved > 0)
			block_production(10 SECONDS)
			mode = INJECT_MODE_GROUND
			on_after_inject(mode, moved, human_object, active_target, null, turf_object)
			return moved

	moved = drain_uniform(amount)
	if(moved > 0)
		block_production(10 SECONDS)
		on_after_inject(mode, moved, human_object, active_target, null, turf_object)
	return moved

/datum/sex_organ/proc/on_after_inject(mode, moved, mob/living/carbon/human/owner, datum/sex_organ/target_org, obj/item/container, turf/T, context)
	if(moved <= 0)
		return

	if(mode == INJECT_MODE_ORGAN && target_org)
		var/mob/living/carbon/human/target = target_org.get_owner()

		if(target && target_org.organ_type == SEX_ORGAN_MOUTH)
			var/datum/reagents/reagent_object = stored_liquid
			if(reagent_object && reagent_object.total_volume)
				target.reagents.add_reagent(producing_reagent_id, moved)

	return

/datum/sex_organ/proc/get_arousal_data()
	var/mob/living/carbon/human/H = get_owner()	
	if(!H || !ismob(H))
		return null

	var/list/data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, data)
	if(!length(data))
		return null

	return data

/datum/sex_organ/proc/get_production_multiplier()
	var/mult = 1.0

	var/mob/living/carbon/human/H = get_owner()
	if(istype(H))
		if(organ_type == SEX_ORGAN_PENIS)
			if(H.has_flaw(/datum/charflaw/addiction/lovefiend))
				mult *= NYMPHO_PROD_MULT
			if(istype(H.patron, /datum/patron/inhumen/baotha))
				mult *= BAOTIST_PROD_MULT

	var/list/ad = get_arousal_data()
	if(ad && ad["is_spent"])
		switch(organ_type)
			if(SEX_ORGAN_PENIS)
				mult *= PENIS_SPENT_PROD_MULT
			if(SEX_ORGAN_BREASTS)
				mult *= BREAST_SPENT_PROD_MULT

	return mult

/datum/sex_organ/proc/wash_out(max_amount = 0)
	if(block_drain)
		return 0
	
	if(!has_storage())
		return 0

	var/current = total_volume()
	if(current <= 0)
		return 0

	var/amount = max_amount > 0 ? min(max_amount, current) : current

	var/removed = drain_uniform(amount)
	if(removed <= 0)
		return 0

	return removed

/datum/sex_organ/proc/set_pain(new_pain, reset_timer = FALSE)
	pain = clamp(new_pain, 0, pain_max)

	if(reset_timer)
		start_pain_decay_timer()

	return pain

/datum/sex_organ/proc/adjust_pain(delta)
	if(!delta)
		return pain
	return set_pain(pain + delta)

/datum/sex_organ/proc/start_pain_decay_timer()
	next_pain_decay_time = world.time + 5 MINUTES

/datum/sex_organ/proc/pain_decay_tick()
	if(QDELETED(src))
		next_pain_decay_time = 0
		return

	pain = max(0, pain - 2)

	if(pain <= 0)
		pain = 0
		next_pain_decay_time = 0
		return

	next_pain_decay_time = world.time + 5 MINUTES

/datum/sex_organ/proc/process_org()
	if(next_production_time && world.time >= next_production_time)
		on_production_tick()

	if(next_deflation_time && world.time >= next_deflation_time)
		on_timer_end()

	// спад боли
	if(next_pain_decay_time && world.time >= next_pain_decay_time)
		pain_decay_tick()

#undef SEX_SENSITIVITY_MAX
#undef SEX_PAIN_MAX
#undef BREAST_SPENT_PROD_MULT
#undef PENIS_SPENT_PROD_MULT

#undef INJECT_MODE_NONE
#undef INJECT_MODE_ORGAN
#undef INJECT_MODE_CONTAINER
#undef INJECT_MODE_GROUND

#undef NYMPHO_PROD_MULT
#undef BAOTIST_PROD_MULT
