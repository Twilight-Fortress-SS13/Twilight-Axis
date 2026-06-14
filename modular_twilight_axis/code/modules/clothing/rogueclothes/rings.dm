/obj/item/clothing/ring/baotha
	name = "snake ring"
	desc = "The ring is made of steel with gilding, and it is artfully recreated as a snake. The quality of the work is so high that it feels as if the snake's gem-filled eyes are watching you."
	icon_state = "baotha_knife"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/rings.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/rings.dmi'
	max_integrity = 300
	var/realname
	var/realdesc
	var/realstate
	var/realicon
	var/baotha_disguised = FALSE

	grid_width = 32
	grid_height = 32

/obj/item/clothing/ring/baotha/Initialize()
	. = ..()
	realname = name
	realdesc = desc
	realstate = icon_state
	realicon = icon

/obj/item/clothing/ring/baotha/get_examine_highlight_status()
	if(baotha_disguised)
		return
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_BAOTHA_RELIC)

/obj/item/clothing/ring/baotha/examine(var/mob/living/carbon/human/user)
	. = ..()
	if(iscarbon(user))
		if(user.patron.type == /datum/patron/inhumen/baotha)
			. += ("This creature is a small gift from my patron, and I can make it take any form I desire.")

/obj/item/clothing/ring/baotha/attack_right(var/mob/living/carbon/human/user)
	if(user.patron.type == /datum/patron/inhumen/baotha)
		var/mimicry = list("gold ring", "silver ring", "bronze ring", "Undo")
		var/mimicry_choise = input("Variants:", "camouflage") as anything in mimicry
		switch(mimicry_choise)
			if("gold ring")
				name = "gold ring"
				desc = "A ring of golden beauty."
				icon_state = "ring_g"
				baotha_disguised = TRUE
			if("silver ring")
				name = "silver ring"
				desc = "A ring of silvered glimmerance."
				icon_state = "ring_s"
				baotha_disguised = TRUE
			if("bronze ring")
				name = "bronze ring"
				desc = "A ring of bronzen resiliance."
				icon_state = "ring_b"
				baotha_disguised = TRUE
			if("Undo")
				name = realname
				desc = realdesc
				icon = realicon
				icon_state = realstate
				baotha_disguised = FALSE

/obj/item/clothing/ring/baotha/attack_self(var/mob/living/carbon/human/user)
	if(user.patron.type == /datum/patron/inhumen/baotha)
		if(do_after(user, 10, target = src))
			var/obj/item/rogueweapon/huntingknife/idagger/steel/baotha/S = new/obj/item/rogueweapon/huntingknife/idagger/steel/baotha(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(S)
			qdel(src)
			playsound(user, pick('sound/magic/magic_nulled.ogg'), 20, TRUE)
		else
			to_chat(user, "<span class='notice'>I losing concentration!</span>")
