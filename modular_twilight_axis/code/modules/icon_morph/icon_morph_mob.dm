// code/modules/icon_morph/icon_morph_mob.dm
// Human morph cache + fitting worn icons using morph overlay layers.

#define MORPH_SAFE(v, d) (isnull(v) ? (d) : (v))
#define MORPH_DIRS list(SOUTH, NORTH, EAST, WEST)

/// Какие слои формируют "морф-дельту" тела.
/// У вас: butt = BODY_ADJ_LAYER, belly = FRONT_MUTATIONS_LAYER.
/// Грудь обычно тоже в BODY_ADJ_LAYER.
#define MORPH_LAYERS list(BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_FRONT_LAYER)

/// Normalize overlays_standing[layer] into a flat list (no nested lists).
/proc/morph_flatten_overlays(var/entry, list/out)
	if(!out)
		out = list()
	if(isnull(entry))
		return out
	if(islist(entry))
		for(var/v in entry)
			morph_flatten_overlays(v, out)
		return out
	out += entry
	return out

/// Returns a list of appearances for the given mob, taken from overlays_standing for the listed layers.
/proc/morph_collect_layers_overlays(mob/living/carbon/human/H, list/layers)
	var/list/out = list()
	if(!H || !islist(layers))
		return out

	for(var/L in layers)
		// overlays_standing is an indexed array in update_icons system.
		var/entry = H.overlays_standing[L]
		morph_flatten_overlays(entry, out)
	return out

/// Removes any appearances whose abs(layer) matches a layer in layers_to_remove.
/// (Helper so you never have "WHERE IS IT DECLARED" again.)
/proc/morph_filter_overlays_remove_layers(list/in_overlays, list/layers_to_remove)
	if(!islist(in_overlays) || !in_overlays.len)
		return list()

	if(!islist(layers_to_remove) || !layers_to_remove.len)
		return in_overlays.Copy()

	var/list/out = list()
	for(var/thing in in_overlays)
		if(isnull(thing))
			continue
		if(islist(thing))
			// flatten nested lists too
			var/list/tmp = morph_filter_overlays_remove_layers(thing, layers_to_remove)
			if(tmp && tmp.len)
				out += tmp
			continue

		var/mutable_appearance/MA = thing
		// layer is usually negative in this codebase: -LAYER
		var/l = abs(MA.layer)
		// tolerate floats
		l = round(l)

		if(l in layers_to_remove)
			continue

		out += MA

	return out

/// Build /icon from a list of appearances for a given dir.
/proc/flat_from_overlays(list/overlays, dir)
	if(!islist(overlays) || !length(overlays))
		return icon('icons/blanks/32x32.dmi', "nothing")

	var/image/dummy = image('icons/blanks/32x32.dmi', "nothing")
	dummy.dir = dir
	dummy.overlays = overlays
	return getFlatIcon(dummy, defdir = dir, no_anim = TRUE)

/// Cache fields live on human.
/mob/living/carbon/human
	var/tmp/icon/morph_full_icons[4]
	var/tmp/icon/morph_base_icons[4]
	var/tmp/icon/morph_delta_masks[4]
	var/tmp/morph_cache_key = null

/// Key that changes when morph-relevant body shape changes.
/mob/living/carbon/human/proc/get_morph_cache_key()
	var/species_type = dna?.species?.type || "nospecies"
	var/g = gender || "nogender"

	var/boob = 0
	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	if(B)
		boob = B.breast_size

	// belly/butt in your fork appear to be organ-based (sprite_accessory uses organ.belly_size/butt_size).
	var/belly = 0
	var/butt = 0

	var/obj/item/organ/belly/BEL = getorganslot(ORGAN_SLOT_BELLY)
	if(BEL)
		belly = BEL.belly_size
	else
		var/list/F = dna?.features
		if(islist(F))
			belly = F["belly"]

	var/obj/item/organ/butt/BT = getorganslot(ORGAN_SLOT_BUTT)
	if(BT)
		butt = BT.butt_size
	else
		var/list/F2 = dna?.features
		if(islist(F2))
			butt = F2["butt"]

	return "[g]|[species_type]|b[MORPH_SAFE(boob,0)]|be[MORPH_SAFE(belly,0)]|bu[MORPH_SAFE(butt,0)]"

