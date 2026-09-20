/datum/buildmode/proc/log_world_action(mob/user, params, atom/object)
	var/list/pa = params2list(params)
	var/list/click_parts = list()
	if(pa.Find("ctrl"))
		click_parts += "Ctrl"
	if(pa.Find("shift"))
		click_parts += "Shift"
	if(pa.Find("alt"))
		click_parts += "Alt"
	if(pa.Find("left"))
		click_parts += "LeftClick"
	else if(pa.Find("right"))
		click_parts += "RightClick"
	else
		click_parts += "Click"

	var/click_desc = jointext(click_parts, "+")
	var/target_desc = "null"
	var/target_type = "null"
	var/location_desc = "unknown location"
	if(object)
		target_desc = "[object]"
		target_type = "[object.type]"
		var/turf/T = get_turf(object)
		if(T)
			location_desc = AREACOORD(T)

	var/mode_desc = mode?.key || "unknown"
	log_admin("Build Mode: [key_name(user)] used [mode_desc] ([click_desc]) on [target_desc] ([target_type]) at [location_desc].")

/datum/buildmode_mode/ai_group
	key = "AI Group"
	button_icon = 'modular_twilight_axis/icons/misc/buildmode.dmi'
	button_icon_state = "buildmode_ai"
	var/list/selected_mobs = list()
	var/list/selection_images = list()

/datum/buildmode_mode/ai_group/Destroy()
	clear_selection()
	selected_mobs = null
	selection_images = null
	return ..()

/datum/buildmode_mode/ai_group/exit_mode(datum/buildmode/BM)
	clear_selection()

/datum/buildmode_mode/ai_group/show_help(client/c)
	to_chat(c, span_notice("<b>AI Group buildmode</b>"))
	to_chat(c, span_notice("Left click an NPC with an AI controller: select it as the group."))
	to_chat(c, span_notice("Ctrl + left click an NPC: add/remove it from the current group."))
	to_chat(c, span_notice("Left click empty/non-AI atom: clear the selection."))
	to_chat(c, span_notice("Right click a turf/object: order the group to move there."))
	to_chat(c, span_notice("Right click a living mob: order the group to attack it."))
	to_chat(c, span_notice("Shift + right click a living mob: order the group to follow it."))
	to_chat(c, span_notice("Alt + right click: force-move the selected group to that turf."))
	to_chat(c, span_notice("Shift + left click an AI NPC: pause/unpause that NPC's AI."))

/datum/buildmode_mode/ai_group/change_settings(client/c)
	if(!length(selected_mobs))
		to_chat(c, span_notice("No AI mobs are currently selected."))
		return
	if(alert(c, "Clear the current AI group selection?", "AI Group", "Clear", "Cancel") == "Clear")
		clear_selection()
		to_chat(c, span_notice("AI group selection cleared."))

/datum/buildmode_mode/ai_group/handle_click(client/c, params, atom/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")
	var/ctrl_click = pa.Find("ctrl")
	var/shift_click = pa.Find("shift")
	var/alt_click = pa.Find("alt")
	if(left_click)
		if(isliving(object))
			var/mob/living/L = object
			if(L.ai_controller && !L.client)
				if(shift_click)
					toggle_ai(L, c)
					return
				if(ctrl_click)
					toggle_selected(L)
				else
					clear_selection()
					select_mob(L)
				to_chat(c, span_notice("AI group: [length(selected_mobs)] selected."))
				return
		if(!ctrl_click)
			clear_selection()
			to_chat(c, span_notice("AI group selection cleared."))
		return
	if(!right_click || !length(selected_mobs))
		return
	var/turf/target_turf = get_turf(object)
	if(!target_turf)
		return
	if(alt_click)
		var/moved = 0
		for(var/mob/living/L as anything in selected_mobs.Copy())
			if(QDELETED(L))
				continue
			L.forceMove(target_turf)
			moved++
		to_chat(c, span_notice("Force-moved [moved] selected AI mob(s) to [target_turf]."))
		log_admin("[key_name(c)] force-moved [moved] AI group mob(s) to [AREACOORD(target_turf)] using buildmode.")
		return
	if(shift_click && isliving(object))
		order_follow(object, c)
		return
	if(isliving(object))
		order_attack(object, c)
		return
	order_move(target_turf, c)

/datum/buildmode_mode/ai_group/proc/select_mob(mob/living/L)
	if(!L?.ai_controller || L.client || (L in selected_mobs))
		return FALSE
	selected_mobs += L
	var/image/I = image('icons/turf/overlays.dmi', L, "greenOverlay")
	I.plane = ABOVE_LIGHTING_PLANE
	selection_images[L] = I
	BM.holder.images += I
	RegisterSignal(L, COMSIG_PARENT_QDELETING, PROC_REF(on_selected_deleted))
	return TRUE

/datum/buildmode_mode/ai_group/proc/deselect_mob(mob/living/L)
	if(!(L in selected_mobs))
		return
	selected_mobs -= L
	var/image/I = selection_images[L]
	if(I)
		BM?.holder?.images -= I
	selection_images[L] = null
	selection_images -= L
	UnregisterSignal(L, COMSIG_PARENT_QDELETING)

/datum/buildmode_mode/ai_group/proc/toggle_selected(mob/living/L)
	if(L in selected_mobs)
		deselect_mob(L)
	else
		select_mob(L)

/datum/buildmode_mode/ai_group/proc/clear_selection()
	if(!selected_mobs)
		return
	for(var/mob/living/L as anything in selected_mobs.Copy())
		deselect_mob(L)
	selected_mobs.Cut()
	if(selection_images)
		selection_images.Cut()

/datum/buildmode_mode/ai_group/proc/on_selected_deleted(datum/source)
	SIGNAL_HANDLER
	if(isliving(source))
		deselect_mob(source)

/datum/buildmode_mode/ai_group/proc/toggle_ai(mob/living/L, client/c)
	if(!L?.ai_controller)
		return
	if(L.ai_controller.ai_status == AI_STATUS_OFF)
		L.ai_controller.reset_ai_status()
		to_chat(c, span_notice("AI enabled for [L]."))
	else
		L.ai_controller.set_ai_status(AI_STATUS_OFF)
		to_chat(c, span_notice("AI paused for [L]."))
	log_admin("[key_name(c)] toggled AI status for [key_name(L)] using AI Group buildmode.")

/datum/buildmode_mode/ai_group/proc/prepare_controller(mob/living/L)
	if(!L?.ai_controller)
		return FALSE
	var/datum/ai_controller/C = L.ai_controller
	C.CancelActions()
	C.clear_blackboard_key(BB_FOLLOW_TARGET)
	C.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	C.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	C.clear_blackboard_key(BB_TRAVEL_DESTINATION)
	C.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
	C.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	C.clear_blackboard_key(BB_CURRENT_PET_TARGET)
	C.blackboard[BB_MOB_AGGRO_TABLE] = list()
	if(C.ai_status == AI_STATUS_OFF)
		C.reset_ai_status()
	return TRUE

/datum/buildmode_mode/ai_group/proc/order_move(turf/target, client/c)
	var/count = 0
	for(var/mob/living/L as anything in selected_mobs.Copy())
		if(QDELETED(L) || !prepare_controller(L))
			continue
		L.ai_controller.set_blackboard_key(BB_TRAVEL_DESTINATION, target)
		L.ai_controller.set_movement_target(type, target)
		L.ai_controller.nudge_target_scan()
		L.ai_controller.wake_for_combat()
		count++
	to_chat(c, span_notice("Ordered [count] AI mob(s) to move to [target]."))
	log_admin("[key_name(c)] ordered [count] AI group mob(s) to move to [AREACOORD(target)] using buildmode.")

/datum/buildmode_mode/ai_group/proc/order_follow(mob/living/target, client/c)
	var/count = 0
	for(var/mob/living/L as anything in selected_mobs.Copy())
		if(QDELETED(L) || L == target || !prepare_controller(L))
			continue
		L.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, target)
		L.ai_controller.set_movement_target(type, target)
		L.ai_controller.nudge_target_scan()
		L.ai_controller.wake_for_combat()
		count++
	to_chat(c, span_notice("Ordered [count] AI mob(s) to follow [target]."))
	log_admin("[key_name(c)] ordered [count] AI group mob(s) to follow [key_name(target)] using buildmode.")

