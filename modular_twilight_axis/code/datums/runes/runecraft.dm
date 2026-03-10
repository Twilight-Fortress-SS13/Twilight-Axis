/obj/item/rogueweapon/huntingknife/idagger/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(.)
		return

	if(!proximity_flag)
		return

	if(istype(target, /obj/item/natural/stone))
		var/obj/item/natural/stone/stone_target = target
		try_carve_runestone(stone_target, user)

/obj/item/rogueweapon/huntingknife/idagger/proc/try_carve_runestone(obj/item/natural/stone/stone_target, mob/living/user)
	if(!stone_target)
		return FALSE

	var/list/available_runes = get_available_rune_choices(user)
	if(!length(available_runes))
		to_chat(user, span_warning("You do not know any runes to carve."))
		return FALSE

	var/chosen_category = tgui_input_list(user, "Choose a rune category.", "Rune Carving", available_runes)
	if(!chosen_category)
		return FALSE

	var/list/category_runes = available_runes[chosen_category]
	if(!length(category_runes))
		return FALSE

	var/chosen_name = tgui_input_list(user, "Choose a rune to carve.", "Rune Carving", category_runes)
	if(!chosen_name)
		return FALSE

	var/rune_path = category_runes[chosen_name]
	if(!rune_path)
		return FALSE

	new /obj/item/runestone(drop_location(), rune_path)
	qdel(stone_target)
	to_chat(user, span_notice("You carve a runestone."))
	return TRUE

/obj/item/rogueweapon/huntingknife/idagger/proc/get_available_rune_choices(mob/living/user)
	var/list/runes = list()
	if(HAS_TRAIT(user, TRAIT_RUNECARVER))
		runes |= RUNE_LIST_LOW
	
	if(HAS_TRAIT(user, TRAIT_RUNEMAKER))
		runes |= RUNE_LIST_BASIC

	// if(HAS_TRAIT(user, TRAIT_RUNEMASTER))
	// 	runes |= RUNE_LIST_MASTER

	return runes

/datum/species/dwarf
	inherent_traits = list(TRAIT_DRUNK_HEALING, TRAIT_CAVEDWELLER, TRAIT_RUNECARVER)

/datum/advclass/witch
	traits_applied = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ALCHEMY_EXPERT, TRAIT_RUNEMAKER)
