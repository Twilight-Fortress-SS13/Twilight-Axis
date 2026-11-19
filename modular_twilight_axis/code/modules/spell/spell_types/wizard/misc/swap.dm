/obj/effect/proc_holder/spell/invoked/swap
	name = "Swap Places"
	desc = "Switch locations with a target you can see. Can pass through glass and bars."
	school = "transmutation"
	cost = 3
	chargetime = 3
	range = 7 
	spell_tier = 3
	selection_type = "range"
	releasedrain = 30
	chargedrain = 1
	invocations = list("Pachisto!")
	invocation_type = "shout"
	recharge_time = 40 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE
	charging_slowdown = 2
	overlay_state = "knowledge"
	xp_gain = TRUE
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	var/phase_effect = /obj/effect/temp_visual/blink

/obj/effect/proc_holder/spell/invoked/swap/cast(list/targets, mob/user = usr)
	if(!targets.len)
		return
		
	var/atom/movable/target = targets[1]
	

	if(!isliving(target) && !isitem(target))
		to_chat(user, span_warning("You can't swap with that!"))
		revert_cast()
		return


	if(!isturf(target.loc))
		to_chat(user, span_warning("[target] must be on the ground!"))
		revert_cast()
		return


	if(target.anchored && !isliving(target))
		to_chat(user, span_warning("[target] is fixed in place!"))
		revert_cast()
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target) 


	if(!target_turf || !user_turf || target_turf.z != user_turf.z)
		return

	if(target == user)
		to_chat(user, span_warning("You are already here!"))
		revert_cast()
		return


	if(!(target in view(range, user)))
		to_chat(user, span_warning("Target is too far!"))
		revert_cast()
		return


	if(target_turf.density)
		to_chat(user, span_warning("The target's location is too solid to materialize!"))
		revert_cast()
		return


	new phase_effect(user_turf)
	new phase_effect(target_turf)
	playsound(user_turf, 'sound/magic/blink.ogg', 50, TRUE)
	playsound(target_turf, 'sound/magic/blink.ogg', 50, TRUE)


	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)
	if(isliving(target))
		var/mob/living/L = target
		if(L.buckled)
			L.buckled.unbuckle_mob(L, TRUE)


	target.forceMove(user_turf)
	do_teleport(user, target_turf, channel = TELEPORT_CHANNEL_MAGIC)


	user.visible_message(span_danger("<b>[user]</b> swaps places with <b>[target]</b>!"), \
						 span_notice("You swap places with [target]!"))
	
	return TRUE
