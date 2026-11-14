/obj/item/clothing/suit/roguetown/armor/brigandine/light/handmade
	slot_flags = ITEM_SLOT_ARMOR
	name = "\"Jack-Of-Plate\" brigandine"
	desc = "This brigandine is an example of the painstaking work of a skilled, and very poor, craftsman. The gambeson, lined with metal parts and scraps of chain mail, is impossible to ruin even with such artistry."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "light_brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_CHEST_LIGHT_IRON + ARMOR_INT_CHEST_PLATE_BRIGANDINE_WEIGHT_MODIFIER
	smeltresult = /obj/item/ingot/iron
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_LIGHT
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi
	name = "hara-yoroi cuirass"
	desc = "A practical lightweight cuirass favored by disciplined mercenaries and provincial retainers of Kazengun. Layered blacksteel-coated steel plates to dull the shine of war, offer reliable protection without the burden of full battle harness."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "kazengunlight"
	boobed = TRUE
	item_state = "kazengunlight"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 25
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Uniform colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
