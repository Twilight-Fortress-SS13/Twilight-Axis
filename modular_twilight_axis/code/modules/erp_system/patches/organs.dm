/obj/item/organ
	var/datum/erp_sex_organ/sex_organ

/obj/item/organ/Destroy()
	if(sex_organ)
		qdel(sex_organ)
		sex_organ = null
	return ..()

/obj/item/bodypart
	var/datum/erp_sex_organ/sex_organ

/obj/item/bodypart/Destroy()
	if(sex_organ)
		qdel(sex_organ)
		sex_organ = null
	return ..()
