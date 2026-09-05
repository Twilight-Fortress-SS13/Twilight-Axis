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
	var/list/row_cache
	var/icon_serial = 0
	var/panel_revision = 0

/datum/tile_panel/New(mob/user)
	owner = user
	appearance_cache = list()
	row_cache = list()
	..()

/datum/tile_panel/Destroy()
	if(owner?.tile_panel == src)
		owner.tile_panel = null

	_clear_appearance_containers()

	owner = null
	target_turf = null
	appearance_cache = null
	row_cache = null
	return ..()

/datum/tile_panel/proc/set_target(turf/T)
	if(!T)
		return FALSE
	if(target_turf != T)
		target_turf = T
		panel_revision++
		row_cache = list()
		last_refresh_at = 0
		refresh_queued = FALSE
		return TRUE
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
	.["revision"] = panel_revision

	var/list/atoms = list()
	var/list/current_refs = list()

	var/list/turf_row = _get_or_build_row(target_turf, TRUE)
	if(turf_row)
		atoms += list(turf_row)
		current_refs[REF(target_turf)] = TRUE

	for(var/atom/A in target_turf)
		if(!_should_include_atom(A))
			continue

		var/list/row = _get_or_build_row(A, FALSE)
		if(!row)
			continue

		atoms += list(row)
		current_refs[REF(A)] = TRUE

	_prune_stale_caches(current_refs)

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
	appearance_cache = list()
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
	var/list/key_parts = list(
		"[REF(A)]",
		"[A.type]",
		"[A.icon]",
		"[A.icon_state]",
		"[A.dir]",
		"[A.color]",
		"[A.alpha]"
	)

	if(ap)
		key_parts += "[ap.icon]"
		key_parts += "[ap.icon_state]"
		key_parts += "[ap.dir]"
		key_parts += "[ap.color]"
		key_parts += "[ap.alpha]"
		key_parts += "[ap.blend_mode]"
		key_parts += "[ap.transform]"
		key_parts += "[length(ap.overlays)]"
		for(var/overlay in ap.overlays)
			key_parts += "[overlay]"
		key_parts += "[length(ap.underlays)]"
		for(var/underlay in ap.underlays)
			key_parts += "[underlay]"

	return key_parts.Join("|")

/datum/tile_panel/proc/_make_preview_icon(atom/A)
	if(!A || QDELETED(A) || !A.icon)
		return null

	var/icon/I
	if(A.icon_state)
		I = icon(A.icon, A.icon_state, A.dir)
	else
		I = icon(A.icon)

	if(!I)
		return null

	if(istext(A.color))
		I.Blend(A.color, ICON_MULTIPLY)

	return I

/datum/tile_panel/proc/_make_icon_filename()
	icon_serial++
	return "tilepanel_[world.time]_[icon_serial]_[rand(1000, 9999)].dmi"

/datum/tile_panel/proc/_get_cached_appearance_ref(atom/A)
	if(!A || QDELETED(A))
		return null
	if(!owner?.client)
		return null

	var/refid = REF(A)
	var/visual_key = _build_visual_cache_key(A)
	if(!visual_key)
		return null

	var/list/ref_entry = appearance_cache[refid]
	if(islist(ref_entry))
		if(ref_entry["key"] == visual_key)
			return ref_entry["appearance_ref"]

	var/icon/preview_icon = _make_preview_icon(A)
	if(!preview_icon)
		return null

	var/file_name = _make_icon_filename()
	owner << browse_rsc(preview_icon, file_name)

	appearance_cache[refid] = list(
		"key" = visual_key,
		"appearance_ref" = file_name
	)

	return file_name

/datum/tile_panel/proc/_get_or_build_row(atom/A, is_turf = FALSE)
	if(!A || QDELETED(A))
		return null

	var/refid = REF(A)
	var/name = "[A.name]"
	var/path = "[A.type]"
	var/visual_key = _build_visual_cache_key(A)
	var/appearance_ref = _get_cached_appearance_ref(A)
	var/render_key = "[panel_revision]|[refid]|[visual_key]|[appearance_ref]"

	var/list/entry = row_cache[refid]
	if(islist(entry))
		if(entry["name"] == name && entry["path"] == path && entry["key"] == visual_key && entry["is_turf"] == is_turf && entry["appearance_ref"] == appearance_ref)
			var/list/cached_row = entry["row"]
			if(islist(cached_row))
				cached_row["appearance_ref"] = appearance_ref
				cached_row["render_key"] = render_key
				return cached_row

	var/list/row = list(
		"name" = name,
		"path" = path,
		"ref" = refid,
		"appearance_ref" = appearance_ref,
		"render_key" = render_key
	)

	if(is_turf)
		row["is_turf"] = TRUE

	row_cache[refid] = list(
		"row" = row,
		"name" = name,
		"path" = path,
		"key" = visual_key,
		"appearance_ref" = appearance_ref,
		"is_turf" = is_turf
	)

	return row

/datum/tile_panel/proc/_prune_stale_caches(list/current_refs)
	if(!islist(current_refs))
		current_refs = list()

	for(var/refid in row_cache)
		if(!current_refs[refid])
			row_cache -= refid

	for(var/refid in appearance_cache)
		if(!current_refs[refid])
			appearance_cache -= refid

#undef TILE_PANEL_UI_ID
#undef TILE_PANEL_UI_NAME
#undef TILEPANEL_ACT_CLOSE
#undef TILEPANEL_ACT_INTERACT
#undef TILEPANEL_ACT_DROP
#undef TILEPANEL_REFRESH_THROTTLE_DS
