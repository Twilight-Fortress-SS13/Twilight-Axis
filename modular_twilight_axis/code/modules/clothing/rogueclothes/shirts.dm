/obj/item/clothing/suit/roguetown/shirt/dress/stewarddress
	name = "steward's dress"
	desc = "A victorian-styled black dress with shining bronze buttons."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/noble.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/noble.dmi'
	icon_state = "stewarddress"
	sleeved = FALSE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT

/obj/item/clothing/suit/roguetown/shirt/twilight_elven
	name = "elven suit"
	desc = "A common garnament for Etruscan countryside, each of these suits is woven in adherence to tradition."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	icon_state = "suit"
	item_state = "suit"
	allowed_race = NON_DWARVEN_RACE_TYPES
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS
	var/elven_colors = list("blue", "red", "beige", "black", "green")
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat
	name = "elven coat"
	desc = "A common garnament for Etruscan countryside, each of these durable coats is woven in adherence to tradition."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "coat"
	item_state = "coat"
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	elven_colors = list("blue", "red", "beige", "white", "green", "gray")

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt
	name = "elven furcoat"
	desc = "A common garnament for Etruscan countryside, each of these durable coats is woven in adherence to tradition. Luxurious leovarg fur makes it fit for colder regions as well as self-entitled nobility."
	icon_state = "coat_alt"
	item_state = "coat_alt"
	elven_colors = list("blue", "red", "beige", "white")

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold
	name = "hammerhold shirt"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	icon_state = "white_shirt_a"
	item_state = "white_shirt_a"
	allowed_race = NON_DWARVEN_RACE_TYPES
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|GROIN|VITALS
	flags_inv= HIDEBOOB|HIDECROTCH
	var/hammerhold_colors = list("white", "black", "red")
	var/hammerhold_variants = list("a", "b", "c", "d")
	var/picked = FALSE
	var/hammerhold_final_icon = null // eto pizdec blyat ia ebal

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/attack_right(mob/user)
	..()
	if(!picked)
		var/iconH = icon_state
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			iconH = "white_shirt"
			hammerhold_variants += list("e", "g")
		if(choiceC == "black")
			iconH = "black_shirt"
			hammerhold_variants += list("e", "g")
		if(choiceC == "red")
			iconH = "red_shirt"
		var/choiceV = input(user, "Choose a variant.", "Hammerhold variants") as anything in hammerhold_variants
		iconH = iconH + "_[choiceV]"
		icon_state = iconH
		item_state = iconH
		base_icon_state = iconH
		hammerhold_final_icon = iconH
		update_icon()
		if(alert("Are you pleased with your shirt?", "Shirt", "Yes", "No") != "Yes")
			icon_state = "white_shirt_a"
			item_state = "white_shirt_a"
			base_icon_state = "white_shirt_a"
			hammerhold_final_icon = "white_shirt_a"
			update_icon()
			return
		picked = TRUE
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/equipped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dropped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/coat
	name = "boyar coat"
	desc = "Боярский плащ вдохновленный эльфийской культурой, который носят знатные представители Хаммерхолда"
	icon_state = "coat_a"
	item_state = "coat_a"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	hammerhold_colors = list("red", "beige")
	hammerhold_variants = null

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/coat/attack_right(mob/user)
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "beige")
			icon_state = "coat_a"
			item_state = "coat_a"
			hammerhold_final_icon = "coat_a"
		if(choiceC == "red")
			icon_state = "coat_b"
			item_state = "coat_b"
			hammerhold_final_icon = "coat_b"
		update_icon()
		if(alert("Are you pleased with your coat?", "Coat", "Yes", "No") != "Yes")
			icon_state = "coat_a"
			item_state = "coat_a"
			hammerhold_final_icon = "coat_a"
			update_icon()
			return
		picked = TRUE
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress
	name = "hammerhold dress"
	desc = ""
	icon_state = "white_dress_a"
	item_state = "white_dress_a"
	allowed_race = NON_DWARVEN_RACE_TYPES
	allowed_sex = list(FEMALE)
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|GROIN|VITALS
	hammerhold_colors = list("white", "black", "blue", "red")
	hammerhold_variants = list("a", "b")

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/attack_right(mob/user)
	if(!picked)
		var/iconH = icon_state
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			iconH = "white_dress"
			hammerhold_variants += list("c")
		if(choiceC == "black")
			iconH = "black_dress"
			hammerhold_variants += list("c")
		if(choiceC == "blue")
			iconH = "blue_dress"
		if(choiceC == "red")
			iconH = "red_dress"
		var/choiceV = input(user, "Choose a variant.", "Hammerhold variants") as anything in hammerhold_variants
		iconH = iconH + "_[choiceV]"
		icon_state = iconH
		item_state = iconH
		hammerhold_final_icon = iconH
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
		if(alert("Are you pleased with your dress?", "Dress", "Yes", "No") != "Yes")
			icon_state = "white_dress_a"
			item_state = "white_dress_a"
			hammerhold_final_icon = "white_dress_a"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_shirt()
			return
		picked = TRUE

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/furcoat
	name = "hammerhold mage coat"
	desc = ""
	icon_state = "white_mage_coat"
	item_state = "white_mage_coat"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	hammerhold_colors = list("white", "blue")
	hammerhold_variants = null

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/furcoat/attack_right(mob/user)
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			icon_state = "white_mage_coat"
			item_state = "white_mage_coat"
			hammerhold_final_icon = "white_mage_coat"
		if(choiceC == "blue")
			icon_state = "blue_mage_coat"
			item_state = "blue_mage_coat"
			hammerhold_final_icon = "blue_mage_coat"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
		if(alert("Are you pleased with your furcoat?", "Furcoat", "Yes", "No") != "Yes")
			icon_state = "white_mage_coat"
			item_state = "white_mage_coat"
			hammerhold_final_icon = "white_mage_coat"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_shirt()
			return
		picked = TRUE

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/robe
	name = "hammerhold robe"
	desc = ""
	icon_state = "white_mage_robe"
	item_state = "white_mage_robe"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	hammerhold_colors = list("white", "blue")
	hammerhold_variants = null

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/robe/attack_right(mob/user)
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			icon_state = "white_mage_robe"
			item_state = "white_mage_robe"
			hammerhold_final_icon = "white_mage_robe"
		if(choiceC == "blue")
			icon_state = "blue_mage_robe"
			item_state = "blue_mage_robe"
			hammerhold_final_icon = "blue_mage_robe"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()
		if(alert("Are you pleased with your furcoat?", "Furcoat", "Yes", "No") != "Yes")
			icon_state = "white_mage_robe"
			item_state = "white_mage_robe"
			hammerhold_final_icon = "white_mage_robe"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_shirt()
				H.update_inv_armor()
			return
		picked = TRUE
