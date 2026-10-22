/datum/crafting_recipe/roguetown/structure/pig_spit
	name = "roasting spit"
	result = /obj/structure/pig_spit
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stick = 2)
	subtype_reqs = FALSE
	craftdiff = SKILL_LEVEL_NOVICE
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/pig_spit/TurfCheck(mob/user, turf/T)
	if(!..() || user.get_skill_level(/datum/skill/craft/crafting) < SKILL_LEVEL_NOVICE)
		return FALSE
	if(T != get_step(user, user.dir) || !user.CanReach(T))
		return FALSE
	if(locate(/obj/structure/pig_spit) in T)
		return FALSE
	for(var/obj/machinery/light/rogue/fire in T)
		if(istype(fire, /obj/machinery/light/rogue/hearth))
			var/obj/machinery/light/rogue/hearth/hearth = fire
			if(!hearth.attachment)
				return TRUE
		else if(istype(fire, /obj/machinery/light/rogue/campfire/densefire))
			var/obj/machinery/light/rogue/campfire/densefire/campfire = fire
			if(!campfire.attachment)
				return TRUE
	return FALSE

/obj/structure/pig_spit
	name = "roasting spit"
	desc = "A wooden spit for roasting a whole pig or boar above a hearth or greater campfire."
	icon = 'modular_twilight_axis/icons/roguetown/items/pig_spit.dmi'
	icon_state = "ony_blank"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE
	max_integrity = 80
	var/pig_on_spit = FALSE
	var/pig_cooked = FALSE
	/// Remaining lit-fire time, in deciseconds. A ready roast cannot burn.
	var/pig_cook_remaining = 0
	/// Fixed by the cook when the pig is mounted; never recalculated by a carver.
	var/pig_meat_remaining = 0
	var/carving = FALSE
	var/dismantling = FALSE

/obj/structure/pig_spit/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/pig_spit/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Build this over an empty hearth or greater campfire with Novice Crafting, one small log and two sticks. Face the hearth or campfire when starting and finishing construction. Drag a dead, unbutchered pig or boar onto it; this requires Apprentice Cooking. Better cooks mount the pig faster and shorten roasting from seven minutes to five. Roasting pauses without a burning fire. The pig on the spit never rots or burns once ready. Middle-click with a short, sharp knife to begin carving one random portion at a time. Cooking determines how much meat the carcass holds; Butchering improves the chance of a usable portion and reduces waste per cut. Drag the empty spit onto yourself to dismantle it for one small log.")

/obj/structure/pig_spit/examine(mob/user)
	. = ..()
	if(!pig_on_spit)
		. += span_notice("The spit is empty. Drag it onto yourself to dismantle it for one small log.")
	else if(pig_cooked)
		. += span_notice("The roast pig is ready: middle-click with a knife to carve it. Meat remaining: [pig_meat_remaining].")
	else
		. += span_notice("The pig needs about [ceil(pig_cook_remaining / (1 SECONDS))] more seconds over a burning fire.")
		var/obj/machinery/light/rogue/fire = get_heat_source()
		if(!fire?.on)
			. += span_warning("A burning hearth or greater campfire is needed to continue roasting.")

/obj/structure/pig_spit/update_icon()
	icon_state = pig_on_spit ? (pig_cooked ? "oni_cooked" : "oni") : "ony_blank"

/obj/structure/pig_spit/attackby(obj/item/W, mob/living/user, params)
	if(pig_on_spit && !user.cmode && W.get_sharpness() && W.wlength == WLENGTH_SHORT)
		to_chat(user, span_notice("Middle-click with the knife to carve the pig."))
		return TRUE
	// The spit covers the fire's sprite: keep lighting and refuelling accessible.
	var/obj/machinery/light/rogue/fire = get_heat_source()
	if(fire && (W.firefuel || W.get_temperature()))
		return fire.attackby(W, user, params)
	return ..()

/obj/structure/pig_spit/proc/get_heat_source()
	for(var/obj/machinery/light/rogue/fire in loc)
		if(istype(fire, /obj/machinery/light/rogue/hearth) || istype(fire, /obj/machinery/light/rogue/campfire/densefire))
			return fire
	return null

/obj/structure/pig_spit/fire_act(added, maxstacks)
	var/obj/machinery/light/rogue/fire = get_heat_source()
	return fire?.fire_act(added, maxstacks)

/obj/structure/pig_spit/spark_act()
	return fire_act()

/obj/structure/pig_spit/extinguish()
	var/obj/machinery/light/rogue/fire = get_heat_source()
	fire?.extinguish()
	return ..()

