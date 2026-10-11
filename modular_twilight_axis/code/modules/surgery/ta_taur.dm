/obj/item/bodypart/taur/feline
	name = "Panther"
	desc = ""
	icon = 'modular_twilight_axis/icons/mob/feline_taur.dmi'
	clip_mask_icon = 'modular_twilight_axis/icons/mob/feline_taur.dmi'
	taur_icon_state = "feline_taur_s"
	clip_mask_state = "clip_mask_feline"
	has_taur_color = TRUE

/obj/item/bodypart/taur/feline/furry
	name = "Feline"
	desc = ""
	icon = 'modular_twilight_axis/icons/mob/feline_taur.dmi'
	clip_mask_icon = 'modular_twilight_axis/icons/mob/feline_taur.dmi'
	taur_icon_state = "feline_taur_furry_s"
	clip_mask_state = "clip_mask_feline"
	has_taur_color = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/full/taur
	name = "tauric plate armor"
	bloody_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	bloody_icon_state = "blood_taur"
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "platetaur"

/obj/item/clothing/suit/roguetown/armor/plate/full/taur/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	return image

/obj/item/clothing/suit/roguetown/armor/plate/full/taur/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/feline))
		if(!disable_warning)
			to_chat(M, span_warning("This armor can fit only catlike creatures!."))
		return FALSE
	return ..()

/obj/item/enchantingkit/taur_armor_plate
	name = "'tauric plate armor morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of an steel plate armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full			= /obj/item/clothing/suit/roguetown/armor/plate/full/taur)
	icon_loadout = /obj/item/clothing/suit/roguetown/armor/plate/full/taur

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/taur
	name = "tauric padded gambeson"
	bloody_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	bloody_icon_state = "blood_taur"
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "gambtaur"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/taur/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	return image

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/taur/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/feline))
		if(!disable_warning)
			to_chat(M, span_warning("This armor can fit only catlike creatures!."))
		return FALSE
	return ..()

/obj/item/enchantingkit/taur_armor_gambeson
	name = "'tauric gambeson morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of an padded gambeson."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy			= /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/taur)
	icon_loadout = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/taur

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur
	name = "tauric haugerk"
	bloody_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	bloody_icon_state = "blood_taur"
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "chaintaur"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	return image

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/feline))
		if(!disable_warning)
			to_chat(M, span_warning("This armor can fit only catlike creatures!."))
		return FALSE
	return ..()

/obj/item/clothing/cloak/t_tabard/taur
	name = "tauric tabard"
	bloody_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	bloody_icon_state = "blood_taur"
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "coattaur"
	detail_tag = "_detail"
	color = "#262927"
	detail_color = "#9c2525"

/obj/item/clothing/cloak/t_tabard/taur/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	return image

/obj/item/clothing/cloak/t_tabard/taur/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/feline))
		if(!disable_warning)
			to_chat(M, span_warning("This armor can fit only catlike creatures!."))
		return FALSE
	return ..()

/obj/item/clothing/cloak/t_tabard/taur/tightened
	name = "tauric tightened tabard"
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "coattaurup"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur
	name = "tauric iron hauberk"
	bloody_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	bloody_icon_state = "blood_taur"
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "ichaintaur"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	return image

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/feline))
		if(!disable_warning)
			to_chat(M, span_warning("This armor can fit only catlike creatures!."))
		return FALSE
	return ..()

/obj/item/enchantingkit/taur_armor_hauberk
	name = "'tauric hauberk morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of a hauberk."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron			= /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk			= /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur)
	icon_loadout = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur

/obj/item/clothing/shoes/roguetown/felinetaur
	name = "four footwraps"
	desc = "Two pair of pawraps for feline like creatures....r-r-r."
	icon = 'modular_twilight_axis/icons/clothing/feline_taur_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
	icon_state = "footwrapstaur"
	item_state = "footwrapstaur"
	clothing_flags = TAUR_COMPATIBLE

/obj/item/clothing/shoes/roguetown/felinetaur/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	return image

/obj/item/clothing/shoes/roguetown/felinetaur/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/feline))
		if(!disable_warning)
			to_chat(M, span_warning("This armor can fit only catlike creatures!."))
		return FALSE
	return ..()

/obj/item/clothing/shoes/roguetown/felinetaur/plate
	name = "four steel plate boots"
	desc = "A two pair of robust steel shoes without a sock. For catlike creatures!"
	icon_state = "platebootstaur"
	item_state = "platebootstaur"
	max_integrity = ARMOR_INT_LEG_STEEL_CHAIN
	sewrepair = FALSE
	armor = ARMOR_PLATE
	clothing_flags = TAUR_COMPATIBLE
	smeltresult = /obj/item/ingot/steel

/datum/anvil_recipe/armor/steel/horseshoes
	name = "Feline tauric plate boots"
	category = "Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/shoes/roguetown/felinetaur/plate
	display_category = ITEM_CAT_SMITHING_MISC
