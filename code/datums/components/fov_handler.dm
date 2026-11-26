/datum/component/fov_handler
	var/cone_state = "90"
	var/current_fov_x = BASE_FOV_MASK_X_DIMENSION
	var/current_fov_y = BASE_FOV_MASK_Y_DIMENSION

/datum/component/fov_handler/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/mob_parent = parent
	if(!mob_parent.client)
		return COMPONENT_INCOMPATIBLE

	sync_direction()
	update_fov_size()

/datum/component/fov_handler/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_stat_change))
	RegisterSignal(parent, COMSIG_LIVING_REVIVE, PROC_REF(on_stat_change))
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(mob_logout))

/datum/component/fov_handler/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_ATOM_DIR_CHANGE, COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE, COMSIG_MOB_LOGOUT))

/datum/component/fov_handler/proc/on_dir_change(mob/source, old_dir, new_dir)
	SIGNAL_HANDLER
	sync_direction()

/datum/component/fov_handler/proc/on_stat_change(mob/source)
	SIGNAL_HANDLER
	var/mob/mob_parent = parent
	mob_parent.update_cone_show()

/datum/component/fov_handler/proc/mob_logout(mob/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/fov_handler/proc/sync_direction()
	var/mob/living/mob_parent = parent
	if(!mob_parent.hud_used?.fov)
		return
	if(isdullahan(mob_parent))
		var/mob/living/carbon/human/user = mob_parent
		var/datum/species/dullahan/user_species = user.dna.species
		var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head
		if(user_species.headless && user_head && ishuman(user_head.loc))
			var/mob/living/head_parent = user_head.loc
			mob_parent.hud_used.fov.dir = head_parent.dir
			mob_parent.hud_used.fov_blocker.dir = head_parent.dir
		else if(!user_species.headless)
			mob_parent.hud_used.fov.dir = mob_parent.dir
			mob_parent.hud_used.fov_blocker.dir = mob_parent.dir
	else
		mob_parent.hud_used.fov.dir = mob_parent.dir
		mob_parent.hud_used.fov_blocker.dir = mob_parent.dir

/datum/component/fov_handler/proc/set_cone_state(new_state)
	cone_state = new_state
	var/mob/living/mob_parent = parent
	if(!mob_parent.hud_used?.fov)
		return
	mob_parent.hud_used.fov.icon_state = "[new_state]_v"
	mob_parent.hud_used.fov_blocker.icon_state = new_state

/datum/component/fov_handler/proc/update_fov_size()
	return
