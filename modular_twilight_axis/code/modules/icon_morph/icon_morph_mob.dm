#define MORPH_SAFE(v, d) (isnull(v) ? (d) : (v))
#define MORPH_DIRS list(SOUTH, NORTH, EAST, WEST)

#define MORPH_LAYERS list(BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_LAYER)
#define MORPH_FULL_LAYERS list(BODYPARTS_LAYER, BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_LAYER)
#define MORPH_REMOVE_LAYERS list(BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_LAYER)

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

/proc/morph_collect_layers_overlays(mob/living/carbon/human/H, list/layers)
	var/list/out = list()
	if(!H || !islist(layers))
		return out
	for(var/L in layers)
		var/entry = H.overlays_standing[L]
		morph_flatten_overlays(entry, out)
	return out

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
			var/list/tmp = morph_filter_overlays_remove_layers(thing, layers_to_remove)
			if(tmp && tmp.len)
				out += tmp
			continue

		var/mutable_appearance/MA = thing
		var/l = abs(MA.layer)
		l = round(l)

		if(l in layers_to_remove)
			continue

		out += MA

	return out

/proc/flat_from_overlays(list/overlays, dir)
	if(!islist(overlays) || !length(overlays))
		return icon('icons/blanks/32x32.dmi', "nothing")

	var/image/dummy = image('icons/blanks/32x32.dmi', "nothing")
	dummy.dir = dir
	dummy.overlays = overlays
	return getFlatIcon(dummy, defdir = dir, no_anim = TRUE)

/mob/living/carbon/human
	var/tmp/icon/morph_full_icons[4]
	var/tmp/icon/morph_base_icons[4]
	var/tmp/icon/morph_delta_masks[4]
	var/tmp/morph_cache_key = null

/mob/living/carbon/human/proc/get_morph_cache_key()
	var/species_type = dna?.species?.type || "nospecies"
	var/g = gender || "nogender"

	var/boob = 0
	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	if(B)
		boob = B.breast_size

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

/mob/living/carbon/human/proc/rebuild_morph_cache_from_current()
	var/key = get_morph_cache_key()
	if(morph_cache_key == key && morph_delta_masks[1])
		return

	morph_cache_key = key

	var/list/full_overlays = morph_collect_layers_overlays(src, MORPH_FULL_LAYERS)
	var/list/base_overlays = morph_filter_overlays_remove_layers(full_overlays, MORPH_REMOVE_LAYERS)
	for(var/i in 1 to 4)
		var/d = MORPH_DIRS[i]
		morph_full_icons[i] = flat_from_overlays(full_overlays, d)
		morph_base_icons[i] = flat_from_overlays(base_overlays, d)
		morph_delta_masks[i] = icon_build_delta_mask(morph_full_icons[i], morph_base_icons[i])

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
			base = icon_apply_delta_to_clothing(base, delta, d, radius, TRUE, debug_red, debug_paint_over)

		out.Insert(base, dir = d)

	return out

#undef MORPH_FULL_LAYERS
#undef MORPH_REMOVE_LAYERS
#undef MORPH_LAYERS
#undef MORPH_DIRS
#undef MORPH_SAFE
