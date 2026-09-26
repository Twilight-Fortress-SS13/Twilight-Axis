/datum/erp_consent_resolver

/// Returns mob to ask consent from for a target atom.
/datum/erp_consent_resolver/proc/get_consent_mob_for_target(atom/target_atom)
	if(!target_atom || QDELETED(target_atom))
		return null

	if(ishuman(target_atom))
		return target_atom

	if(istype(target_atom, /obj/item/bodypart/head/dullahan))
		var/obj/item/bodypart/head/dullahan/H = target_atom
		if(H.original_owner && ishuman(H.original_owner))
			return H.original_owner

	if(istype(target_atom, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target_atom
		return A

	return null
