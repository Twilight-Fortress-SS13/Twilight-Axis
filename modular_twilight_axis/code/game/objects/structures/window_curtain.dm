// TA ADD: curtain based on the open/close window.
// Paths: /obj/structure/window_curtain/<color>_north (+ /east /west /south under it)
// and /<color>_north_open (+ /east /west /south under it).
// LMB and RMB only open/close it, from the lockdir tile and both diagonals next to it.
// Not dense: can be walked through even when closed. Closed = blocks vision.
// Subtype dir = side from which the curtain can be toggled.

/obj/structure/window_curtain
	parent_type = /obj/structure/roguewindow/openclose
	name = "curtain"
	desc = "A heavy curtain."
	icon = 'modular_twilight_axis/icons/obj/structures/window_curtains.dmi'
	icon_state = "curtain_greendir" // map editor preview, shows direction
	base_state = "curtain_green"
	plane = GAME_PLANE_UPPER // -3, base structures use GAME_PLANE_LOWER (-6)
	density = FALSE
	climbable = FALSE
	climb_offset = 0 // no sprite lift when stepping on the tile
	attacked_sound = list('sound/combat/armor_degrade_leather1.ogg', 'sound/combat/armor_degrade_leather2.ogg', 'sound/combat/armor_degrade_leather3.ogg')
	break_sound = 'sound/foley/cloth_rip.ogg'
	destroy_sound = 'sound/foley/cloth_rip.ogg'
	var/open_sound = 'sound/foley/doors/curtain.ogg'
	var/close_sound = 'sound/foley/doors/curtain.ogg'
	/// Spawn already open (used by /open subtypes).
	var/start_open = FALSE
	/// Current state. Used instead of the window's climbable flag.
	var/curtain_open = FALSE
	/// Cloth pieces needed to mend a torn curtain.
	var/repair_cloth_needed = 2
	/// Cloth pieces already applied.
	var/repair_progress = 0
	/// Someone is mending it right now.
	var/repairing = FALSE

/obj/structure/window_curtain/Initialize(mapload)
	. = ..()
	// The window's Initialize sets icon_state = base_state AFTER update_icon(),
	// and "[base_state]" has no sprite, so the curtain was invisible until the next ToD change.
	// Curtains don't change with time of day, so drop them from the ToD list too.
	GLOB.TodUpdate -= src
	if(start_open)
		curtain_open = TRUE
		set_opacity(FALSE)
	update_icon()

/obj/structure/window_curtain/update_tod(todd)
	return

/obj/structure/window_curtain/get_mechanics_examine(mob/user)
	. = list()
	. += span_info("Clicking on the curtain from the inner side will open or close it.")
	. += span_info("A torn curtain can be mended with [repair_cloth_needed] pieces of cloth, one at a time: click it while holding cloth.")
	if(brokenstate)
		. += span_info("It needs [repair_cloth_needed - repair_progress] more piece(s) of cloth to be mended.")

/obj/structure/window_curtain/proc/can_toggle_from(mob/user)
	if(!user || get_dist(src, user) != 1)
		return FALSE
	var/d = get_dir(src, user)
	return (d == lockdir || d == turn(lockdir, 45) || d == turn(lockdir, -45))

/obj/structure/window_curtain/proc/try_toggle(mob/user)
	if(!can_toggle_from(user))
		to_chat(user, span_warning("I can't reach [src] from this side."))
		return
	if(brokenstate)
		to_chat(user, span_warning("It's torn, that would be foolish."))
		return
	add_fingerprint(user)
	if(curtain_open)
		close_up(user)
	else
		open_up(user)

// LMB: toggle instead of knocking like a window.
/obj/structure/window_curtain/attack_hand(mob/living/user)
	try_toggle(user)
	return TRUE

// RMB: same action.
/obj/structure/window_curtain/attack_right(mob/user)
	try_toggle(user)

/obj/structure/window_curtain/open_up(mob/user)
	visible_message(span_info("[user] opens [src]."))
	playsound(src, open_sound, 100, FALSE)
	curtain_open = TRUE
	set_opacity(FALSE)
	update_icon()

/obj/structure/window_curtain/close_up(mob/user)
	visible_message(span_info("[user] closes [src]."))
	playsound(src, close_sound, 100, FALSE)
	curtain_open = FALSE
	set_opacity(TRUE)
	update_icon()

/obj/structure/window_curtain/force_open()
	playsound(src, open_sound, 100, FALSE)
	curtain_open = TRUE
	set_opacity(FALSE)
	update_icon()

