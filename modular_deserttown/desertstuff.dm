//drape
/obj/structure/drape/
	plane = -3

/obj/structure/drape/desert
	name = "desert drape"
	desc = "Made from durable fabric."
	icon = 'modular_deserttown/icons/drapes.dmi'
	icon_state = "desertdrape"

/datum/crafting_recipe/roguetown/structure/zybdrape
	name = "desert drape"
	result = /obj/structure/drape/desert
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1
	ignoredensity = TRUE

/obj/structure/drape/zybantine
	name = "zybantine drape"
	desc = "Made from prestigious fabric."
	icon = 'modular_deserttown/icons/drapes.dmi'
	icon_state = "zybantinedrape1"
	color = "#a3a3a3"

/obj/structure/drape/zybantine/Initialize()
	. = ..()
	icon_state = "zybantinedrape[rand(1, 2)]"

/datum/crafting_recipe/roguetown/structure/zybdrapefancy
	name = "fancy zybantine drape"
	result = /obj/structure/drape/zybantine
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 2 )
	craftdiff = 4
	ignoredensity = TRUE
	wallcraft = TRUE

//cushion
/obj/item/cushion/desert1
	name = "desert cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "desertcushion1"

/obj/item/cushion/desert2
	name = "desert cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "desertcushion2"

/obj/item/cushion/zybantine
	name = "zybantine cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "zybantinecushion"

/datum/crafting_recipe/roguetown/sewing/zybcushion1
	name = "desert cushion (yellow)"
	result = list(/obj/item/cushion/desert1)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/zybcushion2
	name = "desert cushion (grey)"
	result = list(/obj/item/cushion/desert2)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/zybcushionfancy
	name = "zybantine cushion"
	result = list(/obj/item/cushion/zybantine)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

//kegs

/// The original hierarchy for barrels and buckets is kind of messy, and I didn't want to refactor it all to have sane subtypes.


/obj/structure/fermentation_keg/sandpot
	name = "sand pot"
	desc = "A common clay pot used for storing and sometimes fermenting fluids. Favoured over wooden barrels in the desert of Zybantium due to the relative scarcity of wood."
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "sandpot1"
	open_icon_state = "sandpot_open"
	tapped_icon_state = "sandpot_tapped"
	var/ready_icon_state = "sandpot_ready"

/obj/structure/fermentation_keg/sandpot/end_brew()
	..()
	if(!heated)
		icon_state = ready_icon_state
	update_overlays()

/datum/crafting_recipe/roguetown/structure/sandpot
	name = "sand pot"
	result = /obj/structure/fermentation_keg/sandpot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 1

/obj/structure/fermentation_keg/fancypot
	name = "fancy pot"
	desc = "Decorative and Practical!"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "fancypot1"
	open_icon_state = "fancypot_open"
	tapped_icon_state = "fancypot_tapped"
	var/ready_icon_state = "fancypot_ready"

/obj/structure/fermentation_keg/fancypot/end_brew()
	..()
	if(!heated)
		icon_state = ready_icon_state
	update_overlays()

/datum/crafting_recipe/roguetown/structure/fancypot
	name = "sand pot (fancy)"
	result = /obj/structure/fermentation_keg/fancypot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 3

/obj/item/reagent_containers/glass/bucket/tinypot
	name = "tiny pot"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "tinypot1"

/datum/crafting_recipe/roguetown/structure/tinypot
	name = "small clay pot"
	result = /obj/item/reagent_containers/glass/bucket/tinypot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 2

/obj/structure/fermentation_keg/sandpot/Initialize()
	. = ..()
	icon_state = "sandpot[rand(1, 2)]"

/obj/structure/fermentation_keg/fancypot/Initialize()
	. = ..()
	icon_state = "fancypot[rand(1, 2)]"


// Subtypes for sandpots
/obj/structure/fermentation_keg/sandpot/random/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/sandpot/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/sandpot/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/sandpot/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)


// Subtypes for fancypots
/obj/structure/fermentation_keg/fancypot/random/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/fancypot/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/fancypot/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/fancypot/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)

///
/obj/machinery/light/rogue/campfire/fireplace/desert
	name = "desert fireplace"
	icon = 'modular_deserttown/icons/fireplace.dmi'
	icon_state = "fireplace1"
	base_state = "fireplace"
	fueluse = 0
	density = FALSE
	anchored = TRUE
	cookonme = FALSE

/datum/crafting_recipe/roguetown/structure/fireplace/desert
	name = "desert fireplace"
	result = /obj/machinery/light/rogue/campfire/fireplace/desert
	// reqs = list(/obj/item/grown/log/tree/small = 1,
	// 			/obj/item/natural/stoneblock = 3)
	// verbage_simple = "build"
	// verbage = "builds"
	// skillcraft = /datum/skill/craft/masonry
	// wallcraft = TRUE


///////////

/obj/structure/pillar
	name = "pillar"
	desc = ""
	icon = 'modular_deserttown/icons/sandpillar.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	pixel_x = -16
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/pillar

/obj/structure/pillar/sand1
	icon_state = "sandpillar1"

/datum/crafting_recipe/roguetown/structure/pillar/desert
	name = "sandstone pillar"
	result = /obj/structure/pillar/sand1
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "builds"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 4

/obj/structure/large_pillar
	name = "pillar"
	desc = ""
	icon = 'modular_deserttown/icons/temple_objects_tall.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER
	abstract_type = /obj/structure/large_pillar

/obj/structure/large_pillar/broken
	icon_state = "tall_pillar_1"

/obj/structure/large_pillar/broken2
	icon_state = "tall_pillar_4"

/obj/structure/large_pillar/damaged1
	icon_state = "tall_pillar_2"

