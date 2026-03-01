/datum/erp_sex_organ
	var/atom/host
	var/erp_organ_type
	var/list/datum/erp_sex_link/links = list()
	var/sensitivity = 1.0
	var/sensitivity_max = SEX_SENSITIVITY_MAX
	var/pain = 0.0
	var/pain_max = SEX_PAIN_MAX
	var/datum/erp_liquid_storage/storage
	var/datum/erp_liquid_storage/producing
	var/last_process_time = 0
	var/process_interval = 1 SECONDS
	var/last_drain_time = 0
	var/drain_interval = 5 MINUTES
	var/count_to_action = 1
	var/last_overflow_spill_time = 0
	var/overflow_spill_interval = 150 SECONDS
	var/active_arousal = 1.0
	var/passive_arousal = 1.0
	var/active_pain = 0.0
	var/passive_pain = 0.0
	var/allow_overflow_spill = FALSE

/datum/erp_sex_organ/New(atom/A)
	. = ..()
	host = A
	last_process_time = world.time
	SSerp.register_organ(src)

/datum/erp_sex_organ/Destroy()
	for(var/datum/erp_sex_link/L in links)
		qdel(L)

	SSerp.unregister_organ(src)

	links = null
	storage = null
	producing = null
	host = null

	. = ..()

/// Returns production multiplier for this organ (override in subtypes).
/datum/erp_sex_organ/proc/get_production_mult()
	return 0

/datum/erp_sex_organ/process()
	var/mob/living/carbon/H = get_owner()
	if(istype(H) && H.IsSleeping())
		if(pain > 0)
			pain = 0

	if(producing)
		if(world.time >= last_process_time + process_interval)
			last_process_time = world.time
			process_production()

	if(world.time >= last_drain_time + drain_interval)
		last_drain_time = world.time
		process_drain()

/datum/erp_sex_organ/proc/process_production()
	if(!producing || !producing.producing_reagent || producing.production_rate <= 0)
		return

	var/mult = get_production_mult()
	if(mult <= 0)
		return

	if(producing.total_volume() >= producing.capacity)
		if(allow_overflow_spill && should_spill_now() && can_spill_to_ground())
			var/amount = max(5, round(producing.production_rate * mult))
			amount = min(amount, producing.total_volume())

			if(amount > 0)
				var/datum/reagents/Rspill = producing.inject(amount)
				if(Rspill && Rspill.total_volume > 0)
					drop_to_ground(Rspill)
				else if(Rspill)
					qdel(Rspill)
		return

	var/amount = producing.production_rate * mult
	if(amount <= 0)
		return

	var/datum/reagents/R = new(amount)
	R.add_reagent(producing.producing_reagent, amount, null, 300, no_react = TRUE)
	producing.receive(R, amount, no_react = TRUE)

	R.clear_reagents()
	qdel(R)

/datum/erp_sex_organ/proc/process_drain()
	if(!storage)
		return
	if(!storage.can_drain || storage.block_drain)
		return
	if(storage.total_volume() <= 0)
		return

	storage.drain(1)

/// Receives reagents into organ storage, optionally spilling overflow.
/datum/erp_sex_organ/proc/receive_reagents(datum/reagents/R, amount)
	if(!storage || !R || amount <= 0)
		return 0

	var/overflow = storage.receive(R, amount)

	if(overflow > 0)
		if(allow_overflow_spill && should_spill_now())
			drop_to_ground(R)
		else
			R.clear_reagents()

	return amount - overflow

/// Extracts reagents from producing first, then storage.
/datum/erp_sex_organ/proc/extract_reagents(amount)
	if(amount <= 0)
		return null

	var/datum/reagents/R = new(amount)
	var/remaining = amount

	if(producing && producing.total_volume() > 0)
		var/take = min(remaining, producing.total_volume())
		var/datum/reagents/from_prod = producing.inject(take)
		if(from_prod)
			from_prod.trans_to(R, take)
			remaining -= take

	if(remaining > 0 && storage && storage.total_volume() > 0)
		var/take = min(remaining, storage.total_volume())
		var/datum/reagents/from_store = storage.inject(take)
		if(from_store)
			from_store.trans_to(R, take)
			remaining -= take

	if(R.total_volume <= 0)
		qdel(R)
		return null

	return R