/datum/buildmode_mode/ai_group/proc/order_attack(mob/living/target, client/c)
	var/count = 0
	for(var/mob/living/L as anything in selected_mobs.Copy())
		if(QDELETED(L) || L == target || !prepare_controller(L))
			continue
		L.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, target)
		L.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		L.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)
		L.ai_controller.set_movement_target(type, target)
		L.ai_controller.nudge_target_scan()
		L.ai_controller.wake_for_combat()
		count++
	to_chat(c, span_notice("Ordered [count] AI mob(s) to attack [target]."))
	log_admin("[key_name(c)] ordered [count] AI group mob(s) to attack [key_name(target)] using buildmode.")

/datum/buildmode_mode/outfit
	key = "Outfit"
	button_icon = 'modular_twilight_axis/icons/misc/buildmode.dmi'
	button_icon_state = "buildmode_outfit"
	var/selected_outfit

/datum/buildmode_mode/outfit/Destroy()
	selected_outfit = null
	return ..()

/datum/buildmode_mode/outfit/show_help(client/c)
	to_chat(c, span_notice("<b>Outfit buildmode</b>"))
	to_chat(c, span_notice("Right click the buildmode mode button: select an outfit."))
	to_chat(c, span_notice("Left click a human: strip their current equipment and equip the selected outfit."))
	to_chat(c, span_notice("Right click a human: strip and delete their current equipment."))

/datum/buildmode_mode/outfit/Reset()
	. = ..()
	selected_outfit = null

/datum/buildmode_mode/outfit/change_settings(client/c)
	var/new_outfit = c.robust_dress_shop()
	if(isnull(new_outfit))
		return
	selected_outfit = new_outfit
	to_chat(c, span_notice("Outfit buildmode selected: [selected_outfit]."))
	log_admin("Build Mode: [key_name(c)] selected outfit [selected_outfit] for Outfit mode.")

/datum/buildmode_mode/outfit/handle_click(client/c, params, atom/object)
	if(!ishuman(object))
		return

	var/list/pa = params2list(params)
	var/mob/living/carbon/human/H = object

	if(pa.Find("left"))
		if(isnull(selected_outfit))
			to_chat(c, span_warning("Pick an outfit first by right-clicking the buildmode mode button."))
			return
		H.delete_equipment()
		if(selected_outfit != "Naked")
			H.equipOutfit(selected_outfit)
		H.regenerate_icons()
		to_chat(c, span_notice("Applied outfit [selected_outfit] to [H]."))
		log_admin("Build Mode: [key_name(c)] applied outfit [selected_outfit] to [key_name(H)] using Outfit mode.")
		return

	if(pa.Find("right"))
		H.delete_equipment()
		H.regenerate_icons()
		to_chat(c, span_notice("Stripped [H]."))
		log_admin("Build Mode: [key_name(c)] stripped [key_name(H)] using Outfit mode.")
