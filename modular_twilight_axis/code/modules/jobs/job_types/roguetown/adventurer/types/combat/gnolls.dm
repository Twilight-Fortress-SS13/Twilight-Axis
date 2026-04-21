/proc/twilight_apply_gnoll_stat_changes(mob/living/carbon/human/H, list/stat_changes)
	if(!H || QDELETED(H))
		return
	if(!H.mind)
		return
	if(!length(stat_changes))
		return
	for(var/stat in stat_changes)
		H.change_stat(stat, stat_changes[stat])

/datum/outfit/job/roguetown/gnoll/berserker/post_equip(mob/living/carbon/human/H)
	..()
	if(!H || QDELETED(H) || !H.mind)
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(twilight_apply_gnoll_stat_changes), H, list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = -1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = -1
	)), 1)
	H.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/invisibility/gnoll)

/datum/outfit/job/roguetown/gnoll_impure/post_equip(mob/living/carbon/human/H)
	..()
	if(!H || QDELETED(H) || !H.mind)
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(twilight_apply_gnoll_stat_changes), H, list(
		STATKEY_STR = 3,
		STATKEY_PER = 0,
		STATKEY_INT = 0,
		STATKEY_CON = 0,
		STATKEY_WIL = 1,
		STATKEY_SPD = 0,
		STATKEY_LCK = 0
	)), 1)

/datum/outfit/job/roguetown/gnoll/knight/post_equip(mob/living/carbon/human/H)
	..()
	if(!H || QDELETED(H) || !H.mind)
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(twilight_apply_gnoll_stat_changes), H, list(
		STATKEY_STR = 3,
		STATKEY_PER = 0,
		STATKEY_INT = 0,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = -1,
		STATKEY_LCK = 0
	)), 1)
	H.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/invisibility/gnoll)

/datum/outfit/job/roguetown/gnoll/shaman/post_equip(mob/living/carbon/human/H)
	..()
	if(!H || QDELETED(H) || !H.mind)
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(twilight_apply_gnoll_stat_changes), H, list(
		STATKEY_STR = 2,
		STATKEY_PER = 0,
		STATKEY_INT = 0,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 0,
		STATKEY_LCK = 0
	)), 1)

/datum/outfit/job/roguetown/gnoll/templar/post_equip(mob/living/carbon/human/H)
	..()
	if(!H || QDELETED(H) || !H.mind)
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(twilight_apply_gnoll_stat_changes), H, list(
		STATKEY_STR = 2,
		STATKEY_PER = 0,
		STATKEY_INT = 0,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
		STATKEY_LCK = 0
	)), 1)
