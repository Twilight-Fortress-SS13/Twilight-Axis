/datum/species/gnoll/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.icon_state = "firepelt"
	C.base_pixel_x = -8
	C.pixel_x = -8
	C.base_pixel_y = -4
	C.pixel_y = -4

	var/mob/living/carbon/human/H = C
	if(istype(H))
		var/datum/preferences/P = H.client?.prefs
		if(P)
			P.validate_customizer_entries()
			P.apply_customizer_organs_to_mob(H)

		SEND_SIGNAL(H, COMSIG_ERP_ANATOMY_CHANGED)