/obj/structure/large_pillar/damaged2
	icon_state = "tall_pillar_3"

/obj/structure/large_pillar/normal
	icon_state = "tall_pillar_5"

/obj/structure/obelisk
	name = "ancient obelisk"
	desc = "An ancient obelisk. It has archaic inscriptions in the stone work- ancient Drakian, maybe?"
	icon = 'modular_deserttown/icons/temple_objects_verytall.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER
	pixel_x = -16
	abstract_type = /obj/structure/obelisk
	var/translation // set per instance in the map

/obj/structure/obelisk/attack_hand(mob/user)
	. = ..()
	attempt_translate(user)

/obj/structure/obelisk/proc/attempt_translate(mob/living/user)
	if(!translation)
		to_chat(user, span_notice("You find nothing decipherable on the obelisk."))
		return
	to_chat(user, span_notice("You begin studying the archaic inscriptions..."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	var/chance = clamp(20 + (user.STAINT - 10) * 6, 0, 100)
	if(prob(chance))
		to_chat(user, span_notice("Understanding dawns on you: [translation]"))
	else
		to_chat(user, span_warning("The drakian script remains indecipherable to you."))

/obj/structure/obelisk/destroyed
	desc = "An ancient obelisk. Whatever magic it once held is long since gone, damaged beyond function."
	icon_state = "obelisk_destroyed"

/obj/structure/obelisk/active
	desc = "An ancient obelisk"
	icon_state = "obelisk_short"
	var/scan_range = 3
	var/list/mob/living/carbon/human/targets = list()
	var/list/datum/beam/active_beams = list()
	var/current_beam_night = FALSE
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/obelisk/active/tall
	icon_state = "obelisk_tall"

/obj/structure/obelisk/active/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/obelisk/active/Destroy()
	STOP_PROCESSING(SSobj, src)
	clear_all_beams()
	return ..()

/obj/structure/obelisk/active/process()
	var/list/found = list()
	for(var/mob/living/carbon/human/H in view(scan_range, src))
		if(H.stat == DEAD)
			continue
		found += H

	for(var/mob/living/carbon/human/old in targets)
		if(!(old in found))
			remove_target(old)

	var/night = (GLOB.tod == "night")

	if(night != current_beam_night && length(targets))
		refresh_beam_colour(night)
	current_beam_night = night

	for(var/mob/living/carbon/human/H in found)
		if(!(H in targets))
			add_target(H, night)
		apply_obelisk_effect(H, night)

/obj/structure/obelisk/active/proc/add_target(mob/living/carbon/human/H, night)
	targets += H
	var/beam_icon_state = night ? "drainbeam" : "medbeam"
	var/datum/beam/B = src.Beam(H, icon_state = beam_icon_state, time = 35 SECONDS, max_distance = scan_range + 2)
	if(B)
		active_beams[H] = B

/obj/structure/obelisk/active/proc/remove_target(mob/living/carbon/human/H)
	targets -= H
	var/datum/beam/B = active_beams[H]
	if(B && !QDELETED(B))
		qdel(B)
	active_beams -= H

/obj/structure/obelisk/active/proc/refresh_beam_colour(night)
	var/beam_icon_state = night ? "drainbeam" : "medbeam"
	for(var/mob/living/carbon/human/H in targets)
		var/datum/beam/old_beam = active_beams[H]
		if(old_beam && !QDELETED(old_beam))
			qdel(old_beam)
		var/datum/beam/B = src.Beam(H, icon_state = beam_icon_state, time = 35 SECONDS, max_distance = scan_range + 2)
		if(B)
			active_beams[H] = B

/obj/structure/obelisk/active/proc/apply_obelisk_effect(mob/living/carbon/human/H, night)
	if(night)
		H.apply_status_effect(/datum/status_effect/buff/energy_shift/leyline_drain, 5 SECONDS)
	else
		H.apply_status_effect(/datum/status_effect/buff/energy_shift/obelisk_power, 5 SECONDS)

/obj/structure/obelisk/active/proc/clear_all_beams()
	for(var/mob/living/carbon/human/H in active_beams)
		var/datum/beam/B = active_beams[H]
		if(B && !QDELETED(B))
			qdel(B)
	active_beams.Cut()
	targets.Cut()

#define OBELISK_ENERGY_FILTER "obelisk_energy_filter"

/datum/status_effect/buff/energy_shift
	id = "energy_shift"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	var/amount = 5
	var/sign = 1
	var/outline_colour = "#3a86ff"

/datum/status_effect/buff/energy_shift/on_apply()
	owner.add_filter(OBELISK_ENERGY_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 80, "size" = 1))
	return TRUE

/datum/status_effect/buff/energy_shift/tick()
	. = ..()
	if(QDELETED(owner))
		qdel(src)
		return
	if(owner.stat == DEAD)
		return
	owner.energy_add(sign * amount)

/datum/status_effect/buff/energy_shift/on_remove()
	owner.remove_filter(OBELISK_ENERGY_FILTER)
	return ..()

#undef OBELISK_ENERGY_FILTER

/atom/movable/screen/alert/status_effect/buff/obelisk_power
	name = "Invigorated"
	desc = "The obelisk replenishes my energy."
	icon_state = "buff"

/datum/status_effect/buff/energy_shift/obelisk_power
	id = "obelisk_power"
	alert_type = /atom/movable/screen/alert/status_effect/buff/obelisk_power
	amount = 5
	sign = 1
	outline_colour = "#3a86ff"

/atom/movable/screen/alert/status_effect/debuff/leyline_drain
	name = "Drained"
	desc = "The obelisk pulls energy from my body."
	icon_state = "leyline_drain"

/datum/status_effect/buff/energy_shift/leyline_drain
	id = "leyline_drain"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/leyline_drain
	amount = 5
	sign = -1
	outline_colour = "#d62828"

/obj/structure/obelisk/tall
	icon_state = "obelisk_tall"

/obj/structure/obelisk/writing
	icon_state = "obelisk_writing"

/obj/structure/obelisk/tall/damaged
	icon_state = "obelisk_writing_damaged"

/obj/structure/ozymandias
	name = "ruined ancient statue"
	desc = "Look upon my works ye Mighty, and despair!"
	icon = 'modular_deserttown/icons/temple_objects_big.dmi'
	icon_state = "ozymandias"
	opacity = 0
	max_integrity = 20000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER

/obj/structure/ancienthead
	name = "ruined ancient statue"
	desc = "Colors fade, temples crumble, empires fall..."
	icon = 'modular_deserttown/icons/temple_objects_big.dmi'
	icon_state = "head"
	opacity = 0
	max_integrity = 20000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER

/obj/structure/dualpillar
	name = "dual pillar"
	desc = ""
	icon = 'modular_deserttown/icons/temple_objects_big.dmi'
	icon_state = "dual_pillar_1"
	opacity = 0
	max_integrity = 1000
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER
	pixel_x = -16

/obj/structure/dualpillar/type2
	icon_state = "dual_pillar_2"

/obj/structure/dualpillar/type3
	icon_state = "dual_pillar_3"

/obj/structure/dualpillar/type4
	icon_state = "dual_pillar_4"

/obj/structure/dualpillar/type5
	icon_state = "dual_pillar_5"

/obj/structure/dualpillar/type6
	icon_state = "dual_pillar_6"

/obj/structure/table/templestoneslab
	name = "stone slab"
	desc = ""
	icon = 'modular_deserttown/icons/temple_objects.dmi'
	icon_state = "slab_1"
	max_integrity = 400
	smooth = 0
	climb_offset = 10
	debris = list(/obj/item/natural/stoneblock = 1)

/obj/structure/table/templestoneslab/slab2
	icon_state = "slab_2"

/obj/structure/table/templestoneslab/slab3
	icon_state = "slab_3"

/obj/structure/table/templestoneslab/slab4
	icon_state = "slab_4"

/obj/structure/table/templestoneslab/slab5
	icon_state = "slab_5"
/*
/client/proc/admin_move_oasis()
	set name = "Move Mirage Oasis"
	set category = "-GameMaster-"
	set desc = "Force the mirage oasis to relocate to a random marker now"

	if(!GLOB.mirage_controller)
		to_chat(usr, span_warning("No mirage controller exists - has one been initialized this round?"))
		return

	if(!GLOB.mirage_markers.len)
		to_chat(usr, span_warning("No mirage markers found on this map."))
		return

	var/success = GLOB.mirage_controller.MoveOasis()
	if(success)
		message_admins("[key_name(usr)] forced the mirage oasis to relocate.")
		log_admin("[key_name(usr)] forced the mirage oasis to relocate.")
	else
		to_chat(usr, span_warning("Couldn't find a clear marker to relocate to - all candidates may be occupied."))
*/
/obj/structure/fluff/templedebris
	name = "sand pile"
	desc = "A pile of loose sand."
	icon_state = "sandpile"
	var/sandamt = 5
	icon = 'modular_deserttown/icons/temple_objects.dmi'
	climbable = FALSE
	density = FALSE
	climb_offset = 10

/obj/structure/fluff/templedebris/pillar
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_1"

/obj/structure/fluff/templedebris/pillar2
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_2"

/obj/structure/fluff/templedebris/pillar3
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_3"

/obj/structure/fluff/templedebris/pillar4
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_4"

/obj/structure/fluff/templedebris/debris
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "debris_1"

/obj/structure/fluff/templedebris/debris2
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "debris_2"

/obj/structure/fluff/templedebris/debris3
	name = "rocky debris"
	desc = "The destroyed remains of some old stone object."
	icon_state = "debris_3"

/obj/structure/fluff/templedebris/debris4
	name = "rocky debris"
	desc = "The destroyed remains of some old stone object."
	icon_state = "debris_4"

/obj/structure/fluff/templedebris/debris5
	name = "rocky debris"
	desc = "The destroyed remains of some old stone object."
	icon_state = "debris_5"

/obj/structure/fluff/templedebris/ruinedslab
	name = "cracked slab"
	desc = "A stone slab now ruined and broken."
	icon_state = "slab_6"

/obj/structure/fluff/templedebris/ruinedslab2
	name = "cracked slab"
	desc = "A stone slab now ruined and broken."
	icon_state = "slab_7"

/obj/structure/fluff/templedebris/bricks
	name = "pile of bricks"
	desc = "A some stone bricks left about."
	icon_state = "smallbricks_1"

/obj/structure/fluff/templedebris/bricks2
	name = "pile of bricks"
	desc = "A some stone bricks left about."
	icon_state = "smallbricks_2"

/obj/structure/fluff/templedebris/bricks3
	name = "pile of bricks"
	desc = "A some stone bricks left about."
	icon_state = "smallbricks_3"



////chairs

/obj/structure/chair/wood/zybantine
	name = "zybantine chair"
	icon = 'modular_deserttown/icons/chairs.dmi'
	icon_state = "zybantinechair"

/obj/structure/chair/wood/rogue/throne/zybantine
	name = "zybantine throne"
	icon_state = "zybantinethrone"
	icon = 'modular_deserttown/icons/throne.dmi'
	pixel_x = -16

/datum/crafting_recipe/roguetown/structure/chair/zyb
	name = "wooden chair"
	result = /obj/structure/chair/wood/zybantine
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry


/obj/structure/chair/sofa
	name = "old ratty sofa"
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/chair/sofa/corner
	icon_state = "sofacorner"


/obj/structure/chair/zybantine_sofa/right
	name = "zybantine sofa"
	icon_state = "zybantinesofa_right"
	icon = 'modular_deserttown/icons/chairs.dmi'
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/zybantine_sofa/left
	name = "zybantine sofa"
	icon_state = "zybantinesofa_left"
	icon = 'modular_deserttown/icons/chairs.dmi'
	buildstackamount = 1
	item_chair = null

//Sandrocks

/obj/structure/sandrock
	name = "sandrock"
	desc = "A large desert rock protuding from the ground."
	icon_state = "rock1"
	icon = 'modular_deserttown/icons/sandrock.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	pixel_x = -48
	pixel_y = -18
	layer = 4.81
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/sandrock

/obj/structure/sandrock/sandrock1
	icon_state = "sandrock1"

/obj/structure/sandrock/sandrock2
	icon_state = "sandrock2"

/obj/structure/sandrock/sandrock3
	icon_state = "sandrock3"

/obj/structure/sandrock/sandrock4
	icon_state = "sandrock4"

/obj/item/natural/rock/desert
	name = "sand rock"
	icon = 'modular_deserttown/icons/small_sandrock.dmi'
	icon_state = "sandrock1"

/obj/item/natural/rock/desert/Initialize()
	. = ..()
	icon_state = "sandrock[rand(1,2)]"


//bush

/obj/structure/flora/roguegrass/bush/desert
	name = "saigahorn"
	desc = ""
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "saigahorn1"

/obj/structure/flora/roguegrass/bush/desert/Initialize()
	. = ..()
	icon_state = "saigahorn[rand(1, 3)]"

/obj/structure/flora/roguegrass/bush/desert/decor

/obj/structure/flora/roguegrass/bush/desert/decor/Initialize()
	. = ..()
	icon_state = "saigahorn[rand(1, 3)]"
	pixel_x = 0
	pixel_y = 15

/obj/structure/flora/roguegrass/bush/desertshrub
	name = "treelet"
	desc = "A rounded bush-like tree or perhaps tree-like bush native to Zybantium. A valuable source of wood in the sparse desert."
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "bushshrub1"
	attacked_sound = 'sound/misc/woodhit.ogg'
	max_integrity = 100
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)

