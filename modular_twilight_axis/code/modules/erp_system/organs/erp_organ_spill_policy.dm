/datum/erp_organ_spill_policy

/// Returns bodyzone used for accessibility checks, derived from organ type.
/datum/erp_organ_spill_policy/proc/_organ_type_to_zone(datum/erp_sex_organ/O)
	switch(O.erp_organ_type)
		if(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS)
			return BODY_ZONE_PRECISE_GROIN
		if(SEX_ORGAN_BREASTS)
			return BODY_ZONE_CHEST
		if(SEX_ORGAN_MOUTH)
			return BODY_ZONE_PRECISE_MOUTH
	return null

/// Returns TRUE if spilling to ground is allowed for this organ in current state.
/datum/erp_organ_spill_policy/proc/can_spill_to_ground(datum/erp_sex_organ/O)
	var/mob/living/carbon/H = O.get_owner()
	if(!istype(H))
		return FALSE

	var/zone = _organ_type_to_zone(O)
	if(!zone)
		return TRUE

	return get_location_accessible(H, zone)

/// Drops reagents to ground, creating or reusing a cleanable decal.
/// This is SS13-world I/O; swap policy to support "chair/headless" behavior.
/datum/erp_organ_spill_policy/proc/drop_to_ground(datum/erp_sex_organ/O, datum/reagents/R)
	if(!R || R.total_volume <= 0)
		return

	if(!can_spill_to_ground(O))
		R.clear_reagents()
		return

	var/turf/T = get_turf(O.get_owner() || O.host)
	if(!T)
		R.clear_reagents()
		return

	var/obj/effect/decal/cleanable/coom/C = null
	for(var/obj/effect/decal/cleanable/coom/existing in T)
		C = existing
		break

	if(!C)
		C = new /obj/effect/decal/cleanable/coom(T)

	if(!C.reagents)
		C.reagents = new /datum/reagents(C.reagents_capacity)
		C.reagents.my_atom = C

	R.trans_to(C, R.total_volume, 1, TRUE, TRUE)
	R.clear_reagents()
