/datum/magic_item/superior/thievery
	name = "fast fingers"
	description = "It looks like it fits just right"
	glow_color = "#483D8B"
	var/active_item = FALSE
	var/masterstealer = FALSE
	var/legendstealer = FALSE
	var/legendlockpick = FALSE

/datum/magic_item/superior/thievery/on_equip(obj/item/i, mob/living/user, slot)
	. = ..()
	if((user.get_skill_level(/datum/skill/misc/stealing)== 6) && (user.get_skill_level(/datum/skill/misc/lockpicking)== 6))
		to_chat(user, span_notice("I'm too skilled to use this"))
		return
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		if (user.get_skill_level(/datum/skill/misc/stealing) == 6)
			legendstealer = TRUE
			masterstealer = FALSE
		if (user.get_skill_level(/datum/skill/misc/stealing)== 5)
			user.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
			masterstealer = TRUE
		else
			user.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)

		if (user.get_skill_level(/datum/skill/misc/lockpicking)== 6)
			legendlockpick = TRUE
		else
			user.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)

		to_chat(user, span_notice("I feel more dextrous!"))

/datum/magic_item/superior/thievery/on_drop(obj/item/i, mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if (!legendstealer)
			if (masterstealer)
				user.adjust_skillrank(/datum/skill/misc/stealing, -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/misc/stealing, -2, TRUE)
		if(!legendlockpick)
			user.adjust_skillrank(/datum/skill/misc/lockpicking, -1, TRUE)
		to_chat(user, span_notice("I feel mundane once more"))


/obj/item/enchantmentscroll/superior/thievery
	name = "runic tincture of nimble fingers"
	desc = "A vial of quicksilver ink, imbued with an enchantment of thievery."
	component = /datum/magic_item/superior/thievery
	apply_to_pretty = "Can be applied to gloves or a ring."
	effects_pretty = "Increases the bearer's skill in pickpocketing and lockpicking."

/obj/item/enchantmentscroll/superior/thievery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/gloves)||istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of nimble fingers"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))


/datum/runeritual/enchanting/thievery
	name = "Thievery"
	desc = "Better pickpocketing and lockpicks!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/magic/infernal/fang = 2)
	result_atoms = list(/obj/item/enchantmentscroll/superior/thievery)

