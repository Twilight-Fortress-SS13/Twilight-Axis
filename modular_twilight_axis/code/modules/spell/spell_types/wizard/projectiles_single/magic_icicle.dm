/obj/effect/proc_holder/spell/invoked/projectile/icicle_spear
	name = "Icicle Spear"
	desc = "Стреляет магической сосулькой, которая вонзается в плоть врага, нанося постоянный урон и замораживая его изнутри."
	school = "evocation"
	invocations = list("GLACIES CUSPIS!")
	invocation_type = "shout"
	projectile_type = /obj/projectile/magic/icicle_spike
	cost = 6
	spell_tier = 2
	releasedrain = 30
	chargetime =  20
	recharge_time = 35 SECONDS
	action_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'
	overlay_state = "flight"
	glow_color = "#e0f7ff"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/projectile/icicle_spear/cast(list/targets, mob/user)
	user.visible_message(span_warning("<b>[user]</b> Frost products with a long, sharp spike!"))
	return ..()

/obj/item/magic_icicle
	name = "magic icicle"
	desc = "Sharp and unnaturally cold."
	icon_state = "flight"
	force = 10
	throwforce = 20
	w_class = WEIGHT_CLASS_SMALL
	sharpness = TRUE
	

	var/timerid
	var/next_freeze_time = 0
	var/internal_melt_time = 0 


	embedding = list(
		"embedded_pain_multiplier" = 2,
		"embedded_fall_chance" = 2,    
		"embedded_pain_chance" = 15
	)

/obj/item/magic_icicle/Initialize()
	. = ..()

	if(isturf(loc))
		start_melting()

/obj/item/magic_icicle/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()


/obj/item/magic_icicle/dropped(mob/user)
	. = ..()

	STOP_PROCESSING(SSfastprocess, src)

	start_melting()


/obj/item/magic_icicle/pickup(mob/user)
	. = ..()

	if(timerid)
		deltimer(timerid)
		timerid = null
	
	
	STOP_PROCESSING(SSfastprocess, src)


/obj/item/magic_icicle/proc/embedded(mob/living/M)
	
	START_PROCESSING(SSfastprocess, src)
	
	
	next_freeze_time = world.time + 10 SECONDS
	
	
	internal_melt_time = world.time + 20 SECONDS
	
	
	if(timerid)
		deltimer(timerid)
		timerid = null

/obj/item/magic_icicle/process()
	
	if(!is_embedded)
		STOP_PROCESSING(SSfastprocess, src)
		return

	var/mob/living/victim = null
	var/obj/item/bodypart/limb = null 

	
	if(isbodypart(loc)) 
		limb = loc
		victim = limb.owner
	else if(isliving(loc)) 
		victim = loc

	if(victim && victim.stat != DEAD)
		
		if(world.time >= internal_melt_time)
			to_chat(victim, span_notice("The cold inside dissolves in the body... The icicle melted."))
			
			
			if(limb)
				limb.embedded_objects -= src
				victim.update_damage_overlays()
			else
				if(victim.has_embedded_objects())
					victim.clear_alert("embeddedobject")
			
			qdel(src)
			return

	
		victim.adjustFireLoss(1.5) 
		
		
		if(world.time >= next_freeze_time)
			
			victim.apply_status_effect(/datum/status_effect/stacking/hypothermia, 1)
			next_freeze_time = world.time + 10 SECONDS
			
			if(prob(50))
				to_chat(victim, span_userdanger("I feel [src] freezing my blood from the inside!"))
	else
		
		STOP_PROCESSING(SSfastprocess, src)

/obj/item/magic_icicle/proc/start_melting()
	if(timerid) return
	
	timerid = addtimer(CALLBACK(src, PROC_REF(melt_away)), 100, TIMER_STOPPABLE)

/obj/item/magic_icicle/proc/melt_away()
	if(isturf(loc))
		visible_message(span_notice("[src] melts and turns into a puddle."))
		qdel(src)



/obj/projectile/magic/icicle_spike
	name = "Icicle spike"
	icon_state = "flight"
	damage = 45
	damage_type = BRUTE 
	flag = "magic"
	speed = 1.3
	hitsound = 'sound/spellbooks/icicle.ogg'

/obj/projectile/magic/icicle_spike/on_hit(target)
	if(isliving(target))
		var/mob/living/L = target
		if(!L.anti_magic_check())
			
			L.apply_status_effect(/datum/status_effect/stacking/hypothermia, 2)
			
			
			var/obj/item/magic_icicle/I = new(L)
			
			var/embedded_success = FALSE
			
			if(HAS_TRAIT(L, TRAIT_SIMPLE_WOUNDS))
				
				if(L.simple_add_embedded_object(I, crit_message = TRUE))
					embedded_success = TRUE
			else
				
				var/obj/item/bodypart/BP = L.get_bodypart(ran_zone(def_zone))
				if(!BP) BP = L.get_bodypart(BODY_ZONE_CHEST)
				
				if(BP && BP.add_embedded_object(I, crit_message = TRUE, ranged = TRUE))
					embedded_success = TRUE
			
			
			if(embedded_success)
				
				I.embedded(L)
			else
				
				I.forceMove(get_turf(L))
				

	return ..()