/// Routes reagents according to injection mode via inject router service.
/datum/erp_sex_organ/proc/route_reagents(datum/reagents/R, target_mode, target)
	var/datum/erp_organ_inject_router/IR = SSerp.organ_inject_router
	if(IR)
		return IR.route_reagents(src, R, target_mode, target)

	if(!R || R.total_volume <= 0)
		return FALSE

	drop_to_ground(R)
	return TRUE

/// Drops reagents to ground via spill policy service.
/datum/erp_sex_organ/proc/drop_to_ground(datum/reagents/R)
	var/datum/erp_organ_spill_policy/SP = SSerp.organ_spill_policy
	if(SP)
		SP.drop_to_ground(src, R)
		return

	if(R)
		R.clear_reagents()

/// Returns owner mob for this organ, if any.
/datum/erp_sex_organ/proc/get_owner()
	if(!host)
		return null

	if(ismob(host))
		return host

	if(istype(host, /obj/item/organ))
		var/obj/item/organ/O = host
		return O.owner

	if(istype(host, /obj/item/bodypart))
		var/obj/item/bodypart/B = host
		return B.owner

	return null

/// Counts active links where this organ is the init organ.
/datum/erp_sex_organ/proc/get_active_link_count()
	var/c = 0
	for(var/datum/erp_sex_link/L in get_active_links())
		if(L.state != LINK_STATE_ACTIVE)
			continue
		if(L.init_organ == src)
			c++
	return c

/// Returns total action slots for this organ.
/datum/erp_sex_organ/proc/get_total_slots()
	return max(1, count_to_action)

/// Returns free action slots based on active links.
/datum/erp_sex_organ/proc/get_free_slots()
	return max(0, max(1, count_to_action) - get_active_link_count())

/// Returns TRUE if organ has no free slots.
/datum/erp_sex_organ/proc/is_busy()
	return get_free_slots() <= 0

/// Returns links where this organ is init organ.
/datum/erp_sex_organ/proc/get_active_links()
	var/list/out = list()
	for(var/datum/erp_sex_link/L in links)
		if(L.init_organ == src)
			out += L
	return out

/// Returns links where this organ is target organ.
/datum/erp_sex_organ/proc/get_passive_links()
	var/list/out = list()
	for(var/datum/erp_sex_link/L in links)
		if(L.target_organ == src)
			out += L
	return out

/// Returns TRUE if organ has any liquid system enabled.
/datum/erp_sex_organ/proc/has_liquid_system()
	if(storage && storage.capacity > 0)
		return TRUE
	if(producing && producing.capacity > 0)
		return TRUE
	return FALSE

/// Applies client prefs to this organ via prefs service (no-op without client/prefs).
/datum/erp_sex_organ/proc/apply_prefs_if_possible()
	var/datum/erp_organ_prefs_service/PS = SSerp.organ_prefs_service
	if(PS)
		PS.apply_prefs_if_possible(src)

/// Returns TRUE if spill cooldown allows spilling now.
/datum/erp_sex_organ/proc/should_spill_now()
	if(world.time < last_overflow_spill_time + overflow_spill_interval)
		return FALSE
	last_overflow_spill_time = world.time
	return TRUE

/// Returns TRUE if organ may spill to ground (delegated to spill policy).
/datum/erp_sex_organ/proc/can_spill_to_ground()
	var/datum/erp_organ_spill_policy/SP = SSerp.organ_spill_policy
	if(SP)
		return SP.can_spill_to_ground(src)
	return FALSE

/// Adds pain to this organ with clamp.
/datum/erp_sex_organ/proc/add_pain(pain_amt)
	pain += pain_amt / 10
	pain = clamp(pain, 0, pain_max)

/datum/erp_sex_organ/proc/on_inject(datum/erp_sex_link/link, inject_mode, target, datum/reagents/R, mob/living/carbon/human/who)
	return
