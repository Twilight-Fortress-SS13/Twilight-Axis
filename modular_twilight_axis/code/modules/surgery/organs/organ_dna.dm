/datum/organ_dna/butt
	var/butt_size = DEFAULT_BUTT_SIZE

/datum/organ_dna/butt/imprint_organ(obj/item/organ/organ)
	..()
	var/obj/item/organ/butt/butt_organ = organ
	butt_organ.butt_size = butt_size

/datum/organ_dna/belly
	var/belly_size = DEFAULT_BUTT_SIZE
	var/allow_to_grow = FALSE

/datum/organ_dna/belly/imprint_organ(obj/item/organ/organ)
	..()
	var/obj/item/organ/belly/belly_organ = organ
	belly_organ.belly_size = belly_size
	belly_organ.allow_to_grow = allow_to_grow
