/obj/item/clothing/head/roguetown/stewardtophat
	name = "top hat"
	icon_state = "stewardtophat"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/noble.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/eaststrawhat
	name = "worn rice hat"
	desc = "A wicker rice hat."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "eaststrawhat"
	flags_inv = HIDEEARS
	var/hides_ears = TRUE

/obj/item/clothing/head/roguetown/eaststrawhat/MiddleClick(mob/user, params)
	. = ..()
	hides_ears = !hides_ears
	flags_inv = hides_ears ? HIDEEARS : null

/obj/item/clothing/head/roguetown/grenzelhofthat/decorated
	armor = null
	prevent_crits = null

/obj/item/clothing/head/roguetown/twilight_elven_hat
	name = "elven burka"
	desc = "A warm hat, designed to protect long elven ears from cold winds of northen Valoria."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	icon_state = "elven_hat"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat
	name = "kokoshnik"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	icon_state = "white_mage_headwear"
	flags_inv = HIDEEARS
	var/hammerhold_colors = list("white", "blue")
	var/hammerhold_variants = null
	var/picked = FALSE
	var/hammerhold_final_icon = null

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/attack_right(mob/user)
	..()
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			icon_state = "white_mage_headwear"
		if(choiceC == "blue")
			icon_state = "blue_mage_headwear"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your kokoshnik?", "Kokoshnik", "Yes", "No") != "Yes")
			icon_state = "white_mage_headwear"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE


/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/peasant
	name = "hammerhold hat"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	icon_state = "headwear_a"
	flags_inv = HIDEEARS
	hammerhold_colors = null
	hammerhold_variants = list("a", "b")
	picked = FALSE

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/attack_right(mob/user)
	if(!picked)
		var/choiceV = input(user, "Choose a variant.", "Hammerhold colors") as anything in hammerhold_variants
		if(choiceV == "a")
			icon_state = "headwear_a"
			hammerhold_final_icon = "headwear_a"
		if(choiceV == "b")
			icon_state = "headwear_b"
			hammerhold_final_icon = "headwear_b"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your hat?", "hat", "Yes", "No") != "Yes")
			icon_state = "headwear_a"
			hammerhold_final_icon = "headwear_a"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/equipped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/dropped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()
