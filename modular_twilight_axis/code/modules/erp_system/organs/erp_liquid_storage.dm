/datum/erp_liquid_storage
	var/capacity = 0
	var/datum/reagents/reagents
	var/producing_reagent = null
	var/production_rate = 0
	var/can_drain = TRUE
	var/can_produce = TRUE
	var/block_production = FALSE
	var/block_drain = FALSE

/datum/erp_liquid_storage/New(cap = 0, datum/erp_sex_organ/parent = null)
	. = ..()
	capacity = cap
	if(capacity > 0)
		reagents = new(capacity)

/datum/erp_liquid_storage/proc/total_volume()
	return reagents ? reagents.total_volume : 0

/datum/erp_liquid_storage/proc/free_space()
	if(capacity <= 0)
		return 0
	return max(0, capacity - total_volume())

/datum/erp_liquid_storage/proc/is_full()
	return capacity > 0 && total_volume() >= capacity

/datum/erp_liquid_storage/proc/receive(datum/reagents/R, amount, no_react = TRUE)
	if(!reagents || !R || amount <= 0)
		return 0

	var/free = free_space()
	if(free <= 0)
		return amount

	var/to_take = min(amount, free)
	if(to_take <= 0)
		return amount

	R.trans_to(reagents, to_take, 1, TRUE, no_react)
	return amount - to_take

/datum/erp_liquid_storage/proc/drain(amount)
	if(!can_drain || block_drain)
		return 0
	if(!reagents || amount <= 0)
		return 0

	var/current = total_volume()
	if(current <= 0)
		return 0

	var/factor = min(1, amount / current)
	var/removed = 0

	var/list/L = reagents.reagent_list ? reagents.reagent_list.Copy() : list()
	for(var/datum/reagent/R in L)
		var/take = R.volume * factor
		if(take > 0)
			removed += reagents.remove_reagent(R.type, take)

	return removed

/datum/erp_liquid_storage/proc/inject(amount)
	if(!reagents || amount <= 0)
		return null

	var/current = total_volume()
	if(current <= 0)
		return null

	var/to_take = min(amount, current)
	var/datum/reagents/out = new(to_take)

	var/factor = to_take / current
	var/list/L = reagents.reagent_list ? reagents.reagent_list.Copy() : list()

	for(var/datum/reagent/R in L)
		var/take = R.volume * factor
		if(take > 0)
			out.add_reagent(R.type, take)
			reagents.remove_reagent(R.type, take)

	return out

/datum/erp_liquid_storage/proc/clear()
	if(reagents)
		reagents.clear_reagents()
