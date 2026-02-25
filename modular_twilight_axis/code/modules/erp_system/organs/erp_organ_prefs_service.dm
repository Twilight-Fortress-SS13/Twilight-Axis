/datum/erp_organ_prefs_service

/// Applies prefs to organ if it can resolve a mob client with prefs.
/datum/erp_organ_prefs_service/proc/apply_prefs_if_possible(datum/erp_sex_organ/O)
	var/mob/living/M = null

	if(ismob(O.host))
		M = O.host

	if(!M)
		M = O.get_owner()

	if(!M)
		return

	var/client/C = M.client
	if(!C || !C.prefs)
		return

	var/datum/preferences/P = C.prefs
	if(!islist(P.erp_organ_prefs))
		return

	var/list/prefs = P.erp_organ_prefs["[O.erp_organ_type]"]
	if(!islist(prefs))
		return

	if("sensitivity" in prefs)
		O.sensitivity = clamp(prefs["sensitivity"], 0, O.sensitivity_max)

	if("overflow" in prefs)
		O.allow_overflow_spill = !!prefs["overflow"]
