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
	icon = 'icons/roguetown/topadd/johnie/amulets backpacks.dmi'
	icon_state = "bedroll"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64

/obj/item/rug_stored/attack_self(mob/user)
	. = ..()
	//deploy the table if the user clicks on it with an open turf in front of them
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
