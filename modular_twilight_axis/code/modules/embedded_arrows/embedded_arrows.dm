#define EMBED_ENTRY_FRONT	1
#define EMBED_ENTRY_BACK	2
#define EMBED_ENTRY_LEFT	3
#define EMBED_ENTRY_RIGHT	4
#define MOVESPEED_ID_EMBEDDED_LEG_ARROWS	"EMBEDDED_LEG_ARROWS"
#define EMBEDDED_ARROWS_CACHE_INDEX	57
#define EMBEDDED_ARROWS_LAYER		(HANDS_LAYER+0.5)
#define EMBEDDED_ARROWS_ICON 'icons/roguetown/mob/embedded_arrows.dmi'
#define EMBEDDED_ARROWS_PER_LIMB 3
#define ARROW_VIEW_DIAG "diag"
#define ARROW_VIEW_STUB_RIGHT "right"
#define ARROW_VIEW_STUB_LEFT "left"
#define EMBEDDED_LEG_ARROW_SLOWDOWN 0.5
#define EMBEDDED_LEG_ARROW_SLOWDOWN_MAX 1.5


/obj/item
	var/embedded_entry_side

/obj/projectile
	var/pen_integrity_factor
	var/blocked_integrity_factor
	var/embed_needs_full_pen = FALSE
	var/struck_armor_tier = 0

/obj/item/proc/get_embed_removal_time(mob/user, mob/living/target)
	return embedding ? embedding.embedded_unsafe_removal_time * w_class : 0

/obj/item/proc/get_embedded_overlay_state()
	return null

/obj/projectile/proc/can_embed_through_armor()
	return !(embed_needs_full_pen && struck_armor_tier > 0 && armor_penetration <= struck_armor_tier)

/obj/projectile/proc/get_armor_intdamage(damage, intdamage, pen, protection)
	if(pen >= protection)
		if(!isnull(pen_integrity_factor))
			return damage * pen_integrity_factor
	else if(!isnull(blocked_integrity_factor))
		return damage * blocked_integrity_factor
	return intdamage

/mob/living/carbon/proc/update_embedded_leg_slowdown()
	var/arrows = 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(!(bodypart.body_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)))
			continue
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			if(istype(embedded, /obj/item/ammo_casing/caseless/rogue/arrow))
				arrows++
	if(!arrows)
		remove_movespeed_modifier(MOVESPEED_ID_EMBEDDED_LEG_ARROWS)
		return
	var/slowdown = min(arrows * EMBEDDED_LEG_ARROW_SLOWDOWN, EMBEDDED_LEG_ARROW_SLOWDOWN_MAX)
	add_movespeed_modifier(MOVESPEED_ID_EMBEDDED_LEG_ARROWS, update = TRUE, priority = 100, override = TRUE, multiplicative_slowdown = slowdown, movetypes = GROUND)

/mob/living/carbon/proc/update_embedded_arrow_overlays(facing, from_turn = FALSE)
	return

/mob/living/carbon/proc/refresh_embedded_arrows()
	update_embedded_leg_slowdown()
	update_embedded_arrow_overlays()

/mob/living/proc/get_embed_entry_side(atom/origin)
	var/from_dir = origin ? get_dir(src, origin) : NONE
	if(!from_dir || (from_dir & dir))
		return EMBED_ENTRY_FRONT
	if(from_dir & REVERSE_DIR(dir))
		return EMBED_ENTRY_BACK
	return (from_dir & turn(dir, 90)) ? EMBED_ENTRY_LEFT : EMBED_ENTRY_RIGHT

/obj/item/grabbing/proc/ta_embedded_removal_wait(mob/living/user, mob/living/M, obj/item/bodypart/L, obj/item/embedded_item)
	if(!istype(embedded_item) || QDELETED(embedded_item))
		return FALSE
	var/removal_time = istype(embedded_item, /obj/item/ammo_casing/caseless/rogue/arrow) ? embedded_item.get_embed_removal_time(user, M) : 0
	if(!removal_time)
		return TRUE
	if(user == M)
		user.visible_message(span_warning("[user] starts working [embedded_item] free of [user.p_them()]self..."), span_warning("I start working [embedded_item] free..."))
	else
		user.visible_message(span_warning("[user] starts working [embedded_item] free of [M]..."), span_warning("I start working [embedded_item] free of [M]..."))
	if(!do_after(user, removal_time, target = M))
		return FALSE
	if(QDELETED(src) || !valid_check() || grabbed != M || limb_grabbed != L || sublimb_grabbed != embedded_item || user.buckled)
		return FALSE
	return TRUE

/proc/embedded_arrow_view(entry_side, facing)
	var/seen_side
	var/right_side
	var/left_side
	switch(facing)
		if(NORTH)
			seen_side = EMBED_ENTRY_BACK
			right_side = EMBED_ENTRY_RIGHT
			left_side = EMBED_ENTRY_LEFT
		if(EAST)
			seen_side = EMBED_ENTRY_RIGHT
			right_side = EMBED_ENTRY_FRONT
			left_side = EMBED_ENTRY_BACK
		if(WEST)
			seen_side = EMBED_ENTRY_LEFT
			right_side = EMBED_ENTRY_BACK
			left_side = EMBED_ENTRY_FRONT
		else
			seen_side = EMBED_ENTRY_FRONT
			right_side = EMBED_ENTRY_LEFT
			left_side = EMBED_ENTRY_RIGHT
	var/side = entry_side || EMBED_ENTRY_FRONT
	if(side == seen_side)
		return ARROW_VIEW_DIAG
	if(side == right_side)
		return ARROW_VIEW_STUB_RIGHT
	if(side == left_side)
		return ARROW_VIEW_STUB_LEFT
	return null

