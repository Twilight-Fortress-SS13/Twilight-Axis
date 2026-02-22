// code/modules/icon_morph/icon_morph_filters.dm
// Overlay filtering helpers for building BASE overlays from FULL overlays.

/// Returns TRUE if `layer_value` matches any of the remove layers.
/// We compare absolute layer numbers because project uses negative layers in many appearances.
/proc/morph_layer_matches(layer_value, list/remove_layers)
	if(!islist(remove_layers) || !remove_layers.len)
		return FALSE
	var/L = abs(layer_value)
	for(var/x in remove_layers)
		if(abs(x) == L)
			return TRUE
	return FALSE

/// Deep-copy and filter a single appearance/image/mutable_appearance.
/// Removes any nested overlays whose layer matches remove_layers.
/// Returns a NEW mutable_appearance/image reference (safe, doesn’t mutate original).
/proc/morph_filter_appearance_remove_layers(atom/movable/appearance_ref, list/remove_layers)
	if(!appearance_ref)
		return null

	// mutable_appearance is also an atom/movable in DM land.
	var/atom/movable/out = new /mutable_appearance()
	out.appearance = appearance_ref.appearance

	// If it has overlays, filter them recursively.
	if(islist(out.overlays) && out.overlays.len)
		var/list/new_overlays = list()
		for(var/ov in out.overlays)
			// ov can be:
			// - /mutable_appearance
			// - /image
			// - list (rare, but some code stores overlay lists)
			if(islist(ov))
				// flatten list elements with same rules
				var/list/sub = ov
				for(var/subov in sub)
					if(istype(subov, /atom/movable))
						var/atom/movable/sub_app = subov
						if(morph_layer_matches(sub_app.layer, remove_layers))
							continue
						var/atom/movable/sub_filtered = morph_filter_appearance_remove_layers(sub_app, remove_layers)
						if(sub_filtered)
							new_overlays += sub_filtered
					else
						// unknown entry, keep as-is
						new_overlays += subov
				continue

			if(istype(ov, /atom/movable))
				var/atom/movable/ov_app = ov
				if(morph_layer_matches(ov_app.layer, remove_layers))
					continue
				var/atom/movable/ov_filtered = morph_filter_appearance_remove_layers(ov_app, remove_layers)
				if(ov_filtered)
					new_overlays += ov_filtered
				continue

			// anything else: keep
			new_overlays += ov

		out.overlays = new_overlays

	return out
