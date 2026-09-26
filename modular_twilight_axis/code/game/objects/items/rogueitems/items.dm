/obj/item/obj_destruction(damage_flag) // Overrides item breaking logic for steel scrap.
	if (damage_flag == "acid")
		obj_destroyed = TRUE
		acid_melt()
		return TRUE
	if (damage_flag == "fire")
		obj_destroyed = TRUE
		burn()
		return TRUE
	if (ismob(loc) && !always_destroy)
		return FALSE
	obj_destroyed = TRUE
	if(src.anvilrepair)
		if(src.smeltresult == /obj/item/ingot/steel) // Change
			new /obj/item/steel_scrap(get_turf(src))
			if(prob(20))
				new /obj/item/steel_scrap(get_turf(src))
	. = ..()
