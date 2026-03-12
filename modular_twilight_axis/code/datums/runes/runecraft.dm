/obj/item/rogueweapon/huntingknife/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(.)
		return

	if(!proximity_flag)
		return

	if(istype(target, /obj/item/natural/stone))
		var/obj/item/natural/stone/stone_target = target
		try_carve_runestone(stone_target, user)

/obj/item/rogueweapon/huntingknife/proc/try_carve_runestone(obj/item/natural/stone/stone_target, mob/living/user)
	if(!stone_target || !user)
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

	var/datum/rune/rune_preview = new rune_path
	var/list/ingredients = rune_preview.carve_ingredients

	var/turf/stone_turf = get_turf(stone_target)
	if(!stone_turf)
		qdel(rune_preview)
		return FALSE

	if(!has_carve_ingredients_on_turf(stone_turf, ingredients))
		to_chat(user, span_warning("You lack the required ingredients to carve [rune_preview.name]."))
		to_chat(user, span_notice("[build_carve_ingredient_text(ingredients)]"))
		qdel(rune_preview)
		return FALSE

	to_chat(user, span_notice("You begin carving [rune_preview.name] into the stone..."))

	if(!do_after(user, 1 SECONDS, stone_target))
		qdel(rune_preview)
		return FALSE

	if(QDELETED(stone_target))
		qdel(rune_preview)
		return FALSE

	stone_turf = get_turf(stone_target)
	if(!stone_turf)
		qdel(rune_preview)
		return FALSE

	if(!has_carve_ingredients_on_turf(stone_turf, ingredients))
		to_chat(user, span_warning("The required ingredients are no longer nearby."))
		qdel(rune_preview)
		return FALSE

	consume_carve_ingredients_on_turf(stone_turf, ingredients)

	new /obj/item/runestone(drop_location(), rune_path)
	qdel(stone_target)

	to_chat(user, span_notice("You carve a runestone."))
	qdel(rune_preview)
	return TRUE

/obj/item/rogueweapon/huntingknife/proc/has_carve_ingredients_on_turf(turf/source_turf, list/ingredients)
	if(!source_turf)
		return FALSE

	if(!islist(ingredients) || !length(ingredients))
		return TRUE

	for(var/ingredient_type as anything in ingredients)
		var/needed_amount = ingredients[ingredient_type]
		if(!isnum(needed_amount) || needed_amount <= 0)
			continue

		var/found_amount = 0
		for(var/obj/item/found_item in source_turf)
			if(istype(found_item, ingredient_type))
				found_amount++
				if(found_amount >= needed_amount)
					break

		if(found_amount < needed_amount)
			return FALSE

	return TRUE

/obj/item/rogueweapon/huntingknife/proc/consume_carve_ingredients_on_turf(turf/source_turf, list/ingredients)
	if(!source_turf)
		return FALSE

	if(!islist(ingredients) || !length(ingredients))
		return TRUE

	for(var/ingredient_type as anything in ingredients)
		var/needed_amount = ingredients[ingredient_type]
		if(!isnum(needed_amount) || needed_amount <= 0)
			continue

		var/remaining_amount = needed_amount
		for(var/obj/item/found_item in source_turf)
			if(!istype(found_item, ingredient_type))
				continue

			qdel(found_item)
			remaining_amount--

			if(remaining_amount <= 0)
				break

	return TRUE

/obj/item/rogueweapon/huntingknife/proc/build_carve_ingredient_text(list/ingredients)
	if(!islist(ingredients) || !length(ingredients))
		return "No additional ingredients are required."

	var/list/parts = list()

	for(var/ingredient_type as anything in ingredients)
		var/needed_amount = ingredients[ingredient_type]
		if(!isnum(needed_amount) || needed_amount <= 0)
			continue

		var/atom/movable/temp = new ingredient_type
		parts += "[needed_amount]x [initial(temp.name)]"
		qdel(temp)

	return "Required: [english_list(parts)]."

/obj/item/rogueweapon/huntingknife/proc/get_available_rune_choices(mob/living/user)
	var/list/runes = list()

	if(HAS_TRAIT(user, TRAIT_RUNECARVER))
		merge_rune_category_list(runes, RUNE_LIST_LOW)

	if(HAS_TRAIT(user, TRAIT_RUNEMAKER))
		merge_rune_category_list(runes, RUNE_LIST_LOW)
		merge_rune_category_list(runes, RUNE_LIST_BASIC)

	if(HAS_TRAIT(user, TRAIT_RUNEMASTER))
		merge_rune_category_list(runes, RUNE_LIST_LOW)
		merge_rune_category_list(runes, RUNE_LIST_BASIC)
		merge_rune_category_list(runes, RUNE_LIST_MASTER)

	return runes

/obj/item/rogueweapon/huntingknife/proc/merge_rune_category_list(list/target, list/source)
	if(!islist(target) || !islist(source))
		return

	for(var/category in source)
		if(!(category in target))
			target[category] = list()

		target[category] |= source[category]

/datum/species/dwarf
	inherent_traits = list(TRAIT_DRUNK_HEALING, TRAIT_CAVEDWELLER, TRAIT_RUNECARVER)

/datum/advclass/witch
	traits_applied = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ALCHEMY_EXPERT, TRAIT_RUNEMAKER)
