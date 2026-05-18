#define WEAPON_DURABILITY_MULT 1.3

/obj/item/rogueweapon/Initialize()
	. = ..()
	if(!destroy_message)
		destroy_message = span_warning("\The [src] shatters!")
	if(ispath(special))
		special = new special()
	return INITIALIZE_HINT_LATELOAD

/obj/item/rogueweapon/LateInitialize()
	var/old_max_blade_int = max_blade_int

	max_integrity = round(max_integrity * WEAPON_DURABILITY_MULT)
	if(old_max_blade_int)
		max_blade_int = round(old_max_blade_int * WEAPON_DURABILITY_MULT)

	obj_integrity = round(obj_integrity * WEAPON_DURABILITY_MULT)
	if(old_max_blade_int)
		blade_int = round(blade_int * WEAPON_DURABILITY_MULT)
	if(dismember_blade_int)
		dismember_blade_int = round(dismember_blade_int * WEAPON_DURABILITY_MULT)

#undef WEAPON_DURABILITY_MULT
