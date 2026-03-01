/datum/erp_organ_inject_router
	var/inject_organ_spill_ratio = 0.20

/// Routes reagents according to injection mode, delegating ground spill to spill policy.
/datum/erp_organ_inject_router/proc/route_reagents(datum/erp_sex_organ/source, datum/reagents/R, target_mode, target)
	if(!R || R.total_volume <= 0)
		return FALSE

	switch(target_mode)
		if(INJECT_ORGAN)
			var/datum/erp_sex_organ/target_organ = target
			if(!target_organ)
				source?.drop_to_ground(R)
				return TRUE

			var/total = R.total_volume
			var/spill_ratio = clamp(inject_organ_spill_ratio, 0, 1)
			var/spill_amt = round(total * spill_ratio)
			spill_amt = clamp(spill_amt, 0, total)
			if(spill_amt > 0 && source)
				var/datum/reagents/Rspill = new(spill_amt)
				R.trans_to(Rspill, spill_amt, 1, TRUE, TRUE)
				source.drop_to_ground(Rspill)
				qdel(Rspill)

			if(R.total_volume > 0)
				target_organ.receive_reagents(R, R.total_volume)

			return TRUE

		if(INJECT_CONTAINER)
			var/obj/item/reagent_containers/C = target
			if(C && C.reagents)
				R.trans_to(C, R.total_volume, 1, TRUE, TRUE)
				return TRUE

		if(INJECT_GROUND)
			source?.drop_to_ground(R)
			return TRUE

	source?.drop_to_ground(R)
	return TRUE
