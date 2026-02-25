/atom/movable/screen/alert/status_effect/emberwine
	name = "Aphrodisiac"
	desc = "The warmth is spreading through my body..."
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "emberwine"

/datum/status_effect/debuff/emberwine
	id = "emberwine"
	effectedstats = list(STATKEY_LCK = -1)
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/emberwine

/datum/status_effect/debuff/nekoldun
	id = "Psydon's Music"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/nekoldun
	duration = 70 SECONDS

/datum/status_effect/debuff/nekoldun/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

/datum/status_effect/debuff/nekoldun/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

/atom/movable/screen/alert/status_effect/debuff/nekoldun
	name = "Psydon's Music"

/datum/status_effect/debuff/vampiric_slowdown 
	id = "vampiric_slowdown"
	duration = 120 
	alert_type = null 
	effectedstats = list(STATKEY_SPD = -10) 

/datum/status_effect/debuff/vampiric_slowdown/on_apply()
	. = ..()
	if(owner)
		to_chat(owner, span_warning("The dark link weighs heavily on my soul, slowing my movements!"))

/datum/status_effect/debuff/vampiric_slowdown/on_remove()
	if(owner)
		to_chat(owner, span_notice("The burden lifts, and I regain my speed."))
	. = ..()

/datum/status_effect/stacking/hypothermia
	id = "hypothermia"
	status_type = STATUS_EFFECT_REFRESH
	max_stacks = 18 
	delay_before_decay = 10 SECONDS
	tick_interval = 1 SECONDS
	
	var/last_frozen_time = 0
	var/current_speed_penalty = 0 

/datum/status_effect/stacking/hypothermia/refresh(mob/living/new_owner, ...)
	var/list/A = args
	var/amount = (A.len >= 2) ? A[2] : 1
	add_stacks(amount)
	
/datum/status_effect/stacking/hypothermia/add_stacks(stacks_added)
	if(!owner || owner.stat == DEAD) 
		return FALSE
	
	
	var/datum/status_effect/freon/freeze/F = owner.has_status_effect(/datum/status_effect/freon/freeze)
	if(F)
		F.ice_integrity = min(F.ice_integrity + (stacks_added * 5), 250)
		owner.balloon_alert(owner, "Ice reinforcing! ([F.ice_integrity])")
		return TRUE

	if(stacks_added > 0)
		last_frozen_time = world.time
	
	stacks = clamp(stacks + stacks_added, 0, max_stacks)
	
	
	var/new_penalty = -round(stacks * 0.5)
	if(new_penalty != current_speed_penalty)
		owner.change_stat(STATKEY_SPD, -current_speed_penalty) 
		current_speed_penalty = new_penalty
		owner.change_stat(STATKEY_SPD, current_speed_penalty) 
	

	if(stacks == 6)
		owner.balloon_alert(owner, "My limbs are going numb...")
	else if(stacks == 12)
		owner.balloon_alert(owner, "The cold is clouding the mind!")
	
	
	if(stacks >= 18)
		do_final_freeze()
		return TRUE

	update_frost_visuals()
	return TRUE

/datum/status_effect/stacking/hypothermia/proc/update_frost_visuals()
	if(!owner) 
		return
	var/r = clamp(255 - (stacks * 11), 50, 255)
	var/g = clamp(255 - (stacks * 6), 140, 255)
	var/b = 255
	owner.add_atom_colour(rgb(r, g, b), ADMIN_COLOUR_PRIORITY)
	owner.update_atom_colour()

/datum/status_effect/stacking/hypothermia/tick()
	if(!owner || owner.stat == DEAD) 
		return
	
	
	if(world.time > last_frozen_time + delay_before_decay)
		if(stacks > 0)
			add_stacks(-1)
			return 

	if(!owner) 
		return

	owner.update_move_intent_slowdown()


	if(stacks >= 1 && stacks <= 5) 
		if(prob(10)) 
			owner.emote("shiver")

	else if(stacks >= 6 && stacks <= 11) 
		owner.adjustFireLoss(1.5)
		if(owner.stamina < owner.max_stamina)
			owner.stamina_add(10)
		
	else if(stacks >= 12) 
		owner.adjustFireLoss(3)
		owner.adjustOxyLoss(3)
		
		if(owner.stamina < owner.max_stamina)
			owner.stamina_add(15)
		
		
		if(prob(15)) 
			owner.apply_status_effect(STATUS_EFFECT_SLEEPING, 40)
			
		
		if(prob(15))
			owner.visible_message(span_danger("[owner] is staggering from the terrible cold!"))
			owner.Knockdown(20)

/datum/status_effect/stacking/hypothermia/proc/do_final_freeze()
	if(!owner) 
		return
	owner.apply_status_effect(/datum/status_effect/freon/freeze)
	qdel(src)

/datum/status_effect/stacking/hypothermia/on_remove()
	if(owner)
		
		owner.change_stat(STATKEY_SPD, -current_speed_penalty)
		owner.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		owner.update_move_intent_slowdown()
