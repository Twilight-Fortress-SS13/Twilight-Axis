/*
 * Lean port of tgstation's /datum/element/decal. Used by /obj/effect/decal's bake_to_loc.
 *
 * No ELEMENT_DETACH_ON_HOST_DESTROY on purpose: ChangeTurf() qdels the old turf and then
 * copies its signal_procs onto the replacement, so staying registered is what carries the
 * decal through a turf swap - on_turf_change reapplies the overlay on the new turf.
 */
/datum/element/decal
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	var/mutable_appearance/pic

/datum/element/decal/Attach(atom/target, _icon, _icon_state, _dir, _plane = FLOAT_PLANE, _layer = FLOAT_LAYER, _alpha = 255, _color, _pixel_x = 0, _pixel_y = 0, _pixel_w = 0, _pixel_z = 0)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(islist(_color))
		_color = string_list(_color)
	if(!generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _pixel_x, _pixel_y, _pixel_w, _pixel_z))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(apply_overlay), TRUE)
	RegisterSignal(target, COMSIG_TURF_CHANGE, PROC_REF(on_turf_change), TRUE)
	if(target.flags_1 & INITIALIZED_1)
		target.update_icon()
	else
		RegisterSignal(target, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE, PROC_REF(late_update_icon), TRUE)

// Plain appearance values only, never a premade mutable_appearance: bespoke elements dedup
// by their attach arguments, and those must be hashable primitives.
/datum/element/decal/proc/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _pixel_x, _pixel_y, _pixel_w, _pixel_z)
	if(!_icon || !_icon_state)
		return FALSE
	var/image/temp_image = image(_icon, null, _icon_state, _layer, _dir) // dir must come from an image; setting it on a mutable_appearance breaks it as an overlay (BYOND bug, cf. /datum/component/decal)
	pic = new(temp_image)
	pic.plane = _plane
	pic.color = _color
	pic.alpha = _alpha
	pic.pixel_x = _pixel_x
	pic.pixel_y = _pixel_y
	pic.pixel_w = _pixel_w
	pic.pixel_z = _pixel_z
	return TRUE

/datum/element/decal/Detach(atom/source)
	UnregisterSignal(source, list(COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_TURF_CHANGE, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE))
	source.update_icon()
	return ..()

/datum/element/decal/proc/late_update_icon(atom/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE)
	source.update_icon()

/datum/element/decal/proc/apply_overlay(atom/source, list/overlay_list)
	SIGNAL_HANDLER
	overlay_list += pic

/datum/element/decal/proc/on_turf_change(turf/source, path, list/new_baseturfs, flags, list/post_change_callbacks)
	SIGNAL_HANDLER
	post_change_callbacks += CALLBACK(src, PROC_REF(after_turf_change))

// Runs on the replacement turf after ChangeTurf() copied our signal registrations onto it.
/datum/element/decal/proc/after_turf_change(turf/new_turf)
	if(!istype(new_turf))
		return
	if(isclosedturf(new_turf) || isgroundlessturf(new_turf))
		Detach(new_turf)
		return
	new_turf.update_icon()

// Overlay-native twin of GLOB.seasonal_decal_objs, which cannot see baked decals.
GLOBAL_LIST_EMPTY(seasonal_baked_decals)

// Swapping is RemoveElement/AddElement rather than a pic.icon_state write: the pic is shared
// by every turf with the same attach args, and icon_state is part of that key.
/proc/sync_seasonal_baked_decals(snowed)
	for(var/list/record in GLOB.seasonal_baked_decals)
		var/turf/T = record["turf"]
		if(!T || isclosedturf(T) || isgroundlessturf(T))
			GLOB.seasonal_baked_decals -= record
			continue
		var/target_state = (snowed && T.is_seasonally_exposed()) ? record["winter"] : record["summer"]
		if(target_state == record["state"])
			continue
		T.RemoveElement(/datum/element/decal, record["icon"], record["state"], record["dir"], record["plane"], record["layer"], record["alpha"], record["color"], record["px"], record["py"], record["pw"], record["pz"])
		T.AddElement(/datum/element/decal, record["icon"], target_state, record["dir"], record["plane"], record["layer"], record["alpha"], record["color"], record["px"], record["py"], record["pw"], record["pz"])
		record["state"] = target_state
