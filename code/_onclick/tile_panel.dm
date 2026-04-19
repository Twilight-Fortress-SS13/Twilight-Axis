#define TILE_PANEL_UI_ID "TilePanel"
#define TILE_PANEL_UI_NAME "TilePanel"
#define TILEPANEL_ACT_CLOSE "close"
#define TILEPANEL_ACT_INTERACT "interact"
#define TILEPANEL_ACT_DROP "drop"
#define TILEPANEL_REFRESH_THROTTLE_DS 10

/mob
	var/datum/tile_panel/tile_panel

/mob/proc/get_tile_panel()
	if(!tile_panel)
		tile_panel = new(src)
	return tile_panel

/mob/proc/tile_panel_notify_changed(atom/context = null)
	if(!tile_panel)
		return
	tile_panel.request_refresh(context)

/mob/proc/can_open_tile_panel_turf(turf/T)
	if(!T || !client)
		return FALSE

	if(TurfAdjacent(T))
		return TRUE

	if(istype(src, /mob/dead/observer) && client?.holder)
		return TRUE

	return FALSE

/mob/proc/open_tile_panel_for(atom/A)
	if(!client)
		return FALSE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	if(!can_open_tile_panel_turf(T))
		return FALSE

	listed_turf = T
	client.statpanel = T.name

	var/datum/tile_panel/P = get_tile_panel()
	return P.open(T)

/datum/tile_panel
	var/mob/owner
	var/turf/target_turf
	var/last_refresh_at = 0
	var/refresh_queued = FALSE
	var/last_context_ref
	var/refresh_throttle_ds = TILEPANEL_REFRESH_THROTTLE_DS
	var/list/appearance_cache
	var/list/appearance_pool
	var/list/appearance_containers
	var/list/row_cache

/datum/tile_panel/New(mob/user)
	owner = user
	appearance_cache = list()
	appearance_pool = list()
	appearance_containers = list()
	row_cache = list()
	..()

/datum/tile_panel/Destroy()
	if(owner?.tile_panel == src)
		owner.tile_panel = null

	_clear_appearance_containers()

	owner = null
	target_turf = null
	appearance_cache = null
	appearance_pool = null
	appearance_containers = null
	row_cache = null
	return ..()

/datum/tile_panel/proc/set_target(turf/T)
	if(!T)
		return FALSE
	target_turf = T
	return TRUE

/datum/tile_panel/proc/open(turf/T)
	if(!owner || !owner.client)
		return FALSE

	if(T)
		set_target(T)

	if(!target_turf)
		return FALSE

	if(!owner.can_open_tile_panel_turf(target_turf))
		return FALSE

	ui_interact(owner)
	request_refresh()
	return TRUE

/datum/tile_panel/proc/close()
	if(owner)
		SStgui.close_uis(src)

/datum/tile_panel/proc/_is_open()
	if(!owner || !owner.client)
		return FALSE
	return !!SStgui.get_open_ui(owner, src)

/datum/tile_panel/ui_state(mob/user)
	return GLOB.default_state

/datum/tile_panel/ui_status(mob/user, datum/ui_state/state)
	if(!user || !user.client)
		return UI_CLOSE

	if(user != owner)
		return UI_CLOSE

	if(!target_turf)
		return UI_CLOSE

	if(!user.can_open_tile_panel_turf(target_turf))
		return UI_CLOSE

	return UI_INTERACTIVE

/datum/tile_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, TILE_PANEL_UI_ID, TILE_PANEL_UI_NAME)
		ui.open()
		if(user?.client)
			user.client.refocus_map()

/datum/tile_panel/ui_close(mob/user)
	. = ..()
	_clear_appearance_containers()
	target_turf = null

/datum/tile_panel/ui_data(mob/user)
	. = list()

	if(!target_turf)
		.["has_target"] = FALSE
		return

	.["has_target"] = TRUE
	.["name"] = target_turf.name

	var/list/atoms = list()
	var/list/current_refs = list()
	var/list/current_visual_keys = list()

	var/list/turf_row = _get_or_build_row(target_turf, TRUE)
	if(turf_row)
		atoms += list(turf_row)
		current_refs[REF(target_turf)] = TRUE

		var/turf_visual_key = _build_visual_cache_key(target_turf)
		if(turf_visual_key)
			current_visual_keys[turf_visual_key] = TRUE

	for(var/atom/A in target_turf)
		if(!_should_include_atom(A))
			continue

		var/list/row = _get_or_build_row(A, FALSE)
		if(!row)
			continue

		atoms += list(row)
		current_refs[REF(A)] = TRUE

		var/visual_key = _build_visual_cache_key(A)
		if(visual_key)
			current_visual_keys[visual_key] = TRUE

	_prune_stale_caches(current_refs, current_visual_keys)

	.["atoms"] = atoms

