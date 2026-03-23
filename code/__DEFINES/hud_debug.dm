// ============================================================
// HUD DEBUG LOGGING
// Comment/uncomment the line below to toggle ALL hud logging
// ============================================================
#define HUD_DEBUG_LOG

#ifdef HUD_DEBUG_LOG
#define HUD_LOG(source, action, details) hud_debug_log(source, action, details)
#else
#define HUD_LOG(source, action, details)
#endif

#ifdef HUD_DEBUG_LOG
GLOBAL_LIST_INIT(hud_debug_buffer, list())
GLOBAL_VAR_INIT(hud_debug_enabled, TRUE)
GLOBAL_VAR_INIT(hud_debug_max_entries, 500)
GLOBAL_VAR_INIT(hud_debug_file, file("data/logs/hud_debug.log"))

/proc/hud_debug_log(source, action, details)
	if(!GLOB.hud_debug_enabled)
		return
	var/entry = "\[[world.time]\] [source] | [action] | [details]"
	GLOB.hud_debug_buffer += entry
	if(GLOB.hud_debug_buffer.len > GLOB.hud_debug_max_entries)
		GLOB.hud_debug_buffer.Cut(1, GLOB.hud_debug_buffer.len - GLOB.hud_debug_max_entries + 1)
	GLOB.hud_debug_file << entry

/proc/hud_debug_dump(mob/user)
	if(!user?.client)
		return
	for(var/entry in GLOB.hud_debug_buffer)
		to_chat(user, "<span class='notice'>[entry]</span>")

/proc/hud_debug_dump_vis(atom/movable/target)
	var/list/info = list()
	info += "type=[target.type]"
	info += "icon=[target.icon]"
	info += "icon_state=[target.icon_state]"
	info += "alpha=[target.alpha]"
	info += "layer=[target.layer]"
	info += "plane=[target.plane]"
	info += "color=[target.color]"
	info += "vis_contents.len=[length(target.vis_contents)]"
	info += "overlays.len=[length(target.overlays)]"
	info += "screen_loc=[target.screen_loc]"
	return info.Join(", ")

/proc/hud_debug_dump_vis_child(atom/child)
	var/list/info = list()
	info += "ref=["\ref[child]"]"
	info += "type=[child.type]"
	info += "icon=[child.icon]"
	info += "icon_state=[child.icon_state]"
	info += "alpha=[child.alpha]"
	info += "px=[child.pixel_x]"
	info += "py=[child.pixel_y]"
	info += "layer=[child.layer]"
	info += "plane=[child.plane]"
	info += "color=[child.color]"
	info += "overlays.len=[length(child.overlays)]"
	return info.Join(", ")
#endif