/// Rebuild morph cache from current overlays_standing morph layers.
/// FULL = overlays from MORPH_LAYERS
/// BASE = FULL but without MORPH_LAYERS (=> empty). That makes delta == morph silhouette.
#define MORPH_FULL_LAYERS list(BODYPARTS_LAYER, BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_FRONT_LAYER)
#define MORPH_REMOVE_LAYERS list(BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_FRONT_LAYER)

/mob/living/carbon/human/proc/rebuild_morph_cache_from_current()
	var/key = get_morph_cache_key()
	if(morph_cache_key == key && morph_delta_masks[1])
		return

	morph_cache_key = key
	var/list/full_overlays = morph_collect_layers_overlays(src, list(BODYPARTS_LAYER, BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_FRONT_LAYER))
	var/list/base_overlays = morph_filter_overlays_remove_layers(full_overlays, list(BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_FRONT_LAYER))
	morph_add_forced_breasts(full_overlays, src)
	for(var/i in 1 to 4)
		var/d = MORPH_DIRS[i]
		morph_full_icons[i] = flat_from_overlays(full_overlays, d)
		morph_base_icons[i] = flat_from_overlays(base_overlays, d)
		morph_delta_masks[i] = icon_build_delta_mask(morph_full_icons[i], morph_base_icons[i])

#undef MORPH_FULL_LAYERS
#undef MORPH_REMOVE_LAYERS

/// Fit worn icon (all 4 dirs) based on cached deltas.
/// icon_file: dmi
/// icon_state: state name (already includes _f/custom suffix etc if needed)
/// debug_red: TRUE paints delta pixels red (so you can verify it’s actually hitting)
/mob/living/carbon/human/proc/autofit_worn_icon(icon_file, icon_state, sleeveindex, radius = 3, debug_red = FALSE, debug_paint_over = FALSE)
	rebuild_morph_cache_from_current()
	if(!morph_delta_masks[1])
		return null

	var/icon/out = icon('icons/blanks/32x32.dmi', "nothing")

	for(var/i in 1 to 4)
		var/d = MORPH_DIRS[i]
		var/icon/base = icon(icon_file, icon_state, d)

		var/icon/delta = morph_delta_masks[i]
		if(delta)
			base = icon_apply_delta_to_clothing(base, delta, radius, TRUE, debug_red, debug_paint_over)

		out.Insert(base, dir = d)

	return out

/mob/living/carbon/human/proc/rebuild_morph_cache_from_bodyparts(list/full_overlays, list/base_overlays)
	var/key = get_morph_cache_key()
	if(morph_cache_key == key && morph_delta_masks[1])
		return

	morph_cache_key = key

	// Safety: tolerate nulls
	if(!islist(full_overlays))
		full_overlays = list()
	if(!islist(base_overlays))
		base_overlays = list()

	for(var/i in 1 to 4)
		var/d = MORPH_DIRS[i]
		morph_full_icons[i] = flat_from_overlays(full_overlays, d)
		morph_base_icons[i] = flat_from_overlays(base_overlays, d)
		morph_delta_masks[i] = icon_build_delta_mask(morph_full_icons[i], morph_base_icons[i])

#undef MORPH_LAYERS
#undef MORPH_DIRS
#undef MORPH_SAFE

/mob/living/carbon/human/proc/debug_organs_morph()
	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	var/obj/item/organ/belly/BE = getorganslot(ORGAN_SLOT_BELLY)
	var/obj/item/organ/butt/BU = getorganslot(ORGAN_SLOT_BUTT)

	to_chat(src, "BREASTS: [B ? "YES size=[B.breast_size]" : "NO"]")
	to_chat(src, "BELLY: [BE ? "YES size=[BE.belly_size]" : "NO"]")
	to_chat(src, "BUTT: [BU ? "YES size=[BU.butt_size]" : "NO"]")
