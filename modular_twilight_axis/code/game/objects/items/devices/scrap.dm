//all unigue scrap items - here

/obj/item/flashlight/flare/torch/lantern/scrap
	name = "iron scrap lamptern"
	icon_state = "lamp"
	icon = 'modular_twilight_axis/icons/roguetown/items/lighting.dmi'
	desc = "A light to guide the way."
	light_outer_range = 5
	on = FALSE
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_HIP
	obj_flags = CAN_BE_HIT
	force = 1
	on_damage = 5
	fuel = 120 MINUTES
	should_self_destruct = FALSE
	grid_width = 32
	grid_height = 64
	extinguishable = FALSE
	weather_resistant = TRUE
	experimental_onhip = FALSE

/obj/item/rug_stored
	name = "red rug roll"
	desc = "A roll of beautifull rug."
	icon = 'modular_twilight_axis/icons/roguetown/items/kover_ahuy.dmi'
	icon_state = "kovr_red"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64

/obj/item/rug_stored/attack_self(mob/user)
	. = ..()
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't deploy the Rug here!"))
		return NONE
	if(isopenturf(target_turf))
		if(do_after(user, 2 SECONDS, TRUE, src))
			deploy_rug(user, target_turf)
			return TRUE
	return NONE

/obj/item/rug_stored/proc/deploy_rug(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You deploy the Rug.</span>")
	new /obj/effect/decal/carpet/foldable(location)
	qdel(src)

/obj/effect/decal/carpet/foldable
	name = "Red Rug"
	desc = "A beautifull red rug which can be rolled up."
	resistance_flags = FLAMMABLE
	max_integrity = 50
	smooth = 0
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/effect/decal/carpet/foldable/examine()
	. = ..()
	. += span_blue("Right-Click to fold the table.")

/obj/effect/decal/carpet/foldable/attack_right(mob/user)
	user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		new /obj/item/rug_stored(drop_location())
		qdel(src)
		return ..()

/obj/item/rug_purple_stored
	name = "purple rug roll"
	desc = "A roll of beautifull rug."
	icon_state = "kovr_purple"
	icon = 'modular_twilight_axis/icons/roguetown/items/kover_ahuy.dmi'
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64

/obj/item/rug_purple_stored/attack_self(mob/user)
	. = ..()
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't deploy the Rug here!"))
		return NONE
	if(isopenturf(target_turf))
		if(do_after(user, 2 SECONDS, TRUE, src))
			deploy_rug_purple(user, target_turf)
			return TRUE
	return NONE

/obj/item/rug_purple_stored/proc/deploy_rug_purple(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You deploy the Rug.</span>")
	new /obj/effect/decal/carpet/kover_purple/foldable(location)
	qdel(src)

/obj/effect/decal/carpet/kover_purple/foldable
	name = "Purple Rug"
	desc = "A beautifull purple rug which can be rolled up."
	resistance_flags = FLAMMABLE
	max_integrity = 50
	smooth = 0
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/effect/decal/carpet/kover_purple/foldable/examine()
	. = ..()
	. += span_blue("Right-Click to fold the table.")

/obj/effect/decal/carpet/kover_purple/foldable/attack_right(mob/user)
	user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		new /obj/item/rug_purple_stored(drop_location())
		qdel(src)
		return ..()

/obj/item/rug_black_stored
	name = "black rug roll"
	desc = "A roll of beautifull rug."
	icon = 'modular_twilight_axis/icons/roguetown/items/kover_ahuy.dmi'
	icon_state = "kovr_black"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64

/obj/item/rug_black_stored/attack_self(mob/user)
	. = ..()
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't deploy the Rug here!"))
		return NONE
	if(isopenturf(target_turf))
		if(do_after(user, 2 SECONDS, TRUE, src))
			deploy_rug_black(user, target_turf)
			return TRUE
	return NONE

/obj/item/rug_black_stored/proc/deploy_rug_black(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You deploy the Rug.</span>")
	new /obj/effect/decal/carpet/kover_black/foldable(location)
	qdel(src)

/obj/effect/decal/carpet/kover_black/foldable
	name = "Black Rug"
	desc = "A beautifull black rug which can be rolled up."
	resistance_flags = FLAMMABLE
	max_integrity = 50
	smooth = 0
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/effect/decal/carpet/kover_black/foldable/examine()
	. = ..()
	. += span_blue("Right-Click to fold the table.")

/obj/effect/decal/carpet/kover_black/foldable/attack_right(mob/user)
	user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		new /obj/item/rug_black_stored(drop_location())
		qdel(src)
		return ..()

/datum/crafting_recipe/roguetown/sewing/red_kovr
    name = "Red Rug Roll"
    category = "Misc"
    tools = list(/obj/item/needle)
    result = list(/obj/item/rug_stored)
    reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 3, /obj/item/natural/silk = 6)
    craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/gerkit/purple_kovr
    name = "Purple Rug Roll"
    category = "Misc"
    tools = list(/obj/item/needle)
    result = list(/obj/item/rug_purple_stored)
    reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 3, /obj/item/natural/silk = 6)
    craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/gerkit/black_kor
    name = "Black Rug Roll"
    category = "Misc"
    tools = list(/obj/item/needle)
    result = list(/obj/item/rug_black_stored)
    reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 3, /obj/item/natural/silk = 6)
    craftdiff = 4

/obj/item/storage/backpack/rogue/backpack_trader
	name = "traders chests"
	desc = "Bulky, heavy, enormous. You're the rat in the world with a lot of shinies in your pockets for sell."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/back.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/back.dmi'
	icon_state = "backpack_trader"
	item_state = "backpack_trader"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 10 SECONDS
	strip_delay = 5 SECONDS
	max_integrity = 400
	sellprice = 150
	pickup_sound = 'sound/foley/equip/equip_armor.ogg'
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/trader
	var/active_item = FALSE

/obj/item/storage/backpack/rogue/backpack_trader/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_BACK_L)
		active_item = TRUE
		user.change_stat(STATKEY_SPD, -4)
		to_chat(user, span_monkeyhive("uGH! I hate this thing....my back"))

/obj/item/storage/backpack/rogue/backpack_trader/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	user.change_stat(STATKEY_SPD, 4)
	to_chat(user, span_monkeyhive("Finally....some rest"))

/datum/component/storage/concrete/roguetown/trader
	screen_max_rows = 8
	screen_max_columns = 8
	max_w_class = WEIGHT_CLASS_BULKY
	not_while_equipped = TRUE

