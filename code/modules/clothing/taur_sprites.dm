/// Also resolve cosmetics in worn armor's aesthetic storage, without treating arbitrary stored items as worn.
/obj/item/proc/get_taur_sprite_wearer()
	var/atom/container = loc
	if(istype(container, /obj/item/clothing/suit/roguetown/armor))
		container = container.loc
	if(ishuman(container))
		return container
	return null

/obj/item/proc/get_taur_worn_icon(default_icon_file)
	return taur_mob_overlay_icon || mob_overlay_icon || default_icon_file

/obj/item/proc/get_taur_base_state(override_state)
	return override_state || icon_state

/// A missing body, permission, or exact body-build state always falls back to the ordinary worn renderer.
/obj/item/proc/get_taur_worn_state(mob/living/carbon/human/wearer, default_icon_file, override_state)
	if(!length(taur_sprite_types))
		return null
	if(!wearer)
		wearer = get_taur_sprite_wearer()
	if(!istype(wearer))
		return null
	var/obj/item/bodypart/taur/taur = wearer.get_taur_tail()
	if(!taur?.taur_sprite_id || !(taur.taur_sprite_id in taur_sprite_types))
		return null
	var/base_state = get_taur_base_state(override_state)
	var/state = "[base_state]_taur_[wearer.is_bulky_body() ? "m" : "f"]_[taur.taur_sprite_id]"
	if(icon_exists(get_taur_worn_icon(default_icon_file), state))
		return state
	return null

/// Use an optional full-size blood mask, or position the item's ordinary blood mask over the humanoid torso.
/obj/item/proc/get_taur_blood_icon(file, state, blood_color, body_offset_x)
	var/static/list/blood_cache = list()
	var/cache_key = "[REF(file)]|[state]|[REF(bloody_icon)]|[bloody_icon_state]|[blood_color]|[body_offset_x]"
	if(blood_cache[cache_key])
		return blood_cache[cache_key]
	var/icon/silhouette = icon(file, state)
	silhouette.Blend("#fff", ICON_ADD)
	var/icon/blood_mask
	if(icon_exists(file, "[state]_blood"))
		blood_mask = icon(file, "[state]_blood")
	else
		blood_mask = icon(file, state)
		blood_mask.Blend("#ffffff00", ICON_MULTIPLY)
		var/list/mask_size = get_icon_dimensions(bloody_icon)
		var/list/sprite_size = get_icon_dimensions(file)
		var/mask_x = mask_size["width"] == sprite_size["width"] ? 1 : 1 - body_offset_x
		blood_mask.Blend(icon(bloody_icon, bloody_icon_state), ICON_OVERLAY, mask_x, 1)
	silhouette.Blend(blood_mask, ICON_MULTIPLY)
	silhouette.Blend(blood_color, ICON_MULTIPLY)
	blood_cache[cache_key] = fcopy_rsc(silhouette)
	return blood_cache[cache_key]

/// Taur sprites use optional separate sleeves in all directions, rather than 32x32 humanoid cutout masks.
/mob/living/carbon/human/proc/get_taur_sleeves_layer(obj/item/item, state, sleeveindex, layer2use)
	var/list/sleeves = list()
	var/file = item.get_taur_worn_icon()
	var/obj/item/bodypart/taur/taur = get_taur_tail()
	if(item.nodismemsleeves && sleeveindex)
		sleeveindex = 4
	var/datum/component/decal/blood/item_blood = item.GetComponent(/datum/component/decal/blood)
	var/has_blood = HAS_BLOOD_DNA(item) || item_blood
	var/blood_color = item_blood?.blood_color || get_blood_color() || "#C80000"
	for(var/side in list("r", "l"))
		if(sleeveindex && sleeveindex != 4 && sleeveindex != (side == "r" ? 2 : 3))
			continue
		var/sleeve_state = "[side]_[state]"
		if(!sleeveindex && item.inhand_mod)
			for(var/obj/item/held as anything in held_items)
				if((get_held_index_of_item(held) % 2) == (side == "r" ? 0 : 1))
					sleeve_state = "x[sleeve_state]"
					break
		if(!icon_exists(file, sleeve_state))
			continue
		var/mutable_appearance/sleeve = mutable_appearance(file, sleeve_state, -layer2use)
		sleeve.pixel_x = taur.offset_x
		if(item.worn_offsets)
			sleeve.pixel_x += item.worn_offsets["x"]
			sleeve.pixel_y += item.worn_offsets["y"]
		sleeve.color = item.color
		sleeve.alpha = item.alpha
		if(item.sleeved_detail && item.get_detail_tag() && icon_exists(file, "[sleeve_state][item.get_detail_tag()]"))
			var/mutable_appearance/detail = mutable_appearance(file, "[sleeve_state][item.get_detail_tag()]", -layer2use)
			detail.color = item.get_detail_color()
			sleeve.add_overlay(detail)
		if(has_blood)
			sleeve.add_overlay(mutable_appearance(item.get_taur_blood_icon(file, sleeve_state, blood_color, taur.offset_x), layer = -layer2use))
		sleeves += sleeve
	return sleeves
