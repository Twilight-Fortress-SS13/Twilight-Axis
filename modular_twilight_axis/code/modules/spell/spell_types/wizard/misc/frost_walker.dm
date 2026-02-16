
/obj/effect/temp_visual/ice_formation
	icon = 'modular_twilight_axis/icons/effects/freeze.dmi'
	icon_state = "ice_bridge"
	duration = 6 
	layer = ABOVE_NORMAL_TURF_LAYER 
	randomdir = FALSE


/atom/movable/screen/spell_glow_aura
	name = "active glow"
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "spell" 
	color = "#00ffff"
	alpha = 150
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE
	blend_mode = BLEND_ADD 

/atom/movable/screen/spell_glow_aura/Initialize()
	. = ..()
	transform = matrix().Scale(1.1) 
	add_filter("glow", 1, list("type" = "blur", "size" = 2))



/obj/effect/proc_holder/spell/self/frost_walker
	name = "Frost Walker"
	desc = "Замораживает воду. Тратит стамину. Автоматически выключается при истощении."
	invocations = list("GLACIES VIA!")
	cost = 3
	active = FALSE
	
	charge_type = "recharge"
	recharge_time = 100 
	
	var/stamina_passive_drain = 2 
	var/stamina_per_freeze = 3    
	var/atom/movable/screen/spell_glow_aura/button_glow

/obj/effect/proc_holder/spell/self/frost_walker/cast(mob/living/user)
	if(!active)
		if(user.getStaminaLoss() >= user.max_stamina - 15)
			to_chat(user, span_warning("You're too exhausted!"))
			return FALSE
		activate_frost(user)
	else
		deactivate_frost(user)
	return TRUE 

/obj/effect/proc_holder/spell/self/frost_walker/proc/activate_frost(mob/living/user)
	if(active) return
	active = TRUE
	ranged_ability_user = user
	
	to_chat(user, span_notice("Your aura exudes a deadly cold.."))
	
	
	if(action && action.button)
		if(!button_glow)
			button_glow = new /atom/movable/screen/spell_glow_aura()
		action.button.vis_contents += button_glow


	user.add_filter("frost_aura", 1, list("type" = "outline", "color" = "#00ffff66", "size" = 2))

	ADD_TRAIT(user, "frost_walker", "frost_spell")
	ADD_TRAIT(user, TRAIT_NOSLIPALL, "frost_spell")
	
	if(hascall(user, "update_move_intent_slowdown"))
		user.update_move_intent_slowdown()
	
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	START_PROCESSING(SSfastprocess, src)
	
	charge_counter = recharge_time
	if(action)
		action.UpdateButtonIcon()
	
	freeze_radius(user)

/obj/effect/proc_holder/spell/self/frost_walker/proc/deactivate_frost(mob/living/user)
	if(!active) return
	active = FALSE
	
	var/mob/living/L = user || ranged_ability_user
	if(L)
		to_chat(L, span_notice("The ice magic is dissipating."))
		L.remove_filter("frost_aura")
		REMOVE_TRAIT(L, "frost_walker", "frost_spell")
		REMOVE_TRAIT(L, TRAIT_NOSLIPALL, "frost_spell")
		if(hascall(L, "update_move_intent_slowdown"))
			L.update_move_intent_slowdown()
		UnregisterSignal(L, COMSIG_MOVABLE_MOVED)

	
	if(action && action.button && button_glow)
		action.button.vis_contents -= button_glow

	charge_counter = 0
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/self/frost_walker/process()
	if(active)
		if(!ranged_ability_user || ranged_ability_user.stat)
			deactivate_frost()
			return

		if(!ranged_ability_user.stamina_add(stamina_passive_drain))
			deactivate_frost()
			return
		
		charge_counter = recharge_time
		if(action)
			action.UpdateButtonIcon()
	else
	
		if(charge_counter < recharge_time)
			charge_counter += 2 
			if(action)
				action.UpdateButtonIcon()
		else
			charge_counter = recharge_time
			if(action)
				action.UpdateButtonIcon()
			return PROCESS_KILL

/obj/effect/proc_holder/spell/self/frost_walker/proc/on_move(mob/living/user, atom/OldLoc, Dir)
	if(!active) return
	freeze_radius(user)

/obj/effect/proc_holder/spell/self/frost_walker/proc/freeze_radius(mob/living/user)
	for(var/turf/open/T in range(1, user))
		if(istype(T, /turf/open/water) || istype(T, /turf/open/water/ocean/deep))
			
			
			var/has_vis = FALSE
			for(var/obj/effect/temp_visual/ice_formation/existing in T)
				has_vis = TRUE
				break
			if(has_vis) continue

			if(!user.stamina_add(stamina_per_freeze))
				deactivate_frost(user)
				return
			
			var/old_path = T.type
			var/obj/effect/temp_visual/ice_formation/V = new(T)
			V.dir = get_dir(T, user)
			addtimer(CALLBACK(src, PROC_REF(finalize_freeze), T, old_path), 2)

/obj/effect/proc_holder/spell/self/frost_walker/proc/finalize_freeze(turf/T, old_path)
	if(!T || !istype(T, /turf/open/water)) return
	var/turf/open/floor/rogue/dark_ice/regular/magic/I = T.ChangeTurf(/turf/open/floor/rogue/dark_ice/regular/magic, flags = CHANGETURF_INHERIT_AIR)
	I.stored_type = old_path
	addtimer(CALLBACK(src, PROC_REF(melt_ice), I, old_path), 50)

/obj/effect/proc_holder/spell/self/frost_walker/proc/melt_ice(turf/T, old_type)
	if(T && istype(T, /turf/open/floor/rogue/dark_ice/regular/magic))
		T.ChangeTurf(old_type, flags = CHANGETURF_INHERIT_AIR)



/turf/open/floor/rogue/dark_ice/regular/magic
	name = "magical ice"
	icon = 'modular_twilight_axis/icons/effects/freeze.dmi'
	icon_state = "ice"
	var/stored_type = /turf/open/floor/rogue/dirt/road
	var/obj/effect/abstract/pollution/water_overlay

/turf/open/floor/rogue/dark_ice/regular/magic/Initialize(mapload)
	. = ..()
	water_overlay = new(src)
	water_overlay.invisibility = INVISIBILITY_ABSTRACT

/turf/open/floor/rogue/dark_ice/regular/magic/ice_crack()
	src.ChangeTurf(stored_type, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/dark_ice/regular/magic/turf_destruction(damage_flag)
	src.ice_crack()

/turf/open/floor/rogue/dark_ice/regular/magic/Entered(atom/movable/AM)
	if(ishuman(AM) && HAS_TRAIT(AM, "frost_walker"))
		return
	return ..()
