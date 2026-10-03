/mob
	var/fovangle
	var/cone_showing = FALSE

//Procs
/atom/proc/InCone(atom/center = usr, dir = NORTH)
	if(get_dist(center, src) == 0 || src == center) return 0
	var/d = get_dir(center, src)
	if(!d || d == dir) return 1
	if(dir & (dir-1))
		return (d & ~dir) ? 0 : 1
	if(!(d & dir)) return 0
	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)
	if(dx == dy) return 1
	if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? 1 : 0
	return (dir & (EAST|WEST)) ? 1 : 0

/mob/dead/InCone(mob/center = usr, dir = NORTH)//So ghosts aren't calculated.
	return

/proc/cone(atom/center = usr, dirs, list/list = oview(center))
	for(var/atom/A in list)
		var/fou
		for(var/D in dirs)
			if(A.InCone(center, D))
				fou = TRUE
				break
		if(!fou)
			list -= A
	return list


/mob/dead/BehindAtom(mob/center = usr, dir = NORTH)//So ghosts aren't calculated.
	return

/atom/proc/BehindAtom(atom/center = usr, dir = NORTH) //Returns TRUE if center is behind src
	switch(dir)
		if(NORTH)
			if(y > center.y)
				return 1
		if(SOUTH)
			if(y < center.y)
				return 1
		if(EAST)
			if(x > center.x)
				return 1
		if(WEST)
			if(x < center.x)
				return 1

/proc/behind(atom/center = usr, dirs, list/list = oview(center))
	for(var/atom/A in list)
		var/fou
		for(var/D in dirs)
			if(A.BehindAtom(center, D))
				fou = TRUE
				break
		if(!fou)
			list -= A
	return list

/mob/proc/update_vision_cone()
	return

/mob/proc/update_cone()
	return

/mob/living/update_vision_cone()
	if(!client)
		return
	var/datum/component/fov_handler/fov = GetComponent(/datum/component/fov_handler)
	if(!fov)
		AddComponent(/datum/component/fov_handler)
	else
		fov.sync_direction()
		fov.update_fov_size()

/mob/proc/can_see_cone(mob/L)
	if(!isliving(src) || !isliving(L))
		return
	if(!client)
		// NPCs without clients use simple directional vision cone
		if(L.InCone(src, src.dir))
			return TRUE
		return FALSE
	if(hud_used && hud_used.fov)
		if(hud_used.fov.alpha != 0)
			var/list/mobs2hide = list()

			if(fovangle & FOV_RIGHT)
				if(fovangle & FOV_LEFT)
					var/dirlist = list(turn(src.dir, 180),turn(src.dir, -90),turn(src.dir, 90))
					mobs2hide |= cone(src, dirlist, list(L))
				else
					if(fovangle & FOV_BEHIND)
						var/dirlist = list(turn(src.dir, -90))
						mobs2hide |= behind(src, list(turn(src.dir, 180)), list(L))
						mobs2hide |= cone(src, dirlist, list(L))
					else
						var/dirlist = list(turn(src.dir, 180),turn(src.dir, -90))
						mobs2hide |= cone(src, dirlist, list(L))
			else
				if(fovangle & FOV_LEFT)
					if(fovangle & FOV_BEHIND)
						var/dirlist = list(turn(src.dir, 90))
						mobs2hide |= behind(src, list(turn(src.dir, 180)), list(L))
						mobs2hide |= cone(src, dirlist, list(L))
					else
						var/dirlist = list(turn(src.dir, 180),turn(src.dir, 90))
						mobs2hide |= cone(src, dirlist, list(L))
				else
					if(fovangle & FOV_BEHIND)
						mobs2hide |= behind(src, list(turn(src.dir, 180)), list(L))
					else//default
						mobs2hide |= cone(src, list(turn(src.dir, 180)), list(L))

			if(L in mobs2hide)
				return FALSE
	return TRUE

