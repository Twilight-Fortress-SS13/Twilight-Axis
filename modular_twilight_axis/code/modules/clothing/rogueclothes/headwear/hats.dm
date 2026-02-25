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

/obj/item/clothing/head/roguetown/nunTA
	name = "nun hood"
	desc = ""
	icon_state = "nun_hood"
	item_state = "nun_hood"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	slot_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/nunTA/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDE_HEADTOP)
		flags_inv &= ~HIDE_HEADTOP
	else
		flags_inv |= HIDE_HEADTOP
	user.update_inv_head()

/obj/item/clothing/head/roguetown/roguehood/bishop
	name = "bishop hood"
	desc = ""
	color = null
	icon_state = "bishop_hood"
	item_state = "bishop_hood"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	resistance_flags = FIRE_PROOF
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/bishop/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CHOSEN, "VISAGE")

/obj/item/flowercrown/rosa/resprite
	name = "crown of eora flowers"
	desc = ""
	item_state = "flower_crown_eora"
	icon_state = "flower_crown_eora"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/bardhat/soundbreakerhat
	name = "soundbreaker hat"
	desc = "An oddly shaped hat made of tightly-sewn leather, commonly worn by soundbreakers."
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/antlers
	name = "old antlers"
	desc = "Old antlers which you can wear on helmet, hood....or straight on your head!"
	icon_state = "antlers"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	alternate_worn_layer  = 8.9
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_NECK
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	var/rogavid = list("halo", "knighty")
	var/antlers_final_icon = null
	
/obj/item/clothing/head/roguetown/antlers/attack_right(mob/user)
	..()
	if(!picked)
		var/chooseA = input(user, "What will you choose?", "Where you got it?") as anything in rogavid
		if(chooseA == "halo")
			icon_state = "antlers"
			antlers_final_icon = "antlers"
		if(chooseA == "knighty")
			icon_state = "antlers_knighty"
			antlers_final_icon = "antlers_knighty"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your antlers?", "Antlers", "Yes", "No") != "Yes")
			icon_state = "antlers"
			antlers_final_icon = "antlers"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/antlers/equipped(mob/user, slot)
	. = ..()
	if(antlers_final_icon)
		icon_state = antlers_final_icon
		item_state = antlers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/antlers/dropped(mob/user, slot)
	. = ..()
	if(antlers_final_icon)
		icon_state = antlers_final_icon
		item_state = antlers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/tengai
	name = "tengai"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS
	icon_state = "tengai"
	item_state = "tengai"
	icon = 'modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/gasa
	name = "gasa"
	flags_inv = HIDEEARS
	icon_state = "gasa"
	item_state = "gasa"
	icon = 'modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/torioigasa
	name = "torioigasa"
	flags_inv = HIDEEARS
	icon_state = "torioigasa"
	item_state = "torioigasa"
	icon = 'modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/roningasa
	name = "roningasa"
	flags_inv = HIDEEARS
	icon_state = "roningasa"
	item_state = "roningasa"
	icon = 'modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/sandogasa
	name = "sandogasa"
	flags_inv = HIDEEARS
	icon_state = "sandogasa"
	item_state = "sandogasa"
	icon = 'modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/roguehood/burgerhood
	name = "noble hood"
	desc = "Почувствуй себя молчаливым психопатом, что подливает отраву в еду соседа."
	color = null
	icon_state = "burgerhood"
	item_state = "burgerhood"
	icon = 'modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/kazengun_n_burger.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/datum/crafting_recipe/roguetown/survival/burgerhood //i dunno where to place it helpppp
	name = "noble hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/burgerhood)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 15
