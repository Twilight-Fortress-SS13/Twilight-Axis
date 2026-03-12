/obj/item/runestone
	name = "runestone"
	desc = "A carved stone containing a single rune."
	icon = 'modular_twilight_axis/icons/obj/items/runes.dmi'
	icon_state = "erune"
	w_class = WEIGHT_CLASS_TINY

	force = 15
	throwforce = 10
	possible_item_intents = list(/datum/intent/mace/strike)

	/// Type path of the rune stored in this stone
	var/rune_type = /datum/rune

/obj/item/runestone/Initialize(mapload, rune_path)
	. = ..()

	if(rune_path)
		rune_type = rune_path

	update_rune_icon()
	update_rune_glow()
	vand_update_appearance()

/obj/item/runestone/proc/get_rune_name()
	if(!rune_type)
		return "Unknown"

	var/datum/rune/R = new rune_type
	. = R.name
	qdel(R)

/obj/item/runestone/proc/get_rune_desc()
	if(!rune_type)
		return "It seems inert."

	var/datum/rune/R = new rune_type
	. = R.desc
	qdel(R)

/obj/item/runestone/proc/update_rune_icon()
	if(!rune_type)
		return

	if(ispath(rune_type, /datum/rune/fire))
		icon_state = "frune"
	else if(ispath(rune_type, /datum/rune/water))
		icon_state = "wrune"
	else if(ispath(rune_type, /datum/rune/earth))
		icon_state = "erune"
	else if(ispath(rune_type, /datum/rune/air))
		icon_state = "arune"

/obj/item/runestone/proc/update_rune_glow()
	remove_filter("runestone_glow")

	if(!rune_type)
		return

	var/datum/rune/R = new rune_type

	if(R.color)
		add_filter(
			"runestone_glow",
			1,
			list(
				"type" = "drop_shadow",
				"x" = 0,
				"y" = 0,
				"size" = 2,
				"color" = R.color
			)
		)

	qdel(R)

/obj/item/runestone/examine(mob/user)
	. = ..()

	. += span_notice("It contains the rune: [get_rune_name()].")
	. += span_info("[get_rune_desc()]")

/obj/item/runestone/attack(atom/target, mob/living/user, params)
	. = ..()

	if(!isliving(target))
		return

	var/mob/living/L = target
	try_trigger_on_hit(L, user)

/obj/item/runestone/proc/try_apply_to_weapon(obj/item/rogueweapon/weapon_target, mob/living/user)
	if(!weapon_target || !user || !rune_type)
		return FALSE

	to_chat(user, span_notice("You begin applying the runestone to [weapon_target]..."))

	if(!do_after(user, 2 SECONDS, weapon_target))
		return FALSE

	if(QDELETED(weapon_target) || QDELETED(src))
		return FALSE

	var/datum/component/rune_storage/storage = weapon_target.GetComponent(/datum/component/rune_storage)

	if(!storage)
		storage = weapon_target.AddComponent(/datum/component/rune_storage)

	if(!storage)
		return FALSE

	var/datum/rune/R = new rune_type

	if(!storage.add_rune(R, user))
		qdel(R)
		return FALSE

	to_chat(user, span_notice("You apply [R.name] to [weapon_target]."))

	return TRUE

/obj/item/runestone/proc/try_trigger_on_hit(mob/living/target, mob/living/user)
	if(!target || !user || !rune_type)
		return FALSE

	var/datum/rune/R = new rune_type

	if(!(R.trigger_flags & RUNE_TRIGGER_ON_HIT))
		qdel(R)
		return FALSE

	if(R.proc_chance < 100 && !prob(R.proc_chance))
		qdel(R)
		return FALSE

	R.on_trigger(src, user, target, null, null)

	to_chat(user, span_notice("[R.name] activates on hit!"))

	qdel(R)
	return TRUE

/obj/item/rogueweapon/attackby(obj/item/I, mob/living/user, params)

	if(istype(I, /obj/item/runestone))
		var/obj/item/runestone/R = I

		if(!R.rune_type)
			return

		if(R.try_apply_to_weapon(src, user))
			qdel(R)
			return

	. = ..()
