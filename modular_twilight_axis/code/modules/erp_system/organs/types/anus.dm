#define ANUS_MAX_UNITS 30

/datum/erp_sex_organ/anus
	erp_organ_type = SEX_ORGAN_ANUS
	active_arousal = 0.9
	passive_arousal = 1.2
	active_pain = 0.02
	passive_pain = 0.2

/datum/erp_sex_organ/anus/New(atom/host_atom)
	. = ..()
	storage = new(ANUS_MAX_UNITS, src)

/obj/item/bodypart/chest/Initialize()
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/erp_sex_organ/anus(src)

#undef ANUS_MAX_UNITS