/obj/structure/flora/roguegrass/bush/desertshrub/Initialize()
	. = ..()
	icon_state = "bushshrub[pick(1,2)]"

/obj/structure/flora/roguegrass/bush/desertshrub/decor

/obj/structure/flora/roguegrass/bush/desertshrub/decor/Initialize()
	. = ..()
	icon_state = "bushshrub[pick(1,2)]"
	pixel_x = 1
	pixel_y = 21

/obj/structure/flora/roguetree/palm
	name = "palm tree"
	desc = "Scant, precious shade."
	icon = 'modular_deserttown/icons/bigpalm.dmi'
	icon_state = "palm1"
	stump_type = /obj/structure/flora/roguetree/stump/palm
	pixel_x = -32
	opacity = 0 //palm trees are skinny
	density = 0

/obj/structure/flora/roguetree/palm/Initialize()
	. = ..()
	icon_state = "palm[rand(1,2)]"

/obj/structure/flora/roguetree/stump/palm
	name = "tree stump"
	desc = "Shade no more."
	icon_state = "palmstump1"
	icon = 'modular_deserttown/icons/bigpalm.dmi'
	stump_type = null
	pixel_x = -32
	density = 0

/obj/structure/flora/roguetree/stump/palm/Initialize()
	. = ..()
	icon_state = "palmstump[rand(1,2)]"

