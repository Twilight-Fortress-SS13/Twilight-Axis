/obj/effect/proc_holder/spell/invoked/raise_undead_formation/cast(list/targets, mob/living/carbon/user)
	..()

	if(!("[user.mind.current.real_name]_faction" in user.faction))  //FUCK VVV
		user.faction |= "[user.mind.current.real_name]_faction"

	if(!locate(/obj/effect/proc_holder/spell/invoked/gravemark) in user.mind?.spell_list) //OFF VVV
		user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)

	if(!locate(/obj/effect/proc_holder/spell/invoked/minion_order) in user.mind?.spell_list)  //SPELLGRANT IN CLASS FILE
		user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)

	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton_formation"
	miracle = TRUE
	devotion_cost = 50
	cabal_affine = TRUE
	to_spawn = 2