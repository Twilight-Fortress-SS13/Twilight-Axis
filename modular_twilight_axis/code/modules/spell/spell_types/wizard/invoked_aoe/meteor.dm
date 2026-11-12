/obj/effect/proc_holder/spell/invoked/grand_meteor
	name = "Cataclysmic Meteor"
	desc = "Summons a massive meteor. High destruction, high cost."
	overlay_state = "meteor_storm"
	cost = 10
	spell_tier = 3
	chargedrain = 2
	releasedrain = 80
	chargetime = 25
	recharge_time = 60 SECONDS               
	selection_type = "range"
	invocations = list("Anborno!")
	invocation_type = "shout"
	no_early_release = TRUE
	movement_interrupt = TRUE
	gesture_required = TRUE
	xp_gain = TRUE
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokegen
	warnie = "spellwarning"

/obj/effect/proc_holder/spell/invoked/grand_meteor/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	if(!T) return

	if(!(T in view(user)))
		to_chat(user, span_warning("I aimed incorrectly and my concentration was knocked down!"))
		return
	
	T.visible_message(span_boldwarning("A massive shadow covers the area..."))
	new /obj/effect/temp_visual/target/massive(T)
	return TRUE

/obj/effect/temp_visual/fireball/massive
	name = "colossal meteor"
	desc = "A planet-killer heading straight for you."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "meteor"
	duration = 25 
	pixel_z = 600
	plane = GAME_PLANE_UPPER 
	layer = MASSIVE_OBJ_LAYER 
	randomdir = FALSE

/obj/effect/temp_visual/fireball/massive/Initialize(mapload)
	. = ..()
	
	var/matrix/M = matrix()
	M.Scale(6, 6)
	transform = M
	

	pixel_x = 0
	pixel_y = 0

	animate(src, pixel_z = 0, time = duration, easing = EASE_IN)

/obj/effect/temp_visual/target/massive
	name = "impending doom"
	desc = "The ground is heating up..."
	duration = 40 
	plane = GAME_PLANE_LOWER 
	layer = LOW_SIGIL_LAYER 
	

	exp_heavy = -1 
	exp_light = 2  
	exp_flash = 3  
	exp_fire = 3  

/obj/effect/temp_visual/target/massive/Initialize(mapload)
	. = ..()
	
	var/matrix/M = matrix()
	M.Scale(5, 5)
	transform = M
	

	pixel_x = 0
	pixel_y = 0
	
	INVOKE_ASYNC(src, PROC_REF(fall_massive))

/obj/effect/temp_visual/target/massive/fall()
	return

/obj/effect/temp_visual/target/massive/proc/fall_massive()
	var/turf/T = get_turf(src)
	if(!T) 
		return

	new /obj/effect/temp_visual/fireball/massive(T)
	
	sleep(25)
	
	if(!T)
		return

	for(var/mob/living/L in range(12, T))
		shake_camera(L, 12, 4)

	playsound(T, 'sound/misc/explode/explosiongreat.ogg', 150, TRUE)
	T.visible_message(span_userdanger("<b>THE METEOR IMPACTS!</b>"))
	

	for(var/turf/nearby in range(6, T))
		var/dist = get_dist(T, nearby)
		for(var/mob/living/L in nearby.contents)
			if(dist <= 0)
				L.adjustBruteLoss(100)
				L.adjustFireLoss(100)
				L.Knockdown(60)
			else if(dist <= 3)
				L.adjustFireLoss(60)
				L.adjustBruteLoss(40)
				L.Knockdown(60)
			else
				L.adjustFireLoss(20)


	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire)
	

	for(var/turf/open/OT in range(2, T))
		if(prob(40) && isopenturf(OT))
			new /obj/effect/hotspot(OT)

	qdel(src)