/obj/structure/flora/roguegrass/bush/wall/tall/desert
	icon = 'modular_deserttown/icons/alt/foliagetall.dmi'

// /obj/structure/flora/roguegrass/bush/wall/tall/desert/Initialize()
// 	. = ..()
// 	icon_state = "tallbush[pick(1,2)]"

//Stairs

/obj/structure/stairs/desert
	name = "sand stairs"
	icon = 'modular_deserttown/icons/sandstairs.dmi'
	icon_state = "sandstairs"
	max_integrity = 600

//If we need to change the number of rooms
/obj/structure/roguemachine/vendor/inndesert
    keycontrol = "tavern"

/obj/structure/roguemachine/vendor/inndesert/Initialize()
    . = ..()

    // Add room keys with a price of 20
    for(var/X in list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv, /obj/item/roguekey/roomvi, /obj/item/roguekey/roomvii, /obj/item/roguekey/roomviii, /obj/item/roguekey/roomix))
        var/obj/P = new X(src)
        held_items[P] = list()
        held_items[P]["NAME"] = P.name
        held_items[P]["PRICE"] = 20

    // Add fancy keys with a price of 100
    for(var/Y in list(/obj/item/roguekey/fancyroomi, /obj/item/roguekey/fancyroomii, /obj/item/roguekey/fancyroomiii))
        var/obj/Q = new Y(src)
        held_items[Q] = list()
        held_items[Q]["NAME"] = Q.name
        held_items[Q]["PRICE"] = 100

    update_icon()

/obj/structure/roguemachine/vendor/desert_church_bedroomset
	keycontrol = "priest"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/desert_church_bedroomset/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/church/roomi, /obj/item/roguekey/church/roomii, /obj/item/roguekey/church/roomiii, /obj/item/roguekey/church/roomiv, /obj/item/roguekey/church/roomv))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0
//weapons

/obj/structure/fluff/walldeco/customflag/deserttown
	name = "Al-Ashur flag"


