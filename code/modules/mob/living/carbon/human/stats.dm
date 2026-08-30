/mob/living/carbon/human/set_patron(datum/patron/new_patron)
	. = ..()
	if(. && devotion)
		devotion.patron = new_patron
	if(istype(patron, /datum/patron/inhumen/graggar) || istype(patron, /datum/patron/divine/ravox))
		add_verb(src, /mob/living/carbon/human/proc/toggle_cleric_aoe_mode)
