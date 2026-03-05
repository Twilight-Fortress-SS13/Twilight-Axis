/datum/erp_actor/erp_object
	parent_type = /datum/erp_actor

	var/datum/weakref/host_ref
	var/list/organ_type_overrides

/datum/erp_actor/erp_object/New(atom/host, list/organ_types = null, mob/living/effect_mob = null)
	..(host)
	if(!host || QDELETED(host))
		qdel(src)
		return

	host_ref = WEAKREF(host)

	if(islist(organ_types) && organ_types.len)
		organ_type_overrides = organ_types.Copy()

	if(effect_mob && !QDELETED(effect_mob))
		set_effect_mob(effect_mob)

/// Collects organs for an object actor based on overrides or defaults.
/datum/erp_actor/erp_object/collect_organs()
	build_organs()

/// Object actors do not use species overrides from base.
/datum/erp_actor/erp_object/collect_species_overrides()
	return

/// Builds object organs list from overrides or build_default_organs().
/datum/erp_actor/erp_object/proc/build_organs()
	var/list/to_add = organ_type_overrides
	if(!islist(to_add) || !to_add.len)
		to_add = build_default_organs()

	if(!islist(to_add) || !to_add.len)
		return

	for(var/T in to_add)
		add_erp_organ_type(T)

/// Hook: Returns default organ type list for this object actor.
/datum/erp_actor/erp_object/proc/build_default_organs()
	return null

/// Adds an ERP organ datum by path, hosted on the resolved host atom.
/datum/erp_actor/erp_object/proc/add_erp_organ_type(path)
	if(!ispath(path, /datum/erp_sex_organ))
		return

	var/atom/host = host_ref?.resolve()
	if(!host || QDELETED(host))
		return

	var/datum/erp_sex_organ/O = new path(host)
	if(!O.erp_organ_type && istype(O, /datum/erp_sex_organ/mouth))
		O.erp_organ_type = SEX_ORGAN_MOUTH
	add_organ(O)

/// Object actors signal through the effect mob (if any).
/datum/erp_actor/erp_object/get_signal_mob()
	return get_effect_mob()

/// Object actors are controlled through the effect mob (if any), falling back to base logic.
/datum/erp_actor/erp_object/get_control_mob(client/C = null)
	return get_effect_mob() || ..(C)