/datum/tile_panel/proc/_build_mouse_params(list/params)
	var/button = text2num(params["button"])
	var/shift = text2num(params["shift"])
	var/ctrl = text2num(params["ctrl"])
	var/alt = text2num(params["alt"])

	var/list/L = list()
	if(button == 2)
		L["right"] = "1"
	else if(button == 1)
		L["middle"] = "1"
	else
		L["left"] = "1"

	if(shift)
		L["shift"] = "1"
	if(ctrl)
		L["ctrl"] = "1"
	if(alt)
		L["alt"] = "1"

	var/icon_x = params["icon-x"]
	var/icon_y = params["icon-y"]
	if(!icon_x)
		icon_x = "16"
	if(!icon_y)
		icon_y = "16"
	L["icon-x"] = "[icon_x]"
	L["icon-y"] = "[icon_y]"

	return L

/datum/tile_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if(TILEPANEL_ACT_CLOSE)
			close()
			return TRUE

		if(TILEPANEL_ACT_INTERACT)
			var/ref_text = params["ref"]
			if(!ref_text)
				return TRUE

			var/atom/target = locate(ref_text)
			if(!istype(target) || QDELETED(target))
				return TRUE

			if(!owner || !owner.client || !target_turf)
				return TRUE

			if(!owner.can_open_tile_panel_turf(target_turf))
				return TRUE

			if(target != target_turf && target.loc != target_turf)
				return TRUE

			var/list/click_params = _build_mouse_params(params)
			var/obj/item/W = owner.get_active_held_item()

			if(W && click_params["left"] && istype(target, /obj/structure/table))
				target.attackby(W, owner, click_params)
				return TRUE

			owner.ClickOn(target, click_params)
			return TRUE

		if(TILEPANEL_ACT_DROP)
			var/src_ref_text = params["src"]
			var/over_ref_text = params["over"]
			if(!src_ref_text || !over_ref_text)
				return TRUE

			var/atom/src_atom = locate(src_ref_text)
			var/atom/over_atom = locate(over_ref_text)
			if(!istype(src_atom) || QDELETED(src_atom))
				return TRUE
			if(!istype(over_atom) || QDELETED(over_atom))
				return TRUE

			if(!owner || !owner.client || !target_turf)
				return TRUE

			if(!owner.can_open_tile_panel_turf(target_turf))
				return TRUE

			if(src_atom != target_turf && src_atom.loc != target_turf)
				return TRUE
			if(over_atom != target_turf && over_atom.loc != target_turf)
				return TRUE

			var/list/drop_params = _build_mouse_params(params)

			var/mob/old_usr = usr
			usr = owner
			src_atom.MouseDrop(over_atom, null, null, null, null, list2params(drop_params))
			usr = old_usr
			return TRUE

	return TRUE

/datum/tile_panel/proc/request_refresh(atom/context = null)
	if(!owner || !owner.client)
		return FALSE
	if(!_is_open())
		return FALSE

	if(context)
		last_context_ref = REF(context)

	var/now = world.time
	var/next_allowed = last_refresh_at + refresh_throttle_ds
	if(now >= next_allowed)
		last_refresh_at = now
		refresh_queued = FALSE
		SStgui.try_update_ui(owner, src, null)
		return TRUE

	if(!refresh_queued)
		refresh_queued = TRUE
		addtimer(CALLBACK(src, PROC_REF(_queued_refresh)), next_allowed - now)

	return TRUE

/datum/tile_panel/proc/_queued_refresh()
	refresh_queued = FALSE
	if(!owner || !owner.client)
		return
	if(!_is_open())
		return

	last_refresh_at = world.time
	SStgui.try_update_ui(owner, src, null)

/datum/tile_panel/proc/_clear_appearance_containers()
	if(!owner?.hud_used?.vis_holder)
		appearance_cache = list()
		appearance_pool = list()
		appearance_containers = list()
		row_cache = list()
		return

	for(var/atom/movable/screen/container as anything in appearance_containers)
		if(QDELETED(container))
			continue
		owner.hud_used.vis_holder.vis_contents -= container
		qdel(container)

	appearance_cache = list()
	appearance_pool = list()
	appearance_containers = list()
	row_cache = list()

/datum/tile_panel/proc/_should_include_atom(atom/A)
	if(!A)
		return FALSE
	if(istype(A, /obj/effect))
		return FALSE
	if(istype(A, /atom/movable/lighting_object))
		return FALSE
	if(QDELETED(A))
		return FALSE
	if(!A.mouse_opacity)
		return FALSE
	if(ismob(owner) && A.invisibility > owner.see_invisible)
		return FALSE
	return TRUE

/datum/tile_panel/proc/_build_visual_cache_key(atom/A)
	if(!A || QDELETED(A))
		return null

	var/mutable_appearance/ap = A.appearance
	if(!ap)
		return "[A.type]|[A.icon]|[A.icon_state]|[A.dir]|[A.color]|[A.alpha]|0|0"

	var/list/key_parts = list(
		"[A.type]",
		"[ap.icon]",
		"[ap.icon_state]",
		"[ap.dir]",
		"[ap.color]",
		"[ap.alpha]",
		"[ap.pixel_x]",
		"[ap.pixel_y]",
		"[ap.layer]",
		"[ap.plane]",
		"[ap.transform]",
		"[ap.blend_mode]",
		"[length(ap.overlays)]",
		"[length(ap.underlays)]"
	)

	return key_parts.Join("|")

