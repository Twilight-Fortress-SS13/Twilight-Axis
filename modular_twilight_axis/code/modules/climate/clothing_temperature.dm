/mob/living/carbon/human/proc/ta_climate_extra_heat_clothing_flags(temperature)
	var/flags = 0
	if(wear_shirt && !wear_shirt.obj_broken && wear_shirt.max_heat_protection_temperature && wear_shirt.max_heat_protection_temperature >= temperature)
		flags |= ta_climate_effective_thermal_flags(wear_shirt, wear_shirt.heat_protection)
	if(wear_wrists && !wear_wrists.obj_broken && wear_wrists.max_heat_protection_temperature && wear_wrists.max_heat_protection_temperature >= temperature)
		flags |= ta_climate_effective_thermal_flags(wear_wrists, wear_wrists.heat_protection)
	if(cloak && !cloak.obj_broken && cloak.max_heat_protection_temperature && cloak.max_heat_protection_temperature >= temperature)
		flags |= ta_climate_effective_thermal_flags(cloak, cloak.heat_protection)
	if(wear_neck && !wear_neck.obj_broken && wear_neck.max_heat_protection_temperature && wear_neck.max_heat_protection_temperature >= temperature)
		flags |= ta_climate_effective_thermal_flags(wear_neck, wear_neck.heat_protection)
	return flags

/mob/living/carbon/human/proc/ta_climate_extra_cold_clothing_flags(temperature)
	var/flags = 0
	if(wear_shirt && !wear_shirt.obj_broken && wear_shirt.min_cold_protection_temperature && wear_shirt.min_cold_protection_temperature <= temperature)
		flags |= ta_climate_effective_thermal_flags(wear_shirt, wear_shirt.cold_protection)
	if(wear_wrists && !wear_wrists.obj_broken && wear_wrists.min_cold_protection_temperature && wear_wrists.min_cold_protection_temperature <= temperature)
		flags |= ta_climate_effective_thermal_flags(wear_wrists, wear_wrists.cold_protection)
	if(cloak && !cloak.obj_broken && cloak.min_cold_protection_temperature && cloak.min_cold_protection_temperature <= temperature)
		flags |= ta_climate_effective_thermal_flags(cloak, cloak.cold_protection)
	if(wear_neck && !wear_neck.obj_broken && wear_neck.min_cold_protection_temperature && wear_neck.min_cold_protection_temperature <= temperature)
		flags |= ta_climate_effective_thermal_flags(wear_neck, wear_neck.cold_protection)
	if(istype(wear_mask, /obj/item/clothing/mask/rogue/facemask/padded) && !wear_mask.obj_broken && wear_mask.wetness < 50 && (wear_mask.body_parts_covered_dynamic & FACE) && temperature >= BODYTEMP_COLD_LEVEL_ONE_MAX)
		flags |= HEAD
	return flags

/proc/ta_climate_removed_body_coverage(obj/item/I)
	if(!I)
		return 0
	return initial(I.body_parts_covered) & ~(I.body_parts_covered & I.body_parts_covered_dynamic)

/mob/living/carbon/human/proc/ta_climate_trait_thermal_flags()
	var/flags = 0
	if(HAS_TRAIT(src, TRAIT_NUDIST))
		flags |= CHEST | GROIN | ARM_LEFT | ARM_RIGHT | LEG_LEFT | LEG_RIGHT | HAND_LEFT | HAND_RIGHT | FOOT_LEFT | FOOT_RIGHT
	if(HAS_TRAIT(src, TRAIT_SHIRTLESS))
		flags |= CHEST | ARM_LEFT | ARM_RIGHT | HEAD
	if(HAS_TRAIT(src, TRAIT_INHUMEN_ANATOMY))
		flags |= FOOT_LEFT | FOOT_RIGHT | HEAD
	if(dna?.species && (DIGITIGRADE in dna.species.species_traits))
		flags |= FOOT_LEFT | FOOT_RIGHT
	return flags
