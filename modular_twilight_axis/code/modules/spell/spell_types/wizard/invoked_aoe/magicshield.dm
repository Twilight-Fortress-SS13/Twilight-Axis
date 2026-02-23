/obj/effect/proc_holder/spell/self/magic_shield
	name = "Arcane Shield"
	desc = "Creates a magical barrier that reflects projectiles. Consumes stamina continuously and when reflecting damage."
	cost = 6
	xp_gain = TRUE
	spell_tier = 3
	releasedrain = 15 
	chargetime = 3
	recharge_time = 600 
	action_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'
	overlay_state = "shield" 
	associated_skill = /datum/skill/magic/arcane
	invocations = list("Scutum!") 
	invocation_type = "shout"

	active = FALSE 
	charge_type = "recharge" 
	
	
	var/stamina_passive_drain = 0.6    
	var/stamina_damage_ratio = 0.9    
	
	var/mutable_appearance/shield_overlay
	var/atom/movable/screen/spell_glow_aura/button_glow

/obj/effect/proc_holder/spell/self/magic_shield/Initialize()
	. = ..()
	
	shield_overlay = mutable_appearance('icons/effects/effects.dmi', "shield-grey")
	shield_overlay.appearance_flags = RESET_COLOR | RESET_ALPHA
	shield_overlay.color = "#00ffff" 
	shield_overlay.alpha = 150

/obj/effect/proc_holder/spell/self/magic_shield/cast(mob/living/user = usr)
	if(!active)
		
		if(user.getStaminaLoss() >= user.max_stamina - 20)
			to_chat(user, span_warning("You are too exhausted to hold the barrier.!"))
			return FALSE
		activate_shield(user)
	else
		deactivate_shield(user)
	
	return TRUE

/obj/effect/proc_holder/spell/self/magic_shield/charge_check(mob/user) //заглушка для оффкода


	if(active)
		return TRUE
	
	if(charge_counter < recharge_time)
		return FALSE
		
	return TRUE

/obj/effect/proc_holder/spell/self/magic_shield/proc/activate_shield(mob/living/user)
	active = TRUE
	ranged_ability_user = user
	
	
	playsound(user.loc, 'sound/spellbooks/scrapeblade.ogg', 50, 1)
	user.add_overlay(shield_overlay)
	

	ADD_TRAIT(user, TRAIT_MAGIC_SHIELD, src)
	

	if(action && action.button)
		if(!button_glow)
			button_glow = new /atom/movable/screen/spell_glow_aura()
		action.button.vis_contents += button_glow

	to_chat(user, span_notice("A shimmering mirror barrier appears around you."))
	
	
	START_PROCESSING(SSfastprocess, src)
	

	charge_counter = recharge_time
	if(action) action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/self/magic_shield/proc/deactivate_shield(mob/living/user, shattered = FALSE)
	if(!active) return
	active = FALSE
	
	var/mob/living/L = user || ranged_ability_user
	if(L)
		
		L.cut_overlay(shield_overlay)
		REMOVE_TRAIT(L, TRAIT_MAGIC_SHIELD, src)
		
		if(shattered)
			playsound(L.loc, 'sound/spellbooks/glass.ogg', 60, 1)
			L.visible_message(span_danger("Magic Shield [L] shatters into pieces from exhaustion!"))
			to_chat(L, span_userdanger("You're out of power! The shield is destroyed!"))
		else
			playsound(L.loc, 'sound/magic/cosmic_expansion.ogg', 40, 1)
			to_chat(L, span_notice("You dispel the magical barrier."))

	
	if(action && action.button && button_glow)
		action.button.vis_contents -= button_glow


	charge_counter = 0
	if(action) action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/self/magic_shield/process()
	
	if(active)
		if(!ranged_ability_user || ranged_ability_user.stat == DEAD)
			deactivate_shield(ranged_ability_user)
			return

		
		if(!ranged_ability_user.stamina_add(stamina_passive_drain))
			deactivate_shield(ranged_ability_user, shattered = TRUE)
			return
		
		charge_counter = recharge_time
		if(action) action.UpdateButtonIcon()

	else
		if(charge_counter < recharge_time)
			charge_counter += 2
			if(action) action.UpdateButtonIcon()
		else
			charge_counter = recharge_time
			if(action) action.UpdateButtonIcon()
			return PROCESS_KILL
