/obj/item/seeds/treesap
	name = "tree sapling"
	desc = "A small, young tree. Plant it in prepared soil and keep it watered; a great tree may follow."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "palebush_2"
	seed_identity = "tree seeds"

/obj/item/seeds/treesap/attack_turf(turf/T, mob/living/user)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a tree sapling."))
		return
	if(locate(/obj/structure/tree_sapling) in T)
		to_chat(user, span_warning("There's already a sapling growing here."))
		return
	var/obj/structure/soil/existing_soil = locate(/obj/structure/soil) in T
	if(!existing_soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I need to plant this in soil, on dirt, or on grass."))
		return
	to_chat(user, span_notice("I begin preparing the ground for the tree sapling..."))
	if(!do_after(user, get_farming_do_time(user, 15 SECONDS), target = src))
		return
	apply_farming_fatigue(user, 40)
	if(locate(/obj/structure/tree_sapling) in T)
		return
	if(!locate(/obj/structure/soil) in T)
		if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
			return
		new /obj/structure/soil(T)
	plant_tree_sapling(T, user)

/obj/item/seeds/treesap/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a tree sapling."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	if(locate(/obj/structure/tree_sapling) in get_turf(soil))
		to_chat(user, span_warning("There's already a sapling growing here."))
		return
	plant_tree_sapling(get_turf(soil), user)

/obj/item/seeds/treesap/proc/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling(T)
	to_chat(user, span_notice("I carefully plant the tree sapling and pat the soil down."))
	qdel(src)

/obj/item/seeds/treesap/pine
	name = "pine sapling"
	desc = "A small, resinous sapling. Plant it in prepared soil and it may grow into a tall pine tree."
	icon_state = "palebush_3"
	seed_identity = "pine seeds"

/obj/item/seeds/treesap/pine/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling/pine(T)
	to_chat(user, span_notice("I carefully plant the pine sapling and pat the soil down."))
	qdel(src)

/obj/item/seeds/treesap/sakura
	name = "sakura sapling"
	desc = "A small, pink-tinged sapling. Incredibly rare, and originally from distant lands Tend it faithfully and a blooming cherry tree will reward your patience."
	icon_state = "palebush_1"
	seed_identity = "sakura seeds"

/obj/item/seeds/treesap/sakura/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling/sakura(T)
	to_chat(user, span_notice("I carefully plant the sakura sapling and pat the soil down."))
	qdel(src)


/obj/item/seeds/bush
	name = "bush seed"
	desc = "A hard, thorny seed. Plant in prepared soil and keep it watered to grow a wild bush."
	icon_state = "seed"
	seed_identity = "bush seeds"

/obj/item/seeds/bush/attack_turf(turf/T, mob/living/user)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a bush sapling."))
		return
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(locate(/obj/structure/bush_sapling) in T)
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	if(!soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I need to plant this in soil, on dirt, or on grass."))
		return
	to_chat(user, span_notice("I begin mounding up earth for the bush seed..."))
	if(!do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
		return
	apply_farming_fatigue(user, 25)
	if(locate(/obj/structure/bush_sapling) in T)
		return
	if(!soil)
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
				return
			soil = new /obj/structure/soil(T)
	new /obj/structure/bush_sapling(T)
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

/obj/item/seeds/bush/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a bush sapling."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	if(locate(/obj/structure/bush_sapling) in get_turf(soil))
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	new /obj/structure/bush_sapling(get_turf(soil))
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)


/obj/item/seeds/flower
	name = "flower seeds"
	desc = "A small packet of mixed flower seeds. Click in-hand to choose which flower to grow, then plant them in the earth and water."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	seed_identity = "flower seeds"
	var/flower_sprout_type = null
	var/flower_name = null

/obj/item/seeds/flower/attack_self(mob/living/user)
	var/list/options = list(
		"Yellow flowers"        = /obj/structure/flora/ausbushes/ywflowers,
		"Blue & red flowers"    = /obj/structure/flora/ausbushes/brflowers,
		"Purple & pink flowers" = /obj/structure/flora/ausbushes/ppflowers,
		"Lavender"              = /obj/structure/flora/ausbushes/lavendergrass
	)
	var/choice = input(user, "Which flower would you like to cultivate from these seeds?", "Choose Flower") as null|anything in options
	if(isnull(choice))
		return
	flower_sprout_type = options[choice]
	flower_name = choice
	name = "[LOWER_TEXT(choice)] seeds"
	to_chat(user, span_notice("I sort the seeds to cultivate [flower_name]."))

/obj/item/seeds/flower/attack_turf(turf/T, mob/living/user)
	if(!flower_sprout_type)
		to_chat(user, span_warning("I haven't chosen what to grow yet. Use them in your hand to choose first."))
		return
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(soil)
		try_plant_seed(user, soil)
		return
	if(!isopenturf(T))
		to_chat(user, span_warning("The ground here is not suitable for planting."))
		return
	if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I should plant these in dirt or grass."))
		return
	to_chat(user, span_notice("I scatter the seeds into the ground..."))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	soil = locate(/obj/structure/soil) in T
	if(!soil)
		soil = new /obj/structure/soil(T)
	try_plant_seed(user, soil)

/obj/item/seeds/flower/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(!flower_sprout_type)
		to_chat(user, span_warning("I haven't chosen what to grow yet. Use them in your hand to choose first."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("Something is already sprouting here."))
		return
	to_chat(user, span_notice("I plant the flower seeds in \the [soil]."))
	var/obj/structure/flower_sprout/seedling = new(get_turf(soil))
	seedling.bloom_type = flower_sprout_type
	qdel(src)


/obj/item/seeds/bush/conjured
	name = "conjured bush seed"
	desc = "A bush seed called forth by the Treefather's will. It will vanish if dropped."

/obj/item/seeds/bush/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)

/obj/item/seeds/bush/conjured/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(locate(/obj/structure/bush_sapling) in T)
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	if(!soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I need to plant this in soil, on dirt, or on grass."))
		return
	to_chat(user, span_notice("I begin mounding up earth for the bush seed..."))
	if(!do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
		return
	if(locate(/obj/structure/bush_sapling) in T)
		return
	if(!soil)
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
				return
			soil = new /obj/structure/soil(T)
	new /obj/structure/bush_sapling(T)
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

/obj/item/seeds/bush/conjured/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	if(locate(/obj/structure/bush_sapling) in get_turf(soil))
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	new /obj/structure/bush_sapling(get_turf(soil))
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

/obj/item/seeds/flower/conjured
	name = "conjured flower seeds"
	desc = "Flower seeds called forth by the Treefather's will. They will vanish if dropped. Use in-hand to choose which flower to cultivate."

/obj/item/seeds/flower/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)


/obj/item/seeds/mushroom_fey
	name = "fey mushroom spore"
	desc = "A cluster of tiny pale spores that hum with strange, wild energy. They can only take root in blessed soil."
	icon_state = "seed"
	color = "#FFFFFF"
	seed_identity = "mushroom fey spores"

/obj/item/seeds/mushroom_fey/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(!soil)
		if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
			to_chat(user, span_warning("I need to plant these in a prepared soil plot."))
			return
		to_chat(user, span_notice("I begin loosening the earth for the spores..."))
		if(!do_after(user, 5 SECONDS, target = src))
			return
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			soil = new /obj/structure/soil(T)
	if(soil.blessed_time <= 0)
		to_chat(user, span_warning("The soil must be blessed for these spores to take root."))
		return
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		to_chat(user, span_warning("Something is already growing here."))
		return
	to_chat(user, span_notice("I carefully press the spores into the blessed soil..."))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(QDELETED(soil) || soil.blessed_time <= 0)
		to_chat(user, span_warning("The soil's blessing faded before I could finish planting."))
		return
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		return
	new /obj/structure/mushroom_sprout(T)
	to_chat(user, span_notice("I plant the fey mushroom spores."))
	qdel(src)

/obj/item/seeds/mushroom_fey/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.blessed_time <= 0)
		to_chat(user, span_warning("The soil must be blessed for these spores to take root."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	var/turf/T = get_turf(soil)
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		to_chat(user, span_warning("Something is already growing here."))
		return
	to_chat(user, span_notice("I carefully press the spores into the blessed soil..."))
	new /obj/structure/mushroom_sprout(T)
	qdel(src)
