/mob/living/carbon/human/set_patron(datum/patron/new_patron)
	. = ..()
	if(. && devotion)
		devotion.patron = new_patron
	if(istype(patron, /datum/patron/inhumen/graggar) || istype(patron, /datum/patron/divine/ravox)) // TA EDIT START
		add_verb(src, /mob/living/carbon/human/proc/toggle_cleric_aoe_mode)
	if(istype(patron, /datum/patron/divine/ravox))
		add_verb(src, /mob/living/carbon/human/proc/toggle_ravox_spirit_mode)
	if(istype(patron, /datum/patron/divine/abyssor))
		add_verb(src, /mob/living/carbon/human/proc/toggle_abyssor_mossback_mode) // TA EDIT END