/obj/item/rogueweapon/shield/iron/zybantine
	name = "brass shield"
	desc = "A sturdy shield of Zybantium make."
	icon = 'modular_deserttown/icons/items/desertweapons32.dmi'
	icon_state = "zybshield"
	max_integrity = 250
	blade_dulling = DULLING_BASH
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	sellprice = 30
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent
	name = "\improper Staff of the Serpent"
	desc = "A mysterious golden staff shaped like a snake. You could swear its staring at you"
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "snakestaff"


// /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
// 	name = "heavy scimitar"
// 	desc = "A large zybantine sword with a single-edged blade, a crossguard and a knife-like hilt. "
// 	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
// 	icon_state = "Kmesser"

/obj/structure/fluff/traveltile/alashurentrance
	desc = "Awake from this dream. The road to Al-Ashur awaits."
	name = "To Al-Ashur"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"

// Modular Jungle Grass Properties
/obj/structure/flora/grass/jungle
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	max_integrity = 2
	blade_dulling = DULLING_CUT
	debris = list(/obj/item/natural/fibers = 1)

/obj/structure/flora/grass/jungle/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Grass, bushes, and most kinds of foliage can be sliced away by hitting them with the 'CUT', 'CHOP', or 'REND' intents on bladed weapons. Using a torch or lamptern on foliage can burn it away, as well.")
	. += span_info("Left-clicking a bush allows you to forage through it. Most common bushes are rife with thorns, fibers, and jackberries; others can hold unique herbs and flowers, perfect for alchemists and bleeding hearts alike.")
	. += span_info("Moving through foliage has a chance to attract an ambush. The farther you're away from civilization, the more dangerous that these ambushes can become. Most ambushes can be avoided by toggling the 'SNEAK' button on your HUD, before moving through the foliage.")
	. += span_info("Some structures can be used as hiding places. Toggle the 'SNEAK' button on your HUD, then click the structure to hide in it. You can stop hiding by clicking the structure again, or by moving out of it.")

/obj/structure/flora/grass/jungle/spark_act()
	fire_act()

/obj/structure/flora/grass/jungle/Initialize()
	AddComponent(/datum/component/roguegrass)
	return ..()

// Modular Jungle Bush Properties
/obj/structure/flora/junglebush
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	layer = ABOVE_ALL_MOB_LAYER
	var/res_replenish
	blade_dulling = DULLING_CUT
	max_integrity = 35
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1)
	hidingspot = TRUE
	var/mob/living/hiddenguy = null
	var/list/looty = list()
	var/bushtype

/obj/structure/flora/junglebush/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Grass, bushes, and most kinds of foliage can be sliced away by hitting them with the 'CUT', 'CHOP', or 'REND' intents on bladed weapons. Using a torch or lamptern on foliage can burn it away, as well.")
	. += span_info("Left-clicking a bush allows you to forage through it. Most common bushes are rife with thorns, fibers, and jackberries; others can hold unique herbs and flowers, perfect for alchemists and bleeding hearts alike.")
	. += span_info("Moving through foliage has a chance to attract an ambush. The farther you're away from civilization, the more dangerous that these ambushes can become. Most ambushes can be avoided by toggling the 'SNEAK' button on your HUD, before moving through the foliage.")
	. += span_info("Some structures can be used as hiding places. Toggle the 'SNEAK' button on your HUD, then click the structure to hide in it. You can stop hiding by clicking the structure again, or by moving out of it.")

/obj/structure/flora/junglebush/spark_act()
	fire_act()

/obj/structure/flora/junglebush/Initialize()
	AddComponent(/datum/component/roguegrass)
	if(prob(88) && isnull(bushtype))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue=5,
					/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison=3,
					/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed=1))
	loot_replenish()
	pixel_x += rand(-3,3)
	return ..()

/obj/structure/flora/junglebush/proc/loot_replenish()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/natural/thorn
	looty += /obj/item/natural/fibers

