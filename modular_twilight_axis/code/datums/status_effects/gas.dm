
/obj/item/rope/chain/fake/ice
	name = "ice chains"
	desc = "Magical ice freezing your wrists together."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "chain"
	item_flags = ABSTRACT | DROPDEL 
	breakouttime = 600 SECONDS


/obj/structure/ice_support
	name = "ice support"
	icon = null 
	invisibility = 101 
	mouse_opacity = 0 
	density = TRUE    
	anchored = FALSE
	can_buckle = TRUE
	buckle_lying = 0  
	max_buckled_mobs = 1
	buckle_prevents_pull = FALSE


/datum/status_effect/freon/freeze
	id = "frozen"
	duration = 120 SECONDS 
	status_type = STATUS_EFFECT_UNIQUE
	
	
	mob_effect_icon = null
	mob_effect_icon_state = null

	
	var/ice_integrity = 50 
	var/melt_timer = 0
	var/obj/structure/ice_support/support
	var/mutable_appearance/ice_visual

/datum/status_effect/freon/freeze/on_apply()
	. = ..()
	if(!owner) return
	
	
	support = new /obj/structure/ice_support(owner.loc)
	support.buckle_mob(owner, force = TRUE, check_loc = FALSE)

	
	ice_visual = mutable_appearance('modular_twilight_axis/icons/effects/freeze.dmi', "spike")
	ice_visual.alpha = 150
	ice_visual.color = "#b0f0ff"
	ice_visual.layer = ABOVE_MOB_LAYER 
	ice_visual.appearance_flags = RESET_COLOR | RESET_ALPHA | TILE_BOUND
	
	owner.add_overlay(ice_visual)
	owner.add_atom_colour(rgb(50, 150, 255), ADMIN_COLOUR_PRIORITY)

	owner.apply_status_effect(STATUS_EFFECT_PARALYZED, duration)
	ADD_TRAIT(owner, TRAIT_STUCKITEMS, id) 
	
	owner.lying = 0
	owner.pixel_x = 0
	owner.pixel_y = 0
	owner.transform = matrix()
	owner.update_transform()

	
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(sync_position))
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(handle_ice_shatter))

/datum/status_effect/freon/freeze/proc/sync_position()
	SIGNAL_HANDLER
	if(support && owner)
		if(support.loc != owner.loc)
			support.forceMove(owner.loc)
		owner.pixel_x = 0
		owner.pixel_y = 0

/datum/status_effect/freon/freeze/tick()
	if(!owner) return
	
	if(owner.stat == DEAD)
		qdel(src)
		return

	
	if(support && owner.buckled != support)
		support.buckle_mob(owner, force = TRUE, check_loc = FALSE)
	
	owner.pixel_x = 0
	owner.pixel_y = 0
	owner.lying = 0
	owner.transform = matrix()
	owner.adjustOxyLoss(0.8) 

/datum/status_effect/freon/freeze/on_remove()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_MOB_APPLY_DAMGE, COMSIG_MOVABLE_MOVED))
		
		if(ice_visual)
			owner.cut_overlay(ice_visual)
		owner.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		REMOVE_TRAIT(owner, TRAIT_STUCKITEMS, id)

		if(support)
			support.unbuckle_all_mobs(force = TRUE)
			qdel(support)

		owner.remove_status_effect(STATUS_EFFECT_PARALYZED)
		
		if(owner.stat != DEAD)
			owner.setOxyLoss(0)
			owner.lying = 0
			if(hasvar(owner, "lying_prev"))
				owner:lying_prev = 0 
			owner.transform = matrix() 
			owner.update_transform()
			owner.emote("gasp")
		else
			owner.update_transform()

		owner.bodytemperature = BODYTEMP_NORMAL
		owner.update_mobility()
	..()

/datum/status_effect/freon/freeze/proc/handle_ice_shatter(datum/source, damage, damagetype)
	if(damage <= 0 || damagetype == OXY || damagetype == TOX) return
	ice_integrity -= damage
	if(ice_integrity > 0)
		owner.balloon_alert_to_viewers("Ice cracks! ([ice_integrity])")
	else
		playsound(owner, 'sound/combat/hits/onglass/glassbreak (4).ogg', 100, TRUE)
		qdel(src)

/datum/pollutant/cold_mist
	name = "cold mist"
	pollutant_flags = POLLUTANT_APPEARANCE | POLLUTANT_TOUCH_ACT | POLLUTANT_BREATHE_ACT
	thickness = 5
	alpha = 200

/datum/pollutant/cold_mist/touch_act(mob/living/carbon/victim, amount, total_amount)
	if(HAS_TRAIT(victim, TRAIT_RESISTCOLD)) return
	
	
	victim.apply_status_effect(/datum/status_effect/stacking/hypothermia, 1)
	
	
	victim.bodytemperature = max(victim.bodytemperature - 15, 50)

/datum/pollutant/cold_mist/breathe_act(mob/living/carbon/victim, amount, total_amount)
	if(HAS_TRAIT(victim, TRAIT_RESISTCOLD)) return
	
	
	victim.apply_status_effect(/datum/status_effect/stacking/hypothermia, 1)
