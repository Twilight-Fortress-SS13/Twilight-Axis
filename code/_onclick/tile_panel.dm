#define TILE_PANEL_UI_ID "TilePanel"
#define TILE_PANEL_UI_NAME "TilePanel"
#define TILEPANEL_ACT_CLOSE "close"
#define TILEPANEL_ACT_INTERACT "interact"
#define TILEPANEL_ACT_DROP "drop"
#define TILEPANEL_REFRESH_THROTTLE_DS 10
#define TILEPANEL_ICON_BATCH 4
#define TILEPANEL_ICON_GLOBAL_RATE 32
#define TILEPANEL_ICON_CACHE_LIMIT 256

GLOBAL_LIST_EMPTY(tilepanel_preview_icons)
GLOBAL_VAR_INIT(tilepanel_icon_second, -1)
GLOBAL_VAR_INIT(tilepanel_icon_count, 0)

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
	var/panel_revision = 0
	var/icon_serial = 0
	var/list/pending_icons = list()
	var/icon_work_queued = FALSE

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
		pending_icons = list()
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
		if("request_icons")
			if(usr != owner || !owner?.client || !target_turf || !owner.can_open_tile_panel_turf(target_turf))
				return FALSE
			var/list/refs = params["refs"]
			if(!islist(refs))
				return FALSE
			for(var/i in 1 to min(refs.len, 16))
				var/atom/A = locate(refs[i])
				if(!A || QDELETED(A) || (A != target_turf && (A.loc != target_turf || !_should_include_atom(A))))
					continue
				if(!_get_cached_appearance_ref(A))
					pending_icons |= REF(A)
			_queue_icon_work()
			return FALSE
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
	pending_icons = list()

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
	// BYOND appearances are value snapshots: equality includes overlays, color matrices and transforms.
	// Avoid walking and stringifying every overlay whenever the panel updates.
	return A.appearance

/datum/tile_panel/proc/_make_preview_icon(atom/A)
	if(!A || QDELETED(A) || !A.icon)
		return null
	var/image/preview = image(A.icon)
	preview.appearance = copy_appearance_filter_overlays(A.appearance)
	var/icon/I = getFlatIcon(preview, defdir = A.dir, no_anim = TRUE)
	if(I && (I.Width() > 64 || I.Height() > 64))
		var/ratio = min(64 / I.Width(), 64 / I.Height())
		I.Scale(max(round(I.Width() * ratio), 1), max(round(I.Height() * ratio), 1))
	return I

/datum/tile_panel/proc/_get_cached_appearance_ref(atom/A, visual_key = null)
	if(!A || QDELETED(A))
		return null
	var/list/entry = appearance_cache[REF(A)]
	if(islist(entry) && entry["key"] == (visual_key || _build_visual_cache_key(A)))
		return entry["appearance_ref"]
	return null

/datum/tile_panel/proc/_queue_icon_work()
	if(icon_work_queued || !pending_icons.len || !_is_open())
		return
	icon_work_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(_process_icon_work)), 2)

/datum/tile_panel/proc/_process_icon_work()
	icon_work_queued = FALSE
	if(!_is_open() || !target_turf || !owner.can_open_tile_panel_turf(target_turf))
		pending_icons = list()
		return
	var/second = floor(world.time / 10)
	if(GLOB.tilepanel_icon_second != second)
		GLOB.tilepanel_icon_second = second
		GLOB.tilepanel_icon_count = 0
	var/processed = 0
	var/changed = FALSE
	while(pending_icons.len && processed < TILEPANEL_ICON_BATCH && GLOB.tilepanel_icon_count < TILEPANEL_ICON_GLOBAL_RATE)
		if(TICK_CHECK)
			break
		var/refid = pending_icons[1]
		pending_icons.Cut(1, 2)
		var/atom/A = locate(refid)
		if(!A || QDELETED(A) || (A != target_turf && (A.loc != target_turf || !_should_include_atom(A))) || _get_cached_appearance_ref(A))
			continue
		processed++
		GLOB.tilepanel_icon_count++
		var/visual_key = _build_visual_cache_key(A)
		var/icon/I = GLOB.tilepanel_preview_icons[visual_key]
		if(!I)
			I = _make_preview_icon(A)
			if(!I)
				continue
			if(GLOB.tilepanel_preview_icons.len >= TILEPANEL_ICON_CACHE_LIMIT)
				GLOB.tilepanel_preview_icons.Remove(GLOB.tilepanel_preview_icons[1])
			GLOB.tilepanel_preview_icons[visual_key] = I
		// The asset transport uses content hashes and skips resources already sent to this client.
		var/url = icon2html(I, owner.client, sourceonly = TRUE)
		appearance_cache[refid] = list("key" = visual_key, "appearance_ref" = url)
		changed = TRUE
		if(TICK_CHECK)
			break
	if(changed)
		SStgui.update_uis(src)
	_queue_icon_work()

/datum/tile_panel/proc/_get_or_build_row(atom/A, is_turf = FALSE)
	if(!A || QDELETED(A))
		return null

	var/refid = REF(A)
	var/name = "[A.name]"
	var/path = "[A.type]"
	var/visual_key = _build_visual_cache_key(A)
	var/appearance_ref = _get_cached_appearance_ref(A, visual_key)
	var/render_key

	var/list/entry = row_cache[refid]
	if(islist(entry))
		if(entry["name"] == name && entry["path"] == path && entry["key"] == visual_key && entry["is_turf"] == is_turf && entry["appearance_ref"] == appearance_ref)
			var/list/cached_row = entry["row"]
			if(islist(cached_row))
				cached_row["appearance_ref"] = appearance_ref
				return cached_row

	icon_serial++
	render_key = "[panel_revision]|[refid]|[icon_serial]"
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
#undef TILEPANEL_ICON_BATCH
#undef TILEPANEL_ICON_GLOBAL_RATE
#undef TILEPANEL_ICON_CACHE_LIMIT