/obj/structure/flora/junglebush/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent != MOVE_INTENT_SNEAK)
			L.consider_ambush()
		if(L.m_intent == MOVE_INTENT_RUN && (L.mobility_flags & MOBILITY_STAND))
			if(!ishuman(L))
				to_chat(L, span_warning("I'm cut on a thorn!"))
				L.apply_damage(5, BRUTE)
			else
				var/mob/living/carbon/human/H = L
				if(prob(20))
					if(!HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
						var/obj/item/bodypart/BP = pick(H.bodyparts)
						var/obj/item/natural/thorn/TH = new(src.loc)
						BP.add_embedded_object(TH, silent = TRUE)
						BP.receive_damage(10)
						to_chat(H, span_danger("\A [TH] impales my [BP.name]!"))
				else
					var/obj/item/bodypart/BP = pick(H.bodyparts)
					to_chat(H, span_warning("A thorn [pick("slices","cuts","nicks")] my [BP.name]."))
					BP.receive_damage(10)

/obj/structure/flora/junglebush/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 50, FALSE, -1)
		if(user.m_intent == MOVE_INTENT_SNEAK)
			hideinside(user)
			return
		if(do_after(L, 12, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					var/double_output = (HAS_TRAIT(user, TRAIT_ALCHEMY_EXPERT) && user.get_skill_level(/datum/skill/craft/alchemy) >= SKILL_LEVEL_JOURNEYMAN)
					if(double_output)
						var/obj/item/C = new B(user.loc)
						user.put_in_hands(C)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message("<span class='notice'>[user] finds [double_output ? "two of " : ""][B] in [src].</span>")
					return
			user.visible_message(span_warning("[user] searches through [src]."))
			if(looty.len)
				attack_hand(user)
			if(!looty.len)
				to_chat(user, span_warning("Picked clean... I should try later."))

/obj/structure/flora/junglebush/proc/hideinside(mob/living/user)
	if(!user)
		return
	var/sneak_level = user.get_skill_level(/datum/skill/misc/sneaking) || 0
	var/sneaktime = max(10, 50 - (sneak_level * 10))
	if(user.loc == src)
		unhide(user)
		return
	if(occupied)
		to_chat(user, span_warning("Someone is already hiding in [src]!"))
		return
	if(!do_after(user, sneaktime, src))
		return
	user.forceMove(src)
	occupied = TRUE
	hiddenguy = user
	to_chat(user, span_warning("I hide in [src]!"))

/obj/structure/flora/junglebush/proc/unhide(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T) return
	user.forceMove(T)
	occupied = FALSE
	hiddenguy = null
	to_chat(user, span_warning("I come out from [src]!"))

/obj/structure/flora/junglebush/relaymove(mob/user)
	if(user.loc == src)
		unhide(user)

/obj/structure/flora/junglebush/CanAStarPass(ID, travel_dir, caller)
	if(occupied)
		return FALSE
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		if(mover.pass_flags & PASSGRILLE)
			return TRUE
	if(travel_dir == dir)
		return FALSE
	return ..()

/obj/structure/flora/junglebush/CanPass(atom/movable/mover, turf/target)
	if(occupied)
		return 0
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return 1
	if(get_dir(loc, target) == dir)
		return 0
	return 1

// Effects
/obj/effect/decal/edge/desert_gray
	color = "#655653"
	bake_to_loc = TRUE

/obj/effect/decal/edge_corner/desert_gray
	color = "#655653"
	bake_to_loc = TRUE

//Decor
/obj/structure/vase
	name = "fancy pot"
	desc = "Decorative and Practical!"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "fancypot1"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	max_integrity = 100

//Noc Window
/obj/structure/roguewindow/stained/blue
	icon = 'modular_deserttown/icons/windows.dmi'
	icon_state = "stained-blue"
	base_state = "stained-blue"
	desc = "A stained glass window with the symbols of Nok, the Sister-Bringer of Knowledge, \
	who is the true ruler of the Pantheon of Ten. This symbol is common in places where the Ecumenical  \
	Patriarchate of Dvergale holds its power."

// Desert Spice

/datum/effect_system/smoke_spread/desert_spice
	effect_type = /obj/effect/particle_effect/smoke/desert_spice

/obj/effect/particle_effect/smoke/desert_spice
	name = "spice cloud"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	color = "#60A584"
	pixel_x = 0
	pixel_y = 0
	opacity = 0
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = 0
	amount = 4
	lifetime = 8
	density = 0
	opaque = 0

/obj/effect/particle_effect/smoke/desert_spice/smoke_mob(mob/living/carbon/M)
	if(..())
		M.emote("cough")
		M.reagents.add_reagent(/datum/reagent/druqks, 3)
		return 1

/obj/structure/desert_spice
	name = "desert spice"
	desc = "A mound of unrefined spice protruding from the sands."
	icon = 'modular_deserttown/icons/desert_spice.dmi'
	icon_state = "desert_spice"
	density = FALSE
	anchored = TRUE

/obj/structure/desert_spice/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/roguegrass)
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)

/obj/structure/desert_spice/Crossed(atom/movable/arrived)
	..()
	if(isliving(arrived))
		var/mob/living/L = arrived
		if(L.is_flying())
			return
		if(L.m_intent == MOVE_INTENT_SNEAK)
			return
		make_gas()