// Mending: click a torn curtain with cloth, 5 s per piece, 2 pieces.
/obj/structure/window_curtain/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/natural/cloth))
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	if(!brokenstate)
		to_chat(user, span_warning("[src] isn't torn."))
		return TRUE
	if(repairing)
		to_chat(user, span_warning("Someone is already mending [src]."))
		return TRUE
	repairing = TRUE
	user.visible_message(span_info("[user] starts mending [src]."), span_info("I start mending [src] with [I]."))
	if(!do_after(user, 5 SECONDS, target = src))
		repairing = FALSE
		return TRUE
	repairing = FALSE
	if(QDELETED(I) || !user.is_holding(I) || !brokenstate)
		return TRUE
	qdel(I)
	repair_progress++
	if(repair_progress < repair_cloth_needed)
		to_chat(user, span_notice("I patch part of [src]. It needs [repair_cloth_needed - repair_progress] more piece(s) of cloth."))
		return TRUE
	repair_curtain(user)
	return TRUE

/// Restores the curtain to its initial (mapped) state.
/obj/structure/window_curtain/proc/repair_curtain(mob/user)
	repair_progress = 0
	brokenstate = FALSE
	obj_fix(user)
	curtain_open = start_open
	set_opacity(!curtain_open)
	update_icon()
	if(user)
		user.visible_message(span_info("[user] mends [src]."), span_notice("I finish mending [src]."))

// Always passable, nothing is damaged by walking or throwing through it.
/obj/structure/window_curtain/CanPass(atom/movable/mover, turf/target)
	return TRUE

/obj/structure/window_curtain/CanAStarPass(ID, to_dir, caller)
	return TRUE

// Torn curtain: no glass, no loud message, drops one cloth.
// Does NOT call the window's obj_break; repeats the base /obj logic instead.
/obj/structure/window_curtain/obj_break(damage_flag)
	if(obj_broken)
		return
	obj_broken = TRUE
	if(!brokenstate)
		brokenstate = TRUE
		new /obj/item/natural/cloth(get_turf(src))
		set_opacity(FALSE)
	if(break_sound)
		playsound(get_turf(src), break_sound, 80, TRUE)
	if(break_message)
		visible_message(break_message)
	SEND_SIGNAL(src, COMSIG_ITEM_BROKEN)
	balloon_alert_to_viewers("<font color = '#bb2b2b'>[src]<br>breaks!</font>")
	update_icon()

// No day/night variants: only [base_state]-open and [base_state]-closed.
// A torn curtain uses the open sprite.
/obj/structure/window_curtain/update_icon()
	if(brokenstate || curtain_open)
		icon_state = "[base_state]-open"
	else
		icon_state = "[base_state]-closed"

// ===== Variants. dir = side from which the curtain can be toggled. =====

// --- bounty ---
/obj/structure/window_curtain/bounty_north
	name = "curtain"
	icon_state = "bountydir"
	base_state = "bounty"
	dir = NORTH
/obj/structure/window_curtain/bounty_north/east
	dir = EAST
/obj/structure/window_curtain/bounty_north/west
	dir = WEST
/obj/structure/window_curtain/bounty_north/south
	dir = SOUTH
/obj/structure/window_curtain/bounty_north_open
	name = "curtain"
	icon_state = "bountydir"
	base_state = "bounty"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/bounty_north_open/east
	dir = EAST
/obj/structure/window_curtain/bounty_north_open/west
	dir = WEST
/obj/structure/window_curtain/bounty_north_open/south
	dir = SOUTH

// --- blue ---
/obj/structure/window_curtain/blue_north
	name = "blue curtain"
	icon_state = "curtain_bluedir"
	base_state = "curtain_blue"
	dir = NORTH
/obj/structure/window_curtain/blue_north/east
	dir = EAST
/obj/structure/window_curtain/blue_north/west
	dir = WEST
/obj/structure/window_curtain/blue_north/south
	dir = SOUTH
/obj/structure/window_curtain/blue_north_open
	name = "blue curtain"
	icon_state = "curtain_bluedir"
	base_state = "curtain_blue"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/blue_north_open/east
	dir = EAST
/obj/structure/window_curtain/blue_north_open/west
	dir = WEST
/obj/structure/window_curtain/blue_north_open/south
	dir = SOUTH

// --- purple ---
/obj/structure/window_curtain/purple_north
	name = "purple curtain"
	icon_state = "curtain_purpledir"
	base_state = "curtain_purple"
	dir = NORTH
/obj/structure/window_curtain/purple_north/east
	dir = EAST
/obj/structure/window_curtain/purple_north/west
	dir = WEST
/obj/structure/window_curtain/purple_north/south
	dir = SOUTH
/obj/structure/window_curtain/purple_north_open
	name = "purple curtain"
	icon_state = "curtain_purpledir"
	base_state = "curtain_purple"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/purple_north_open/east
	dir = EAST
/obj/structure/window_curtain/purple_north_open/west
	dir = WEST
/obj/structure/window_curtain/purple_north_open/south
	dir = SOUTH

