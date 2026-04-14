/obj/item/craft_kit
	name = "iron craftkit"
	desc = "An empty metal box that is suitable for storing various pieces of hardware and other scrap. \
	Fill with reguired metal objects to create a varios items"
	icon_state = "craft_kit_iron"
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	grid_width = 64
	grid_height = 32
	var/need_scrap = 3
	var/current_scrap = 0
	var/scrap = /obj/item/scrap
	var/material = /obj/item/ingot/iron
	var/result = null
	dropshrink = 0.7

/obj/item/craft_kit/Initialize()
	. = ..()
	var/obj/item/result_item = result
	name = "[result_item?.name] craftkit"

/obj/item/craft_kit/attackby(obj/O, mob/living/user, params)
	if(!isitem(O))
		return
	if(!result)
		return
	var/obj/item/I = O
	if(I.anvilrepair || I.type == scrap)
		if(I.smeltresult == material || I.type == scrap)
			if(!do_after(user, 2 SECONDS, target = I))
				return
			user.visible_message(span_notice("[user] salvages [I] into usable materials."))
			qdel(I)
			current_scrap++
			if(current_scrap < need_scrap)
				var/visible_scrap = need_scrap - current_scrap
				to_chat(user, span_info("To fill [name], you need [visible_scrap] more..."))
			if(current_scrap >= need_scrap)
				var/quality = (user.get_skill_level(/datum/skill/craft/crafting) - 6) + (user.get_skill_level(/datum/skill/craft/blacksmithing) - 6) + (user.get_stat(STAT_INTELLIGENCE) - 10)
				if(prob(50 - ((10 - user.get_stat(STAT_FORTUNE))*10)))
					quality -= rand(1,5)
				var/obj/item/item_result = new result(get_turf(src))
				if(quality < 0)
					quality = quality * 5
					item_result.max_integrity += quality
					item_result.obj_integrity += quality + rand(-10, -100)
				qdel(src)
			return
		return
	return

/obj/item/craft_kit/steel
	name = "steel craftkit"
	icon_state = "craft_kit_steel"
	scrap = /obj/item/steel_scrap
	material = /obj/item/ingot/steel
	result = null

/obj/item/steel_scrap
	name = "steel scrap"
	desc = "Shingles and scrap, borne from violence upon steel. There may yet still be a use for these pieces.. </br>Steel scrap can be crafted into varios craft kits."
	icon_state = "scrap_steel"
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	grid_width = 32
	grid_height = 32
	dropshrink = 0.7
	anvilrepair = /datum/skill/craft/blacksmithing

/obj/item/metal_stake
	name = "metal stake"
	icon_state = "m_stake"
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	desc = "A heavy, sharp, iron-reinforced stake. It can break steel items to scrap piles."
	grid_width = 32
	grid_height = 64
	force = 18
	throwforce = 5
	possible_item_intents = list(/datum/intent/stab, /datum/intent/pick)
	max_blade_int = 200
	max_integrity = 100
	static_debris = null
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR
	obj_flags = null
	w_class = WEIGHT_CLASS_SMALL
	twohands_required = FALSE
	gripped_intents = null
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP

/obj/item/metal_stake/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/metal_stake/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(isitem(O))
		var/obj/item/I = O
		var/check_cout = 0
		if(istype(I, /obj/item/ingot))
			if(!do_after(user, 4 SECONDS, target = I))
				return
			to_chat(user, span_warning("The [user] breaks an [I] using stake into small parts!"))
			var/scrap_type = null
			if(istype(I, /obj/item/ingot/iron))
				scrap_type = /obj/item/scrap
			if(istype(I, /obj/item/ingot/steel))
				scrap_type = /obj/item/steel_scrap
			for(var/i in 1 to 3)
				new scrap_type(get_turf(I))
			qdel(I)
			return
		if(I.anvilrepair)
			if(!I.smeltresult || I.smeltresult == /obj/item/ash)
				return
			if(!do_after(user, 2 SECONDS, target = I))
				return
			if(I.smeltresult == /obj/item/ingot/iron)
				new /obj/item/scrap(get_turf(I))
				check_cout++
			if(I.smeltresult == /obj/item/ingot/steel)
				new /obj/item/steel_scrap(get_turf(I))
				check_cout++
			if(check_cout == 0)
				return
			to_chat(user, span_warning("The [user] breaks an [I] using stake into small parts!"))
			qdel(I)
			return

/obj/item/storage/belt/rogue/pouch/i_scrap
	populate_contents = list(
	/obj/item/ingot/iron,
	/obj/item/ingot/iron
	)

/obj/item/storage/belt/rogue/pouch/s_scrap
	populate_contents = list(
	/obj/item/ingot/steel,
	/obj/item/ingot/steel
	)

