/datum/erp_controller_kinks
	var/datum/erp_controller/controller

/datum/erp_controller_kinks/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Builds kinks UI list with partner known/unknown prefs.
/datum/erp_controller_kinks/proc/get_kinks_ui(mob/living/M, datum/erp_actor/partner)
	if(!istype(M))
		return null

	var/datum/component/kinks/K = M.ensure_kinks_component()

	var/mob/living/PM = partner?.physical
	var/datum/component/kinks/PK = null
	if(istype(PM))
		PK = PM.ensure_kinks_component()

	var/list/entries = list()

	for(var/kink_type in GLOB.available_kinks)
		var/datum/kink/KD = GLOB.available_kinks[kink_type]
		if(!KD)
			continue

		var/kink_path = KD.type
		var/self_pref = K ? K.get_pref(kink_path) : 0

		var/partner_pref = null
		var/partner_pref_known = FALSE

		if(PM && PM == M)
			partner_pref = self_pref
			partner_pref_known = TRUE
		else if(PK)
			partner_pref_known = PK.has_pref(kink_path)
			if(partner_pref_known)
				partner_pref = PK.get_pref(kink_path)

		entries += list(list(
			"type" = "[kink_path]",
			"name" = KD.name,
			"description" = KD.description,
			"category" = KD.category,
			"pref" = self_pref,
			"partner_pref" = partner_pref_known ? partner_pref : null,
			"partner_pref_known" = partner_pref_known,
		))

	return list("entries" = entries)

/// Sets kink pref on mob and saves into preferences.
/datum/erp_controller_kinks/proc/set_kink_pref(mob/living/M, kink_type, value)
	if(!istype(M))
		return FALSE

	var/kink_path = kink_type
	if(istext(kink_type))
		kink_path = text2path(kink_type)

	if(!ispath(kink_path, /datum/kink))
		return FALSE

	var/datum/component/kinks/K = M.ensure_kinks_component()
	if(!K)
		return FALSE

	K.set_pref(kink_path, value)

	var/datum/preferences/P = M.client?.prefs
	if(P)
		P.capture_erp_kinks_from_mob(M)
		P.save_preferences()

	return TRUE
