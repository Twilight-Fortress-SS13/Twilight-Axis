
/obj/effect/proc_holder/spell/invoked/projectile/northern_spike
	name = "Northern Spike"
	desc = "Выпускает ледяной пик, который пронзает врага и пригвождает его к стене, используя магический лед."
	cost = 5
	projectile_type = /obj/projectile/magic/northern_spike
	overlay_state = "ice_spear"
	sound = list('sound/magic/abyssor_splash.ogg')
	releasedrain = SPELLCOST_MAJOR_PROJECTILE
	chargetime = 15
	recharge_time = 20 SECONDS
	spell_tier = 3
	invocations = list("Septentrio!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "northern_spike"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/projectile/northern_spike/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FIREFROST, src)
	var/success = ..()
	warlock_spell_post_cast(user, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FIREFROST, success, context)
	return success

/obj/projectile/magic/northern_spike
	name = "northern spike"
	icon_state = "chronobolt"
	damage = 30
	damage_type = BRUTE
	speed = 0.8
	range = 15
	nodamage = FALSE
	flag = "magic"
	guard_deflectable = TRUE
	var/mob/living/pinned_mob = null
	var/tmp/damage_mult = 1

/obj/projectile/magic/northern_spike/Initialize()
	. = ..()
	if(isliving(firer))
		var/list/context = warlock_spell_pre_cast(firer, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FIREFROST, src)
		damage_mult = warlock_get_damage_mult(context)

/obj/projectile/magic/northern_spike/on_hit(target, blocked = FALSE)
	var/mob/living/L = target
	if(ismob(target) && !pinned_mob)
		if(L.anti_magic_check())
			return BULLET_ACT_BLOCK

		pinned_mob = L
		L.apply_status_effect(/datum/status_effect/buff/frostbite)
		L.visible_message(span_danger("[src] пронзает [L] и утаскивает за собой!"))
		
		L.Stun(1 SECONDS)
		
		temporary_unstoppable_movement = TRUE
		movement_type |= UNSTOPPABLE 
		return BULLET_ACT_FORCE_PIERCE
	
	return ..()

/obj/projectile/magic/northern_spike/Range()
	if(QDELETED(src)) 
		return

	..()

	if(pinned_mob)

		if(pinned_mob.stat == DEAD || QDELETED(pinned_mob))
			pinned_mob = null
			return
		
		var/turf/T = get_turf(src)
		if(T)
			pinned_mob.forceMove(T)
		else

			pinned_mob = null


/obj/projectile/magic/northern_spike/Destroy()
	pinned_mob = null
	return ..()

/obj/projectile/magic/northern_spike/Bump(atom/A)
	if(QDELETED(src) || !trajectory) 
		return FALSE
	
	if(pinned_mob && (iswallturf(A) || (isobj(A) && A.density)))
		var/turf/T = get_turf(src)
		if(!T)
			pinned_mob = null
			qdel(src)
			return FALSE
			
		var/obj/structure/northern_spike_ice/NS = new /obj/structure/northern_spike_ice(T, src.dir)
		
		pinned_mob.SetKnockdown(0)
		pinned_mob.SetParalyzed(0)
		pinned_mob.SetImmobilized(0)
		pinned_mob.set_resting(FALSE, TRUE)
		pinned_mob.forceMove(T)
		
		if(NS.buckle_mob(pinned_mob, force=TRUE))
			pinned_mob.visible_message(span_userdanger("[pinned_mob] прибит к [A.name]!"))
			playsound(T, 'sound/combat/hits/pick/genpick (1).ogg', 100, TRUE)
		
		arcyne_strike(firer, pinned_mob, null, round(25 * damage_mult), BODY_ZONE_CHEST, BCLASS_STAB, spell_name = "Northern Spike", skip_animation = TRUE, skip_message = TRUE)
		pinned_mob = null
		qdel(src)
		return TRUE
	return ..()


/obj/structure/northern_spike_ice
	name = "ice spike"
	desc = "Массивный ледяной шип, пригвоздивший жертву. Нужно время, чтобы вырваться из его хватки."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "chronobolt"
	anchored = TRUE
	density = FALSE
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0 
	buckleverb = "impale"
	pixel_y = 10 
	layer = ABOVE_MOB_LAYER 
	
	var/duration = 12 SECONDS
	var/unbuckle_delay = 5 SECONDS

/obj/structure/northern_spike_ice/Initialize(mapload, new_dir)
	. = ..()
	if(new_dir)
		setDir(new_dir)
	
	var/matrix/M = matrix()
	
	switch(dir)
		if(NORTH)
			pixel_y = 14
		if(SOUTH)
			M.Turn(180)
			pixel_y = -14
		if(EAST)
			M.Turn(90)
			pixel_x = 14
		if(WEST)
			M.Turn(-90)
			pixel_x = -14
	transform = M
	QDEL_IN(src, duration)

/obj/structure/northern_spike_ice/post_buckle_mob(mob/living/M)
	. = ..()
	M.set_mob_offsets("spike_pin", _x = src.pixel_x, _y = src.pixel_y)
	
	M.set_resting(FALSE, TRUE)
	M.setDir(REVERSE_DIR(src.dir)) 
	M.update_mobility()

/obj/structure/northern_spike_ice/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("spike_pin")

/obj/structure/northern_spike_ice/Destroy()
	unbuckle_all_mobs(force=TRUE) 
	return ..()

/obj/structure/northern_spike_ice/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(!buckled_mob || !user) return
	if(user == buckled_mob)
		if(do_after(user, unbuckle_delay, target = src))
			return ..()
	else
		if(do_after(user, unbuckle_delay * 0.5, target = src))
			return ..()
	return FALSE
