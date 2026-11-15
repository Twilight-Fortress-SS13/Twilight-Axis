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

/obj/item/grown/log/tree
	var/blessed = FALSE

/obj/item/grown/log/tree/proc/bless_log()
	if(blessed)
		return FALSE
	blessed = TRUE
	name = "blessed log"
	add_atom_colour("#88ffaa", FIXED_COLOUR_PRIORITY)
	add_filter("blessed_log_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))
	return TRUE

/obj/item/grown/log/tree/Destroy()
	remove_filter("blessed_log_outline")
	return ..()

/obj/item/grown/log/tree/examine(mob/user)
	. = ..()
	if(blessed)
		. += span_green("This log bears Dendor's blessing.")