/obj/item/ingot/attackby(obj/item/I, mob/user, params) //переопределяет аттакбай слитков, для возможности их разлома колышками
	. = ..()
	if(istype(I, /obj/item/metal_stake) || istype(I, /obj/item/grown/log/tree/stake))
		if(!do_after(user, 4 SECONDS, target = src))
			return
		to_chat(user, span_warning("The [user] breaks an [I] using stake into small parts!"))
		var/scrap_type = null
		if(istype(src, /obj/item/ingot/iron))
			scrap_type = /obj/item/scrap
		if(istype(src, /obj/item/ingot/steel))
			scrap_type = /obj/item/steel_scrap
		for(var/i in 1 to 3)
			new scrap_type(get_turf(src))
		qdel(src)
		return
	..()

//IRON
/*
/obj/item/craft_kit/
	result =
*/

GLOBAL_LIST_INIT(craft_iron, (list(/obj/item/clothing/neck/roguetown/chaincoif/full/iron,
								/obj/item/clothing/suit/roguetown/armor/chainmail/iron,
								/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron,
								/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron,
								/obj/item/clothing/suit/roguetown/armor/plate/iron,
								/obj/item/clothing/suit/roguetown/armor/plate/full/iron,
								/obj/item/clothing/suit/roguetown/armor/chainmail/light/iron,
								/obj/item/clothing/suit/roguetown/armor/brigandine/light/handmade,
								/obj/item/clothing/wrists/roguetown/bracers/splint,
								/obj/item/clothing/under/roguetown/chainlegs/iron,
								/obj/item/clothing/under/roguetown/splintlegs,
								/obj/item/clothing/under/roguetown/chainlegs/iron/kilt,
								/obj/item/clothing/shoes/roguetown/boots/armor/iron
								)
))
//helmet

/obj/item/craft_kit/full_chaincoif
	result = /obj/item/clothing/neck/roguetown/chaincoif/full/iron

//armor

/obj/item/craft_kit/haubergeon
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/iron

/obj/item/craft_kit/hauberk
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron

/obj/item/craft_kit/cuirass
	result = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron

/obj/item/craft_kit/halfplate
	result = /obj/item/clothing/suit/roguetown/armor/plate/iron

/obj/item/craft_kit/plate
	result = /obj/item/clothing/suit/roguetown/armor/plate/full/iron

/obj/item/craft_kit/haubergeon_light
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/light/iron

/obj/item/craft_kit/brigandine_light
	result = /obj/item/clothing/suit/roguetown/armor/brigandine/light/handmade

//arms

/obj/item/craft_kit/splintarms
	result = /obj/item/clothing/wrists/roguetown/bracers/splint

//legs

/obj/item/craft_kit/chainlegs
	result = /obj/item/clothing/under/roguetown/chainlegs/iron

/obj/item/craft_kit/splintlegs
	result = /obj/item/clothing/under/roguetown/splintlegs

/obj/item/craft_kit/kilt
	result = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt

//feets

/obj/item/craft_kit/lplateboots
	result = /obj/item/clothing/shoes/roguetown/boots/armor/iron

//STEEL
/*
/obj/item/craft_kit/steel/
	result =
*/

GLOBAL_LIST_INIT(craft_steel, (list(/obj/item/clothing/neck/roguetown/chaincoif/full,
								/obj/item/clothing/suit/roguetown/armor/chainmail,
								/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,
								/obj/item/clothing/suit/roguetown/armor/plate/cuirass,
								/obj/item/clothing/suit/roguetown/armor/plate,
								/obj/item/clothing/suit/roguetown/armor/plate/full,
								/obj/item/clothing/suit/roguetown/armor/chainmail/light,
								/obj/item/clothing/under/roguetown/chainlegs,
								/obj/item/clothing/under/roguetown/chainlegs/kilt,
								)
))

//helmet

/obj/item/craft_kit/steel/full_chaincoif
	result = /obj/item/clothing/neck/roguetown/chaincoif/full

//armor

/obj/item/craft_kit/steel/haubergeon
	result = /obj/item/clothing/suit/roguetown/armor/chainmail

/obj/item/craft_kit/steel/hauberk
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk

/obj/item/craft_kit/steel/cuirass
	result = /obj/item/clothing/suit/roguetown/armor/plate/cuirass

/obj/item/craft_kit/steel/halfplate
	result = /obj/item/clothing/suit/roguetown/armor/plate

/obj/item/craft_kit/steel/plate
	result = /obj/item/clothing/suit/roguetown/armor/plate/full

/obj/item/craft_kit/steel/haubergeon_light
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/light

//legs

/obj/item/craft_kit/steel/chainlegs
	result = /obj/item/clothing/under/roguetown/chainlegs

/obj/item/craft_kit/steel/kilt
	result = /obj/item/clothing/under/roguetown/chainlegs/kilt