/obj/structure/pig_spit/proc/get_roast_duration(cooking_skill)
	cooking_skill = clamp(cooking_skill, SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_LEGENDARY)
	return (7 MINUTES) - (cooking_skill - SKILL_LEVEL_APPRENTICE) * (30 SECONDS)

/obj/structure/pig_spit/process(elapsed)
	if(!pig_on_spit || pig_cooked)
		return PROCESS_KILL
	var/obj/machinery/light/rogue/fire = get_heat_source()
	if(!fire?.on || (initial(fire.fueluse) > 0 && fire.fueluse <= 0))
		return
	// SSobj supplies its interval in deciseconds.
	pig_cook_remaining = max(0, pig_cook_remaining - elapsed)
	if(pig_cook_remaining > 0)
		return
	pig_cooked = TRUE
	visible_message(span_notice("The pig on [src] is roasted and ready to carve!"))
	update_icon()
	return PROCESS_KILL

/obj/structure/pig_spit/MouseDrop_T(atom/movable/dropped, mob/living/user)
	if(!istype(dropped, /mob/living/simple_animal/hostile/retaliate/rogue/trufflepig) && !istype(dropped, /mob/living/simple_animal/hostile/retaliate/rogue/boar))
		return ..()
	if(!istype(user) || user.incapacitated() || !user.CanReach(src) || !user.CanReach(dropped))
		return FALSE
	if(pig_on_spit || dismantling || !get_heat_source())
		to_chat(user, span_warning("I need an empty roasting spit on this fire."))
		return FALSE
	var/cooking_skill = user.get_skill_level(/datum/skill/craft/cooking)
	if(cooking_skill < SKILL_LEVEL_APPRENTICE)
		to_chat(user, span_warning("I need at least Apprentice cooking to mount a whole pig."))
		return FALSE
	var/mob/living/simple_animal/pig = dropped
	if(!can_roast_pig(pig))
		to_chat(user, span_warning("The pig must be dead, fresh and unbutchered."))
		return FALSE
	var/turf/pig_turf = get_turf(pig)
	var/speed = get_cooktime_divisor(cooking_skill) / get_cooktime_divisor(SKILL_LEVEL_APPRENTICE)
	user.visible_message(span_notice("[user] begins mounting [pig] on the spit."))
	if(!do_after(user, (10 SECONDS) / speed, target = src))
		return FALSE
	// Recheck both the corpse and fire: another cook may have used either during do_after.
	if(QDELETED(src) || pig_on_spit || dismantling || !get_heat_source() || !can_roast_pig(pig))
		return FALSE
	if(!user.CanReach(src) || !user.CanReach(pig) || get_turf(pig) != pig_turf)
		return FALSE
	pig_on_spit = TRUE
	pig_cooked = FALSE
	pig_cook_remaining = get_roast_duration(cooking_skill)
	pig_meat_remaining = get_carcass_meat(cooking_skill)
	START_PROCESSING(SSobj, src)
	user.visible_message(span_notice("[user] mounts [pig] on the roasting spit."))
	// Consume the corpse once mounted, so it cannot also be butchered or revived for extra meat.
	qdel(pig)
	update_icon()
	return TRUE

/obj/structure/pig_spit/proc/can_roast_pig(mob/living/simple_animal/pig)
	if(QDELETED(pig) || !isturf(pig.loc) || pig.stat != DEAD || pig.buckled)
		return FALSE
	if(istype(pig, /mob/living/simple_animal/hostile/retaliate/rogue/boar/undead))
		return FALSE
	if(!istype(pig, /mob/living/simple_animal/hostile/retaliate/rogue/trufflepig) && !istype(pig, /mob/living/simple_animal/hostile/retaliate/rogue/boar))
		return FALSE
	if(!pig.initial_butcher_count || length(pig.butcher_results) != pig.initial_butcher_count)
		return FALSE
	var/datum/component/rot/simple/rot = pig.GetComponent(/datum/component/rot/simple)
	return !rot || rot.amount < 10 MINUTES

/obj/structure/pig_spit/proc/get_carcass_meat(cooking_skill)
	return 50 + 25 * (clamp(cooking_skill, SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_LEGENDARY) - SKILL_LEVEL_APPRENTICE)

/obj/structure/pig_spit/proc/get_cut_cost(butchering_skill)
	return round(25 - 10 * clamp(butchering_skill, SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY) / SKILL_LEVEL_LEGENDARY)

