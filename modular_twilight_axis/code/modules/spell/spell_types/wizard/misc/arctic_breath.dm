/obj/effect/proc_holder/spell/invoked/arctic_breath
	name = "Arctic Breath"
	desc = "Выдыхает поток морозного воздуха, отталкивая врагов и создавая густой ледяной туман."
	school = "evocation"
	invocations = list("SPIRITUS HIEMIS!")
	invocation_type = "shout"
	cost = 6
	spell_tier = 3
	range = 3 
	releasedrain = 40
	chargetime = 30
	recharge_time = 60 SECONDS
	glow_color = "#e0f7ff"
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/arctic_breath/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(user)
	var/target_dir = user.dir
	
	
	playsound(T, 'sound/magic/fleshtostone.ogg', 75, TRUE)
	user.visible_message(span_warning("<b>[user]</b> exhales a stream of white frost!"))
	
	
	var/list/affected_turfs = list()
	
	
	var/turf/curr = T
	for(var/i in 1 to range)
		curr = get_step(curr, target_dir)
		if(!curr || curr.density) break 
		affected_turfs += curr
		
		
		if(i >= 2)
			var/turf/left = get_step(curr, turn(target_dir, 90))
			var/turf/right = get_step(curr, turn(target_dir, -90))
			if(left && !left.density) affected_turfs += left
			if(right && !right.density) affected_turfs += right

	
	for(var/turf/open/OT in affected_turfs)
		
		
		OT.pollute_turf(/datum/pollutant/cold_mist, 150, 300)
		
		
		if(prob(40))
			new /obj/effect/temp_visual/snap_freeze(OT)

		
		for(var/mob/living/L in OT)
			if(L == user || HAS_TRAIT(L, TRAIT_RESISTCOLD)) continue
			
			
			to_chat(L, span_userdanger("The icy wind takes your breath away!"))
			
			
			L.apply_status_effect(/datum/status_effect/stacking/hypothermia, 1)
			
			
			var/push_dir = get_dir(user, L)
			if(!L.anchored && L.mobility_flags & MOBILITY_MOVE)
				step(L, push_dir)
				
				if(L.loc == OT) 
					L.adjustStaminaLoss(10)

	return TRUE