/datum/tile_panel/proc/_needs_filtered_appearance(mutable_appearance/ap)
	if(!ap)
		return FALSE

	if(length(ap.overlays) || length(ap.underlays))
		return TRUE

	if(!(ap.plane in list(FLOAT_PLANE, GAME_PLANE, FLOOR_PLANE)))
		return TRUE

	return FALSE

/datum/tile_panel/proc/_make_filtered_appearance(atom/A)
	if(!A || QDELETED(A))
		return null

	var/mutable_appearance/ap = A.appearance
	if(!ap)
		return null

	if(!_needs_filtered_appearance(ap))
		var/mutable_appearance/ma = new
		ma.appearance = ap
		return ma

	return copy_appearance_filter_overlays(ap)

/datum/tile_panel/proc/_create_appearance_container(atom/A, visual_key)
	if(!owner?.hud_used?.vis_holder)
		return null

	var/mutable_appearance/ma = _make_filtered_appearance(A)
	if(!ma)
		return null

	var/atom/movable/screen/container = new
	container.appearance = ma

	owner.hud_used.vis_holder.vis_contents += container
	appearance_containers += container

	if(visual_key)
		appearance_pool[visual_key] = container

	return container

/datum/tile_panel/proc/_get_cached_appearance_ref(atom/A)
	if(!A || QDELETED(A))
		return null
	if(!owner?.client || !owner?.hud_used?.vis_holder)
		return null

	var/refid = REF(A)
	var/visual_key = _build_visual_cache_key(A)
	if(!visual_key)
		return null

	var/list/ref_entry = appearance_cache[refid]
	if(islist(ref_entry))
		if(ref_entry["key"] == visual_key)
			var/atom/movable/screen/existing_ref_container = ref_entry["container"]
			if(existing_ref_container && !QDELETED(existing_ref_container))
				return ref_entry["appearance_ref"]

	var/atom/movable/screen/pooled_container = appearance_pool[visual_key]
	if(pooled_container && !QDELETED(pooled_container))
		var/pooled_ref = "\ref[pooled_container]"
		appearance_cache[refid] = list(
			"key" = visual_key,
			"appearance_ref" = pooled_ref,
			"container" = pooled_container
		)
		return pooled_ref

	var/atom/movable/screen/new_container = _create_appearance_container(A, visual_key)
	if(!new_container)
		return null

	var/new_ref = "\ref[new_container]"
	appearance_cache[refid] = list(
		"key" = visual_key,
		"appearance_ref" = new_ref,
		"container" = new_container
	)

	return new_ref

/datum/tile_panel/proc/_get_or_build_row(atom/A, is_turf = FALSE)
	if(!A || QDELETED(A))
		return null

	var/refid = REF(A)
	var/name = "[A.name]"
	var/path = "[A.type]"
	var/visual_key = _build_visual_cache_key(A)
	var/appearance_ref = _get_cached_appearance_ref(A)

	var/list/entry = row_cache[refid]
	if(islist(entry))
		if(entry["name"] == name && entry["path"] == path && entry["key"] == visual_key && entry["is_turf"] == is_turf)
			var/list/cached_row = entry["row"]
			if(islist(cached_row))
				cached_row["appearance_ref"] = appearance_ref
				return cached_row

	var/list/row = list(
		"name" = name,
		"path" = path,
		"ref" = refid,
		"appearance_ref" = appearance_ref
	)

	if(is_turf)
		row["is_turf"] = TRUE

	row_cache[refid] = list(
		"row" = row,
		"name" = name,
		"path" = path,
		"key" = visual_key,
		"is_turf" = is_turf
	)

	return row

/datum/tile_panel/proc/_prune_stale_caches(list/current_refs, list/current_visual_keys)
	if(!islist(current_refs))
		current_refs = list()
	if(!islist(current_visual_keys))
		current_visual_keys = list()

	for(var/refid in row_cache)
		if(!current_refs[refid])
			row_cache -= refid

	for(var/refid in appearance_cache)
		if(!current_refs[refid])
			appearance_cache -= refid

	for(var/visual_key in appearance_pool)
		var/atom/movable/screen/container = appearance_pool[visual_key]
		if(!current_visual_keys[visual_key] || QDELETED(container))
			if(container && !QDELETED(container) && owner?.hud_used?.vis_holder)
				owner.hud_used.vis_holder.vis_contents -= container
				qdel(container)

			appearance_pool -= visual_key
			appearance_containers -= container

	var/list/valid_containers = list()
	for(var/visual_key in appearance_pool)
		var/atom/movable/screen/container = appearance_pool[visual_key]
		if(container && !QDELETED(container))
			valid_containers += container

	appearance_containers = valid_containers

#undef TILE_PANEL_UI_ID
#undef TILE_PANEL_UI_NAME
#undef TILEPANEL_ACT_CLOSE
#undef TILEPANEL_ACT_INTERACT
#undef TILEPANEL_ACT_DROP
#undef TILEPANEL_REFRESH_THROTTLE_DS