/mob/proc/update_cone_show()
	if(!client)
		return
	if(client.perspective != MOB_PERSPECTIVE)
		// Show cone if we're looking at our head.
		if(isdullahan(src))
			var/mob/living/carbon/human/human = src
			var/obj/item/organ/dullahan_vision/vision = human.getorganslot(ORGAN_SLOT_HUD)
			if(vision.viewing_head)
				return show_cone()
		return hide_cone()
	if(client.eye != src)
		return hide_cone()
	if(client.pixel_x || client.pixel_y)
		return hide_cone()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!(H.mobility_flags & MOBILITY_STAND))
			return hide_cone()
		if(!H.client && H.ai_controller)
			return hide_cone()
		if(H.viewcone_override)
			return hide_cone()
	return show_cone()

/mob/proc/update_fov_angles()
	fovangle = initial(fovangle)
	if(ishuman(src) && fovangle)
		var/mob/living/carbon/human/H = src
		var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
		if(!head && isdullahan(src))
			var/datum/species/dullahan/dullahan = H.dna.species
			head = dullahan.my_head

		var/cyclops_left = HAS_TRAIT(src, TRAIT_CYCLOPS_LEFT)
		var/cyclops_right = HAS_TRAIT(src, TRAIT_CYCLOPS_RIGHT)

		if(H.has_status_effect(STATUS_EFFECT_BLINDED) || H.has_status_effect(STATUS_EFFECT_PSYPOWDER)) //TA EDIT
			fovangle |= FOV_LEFT
			fovangle |= FOV_RIGHT

		if(head)
			cyclops_left = cyclops_left || head.has_wound(/datum/wound/facial/eyes/left)
			cyclops_right = cyclops_right || head.has_wound(/datum/wound/facial/eyes/right)

		if(H.head)
			if(H.head.block2add)
				fovangle |= H.head.block2add
		if(H.wear_mask)
			if(H.wear_mask.block2add)
				fovangle |= H.wear_mask.block2add
		if(H.head?.block2add == FOV_BEHIND && H.wear_mask?.block2add == FOV_BEHIND && H.wear_mask?.stack_fovs && H.head?.stack_fovs)
			fovangle |= FOV_LEFT|FOV_RIGHT
		if(cyclops_left)
			fovangle |= FOV_LEFT
		if(cyclops_right)
			fovangle |= FOV_RIGHT

	if(!hud_used)
		return
	if(!hud_used.fov)
		return
	if(!hud_used.fov_blocker)
		return
	if(fovangle & FOV_DEFAULT)
		var/cone_state = "90"
		if(fovangle & FOV_BEHIND)
			cone_state = (fovangle & (FOV_LEFT|FOV_RIGHT)) ? "270" : "180"
		else if((fovangle & FOV_LEFT) && (fovangle & FOV_RIGHT))
			cone_state = "270"
		var/datum/component/fov_handler/fov = GetComponent(/datum/component/fov_handler)
		if(fov)
			fov.set_cone_state(cone_state)
		else
			hud_used.fov.icon_state = "[cone_state]_v"
			hud_used.fov_blocker.icon_state = cone_state
		return
	hud_used.fov.icon_state = null
	hud_used.fov_blocker.icon_state = null

//Making these generic procs so you can call them anywhere.
/mob/proc/show_cone()
	if(!client)
		return
	if(cone_showing)
		return
	cone_showing = TRUE
	if(hud_used?.fov)
		hud_used.fov.alpha = 255
		hud_used.fov_blocker.alpha = 255
	var/atom/movable/screen/plane_master/game_world_fov_hidden/PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in client.screen
	PM.backdrop(src)

/mob/proc/hide_cone()
	if(!client)
		return
	if(!cone_showing)
		return
	cone_showing = FALSE
	if(hud_used?.fov)
		hud_used.fov.alpha = 0
		hud_used.fov_blocker.alpha = 0
	var/atom/movable/screen/plane_master/game_world_fov_hidden/PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in client.screen
	PM.backdrop(src)

/atom/movable/screen/fov_blocker
	icon = 'icons/effects/fov/field_of_view.dmi'
	icon_state = "90"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FIELD_OF_VISION_BLOCKER_PLANE
	screen_loc = "CENTER-7,CENTER-7"

/atom/movable/screen/fov
	icon = 'icons/effects/fov/field_of_view.dmi'
	icon_state = "90_v"
	name = " "
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = 0
	plane = FULLSCREEN_PLANE
	color = "#000000"
