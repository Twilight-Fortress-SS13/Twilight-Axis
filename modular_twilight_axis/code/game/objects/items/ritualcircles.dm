/obj/structure/ritualcircle/malum_TA
	name = "Rune of Forge"
	desc = "A Holy Rune of Malum. A hammer and heat, to fix any imperfections with."
	icon_state = "malum_chalky"
	var/forgerites = list("Ritual of Blessed Reforgance", "Malum Forge")

/obj/structure/ritualcircle/malum_TA/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/malum)
		to_chat(user,span_warning("This rune references schematics I don't understand."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_warning("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_warning("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Creation", src) as null|anything in forgerites
	switch(riteselection) // put ur rite selection here
		if("Ritual of Blessed Reforgance")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("God of craft and heat of the forge!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Take forth these metals and rebirth them in your furnaces!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Grant unto me the metals in which to forge great works!")
			to_chat(user,span_danger("You feel a sudden heat rising within you, burning within your chest.."))
			if(!do_after(user, 3 SECONDS))
				return
			icon_state = "malum_active"
			user.say("From your forge, may these creations be remade!!")
			loc.visible_message(span_warning("A wave of heat rushes out from the ritual circle before [user]. The metal is reforged in a flash of light!"))
			playsound(loc, 'sound/magic/churn.ogg', 100, FALSE, -1)
			holyreforge_TA(src)
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			spawn(120)
				icon_state = "malum_chalky"
		if("Malum Forge")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("God of craft and heat of the forge!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Take forth these metals and rebirth them in your furnaces!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Grant unto me the metals in which to forge great works!")
			to_chat(user,span_danger("You feel a sudden heat rising within you, burning within your chest.."))
			if(!do_after(user, 3 SECONDS))
				return
			icon_state = "malum_active"
			user.say("From your forge, may these creations be remade!!")
			loc.visible_message(span_warning("A wave of heat rushes out from the ritual circle before [user]. The metal is reforged in a flash of light!"))
			playsound(loc, 'sound/magic/churn.ogg', 100, FALSE, -1)
			malumforge(src)
			new /obj/effect/hotspot(get_turf(src))
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			spawn(120)
				icon_state = "malum_chalky"

/obj/structure/ritualcircle/malum_TA/proc/holyreforge_TA(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.flash_fullscreen("whiteflash") //Cool effect!
	for (var/obj/item/ingot/silver/I in loc)
		qdel(I)
		new /obj/item/ingot/silverblessed(loc)
	for (var/obj/item/ingot/steel/I in loc)
		qdel(I)
		new /obj/item/ingot/steelholy(loc)

/obj/structure/ritualcircle/malum_TA/proc/malumforge(src)
	var/ritualtargets = view(7, loc)
	var/datum/effect_system/spark_spread/sparks = new()
	var/list/nosmeltore = list(/obj/item/rogueore/coal)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.flash_fullscreen("whiteflash") //Cool effect!
	for (var/obj/item/I in loc)
		if(!istype(I, /obj/item/ingot))
			rite_item_smelting(I, sparks, nosmeltore)
	for (var/obj/item/ingot/iron/I in loc)
		qdel(I)
		new /obj/item/ingot/steel(loc)
	for (var/obj/item/ingot/aaslag/I in loc)
		qdel(I)
		new /obj/item/ingot/bronze(loc)

/proc/rite_item_smelting(obj/item/target, datum/effect_system/spark_spread/sparks, list/nosmeltore)
	if (!target.smeltresult) return
	var/obj/item/itemtospawn = target.smeltresult
	new itemtospawn(target.loc)
	sparks.set_up(1, 1, target.loc)
	sparks.start()
	qdel(target)

/obj/structure/ritualcircle/baotha_TA
	name = "Rune of Hedonism"
	desc = "A Holy Rune of Baotha. Relief for the broken hearted."
	icon_state = "baotha_chalky"
	var/baothists = list("Rite of Armaments", "Rite of Joy", "Expancy", "Masquarade")

/obj/structure/ritualcircle/baotha_TA/attack_hand(mob/living/user, list/selected_atoms, turf/loc)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/baotha)
		to_chat(user,span_warning(""))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_warning("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_warning("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Hedonism", src) as null|anything in baothists
	switch(riteselection) // put ur rite selection here
		if("Rite of Armaments")
			if(user.has_status_effect(/datum/status_effect/debuff/armamentrites))
				to_chat(user, span_warning("I am not yet ready to perform this rite."))
				return
			var/onrune = view(1, src.loc)
			var/list/joyridersonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_DEPRAVED))
					joyridersonrune += persononrune
			var/mob/living/carbon/human/target = input(user, "Choose a host") as null|anything in joyridersonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("O' BLESSED SPIDER, SCORNED AND SORROWFUL, HEED MY PLEA OF SUCCOR!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("TAKE THIS CUP FROM ME, OVERFILLING WITH ANGUISH AND HEARTBREAK..")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("..AND IN ITS STEAD, BESTOW UPON ME.. EEEEVEEERRRYTHIIIIIIING!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "baotha_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			ADD_TRAIT(target, TRAIT_NOPAIN, TRAIT_RITUAL)
			ADD_TRAIT(target, TRAIT_DODGEEXPERT, TRAIT_RITUAL)
			var/is_heretic = istype(user.mind?.picked_advclass, /datum/advclass/wretch/heretic || /datum/advclass/wretch/heretic/spy || /datum/advclass/gnoll/shaman)
			if(is_heretic)
				user.apply_status_effect(/datum/status_effect/debuff/armamentrites)
			baothaarmamentsta(target)
			spawn(120)
				icon_state = "baotha_chalky"
		if("Rite of Joy")
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Let the wine flow, let the music crash!")
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Away with tears, away with shame!")
			to_chat(user, span_notice("The memory of sorrow fades into a haze of bliss."))
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Grant me the bliss, grant me the rush!")
			if(!do_after(user, 3 SECONDS))
				return FALSE
			user.say("Baotha, fill my cup with endless mirth!")
			playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			user.apply_status_effect(/datum/status_effect/joybringer)

			return TRUE
		if("Expancy")
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Let the wine flow, let the music crash!")
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Away with tears, away with shame!")
			to_chat(user, span_notice("The memory of sorrow fades into a haze of bliss."))
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Grant me the bliss, grant me the rush!")
			if(!do_after(user, 3 SECONDS))
				return FALSE
			user.say("Baotha, fill my cup with endless mirth!")
			playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
			var/ritual_type = list("Ozium x3", "Moon Dust x3", "Purified Moondust x2", "Star shugar x2", "Spice x2", "Herozium x2", "Smartium x3", "Grave Powder x3", "Corps Dust x3", "Inferrum x3", "Grenzelhoft Sour x3", "Otavan Red x3", "Otavan White x3", "Elven Red x3", "Valmora Blue x2", "Aged Spiced Wine x2", "Delectable Spiced Wine x2")
			var/chooselection = input(user, "Rituals of Gedonism", src) as null|anything in ritual_type
			var/choose = /obj/item/reagent_containers/powder/ozium
			var/count = 3
			if(!chooselection)
				return
			switch(chooselection)
				if("Ozium x3")
					choose = /obj/item/reagent_containers/powder/ozium
				if("Moon Dust x3")
					choose = /obj/item/reagent_containers/powder/moondust
				if("Purified Moondust x2")
					choose = /obj/item/reagent_containers/powder/moondust_purest
					count = 2
				if("Starsugar x2")
					choose = /obj/item/reagent_containers/powder/starsugar
					count = 2
				if("Spice x2")
					choose = /obj/item/reagent_containers/powder/spice
					count = 2
				if("Herozium x2")
					choose = /obj/item/reagent_containers/powder/herozium
					count = 2
				if("Smartium x3")
					choose = /obj/item/reagent_containers/powder/smartium
				if("Grave Powder x3")
					choose = /obj/item/reagent_containers/powder/grave_powder
				if("Corps Dust x3")
					choose = /obj/item/reagent_containers/powder/corps_dust
				if("Inferrum x3")
					choose = /obj/item/reagent_containers/powder/inferrum
				if("Grenzelhoft Sour x3")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine
				if("Otavan Red x3")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/redwine
				if("Otavan White x3")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/whitewine
				if("Elven Red x3")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/elfred
				if("Valmora Blue x2")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/elfblue
					count = 2
				if("Aged Spiced Wine x2")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/spicedwineaged
					count = 2
				if("Delectable Spiced Wine x2")
					choose = /obj/item/reagent_containers/glass/bottle/rogue/spicedwinedelectable
					count = 2
			for(var/i=1, i <= count, i++)
				new choose (get_turf(src))
				playsound(src, 'sound/magic/mending.ogg', 35, TRUE, -2)
				sleep(1 SECONDS)
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			return TRUE
		if("Masquarade")
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Let the wine flow, let the music crash!")
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Away with tears, away with shame!")
			to_chat(user, span_notice("The memory of sorrow fades into a haze of bliss."))
			if(!do_after(user, 5 SECONDS))
				return FALSE
			user.say("Grant me the bliss, grant me the rush!")
			if(!do_after(user, 3 SECONDS))
				return FALSE
			user.say("Baotha, fill my cup with endless mirth!")
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
			new /obj/item/clothing/ring/baotha (get_turf(src))
			user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			sleep(1 SECONDS)
			playsound(loc, 'sound/magic/mending.ogg', 35, TRUE, -2)
			new /obj/item/clothing/suit/roguetown/armor/regenerating/baotha (get_turf(src))
			return TRUE

/obj/structure/ritualcircle/baotha_TA/proc/baothaarmamentsta(mob/living/carbon/human/target)
	if(!target || QDELETED(target))
		return
	if(!HAS_TRAIT(target, TRAIT_DEPRAVED))
		visible_message(span_cult("THE RITE REJECTS ONE WITHOUT REGRET IN THEIR HEART!!"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("superagony")
	playsound(src, 'sound/misc/smelter_fin.ogg', 50)
	visible_message(span_cult("[target]'s lux gushes out from their mouth, splashing onto the rune and causing the chalk to fizzle into prismatic smoke; and once it clears, their saccharine presence is made clear!"))
	spawn(20)
		if(QDELETED(target) || QDELETED(src))
			return
		playsound(src, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/baothanrite_TA)
		tag_kit_items(target, list(
			"armor" = target.get_item_by_slot(SLOT_ARMOR),
			"shirt" = target.get_item_by_slot(SLOT_SHIRT),
			"pants" = target.get_item_by_slot(SLOT_PANTS),
			"shoes" = target.get_item_by_slot(SLOT_SHOES),
			"wrists" = target.get_item_by_slot(SLOT_WRISTS),
			"gloves" = target.get_item_by_slot(SLOT_GLOVES),
			"head" = target.get_item_by_slot(SLOT_HEAD),
			"neck" = target.get_item_by_slot(SLOT_NECK),
			"backr" = target.get_item_by_slot(SLOT_BACK_R),
		), list("armor", "shirt", "pants", "shoes", "wrists", "gloves", "head", "neck", "backr"))
		target.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		spawn(40)
			if(QDELETED(target))
				return
			to_chat(target, span_cult("Live deliciously."))

/datum/outfit/job/roguetown/baothanrite_TA/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	head = /obj/item/clothing/head/roguetown/helmet/baotha_ta
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha_ta
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/baotha_ta
	pants = /obj/item/clothing/under/roguetown/skirt/baotha_ta
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/baotha_ta
	gloves = /obj/item/clothing/gloves/roguetown/plate/baotha_ta
	neck = /obj/item/clothing/neck/roguetown/coif/baotha_ta
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/baotha_ta
	backr = /obj/item/rogueweapon/spear/partizan/baotha_ta

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		ADD_TRAIT(H, TRAIT_UNCONVERTIBLE, TRAIT_RITUAL)

/atom/movable/screen/radial/slice/proc/ta_show_choice_tooltip()
	maptext_width = 224
	maptext_height = 20
	var/relative_y = pixel_y - (parent ? parent.py_shift : 0)
	var/text_align = "center"
	maptext_x = (32 - maptext_width) / 2
	if(pixel_x && abs(pixel_x) >= abs(relative_y))
		maptext_y = (32 - maptext_height) / 2
		if(pixel_x > 0)
			maptext_x = 36
			text_align = "left"
		else
			maptext_x = -maptext_width - 4
			text_align = "right"
	else if(relative_y >= 0)
		maptext_y = 34
	else
		maptext_y = -maptext_height - 2
	var/tooltip_text = MAPTEXT_PIXELLARI(html_encode(name))
	maptext = "<div style='text-align:[text_align];color:#ffffff'>[tooltip_text]</div>"

/atom/movable/screen/radial/slice/proc/ta_hide_choice_tooltip()
	maptext = null

/proc/ta_select_zizo_armor(mob/living/user, atom/anchor)
	var/list/armor_options = list(
		"Avantyne Light Armor" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/clothes/cursed_armor/zlighticon.dmi', icon_state = "zlbrigantine"),
		"Avantyne Half-Plate" = image(icon = 'icons/roguetown/clothing/armor.dmi', icon_state = "zizoplatechest_med"),
		"Avantyne Full-Plate" = image(icon = 'icons/roguetown/clothing/armor.dmi', icon_state = "zizoplate"),
	)
	return show_radial_menu(user, anchor, armor_options, require_near = TRUE, tooltips = TRUE)

/proc/ta_select_zizo_helm(mob/living/user, atom/anchor, armor_choice)
	if(armor_choice == "Avantyne Light Armor")
		return "Ascension's Hood"
	var/list/helm_options = list(
		"Avantyne Barbute" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "zizobarbute"),
		"Avantyne Froggemund" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "zizofrogmouth"),
		"Avantyne Volf-Plate" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "volfplate_avantyne"),
		"Avantyne Bascinet" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "zizobascinet"),
	)
	return show_radial_menu(user, anchor, helm_options, require_near = TRUE, tooltips = TRUE)

/proc/ta_select_rite_weapon(mob/living/user, atom/anchor, patron_type)
	var/list/weapon_options = list()
	switch(patron_type)
		if(/datum/patron/inhumen/zizo)
			weapon_options = list(
				"Avantyne Longsword" = image(icon = 'icons/roguetown/weapons/swords64.dmi', icon_state = "zizosword"),
				"Cursed Greatsword" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_weapone_twoh.dmi', icon_state = "zgtsword"),
				"Avantyne Sword and Shield" = image(icon = 'icons/roguetown/weapons/swords32.dmi', icon_state = "zizoarming"),
				"Avantyne Rapier" = image(icon = 'icons/roguetown/weapons/swords64.dmi', icon_state = "zizorapier"),
				"Cursed Axe and Shield" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_weapone.dmi', icon_state = "Zaxe"),
				"Cursed Greataxe" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_weapone_twoh.dmi', icon_state = "Ztaxe"),
				"Cursed Spear" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_weapone_twoh.dmi', icon_state = "Zspear"),
				"Cursed Glaive" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_weapone_twoh.dmi', icon_state = "Zglaive"),
				"Cursed Mace and Shield" = image(icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_weapone.dmi', icon_state = "Zmaul"),
			)
		if(/datum/patron/inhumen/graggar)
			weapon_options = list(
				"Vicious Greataxe" = image(icon = 'icons/roguetown/weapons/axes64.dmi', icon_state = "graggargaxe"),
				"Vicious Axe and Shield" = image(icon = 'icons/roguetown/weapons/axes32.dmi', icon_state = "graggartomahawk"),
			)
	if(!length(weapon_options))
		return null
	return show_radial_menu(user, anchor, weapon_options, radius = patron_type == /datum/patron/inhumen/zizo ? 64 : 32, require_near = TRUE, tooltips = TRUE)

/datum/outfit/job/roguetown/darksteelrite
	var/ta_weapon_choice
	var/ta_weapon_skill = /datum/skill/combat/swords

/datum/outfit/job/roguetown/darksteelrite/proc/ta_apply_weapon_choice()
	ta_weapon_skill = /datum/skill/combat/swords
	switch(ta_weapon_choice)
		if("Avantyne Longsword")
			r_hand = /obj/item/rogueweapon/sword/long/zizo
			l_hand = null
		if("Avantyne Sword and Shield")
			r_hand = /obj/item/rogueweapon/sword/zizo
			l_hand = /obj/item/rogueweapon/shield/kite/zizo
		if("Cursed Greatsword")
			r_hand = /obj/item/rogueweapon/greatsword/zizo
			l_hand = null
		if("Avantyne Rapier")
			r_hand = /obj/item/rogueweapon/sword/rapier/avantyne
			l_hand = null
		if("Cursed Axe and Shield")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle/zizo
			l_hand = /obj/item/rogueweapon/shield/kite/zizo
			ta_weapon_skill = /datum/skill/combat/axes
		if("Cursed Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/zizo
			l_hand = null
			ta_weapon_skill = /datum/skill/combat/axes
		if("Cursed Spear")
			r_hand = /obj/item/rogueweapon/spear/zizo
			l_hand = null
			ta_weapon_skill = /datum/skill/combat/polearms
		if("Cursed Glaive")
			r_hand = /obj/item/rogueweapon/halberd/glaive/zizo
			l_hand = null
			ta_weapon_skill = /datum/skill/combat/polearms
		if("Cursed Mace and Shield")
			r_hand = /obj/item/rogueweapon/mace/steel/zizo
			l_hand = /obj/item/rogueweapon/shield/kite/zizo
			ta_weapon_skill = /datum/skill/combat/maces

/datum/outfit/job/roguetown/viciousrite
	var/ta_weapon_choice

/datum/outfit/job/roguetown/viciousrite/proc/ta_apply_weapon_choice()
	switch(ta_weapon_choice)
		if("Vicious Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar
			l_hand = null
		if("Vicious Axe and Shield")
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/graggar
			l_hand = /obj/item/rogueweapon/shield/iron/graggar

/datum/outfit/job/roguetown/darksteelrite/light/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/cult
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/besilked/cult
	pants = /obj/item/clothing/under/roguetown/brigandinelegs/cult
	head = /obj/item/clothing/head/roguetown/helmet/skullcap/cult
	neck = /obj/item/clothing/neck/roguetown/chaincoif/cult
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo/rite_light
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo/rite_light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo/rite_light