/mob/living/carbon/human/update_embedded_arrow_overlays(facing = dir, from_turn = FALSE)
	remove_overlay(EMBEDDED_ARROWS_CACHE_INDEX)
	var/list/arrow_overlays = list()
	var/static/list/available_states
	if(!available_states)
		available_states = icon_states(EMBEDDED_ARROWS_ICON)
	var/static/list/diag_nudges = list(list(0, 0), list(2, -3), list(-2, 3))
	var/static/list/stub_nudges = list(list(0, 0), list(0, -3), list(0, 3))
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!length(BP.embedded_objects))
			continue
		var/list/limb = embedded_arrow_limb_bounds(BP.species_icon, BP.body_zone, facing)
		if(!limb)
			continue
		var/shown = 0
		for(var/obj/item/embedded as anything in BP.embedded_objects)
			var/state = embedded.get_embedded_overlay_state()
			if(!state)
				continue
			var/view = embedded_arrow_view(embedded.embedded_entry_side, facing)
			if(!view)
				continue
			if(++shown > EMBEDDED_ARROWS_PER_LIMB)
				break
			var/prefix = (view == ARROW_VIEW_DIAG) ? "diag" : "side"
			var/icon_state = "[prefix]_[state]"
			if(!(icon_state in available_states))
				icon_state = "[prefix]_arrow_proj"
			var/anchor_x
			var/flip = FALSE
			var/list/nudge
			switch(view)
				if(ARROW_VIEW_DIAG)
					anchor_x = round((limb[1] + limb[2] - 1) / 2)
					flip = !(shown % 2)
					nudge = diag_nudges[shown]
				if(ARROW_VIEW_STUB_RIGHT)
					anchor_x = limb[2]
					nudge = stub_nudges[shown]
				if(ARROW_VIEW_STUB_LEFT)
					anchor_x = limb[1] - 1
					flip = TRUE
					nudge = stub_nudges[shown]
			var/mutable_appearance/arrow_overlay = mutable_appearance(EMBEDDED_ARROWS_ICON, icon_state, -EMBEDDED_ARROWS_LAYER)
			arrow_overlay.pixel_x = anchor_x + nudge[1] - 16 + (flip ? 1 : 0)
			arrow_overlay.pixel_y = 16 - (limb[3] + nudge[2])
			if(flip)
				arrow_overlay.transform = matrix(-1, 0, 0, 0, 1, 0)
			arrow_overlays += arrow_overlay
	if(length(arrow_overlays))
		overlays_standing[EMBEDDED_ARROWS_CACHE_INDEX] = arrow_overlays
		apply_overlay(EMBEDDED_ARROWS_CACHE_INDEX)
	if(from_turn)
		return
	if(has_drawable_embeds())
		RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change_redraw_arrows), override = TRUE)
	else
		UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)

/mob/living/carbon/human/proc/has_drawable_embeds()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!length(BP.embedded_objects) || !embedded_arrow_limb_bounds(BP.species_icon, BP.body_zone, SOUTH))
			continue
		for(var/obj/item/embedded as anything in BP.embedded_objects)
			if(embedded.get_embedded_overlay_state())
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/on_dir_change_redraw_arrows(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	if(old_dir != new_dir)
		update_embedded_arrow_overlays(new_dir, from_turn = TRUE)

/obj/item/ammo_casing/caseless/rogue/arrow
	embedding = list("embedded_fall_chance" = 0, "embedded_unsafe_removal_time" = 20, "embedded_bloodloss" = 1, "embedded_unsafe_removal_pain_multiplier" = 10)

/obj/item/ammo_casing/caseless/rogue/arrow/get_embed_removal_time(mob/user, mob/living/target)
	. = ..()
	if(user == target)
		. *= 2

/obj/item/ammo_casing/caseless/rogue/arrow/get_embedded_overlay_state()
	var/obj/projectile/arrow_type = projectile_type
	return arrow_type ? initial(arrow_type.icon_state) : null

/obj/item/ammo_casing/caseless/rogue/arrow/iron
	embedding = list("embedded_fall_chance" = 0, "embedded_unsafe_removal_time" = 20, "embedded_bloodloss" = 1.5, "embedded_unsafe_removal_pain_multiplier" = 15)

/// Узкое остриё: рана чище.
/obj/item/ammo_casing/caseless/rogue/arrow/steel
	embedding = list("embedded_fall_chance" = 0, "embedded_unsafe_removal_time" = 20, "embedded_bloodloss" = 0.75, "embedded_unsafe_removal_pain_multiplier" = 8)

/obj/item/ammo_casing/caseless/rogue/arrow/blacksteel
	embedding = list("embedded_fall_chance" = 0, "embedded_unsafe_removal_time" = 20, "embedded_bloodloss" = 0.75, "embedded_unsafe_removal_pain_multiplier" = 8)

/obj/projectile/bullet/reusable/arrow
	pen_integrity_factor = 0.5
	blocked_integrity_factor = 0.25
	embed_needs_full_pen = TRUE

/obj/projectile/bullet/reusable/arrow/iron
	embedchance = 60

/obj/projectile/bullet/reusable/arrow/steel
	embedchance = 50

/obj/projectile/bullet/reusable/arrow/blacksteel
	armor_penetration = PEN_BSTEEL
	embedchance = 50

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	penfactor = 1

#undef EMBEDDED_ARROWS_ICON
#undef EMBEDDED_ARROWS_PER_LIMB
#undef ARROW_VIEW_DIAG
#undef ARROW_VIEW_STUB_RIGHT
#undef ARROW_VIEW_STUB_LEFT
#undef EMBEDDED_LEG_ARROW_SLOWDOWN
#undef EMBEDDED_LEG_ARROW_SLOWDOWN_MAX