/obj/structure/desert_spice/attack_hand(mob/user)
	if(!isliving(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_notice("You begin carefully gathering \the [src]..."))
	if(!do_after(user, 7 SECONDS, target = src))
		to_chat(user, span_warning("You stop gathering \the [src]."))
		return
	to_chat(user, span_notice("You finish harvesting \the [src]."))
	var/obj/item/desert_spice/spice = new(drop_location())
	if(!user.put_in_hands(spice))
		to_chat(user, span_warning("Your hands are full, so \the [spice] drops to the ground."))
	qdel(src)

/obj/structure/desert_spice/proc/make_gas()
	visible_message(span_warningbig("A cloud of spice bursts up from \the [src]!"))
	var/datum/effect_system/smoke_spread/desert_spice/S = new
	playsound(get_turf(src), "sound/items/mushroom_step.ogg", 100)
	S.set_up(2, loc)
	S.start()
	qdel(src)

/obj/item/desert_spice
	name = "desert spice"
	desc = "A handful of unrefined desert spice. Highly intoxicating and valued by merchants."
	icon = 'modular_deserttown/icons/desert_spice.dmi'
	icon_state = "desert_spice"
	item_state = "spice"
	parent_type = /obj/item/reagent_containers/powder
	volume = 15
	list_reagents = list(/datum/reagent/druqks/desert_spice = 15)
	grind_results = list(/datum/reagent/druqks/desert_spice = 15)
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 55
	materia = list(/datum/materia_aspect/air)

/datum/reagent/druqks/desert_spice
	name = "desert spice"
	description = "An unrefined yet extraordinarily potent narcotic spice from the deep desert."
	color = "#60A584"
	overdose_threshold = 16
	metabolization_rate = 0.05

/datum/reagent/druqks/desert_spice/on_mob_life(mob/living/carbon/M)
	current_cycle++
	if(holder)
		holder.remove_reagent(type, metabolization_rate)
	M.apply_status_effect(/datum/status_effect/buff/desert_spice)
	return TRUE

/datum/reagent/druqks/desert_spice/on_mob_metabolize(mob/living/M)
	return

/datum/reagent/druqks/desert_spice/on_mob_end_metabolize(mob/living/M)
	return

/atom/movable/screen/alert/status_effect/buff/desert_spice
	name = "Desert Spice High"
	desc = "A furious surge of unrefined desert spice courses through your body. Your body and senses are pushed far beyond their natural limits, but the strain is lethal."
	icon_state = "acid"

/datum/status_effect/buff/desert_spice
	id = "desert_spice"
	alert_type = /atom/movable/screen/alert/status_effect/buff/desert_spice
	effectedstats = list(STATKEY_STR = 3, STATKEY_PER = 3, STATKEY_INT = 3, STATKEY_CON = 3, STATKEY_WIL = 3, STATKEY_SPD = 3)
	duration = 3 MINUTES
	tick_interval = 2 SECONDS

/datum/status_effect/buff/desert_spice/on_apply()
	. = ..()
	if(owner?.client)
		owner.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/druqks)
		owner.set_drugginess(35)
		ADD_TRAIT(owner, TRAIT_DRUQK, "desert_spice")
		SSdroning.area_entered(get_area(owner), owner.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM?.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM?.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM?.backdrop(owner)
		owner.add_stress(/datum/stressevent/high)
		to_chat(owner, span_notice("A rush of scorching energy courses through your veins! Your senses and strength soar to unnatural heights!"))
	owner.sate_addiction(/datum/charflaw/addiction/junkie)

/datum/status_effect/buff/desert_spice/tick(wait)
	if(!owner)
		return
	owner.set_drugginess(35)
	if(prob(5))
		if(owner.gender == FEMALE)
			owner.emote(pick("twitch_s", "giggle"))
		else
			owner.emote(pick("twitch_s", "chuckle"))
	if(duration != -1)
		var/time_left = duration - world.time
		if(time_left <= 30 SECONDS && time_left > 26 SECONDS)
			to_chat(owner, span_warning("Your body feels like a raging furnace on the brink of tearing itself apart!"))

/datum/status_effect/buff/desert_spice/on_remove()
	if(owner?.client)
		owner.clear_fullscreen("druqk")
		owner.set_drugginess(0)
		REMOVE_TRAIT(owner, TRAIT_DRUQK, "desert_spice")
		SSdroning.play_area_sound(get_area(owner), owner.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM?.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM?.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM?.backdrop(owner)
		owner.remove_stress(/datum/stressevent/high)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		if(C.can_heartattack() && !C.undergoing_cardiac_arrest())
			C.set_heartattack(TRUE)
			C.visible_message(span_danger("[C] clutches at [C.p_their()] chest as [C.p_their()] heart suddenly gives out!"), \
				span_userdanger("An agonizing pang shoots through your chest! Your overworked heart violently stops beating!"))
			C.adjustOxyLoss(25)
		else
			C.visible_message(span_danger("[C] violently spasms as the unrefined spice tears [C.p_them()] apart from within!"), \
				span_userdanger("The sheer unnatural strain of the spice tears through your form, extinguishing your life!"))
			C.death()
	else if(isliving(owner))
		var/mob/living/L = owner
		L.visible_message(span_danger("[L] collapses lifelessly as the spice completely overwhelms [L.p_them()]!"))
		L.death()
	. = ..()


//Throne
/obj/structure/roguethrone/desert
	name = "zybantine throne"
	icon_state = "zybantinethrone"
	icon = 'modular_deserttown/icons/throne.dmi'
	pixel_x = -16

/obj/structure/flora/junglebush/desertbush
	name = "dry bush"
	desc = "A withered, dry bush."
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "desertbush"

/obj/structure/flora/junglebush/desertbush/Initialize(mapload)
	. = ..()
	icon_state = "desertbush"

/obj/structure/flora/junglebush/desertbush/loot_replenish()
	looty.Cut()
	looty += /obj/item/grown/log/tree/stick

/obj/structure/flora/roguegrass/desertgrass
	name = "desert grass"
	desc = "Dry grass struggling to survive in the arid climate."
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "desertgrass1"

/obj/structure/flora/roguegrass/desertgrass/update_icon()
	icon_state = "desertgrass[rand(1, 5)]"

/obj/structure/flora/roguegrass/crimson
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "crimsongrassall1"
	gender = PLURAL

/obj/structure/flora/roguegrass/crimson/update_icon()
	icon_state = "crimsongrassall[rand(1, 3)]"

/obj/structure/flora/roguegrass/crimson/Initialize(mapload)
	icon_state = "crimsongrassall[rand(1, 3)]"
	. = ..()

/obj/structure/flora/roguegrass/crimson/brown
	icon_state = "crimsongrass1bb"

/obj/structure/flora/roguegrass/crimson/brown/Initialize(mapload)
	icon_state = "crimsongrass[rand(1, 3)]bb"
	. = ..()

/obj/structure/flora/roguegrass/crimson/brown/update_icon()
	icon_state = "crimsongrass[rand(1, 3)]bb"

/obj/structure/flora/roguegrass/crimson/green
	icon_state = "crimsongrass1gb"

/obj/structure/flora/roguegrass/crimson/green/Initialize(mapload)
	icon_state = "crimsongrass[rand(1, 3)]gb"
	. = ..()

/obj/structure/flora/roguegrass/crimson/green/update_icon()
	icon_state = "crimsongrass[rand(1, 3)]gb"

/obj/structure/flora/roguegrass/crimson/both
	icon_state = "crimsongrassall1"

/obj/structure/flora/roguegrass/crimson/both/Initialize(mapload)
	icon_state = "crimsongrassall[rand(1, 3)]"
	. = ..()

/obj/structure/flora/roguegrass/crimson/both/update_icon()
	icon_state = "crimsongrassall[rand(1, 3)]"

/obj/structure/flora/roguegrass/crimsongrass
	parent_type = /obj/structure/flora/roguegrass/crimson

/obj/structure/flora/roguegrass/crimsongrass/brown
	parent_type = /obj/structure/flora/roguegrass/crimson/brown

/obj/structure/flora/roguegrass/crimsongrass/green
	parent_type = /obj/structure/flora/roguegrass/crimson/green

/obj/structure/flora/roguegrass/crimsongrass/both
	parent_type = /obj/structure/flora/roguegrass/crimson/both


/obj/effect/spawner/lootdrop/cheap_carvedgem_spawner
	name = "cheap carvedgem spawner"
	icon_state = "lowjewlery"
	lootcount = 1
	loot_value = LOOT_VALUE_CHEAP_CARVEDGEM
	junk_loot = list(/obj/item/carvedgem/shell/rawshell = 5, /obj/item/reagent_containers/glass/cup/carved/shell = 5)
	loot = list(
		/obj/item/carvedgem/shell/fancyvase = 1,
		/obj/item/reagent_containers/glass/cup/carved/rose = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotshell = 1,
		/obj/item/carvedgem/shell/tablet = 1,
		/obj/item/carvedgem/shell/bust = 1,
		/obj/item/carvedgem/rose/fish = 1,
		/obj/item/carvedgem/rose/flower = 1,
		/obj/item/carvedgem/rose/tablet = 1,
		/obj/item/carvedgem/onyxa/duck = 1,
		/obj/item/carvedgem/turq/cameo = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotrose = 1,
		/obj/item/carvedgem/jade/vase = 1,
		/obj/item/carvedgem/coral/vase = 1,
	)

/obj/effect/spawner/lootdrop/valuable_carvedgem_spawner
	name = "valuable carvedgem spawner"
	icon_state = "hijewlery"
	lootcount = 1
	loot_value = LOOT_VALUE_VALUABLE_CARVEDGEM
	junk_loot = list(/obj/item/carvedgem/shell/rawshell = 5, /obj/item/reagent_containers/glass/cup/carved/shell = 5)
	loot = list(
		/obj/item/carvedgem/jade/fancyvase = 1,
		/obj/item/carvedgem/jade/comb = 1,
		/obj/item/carvedgem/jade/duck = 1,
		/obj/item/carvedgem/jade/statue = 1,
		/obj/item/carvedgem/jade/wyrm = 1,
		/obj/item/carvedgem/jade/figurine = 1,
		/obj/item/carvedgem/jade/bust = 1,
		/obj/item/carvedgem/jade/obelisk = 1,
		/obj/item/carvedgem/jade/comb = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotjade = 1,
		/obj/item/reagent_containers/glass/cup/carved/jade = 1,
		/obj/item/carvedgem/onyxa/fancyvase = 1,
		/obj/item/carvedgem/onyxa/comb = 1,
		/obj/item/carvedgem/onyxa/duck = 1,
		/obj/item/carvedgem/onyxa/statue = 1,
		/obj/item/carvedgem/onyxa/figurine = 1,
		/obj/item/carvedgem/onyxa/bust = 1,
		/obj/item/carvedgem/onyxa/obelisk = 1,
		/obj/item/carvedgem/onyxa/comb = 1,
		/obj/item/carvedgem/onyxa/snake = 1,
		/obj/item/carvedgem/onyxa/spider = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotonyxa = 1,
		/obj/item/reagent_containers/glass/cup/carved/onyxa = 1,
		/obj/item/carvedgem/onyxa/fancyvase = 1,
		/obj/item/carvedgem/onyxa/comb = 1,
		/obj/item/carvedgem/onyxa/duck = 1,
		/obj/item/carvedgem/onyxa/statue = 1,
		/obj/item/carvedgem/onyxa/figurine = 1,
		/obj/item/carvedgem/onyxa/bust = 1,
		/obj/item/carvedgem/onyxa/obelisk = 1,
		/obj/item/carvedgem/onyxa/comb = 1,
		/obj/item/carvedgem/onyxa/snake = 1,
		/obj/item/carvedgem/onyxa/spider = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotonyxa = 1,
		/obj/item/reagent_containers/glass/cup/carved/onyxa = 1,
		/obj/item/carvedgem/amber/fancyvase = 1,
		/obj/item/carvedgem/amber/comb = 1,
		/obj/item/carvedgem/amber/cameo = 1,
		/obj/item/carvedgem/amber/statue = 1,
		/obj/item/carvedgem/amber/figurine = 1,
		/obj/item/carvedgem/amber/bust = 1,
		/obj/item/carvedgem/amber/obelisk = 1,
		/obj/item/carvedgem/amber/comb = 1,
		/obj/item/carvedgem/amber/sun = 1,
		/obj/item/carvedgem/amber/beaver = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotamber = 1,
		/obj/item/reagent_containers/glass/cup/carved/amber = 1,
		/obj/item/carvedgem/opal/fancyvase = 1,
		/obj/item/carvedgem/opal/comb = 1,
		/obj/item/carvedgem/opal/fish = 1,
		/obj/item/carvedgem/opal/statue = 1,
		/obj/item/carvedgem/opal/figurine = 1,
		/obj/item/carvedgem/opal/bust = 1,
		/obj/item/carvedgem/opal/obelisk = 1,
		/obj/item/carvedgem/opal/comb = 1,
		/obj/item/carvedgem/opal/crab = 1,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotopal = 1,
		/obj/item/reagent_containers/glass/cup/carved/opal = 1,

	)

/obj/structure/flora/roguegrass/bush/wall/tallcrimson
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "tallbush1"
	opacity = 1
	pixel_x = -16
	debris = null
	static_debris = null

/obj/structure/flora/roguegrass/bush/wall/tallcrimson/Initialize(mapload)
	. = ..()
	bush_base_state = "tallbush[pick(1,2)]"
	refresh_bush_icon()



