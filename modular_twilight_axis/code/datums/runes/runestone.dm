/obj/item/runestone
	name = "runestone"
	desc = "A carved stone containing a single rune."
	icon = 'modular_twilight_axis/icons/obj/items/runes.dmi'
	icon_state = "grimoire"
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
	vand_update_appearance()

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

/obj/item/runestone/update_overlays()
	. = ..()

	if(!rune_type)
		return

	var/datum/rune/rune = new rune_type
	if(rune.color)
		var/mutable_appearance/rune_glow = mutable_appearance(icon, "grimoire")
		rune_glow.color = rune.color
		rune_glow.alpha = 180
		. += rune_glow
	qdel(rune)

/obj/item/runestone/attack(atom/target, mob/living/user, params)
	. = ..()

	if(!isliving(target))
		return

	var/mob/living/living_target = target
	try_trigger_on_hit(living_target, user)

/obj/item/runestone/proc/try_apply_to_weapon(obj/item/rogueweapon/item_target, mob/living/user)
	if(!item_target)
		return FALSE

	var/datum/component/rune_storage/storage = item_target.GetComponent(/datum/component/rune_storage)
	if(!storage)
		storage = item_target.AddComponent(/datum/component/rune_storage)

	if(!storage)
		return FALSE

	var/datum/rune/rune = new rune_type
	if(!storage.add_rune(rune, user))
		qdel(rune)
		return FALSE

	to_chat(user, span_notice("You apply [rune.name] to [item_target]."))
	return TRUE

/obj/item/runestone/proc/try_trigger_on_hit(mob/living/target, mob/living/user)
	if(!target || !user || !rune_type)
		return FALSE

	var/datum/rune/rune = new rune_type
	if(!(rune.trigger_flags & RUNE_TRIGGER_ON_HIT))
		qdel(rune)
		return FALSE

	if(rune.proc_chance < 100 && !prob(rune.proc_chance))
		qdel(rune)
		return FALSE

	rune.on_trigger(src, user, target, null, null)
	to_chat(user, span_notice("[rune.name] activates on hit!"))
	qdel(rune)
	return TRUE

/obj/item/rogueweapon/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/runestone))
		var/obj/item/runestone/rune_stone = I
		if(!rune_stone.rune_type)
			return	
		
		if(rune_stone.try_apply_to_weapon(src, user))
			qdel(rune_stone)
			return
	
	. = ..()