/obj/structure/pig_spit/proc/get_meat_chance(butchering_skill)
	// Match the normal livestock butchering botch chance.
	if(butchering_skill >= SKILL_LEVEL_JOURNEYMAN)
		return 100
	return 30 + 20 * max(SKILL_LEVEL_NONE, butchering_skill)

/obj/structure/pig_spit/MiddleClick(mob/living/user, params)
	if(!istype(user) || user.incapacitated() || !user.CanReach(src))
		return FALSE
	var/obj/item/knife = user.get_active_held_item()
	if(!knife || !knife.get_sharpness() || knife.wlength != WLENGTH_SHORT)
		return ..()
	if(!pig_on_spit || !pig_cooked)
		to_chat(user, span_warning("There is no cooked pig ready to carve."))
		return TRUE
	return carve_pig(user, knife)

/obj/structure/pig_spit/proc/can_carve(mob/living/user, obj/item/knife)
	return !QDELETED(src) && pig_on_spit && pig_cooked && !QDELETED(user) && !user.incapacitated() && user.CanReach(src) && !QDELETED(knife) && user.get_active_held_item() == knife && knife.get_sharpness() && knife.wlength == WLENGTH_SHORT

/obj/structure/pig_spit/proc/carve_pig(mob/living/user, obj/item/knife)
	if(carving || !can_carve(user, knife))
		return FALSE
	carving = TRUE
	user.visible_message(span_notice("[user] begins carving the roast pig."))
	while(can_carve(user, knife))
		if(!do_after(user, 2 SECONDS, target = src))
			break
		if(!can_carve(user, knife))
			break
		carve_slice(user)
	if(!QDELETED(src))
		carving = FALSE
	return TRUE

/obj/structure/pig_spit/proc/carve_slice(mob/living/user)
	if(!pig_on_spit || !pig_cooked || pig_meat_remaining <= 0)
		return FALSE
	var/skill = clamp(user.get_skill_level(/datum/skill/labor/butchering), SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY)
	// Every completed cut uses up meat, including botched cuts. Interrupted actions do not.
	pig_meat_remaining = max(0, pig_meat_remaining - get_cut_cost(skill))
	if(prob(get_meat_chance(skill)))
		var/static/list/meat_types = list(
			/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried,
			/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast,
			/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed/roasted,
			/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast/ribs,
		)
		var/meat_type = pick(meat_types)
		new meat_type(get_turf(src))
		to_chat(user, span_notice("I carve off a portion of roast meat."))
	else
		to_chat(user, span_warning("I botch the cut and waste some meat."))
	playsound(src, 'sound/foley/butcher.ogg', 50, TRUE)
	if(!pig_meat_remaining)
		pig_on_spit = FALSE
		pig_cooked = FALSE
		pig_cook_remaining = 0
		STOP_PROCESSING(SSobj, src)
		user.visible_message(span_notice("[user] finishes carving the roast pig, leaving the spit empty."))
		update_icon()
	return TRUE

/obj/structure/pig_spit/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(over != usr || !isliving(usr))
		return ..()
	return dismantle_spit(usr)

/obj/structure/pig_spit/proc/dismantle_spit(mob/living/user)
	if(QDELETED(src) || dismantling || user.incapacitated() || !user.CanReach(src))
		return FALSE
	if(pig_on_spit)
		to_chat(user, span_warning("The spit must be empty before I can dismantle it."))
		return FALSE
	dismantling = TRUE
	user.visible_message(span_notice("[user] begins dismantling [src]."))
	if(!do_after(user, 3 SECONDS, target = src))
		if(!QDELETED(src))
			dismantling = FALSE
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(pig_on_spit || user.incapacitated() || !user.CanReach(src))
		dismantling = FALSE
		return FALSE
	new /obj/item/grown/log/tree/small(get_turf(src))
	user.visible_message(span_notice("[user] dismantles [src], recovering a small log."))
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast/ribs
	name = "roast pork ribs"
	desc = "Tender pork ribs, slowly roasted over an open fire."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs"
	slices_num = 0
	slice_path = null

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed/roasted
	name = "roast ham"
	desc = "A tender pork haunch roasted over an open fire."
	rotprocess = SHELFLIFE_DECENT

/obj/machinery/light/rogue/MouseDrop_T(atom/movable/dropped, mob/living/user)
	var/obj/structure/pig_spit/spit = locate() in loc
	if(spit && spit.get_heat_source() == src)
		return spit.MouseDrop_T(dropped, user)
	return ..()
