/*
 * Vagabond vampires retain upstream Transfix, but do not know the route to
 * the Vampire Lord's manor.
 */

/mob/living/carbon/human/proc/ta_apply_vagabond_vampire_rules()
	var/datum/component/ta_vampire_transfix_cleanup/cleanup = GetComponent(/datum/component/ta_vampire_transfix_cleanup)
	if(cleanup)
		qdel(cleanup)

	mind?.RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
	RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)

	if(!mind?.has_spell(/obj/effect/proc_holder/spell/targeted/transfix_neu) && !HasSpell(/obj/effect/proc_holder/spell/targeted/transfix_neu))
		AddSpell(new /obj/effect/proc_holder/spell/targeted/transfix_neu)

	REMOVE_TRAIT(src, TRAIT_VAMPMANSION, "clan")