// --- cyan ---
/obj/structure/window_curtain/cyan_north
	name = "cyan curtain"
	icon_state = "curtain_cyandir"
	base_state = "curtain_cyan"
	dir = NORTH
/obj/structure/window_curtain/cyan_north/east
	dir = EAST
/obj/structure/window_curtain/cyan_north/west
	dir = WEST
/obj/structure/window_curtain/cyan_north/south
	dir = SOUTH
/obj/structure/window_curtain/cyan_north_open
	name = "cyan curtain"
	icon_state = "curtain_cyandir"
	base_state = "curtain_cyan"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/cyan_north_open/east
	dir = EAST
/obj/structure/window_curtain/cyan_north_open/west
	dir = WEST
/obj/structure/window_curtain/cyan_north_open/south
	dir = SOUTH

// --- brown ---
/obj/structure/window_curtain/brown_north
	name = "brown curtain"
	icon_state = "curtain_browndir"
	base_state = "curtain_brown"
	dir = NORTH
/obj/structure/window_curtain/brown_north/east
	dir = EAST
/obj/structure/window_curtain/brown_north/west
	dir = WEST
/obj/structure/window_curtain/brown_north/south
	dir = SOUTH
/obj/structure/window_curtain/brown_north_open
	name = "brown curtain"
	icon_state = "curtain_browndir"
	base_state = "curtain_brown"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/brown_north_open/east
	dir = EAST
/obj/structure/window_curtain/brown_north_open/west
	dir = WEST
/obj/structure/window_curtain/brown_north_open/south
	dir = SOUTH

// --- green ---
/obj/structure/window_curtain/green_north
	name = "green curtain"
	icon_state = "curtain_greendir"
	base_state = "curtain_green"
	dir = NORTH
/obj/structure/window_curtain/green_north/east
	dir = EAST
/obj/structure/window_curtain/green_north/west
	dir = WEST
/obj/structure/window_curtain/green_north/south
	dir = SOUTH
/obj/structure/window_curtain/green_north_open
	name = "green curtain"
	icon_state = "curtain_greendir"
	base_state = "curtain_green"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/green_north_open/east
	dir = EAST
/obj/structure/window_curtain/green_north_open/west
	dir = WEST
/obj/structure/window_curtain/green_north_open/south
	dir = SOUTH

// --- red ---
/obj/structure/window_curtain/red_north
	name = "red curtain"
	icon_state = "curtain_reddir"
	base_state = "curtain_red"
	dir = NORTH
/obj/structure/window_curtain/red_north/east
	dir = EAST
/obj/structure/window_curtain/red_north/west
	dir = WEST
/obj/structure/window_curtain/red_north/south
	dir = SOUTH
/obj/structure/window_curtain/red_north_open
	name = "red curtain"
	icon_state = "curtain_reddir"
	base_state = "curtain_red"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/red_north_open/east
	dir = EAST
/obj/structure/window_curtain/red_north_open/west
	dir = WEST
/obj/structure/window_curtain/red_north_open/south
	dir = SOUTH

// --- noc ---
/obj/structure/window_curtain/noc_north
	name = "curtain"
	icon_state = "curtain_nocdir"
	base_state = "curtain_noc"
	dir = NORTH
/obj/structure/window_curtain/noc_north/east
	dir = EAST
/obj/structure/window_curtain/noc_north/west
	dir = WEST
/obj/structure/window_curtain/noc_north/south
	dir = SOUTH
/obj/structure/window_curtain/noc_north_open
	name = "curtain"
	icon_state = "curtain_nocdir"
	base_state = "curtain_noc"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/noc_north_open/east
	dir = EAST
/obj/structure/window_curtain/noc_north_open/west
	dir = WEST
/obj/structure/window_curtain/noc_north_open/south
	dir = SOUTH

// --- old ---
/obj/structure/window_curtain/old_north
	name = "old curtain"
	icon_state = "curtain_olddir"
	base_state = "curtain_old"
	dir = NORTH
/obj/structure/window_curtain/old_north/east
	dir = EAST
/obj/structure/window_curtain/old_north/west
	dir = WEST
/obj/structure/window_curtain/old_north/south
	dir = SOUTH
/obj/structure/window_curtain/old_north_open
	name = "old curtain"
	icon_state = "curtain_olddir"
	base_state = "curtain_old"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/old_north_open/east
	dir = EAST
/obj/structure/window_curtain/old_north_open/west
	dir = WEST
/obj/structure/window_curtain/old_north_open/south
	dir = SOUTH

// --- oldbeige ---
/obj/structure/window_curtain/oldbeige_north
	name = "old beige curtain"
	icon_state = "curtain_oldbeigedir"
	base_state = "curtain_oldbeige"
	dir = NORTH
/obj/structure/window_curtain/oldbeige_north/east
	dir = EAST
