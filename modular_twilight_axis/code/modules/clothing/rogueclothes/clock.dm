/datum/looping_sound/handclockloop
	mid_sounds = list('modular_twilight_axis/sound/items/clocks.ogg')
	mid_length = 20
	volume = 70
	extra_range = -3
	ignore_walls = FALSE

/obj/item/clock_capped
	name = "gold pocket clock"
	desc = "Произведение инженерного искусства под красивой золотой крышкой со знаком Астраты. Всегда знай какой сейчас час и день!"
	icon = 'modular_twilight_axis/icons/clothing/clocks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/clocks.dmi'
	icon_state = "clock_g"
	item_state = "clock_g"
	slot_flags = ITEM_SLOT_CLOAK | ITEM_SLOT_HIP | ITEM_SLOT_BACK_R | ITEM_SLOT_BACK_L
	grid_height = 32
	grid_width = 32
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	force = 15
	dropshrink = 0
	hitsound = 'sound/blank.ogg'
	sellprice = 0
	resistance_flags = FIRE_PROOF
	var/datum/looping_sound/handclockloop/soundloop
	var/open = FALSE
	var/wrist_display = FALSE

/obj/item/clock_capped/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(slot == SLOT_BELT || slot == SLOT_BELT_L  || slot == SLOT_BELT_R || (wrist_display && slot != SLOT_CLOAK))
		mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
		sleeved = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	return ..()

/obj/item/clock_capped/attack_right(mob/user)
	if(!ismob(loc))
		return ..()

	wrist_display = !wrist_display
	to_chat(user, span_info("You adjust clock's place on your body"))
	if(wrist_display)
		mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
		sleeved = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_clothes()
	return ..()

/obj/item/clock_capped/attack_self(mob/living/user)
	if(!open)
		open = TRUE
		playsound(src, 'sound/items/blackmirror_open.ogg', 100, FALSE)
		icon_state = "clock_g_o"
		soundloop = new(src, FALSE)
		soundloop.start()
	else
		open = FALSE
		playsound(src, 'sound/items/blackmirror_shut.ogg', 100, FALSE)
		icon_state = "clock_g"
		soundloop.stop()
	..()

/obj/item/clock_capped/Destroy()
	if(soundloop)
		soundloop.stop()
	..()

/obj/item/clock_capped/examine(mob/user)
	. = ..()
	if(open)
		var/day = LOWER_TEXT(get_current_day_of_week_name())
		. += "Oh no, it's [station_time_timestamp("hh:mm")] on a [day]"

/obj/item/clock_capped/silver
	name = "silver pocket clock"
	desc = "Произведение инженерного искусства под красивой серебряной крышкой со знаком Псайдона. Всегда знай какой сейчас час и день!"
	icon_state = "clock_s"
	item_state = "clock_s"
	open = FALSE
	sellprice = 0

/obj/item/clock_capped/silver/attack_self(mob/living/user)
	if(!open)
		open = TRUE
		playsound(src, 'sound/items/blackmirror_open.ogg', 100, FALSE)
		icon_state = "clock_s_o"
		soundloop = new(src, FALSE)
		soundloop.start()
	else
		open = FALSE
		playsound(src, 'sound/items/blackmirror_shut.ogg', 100, FALSE)
		icon_state = "clock_s"
		soundloop.stop()

/obj/item/clock_capped/compas
	name = "gold artificied clock"
	desc = "Компас."
	icon_state = "compas"
	item_state = "compas"

/obj/item/clock_capped/compas/attack_self(mob/living/user)
	if(!open)
		open = TRUE
		playsound(src, 'sound/items/blackmirror_open.ogg', 100, FALSE)
		if((GLOB.tod == "night") || (GLOB.tod == "dusk"))
			icon_state = "compas_o"
		else
			icon_state = "compas_o_d"
		soundloop = new(src, FALSE)
		soundloop.start()
	else
		open = FALSE
		playsound(src, 'sound/items/blackmirror_shut.ogg', 100, FALSE)
		icon_state = "compas"
		soundloop.stop()


/obj/item/clock
	name = "bronze pocket clock"
	desc = "Красивые, хоть и простые часы из бронзы на железной цепочке. Стекло сохраняет стрелки и механизм от пыли и грязи."
	icon = 'modular_twilight_axis/icons/clothing/clocks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/clocks.dmi'
	icon_state = "clock_br"
	item_state = "clock_br"
	slot_flags = ITEM_SLOT_CLOAK | ITEM_SLOT_HIP | ITEM_SLOT_BACK_R | ITEM_SLOT_BACK_L
	grid_height = 32
	grid_width = 32
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	force = 15
	dropshrink = 0
	hitsound = 'sound/blank.ogg'
	sellprice = 0
	resistance_flags = FIRE_PROOF
	var/wrist_display = FALSE

/obj/item/clock/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(slot == SLOT_BELT || slot == SLOT_BELT_L  || slot == SLOT_BELT_R || (wrist_display && slot != SLOT_CLOAK))
		mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
		sleeved = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	return ..()

/obj/item/clock/attack_right(mob/user)
	if(!ismob(loc))
		return ..()

	wrist_display = !wrist_display
	to_chat(user, span_info("You adjust clock's place on your body"))
	if(wrist_display)
		mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
		sleeved = 'modular_twilight_axis/icons/clothing/onmob/clocks_belt.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_clothes()
	return ..()

/obj/item/clock/examine(mob/user)
	. = ..()
	var/day = LOWER_TEXT(get_current_day_of_week_name())
	. += "Oh no, it's [station_time_timestamp("hh:mm")] on a [day]"

/obj/item/clock/iron
	name = "iron pocket clock"
	desc = "Красивые, хоть и простые часы из железа на такой же железной цепочке. Стекло сохраняет стрелки и механизм от пыли и грязи."
	icon_state = "clock_i"
	item_state = "clock_i"
	sellprice = 0

/datum/anvil_recipe/engineering/clock_g
	name = "Gold Pocket Clock"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegear)
	created_item = /obj/item/clock_capped
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/engineering/clock_s
	name = "Silver Pocket Clock"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegear)
	created_item = /obj/item/clock_capped/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/engineering/clock_br
	name = "Bronze Pocket Clock"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear)
	created_item = /obj/item/clock
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/engineering/clock_i
	name = "Iron Pocket Clock"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear)
	created_item = /obj/item/clock/iron
	craftdiff = SKILL_LEVEL_EXPERT
