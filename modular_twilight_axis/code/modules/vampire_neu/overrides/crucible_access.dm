/*
 * A personal one-use servant call belongs only to the Vampire Lord and the
 * roundstart Wretch Licker. Other vampires may still donate to the crucible.
 */

#define TA_CRUCIBLE_ROLE_BLOCKED "ta_crucible_role_blocked"

/datum/antagonist/vampire/proc/ta_configure_personal_servant_access(mob/living/carbon/human/vampire)
	if(!istype(vampire))
		return

	var/vampire_ref = REF(src)
	var/is_vampire_lord = istype(src, /datum/antagonist/vampire/lord)
	var/is_wretch_licker = vampire.job == "Wretch" && istype(vampire.mind?.picked_advclass, /datum/advclass/wretch/licker)

	if(is_vampire_lord || is_wretch_licker)
		if(GLOB.crimson_crucible_personal_servant_summons[vampire_ref] == TA_CRUCIBLE_ROLE_BLOCKED)
			GLOB.crimson_crucible_personal_servant_summons -= vampire_ref
		return

	GLOB.crimson_crucible_personal_servant_summons[vampire_ref] = TA_CRUCIBLE_ROLE_BLOCKED

#undef TA_CRUCIBLE_ROLE_BLOCKED