/obj/structure/window_curtain/oldbeige_north/west
	dir = WEST
/obj/structure/window_curtain/oldbeige_north/south
	dir = SOUTH
/obj/structure/window_curtain/oldbeige_north_open
	name = "old beige curtain"
	icon_state = "curtain_oldbeigedir"
	base_state = "curtain_oldbeige"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/oldbeige_north_open/east
	dir = EAST
/obj/structure/window_curtain/oldbeige_north_open/west
	dir = WEST
/obj/structure/window_curtain/oldbeige_north_open/south
	dir = SOUTH

// --- oldred ---
/obj/structure/window_curtain/oldred_north
	name = "old red curtain"
	icon_state = "curtain_oldreddir"
	base_state = "curtain_oldred"
	dir = NORTH
/obj/structure/window_curtain/oldred_north/east
	dir = EAST
/obj/structure/window_curtain/oldred_north/west
	dir = WEST
/obj/structure/window_curtain/oldred_north/south
	dir = SOUTH
/obj/structure/window_curtain/oldred_north_open
	name = "old red curtain"
	icon_state = "curtain_oldreddir"
	base_state = "curtain_oldred"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/oldred_north_open/east
	dir = EAST
/obj/structure/window_curtain/oldred_north_open/west
	dir = WEST
/obj/structure/window_curtain/oldred_north_open/south
	dir = SOUTH

// --- oldblue ---
/obj/structure/window_curtain/oldblue_north
	name = "old blue curtain"
	icon_state = "curtain_oldbluedir"
	base_state = "curtain_oldblue"
	dir = NORTH
/obj/structure/window_curtain/oldblue_north/east
	dir = EAST
/obj/structure/window_curtain/oldblue_north/west
	dir = WEST
/obj/structure/window_curtain/oldblue_north/south
	dir = SOUTH
/obj/structure/window_curtain/oldblue_north_open
	name = "old blue curtain"
	icon_state = "curtain_oldbluedir"
	base_state = "curtain_oldblue"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/oldblue_north_open/east
	dir = EAST
/obj/structure/window_curtain/oldblue_north_open/west
	dir = WEST
/obj/structure/window_curtain/oldblue_north_open/south
	dir = SOUTH

// --- oldgreen ---
/obj/structure/window_curtain/oldgreen_north
	name = "old green curtain"
	icon_state = "curtain_oldgreendir"
	base_state = "curtain_oldgreen"
	dir = NORTH
/obj/structure/window_curtain/oldgreen_north/east
	dir = EAST
/obj/structure/window_curtain/oldgreen_north/west
	dir = WEST
/obj/structure/window_curtain/oldgreen_north/south
	dir = SOUTH
/obj/structure/window_curtain/oldgreen_north_open
	name = "old green curtain"
	icon_state = "curtain_oldgreendir"
	base_state = "curtain_oldgreen"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/oldgreen_north_open/east
	dir = EAST
/obj/structure/window_curtain/oldgreen_north_open/west
	dir = WEST
/obj/structure/window_curtain/oldgreen_north_open/south
	dir = SOUTH

// --- oldpurple ---
/obj/structure/window_curtain/oldpurple_north
	name = "old purple curtain"
	icon_state = "curtain_oldpurpledir"
	base_state = "curtain_oldpurple"
	dir = NORTH
/obj/structure/window_curtain/oldpurple_north/east
	dir = EAST
/obj/structure/window_curtain/oldpurple_north/west
	dir = WEST
/obj/structure/window_curtain/oldpurple_north/south
	dir = SOUTH
/obj/structure/window_curtain/oldpurple_north_open
	name = "old purple curtain"
	icon_state = "curtain_oldpurpledir"
	base_state = "curtain_oldpurple"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/oldpurple_north_open/east
	dir = EAST
/obj/structure/window_curtain/oldpurple_north_open/west
	dir = WEST
/obj/structure/window_curtain/oldpurple_north_open/south
	dir = SOUTH

// --- sun ---
/obj/structure/window_curtain/sun_north
	name = "curtain"
	icon_state = "curtain_sundir"
	base_state = "curtain_sun"
	dir = NORTH
/obj/structure/window_curtain/sun_north/east
	dir = EAST
/obj/structure/window_curtain/sun_north/west
	dir = WEST
/obj/structure/window_curtain/sun_north/south
	dir = SOUTH
/obj/structure/window_curtain/sun_north_open
	name = "curtain"
	icon_state = "curtain_sundir"
	base_state = "curtain_sun"
	dir = NORTH
	start_open = TRUE
/obj/structure/window_curtain/sun_north_open/east
	dir = EAST
/obj/structure/window_curtain/sun_north_open/west
	dir = WEST
/obj/structure/window_curtain/sun_north_open/south
	dir = SOUTH
