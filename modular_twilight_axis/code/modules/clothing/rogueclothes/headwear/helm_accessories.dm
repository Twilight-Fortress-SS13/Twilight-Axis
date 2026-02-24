/obj/item/clothing/head/roguetown/tw_d_horns
	name = "horns helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_horns"
	item_state = "d_horns"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_basic
	name = "helm's chaperon"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_basic"
	item_state = "d_basic"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_castle_red
	name = "castle helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_castle_red"
	item_state = "d_castle_red"
	flags_inv = HIDEEARS
	var/picked = FALSE
	var/towavid = list("red", "white")
	var/towers_final_icon = null
	
/obj/item/clothing/head/roguetown/tw_d_castle_red/attack_right(mob/user)
	..()
	if(!picked)
		var/chooseA = input(user, "What will you choose?", "Which colour?") as anything in towavid
		if(chooseA == "red")
			icon_state = "d_castle_red"
			towers_final_icon = "d_castle_red"
		if(chooseA == "white")
			icon_state = "d_castle_white"
			towers_final_icon = "d_castle_white"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your burlet?", "Burlet", "Yes", "No") != "Yes")
			icon_state = "d_castle_red"
			towers_final_icon = "d_castle_red"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/tw_d_castle_red/equipped(mob/user, slot)
	. = ..()
	if(towers_final_icon)
		icon_state = towers_final_icon
		item_state = towers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/tw_d_castle_red/dropped(mob/user, slot)
	. = ..()
	if(towers_final_icon)
		icon_state = towers_final_icon
		item_state = towers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/tw_d_graggar
	name = "bloodied star helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_graggar"
	item_state = "d_graggar"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_efreet
	name = "afreet helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_efreet"
	item_state = "d_efreet"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_sun
	name = "sun helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_sun"
	item_state = "d_sun"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_peace
	name = "astrata's eye helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_peace"
	item_state = "d_peace"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_feathers
	name = "feathers accessory"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_feathers"
	item_state = "d_feathers"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_lion
	name = "lion helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_lion"
	item_state = "d_lion"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_dragon_red
	name = "dragon's dread"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_dragon_red"
	item_state = "d_dragon_red"
	flags_inv = HIDEEARS
	var/picked = FALSE
	var/drvid = list("red", "green")
	var/dragon_final_icon = null
	
/obj/item/clothing/head/roguetown/tw_d_dragon_red/attack_right(mob/user)
	..()
	if(!picked)
		var/chooseB = input(user, "What will you choose?", "Which colour?") as anything in drvid
		if(chooseB == "red")
			icon_state = "d_dragon_red"
			dragon_final_icon = "d_dragon_red"
		if(chooseB == "green")
			icon_state = "d_dragon_green"
			dragon_final_icon = "d_dragon_green"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your burlet?", "Burlet", "Yes", "No") != "Yes")
			icon_state = "d_dragon_red"
			dragon_final_icon = "d_dragon_red"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/tw_d_dragon_red/equipped(mob/user, slot)
	. = ..()
	if(dragon_final_icon)
		icon_state = dragon_final_icon
		item_state = dragon_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/tw_d_dragon_red/dropped(mob/user, slot)
	. = ..()
	if(dragon_final_icon)
		icon_state = dragon_final_icon
		item_state = dragon_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/tw_d_swan
	name = "swan on lake"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_swan"
	item_state = "d_swan"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_fish
	name = "gold fish helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_fish"
	item_state = "d_fish"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_windmill
	name = "windmill helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_windmill"
	item_state = "d_windmill"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_oathtaker
	name = "oathtaker symbol"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_oathtaker"
	item_state = "d_oathtaker"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/tw_d_skull
	name = "gold skull helmkleinod"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_skull"
	item_state = "d_skull"
	flags_inv = HIDEEARS

/datum/anvil_recipe/armor/tw_d_horns
	name = "horns helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_horns
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_castle_red
	name = "castle helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_castle_red
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_graggar
	name = "bloodied star helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_graggar
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_sun
	name = "sun helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_sun
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_swan
	name = "swan on lake"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/feather = 2, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_swan
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_fish
	name = "gold fish helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_fish
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_windmill
	name = "windmill helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_windmill
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_oathtaker
	name = "oathtaker symbol"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_oathtaker
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_skull
	name = "gold skull helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_skull
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_lion
	name = "lion helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_lion
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_peace
	name = "astrata's eye helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_peace
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_dragon_red
	name = "dragon's dread"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_dragon_red
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_efreet
	name = "afreet helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/tw_d_efreet
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/tw_d_basic
	name = "helmkleinod chaperon"
	result = /obj/item/clothing/head/roguetown/tw_d_basic
	reqs = list(/obj/item/natural/cloth = 3)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/tw_d_feathers
	name = "swan helmkleinod"
	result = /obj/item/clothing/head/roguetown/tw_d_feathers
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/feather = 4)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 3
