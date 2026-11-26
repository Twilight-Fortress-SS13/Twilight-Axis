/datum/erp_actor_factory

/// Creates actor subtype for atom; client/effect_mob optional.
/datum/erp_actor_factory/proc/create_actor(atom/A, client/C = null, mob/living/effect_mob = null)
	if(!A || QDELETED(A))
		return null

	if(istype(A, /obj/item/bodypart/head/dullahan))
		var/obj/item/bodypart/head/dullahan/HD = A
		var/mob/living/effect = effect_mob
		if(!effect && HD.original_owner && ismob(HD.original_owner))
			effect = HD.original_owner

		var/datum/erp_actor/erp_object/dullahan_head/Act = new(A, null, effect)
		if(C)
			Act.attach_client(C)
		Act.post_init()
		return Act

	if(ishuman(A))
		var/datum/erp_actor/human/HAct = new(A)
		if(C)
			HAct.attach_client(C)
		HAct.post_init()
		return HAct

	if(ismob(A))
		var/datum/erp_actor/mob/MAct = new(A)
		if(C)
			MAct.attach_client(C)
		MAct.post_init()
		return MAct

	return null
